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

unit FProdutosPesquisaPreco;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, StdCtrls, ExtCtrls,   db, Buttons, jpeg, Mask, DBCtrls,
        
    Grids,   DBGrids, ISFEdit, ISFEditbtn,
  ISFdbEditbtn, IDBEdit, uEstSearchDialogZeos, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
   TFrmProdutosPesquisaPreco = class(TForm)
      Panel3: TPanel;
      Label18: TLabel;
      db_estoque:  TFDQuery;
      ds_estoque: TDataSource;
    Panel1: TPanel;
    Panel2: TPanel;
    Image2: TImage;
    Panel4: TPanel;
    EditCodigo: TLabeledEdit;
    Painel1: TPanel;
    EditQtde: TLabeledEdit;
    EditNomeProduto: TLabeledEdit;
    EditPreco: TLabeledEdit;
    EditCodigoProduto: TLabeledEdit;
    DBGrid1: TDBGrid;
    ds_estoqueEstoque: TDataSource;
    db_estoqueEstoque: TFDQuery;
    dbProcurarProduto: TIDBEditDialog;
      procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
      procedure FormClose(Sender: TObject; var Action: TCloseAction);
      procedure EditCodigoKeyPress(Sender: TObject; var Key: Char);
      procedure EditCodigoKeyDown(Sender: TObject; var Key: Word;
        Shift: TShiftState);
   private
      { Private declarations }

      ViaLeitor: Boolean;

   public
      { Public declarations }
   end;

var
   FrmProdutosPesquisaPreco: TFrmProdutosPesquisaPreco;

implementation

uses FPrincipal, SQLServer, Biblioteca, Global;

{$R *.dfm}

procedure TFrmProdutosPesquisaPreco.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   If Key = VK_ESCAPE then
   Begin
      close;
   End;

end;

procedure TFrmProdutosPesquisaPreco.EditCodigoKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   if dbProcurarProduto.Execute then
   begin
      EditCodigo.Text :=dbProcurarProduto.ResultFieldAsString('REFERENCIA');
   end;
end;

procedure TFrmProdutosPesquisaPreco.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin

   // checar se o produto existe
   wInteger[0] := 0; // Quantidade disponivel do tamanho U
   wInteger[1] := 0; // Quantidade disponivel do tamanho P
   wInteger[2] := 0; // Quantidade disponivel do tamanho M
   wInteger[3] := 0; // Quantidade disponivel do tamanho G
   wInteger[4] := 0; // Quantidade disponivel do tamanho GG

   Action := cafree;
end;

procedure TFrmProdutosPesquisaPreco.EditCodigoKeyPress(Sender: TObject;
  var Key: Char);
begin
   // db_VendasItens.FieldByName('QTDE').AsFloat;
   // codigo de barras
   If Key = #13 then
   Begin

      db_estoque.close;

      EditNomeProduto.Text := '';
      EditPreco.Text := '';
      EditQtde.Text := '';

      db_estoque.close;
      db_estoque.ParamByName('REFERENCIA').AsString :=     Uppercase(alltrim(EditCodigo.Text));
      db_estoque.Open;

      if db_estoque.RecordCount < 1 then
      begin
         Erro('Produto n�o cadastrado no estoque');
         EditCodigo.SetFocus;
         db_estoque.close;
         Exit;
      End;
      db_estoque.first;

      // checar as quantidades
      EditCodigoProduto.Text := Trim(EditCodigo.Text);
      EditNomeProduto.Text := db_estoque.FieldByName('DESCRICAO').AsString;
      EditPreco.Text := FormatFloat('###,##0.00',        db_estoque.FieldByName('PRC_VENDA').AsFloat);
      EditQtde.Text := FormatFloat('###,##0',            db_estoque.FieldByName('ESTOQUESALDO').AsFloat);



      FSQL := ' SELECT *  FROM CAD_PRODUTOS_GRADES ';

      CrossTab(db_estoqueEstoque,
             FSQL,
             'COR',
             'GRADE (COR/TAMANHO):',
             'TAMANHO',
             'QUANTIDADE',
             ' WHERE TAMANHO<>''''  AND REFERENCIA='+QuotedStr(Trim(EditCodigo.Text)),
             'ORDEM_GRADE',
             'SUM');


      db_estoque.close;

      EditCodigo.Text := '';

   End;

end;

end.
