#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMANZA4    บAutor  ณJean Carlos Saggin  บ Data ณ  05/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para manuten็ใo de flex adicional x vendedor.       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Faturamento/For็a de Vendas                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ManZA4()

Private cTabela   := "ZA4"
Private cCadastro := "Flex Complem x Vendedor x Perํodo"
Private aRotina   := {}

aAdd(aRotina, {"&Pesquisar",  "AxPesqui", 0, 1})
aAdd(aRotina, {"&Visualizar", "AxVisual", 0, 2})
aAdd(aRotina, {"&Incluir",    "U_ZA4Inc", 0, 3})
aAdd(aRotina, {"&Alterar",    "U_ZA4Alt", 0, 4})
aAdd(aRotina, {"&Excluir",    "U_ZA4Del", 0, 5})
aAdd(aRotina, {"&Workflows",  "U_WFCFG" , 0, 6})

DbSelectArea(cTabela)
(cTabela)->(DbSetOrder(1))
mBrowse(6, 1, 22, 75, cTabela)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

Return Nil

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFun็ใo utilizada na valida็ใo de usuแrio do campo ZA4_PERIODณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

User Function VldPeriodo(cPeriodo)

Local lRet := .T.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

lRet := NaoVazio().and.;
		 SubStr(M->ZA4_PERIOD,1,2)$"01/02/03/04/05/06/07/08/09/10/11/12".and.;  
		 ((SubStr(M->ZA4_PERIOD,1,2) >= StrZero(Month(Date()),2).and.;
		 SubStr(M->ZA4_PERIOD,3,4) >= StrZero(Year(Date()),4)) .or.;
		 (SubStr(M->ZA4_PERIOD,1,2) < StrZero(Month(Date()),2).and.;
		 SubStr(M->ZA4_PERIOD,3,4) > StrZero(Year(Date()),4)))
		 
if !lRet
	Aviso("Conte๚do do campo Perํodo", "Verifique se o conte๚do do campo atende aos seguintes requisitos:"+ CHR(13)+ CHR(10)+;
			"- Os dois primeiros dํgitos formam um m๊s vแlido"+ CHR(13)+ CHR(10)+;
			"- Os dois primeiros dํgitos formam um m๊s maior ou igual ao m๊s atual"+ CHR(13)+ CHR(10)+;
			"- O Ano informado nos ๚ltimos quatro dํgitos formam um ano maior ou igual ao ano corrente.", {"Ok"}, 2)
EndIf        

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณZA4Inc    บAutor  ณJean Carlos Saggin  บ Data ณ  14/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo responsแvel por fazer a inclusใo dos registros      บฑฑ
ฑฑบ          ณ na tabela ZA4 utilizando a fun็ใo padrใo AxInclui          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MANZA4                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ZA4Inc()

Local nReg  := (cTabela)->(Recno())
Local aCpos := {"ZA4_FILIAL","ZA4_CODVEN","ZA4_DESCVE","ZA4_PERIOD","ZA4_VALOR","ZA4_USRINC",;
				  "ZA4_DTHRIN","ZA4_USRALT","ZA4_DTHRAL","ZA4_USREXC","ZA4_DTHREXC"} 

AxInclui(cTabela,nReg,3,,,aCpos,"U_ZA4TOK()",,,,,,,)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

Return 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFun็ใo responsแvel pela altera็ใo do registroณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

User Function ZA4Alt()

Local nReg  := (cTabela)->(Recno())
Local aCpos := {"ZA4_FILIAL","ZA4_CODVEN","ZA4_DESCVE","ZA4_PERIOD","ZA4_VALOR","ZA4_USRINC",;
				  "ZA4_DTHRIN","ZA4_USRALT","ZA4_DTHRAL","ZA4_USREXC","ZA4_DTHREXC"}


AxAltera(cTabela,nReg,4,,aCpos,,,"U_ZA4TOK()",,,) 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

Return Nil

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFun็ใo responsแvel pela exclusใo do registroณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

User Function ZA4Del()

Local nReg  := (cTabela)->(Recno())
Local aCpos := {"ZA4_FILIAL","ZA4_CODVEN","ZA4_DESCVE","ZA4_PERIOD","ZA4_VALOR","ZA4_USRINC",;
				  "ZA4_DTHRIN","ZA4_USRALT","ZA4_DTHRAL","ZA4_USREXC","ZA4_DTHREXC"}
    
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

RecLock("ZA4", .F.)
ZA4->ZA4_USREXC := cUserName
ZA4->ZA4_DTHREX := DTOS(DATE()) + ' ' + SUBSTR(TIME(), 1, 5)
MsUnlock()

AxDeleta(cTabela,nReg,5,,aCpos)

(cTabela)->(DbGoTo(nReg))
If !Deleted()
	RecLock("ZA4", .F.)
	ZA4->ZA4_USREXC := Space(15)
	ZA4->ZA4_DTHREX := Space(15)
	MsUnlock()
