unit UWhatNext;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.ListBox, FMX.MultiView;

type
  TFormWhatNext = class(TForm)
    LayoutMain: TLayout;
    ListBox: TListBox;
    ToolBar: TToolBar;
    ToolLabel: TLabel;
    MasterButton: TSpeedButton;
    ConfigButton: TSpeedButton;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    MultiViewPopup: TMultiView;
    procedure MasterButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormWhatNext: TFormWhatNext;

implementation

{$R *.fmx}

procedure TFormWhatNext.MasterButtonClick(Sender: TObject);
begin
  Close;
end;

end.
