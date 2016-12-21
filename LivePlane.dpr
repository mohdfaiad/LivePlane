program LivePlane;

uses
  System.StartUpCopy,
  FMX.Forms,
  Main in 'Main.pas' {MainForm},
  Engine in 'Engine.pas',
  UnitTarget in 'UnitTarget.pas' {FormTarget},
  UnitWhatNext in 'UnitWhatNext.pas' {FormWhatNext};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TFormTarget, FormTarget);
  Application.CreateForm(TFormWhatNext, FormWhatNext);
  Application.Run;
end.
