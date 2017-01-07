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
  FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Comp.DataSet,
  FMX.ListBox;

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
    Label4: TLabel;
    EditDetail: TEdit;
    Label5: TLabel;
    ListBox: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    procedure ConfigButtonClick(Sender: TObject);
    procedure ListBoxItemClick(const Sender: TCustomListBox; const Item: TListBoxItem);
    procedure ListBoxChangeCheck(Sender: TObject);
    procedure MasterButtonClick(Sender: TObject);
  private
    { Private declarations }
    LastImageIndex: Integer;
  public
    procedure Clear;
  end;

var
  FormResourceNew: TFormResourceNew;

implementation

uses
  Main, UnitResource;

{$R *.fmx}
{ TFormResourceNew }

procedure TFormResourceNew.Clear;
// Очищает данные в полях ввода формы
var
  I: Integer;
begin
  LastImageIndex := 0;
  for I := 0 to ComponentCount - 1 do
    if (Components[I] is TListBoxItem) then
      TListBoxItem(Components[I]).IsChecked := False;
  EditName.Text := '';
  EditMeasure.Text := '';
  EditStartValue.Text := '';
end;

procedure TFormResourceNew.ConfigButtonClick(Sender: TObject);
var
  MaxIndex: Integer;
begin
  if EditName.Text = '' then
  begin
    ShowMessage('Нельзя создать ресурс с пустым именем...');
    Exit;
  end;
  if EditMeasure.Text = '' then
  begin
    ShowMessage('Нельзя создать ресурс без единицы измерения...');
    Exit;
  end;

  With MainForm do
  begin
    // Получаем максимальный ID
    MaxIndex := 0;
    try
      FDQuery.Open('SELECT MAX(ID) FROM RESOURCE');
      if not FDQuery.FieldList.Fields[0].IsNull then
        MaxIndex := FDQuery.FieldList.Fields[0].AsInteger;
    finally
      FDQuery.Close;
    end;
    // Записываем
    try
      FDQuery.SQL.Text :=
        'INSERT INTO RESOURCE VALUES (:rid, :name, :measure, :startvalue, :detail, :icon)';
      FDQuery.ParamByName('rid').DataType := TFieldType.ftInteger;
      FDQuery.ParamByName('rid').AsInteger := MaxIndex + 1;
      FDQuery.ParamByName('name').DataType := TFieldType.ftString;
      FDQuery.ParamByName('name').AsString := EditName.Text;
      FDQuery.ParamByName('startvalue').DataType := TFieldType.ftInteger;
      FDQuery.ParamByName('startvalue').AsInteger := StrToInt(EditStartValue.Text);
      FDQuery.ParamByName('measure').DataType := TFieldType.ftString;
      FDQuery.ParamByName('measure').AsString := EditMeasure.Text;
      FDQuery.ParamByName('detail').DataType := TFieldType.ftString;
      FDQuery.ParamByName('detail').AsString := EditDetail.Text;
      FDQuery.ParamByName('icon').DataType := TFieldType.ftInteger;
      FDQuery.ParamByName('icon').AsInteger := LastImageIndex;
      if not FDQuery.Prepared then
        FDQuery.Prepare;
      FDQuery.ExecSQL();
    finally
      FDQuery.Close;
    end;
  end;
  FormResource.Update;
  Close;
end;

procedure TFormResourceNew.ListBoxChangeCheck(Sender: TObject);
begin
  if Sender is TListBoxItem then
    LastImageIndex := TListBoxItem(Sender).ImageIndex;
end;

procedure TFormResourceNew.ListBoxItemClick(const Sender: TCustomListBox; const Item: TListBoxItem);
var
  I: Integer;
begin
  for I := 0 to ComponentCount - 1 do
    if (Components[I] is TListBoxItem) and (TListBoxItem(Components[I]) <> Item) then
      TListBoxItem(Components[I]).IsChecked := False;
  Item.IsChecked := True;
end;

procedure TFormResourceNew.MasterButtonClick(Sender: TObject);
begin
  Close;
end;

end.
