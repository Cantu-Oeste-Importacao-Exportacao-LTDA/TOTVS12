#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFIN150_3  บAutor  ณGuilherme Poyer     บ Data ณ  19/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ O ponto de entrada FIN150_3 serแ executado ap๓s excluir os บฑฑ
ฑฑบ          ณ arquivos de trabalho utilizados nesta rotina e antes       บฑฑ
ฑฑบ          ณ de encerrแ-la.                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Financeiro                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-------------------------*
User Function FIN150_3()   
*-------------------------*

Private lStatus := .F.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ 

U_USORWMAKE(ProcName(),FunName())

If !Empty(cArqTemp) //Verificar se ้ chamado pelo programa certo
	
	cDiret   := cArqAux     //Variavel recebe o valor no programa GETARQFIN e valoriza no P.E em questใo.
	cArq 	   := cArqTemp    //Variavel recebe o valor no programa GETARQFIN e valoriza no P.E em questใo.
	cSubCta	 := cTipo       //Variavel recebe o valor no programa GETARQFIN e valoriza no P.E em questใo. 
	cCaminho := iif(cSubCta == "001","\CNABS\RECEBER\OUTBOX\",iif(cSubCta == "003", "\CNABS\PAGAR\OUTBOX\", ""))
	
	If !Empty(Alltrim(cDiret))  
	
		If cSubCta == "001"
			
			if !ExistDir("\CNABS\RECEBER\")
				MakeDir("\CNABS\RECEBER")
			EndIf 
			
			if !ExistDir("\CNABS\RECEBER\OUTBOX\")
				MakeDir("\CNABS\RECEBER\OUTBOX")
			EndIf
			
		If cSubCta == "003"
			
			if !ExistDir("\CNABS\PAGAR\")
				MakeDir("\CNABS\PAGAR")
			EndIf 
			
			if !ExistDir("\CNABS\PAGAR\OUTBOX\")
				MakeDir("\CNABS\PAGAR\OUTBOX")
			EndIf
				
			
			
			cArqIn   := Alltrim(cDiret)+Alltrim(cArq)
			cArqDest := Alltrim(cCaminho)+Alltrim(cArq)
			
			lStatus := FRename(AllTrim(cArqAux)+Alltrim(cArq),AllTrim(cCaminho)+Alltrim(cArq)) 
			If lStatus != -1	
				CONOUT("FIN150_3 - "+cArq+" COPIADO DO DIR. "+cDiret+" PARA "+cCaminho)			
			Else
				CONOUT("FIN150_3 - ERRO AO COPIAR O ARQUIVO!")
			EndIf		
			EndIf
		EndIf
	
	Else
		CONOUT("FIN150_3 - DIRETORIO VAZIO, NรO SERม EFETUADA A CำPIA!")
	EndIf	
	
EndIf

Return  