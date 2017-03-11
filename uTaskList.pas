unit uTaskList;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, IOUTils,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Ani,
  FMX.ListBox, FMX.Layouts, System.ImageList, FMX.ImgList, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.MultiView;

const
  // Чтобы TListBoxItem не могу очистить TListBox, передадим сообщение форме, чтобы она сама это сделала
  USER_MESSAGE_RELOADTASK = 1;

type
  TRemoveMessage = packed record
    MessageId: Word;
    TaskId: Integer;
  end;

  PRemoveMessage = ^TRemoveMessage;

type
  TFormTaskList = class(TForm)
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
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ListBoxItemAddClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
  private
    fCurrTaskID: Integer;
    { Private declarations }
    procedure OnClick(Sender: TObject);
    procedure ReloadTask(var AMessage: TRemoveMessage); message USER_MESSAGE_RELOADTASK;
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
  uMain, uTargetView, uTargetNew;

{$R *.fmx}

function ReloadThread(Parameter: PRemoveMessage): Integer;
// Поток создаёт сообщение фрейму для перезагрузки контента
var
  Msg: TRemoveMessage;
begin
  Msg.MessageId := Parameter^.MessageId;
  Msg.TaskId := Parameter^.TaskId;
  FreeMem(Parameter);
  // Грязный код, но нужно дождаться завершения OnClick
  Sleep(50);
  //
  FormTaskList.Dispatch(Msg);
  Result := 0;
end;

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
begin
  MultiViewPopup.HideMaster;
  FormTargetNew.CreateMode;
  FormTargetNew.Clear;
  FormTargetNew.Show;
end;

procedure TFormTaskList.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := fCurrTaskID = 0;
  if fCurrTaskID <> 0 then
    MasterButtonClick(Sender);
end;

procedure TFormTaskList.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
{$IFDEF ANDROID}
  if Key = vkHardwareBack then
    if fCurrTaskID <> 0 then
    begin
      MasterButtonClick(Sender);
      Key := 0;
    end;
{$ENDIF}
end;

procedure TFormTaskList.MasterButtonClick(Sender: TObject);
begin
  if fCurrTaskID = 0 then
    Close
  else
    Update(GetParentTask(fCurrTaskID));
end;

procedure TFormTaskList.OnClick(Sender: TObject);
var
  Msg: PRemoveMessage;
{$IFDEF ANDROID}
  ThreadID: NativeUInt;
{$ELSE}
  ThreadID: Cardinal;
{$ENDIF}
begin
  if not(Sender is TListBoxItem) then
    Exit;

  GetMem(Msg, SizeOf(TRemoveMessage));
  Msg^.MessageId := USER_MESSAGE_RELOADTASK;
  Msg^.TaskId := TListBoxItem(Sender).Tag;

  if AvaibleChild(Msg^.TaskId) then
  begin
{$IFDEF ANDROID}
    BeginThread(nil, @ReloadThread, Msg, ThreadID);
{$ELSE}
    BeginThread(nil, 0, @ReloadThread, Msg, 0, ThreadID);
{$ENDIF}
    Exit;
  end;

  FormTargetView.Clear;
  With MainForm do
  begin
    FDQuery.Open('SELECT * FROM TASKS WHERE ParentID = ' + IntToStr(TListBoxItem(Sender).Tag));
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

procedure TFormTaskList.ReloadTask(var AMessage: TRemoveMessage);
// Реакция на сообщение о перезагрузке фрейма
begin
  Update(AMessage.TaskId);
end;

procedure TFormTaskList.Update(TaskId: Integer = 0);
// Обновление данных в ListBox
var
  Item: TListBoxItem;
begin
  fCurrTaskID := TaskId;
  ListBox.BeginUpdate;
  try
    ListBox.ShowCheckboxes := False;
    ListBox.Clear;
    With MainForm do
    begin
      FDQuery.Open('SELECT * FROM TASKS WHERE ParentID = ' + IntToStr(TaskId));
      while not FDQuery.Eof do
      begin
        // Создаём элемент
        Item := TListBoxItem.Create(nil);
        Item.Height := 65;
        Item.ItemData.Accessory := TListBoxItemData.TAccessory.aMore;
        Item.TextSettings.WordWrap := True;
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
        FormTaskList.ListBox.AddObject(Item);
        FDQuery.Next;
      end;
      FDQuery.Close;
    end;
  finally
    ListBox.EndUpdate;
  end;
end;

end.
