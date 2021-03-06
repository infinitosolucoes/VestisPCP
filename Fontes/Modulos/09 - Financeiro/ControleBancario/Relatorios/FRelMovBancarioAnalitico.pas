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

unit FRelMovBancarioAnalitico;

interface

uses
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   DBTables, DB, quickrpt, Qrctrls, ExtCtrls,
       QRPDFFilt,   FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
   TFrmRelMovBancarioAnalitico = class(TForm)
      QuickRep: TQuickRep;
      QRBand1: TQRBand;
      QRLabel7: TQRLabel;
      QRLabel9: TQRLabel;
      QRSysData3: TQRSysData;
      QRLabel10: TQRLabel;
      QRSysData4: TQRSysData;
      Cabecalho: TQRBand;
      QRBand2: TQRBand;
      QuebraBanco: TQRGroup;
      QRLabel15: TQRLabel;
      TotalClasse: TQRBand;
      QRLabel14: TQRLabel;
      QRBand4: TQRBand;
      Sql_MovtoBancario:  TFDQuery;
      QRLabel6: TQRLabel;
      QRLabel3: TQRLabel;
      QRLabel11: TQRLabel;
      LblSldAnterior: TQRLabel;
      QRLabel8: TQRLabel;
      QRLabel4: TQRLabel;
      Vlr_SaldoAtual: TQRDBText;
      Vlr_Debito: TQRDBText;
      Vlr_Credito: TQRDBText;
      Vlr_SaldoAnterior: TQRDBText;
      QRDBText2: TQRDBText;
      QRDBText3: TQRDBText;
      QRExpr1: TQRExpr;
      QRExpr3: TQRExpr;
      QRDBText4: TQRDBText;
      QRDBText5: TQRDBText;
      QRExpr4: TQRExpr;
      QRExpr6: TQRExpr;
      QRDBText6: TQRDBText;
      QRDBText1: TQRDBText;
      procedure FormCreate(Sender: TObject);
      procedure FormClose(Sender: TObject; var Action: TCloseAction);
   private
      { Private declarations }
   public
      { Public declarations }
   end;

var
   FrmRelMovBancarioAnalitico: TFrmRelMovBancarioAnalitico;

implementation

uses FPrincipal, Global, Biblioteca, FRelMovbancario;

{$R *.DFM}

procedure TFrmRelMovBancarioAnalitico.FormCreate(Sender: TObject);
begin

   sqlMaster :=
     ' SELECT * FROM SP_BANCO_SALDO_02(:DATA1, :DATA2, :SLDANTERIOR, :CONTA_CORRENTE) ';

   Sql_MovtoBancario.Close;
   Sql_MovtoBancario.SQL.Clear;
   Sql_MovtoBancario.SQL.Add(sqlMaster);
   Sql_MovtoBancario.ParamByName('DATA1').AsDateTime :=
     StrToDate(FrmRelMovbancario.FrameDatas1.MskDataIni.Text);
   Sql_MovtoBancario.ParamByName('DATA2').AsDateTime :=
     StrToDate(FrmRelMovbancario.FrameDatas1.MskDataFim.Text);

   // Informar se deve ou n�o Incluir o Saldo Anterior
   if (FrmRelMovbancario.RadioGSaldoAnterior.ItemIndex = 0) then
   begin
      Sql_MovtoBancario.ParamByName('SLDANTERIOR').AsString := 'S';
   end;

   if (FrmRelMovbancario.RadioGSaldoAnterior.ItemIndex = 1) then
   begin
      LblSldAnterior.Enabled := False;
      Vlr_SaldoAnterior.Enabled := False;
      Sql_MovtoBancario.ParamByName('SLDANTERIOR').AsString := 'N';
   end;

   if not FrmRelMovbancario.chkContaCorrente.checked then
   Begin
      Sql_MovtoBancario.ParamByName('CONTA_CORRENTE').AsInteger := StrToInt(FrmRelMovbancario.EditContaCorrente.Text);
   End
   else
   begin
      Sql_MovtoBancario.ParamByName('CONTA_CORRENTE').AsInteger := 0;
   end;

   Sql_MovtoBancario.Open;

   QuickRep.Preview;
   Close;

end;

procedure TFrmRelMovBancarioAnalitico.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   Sql_MovtoBancario.Close;

   Action := caFree;
end;

end.
