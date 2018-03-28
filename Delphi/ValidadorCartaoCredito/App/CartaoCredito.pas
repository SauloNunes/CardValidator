unit CartaoCredito;

interface

type
  TCartaoCredito = class
  private
    // Atributos da Classe
    FBandeira       : string;
    FNumero         : string;
    FOk             : Boolean;
    FValidationType : Integer;
    FDirectory      : string;
    
  protected
    function CheckLUHN(S: String): Boolean;
    
  public
    // Métodos Públicos da Classe
    constructor Create;
    procedure CheckFlag(const oCartaoCredito: TCartaoCredito);
    procedure CheckLUHNDLL(const oCartaoCredito: TCartaoCredito);
    procedure CheckLUHNAcbr(const oCartaoCredito: TCartaoCredito);    
    procedure ValidateCreditCard(const oCartaoCredito: TCartaoCredito);

    // Propriedades da Classe
    property Bandeira       : string  read FBandeira       write FBandeira;
    property Numero         : string  read FNumero         write FNumero;
    property Ok             : Boolean read FOk             write FOk;
    property ValidationType : Integer read FValidationType write FValidationType;
    property Directory      : string  read FDirectory      write FDirectory;
    
  end;

  TCheckLUHN = function(S: String): Boolean;

implementation

uses System.SysUtils, Vcl.Forms, Winapi.Windows, ACBrValidador;

{ TCartaoCredito }

procedure TCartaoCredito.CheckFlag(const oCartaoCredito: TCartaoCredito);
Var
  FlagNumber1, FlagNumber2 : Integer;
  newStr : string;
begin
  newStr := StringReplace(Self.Numero, ' ', '', [rfReplaceAll]);
  FlagNumber1 := StrToInt(Copy(newStr, 1, 1));
  //
  If FlagNumber1 in [3, 5] then
    FlagNumber2 := StrToInt(Copy(newStr, 1, 2))
  Else If FlagNumber1 = 6 then
    FlagNumber2 := StrToInt(Copy(newStr, 1, 4))
  Else 
    FlagNumber2 := FlagNumber1;
  //
  case FlagNumber2 of
    4      :
      Begin
        if (length(newStr) = 13) Or (length(newStr) = 16) then
        Begin
          Self.Ok := True;
          Self.Bandeira := 'VISA';
        End
        Else
        Begin
          Self.Bandeira := 'ALL';
          Self.Ok := False;
        End;
      End;
    34     :
      Begin
        if length(newStr) = 15 then
        Begin
          Self.Ok := True;
          Self.Bandeira := 'AMEX';
        End
        Else
        Begin
          Self.Bandeira := 'ALL';
          Self.Ok := False;
        End;
      End;
    37     :
      Begin
        if length(newStr) = 15 then
        Begin
          Self.Ok := True;
          Self.Bandeira := 'AMEX';
        End
        Else
        Begin
          Self.Bandeira := 'ALL';
          Self.Ok := False;
        End;
      End;
    51..55 :
      Begin
        if length(newStr) = 16 then
        Begin
          Self.Ok := True;
          Self.Bandeira := 'MASTERCARD';
        End
        Else
        Begin
          Self.Bandeira := 'ALL';
          Self.Ok := False;
        End;
      End;
    6011   :
      Begin
        if length(newStr) = 16 then
        Begin
          Self.Ok := True;
          Self.Bandeira := 'DISCOVER';
        End
        Else
        Begin
          Self.Bandeira := 'ALL';
          Self.Ok := False;
        End;
      End
    Else
      Begin
        Self.Bandeira := 'All';
        Self.Ok       := False;
      End;
  end;
end;

function TCartaoCredito.CheckLUHN(S: String): Boolean;
Var
  i, F, V, Sum: Integer;
begin
  Result := False;
  F := 1;
  Sum := 0;
  for i := Length(S) downto 1 do
  begin
    if Not(S[i] In ['0' .. '9']) Then
      Exit;
    V := F * (Ord(S[i]) - Ord('0'));
    if V > 9 Then
      V := (V Mod 10) + 1;
    Sum := Sum + V;
    F := 3 - F;
  end;
  Result := (Sum Mod 10) = 0;
end;

procedure TCartaoCredito.CheckLUHNAcbr(const oCartaoCredito: TCartaoCredito);
Var
  ACBrValidador: TACBrValidador;
begin
  ACBrValidador := TACBrValidador.Create(nil);
  //
  ACBrValidador.TipoDocto := docCartaoCredito;
  ACBrValidador.Documento := Self.Numero;
  //
  Self.Ok :=  ACBrValidador.Validar;
  //
  FreeAndNil(ACBrValidador);
end;

procedure TCartaoCredito.CheckLUHNDLL(const oCartaoCredito: TCartaoCredito);
Var
  T: string;
  Handle: THandle;
  mCheckLUHN: TCheckLUHN;
  DLLDir: string;
  wideChars: array [0 .. 100] of WideChar;
begin
  T := stringReplace(Self.Numero, ' ', '', [rfReplaceAll]);
  DLLDir := Self.Directory + 'Resources\Bin\ValidaCartaoDLL.dll';
  StringToWideChar(DLLDir, wideChars, 100);
  //
  Handle := LoadLibrary(wideChars);
  if Handle <> 0 then
    mCheckLUHN := GetProcAddress(Handle, 'CheckLUHN');
  //
  Self.Ok := mCheckLUHN(T);
  //
  FreeLibrary(Handle);
end;

constructor TCartaoCredito.Create;
begin
  FBandeira := 'All';
  FNumero := '';
  FOk := False;
  FValidationType := 1;
  FDirectory := ExtractFilePath(Application.ExeName);
end;

procedure TCartaoCredito.ValidateCreditCard(const oCartaoCredito
  : TCartaoCredito);
begin
  Self.CheckFlag(Self);
  //
  if Self.Ok then
    case Self.ValidationType of
      0: CheckLUHNAcbr(Self);
      1: Self.Ok := CheckLUHN(oCartaoCredito.Numero);
      2: CheckLUHNDLL(Self);
    end;
end;

end.
