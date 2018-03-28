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
begin
  FlagNumber1 := StrToInt(Copy(Self.Numero, 1, 1));
  ///
  If FlagNumber1 in [3, 5] then 
    FlagNumber2 := StrToInt(Copy(Self.Numero, 1, 2))
  Else If FlagNumber1 = 6 then 
    FlagNumber2 := StrToInt(Copy(Self.Numero, 1, 4))
  Else 
    FlagNumber2 := FlagNumber1; 
  //
  case FlagNumber2 of
    4      : Self.Bandeira := 'Visa';
    34     : Self.Bandeira := 'AMEX';
    37     : Self.Bandeira := 'AMEX';
    51..55 : Self.Bandeira := 'MasterCard';
    6011   : Self.Bandeira := 'Discover';
    Else     Self.Bandeira := 'All';
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
  case Self.ValidationType of
    0: CheckLUHNAcbr(Self);
    1: Self.Ok := CheckLUHN(oCartaoCredito.Numero);
    2: CheckLUHNDLL(Self);
  end;
end;

end.
