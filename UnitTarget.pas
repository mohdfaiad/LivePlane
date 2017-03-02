unit UnitTarget;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, IOUTils,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Ani,
  FMX.ListBox, FMX.Layouts, System.ImageList, FMX.ImgList, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.MultiView;

type
  TFormTarget = class(TForm)
    LayoutMain: TLayout;
    ListBox: TListBox;
    ToolBar: TToolBar;
    ToolLabel: TLabel;
    MasterButton: TSpeedButton;
    ConfigButton: TSpeedButton;
    MultiViewPopup: TMultiView;
    ListBox1: TListBox;
    procedure MasterButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Update;
  end;

var
  FormTarget: TFormTarget;

implementation

uses
  Main;

{$R *.fmx}

procedure TFormTarget.FormShow(Sender: TObject);
begin
  //MultiViewPopup.PopoverOptions.PopupHeight := ListBoxItemAdd.Height * 3;
  Update;
end;

procedure TFormTarget.MasterButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TFormTarget.Update;
var
  Item: TListBoxItem;
begin
  ListBox.ShowCheckboxes := False;
  ListBox.Clear;
  With MainForm do
  begin
    FDQuery.Open('SELECT * FROM TARGET');
    while not FDQuery.Eof do
    begin
      Item := TListBoxItem.Create(nil);
      Item.Parent := FormTarget.ListBox;
      Item.Height := 65;
      Item.ItemData.Accessory := TListBoxItemData.TAccessory.aMore;
      Item.TextSettings.WordWrap := True;
      Item.TextSettings.FontColor := TAlphaColorRec.Teal;
      Item.StyleLookup := 'listboxitembottomdetail';
    //  Item.OnClick := OnClick;
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
