unit UnitResource;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.ListBox, FMX.MultiView,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TFormResource = class(TForm)
    LayoutMain: TLayout;
    ListBox: TListBox;
    ToolBar: TToolBar;
    ToolLabel: TLabel;
    MasterButton: TSpeedButton;
    ConfigButton: TSpeedButton;
    MultiViewPopup: TMultiView;
    ListBoxCommand: TListBox;
    ListBoxItemAdd: TListBoxItem;
    ListBoxItemDelete: TListBoxItem;
    ListBoxItemSelected: TListBoxItem;
    procedure MasterButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListBoxItemAddClick(Sender: TObject);
    procedure ListBoxItemSelectedClick(Sender: TObject);
    procedure ListBoxItemDeleteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Update;
    procedure Remove(Index: Integer);
  end;

var
  FormResource: TFormResource;

implementation

uses
  Main, UnitResourceNew;

{$R *.fmx}

procedure TFormResource.FormShow(Sender: TObject);
begin
  MultiViewPopup.PopoverOptions.PopupHeight := ListBoxItemAdd.Height * 3;
  Update;
end;

procedure TFormResource.ListBoxItemAddClick(Sender: TObject);
begin
  MultiViewPopup.HideMaster;
  FormResourceNew.Clear;
  FormResourceNew.Show;
end;

procedure TFormResource.ListBoxItemDeleteClick(Sender: TObject);
var
  I: Integer;
begin
  for I := ListBox.Count - 1 downto 0 do
    if ListBox.ItemByIndex(I).IsChecked then
    begin
      Remove(ListBox.ItemByIndex(I).Tag);
      ListBox.Items.Delete(ListBox.ItemByIndex(I).Index);
    end;
  MultiViewPopup.HideMaster;
end;

procedure TFormResource.ListBoxItemSelectedClick(Sender: TObject);
begin
  MultiViewPopup.HideMaster;
  ListBox.ShowCheckboxes := True;
end;

procedure TFormResource.MasterButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TFormResource.Remove(Index: Integer);
begin
  With MainForm do
  begin
    ShowMessage(IntToStr(FDConnection.ExecSQL('DELETE FROM RESOURCE WHERE ID = ' + IntToStr(Index))));
  end;
end;

procedure TFormResource.Update;
var
  MaxIndex: Integer;
  Item: TListBoxItem;
begin
  ListBox.ShowCheckboxes := False;
  ListBox.Clear;
  With MainForm do
  begin
    FDQuery.Open('SELECT * FROM RESOURCE');
    while not FDQuery.Eof do
    begin
      Item := TListBoxItem.Create(nil);
      Item.Parent := FormResource.ListBox;
      Item.Height := 65;
      Item.ItemData.Accessory := TListBoxItemData.TAccessory.aMore;
      Item.TextSettings.WordWrap := True;
      Item.TextSettings.FontColor := TAlphaColorRec.Teal;
      Item.StyleLookup := 'listboxitembottomdetail';
      if not FDQuery.FieldByName('ID').IsNull then
        Item.Tag := FDQuery.FieldByName('ID').AsInteger;
      if not FDQuery.FieldByName('NAME').IsNull then
        Item.ItemData.Text := FDQuery.FieldByName('NAME').AsString;
      if not FDQuery.FieldByName('MEASURE').IsNull then
        Item.ItemData.Text := Item.ItemData.Text + ' (' + FDQuery.FieldByName('MEASURE')
          .AsString + ')';
      if not FDQuery.FieldByName('detail').IsNull then
        Item.ItemData.Detail := FDQuery.FieldByName('detail').AsString;
      if not FDQuery.FieldByName('ICON').IsNull then
        Item.ImageIndex := FDQuery.FieldByName('ICON').AsInteger;

      FDQuery.Next;
    end;
    FDQuery.Close;
  end;
end;

end.
