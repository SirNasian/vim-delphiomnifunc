unit ClassA;

interface

type
	TClassC = class
	private
		FChild: TClassA;
		FIntegerValue: integer;
		FStringValue: string;
		function GetIntegerValue(): integer;
		function GetStringValue(): string;
		procedure SetIntegerValue(const aValue: integer);
		procedure SetStringValue(const aValue: string);
	public
		property IntegerValue: integer read GetIntegerValue write SetIntegerValue;
		property StringValue: string read GetStringValue write SetStringValue;
	end;

implementation

{ TClassC }

function TClassC.GetIntegerValue(): integer;
begin
	result := self.FIntegerValue;
end;

function TClassC.GetStringValue(): string;
begin
	result := self.FStringValue;
end;

procedure TClassC.SetIntegerValue(const aValue: integer);
begin
	self.FIntegerValue := aValue;
end;

procedure TClassC.SetStringValue(const aValue: string);
begin
	self.FStringValue := aValue;
end;

end.
