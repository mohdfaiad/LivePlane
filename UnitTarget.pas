unit UnitTarget;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Ani,
  FMX.ListBox, FMX.Layouts, System.ImageList, FMX.ImgList;

type
  TFormTarget = class(TForm)
    Layout1: TLayout;
    ListBox1: TListBox;
    MetropolisUIListBoxItem1: TMetropolisUIListBoxItem;
    ListBoxGroupHeader1: TListBoxGroupHeader;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormTarget: TFormTarget;

implementation

{$R *.fmx}

procedure TFormTarget.FormCreate(Sender: TObject);
begin
{$IFDEF ANDROID}
  MetropolisUIListBoxItem1.Icon.LoadFromFile('.\assets\internal\android-brain.bmp');
{$ENDIF}
end;

end.
