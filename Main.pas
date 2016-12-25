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
  FireDAC.Comp.DataSet, Engine, FMX.Edit, FMX.Grid.Style, FMX.ScrollBox;

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
    ListBoxItemWhatNext: TListBoxItem;
    MultiViewPopup: TMultiView;
    FDConnection: TFDConnection;
    FDTable: TFDTable;
    BindSourceDB: TBindSourceDB;
    BindingsList: TBindingsList;
    ListBoxItemNotes: TListBoxItem;
    procedure ListBoxItemTargetClick(Sender: TObject);
    procedure ListBoxItemWhatNextClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListBoxItemResourceClick(Sender: TObject);
  private
    { Private declarations }
    fResources: TResources;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

uses UnitTarget, UnitWhatNext, UnitResource;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   (*FDTable.Active := False;
  FDConnection.Close;          *)
end;

procedure TMainForm.FormShow(Sender: TObject);
begin    (*
{$IFDEF ANDROID}
  FDConnection.Params.Values['Database'] := '$(DOC)/database.sqlite';
  FDTable.TableName := 'RESOURCE';
{$ENDIF}
  FDConnection.Connected := True;
  FDTable.Open('RESOURCE');
  FDTable.Active := True;         *)
end;

procedure TMainForm.ListBoxItemResourceClick(Sender: TObject);
begin
  FormResource.Show;
  MultiView.HideMaster;
end;

procedure TMainForm.ListBoxItemTargetClick(Sender: TObject);
begin
  FormTarget.Show;
  MultiView.HideMaster;
end;

procedure TMainForm.ListBoxItemWhatNextClick(Sender: TObject);
begin
  FormWhatNext.Show;
  MultiView.HideMaster;
end;

end.
