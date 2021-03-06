{**********************************************************************************}
{ VESTIS PCP  - SISTEMA PARA INDUSTRIAS DE CONFEC��ES.                             } 
{                                                                                  } 
{ Este arquivo � parte do codigo-fonte do sistema VESTIS PCP, � um software livre; }
{ voc� pode redistribu�-lo e/ou modific�-lo dentro dos termos da GNU LGPL vers�o 3 }
{ como publicada pela Funda��o do Software Livre (FSF).                            }
{                                                                                  }
{ Este programa � distribu�do na esperan�a que possa ser �til, mas SEM NENHUMA     }
{ GARANTIA; sem uma garantia impl�cita de ADEQUA��O a qualquer MERCADO ou          }
{ APLICA��O EM PARTICULAR. Veja a Licen�a P�blica Geral GNU/LGPL em portugu�s      }
{ para maiores detalhes.                                                           }
{                                                                                  }
{ Voc� deve ter recebido uma c�pia da GNU LGPL vers�o 3, sob o t�tulo              }
{ "LICENCA.txt", junto com esse programa.                                          }
{ Se n�o, acesse <http://www.gnu.org/licenses/>                                    }
{ ou escreva para a Funda��o do Software Livre (FSF) Inc.,                         }
{ 51 Franklin St, Fifth Floor, Boston, MA 02111-1301, USA.                         }
{                                                                                  }
{                                                                                  }
{ Autor: Adriano Zanini -  vestispcp.indpcp@gmail.com                              }
{                                                                                  }
{**********************************************************************************}


{***********************************************************************************
**  SISTEMA...............: VESTIS PCP                                            **
**  DESCRI��O.............: SISTEMA ERP PARA INDUSTRIAS DE CONFEC��ES             **
**  LINGUAGEM/DB..........: DELPHI XE7  /  SQL SERVER 2014                        ** 
**  ANO...................: 2010 - 2018                                           ** 
**                                                                                **
** ------------------------------------------------------------------------------ **
**                                                                                **
**  AUTOR/DESENVOLVEDOR...: ADRIANO ZANINI                                        **
**  MINHAS AUTORIAS.......:  Vestis PCP e IndPCP                                  **
**  - VESTISPCP (� gratuito, disponivel no GitHub). N�o dou Suporte T�cnico.      **
**  - INDPCP (� pago). Dou Suporte T�cnico.                                       **
**                                                                                **
** -----------------------------------------------------------------------------  **
**                                                                                **
** - VESTISPCP � C�DIGO-FONTE LIVRE. O CODIGO-FONTE N�O PODE SER COMERCIALIZADO.  **
**                                                                                **
** - INDPCP � RESTRITO. SOMENTE EU, O AUTOR, POSSO COMERCIALIZAR O CODIGO-FONTE.  **
**                                                                                **
***********************************************************************************}

unit FAcesso;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   DB, ExtCtrls, StdCtrls, Classe.Global,  App.Constantes, FFrameBarra,
   Vcl.Imaging.pngimage;

type
   TFrmAcesso = class(TForm)
    FrmFrameBarra1: TFrmFrameBarra;
    W7Panel1: TPanel;
    BtnAcessar: TButton;
    BtnCancelar: TButton;
    EditUsuario: TLabeledEdit;
    EditSenha: TLabeledEdit;
    Image1: TImage;
      procedure FormClose(Sender: TObject; var Action: TCloseAction);
      procedure FormCreate(Sender: TObject);
      procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
      procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure BtnAcessarClick(Sender: TObject);
    procedure BtnCancelarClick(Sender: TObject);
   private
      { Private declarations }
      fechar: Boolean;
   public
      { Public declarations }
   end;

var
   FrmAcesso: TFrmAcesso;

implementation

uses Biblioteca, Global, FBaseDados;

{$R *.dfm}

procedure TFrmAcesso.BtnCancelarClick(Sender: TObject);
begin
   fechar := True;
   blnUsuarioAutorizado := false;
   close;
end;

procedure TFrmAcesso.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Action := caFree;
end;

procedure TFrmAcesso.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin

   if fechar = false then
      abort;

   // BaseDados.db_Usuario.Close;

end;

procedure TFrmAcesso.FormCreate(Sender: TObject);

begin
   nUsuario :=0;
   if FileExists('C:\Vestis.txt') then
   Begin
      EditUsuario.text := 'Admin';
      EditSenha.text := 'Admin';
   end;

   fechar := false;
   blnUsuarioAutorizado := false;

   BaseDados.db_Usuario.Open;

end;

procedure TFrmAcesso.BtnAcessarClick(Sender: TObject);
begin
   // BaseDados.db_Usuario.close;
   nUsuario :=0;



   FUsuario.UsuarioNome := UpperCase(EditUsuario.text);
   FUsuario.UsuarioSenha   := UpperCase(EditSenha.text);

   if empty(FUsuario.UsuarioNome) then
   Begin
      fechar := false;
      blnUsuarioAutorizado := false;
      BeepCritica;
      Informar('Voc� esqueceu de informar o seu nome de Login');
      EditUsuario.SetFocus;
      abort;
   end;

   if empty(FUsuario.UsuarioSenha) then
   Begin
      fechar := false;
      blnUsuarioAutorizado := false;
      BeepCritica;
      Informar('Voc� esqueceu de informar a sua senha Login');
      EditSenha.SetFocus;
      abort;

   end;

   // primeiro, tentar esenha master
   If (UpperCase(FUsuario.UsuarioNome) = MASTER_USUARIO) and (UpperCase(FUsuario.UsuarioSenha) = MASTER_SENHA) then
   begin
      blnUsuarioAutorizado := True;
      close;
   end;

   // abrir tabela

   If blnUsuarioAutorizado = false then
   begin

      BaseDados.db_Usuario.close;
      BaseDados.db_Usuario.ParamByName('USERNAME').AsString := FUsuario.UsuarioNome;
      BaseDados.db_Usuario.ParamByName('SENHA').AsString := FUsuario.UsuarioSenha;
      BaseDados.db_Usuario.Open;

      If not BaseDados.db_Usuario.IsEmpty then
      begin
         nUsuario :=BaseDados.db_Usuario.FieldByName('CODIGO').AsInteger;

         // checar se usuario est� autorizado
         if BaseDados.db_Usuario.FieldByName('BLOQUEAR').AsString='S' then
         begin
            BeepCritica;
            AvisoSistemaErro('Prezado(a) '+FUsuario.UsuarioNome+', '+sLineBreak+
             'Voc� est� cadastrado no sistema, por�m seu acesso n�o est� autorizado.'+sLineBreak+
             'Por favor, informe o administrador do sistema.'

             );

            fechar := false;
            blnUsuarioAutorizado := false;
            EditUsuario.SetFocus;
            abort;
         end;


         // marcar usu�rio como online;
         If not(BaseDados.db_Usuario.state in [dsEdit, dsInsert]) then
            BaseDados.db_Usuario.Edit;

         BaseDados.db_Usuario.FieldByName('ONLINE').AsString := 'S';
         BaseDados.db_Usuario.Post;


         FUsuario.UsuarioCodigo := BaseDados.db_Usuario.FieldByname('CODIGO').AsInteger;
         ModalResult := mrOk;
         BaseDados.db_Usuario.First;
         blnUsuarioAutorizado := True;



         close;
      End
      else
      Begin
         fechar := false;
         blnUsuarioAutorizado := false;
         BeepCritica;
         Informar('Usu�rio "' + FUsuario.UsuarioNome + '" n�o foi reconhecido pelo sistema.'
           + #13 + 'Acesso negado');
         EditUsuario.SetFocus;
         abort;
      End;
   End;

   fechar := True;

end;

procedure TFrmAcesso.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

   If Key = VK_RETURN then
      BtnAcessarClick(Sender);

   If Key = VK_ESCAPE then
      BtnCancelarClick(Sender);


end;

end.
