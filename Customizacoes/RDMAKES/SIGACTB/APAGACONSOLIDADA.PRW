#include "rwmake.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CCT010   º Autor ³ Pedro A. de Souza  º Data ³  28/01/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Apagar lancamentos da Contabilidade Consolidada            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Exclusivo da CANTU                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CCT010()
   Local _dDataIni, _dDataFim
   Local _lMudar  := .f.
   Local _cQuery

   _dDataIni := _dDataFim := dDataBase
   
   	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama função para monitor uso de fontes customizados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())

   @ 096,042 TO 323,555 DIALOG oDlg5 TITLE "Apagar lançamentos consolidados"
   @ 010,010 SAY "Data Inicial" 
   @ 010,100 GET _dDataIni SIZE 70,50
   @ 025,010 SAY "Data Final" 
   @ 025,100 GET _dDataFim valid _dDataFim >= _dDataIni SIZE 70,50
   @ 093,168 BMPBUTTON TYPE 1 ACTION (_lMudar:= .t., close(oDlg5))
   @ 093,200 BMPBUTTON TYPE 2 ACTION close(oDlg5)
   ACTIVATE DIALOG oDlg5 CENTERED
     
   if _lMudar
   	 // Faz a seleção do registros por recno
     cSqlSel := "select distinct ct2_data AS CT2_DATA from " + RetSQLName("CT2")
     cSqlSel += " where ct2_filial = '99' AND CT2_DATA BETWEEN '"+dtos(_dDataIni)+"' AND '"+DTOS(_dDataFim)+"' "
     
     TCQUERY cSqlSel NEW ALIAS "TMPCT2"
     
   	 Processa({||ExcLan()})  	 
   	 
   	 TMPCT2->(dbCloseArea())

     MsgBox("Lancamentos excluídos")
   endIf
return (nil)

Static Function ExcLan()     
ProcRegua(TMPCT2->(LastRec()))
TMPCT2->(dbGoTop())
While TMPCT2->(!Eof())
	IncProc("Excluido lançamentos do dia " + dtoC(sToD(TMPCT2->CT2_DATA)) )
	_cQuery := "delete from  "+ RetSQLName("CT2")
	_cQuery += "   where ct2_data = '"+TMPCT2->CT2_DATA+"' "
  _cQuery += " and CT2_FILIAL = '99' "
  // Faz a exclusao do banco para o dia passado no alias
  TCSQLExec(_cQuery)
       
  // exclui da ct3       
  _cQuery := "delete from  "+ RetSQLName("CT3")
  _cQuery += "   where ct3_data = '"+TMPCT2->CT2_DATA+"' "
  _cQuery += " and CT3_FILIAL = '99' "
  // Faz a exclusao do banco para o dia passado no alias
  TCSQLExec(_cQuery)
       
  // Exclui da ct6
  _cQuery := "delete from  "+ RetSQLName("CT6")
  _cQuery += "   where ct6_data = '"+TMPCT2->CT2_DATA+"' "
  _cQuery += " and CT6_FILIAL = '99' "
  // Faz a exclusao do banco para o dia passado no alias
  TCSQLExec(_cQuery)
       
  // exclu da ctu
  _cQuery := "delete from  "+ RetSQLName("CTU")
  _cQuery += "   where ctu_data = '"+TMPCT2->CT2_DATA+"' "
  _cQuery += " and CTU_FILIAL = '99' "
  // Faz a exclusao do banco para o dia passado no alias
  TCSQLExec(_cQuery)
       
  TMPCT2->(dbskip())
EndDo
Return