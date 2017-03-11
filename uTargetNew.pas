unit uTargetNew;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs;

type
  TFormTargetNew = class(TForm)
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Clear;
    procedure CreateMode;
  end;

var
  FormTargetNew: TFormTargetNew;

implementation

{$R *.fmx}
{ TFormTargetNew }

procedure TFormTargetNew.Clear;
begin
  //
end;

procedure TFormTargetNew.CreateMode;
// Режим создания
begin
  { ToolLabel.Text := 'Добавление новой цели';
    Mode := mCreate;
    ConfigButton.StyleLookup := 'additembutton';
    fSelectedID := Integer(INVALID_HANDLE_VALUE); }
end;

end.