Else
	RptStatus({|lEnd| fEnvMail(5, ZA4->ZA4_CODVEN, ZA4->ZA4_PERIOD, ZA4->ZA4_VALOR, @lEnd)}, "Aguarde...","Calculando flex e enviando workflow...", .T.)	
EndIf

Return Nil

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFun็ใo que valida os dados na altera็ใo do registro.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

User Function ZA4TOK(nOpc)

Local nOpc := 0
Local nVlAnt := 0
    
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

if INCLUI
	nOpc := 3
ElseIf ALTERA
	nOpc := 4
	nVlAnt := ZA4->ZA4_VALOR
	M->ZA4_USRALT := cUserName
	M->ZA4_DTHRAL := DTOS(DATE()) + ' ' + SUBSTR(TIME(), 1, 5)  
EndIf                                                           

RptStatus({|lEnd| fEnvMail(nOpc, M->ZA4_CODVEN, M->ZA4_PERIOD, M->ZA4_VALOR, nVlAnt, @lEnd)}, "Aguarde...","Calculando flex e enviando workflow...", .T.)

Return .T.  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFun็ใo responsแvel pelo envio de workflow aos interessadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Static Function fEnvMail(nOper, cCodVen, cPeriod, nValor, nVlAnt ,lEnd)

Local aFields := {"ZA4_CODVEN","ZA4_PERIOD","ZA4_VALOR"}
Local lAlter  := .F.
Local nX      := 0
Local aArea   := GetArea()
Local cRotina := 'MANZA4  '
Local lFound  := .F.
Local oProcess
Local cAssunto := ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณBusca o cadastro do processo de workflow na tabela ZWFณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

DbSelectArea("ZWF")
ZWF->(DBSetOrder(1))
if DbSeek(xFilial("ZWF") + cRotina)
	lFound := .T.	
Else
	ConOut("Nใo foi encontrado processo "+ AllTrim(cRotina) +" na tabela ZWF! Envio de workflow cancelado.")
	RestArea(aArea)
	Return
EndIf               

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se o processo de workflow para essa rotina estแ ativo.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

if ZWF->ZWF_ATIVO != "S"
	ConOut("O processo "+ AllTrim(cRotina) +" estแ desativado na tabela ZWF! Envio de workflow cancelado.")
	RestArea(aArea)
	Return  
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se a filial atual estแ vinculada ao cadastro do workflowณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

if !(cFilAnt $ ZWF->ZWF_LISFIL)
	ConOut("O processo "+ AllTrim(cRotina) +" nใo estแ ativo para essa filial! Inclua a filial "+ cFilAnt +" no campo Filiais da tabela ZWF! Envio de workflow cancelado.")
	RestArea(aArea)
	Return
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณEdita o assunto do workflow de acordo com a opera็ใo.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

if nOper == 3
	cAssunto := "[FLEX ADICIONAL] "+ AllTrim(cUserName) +" liberou flex adicional."
ElseIf nOper == 4
	cAssunto := "[FLEX ADICIONAL] "+ AllTrim(cUserName) +" alterou uma libera็ใo de flex adicional."
Else                                                                                
	cAssunto := "[FLEX ADICIONAL] "+ AllTrim(cUserName) +" excluํu uma libera็ใo de flex adicional."
EndIf

oProcess := TWFProcess():New( "MANZA4", "FLEX ADICIONAL X VENDEDOR")
oProcess:NewTask( "MANZA4", "\WORKFLOW\MANZA4.HTML" )
oProcess:cSubject := cAssunto
oHTML := oProcess:oHTML

oProcess:cTo := AllTrim(ZWF->ZWF_EMAIL)
oProcess:cCC := AllTrim(ZWF->ZWF_EMAILC)
oProcess:cBCC := AllTrim(ZWF->ZWF_EMAILO)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณPreenchimento de variแveis que comp๕em o workflow.
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ

DbSelectArea("SA3")
SA3->(DbSetOrder(1))
if DbSeek(xFilial("SA3") + cCodVen)
	cNome   := Upper(AllTrim(SubStr(SA3->A3_NOME, 01, 30)))
	cCodigo := cCodVen
EndIf

cMesAno := fGetPer(cPeriod)
cFlxAdi := fGetFlxAdi(cCodVen, cPeriod, nValor, nVlAnt, nOper)

DbSelectArea("ZA4")

if nOper == 3
	
	cOperacao := "incluํu"
	oHtml:ValByName("CUSUARIO", Upper(AllTrim(cUserName)) )
	oHtml:ValByName("COPERA"  , cOperacao )
	oHtml:ValByName("CNMVEN"  , cNome )
	oHtml:ValByName("CCODVND" , cCodigo )
	oHtml:ValByName("CPERIODO", cMesAno )
	oHtml:ValByName("FLXADIC" , cFlxAdi )   
	oHtml:ValByName("FLXUTIL" , "R$ 0,00" ) // Fixo por enquanto @qui...  
	
	oProcess:Start()
	oProcess:Finish()
	
