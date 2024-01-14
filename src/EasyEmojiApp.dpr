program EasyEmojiApp;

uses
  System.StartUpCopy,
  FMX.Forms,
  untEasyEmojiAppMainForm in 'untEasyEmojiAppMainForm.pas' {frmEasyEmojiAppMainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmEasyEmojiAppMainForm, frmEasyEmojiAppMainForm);
  Application.Run;
end.
