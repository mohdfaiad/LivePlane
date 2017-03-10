unit uTaskList;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs;

type
  TFormTaskList = class(TForm)
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Clear;
  end;

var
  FormTaskList: TFormTaskList;

implementation

{$R *.fmx}

{ TTFormTaskList }

procedure TFormTaskList.Clear;
begin

end;

end.
