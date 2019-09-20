#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPABMAN  ºAutor  ³Microsiga           º Data ³  24/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina criada para importação dos registros de abastec.    º±±
±±º          ³ manual.                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Manutenção de Ativos                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*------------------------*
User Function ImpAbMan()  
*------------------------*

Private nImp := 0    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
                                                                                                                                         
If Aviso("Importação de Abastecidas", "Essa rotina tem por objetivo fazer a integração dos abastecimentos manuais. Deseja Prosseguir?", {"Sim", "Não"}) == 1
	RptStatus({|lEnd| RunProc(@lEnd)}, "Aguarde...","Importando registros de abastecidas", .T.)
EndIf

Aviso("Registros Importados", cValToChar(nImp) + " abastecidas importadas.", {"Ok"}, 2)

Return

*-------------------------*                                                                     
Static Function RunProc()   
*-------------------------*

Local cSql := ""
Local oDlg
Local aCampos
Local oMSNewGe1
Local aHeaderEx := {}
Local aColsEx := {}
Local aFieldFill := {}
Local lOk := .F.
Local nRegua := 0
Local nPrcComb6	:= 0 
Local cSqlPr6 := "" 
Local cSqlPrc := ""

if (cEmpAnt != "50")
	Return
EndIf

// Usar este ponto de entrada para fazer a inserção manual em M->XXX_XXXXX
// Não há como fazer rotina automática

cSql := "SELECT AB.DATAABASTECIMENTO as DATAAB, AB.HORAABASTECIMENTO AS HORAAB, AB.QUANTIDADE AS QTDE, AB.MOTORISTA AS MOTOR, "
cSql += "AB.PLACA, AB.KM, AB.CODIGO, AB.CODPOSTO, AB.IDBICO, AB.COMBUSTIVEL "
cSql += "FROM abastecimentomanual AB "
cSql += "WHERE AB.SINCRONIZADO = 'N' "

TcQuery cSql New Alias "TMPABS"

cSqlPrc := "SELECT TQH_PRENEG FROM TQH500 TQH "
cSqlPrc += "WHERE TQH_CODPOS = '78575149 ' AND TQH_LOJA = '0001' AND D_E_L_E_T_ <> '*' AND TQH_CODCOM = '001'"
cSqlPrc += "AND TQH_DTNEG = (SELECT MAX(TQH_DTNEG) FROM TQH500 WHERE "
cSqlPrc += " D_E_L_E_T_ <> '*' AND TQH_CODPOS = '78575149 ' AND TQH_LOJA = '0001' AND TQH_CODCOM = '001')"

TcQuery cSqlPrc NEW ALIAS "TQHPRC"

nPrcComb := TQHPRC->TQH_PRENEG
TQHPRC->(dbCloseArea())

cSqlPr6 := "SELECT TQH_PRENEG FROM TQH500 TQH "
cSqlPr6 += "WHERE TQH_CODPOS = '78575149 ' AND TQH_LOJA = '0001' AND D_E_L_E_T_ <> '*' AND TQH_CODCOM = '006' "
cSqlPr6 += "AND TQH_DTNEG = (SELECT MAX(TQH_DTNEG) FROM TQH500 WHERE "
cSqlPr6 += " D_E_L_E_T_ <> '*' AND TQH_CODPOS = '78575149 ' AND TQH_LOJA = '0001' AND TQH_CODCOM = '006') "
           	
TcQuery cSqlPr6 NEW ALIAS "TQHPR6"
nPrcComb6 := TQHPR6->TQH_PRENEG
TQHPR6->(dbCloseArea())

if TMPABS->(EOF())
	TMPABS->(dbCloseArea())
	Return .T.	
EndIf

DbSelectArea("TMPABS")
TMPABS->(DbGoTop())

count to nRegua

TMPABS->(DbGoTop())

SetRegua(nRegua)

// Faz a importação para a tabela TR6
While TMPABS->(!Eof())
	nImp++ 
	IncRegua()
	
	DbSelectArea("TR6")
	TR6->(DbSetOrder(1))
	if !DbSeek(TMPABS->CODIGO)    
	
	
		RecLock("TR6", .T.)
		TR6->TR6_FILIAL := xFilial("TR6")
		TR6->TR6_NUMABA := TMPABS->CODIGO
		TR6->TR6_PLACA  := TMPABS->PLACA
		TR6->TR6_CNPJ   := "78575149000196"
		TR6->TR6_TIPCOM := TMPABS->COMBUSTIVEL
		TR6->TR6_CPFMOT := POSICIONE("DA4", 01, xFilial("DA4") + PadL(Trim(TMPABS->MOTOR), 6, "0"), "DA4_CGC")
		TR6->TR6_KMABAS := TMPABS->KM
		TR6->TR6_QTDCOM := TMPABS->QTDE
		TR6->TR6_VLCOMB := IIF(TMPABS->COMBUSTIVEL$'001',nPrcComb,nPrcComb6)
		TR6->TR6_VLTOT  := TMPABS->QTDE * (IIF(TMPABS->COMBUSTIVEL$'001',nPrcComb,nPrcComb6))
		TR6->TR6_DTABAS := CToD(TMPABS->DATAAB)
		TR6->TR6_HRABAS := TMPABS->HORAAB
		TR6->TR6_TANQUE := "OF"
		TR6->TR6_BOMBA  := SUBSTR(TMPABS->COMBUSTIVEL,1,3)
			
	
		TR6->(MsUnlock())          
		TCSQLExec("UPDATE ABASTECIMENTOMANUAL SET SINCRONIZADO = 'S' WHERE CODIGO = '" + Trim(TMPABS->CODIGO) + "' ")
		
	EndIf
	
	TMPABS->(dbSkip())
EndDo

TMPABS->(dbCloseArea())

Return