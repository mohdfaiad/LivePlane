program LivePlane;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'uMain.pas' {MainForm},
  Engine in 'Engine.pas',
  uTargetList in 'uTargetList.pas' {FormTargetList},
  uResourceList in 'uResourceList.pas' {FormResourceList},
  uResourceNew in 'uResourceNew.pas' {FormResourceNew},
  uTargetNew in 'uTargetNew.pas' {TFormTargetNew},
  uTaskList in 'uTaskList.pas' {FormTaskList},
  uTargetView in 'uTargetView.pas' {FormTargetView};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TFormTargetList, FormTargetList);
  Application.CreateForm(TFormResourceList, FormResourceList);
  Application.CreateForm(TFormResourceNew, FormResourceNew);
  Application.CreateForm(TTFormTargetNew, TFormTargetNew);
  Application.CreateForm(TFormTaskList, FormTaskList);
  Application.CreateForm(TFormTargetView, FormTargetView);
  Application.Run;
end.
