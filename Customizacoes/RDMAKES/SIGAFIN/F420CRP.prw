#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF420CRP  บAutor  ณEdison G. Barbieri   บ Data ณ  19/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ O ponto de entrada F420CRP  serแ executado ap๓s excluir os บฑฑ
ฑฑบ          ณ arquivos de trabalho utilizados nesta rotina e antes       บฑฑ
ฑฑบ          ณ de encerrแ-la.                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Financeiro                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-------------------------*
User Function F420CRP()   
*-------------------------*

Local aArea := GetArea()
Private lStatus := .F.  


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ 
U_USORWMAKE(ProcName(),FunName())

//If !Empty(cArqTemp) //Verificar se ้ chamado pelo programa certo
If iif(TYPE("cArqTemp") == "C", !Empty(cArqTemp),.F.) //Verificar se ้ chamado pelo programa certo
	
	cDiret   := cArqAux     //Variavel recebe o valor no programa GETARQFIN e valoriza no P.E em questใo.
	cArq 	 := cArqTemp    //Variavel recebe o valor no programa GETARQFIN e valoriza no P.E em questใo.
	cSubCta	 := cTipo       //Variavel recebe o valor no programa GETARQFIN e valoriza no P.E em questใo. 
	cCaminho := "\CNABS\PAGAR\OUTBOX\"    
	
	If !Empty(Alltrim(cDiret))  
	
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
				CONOUT("F420CRP - "+cArq+" COPIADO DO DIR. "+cDiret+" PARA "+cCaminho)			
			Else
				CONOUT("F420CRP - ERRO AO COPIAR O ARQUIVO!")
			EndIf		
			
		EndIf
	
	Else
		CONOUT("F420CRP - DIRETORIO VAZIO, NรO SERม EFETUADA A CำPIA!")
	EndIf	
	
EndIf

RestArea(aArea)      

Return 