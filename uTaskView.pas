unit uTaskView;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.WebBrowser, FMX.Controls.Presentation, FMX.Layouts;

type
  TFormTaskView = class(TForm)
    LayoutMain: TLayout;
    ToolBar: TToolBar;
    ToolLabel: TLabel;
    MasterButton: TSpeedButton;
    ConfigButton: TSpeedButton;
    Panel: TPanel;
    LabelTaskName: TLabel;
    LabelTaskDetail: TLabel;
    WebBrowser: TWebBrowser;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Clear;
  end;

var
  FormTaskView: TFormTaskView;

implementation

{$R *.fmx}
{ TFormTargetView }

procedure TFormTaskView.Clear;
begin
  // Пока ни чего
end;

end.
