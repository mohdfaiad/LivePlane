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
    procedure MasterButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListBoxItemAddClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Update;
  end;

var
  FormResource: TFormResource;

implementation

{$R *.fmx}

uses UnitResourceNew;

procedure TFormResource.FormShow(Sender: TObject);
begin
  MultiViewPopup.PopoverOptions.PopupHeight := ListBoxItemAdd.Height +
    ListBoxItemDelete.Height;
end;

procedure TFormResource.ListBoxItemAddClick(Sender: TObject);
begin
  MultiViewPopup.HideMaster;
  FormResourceNew.Clear;
  FormResourceNew.Show;
end;

procedure TFormResource.MasterButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TFormResource.Update;
begin

end;

end.