ElseIf nOper == 4
	for nX := 1 to Len(aFields)
		if &("ZA4->"+aFields[nX]) != &("M->"+aFields[nX])
			lAlter := .T.
		EndIf
	Next nX
	if lAlter
		// Preenchimento de variแveis de altera็ใo
		cOperacao := " alterou "

		oHtml:ValByName("CUSUARIO", Upper(AllTrim(cUserName)) )
		oHtml:ValByName("COPERA"  , cOperacao )
		oHtml:ValByName("CNMVEN"  , cNome )
		oHtml:ValByName("CCODVND" , cCodigo )
		oHtml:ValByName("CPERIODO", cMesAno )
		oHtml:ValByName("FLXADIC" , cFlxAdi )   
		oHtml:ValByName("FLXUTIL" , "R$ 0,00" ) // Fixo por enquanto @qui...
		
		oProcess:Start()
		oProcess:Finish()
		
	EndIf	
Else
	// Preenchimento de variแveis especํficas para exclusใo
	cOperacao := " excluํu "
	
	oHtml:ValByName("CUSUARIO", Upper(AllTrim(cUserName)) )
	oHtml:ValByName("COPERA"  , cOperacao )
	oHtml:ValByName("CNMVEN"  , cNome )
	oHtml:ValByName("CCODVND" , cCodigo )
	oHtml:ValByName("CPERIODO", cMesAno )
	oHtml:ValByName("FLXADIC" , cFlxAdi )   
	oHtml:ValByName("FLXUTIL" , "R$ 0,00" ) // Fixo por enquanto @qui... 
	
	oProcess:Start()
	oProcess:Finish()
	
EndIf

if lFound
	
	DbSelectArea("ZWF")
	ZWF->(DBSetOrder(1))
	DbSeek(xFilial("ZWF") + cRotina)

	RecLock("ZWF", .F.)
	ZWF->ZWF_ULTEXC := Date()
	ZWF->(MsUnlock())
EndIf

RestArea(aArea)
          
Return .T.      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGetPer  บAutor  ณJean Carlos Saggin   บ Data ณ  14/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo responsแvel por retornar m๊s e ano em formato de    บฑฑ
ฑฑบ          ณ string                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MANZA4                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fGetPer(cPeriodo)

Local cRet := ""
Local cMes := SubStr(cPeriodo, 01, 02)
Local cAno := SubStr(cPeriodo, 03, 04)

Do Case
	Case cMes == "01"
		cRet := "janeiro de "
	Case cMes == "02"
		cRet := "fevereiro de "
	Case cMes == "03"
		cRet := "mar็o de "
	Case cMes == "04"
		cRet := "abril de "
	Case cMes == "05"
		cRet := "maio de "
	Case cMes == "06"
		cRet := "junho de "
	Case cMes == "07"
		cRet := "julho de "
	Case cMes == "08"
		cRet := "agosto de "
	Case cMes == "09"
		cRet := "setembro de "
	Case cMes == "10"
		cRet := "outubro de "
	Case cMes == "11"
		cRet := "novembro de "
	Case cMes == "12"
		cRet := "dezembro de " 
EndCase

cRet += cAno

Return cRet	

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGetFlxAdi  บAutor Jean Carlos Saggin  บ Data ณ  14/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo responsแvel por retornar o valor de flex adicional  บฑฑ
ฑฑบ          ณ jแ liberado para o vendedor no perํodo.                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MANZA4                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fGetFlxAdi(cCodVen, cPeriodo, nValor, nVlAnt, nOpc)

Local nVlAtu := 0
Local cTotal := ""
Local cSql   := ""                                                            
Local cEol   := CHR(13)+CHR(10)

cSql := "select sum(za4.za4_valor) as vlrlib from "+ RetSqlName("ZA4")+ " za4 "+cEol
cSql += "where za4.za4_codven = '"+ cCodVen +"' "                              +cEol
cSql += "  and za4.za4_period = '"+ cPeriodo +"' "                             +cEol
cSql += "  and za4.d_e_l_e_t_ <> '*'"

TCQUERY cSql NEW ALIAS "za4tmp"

DbSelectArea("za4tmp")
za4tmp->(DbGoTop())

if !za4tmp->(EOF())
	nVlAtu := za4tmp->vlrlib
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSe estiver incluindo jแ inclui o valor do registro atual ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

if nOpc == 3
	nVlAtu += nValor
ElseIf nOpc == 4
	nVlAtu -= nVlAnt
	nVlAtu += nValor		
EndIf

cTotal := "R$ "+ Transform(nVlAtu, "@E 999,999.99") 

za4tmp->(DbCloseArea())

Return cTotal