unit uTaskList;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, IOUTils,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Ani,
  FMX.ListBox, FMX.Layouts, System.ImageList, FMX.ImgList, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.MultiView, FMX.WebBrowser, MarkdownProcessor,
  FMX.Objects, FMX.ScrollBox;

type
  TFormTaskList = class(TForm)
    LayoutMain: TLayout;
    ToolBar: TToolBar;
    ToolLabel: TLabel;
    MasterButton: TSpeedButton;
    ConfigButton: TSpeedButton;
    MultiViewPopup: TMultiView;
    ListBoxCommand: TListBox;
    ListBoxItemAdd: TListBoxItem;
    ListBoxItemSelected: TListBoxItem;
    ListBoxItemDelete: TListBoxItem;
    MultiView: TMultiView;
    Rectangle: TRectangle;
    ListBox: TListBox;
    procedure MasterButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListBoxItemAddClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    fMD: TMarkdownProcessor;
    fCurrTaskID: Integer;
    { Private declarations }
    procedure OnClick(Sender: TObject);
  public
    { Public declarations }
    function AvaibleChild(TaskId: Integer = 0): Boolean;
    procedure Update(TaskId: Integer = 0);
    function GetParentTask(TaskId: Integer): Integer;
  end;

var
  FormTaskList: TFormTaskList;

implementation

uses
  uMain, uTaskView, uTargetNew;

{$R *.fmx}

function TFormTaskList.AvaibleChild(TaskId: Integer): Boolean;
// Есть ли дочернии элементы?
begin
  Result := False;
  With MainForm do
  begin
    FDQuery.Open('SELECT COUNT(ID) AS "CNT" FROM TASKS WHERE ParentID = ' + IntToStr(TaskId));
    if not FDQuery.FieldByName('CNT').IsNull then
      Result := FDQuery.FieldByName('CNT').AsInteger <> 0;
    FDQuery.Close;
  end;
end;

procedure TFormTaskList.FormShow(Sender: TObject);
begin
  fMD := TMarkdownProcessor.createDialect(mdDaringFireball);
  fMD.UnSafe := true;
  fCurrTaskID := 0;
  MultiViewPopup.PopoverOptions.PopupHeight := ListBoxItemAdd.Height * 3;
  Update;
end;

function TFormTaskList.GetParentTask(TaskId: Integer): Integer;
// Получить ID родительской цели
begin
  Result := 0;
  With MainForm do
  begin
    FDQuery.Open('SELECT ParentID FROM TASKS WHERE ID = ' + IntToStr(TaskId));
    while not FDQuery.Eof do
    begin
      if not FDQuery.FieldByName('ParentID').IsNull then
      begin
        Result := FDQuery.FieldByName('ParentID').AsInteger;
        Break;
      end;
      FDQuery.Next;
    end;
    FDQuery.Close;
  end;
end;

procedure TFormTaskList.ListBoxItemAddClick(Sender: TObject);
// Добавляем новую задачу
begin
  MultiViewPopup.HideMaster;
  FormTargetNew.CreateMode;
  FormTargetNew.Clear;
  FormTargetNew.Show;
end;

procedure TFormTaskList.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(fMD) then
    fMD.free;
  if fCurrTaskID <> 0 then
    Action := TCloseAction.caFree;
end;

procedure TFormTaskList.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
{$IFDEF ANDROID}
  if Key = vkHardwareBack then
  begin
    MasterButtonClick(Sender);
    Key := 0;
  end;
{$ENDIF}
end;

procedure TFormTaskList.MasterButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TFormTaskList.OnClick(Sender: TObject);
var
  FormTaskListNew: TFormTaskList;
begin
  ListBox.Visible := False;
  try
    if not(Sender is TListBoxItem) then
      exit;
    { if AvaibleChild(TListBoxItem(Sender).Tag) then
      begin
      Application.CreateForm(TFormTaskList, FormTaskListNew);
      FormTaskListNew.Show;
      FormTaskListNew.Update(TListBoxItem(Sender).Tag);
      end
      else
      begin }
    FormTaskView.Clear;
    With MainForm do
    begin
      FDQuery.Open('SELECT * FROM TASKS WHERE ID = ' + IntToStr(TListBoxItem(Sender).Tag));
      while not FDQuery.Eof do
      begin
        if not FDQuery.FieldByName('NAME').IsNull then
          FormTaskView.LabelTaskName.Text := FDQuery.FieldByName('NAME').AsString;
        if not FDQuery.FieldByName('DETAIL').IsNull then
          FormTaskView.LabelTaskDetail.Text := FDQuery.FieldByName('DETAIL').AsString;
        if not FDQuery.FieldByName('COMMENT').IsNull then
          FormTaskView.WebBrowser.LoadFromStrings(fMD.process(FDQuery.FieldByName('COMMENT').AsString), 'about:blank');
        FDQuery.Next;
      end;
      FDQuery.Close;
    end;
    FormTaskView.Show;
    // end;
  finally
    ListBox.Visible := true;
  end;

end;

procedure TFormTaskList.Update(TaskId: Integer = 0);
// Обновление данных в ListBox
var
  Head: TListBoxGroupHeader;
  Footer: TListBoxGroupFooter;
  Item: TListBoxItem;
begin
  fCurrTaskID := TaskId;
  Self.ListBox.BeginUpdate;
  try
    Self.ListBox.ShowCheckboxes := False;
    Self.ListBox.Clear;
    With MainForm do
    begin
      FDQuery.Open('SELECT * FROM TASKS WHERE ParentID = ' + IntToStr(TaskId));
      while not FDQuery.Eof do
      begin
        // Создаём элемент
        Item := TListBoxItem.Create(nil);
        Item.Height := 65;
        Item.ItemData.Accessory := TListBoxItemData.TAccessory.aMore;
        Item.TextSettings.WordWrap := true;
        Item.TextSettings.FontColor := TAlphaColorRec.Teal;
        Item.StyleLookup := 'listboxitembottomdetail';
        Item.OnClick := OnClick;
        if not FDQuery.FieldByName('ID').IsNull then
          Item.Tag := FDQuery.FieldByName('ID').AsInteger;
        if not FDQuery.FieldByName('ParentID').IsNull then
          Item.TagFloat := FDQuery.FieldByName('ParentID').AsFloat;
        if not FDQuery.FieldByName('NAME').IsNull then
          Item.ItemData.Text := FDQuery.FieldByName('NAME').AsString;
        if not FDQuery.FieldByName('DETAIL').IsNull then
          Item.ItemData.Detail := FDQuery.FieldByName('DETAIL').AsString;
        if not FDQuery.FieldByName('ICON').IsNull then
          Item.ImageIndex := FDQuery.FieldByName('ICON').AsInteger;

        // Добавляем его в листбокс
        Self.ListBox.AddObject(Item);
        FDQuery.Next;
      end;
      FDQuery.Close;
    end;
  finally
    Self.ListBox.EndUpdate;
  end;
end;

end.
