#Include "Protheus.ch"

//===========================================================================================================
/* Ponto de Entrada para Cadastrar Validar Motorista Target
@author  	Davis Vieira MAgalhaes
@version 	P11 R11.8
@build		700120420A
@since 	    06/08/2014
@return

//===========================================================================================================
*/
User Function OS040GRV()

Local nOpc040 := PARAMIXB[1]
Local aArea040 := GetArea()
Local cCodMot := M->DA4_COD
Local cTipMot := M->DA4_TIPMOT
Local cCodFor := M->DA4_FORNEC
Local cLojFor := M->DA4_LOJA
Local cIdOper := M->DA4_IDOPE
Local cCPFMot := StrZero(Val(Alltrim(DA4->DA4_CGC)),11,0)
Local lRet    := .T.
   
dbSelectArea("DEL")
DEL->( dbSetOrder(2) )                                                                                     
If DEL->( dbSeek(xFilial("DEL")+cCodMot+"88") )

   LJMsgRun( "Aguarde... Analisando Processos...",, {|| lRet  := U_DVMFG02(nOpc040, cCodMot, cTipMot, cCodFor, cLojFor, cCPFMot, cIdOper) } )
EndIf

RestArea(aArea040)

Return(lRet)





