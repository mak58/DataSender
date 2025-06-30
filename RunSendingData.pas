unit RunSendingData;

interface

uses
  System.SysUtils, EnviarArquivo.Form;

function CallFunction(): string;
procedure SendData(AProgress: TEnviarArquivo; var ACount: Integer);

implementation

var
  LEnviarArquivo: TEnviarArquivo;
  Count: Integer;

function CallFunction(): string;
begin
  try
    LEnviarArquivo := TEnviarArquivo.New(
      'Enviando Dados Form',
      '* Gerando e enviando lote de 50 registros.');

    LEnviarArquivo.OnExecute := procedure(AProgress: TEnviarArquivo)
                                begin
                                  RunSendingData.SendData(
                                    AProgress,
                                    Count);
                                end;
    LEnviarArquivo.Execute();
    LEnviarArquivo.ShowModal();

    Result := Count.ToString();
  finally
    LEnviarArquivo.Free;
  end;
end;

procedure SendData(AProgress: TEnviarArquivo; var ACount: Integer);
const
  MAX_REC = 100;
var
  index: byte;
begin
  for index := 1 to MAX_REC do
  begin
    if (not AProgress.FActive) then Exit;

    Sleep(50);

    ACount := Index;

    if (index mod 2 = 0) then
      AProgress.AddLog(Format('Registro [%s] NÃO enviado! Verifique em Detalhes.',
        [Index.ToString()]),
        'Enviado',
        Index,
        MAX_REC)
    else
      AProgress.AddLog(Format('Registro [%s] ENVIADO com sucesso!',
        [Index.ToString()]),
        EmptyStr,
        Index,
        MAX_REC);

    if (Index = MAX_REC) then
      AProgress.SetFinalCaption();
  end;
end;

end.
