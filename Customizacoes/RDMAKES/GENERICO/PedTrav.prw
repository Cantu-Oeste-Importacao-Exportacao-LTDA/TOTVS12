#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³PEDTRAV ºAutor  ³Cleidisson Draszewski º Data ³  18/08/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para reimportar pedidos travados com importado = 9  º±±
±±º          ³                                                            º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PedTrav()

Local cPerg := "PEDTRAV"
Local cPerg := PadR(cPerg,10," ")
Local cSql	:= ""   
Local cEol	:= CHR(10) + CHR(13)  
Local lOk	:= .F.
Local aGrupos := {}


PswOrder(2) //Nome do usuário
If PswSeek(cUserName)				
   aGrupos := PswRet()[1][10]
EndIf   

For nI := 1 To Len(aGrupos)
	If aGrupos[nI] == "000000" //grupo Administrador
		lOk := .T.
	EndIf
Next nI        

If lOk
	VldPerg(cPerg)  // Chama funcao VldPerg para Verificar se as Perguntas existem no SX1, se nao existir cria
	AjusteSX1(cPerg)
	If !Pergunte(cPerg,.T.)
		Return
	EndIf
Else
	ShowHelpDlg("Atenção",{"Usuário não possui acesso de administrador."},5,{"Opção só poderá ser executada pelo administrador."},5)	
EndIf		

If lOk

		cSql += "BEGIN "																											+cEol
		cSql += "UPDATE POLIBRAS.POLIBRAS_PEDCAB2 SET  IMPORTADO = 1 WHERE IMPORTADO = 9 AND CODIGO_PEDIDO = 	"  + MV_PAR01+ "';"	+cEol
		cSql += "END;"  																											+cEol	
    
    Return
		
	If (TCSQLExec(cSql) < 0)
    	Return MsgStop("TCSQLError() " + TCSQLError()) 
 	Else
 		MsgInfo("Processo Concluído \o/ ")
 	EndIf
EndIf	

Return    


Static Function VldPerg(cPerg)

PutSX1(cPerg,"01","Codigo Pedido"	,"Codigo Pedido"   ,"Codigo Pedido"  ,"MV_CH1","C",006,0,0,"G","","","","","MV_PAR01","","","","","","","","","", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")

Return
