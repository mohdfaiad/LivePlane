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
  TMode = (mCreate { �������� ������ } , mEdit { �������������� } );

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
    procedure MasterButtonClick(Sender: TObject);
    procedure ListBoxChangeCheck(Sender: TObject);
  private
    { Private declarations }
    fSelectedID: Integer;
    Mode: TMode;
    procedure CreateRecord;
    procedure UpdateRecord;
    function GetIconIndex: Integer;
  public
    procedure Clear;
    procedure EditMode(AID: Integer);
    procedure CreateMode;
  end;

var
  FormResourceNew: TFormResourceNew;
  CheckCrit: Boolean = false;

implementation

uses
  Main, UnitResource;

{$R *.fmx}
{ TFormResourceNew }

procedure TFormResourceNew.Clear;
// ������� ������ � ����� ����� �����
var
  I: Integer;
begin
  for I := 0 to ComponentCount - 1 do
    if (Components[I] is TListBoxItem) then
      TListBoxItem(Components[I]).IsChecked := false;
  EditName.Text := '';
  EditMeasure.Text := '';
  EditStartValue.Text := '';
end;

procedure TFormResourceNew.ConfigButtonClick(Sender: TObject);
// ������ ��� ��������� ������ � ��
begin
  if Mode = mCreate then
    CreateRecord
  else if Mode = mEdit then
    UpdateRecord;
end;

procedure TFormResourceNew.CreateMode;
// ����� ��������
begin
  ToolLabel.Text := '���������� ������ �������';
  Mode := mCreate;
  ConfigButton.StyleLookup := 'additembutton';
  fSelectedID := INVALID_HANDLE_VALUE;
end;

procedure TFormResourceNew.CreateRecord;
// �������� ������
var
  MaxIndex: Integer;
begin
  if EditName.Text = '' then
  begin
    ShowMessage('������ ������� ������ � ������ ������...');
    Exit;
  end;
  if EditMeasure.Text = '' then
  begin
    ShowMessage('������ ������� ������ ��� ������� ���������...');
    Exit;
  end;

  With MainForm do
  begin
    // �������� ������������ ID
    MaxIndex := 0;
    try
      FDQuery.Open('SELECT MAX(ID) FROM RESOURCE');
      if not FDQuery.FieldList.Fields[0].IsNull then
        MaxIndex := FDQuery.FieldList.Fields[0].AsInteger;
    finally
      FDQuery.Close;
    end;
    // ����������
    try
      FDQuery.SQL.Text := 'INSERT INTO RESOURCE VALUES (:rid, :name, :measure, :detail, :startvalue, :icon)';
      FDQuery.ParamByName('rid').DataType := TFieldType.ftInteger;
      FDQuery.ParamByName('rid').AsInteger := MaxIndex + 1;
      FDQuery.ParamByName('name').DataType := TFieldType.ftString;
      FDQuery.ParamByName('name').AsString := EditName.Text;
      FDQuery.ParamByName('measure').DataType := TFieldType.ftString;
      FDQuery.ParamByName('measure').AsString := EditMeasure.Text;
      FDQuery.ParamByName('detail').DataType := TFieldType.ftString;
      FDQuery.ParamByName('detail').AsString := EditDetail.Text;
      FDQuery.ParamByName('startvalue').DataType := TFieldType.ftInteger;
      FDQuery.ParamByName('startvalue').AsInteger := StrToInt(EditStartValue.Text);
      FDQuery.ParamByName('icon').DataType := TFieldType.ftInteger;
      FDQuery.ParamByName('icon').AsInteger := GetIconIndex;
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

procedure TFormResourceNew.EditMode(AID: Integer);
// ����� ��������������
begin
  ToolLabel.Text := '�������������� �������';
  Mode := mEdit;
  ConfigButton.StyleLookup := 'composetoolbutton';
  fSelectedID := AID;
end;

function TFormResourceNew.GetIconIndex: Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to ListBox.Count - 1 do
    if ListBox.ItemByIndex(I).IsChecked then
      Exit(I);
end;

procedure TFormResourceNew.ListBoxChangeCheck(Sender: TObject);
var
  I, ItemIndex: Integer;
begin
  if CheckCrit then
    Exit;
  CheckCrit := True;
  ItemIndex := ListBox.ItemIndex;

  for I := 0 to ListBox.Count - 1 do
    ListBox.ListItems[I].IsChecked := false;

  ListBox.ListItems[ItemIndex].IsChecked := True;
  CheckCrit := false;
end;

procedure TFormResourceNew.ListBoxItemClick(const Sender: TCustomListBox; const Item: TListBoxItem);
var
  I: Integer;
begin
  for I := 0 to ComponentCount - 1 do
    if (Components[I] is TListBoxItem) and (TListBoxItem(Components[I]) <> Item) then
      TListBoxItem(Components[I]).IsChecked := false;
  Item.IsChecked := True;
end;

procedure TFormResourceNew.MasterButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TFormResourceNew.UpdateRecord;
// ���������� ������
var
  MaxIndex: Integer;
begin
  if EditName.Text = '' then
  begin
    ShowMessage('������ ������� ��� �������...');
    Exit;
  end;
  if EditMeasure.Text = '' then
  begin
    ShowMessage('������ ������� ������� ��������� �������...');
    Exit;
  end;

  With MainForm do
  begin
    // �������� ������������ ID
    MaxIndex := 0;
    try
      FDQuery.Open('SELECT MAX(ID) FROM RESOURCE');
      if not FDQuery.FieldList.Fields[0].IsNull then
        MaxIndex := FDQuery.FieldList.Fields[0].AsInteger;
    finally
      FDQuery.Close;
    end;
    // ����������
    try
      FDQuery.SQL.Text := 'UPDATE RESOURCE SET NAME = :aname, MEASURE = :ameasure, DETAIL = :adetail,' +
        'STARTVALUE = :astartvalue, ICON = :aicon WHERE ID = :aid';

      FDQuery.ParamByName('aname').DataType := TFieldType.ftString;
      FDQuery.ParamByName('aname').AsString := EditName.Text;
      FDQuery.ParamByName('ameasure').DataType := TFieldType.ftString;
      FDQuery.ParamByName('ameasure').AsString := EditMeasure.Text;
      FDQuery.ParamByName('adetail').DataType := TFieldType.ftString;
      FDQuery.ParamByName('adetail').AsString := EditDetail.Text;
      FDQuery.ParamByName('astartvalue').DataType := TFieldType.ftInteger;
      FDQuery.ParamByName('astartvalue').AsInteger := StrToInt(EditStartValue.Text);
      FDQuery.ParamByName('aicon').DataType := TFieldType.ftInteger;
      FDQuery.ParamByName('aicon').AsInteger := GetIconIndex;
      FDQuery.ParamByName('aid').DataType := TFieldType.ftInteger;
      FDQuery.ParamByName('aid').AsInteger := fSelectedID;
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

end.
