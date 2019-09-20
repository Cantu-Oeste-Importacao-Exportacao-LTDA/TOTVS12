#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NUMSEQ    º Autor ³ Rafael Parma       º Data ³  25/04/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa responsavel por trazer o codigo do produto de     º±±
±±º          ³ acordo com a sequencia do campo B1_CLASINT                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico RJU                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                   

*--------------------- 
User Function NUMSEQ()
*--------------------- 

Local cClas := M->B1_CLASINT
Local nRec  := Recno()  
Local nAux  := Val(cClas)
Local cCod  := ""    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

dbSelectArea("SB1")
dbSetOrder(1)
dbGoTop()
If dbSeek(xFilial("SB1")+"0"+Alltrim(STR(nAux+1)))
	SB1->(dbSkip(-1))
	If Alltrim(cClas) == SUBSTR(SB1->B1_COD,1,2)
		cCod := SubSTR(SB1->B1_COD,4,4)
		nAux := Val(cCod)+1
		cCod := cClas+"."+StrZero(nAux,4)
	Else
		cCod := cClas+"."+"0001"		
	Endif
Else 
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbGoTop()
	If dbSeek(xFilial("SB1")+Alltrim(cClas))
		While !EOF() .and. xFilial("SB1")+Alltrim(cClas) == SB1->B1_FILIAL+SUBSTR(SB1->B1_COD,1,2)
			dbSelectArea("SB1")
			dbSkip()
		Enddo
		SB1->(dbSkip(-1))
		cCod := SubSTR(SB1->B1_COD,4,4)
		nAux := Val(cCod)+1
		cCod := cClas+"."+StrZero(nAux,4)
	Else
		cCod := cClas+"."+"0001"	
	Endif
Endif                     

dbGoTo(nRec)

Return cCod



*--------------------- 
User Function NUMSEQZP()
*--------------------- 

Local cClas := M->ZP_CLASINT
Local nRec  := Recno()  
Local nAux  := Val(cClas)
Local cCod  := ""      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

dbSelectArea("SZP")
dbSetOrder(1)
dbGoTop()
If dbSeek(xFilial("ZP")+"0"+Alltrim(STR(nAux+1)))
	SZP->(dbSkip(-1))
	If Alltrim(cClas) == SUBSTR(SZP->ZP_COD,1,2)
		cCod := SubSTR(SZP->ZP_COD,4,4)
		nAux := Val(cCod)+1
		cCod := cClas+"."+StrZero(nAux,4)
	Else
		cCod := cClas+"."+"0001"		
	Endif
Else 
	dbSelectArea("SZP")
	dbSetOrder(1)
	dbGoTop()
	If dbSeek(xFilial("SZP")+Alltrim(cClas))
		While !EOF() .and. xFilial("SZP")+Alltrim(cClas) == SZP->ZP_FILIAL+SUBSTR(SZP->ZP_COD,1,2)
			dbSelectArea("SZP")
			dbSkip()
		Enddo
		SZP->(dbSkip(-1))
		cCod := SubSTR(SZP->ZP_COD,4,4)
		nAux := Val(cCod)+1
		cCod := cClas+"."+StrZero(nAux,4)
	Else
		cCod := cClas+"."+"0001"	
	Endif
Endif                     

dbGoTo(nRec)

Return cCod