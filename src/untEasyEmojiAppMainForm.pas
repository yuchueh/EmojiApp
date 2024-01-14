unit untEasyEmojiAppMainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.Effects, FMX.StdCtrls, FMX.ScrollBox, FMX.Memo, FMX.Edit,
  FMX.Controls.Presentation, FMX.Layouts, FMX.TabControl;

type
  TfrmEasyEmojiAppMainForm = class(TForm)
    MaterialOxfordBlueSB: TStyleBook;
    SaveDialog1: TSaveDialog;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    Layout1: TLayout;
    NextButton: TButton;
    PriorButton: TButton;
    CurrentCharLabel: TLabel;
    EmojiEdit: TEdit;
    EmojiLabel: TLabel;
    TabItem2: TTabItem;
    Memo1: TMemo;
    ToolBar1: TToolBar;
    Label1: TLabel;
    ShadowEffect1: TShadowEffect;
    ScreenshotButton: TButton;
    procedure ScreenshotButtonClick(Sender: TObject);
    procedure PriorButtonClick(Sender: TObject);
    procedure NextButtonClick(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FCurrentChar: Integer;
    procedure UpdateCharacter;
  public
    { Public declarations }
  end;

var
  frmEasyEmojiAppMainForm: TfrmEasyEmojiAppMainForm;

implementation

{$R *.fmx}

uses
  System.Math, Character;

// https://stackoverflow.com/questions/32020126/detecting-and-retrieving-codepoints-and-surrogates-from-a-delphi-string
function MyCharNext(P: PChar): PChar;
begin
  Result := P;
  if Result <> nil then
  begin
    Result := StrNextChar(Result);
    while GetUnicodeCategory(Result^) = TUnicodeCategory.ucCombiningMark do
      Result := StrNextChar(Result);
  end;
end;

function GetElementAtIndex(S: string; StrIdx: Integer): string;
var
  pStart, pEnd: PChar;
begin
  Result := '';
  if (S = '') or (StrIdx < 0) then
    Exit;
  pStart := PChar(S);
  while StrIdx > 1 do
  begin
    pStart := MyCharNext(pStart);
    if pStart^ = #0 then
      Exit;
    Dec(StrIdx);
  end;
  pEnd := MyCharNext(pStart);
  {$POINTERMATH ON}
  SetString(Result, pStart, pEnd - pStart);
end;

procedure TfrmEasyEmojiAppMainForm.FormCreate(Sender: TObject);
begin
  TabControl1.TabIndex := 0;
  FCurrentChar := Random(Trunc(Memo1.Lines.Text.Length/2));
  UpdateCharacter;
end;

procedure TfrmEasyEmojiAppMainForm.NextButtonClick(Sender: TObject);
begin
  FCurrentChar := Min(FCurrentChar + 1, Trunc(Memo1.Lines.Text.Length / 2));
  UpdateCharacter;
end;

procedure TfrmEasyEmojiAppMainForm.PriorButtonClick(Sender: TObject);
begin
  FCurrentChar := Max(FCurrentChar - 1, 0);
  UpdateCharacter;
end;

procedure TfrmEasyEmojiAppMainForm.ScreenshotButtonClick(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
    EmojiLabel.MakeScreenshot.SaveToFile(SaveDialog1.FileName);
  end;
end;

procedure TfrmEasyEmojiAppMainForm.TabControl1Change(Sender: TObject);
begin
  case TabControl1.TabIndex of
    0: Memo1.Visible := False;
    1: Memo1.Visible := True;
  end;
end;

procedure TfrmEasyEmojiAppMainForm.UpdateCharacter;
begin
  EmojiLabel.Text := GetElementAtIndex(Memo1.Lines.Text, FCurrentChar);
  EmojiEdit.Text := EmojiLabel.Text + ' ';
  CurrentCharLabel.Text := FCurrentChar.ToString;
end;

initialization
  Randomize;

end.

