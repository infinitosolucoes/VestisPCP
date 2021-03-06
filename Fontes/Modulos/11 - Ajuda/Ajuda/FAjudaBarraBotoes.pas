{**********************************************************************************}
{ VESTIS PCP  - SISTEMA PARA INDUSTRIAS DE CONFECÇÕES.                             } 
{                                                                                  } 
{ Este arquivo é parte do codigo-fonte do sistema VESTIS PCP, é um software livre; }
{ você pode redistribuí-lo e/ou modificá-lo dentro dos termos da GNU LGPL versão 3 }
{ como publicada pela Fundação do Software Livre (FSF).                            }
{                                                                                  }
{ Este programa é distribuído na esperança que possa ser útil, mas SEM NENHUMA     }
{ GARANTIA; sem uma garantia implícita de ADEQUAÇÃO a qualquer MERCADO ou          }
{ APLICAÇÃO EM PARTICULAR. Veja a Licença Pública Geral GNU/LGPL em português      }
{ para maiores detalhes.                                                           }
{                                                                                  }
{ Você deve ter recebido uma cópia da GNU LGPL versão 3, sob o título              }
{ "LICENCA.txt", junto com esse programa.                                          }
{ Se não, acesse <http://www.gnu.org/licenses/>                                    }
{ ou escreva para a Fundação do Software Livre (FSF) Inc.,                         }
{ 51 Franklin St, Fifth Floor, Boston, MA 02111-1301, USA.                         }
{                                                                                  }
{                                                                                  }
{ Autor: Adriano Zanini -  vestispcp.indpcp@gmail.com                              }
{                                                                                  }
{**********************************************************************************}


{***********************************************************************************
**  SISTEMA...............: VESTIS PCP                                            **
**  DESCRIÇÃO.............: SISTEMA ERP PARA INDUSTRIAS DE CONFECÇÕES             **
**  LINGUAGEM/DB..........: DELPHI XE7  /  SQL SERVER 2014                        ** 
**  ANO...................: 2010 - 2018                                           ** 
**                                                                                **
** ------------------------------------------------------------------------------ **
**                                                                                **
**  AUTOR/DESENVOLVEDOR...: ADRIANO ZANINI                                        **
**  MINHAS AUTORIAS.......:  Vestis PCP e IndPCP                                  **
**  - VESTISPCP (é gratuito, disponivel no GitHub). Não dou Suporte Técnico.      **
**  - INDPCP (é pago). Dou Suporte Técnico.                                       **
**                                                                                **
** -----------------------------------------------------------------------------  **
**                                                                                **
** - VESTISPCP É CÓDIGO-FONTE LIVRE. O CODIGO-FONTE NÃO PODE SER COMERCIALIZADO.  **
**                                                                                **
** - INDPCP É RESTRITO. SOMENTE EU, O AUTOR, POSSO COMERCIALIZAR O CODIGO-FONTE.  **
**                                                                                **
***********************************************************************************}

unit FAjudaBarraBotoes;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, FFrameBarra, ExtCtrls, FrmRelatoriosBotoes, frxClass, StdCtrls,
   Buttons,  FFrameBotoes, jpeg;

type
   TFrmAjudaBarraBotoes = class(TForm)
      FrmFrameBarra1: TFrmFrameBarra;
      Panel1: TPanel;
      FrameRelatoriosBotoes1: TFrameRelatoriosBotoes;
      Panel2: TPanel;
      GroupBox2: TGroupBox;
      RTFLabel2: TLabel;
      GroupBox1: TGroupBox;
      FrmFrameBotoes1: TFrmFrameBotoes;
      Image1: TImage;
      procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
      procedure FormCreate(Sender: TObject);
    procedure FrameRelatoriosBotoes1SpbSairClick(Sender: TObject);
   private
      { Private declarations }
   public
      { Public declarations }
   end;

var
   FrmAjudaBarraBotoes: TFrmAjudaBarraBotoes;

implementation

{$R *.dfm}

procedure TFrmAjudaBarraBotoes.FormCreate(Sender: TObject);
begin

   // SpbAdicionar.Glyph   :=FrmFrameBotoes1.SpbAdicionar.Glyph;
   // SpbAdicionar.Caption :=FrmFrameBotoes1.SpbAdicionar.Caption;

   // SpbSair.Glyph   :=FrmFrameBotoes1.SpbSair.Glyph;
   // SpbSair.Caption :=FrmFrameBotoes1.SpbSair.Caption;

end;

procedure TFrmAjudaBarraBotoes.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

   if Key = VK_Escape then
   begin
      close;
   end;

end;

procedure TFrmAjudaBarraBotoes.FrameRelatoriosBotoes1SpbSairClick(
  Sender: TObject);
begin
  FrameRelatoriosBotoes1.SpbSairClick(Sender);

end;

end.
