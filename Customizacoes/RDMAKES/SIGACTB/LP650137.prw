#include "protheus.ch"
#include "rwmake.ch"   
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LP650137	  ºAutor  ³Ricardo Catelli   º Data ³  18/08/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Fonte do LP COM - PIS COMPRAS SERV/ENERGIA/ALUG/COMB       º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Lançamento Padrão - Compras / Cantu		                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LP650137(cGrupo,cTpProd,cProd,cSeg,cCOp,cCRate)

Local cCredit	 := SD1->D1_CONTA
Local hEnter	 := CHR(10) + CHR(13)      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

U_USORWMAKE(ProcName(),FunName())	 
                                                                                                                                                      
If SF4->F4_CATOPER == "012"	
	
	If cCRate == '1'
		cCredit := Posicione("SDE",1,xFilial("SDE") + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA + SD1->D1_ITEM, "DE_CONTA") 
	Else
		cCredit := SD1->D1_CONTA   
	EndIf
	
ElseIf SF4->F4_CATOPER == "008"	
	cCredit := "3210103020"  	   
	
ElseIf SF4->F4_CATOPER == "007"	
	cCredit := "3110104002"   
	
ElseIf SUBSTR(SB1->B1_GRUPO,1,4) == "1707" .AND. SF4->F4_ESTOQUE == "N"
	cCredit := "3210301014"

ElseIf SF4->F4_CATOPER == "048" 
 	cCredit := "1120501014"            

ElseIf SF4->F4_CATOPER == "011" .AND. SD1->D1_TIPO == "MP"
	cCredit := "1120501002"
	
Else
	If cCRate == '1'
		cCredit := Posicione("SDE",1,xFilial("SDE") + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA + SD1->D1_ITEM, "DE_CONTA")
	Else
		cCredit	:= SD1->D1_CONTA  
	EndIf
Endif	

Return (cCredit)