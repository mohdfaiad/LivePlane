program LivePlane;

uses
  System.StartUpCopy,
  FMX.Forms,
  Main in 'Main.pas' {MainForm},
  Engine in 'Engine.pas',
  UnitTarget in 'UnitTarget.pas' {FormTarget},
  UnitWhatNext in 'UnitWhatNext.pas' {FormWhatNext},
  UnitResource in 'UnitResource.pas' {FormResource},
  UnitResourceNew in 'UnitResourceNew.pas' {FormResourceNew};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TFormTarget, FormTarget);
  Application.CreateForm(TFormWhatNext, FormWhatNext);
  Application.CreateForm(TFormResource, FormResource);
  Application.CreateForm(TFormResourceNew, FormResourceNew);
  Application.Run;
end.
