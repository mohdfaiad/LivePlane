program LivePlane;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'uMain.pas' {MainForm},
  Engine in 'Engine.pas',
  UTargetList in 'UTargetList.pas' {FormTarget},
  UWhatNext in 'UWhatNext.pas' {FormWhatNext},
  UResourceList in 'UResourceList.pas' {FormResource},
  UResourceNew in 'UResourceNew.pas' {FormResourceNew},
  UTargetNew in 'UTargetNew.pas' {TFormTargetNew},
  UTaskList in 'UTaskList.pas' {TFormTaskList};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TFormTarget, FormTarget);
  Application.CreateForm(TFormWhatNext, FormWhatNext);
  Application.CreateForm(TFormResource, FormResource);
  Application.CreateForm(TFormResourceNew, FormResourceNew);
  Application.CreateForm(TTFormTargetNew, TFormTargetNew);
  Application.CreateForm(TTFormTaskList, TFormTaskList);
  Application.Run;
end.
