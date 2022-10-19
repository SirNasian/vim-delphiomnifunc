unit ClassA;

interface

type
	TClassA = class
	private
		FChild: TClassB;
		FStringValue: string;
		function GetStringValue(): string;
		procedure SetStringValue(const aValue: string);
	public
		property StringValue: string read GetStringValue write SetStringValue;
	end;

implementation

{ TClassA }

function TClassA.GetStringValue(): string;
begin
	result := self.FStringValue;
end;

procedure TClassA.SetStringValue(const aValue: string);
begin
	self.FStringValue := aValue;
end;

end.
