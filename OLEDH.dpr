program OLEDH;

uses
  Vcl.Forms,
  uLFG3_Main in 'uLFG3_Main.pas' {frmLFG3Main};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmLFG3Main, frmLFG3Main);
  Application.Run;
end.
