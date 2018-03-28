program ValidaCartaoApp;

uses
  Vcl.Forms,
  untMain in 'untMain.pas' {frmMain},
  CartaoCredito in 'CartaoCredito.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
