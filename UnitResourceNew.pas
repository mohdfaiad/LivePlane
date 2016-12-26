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
    EditName: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    EditMeasure: TEdit;
    EditStartValue: TEdit;
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
  EditName.Text := '';
  EditMeasure.Text := '';
  EditStartValue.Text := '';
end;

procedure TFormResourceNew.ConfigButtonClick(Sender: TObject);
var
  MaxIndex: Integer;
begin
{$IFDEF ANDROID}
  FDConnection.Params.Values['Database'] := '$(DOC)/database.sqlite';
{$ELSE}
  FDConnection.Params.Values['Database'] := ExtractFilePath(ParamStr(0)) +
    'assets\internal\database.sqlite';
{$ENDIF}
  FDConnection.DriverName := 'SQLite';
  FDConnection.Connected := True;
  FDQuery.Active := True;
  // Получаем максимальный ID
  FDQuery.Open('SELECT MAX(ID) AS ''MAXID'' FROM RESOURCE');
  if FDQuery.FieldByName('MAXID').IsNull then
    MaxIndex := 0
  else
    MaxIndex := FDQuery.FieldByName('MAXID').AsInteger;
  FDQuery.Close;
  // Записываем
  FDQuery.SQL.Text := 'INSERT INTO RESOURCE VALUES (:rid, :name, :measure)';
  FDQuery.ParamByName('rid').DataType := TFieldType.ftInteger;
  FDQuery.ParamByName('rid').AsInteger := MaxIndex + 1;
  FDQuery.ParamByName('name').DataType := TFieldType.ftString;
  FDQuery.ParamByName('name').AsString := EditName.Text;
  FDQuery.ParamByName('measure').DataType := TFieldType.ftString;
  FDQuery.ParamByName('measure').AsString := EditMeasure.Text;
  if not FDQuery.Prepared then
    FDQuery.Prepare;
  FDQuery.ExecSQL();
  FDQuery.Close;
  FDQuery.Active := False;
  FDConnection.Connected := False;
  Close;
end;

end.
