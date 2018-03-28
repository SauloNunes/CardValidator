library ValidaCartaoDLL;

uses
  SysUtils,
  Classes;

{$R *.res}

function CheckLUHN(S:String):Boolean;
Var
 i,F,V,Sum:integer;
begin
 Result:=False;
 F:=1;
 Sum:=0;
 for i:=Length(S) downto 1 do
  begin
   if Not (S[i] In ['0'..'9']) Then Exit;
   V:=F*(Ord(S[i])-Ord('0'));
   if V>9 Then V:=(V Mod 10)+1;
   Sum:=Sum+V;
   F:=3-F;
  end;
 Result:=(Sum Mod 10)=0;
end;

exports
  CheckLUHN;
begin

end.


