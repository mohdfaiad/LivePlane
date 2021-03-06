program LivePlane;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'uMain.pas' {MainForm},
  Engine in 'Engine.pas',
  uTaskList in 'uTaskList.pas' {FormTaskList},
  uResourceList in 'uResourceList.pas' {FormResourceList},
  uResourceNew in 'uResourceNew.pas' {FormResourceNew},
  uTargetNew in 'uTargetNew.pas' {FormTargetNew},
  uTaskView in 'uTaskView.pas' {FormTaskView},
  MarkdownProcessor in 'markdown\source\MarkdownProcessor.pas',
  MarkdownDaringFireball in 'markdown\source\MarkdownDaringFireball.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TFormTaskList, FormTaskList);
  Application.CreateForm(TFormResourceList, FormResourceList);
  Application.CreateForm(TFormResourceNew, FormResourceNew);
  Application.CreateForm(TFormTargetNew, FormTargetNew);
  Application.CreateForm(TFormTaskView, FormTaskView);
  Application.Run;

end.
