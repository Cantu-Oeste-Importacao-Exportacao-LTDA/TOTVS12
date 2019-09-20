#include "rwmake.ch"      
#include "topconn.ch"

*----------------------
User Function Contato()
*----------------------

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

@ 150,1 TO 550,580 DIALOG oDlg1 TITLE "Importacao de Contatos"
@ 180,220 BMPBUTTON TYPE 1 ACTION Executa()
@ 180,260 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 CENTERED           

Return()
                        
*-----------------------
Static Function Executa()
*-----------------------

dbSelectArea("SA1")
dbSetOrder(1)
dbGoTop()
nCodCont := 0001
while !eof()
    dbSelectArea("AC8")
    dbSetOrder(2)
    if !(dbSeek(xFilial("AC8")+"SA1  "+SA1->A1_COD+SA1->A1_LOJA))
			dbSelectArea("SU5")
			Reclock("SU5",.T.) 
			U5_FILIAL  := SPACE(2)
			U5_CODCONT := STRZERO(nCodCont,6)
	  	U5_CONTAT  := SUBSTR(SA1->A1_NOME,1,30)
			IF SA1->A1_TEL <> ""
        	  U5_FCOM1   := SA1->A1_TEL
			ELSE
			    U5_FCOM1   := "9999-9999"
			ENDIF
			U5_ATIVO = "1"
			MsUnlock("SU5")   

			Reclock("AC8",.T.) 
			AC8_FILIAL := SPACE(2)
			AC8_FILENT := SPACE(2)
			AC8_ENTIDA := "SA1"
 	    AC8_CODENT := SA1->A1_COD+SA1->A1_LOJA
      AC8_CODCON := STRZERO(nCodCont,6)
    	MsUnlock("AC8")
    Endif
    dbSelectArea("SA1")
  	dbSkip()   
	  nCodCont++
end

alert("Operação realizada com sucesso!")
Close(oDlg1)

Return()