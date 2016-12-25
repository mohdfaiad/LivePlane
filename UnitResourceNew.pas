unit UnitResourceNew;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Layouts, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Comp.DataSet;

type
  TFormResourceNew = class(TForm)
    MainLayout: TLayout;
    ToolBar: TToolBar;
    ToolLabel: TLabel;
    MasterButton: TSpeedButton;
    ConfigButton: TSpeedButton;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Label3: TLabel;
    FDQuery: TFDQuery;
    FDConnection: TFDConnection;
    procedure ConfigButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Clear;
  end;

var
  FormResourceNew: TFormResourceNew;

implementation

{$R *.fmx}
{ TFormResourceNew }

procedure TFormResourceNew.Clear;
// Очищает данные в полях ввода формы
begin

end;

procedure TFormResourceNew.ConfigButtonClick(Sender: TObject);
begin
{$IFDEF ANDROID}
  FDConnection.Params.Values['Database'] := '$(DOC)/database.sqlite';
{$ENDIF}
  FDConnection.Connected := True;
  FDQuery.SQL.Text := 'INSERT INTO RESOURCE VALUES (1, ''111'', ''222'', ''333'')';
  Close;
end;

end.
