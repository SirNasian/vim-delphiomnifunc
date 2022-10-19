unit ClassB;

interface

type
	TClassB = class
	private
		FChild: TClassC;
		FBooleanValue: boolean;
		FIntegerValue: integer;
		function GetBooleanValue(): boolean;
		function GetIntegerValue(): integer;
		procedure SetBooleanValue(const aValue: boolean);
		procedure SetIntegerValue(const aValue: integer);
	public
		property IntegerValue: integer read GetIntegerValue write SetIntegerValue;
		property BooleanValue: boolean read GetBooleanValue write SetBooleanValue;
	end;

implementation

{ TClassB }

function TClassB.GetBooleanValue(): boolean;
begin
	result := self.FBooleanValue;
end;

function TClassB.GetIntegerValue(): integer;
begin
	result := self.FIntegerValue;
end;

procedure TClassB.SetBooleanValue(const aValue: boolean);
begin
	self.FBooleanValue := aValue;
end;

procedure TClassB.SetIntegerValue(const aValue: integer);
begin
	self.FIntegerValue := aValue;
end;

end.
