program SenderData;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Winapi.Windows,
  RunSendingData in 'RunSendingData.pas',
  EnviarArquivo.Form in 'EnviarArquivo.Form.pas' {EnviarArquivo};

var
  SentFiles: string;
begin
  SentFiles := RunSendingData.CallFunction();

  MessageBox(0, PChar(Format('Realizado envio de %s registros.', [SentFiles])),
    'Envios de arquivos', MB_TASKMODAL + MB_OK + MB_DEFBUTTON1 + MB_ICONINFORMATION);
end.
