#include "protheus.ch"
#INCLUDE "rwmake.ch"
#include "topconn.ch"

User Function PopulaZZV()    
	RptStatus({|lEnd| Popula(@lEnd) }, "Aguarde...","Processando Registros...", .T.) 
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

Return nil

Static function Popula(lEnd)

Local nCnt   := 0
Local cQuery := ""
Local cEmp   := ""    
Local cChave := ""
Local cCrLf  := Chr(13) + Chr(10)
Local cMunic := ""
Local cTrans := ""
Local aArea  := SM0->(GetArea())
Local aEmp   := {}

/*
DbSelectArea("SM0")
DbSetOrder(1)
SM0->(DbGoTop())

// Percorre o cadastro de empresas e armazena os códigos na variável aEmp[]
while !SM0->(EOF())
  if (cEmp <> SM0->M0_CODIGO)
  	aAdd(aEmp,SM0->M0_CODIGO)
  	cEmp := SM0->M0_CODIGO
  EndIf
	SM0->(DbSkip())
End
*/

// Serão utilizados como base apenas as empresas 30 e 31 para popular a tabela ZZV
aEmp := {'30','31'} 

// Monta o SQL para consultar os dados no banco.
cQuery := "SELECT A1_EST, A1_COD_MUN, F2_TRANSP, SUM(QTDE) AS QUANT FROM( "                    + cCrLf

for i := 1 to len(aEmp)
	
	cQuery += "SELECT A1_EST, A1_COD_MUN, F2_TRANSP, COUNT(*) AS QTDE FROM SF2"+aEmp[i]+"0 F2 "  + cCrLf
	cQuery += "INNER JOIN " + retSqlName("SA1") + " A1 "                                         + cCrLf
	cQuery += " ON A1_COD = F2_CLIENTE "                                                         + cCrLf
	cQuery += "AND A1_LOJA = F2_LOJA "                                                           + cCrLf
	cQuery += "AND A1.D_E_L_E_T_ <> '*' "                                                        + cCrLf
	cQuery += "AND F2_TRANSP NOT IN (' ','000056','.') "                                         + cCrLf
	cQuery += "AND F2.D_E_L_E_T_ <> '*' "                                                        + cCrLf
	cQuery += "GROUP BY A1_EST, A1_COD_MUN, F2_TRANSP "                                          + cCrLf
	
	if i == len(aEmp)
		cQuery += ") "
		cQuery += "GROUP BY A1_EST, A1_COD_MUN, F2_TRANSP "                                        + cCrLf
	Else
		cQuery += "UNION ALL "                                                                     + cCrLf
	EndIf
Next

cQuery += "ORDER BY A1_EST, A1_COD_MUN, F2_TRANSP, QUANT DESC "                                + cCrLf

TCQUERY cQuery NEW ALIAS "ZZVTMP"

DbSelectArea("ZZVTMP")
ZZVTMP->(DbGoTop())

// Varre a tabela temporária pela primeira vez para saber a quantidade de registros.
While !ZZVTMP->(EOF())
	nCnt++
	ZZVTMP->(DbSkip())
End

// Volta ao início da tabela temporária.
ZZVTMP->(DbGoTop())

// Atribui a quantidade de registros da tabela temporária na régua de processamento.        
SetRegua(nCnt)
While !ZZVTMP->(EOF())
	
	IncRegua()
	
	if cChave != ZZVTMP->A1_EST + ZZVTMP->A1_COD_MUN
		
		DbSelectArea("ZZV")
		ZZV->(DbSetOrder(2))
		
		if DbSeek(xFilial("ZZV") + ZZVTMP->A1_EST + ZZVTMP->A1_COD_MUN)
			RecLock("ZZV", .F.)			
			ZZV->ZZV_TRANSP := ZZVTMP->F2_TRANSP
			ZZV->ZZV_NMTRAN := Posicione("SA4",1,xFilial("SA4") + ZZVTMP->F2_TRANSP, "A4_NOME")
			ZZV->(MsUnlock())			
		Else
			RecLock("ZZV", .T.)			
			ZZV->ZZV_FILIAL := xFilial("ZZV")
			ZZV->ZZV_EST    := ZZVTMP->A1_EST
			ZZV->ZZV_CODMUN := ZZVTMP->A1_COD_MUN
			ZZV->ZZV_MUN    := Posicione("CC2",3,xFilial("CC2") + ZZVTMP->A1_COD_MUN, "CC2_MUN")
			ZZV->ZZV_TRANSP := ZZVTMP->F2_TRANSP
			ZZV->ZZV_NMTRAN := Posicione("SA4",1,xFilial("SA4") + ZZVTMP->F2_TRANSP, "A4_NOME")
			ZZV->(MsUnlock())
		EndIf
		
		cChave := ZZVTMP->A1_EST + ZZVTMP->A1_COD_MUN
	EndIf
	
	ZZVTMP->(DbSkip())
End
   
ZZVTMP->(DbCloseArea())

RestArea(aArea)

Return .T.