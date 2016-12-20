unit Engine;

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
  FireDAC.Comp.DataSet;

type
  TResources = class(TFmxObject)
  private
    fConnection: TFDConnection;
    fTable: TFDTable;
    fQuery: TFDQuery;

  public
    constructor Create(AOwner: TComponent; AFDConnection: TFDConnection;
      AFDTable: TFDTable; AFDQuery: TFDQuery); reintroduce;
    destructor Destroy; override;

    procedure New(AName: String; ADesc: String; AMeasure: String);
  end;

implementation

{ TResource }

constructor TResources.Create(AOwner: TComponent; AFDConnection: TFDConnection;
  AFDTable: TFDTable; AFDQuery: TFDQuery);
begin
  inherited Create(AOwner);
  fConnection := AFDConnection;
  fTable := AFDTable;
  fQuery := AFDQuery;
end;

destructor TResources.Destroy;
begin

  inherited;
end;

procedure TResources.New(AName, ADesc, AMeasure: String);
var
  MaxID: Integer;
begin
  MaxID := -1;
  try
    fQuery.Open('SELECT MAX(ID) FROM RESOURCE');
    MaxID := fQuery.Fields[0].AsInteger;
    fQuery.Close;
  Except
  end;
  fQuery.SQL.Text := Format('INSERT INTO RESOURCE VALUES (%d, "%s", "%s", "%s")',
    [MaxID + 1, AName, ADesc, AMeasure]);
  fQuery.ExecSQL;
  fTable.UpdateRecord;
end;

end.
