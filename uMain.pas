unit uMain;

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
  FireDAC.Comp.DataSet, Engine, FMX.Edit, FMX.ScrollBox, System.Notification;

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
    MultiViewPopup: TMultiView;
    FDConnection: TFDConnection;
    BindingsList: TBindingsList;
    ListBoxItemNotes: TListBoxItem;
    FDQuery: TFDQuery;
    FDTransaction: TFDTransaction;
    ListBox: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    NotificationCenter: TNotificationCenter;
    procedure ListBoxItemTargetClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListBoxItemResourceClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShowTestNotification;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

uses uTaskList, UResourceList;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FDQuery.Close;
  FDQuery.Active := False;
  FDConnection.Close;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
{$IFDEF ANDROID}
  ShowTestNotification;
  FDConnection.Params.Values['Database'] := '$(DOC)/database.sqlite';
{$ELSE}
  FDConnection.Params.Values['Database'] := ExtractFilePath(ParamStr(0)) + 'database.sqlite';
{$ENDIF}
  FDConnection.DriverName := 'SQLite';
  FDConnection.Connected := True;
  FDConnection.ExecSQL('PRAGMA foreign_keys=ON');
end;

procedure TMainForm.ListBoxItemResourceClick(Sender: TObject);
begin
  FormResourceList.Show;
  MultiView.HideMaster;
end;

procedure TMainForm.ListBoxItemTargetClick(Sender: TObject);
begin
  FormTaskList.Show;
  MultiView.HideMaster;
end;

procedure TMainForm.ShowTestNotification;
var
  Notification: TNotification;
begin
  Notification := NotificationCenter.CreateNotification; // создаем экземпляр класса TNotification
  try // обработчик ошибок
    Notification.Name := 'MyNotification'; // Название
    Notification.AlertBody := 'Уведомление: PWcode.net'; // содержание уведомления
    Notification.FireDate := Now + EncodeTime(0, 0, 4, 0); // Задержка отправки на 4 секунды
 //   NotificationCenter.ScheduleNotification(Notification); // отправка уведомления в компонент
  finally
    Notification.DisposeOf; // очистка переменной при возникновении ошибки
  end;
end;

end.
