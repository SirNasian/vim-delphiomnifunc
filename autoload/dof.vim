function! dof#GetClassFile(tag)
	for item in taglist('\<'.a:tag.'\>')
		if (index(['c', 'r'], item.kind) > -1)
			return item.filename
		endif
	endfor
	return ''
endfunction

function! dof#GetClassMembers(tag)
	let members = []
	let reading_class = 0
	let filename = dof#GetClassFile(a:tag)
	if (strlen(filename))
		for line in readfile(filename)
			if (line =~ '\<'.a:tag.'\>')
				let reading_class = 1
			endif
			if (reading_class)
				if (line =~ '\<end;')
					break
				endif
				let field     = trim(matchstr(line, '^\s*\w\+\s*:\s*\w\+\s*;'))
				let function  = trim(matchstr(line, '^\s*function\s*\w\+\((.*)\)\?\s*:\s*\w\+\s*;'))
				let procedure = trim(matchstr(line, '^\s*procedure\s*\w\+\((.*)\)\?\s*;'))
				let property  = trim(matchstr(line, '^\s*property\s*\w\+\s*:\s*\w\+'))
				if (strlen(field))
					let name = substitute(field, '^\s*\(\w\+\)\s*:\s*\w\+;', '\1', '')
					let type = substitute(field, '^\s*\w\+\s*:\s*\(\w\+\);', '\1', '')
					call add(members, {'name': name, 'type': type, 'context': type})
				elseif (strlen(function))
					let name    = substitute(function, '^\s*function\s*\(\w\+\)\((.*)\)\?\s*:\s*\w\+\s*;', '\1', '')
					let type    = substitute(function, '^\s*function\s*\w\+\((.*)\)\?\s*:\s*\(\w\+\)\s*;', '\2', '')
					let context = substitute(function, '^\s*function\s*\w\+\((\(.*\))\)\?\s*:\s*\(\w\+\)\s*;', 'function(\2): \3', '')
					call add(members, {'name': name, 'type': type, 'context': context})
				elseif (strlen(procedure))
					let name    = substitute(procedure, '^\s*procedure\s*\(\w\+\)\((.*)\)\?\s*;', '\1', '')
					let type    = 'procedure'
					let context = substitute(procedure, '^\s*procedure\s*\w\+\((\(.*\))\)\?\s*;', 'procedure(\2)', '')
					call add(members, {'name': name, 'type': type, 'context': context})
				elseif (strlen(property))
					let name    = substitute(property, '^\s*property\s*\(\w\+\)\s*:\s*\w\+', '\1', '')
					let type    = substitute(property, '^\s*property\s*\w\+\s*:\s*\(\w\+\)', '\1', '')
					let context = type . ' (property)'
					call add(members, {'name': name, 'type': type, 'context': context})
				endif
			endif
		endfor
	endif
	return members
endfunction

function! dof#GetMatchingBracketChar(char)
	let mapping = {'(': ')', ')': '(', '[': ']', ']': '[', '<': '>', '>': '<'}
	return get(mapping, a:char, '')
endfunction

function! dof#GetTokenStack()
	let index = col('.') - 1
	let line  = getline('.')
	let token = ''
	let build_stack = 0
	let token_stack = []
	let in_bracket  = []
	while ((index > 0) && (line[index-1] !~ '[ \t;]'))
		if (index([')', ']', '>'], line[index-1]) > -1)
			call add(in_bracket, dof#GetMatchingBracketChar(line[index-1]))
		elseif (index(['(', '[', '<'], line[index-1]) > -1)
			if (empty(in_bracket))
				break
			else
				call remove(in_bracket, dof#GetMatchingBracketChar(line[index-1]))
			endif
		endif
		if (empty(in_bracket))
			if ((line[index-1] == '.'))
				call add(token_stack, matchstr(token, '\w\+'))
				let build_stack = 1
				let token = ''
			elseif (build_stack)
				let token = line[index-1] . token
			endif
		endif
		let index -= 1
	endwhile
	call add(token_stack, matchstr(token, '\w\+'))
	return filter(token_stack, {_, token -> token != ''})
endfunction

function! dof#GetDefinition(token)
	let line_number = line('.')
	while (line_number > 0)
		let line = matchstr(getline(line_number), '\<'.a:token.'\>\(,.*\)\?\s*:\s*\w\+')
		if (strlen(line))
			return substitute(line, '\c\<'.a:token.'\>\(,.*\)\?\s*:\s*\(\w\+\)', '\2', '')
		endif
		let line_number -= 1
	endwhile
	return ''
endfunction

function! dof#DelphiOmniFunc(findstart, base)
	if (a:findstart)
		let line  = getline('.')
		let index = col('.') - 1
		while ((index > 0) && (line[index-1] =~ '\w'))
			let index -= 1
		endwhile
		return index
	else
		let items = []
		let token_list = reverse(dof#GetTokenStack())
		if (!empty(token_list))
			let class = dof#GetDefinition(remove(token_list, 0))
			for token in token_list
				for member in dof#GetClassMembers(class)
					let class = ''
					if (member.name == token)
						let class = member.type
						break
					endif
				endfor
			endfor
			if (strlen(class))
				for member in dof#GetClassMembers(class)
					if (member.name =~ '^' . a:base)
						call add(items, {'word': member.name, 'menu': member.context})
					endif
				endfor
			endif
		endif
		return items
	endif
endfunction
