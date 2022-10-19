# Delphi OmniFunc
I couldn't find a nice completion plugin to handle Delphi and/or Object Pascal, so I've decided to write my own.
There's nothing particularly fancy here, this plugin simply adds a completion function that is bound to `omnifunc`
for `*.pas` files.

## Dependencies
The only requirement for the completion function to work is a `tags` file that describes which source file each of the
classes/record exist in, so that it can quickly parse the definition of the given class/record.

`ctags` can be used to generate a `tags` file.
The following command should be enough to get you started:
```
ctags --langdef=Delphi --langmap=Delphi:.pas --regex-Delphi=/(\w+)\s*=\s*class/\1/c,class/ --regex-Delphi=/(\w+)\s*=\s*record/\1/r,record/ -R <<path_to_source_directory>>
```

If you're interested in having more symbols than just classes and records recognised by `ctags`, then you can use my
`.ctags` file, which I've left below:
```
--langdef=Delphi
--langmap=Delphi:.pas
--regex-Delphi=/(\w+)\s*=\s*class/\1/c,class/
--regex-Delphi=/(\w+)\s*=\s*record/\1/r,record/
--regex-Delphi=/(\w+)\s*=\s*\(/\1/e,enum/
--regex-Delphi=/function\s*(\w+)\s*[;\(]/\1/f,function/
--regex-Delphi=/function\s*\w+\.(\w+)\s*[;\(]/\1/f,function/
--regex-Delphi=/procedure\s*(\w+)\s*[;\(]/\1/p,procedure/
--regex-Delphi=/procedure\s*\w+\.(\w+)\s*[;\(]/\1/p,procedure/
```

Having these extra symbols won't improve the completion function (though it may make it slower since it has to go
through more symbols to find the relevant class/record), it's pretty handy for navigating code with `ctrl-]`, `:tag`,
and/or `:tselect` to jump directly to a tag.

## Usage
When in insert mode in a file with the `.pas` extension, `ctrl-x ctrl-o` can be used to invoke the completion function.

## Example
If you want to try this plugin, without having to generate a `tags` file, I have set up an example with a `tags` file
already in the `example` directory. If you open `example/src/Example.pas` in vim after installing this plugin, then you
should be able to invoke the completion function on the incomplete lines.

## Known Issues
- Generics are not handled.
- Multiline declarations are not handled.
