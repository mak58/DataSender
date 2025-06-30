unit EnviarArquivo.Form;

/// <summary>
///  Form executa um callBack de um método de fora.
///  Não é necessário incluir lógica dentro deste form.
///  Verificar exemplo de uso no CentralON_SERP.Modulo.Form.IniciarProcedimentoMultiploEnvio();
///  @marcio.koehler 2025;
/// </summary>

interface

uses cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, Vcl.Menus, JvComponentBase, JvFormPlacement, Vcl.StdCtrls, cxButtons,
  Vcl.Controls, cxProgressBar, System.Classes, Vcl.ExtCtrls, Vcl.Forms,
  System.SysUtils, Vcl.ComCtrls, System.Generics.Collections, Vcl.Graphics, Winapi.Windows;


type
  TEnviarArquivo = class(TForm)
    paGerarArquivo: TPanel;
    paProgresso: TPanel;
    lbProgresso: TLabel;
    ProgressBar: TcxProgressBar;
    paTarefa: TPanel;
    lbTarefa: TLabel;
    paTarefaLog: TPanel;
    ListBoxLog: TListBox;
    btFechar: TcxButton;
    lbObservacao: TLabel;
    procedure btFecharClick(Sender: TObject);
    procedure ListBoxLogDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  FOnExecute: TProc<TEnviarArquivo>;
  FSent: Boolean;
  public
    { Public declarations }
    FActive: Boolean;

    procedure AddLog(const AMessage: string; AReturn: string; APosition, AMax: Integer);
    procedure Execute();
    procedure SetFinalCaption();
    property OnExecute: TProc<TEnviarArquivo> read FOnExecute write FOnExecute;

    destructor Destroy;
    class function New(ACaption, AObservacao: string): TEnviarArquivo;
  end;

implementation

const
  SIZE_ROW_LISTBOX: Byte = 18;
var
  EnviarArquivo: TEnviarArquivo;

{$R *.dfm}

class function TEnviarArquivo.New(ACaption, AObservacao: string): TEnviarArquivo;
begin
  EnviarArquivo := TEnviarArquivo.Create(Application);
  EnviarArquivo.FActive := True;
  EnviarArquivo.Caption := ACaption;
  EnviarArquivo.lbObservacao.Caption := AObservacao;
  EnviarArquivo.ListBoxLog.ItemHeight := SIZE_ROW_LISTBOX;
  Result := EnviarArquivo;
end;

destructor TEnviarArquivo.Destroy;
begin
  EnviarArquivo.Free;
end;

procedure TEnviarArquivo.Execute();
begin
  if Assigned(FOnExecute) then
    TThread.CreateAnonymousThread(
      procedure
      begin
        FOnExecute(Self);
      end
    ).Start;
end;

procedure TEnviarArquivo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Self.FActive := False;
  Action := caFree;
end;

procedure TEnviarArquivo.ListBoxLogDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  ListBox: TListBox;
  ItemColor: TColor;
begin
  ListBox := Control as TListBox;

  ItemColor := TColor(ListBox.Items.Objects[Index]);

  if odSelected in State then
    ListBox.Canvas.Brush.Color := clHighlight
  else
    ListBox.Canvas.Brush.Color := ListBox.Color;

  ListBox.Canvas.FillRect(Rect);

  ListBox.Canvas.Font.Color := ItemColor;

  ListBox.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, ListBox.Items[Index]);
end;

procedure TEnviarArquivo.AddLog(const AMessage: string; AReturn: string; APosition, AMax: Integer);
var
  ItemIndex: Integer;
begin
  if (not FActive) then Exit;

  TThread.Synchronize(nil,
    procedure
    begin
      FSent := (AReturn <> '');

      ItemIndex := ListBoxLog.Items.Add(AMessage);
      ListBoxLog.ItemIndex := ListBoxLog.Items.Count - 1;

      if FSent then
        ListBoxLog.Items.Objects[ItemIndex] := TObject(clBlue)
      else
        ListBoxLog.Items.Objects[ItemIndex] := TObject(clRed);

      ListBoxLog.Repaint;

      ProgressBar.Properties.Max := AMax;
      ProgressBar.Position := APosition;
    end
  );
end;

procedure TEnviarArquivo.SetFinalCaption();
begin
  btFechar.Caption := 'Ok';
  btFechar.Tag := 1;
  btFechar.SetFocus;
end;

procedure TEnviarArquivo.btFecharClick(Sender: TObject);
begin
  case btFechar.Tag of
    0: btFechar.ModalResult := mrCancel;
    1: btFechar.ModalResult := mrOk;
  end;
  Self.Close;
end;

end.
