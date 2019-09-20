#include "protheus.ch"
#include "rwmake.ch"   
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ LP650013	  บAutor  ณRegis Stucker     บ Data ณ  17/03/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fonte para verificar a conta d้bito no documento de        บฑฑ
ฑฑบ          ณ entrada                                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Lan็amento Padrใo - Compras / Cantu		                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function LP650013(cGrupo,cTpProd,cProd,cSeg)

Local cDebit := SD1->D1_CONTA
Local hEnter	:= CHR(10) + CHR(13)  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName()) 

/*If SUBSTR(cGrupo,1,2)=='19'
	cDebit := "3210103026"
*/	
If SUBSTR(cGrupo,1,4)=='1707'
	cDebit := "3210301014"
	
ElseIf SUBSTR(cGrupo,1,2)=='99' .AND. !cSeg $'004001001/004001002' 
	cDebit := "3210103027"
	
ElseIf (cTpProd$("ME/MP") .AND. !SUBSTR(cGrupo,1,2) $ '09/10/11/12' .AND. cProd <> "01060005")
	cDebit := "3210103040"
	
ElseIf SUBSTR(cGrupo,1,2)=='99' .AND. cSeg $ '004001001/004001002' 
	cDebit := "3110203006"

ElseIf SUBSTR(cGrupo,1,2) $ '09/10/11/12'.AND. cSeg $ '004001001/004001002'
	cDebit := "3110203022"
	
ElseIf SUBSTR(cGrupo,1,2) $ '09/10/11/12'.AND. !cSeg $ '004001001/004001002'
	cDebit := "3210103076"
EndIf

Return (cDebit)

/*

SELECT F1_SERIE,F1_DOC,D1_ITEM,D1_COD,D1_TES,D1_DTDIGIT,F1_FILIAL FROM SD1500 D1,SF1500 F1, SF4CMP F4, Z24CMP Z,SB1CMP
WHERE D1_DOC = F1_DOC
AND D1_SERIE = F1_SERIE
AND D1_FORNECE = F1_FORNECE
AND D1_LOJA = F1_LOJA
AND D1_FILIAL = F1_FILIAL
--AND F1_DTDIGIT = '20110105' 
AND D1.D_E_L_E_T_ = ' '
AND F1.D_E_L_E_T_ = ' '
AND D1.D1_TES = F4_CODIGO
AND F4_CATOPER = '006'
AND B1_COD = D1_COD
AND SUBSTR(B1_GRUPO,1,2) ='99'
AND D1_CLVL ='004001001'
AND D1_TP ='MP'
GROUP BY F1_SERIE,F1_DOC,D1_ITEM,D1_COD,D1_TES,D1_DTDIGIT,F1_FILIAL

*/




