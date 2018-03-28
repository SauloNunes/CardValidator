unit untMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.Imaging.jpeg, Vcl.ExtCtrls, ACBrBase, ACBrValidador, CartaoCredito;

type
  TfrmMain = class(TForm)
    edtNro: TEdit;
    btValidar: TButton;
    imgBandeira: TImage;
    sbCartao: TStatusBar;
    rgForma: TRadioGroup;
    procedure btValidarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtNroKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    //Diretorio : string;
  public
    { Public declarations }
    oCartaoCredito : TCartaoCredito;
  end;

var
  frmMain: TfrmMain;

implementation

uses StrUtils;

{$R *.dfm}

{ TForm1 }

procedure TfrmMain.btValidarClick(Sender: TObject);
begin
  try
    oCartaoCredito.Numero := edtNro.Text;
    oCartaoCredito.ValidationType := rgForma.ItemIndex;
    oCartaoCredito.ValidateCreditCard(oCartaoCredito);
    //
    if oCartaoCredito.Ok then
      sbCartao.Panels[0].Text := 'VÁLIDO'
    Else
      sbCartao.Panels[0].Text := 'INVÁLIDO';
    //
    case AnsiIndexStr(UpperCase(oCartaoCredito.Bandeira), ['ALL', 'AMEX','MASTERCARD', 'VISA', 'DISCOVER']) of
     0  : imgBandeira.Picture.LoadFromFile(oCartaoCredito.Directory+'Resources\Images\All.jpg');
     1  : imgBandeira.Picture.LoadFromFile(oCartaoCredito.Directory+'Resources\Images\AMEX.jpg');
     2  : imgBandeira.Picture.LoadFromFile(oCartaoCredito.Directory+'Resources\Images\MasterCard.jpg');
     3  : imgBandeira.Picture.LoadFromFile(oCartaoCredito.Directory+'Resources\Images\VISA.jpg');
     4  : imgBandeira.Picture.LoadFromFile(oCartaoCredito.Directory+'Resources\Images\Discover.jpg');
    end;
  except
    on E : Exception do
      sbCartao.Panels[0].Text := E.Message;
  end;
end;

procedure TfrmMain.edtNroKeyPress(Sender: TObject; var Key: Char);
begin
  if not ( Key in['0'..'9', #32, #8] ) then
    Key := #0;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  oCartaoCredito := TCartaoCredito.Create;
  //
  imgBandeira.Picture.LoadFromFile(oCartaoCredito.Directory+'Resources\Images\All.jpg');
  rgForma.ItemIndex := oCartaoCredito.ValidationType;
  sbCartao.Panels[0].Text := 'VÁLIDO / INVÁLIDO';
  edtNro.SetFocus;
end;

end.
