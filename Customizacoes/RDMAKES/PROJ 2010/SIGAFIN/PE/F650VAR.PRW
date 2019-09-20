#Include "rwmake.ch"
#Include "Protheus.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF650VAR   บAutor  ณRegis Stucker       บ Data ณ  02/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada executado na rotina FINA200 -			  บฑฑ
ฑฑบ          ณ Proc.Arquivo Retorno CNAB                                  บฑฑ
ฑฑบ          ณ Usado para buscar o tํtulo pelo Nosso N๚mero               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P10                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

/*    
-----------------------------------------------------------------------
Variaveis que tbem poderao ser utilizadas no fonte fora os PARAMIXB
-----------------------------------------------------------------------
Private cBanco
Private cAgencia
Private cConta
Private cHist070
Private lAut:=.f.,nTotAbat := 0
Private cArquivo
Private dDataCred
Private lCabec := .f.
Private cPadrao
Private nTotal := 0
Private cModSpb := "1"  // Informado apenas para nao dar problemas nas rotinas de baixa
Private nAcresc
Private nDecresc

-----------------------------------------------------------------------
Array aValores ira permitir que qualquer exce็ใo ou necessidade seja tratado no ponto de entrada em PARAMIXB
-----------------------------------------------------------------------
Estrutura de aValores
Numero do Titulo	- 01	cNumTit
data da Baixa		- 02	dBaixa
Tipo do Tกtulo		- 03	cTipo
Nosso Numero		- 04	cNsNum
Valor da Despesa	- 05	nDespes
Valor do Desconto	- 06	nDescont
Valor do Abatiment	- 07	nAbatim
Valor Recebido    	- 08	nValRec
Juros				- 09	nJuros
Multa				- 10	nMulta
Outras Despesas		- 11	nOutrDesp
Valor do Credito	- 12	nValCc
Data Credito		- 13	dDataCred
Ocorrencia			- 14	cOcorr
Motivo da Baixa 	- 15	cMotBan
Linha Inteira		- 16	xBuffer
Data de Vencto	   	- 17	dDtVc

PARAMIXB		[1,1]	 [1,2]	  [1,3]   [1,4]  [1,5]   [1,6]      [1,7]   [1,8]    [1,9]   [1,10]   [1,11]     [1,12]  [1,13]    [1,14]   [1,15]  [1,16]  [1,17]
aValores := ( { cNumTit, dBaixa, cTipo, cNsNum, nDespes, nDescont, nAbatim, nValRec, nJuros, nMulta, nOutrDesp, nValCc, dDataCred, cOcorr, cMotBan, xBuffer,dDtVc,{} })

*/

User Function F650VAR()   

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

/*
Local aAlias := GetArea()
Local hEnter := CHR(10) + CHR(13)

cNumTit	:=	ParamIXB[1,1]
cNsNum 	:=	ParamIXB[1,4]

Alert("titulo: "+cNumTit+" nn: "+cNsNum)
If !(SubStr(cNumTit,1,1)=="0") .OR. ALLTRIM(cNumTit) == "" // se nใo for IDCNAB
	Alert("entrou cond.")
	cQuery := ""
	cQuery += " SELECT E1_IDCNAB FROM " + RetSqlName("SE1") +  " E1									" + hEnter
	cQuery += "    WHERE D_E_L_E_T_ <> '*'															" + hEnter
	cQuery += "    AND E1_NUMBOR  <>'      ' 														" + hEnter
	cQuery += "    AND E1_IDCNAB  <>'      ' 														" + hEnter
	cQuery += "    AND E1_NUMBCO = '" + cNsNum + "'								  					" + hEnter
	cQuery += "    AND E1_SALDO   >0		 															" + hEnter	
		
	TCQUERY cQuery NEW ALIAS "SE1FIL"
	
	SE1FIL->(DbGotop())
	
	If SE1FIL->(!EOF())
		
		//Do While SE1FIL->(!EOF())
			
			ParamIXB[1,1]:= ALLTRIM(SE1FIL->E1_IDCNAB)
			Alert(SE1FIL->E1_IDCNAB)
		//dbSkip()			
		//EndDo
		
	EndIF
	DBCloseArea("SE1FIL")
EndIf

RestArea(aAlias)*/

Return