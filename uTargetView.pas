unit uTargetView;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs;

type
  TFormTargetView = class(TForm)
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Clear;
  end;

var
  FormTargetView: TFormTargetView;

implementation

{$R *.fmx}
{ TFormTargetView }

procedure TFormTargetView.Clear;
begin
  // Пока ни чего
end;

end.
