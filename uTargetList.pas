unit uTargetList;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, IOUTils,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Ani,
  FMX.ListBox, FMX.Layouts, System.ImageList, FMX.ImgList, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.MultiView;

type
  TFormTargetList = class(TForm)
    LayoutMain: TLayout;
    ListBox: TListBox;
    ToolBar: TToolBar;
    ToolLabel: TLabel;
    MasterButton: TSpeedButton;
    ConfigButton: TSpeedButton;
    MultiViewPopup: TMultiView;
    ListBoxCommand: TListBox;
    ListBoxItemAdd: TListBoxItem;
    ListBoxItemSelected: TListBoxItem;
    ListBoxItemDelete: TListBoxItem;
    procedure MasterButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure OnClick(Sender: TObject);
  public
    { Public declarations }
    function AvaibleChild(TaskID: Integer = 0): Boolean;
    procedure Update(TaskID: Integer = 0);
  end;

var
  FormTargetList: TFormTargetList;

implementation

uses
  uMain, uTargetView;

{$R *.fmx}

function TFormTargetList.AvaibleChild(TaskID: Integer): Boolean;
// Есть ли дочернии элементы?
begin
  Result := False;
  With MainForm do
  begin
    FDQuery.Open('SELECT COUNT(ID) AS "CNT" FROM TASKS WHERE ParentID = ' +
      IntToStr(TaskID));
    if not FDQuery.FieldByName('CNT').IsNull then
      Result := FDQuery.FieldByName('CNT').AsInteger <> 0;
    FDQuery.Close;
  end;
end;

procedure TFormTargetList.FormShow(Sender: TObject);
begin
  MultiViewPopup.PopoverOptions.PopupHeight := ListBoxItemAdd.Height * 3;
  Update;
end;

procedure TFormTargetList.MasterButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TFormTargetList.OnClick(Sender: TObject);
begin
  if not(Sender is TListBoxItem) then
    Exit;

  if AvaibleChild(TListBoxItem(Sender).Tag) then
  begin
    Update(TListBoxItem(Sender).Tag);
    Exit;
  end;

  FormTargetView.Clear;

  With MainForm do
  begin
    FDQuery.Open('SELECT * FROM TASKS WHERE ParentID = ' +
      IntToStr(TListBoxItem(Sender).Tag));
    while not FDQuery.Eof do
    begin
      { if not FDQuery.FieldByName('NAME').IsNull then
        FormTarget.EditName.Text := FDQuery.FieldByName('NAME').AsString;
        if not FDQuery.FieldByName('MEASURE').IsNull then
        FormTarget.EditMeasure.Text := FDQuery.FieldByName('MEASURE').AsString;
        if not FDQuery.FieldByName('DETAIL').IsNull then
        FormTarget.EditDetail.Text := FDQuery.FieldByName('detail').AsString;
        if not FDQuery.FieldByName('STARTVALUE').IsNull then
        FormTarget.EditStartValue.Text := FDQuery.FieldByName('STARTVALUE').AsString;
        if not FDQuery.FieldByName('ICON').IsNull then
        begin
        FormTarget.ListBox.ItemIndex := FDQuery.FieldByName('ICON').AsInteger;
        FormTarget.ListBox.Selected.IsChecked := True;
        end; }
      FDQuery.Next;
    end;
    FDQuery.Close;
  end;

  FormTargetView.Show;
end;

procedure TFormTargetList.Update(TaskID: Integer = 0);
var
  Item: TListBoxItem;
begin
  ListBox.ShowCheckboxes := False;
  ListBox.Clear;
  With MainForm do
  begin
    FDQuery.Open('SELECT * FROM TASKS WHERE ParentID = ' + IntToStr(TaskID));
    while not FDQuery.Eof do
    begin
      Item := TListBoxItem.Create(nil);
      Item.Parent := FormTargetList.ListBox;
      Item.Height := 65;
      Item.ItemData.Accessory := TListBoxItemData.TAccessory.aMore;
      Item.TextSettings.WordWrap := True;
      Item.TextSettings.FontColor := TAlphaColorRec.Teal;
      Item.StyleLookup := 'listboxitembottomdetail';
      Item.OnClick := OnClick;
      if not FDQuery.FieldByName('ID').IsNull then
        Item.Tag := FDQuery.FieldByName('ID').AsInteger;
      if not FDQuery.FieldByName('NAME').IsNull then
        Item.ItemData.Text := FDQuery.FieldByName('NAME').AsString;
      if not FDQuery.FieldByName('DETAIL').IsNull then
        Item.ItemData.Detail := FDQuery.FieldByName('DETAIL').AsString;
      if not FDQuery.FieldByName('ICON').IsNull then
        Item.ImageIndex := FDQuery.FieldByName('ICON').AsInteger;
      FDQuery.Next;
    end;
    FDQuery.Close;
  end;
end;

end.
