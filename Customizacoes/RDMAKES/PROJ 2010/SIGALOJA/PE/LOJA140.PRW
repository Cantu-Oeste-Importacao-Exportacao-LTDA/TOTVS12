#include "PROTHEUS.CH"
#include "RWMAKE.CH"
#include "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LOJA140    ºAutor  ³Joel Lipnhraski    º Data ³  29/04/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³P.E. chamado depois da exclusao do Cupom Fiscal.             ±±
±±º          ³Utilizado para integrar com PCO - Lancamento 999005.        º±±
±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-------------------------*
User Function LOJA140()
*-------------------------*
Local aArea  := GetArea()

Local cFILDOC   := SF2->F2_FILIAL
Local cCLIDOC   := SF2->F2_CLIENTE
Local cLOJDOC   := SF2->F2_LOJA
Local cNUMDOC   := SF2->F2_DOC
Local cSERDOC   := SF2->F2_SERIE
Local cQuery    := ""
Local cAliasTMP := "_LJ"     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

cQuery := " SELECT * FROM " + RetSqlName("SD2") + " SD2 "
cQuery += " WHERE SD2.D2_FILIAL = '" + cFILDOC + "' "
cQuery += " AND SD2.D2_DOC   = '" + ALLTRIM(cNUMDOC) + "' "
cQuery += " AND SD2.D2_SERIE = '" + ALLTRIM(cSERDOC) + "' "
cQuery += " AND SD2.D2_CLIENTE = '" + ALLTRIM(cCLIDOC) + "' "
cQuery += " AND SD2.D2_LOJA = '" + ALLTRIM(cLOJDOC) + "' "
cQuery += " AND D_E_L_E_T_  = '*' "	
	
TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)

dbSelectArea(cAliasTMP)
(cAliasTMP)->(dbGoTop())
                                
PCOINILAN("999005")				
While !(cAliasTMP)->(EOF()) .and. (cAliasTMP)->D2_FILIAL+(cAliasTMP)->D2_DOC+(cAliasTMP)->D2_SERIE+(cAliasTMP)->D2_CLIENTE+(cAliasTMP)->D2_LOJA == cFILDOC+cNUMDOC+cSERDOC+cCLIDOC+cLOJDOC
	Begin Transaction
		PCODETLAN("999005","01","LOJA140")
	End Transaction
	(cAliasTMP)->(dbSkip())
Enddo
PCOFINLAN("999005")

DbCloseArea( (cAliasTMP) )
			
Return