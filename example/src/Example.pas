unit Example;

interface

procedure Example();

implementation

procedure Example();
var
	// You can navigate to the definition of these classes by moving the
	// cursor over the class name and pressing `ctrl-]` in normal mode!
	ObjectA: TClassA;
	ObjectB: TClassB;
	ObjectC: TClassC;
begin
	// Invoke completion with `ctrl-x ctrl-o` while in insert mode!
	ObjectA.
	ObjectB.
	ObjectC.
	// It can even handle chaining!
	ObjectA.FChild.
	ObjectA.FChild.FChild.
end;

end.
