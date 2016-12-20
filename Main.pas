unit Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.Objects, FMX.MultiView,
  FMX.ListBox, System.ImageList, FMX.ImgList, FMX.TabControl,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  System.Rtti, FMX.Bind.Grid, System.Bindings.Outputs, FMX.Bind.Editors,
  Data.Bind.Controls, Data.Bind.EngExt, FMX.Bind.DBEngExt, Data.Bind.Components,
  FMX.Bind.Navigator, Data.Bind.Grid, FMX.Grid, Data.Bind.DBScope,
  FireDAC.Comp.DataSet, Engine, FMX.Edit;

type
  TMainForm = class(TForm)
    LayoutMain: TLayout;
    ToolBar: TToolBar;
    ToolLabel: TLabel;
    MasterButton: TSpeedButton;
    ConfigButton: TSpeedButton;
    MultiView: TMultiView;
    Rectangle: TRectangle;
    ListBoxCommand: TListBox;
    ListBoxItemResource: TListBoxItem;
    ImageList: TImageList;
    ListBoxItemTarget: TListBoxItem;
    TabControl: TTabControl;
    TabItemResource: TTabItem;
    TabItemTarget: TTabItem;
    TabItemWhatNext: TTabItem;
    ListBoxItemWhatNext: TListBoxItem;
    ScrollBoxWhatNext: TScrollBox;
    LabelPlanningToday: TLabel;
    PanelResource: TPanel;
    MultiViewPopup: TMultiView;
    RectangleWhatNext: TRectangle;
    FDConnection: TFDConnection;
    FDTable: TFDTable;
    BindSourceDB: TBindSourceDB;
    StringGridBindSourceDB: TStringGrid;
    LinkGridToDataSourceBindSourceDB: TLinkGridToDataSource;
    NavigatorBindSourceDB: TBindNavigator;
    BindingsList: TBindingsList;
    ResEditName: TEdit;
    LinkControlToFieldResName: TLinkControlToField;
    ResLabelName: TLabel;
    ResLabelDesc: TLabel;
    ResEditDesc: TEdit;
    LinkControlToFieldResDesc: TLinkControlToField;
    ResEditMeasure: TEdit;
    LinkControlToFieldResMeasure: TLinkControlToField;
    ResLabelMeasure: TLabel;
    LayoutResourceEdit: TLayout;
    procedure ListBoxItemResourceClick(Sender: TObject);
    procedure ListBoxItemTargetClick(Sender: TObject);
    procedure ListBoxItemWhatNextClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    fResources: TResources;
  public
    { Public declarations }
    procedure SelectTabItem(TabItem: TTabItem);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

procedure TMainForm.SelectTabItem(TabItem: TTabItem);
begin
  // Активируем все элементы в списке команд
  ListBoxItemResource.Enabled := True;
  ListBoxItemTarget.Enabled := True;
  ListBoxItemWhatNext.Enabled := True;
  // Прячем все табы
  TabItemResource.Visible := False;
  TabItemTarget.Visible := False;
  TabItemWhatNext.Visible := False;
  // Прячем MultiView
  MultiView.HideMaster;
  // Активируем и показываем нужный таб
  TabControl.ActiveTab := TabItem;
  TabItem.Visible := True;
  // Блокируем соответствующий элемент в списке команд
  if TabItem = TabItemResource then
    ListBoxItemResource.Enabled := False;
  if TabItem = TabItemTarget then
    ListBoxItemTarget.Enabled := False;
  if TabItem = TabItemWhatNext then
    ListBoxItemWhatNext.Enabled := False;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FDTable.Active := False;
  FDConnection.Close;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  SelectTabItem(TabItemWhatNext);
  // fResources := TResources.Create(self, FDConnection, FDTable, FDQuery);
{$IFDEF ANDROID}
  FDConnection.Params.Values['Database'] := '$(DOC)/database.sqlite';
  FDTable.TableName := 'RESOURCE';
{$ENDIF}
  FDConnection.Connected := True;
  FDTable.Open('RESOURCE');
  FDTable.Active := True;
end;

procedure TMainForm.ListBoxItemResourceClick(Sender: TObject);
begin
  SelectTabItem(TabItemResource);
end;

procedure TMainForm.ListBoxItemTargetClick(Sender: TObject);
begin
  SelectTabItem(TabItemTarget);
end;

procedure TMainForm.ListBoxItemWhatNextClick(Sender: TObject);
begin
  SelectTabItem(TabItemWhatNext);
end;

end.
