#INCLUDE "rwmake.ch"
#Include "PROTHEUS.Ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FA60FIL º Autor ³ Paulo Donizeti     º Data ³  26/10/2009  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Filtro no bordero para selecionar apenas os títulos do     º±±
±±º          ³ Banco.                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 10                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

USER FUNCTION FA60FIL()
Local cBanc  := PARAMIXB[1]
Local cAgec  := PARAMIXB[2]
Local cContc := PARAMIXB[3]
Local aRet 		:= {}
Local cFiltro 	 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Chama tela de parametros de filtro³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PARAMBOX({{2, 'Filtrar Titulos', 1,{'1 - Boleto Emitido', '2 - Sem Boleto', '3 - Todos'},100,'',.T.}},'Filtro de Titulos',@aRet)


aRet[1] := If(ValType(aRet[1]) == "N", STR(aRet[1], 1), aRet[1])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica opção selecionada pelo usuario e realiza o filtro³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DO CASE
	CASE aRet[1] = '1'  				//Boleto Emitido
		cFiltro := "E1_NUMBCO != '                 ' .AND.  ALLTRIM(E1_PORTADO) == ALLTRIM('"+cBanc+"') .AND. ALLTRIM(E1_AGEDEP) == ALLTRIM('"+cAgec+"') .AND. ALLTRIM(E1_CONTA) == ALLTRIM('"+cContc+"') "
        //cFiltro := "E1_NUMBCO > '0' .AND.  ALLTRIM(E1_PORTADO) == ALLTRIM('"+cBanc+"') .AND. ALLTRIM(E1_AGEDEP) == ALLTRIM('"+cAgec+"') .AND. ALLTRIM(E1_CONTA) == ALLTRIM('"+cContc+"') "

	CASE aRet[1] = '2'  	 			//Sem Boleto
		cFiltro := "E1_NUMBCO == '                 ' .AND.  ALLTRIM(E1_PORTADO) == ALLTRIM('"+cBanc+"') .AND. ALLTRIM(E1_AGEDEP) == ALLTRIM('"+cAgec+"') .AND. ALLTRIM(E1_CONTA) == ALLTRIM('"+cContc+"') "

	OTHERWISE 						 	//Todos
		cFiltro := ".T."
ENDCASE
         
Return (cFiltro)