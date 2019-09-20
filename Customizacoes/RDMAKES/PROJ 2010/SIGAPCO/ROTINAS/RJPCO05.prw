#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RJPCO05 ³ Autor ³ Joel Lipnharski       ³Data ³ 28/04/2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ FUNCAO PARA TRATAR A GERACAO DOS LANCAMENTOS DO PCO         ±±
±±³          ³ PARA AS PROVISOES DO RH (SRT), ONDE NO MESMO ANO DEDUZ O MES±±
±±³          ³ ANTERIOR PARA GERACAO DO SALDO.                             ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ CANTU                             	    				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RJPCO05()

Local aAlias    := GetArea()    
Local nRet      := SRT->RT_VALOR

Private cMatMv  := SRT->RT_MAT           
Private cCCMv   := SRT->RT_CC
Private dDat1Mv := SRT->RT_DATACAL
Private dDat2Mv := SRT->RT_DATACAL
Private cTPMv   := SRT->RT_TIPPROV
Private cVerMv  := SRT->RT_VERBA
Private nValMv  := SRT->RT_VALOR  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
                   
DbSelectArea("SRT")
wOrdSRT  := indexORD()
wRecSRT  := RECNO()

dDat1Mv := STOD((SUBSTR(DTOS(dDat1Mv),1,4)+SUBSTR(DTOS(dDat1Mv),5,2)+"01"))-1   //20100428

IF YEAR(dDat1Mv) == YEAR(dDat2Mv)
	dbSetOrder(1)
	dbSkip(-1)
	WHILE !EOF() .AND. !BOF() .AND. cMatMv+cCCMv == SRT->RT_MAT+SRT->RT_CC .AND. (;
	      (MONTH(dDat1Mv)+YEAR(dDat1Mv) == MONTH(SRT->RT_DATACAL)+YEAR(SRT->RT_DATACAL)) ;
	      .OR. (MONTH(dDat2Mv)+YEAR(dDat2Mv) == MONTH(SRT->RT_DATACAL)+YEAR(SRT->RT_DATACAL)) )
		IF YEAR(dDat1Mv) == YEAR(SRT->RT_DATACAL) .AND.  cTPMv+cVerMv == SRT->RT_TIPPROV+SRT->RT_VERBA .AND. ;
		   MONTH(SRT->RT_DATACAL) == MONTH(dDat1Mv)
			IF SRT->RT_VALOR > 0
				nRet := nValMv - SRT->RT_VALOR
			ELSE                              
				nRet := nValMv + SRT->RT_VALOR
			ENDIF
		ENDIF
		dbSkip(-1)
	ENDDO	
ENDIF
DbSelectArea("SRT")
DbSetOrder(wOrdSRT)
DbGoTo(wRecSRT)
RestArea(aAlias) 

RETURN nRet         
