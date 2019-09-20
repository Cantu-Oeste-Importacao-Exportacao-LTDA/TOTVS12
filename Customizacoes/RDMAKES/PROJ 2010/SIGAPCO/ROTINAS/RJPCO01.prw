#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJPCO01  ºAutor  ³JoelLipnharski       º Data ³  02/03/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para retornar conta orçamentária amarrada a       º±±
±±º          ³ conta contábil (CT1)                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PROTHEUS                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
   
/*
Opções de Retorno
"CT1->CT1_X_CO"   - Retorna Conta Orçamentaria amarrada a Conta Contábil - CT1. 
"SC7->C7_CC"      - Retorna Centro de Custos Pedido de Compras na NFE.
"SC7->C7_CLVL"    - Retorna Classe de Valor Pedido de Compras na NFE. 
"SC7->C7_CONTA"   - Retorna Conta Orçamentária amarrada a Conta Contábil - CT1 no Pedido de Compras - NFE.
"SED->ED_CONTA"   - Retorna Conta Orçamentária amarrada a natureza - Contas a Pagar. 
"SEV->EV_NATUREZ" - Retorna Conta Orçamentária amarrada a natureza - Multi Natureza Contas a Pagar. 
"SEZ->EZ_NATUREZ" - Retorna Conta Orçamentária amarrada a natureza - Multi Natureza e Rat. Centro de Custos - Contas a Pagar. 
"CV4->CV4_DEBITO" - Retorna Conta Orçamentária amarrada a Conta Contábil - Contas a Pagar Rateio Centro de Custos.    
"SE5->E5_NATUREZ" - Retorna Conta Orçamentária amarrada a Conta Contábil - Baixas a Pagar.   
"CTAORIG"         - Retorna Valores da Origem - Documento de Devolução 
*/

User Function RJPCO01(_cOpcao,_cVar)

Local lTest			:= ISINCALLSTACK("PCOA530")
Local lVai			:= ISINCALLSTACK("PCOA530ALC")
Private _cVarAux 	:= ""
Private _cRet   	:= ""    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//U_USORWMAKE(ProcName(),FunName())         

//Rotina de Contingencia do PCO, se utilizar GetArea() ocorrem problemas na gravadao do campo ref. AKA_CHVCTG
If !lTest .AND. !lVai
	aAreaRJ := GetArea() 
EndIf


Do Case  
                               
	Case _cOpcao = "CT1->CT1_X_CO"
		if !ISINCALLSTACK("PCOA530") .AND. !ISINCALLSTACK("PCOA530ALC") 
			RetCOCT1(_cVar)
		else
			_cRet := ALLTRIM(POSICIONE("CT1",1,XFILIAL("CT1")+Alltrim(_cVar),"CT1_X_CO"))
		endif
		
	Case _cOpcao = "SC7->C7_CC"
		_cRet := POSICIONE("SC7",1,XFILIAL("SC7")+_cVar,"SC7->C7_CC")

	Case _cOpcao = "SC7->C7_CLVL"
		_cRet := POSICIONE("SC7",1,XFILIAL("SC7")+_cVar,"SC7->C7_CLVL") 
		
	Case _cOpcao = "SC7->C7_EMISSAO"
		_cRet := POSICIONE("SC7",1,XFILIAL("SC7")+_cVar,"SC7->C7_EMISSAO") 

	Case _cOpcao = "SC7->C7_CONTA"
		_cVar := Alltrim(POSICIONE("SC7",1,XFILIAL("SC7")+SD1->D1_PEDIDO+SD1->D1_ITEMPC,"SC7->C7_CONTA"))
		RetCOCT1(_cVar)

	Case _cOpcao = "SED->ED_CONTA"
		If _cVar == "P" .OR. _cVar == "PB"       //CONTAS A PAGAR
			If _cVar == "PB"
				cAliasSE2 := 'M->'	
			Else
				cAliasSE2 := 'SE2->'
			EndIf
			_cVarAux := POSICIONE("SED",1,XFILIAL("SED")+&(cAliasSE2+'E2_NATUREZ'),"SED->ED_DEBITO")
			If EMPTY(_cVarAux) 
				_cVarAux := POSICIONE("SED",1,XFILIAL("SED")+&(cAliasSE2+'E2_NATUREZ'),"SED->ED_CONTA")
			EndIf	
		ElseIf _cVar == "R" //CONTAS A RECEBER
			_cVarAux := POSICIONE("SED",1,XFILIAL("SED")+SE1->E1_NATUREZ,"SED->ED_CREDIT")
			If EMPTY(_cVarAux) 
				_cVarAux := POSICIONE("SED",1,XFILIAL("SED")+SE1->E1_NATUREZ,"SED->ED_CONTA")
			EndIf	
		EndIf
		RetCOCT1(_cVarAux)

	Case _cOpcao = "CV4->CV4_DEBITO"
		If !EMPTY(CV4->CV4_DEBITO) 		//Se estiver preenchido a conta contábil no Rateio utiliza ela
			_cVar := CV4->CV4_DEBITO
		Else
			_cVar := POSICIONE("SED",1,XFILIAL("SED")+SE2->E2_NATUREZ,"SED->ED_DEBITO")
			If Empty(_cVar) // Se a conta ED_DEBITO em Branco busca ED_CONTA      
				_cVar := POSICIONE("SED",1,XFILIAL("SED")+SE2->E2_NATUREZ,"SED->ED_CONTA")					
			EndIf		
		EndIf	
		RetCOCT1(_cVar)  
		
	Case _cOpcao = "TMP->CTJ_DEBITO"  //BLOQUEIO CONTAS A PAGAR COM RATEIO
		If !EMPTY(TMP->CTJ_DEBITO)    //Se estiver preenchido a conta contábil no Rateio utiliza ela
			_cVar := TMP->CTJ_DEBITO
		Else
			_cVar := POSICIONE("SED",1,XFILIAL("SED")+M->E2_NATUREZ,"SED->ED_DEBITO")
			If Empty(_cVar) // Se a conta ED_DEBITO em Branco busca ED_CONTA      
				_cVar := POSICIONE("SED",1,XFILIAL("SED")+M->E2_NATUREZ,"SED->ED_CONTA")					
			EndIf		
		EndIf	
		RetCOCT1(_cVar)         
		   
	Case _cOpcao = "SEV->EV_NATUREZ"
		_cVar := POSICIONE("SED",1,XFILIAL("SED")+SEV->EV_NATUREZ,"SED->ED_DEBITO")
		If Empty(_cVar) // Se a conta ED_DEBITO em Branco busca ED_CONTA      
			_cVar := POSICIONE("SED",1,XFILIAL("SED")+SEV->EV_NATUREZ,"SED->ED_CONTA")					
		EndIf		
		RetCOCT1(_cVar)

	Case _cOpcao = "SEZ->EZ_NATUREZ"
		_cVar := POSICIONE("SED",1,XFILIAL("SED")+SEZ->EZ_NATUREZ,"SED->ED_DEBITO")
		If Empty(_cVar) // Se a conta ED_DEBITO em Branco busca ED_CONTA      
			_cVar := POSICIONE("SED",1,XFILIAL("SED")+SEZ->EZ_NATUREZ,"SED->ED_CONTA")					
		EndIf		

		RetCOCT1(_cVar)
		
	Case _cOpcao = "SE5->E5_NATUREZ"  
		If _cVar == "P"        //MOVIMENTO BANCARIO A PAGAR
			_cVarAux := POSICIONE("SED",1,XFILIAL("SED")+SE5->E5_NATUREZ,"SED->ED_DEBITO")
			If Empty(_cVarAux) // Se a conta ED_DEBITO em Branco busca ED_CONTA      
				_cVarAux := POSICIONE("SED",1,XFILIAL("SED")+SE5->E5_NATUREZ,"SED->ED_CONTA")					
			EndIf				
		ElseIf _cVar == "R"
			_cVarAux := POSICIONE("SED",1,XFILIAL("SED")+SE5->E5_NATUREZ,"SED->ED_CREDIT")
			If Empty(_cVarAux) // Se a conta ED_CREDIT em Branco busca ED_CONTA      
				_cVarAux := POSICIONE("SED",1,XFILIAL("SED")+SE5->E5_NATUREZ,"SED->ED_CONTA")					
			EndIf						
		Else
			_cVarAux := ""
		EndIf 
		RetCOCT1(_cVarAux)

	Case _cOpcao = "M->E5_NATUREZ"  
		If _cVar == "P"        //MOVIMENTO BANCARIO A PAGAR
			_cVarAux := POSICIONE("SED",1,XFILIAL("SED")+M->E5_NATUREZ,"SED->ED_DEBITO")
			If Empty(_cVarAux) // Se a conta ED_DEBITO em Branco busca ED_CONTA      
				_cVarAux := POSICIONE("SED",1,XFILIAL("SED")+M->E5_NATUREZ,"SED->ED_CONTA")					
			EndIf				
		ElseIf _cVar == "R"
			_cVarAux := POSICIONE("SED",1,XFILIAL("SED")+M->E5_NATUREZ,"SED->ED_CREDIT")
			If Empty(_cVarAux) // Se a conta ED_CREDIT em Branco busca ED_CONTA      
				_cVarAux := POSICIONE("SED",1,XFILIAL("SED")+M->E5_NATUREZ,"SED->ED_CONTA")					
			EndIf						
		Else
			_cVarAux := ""
		EndIf 
		RetCOCT1(_cVarAux)

		
	Case _cOpcao = "SRD->RD_CO"
		_cRet := POSICIONE("SRV",1,XFILIAL("SRV")+SRD->RD_PD,"SRV->RV_X_CO")

	Case _cOpcao = "SRD->RD_DATARQ"
		//cData := GETMV("MV_FOLMES")	                                                                    
		cData := SRD->RD_DATARQ	  
		
		//Guilherme alterado 29/12/12 porque estava puxando mes 13 no lançamento do PCO tornado o lançamento invalido                                                                  
		Do Case
			Case Substr(cData,5,2) == '02'                                                                
				_cRet := cData+'28'
			Case Substr(cData,5,2) == '13'
				_cRet := Substr(cData,1,4)+'12'+'30'
			OtherWise	
				_cRet := cData+'30'
		End Case		
		// Fim alteração Guilherme 27/12/12
		
		/*If Substr(SRD->RD_DATARQ,5,2) == '02' - Guilherme 04-01-12 readequar mudanças feitas pelo Joel
			_cRet := SRD->RD_DATARQ+'28'
		Else                                 
			_cRet := SRD->RD_DATARQ+'30' 
		EndIf*/
		
	Case _cOpcao = "CTAORIG"
        
        If ISINCALLSTACK("MATA103") //DOCUMENTO DE ENTRADA - Devolução de Vendas
			DbSelectArea("SD2")
			DbSetOrder(3)
			DbGoTop()
			If DbSeek(xFilial("SD2")+SD1->D1_NFORI+SD1->D1_SERIORI+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_COD+SD1->D1_ITEMORI)
				If _cVar == "CONTA"
					RetCOCT1(SD2->D2_CONTA)
				ElseIf _cVar == "CC"
					_cRet := SD2->D2_CCUSTO
				ElseIf _cVar == "CLVL"
					_cRet := SD2->D2_CLVL  
				ElseIf _cVar == "F4_CATEG"
					_cRet := POSICIONE("SF4",1,XFILIAL("SF4")+SD2->D2_TES,"F4_CATOPER")
				EndIf	
			EndIf 
		Else   						//DOCUMENTO DE SAIDA - Devolução de Compras
			DbSelectArea("SD1")
			DbSetOrder(1)
			DbGoTop()
			If DbSeek(xFilial("SD1")+SD2->D2_NFORI+SD2->D2_SERIORI+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_COD+SD2->D2_ITEMORI)
				If SD1->D1_RATEIO # '1'
					If _cVar == "CONTA"
						RetCOCT1(SD1->D1_CONTA)
					ElseIf _cVar == "CC"
						_cRet := SD1->D1_CC
					ElseIf _cVar == "CLVL"
						_cRet := SD1->D1_CLVL  
					EndIf
				Else
					DbSelectArea("SDE")
					DbSetOrder(1)
					DbGoTop()
					If Dbseek(xFilial("SD1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_ITEM)
						If _cVar == "CONTA"
								RetCOCT1(SDE->DE_CONTA)
						ElseIf _cVar == "CC"
							_cRet := SDE->DE_CC
						ElseIf _cVar == "CLVL"
							_cRet := SDE->DE_CLVL  
						EndIf				
					EndIf
				EndIf
			EndIf		
		EndIf
		
		
		
		Case _cOpcao = "000054/99"
			_cRet := IIF(!EMPTY(U_RJPCO01("CT1->CT1_X_CO",SDE->DE_CONTA)).AND.!(SD1->D1_TIPO$"D*B").AND.SD1->D1_RATEIO="1".AND.POSICIONE("SF4",1,XFILIAL("SF4")+SD1->D1_TES,"F4_CATOPER")$'066/068',((SD1->(D1_TOTAL+D1_VALFRE+D1_SEGURO+D1_DESPESA-D1_VALDESC)*SDE->DE_PERC)/100),0)
	
	
	EndCase        
             
             
if !ISINCALLSTACK("PCOA530") .AND. !ISINCALLSTACK("PCOA530ALC")            
	RestArea(aAreaRJ)
endif

Return (_cRet)

/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄt¿
//³Posiciona CT1 retornando Conta Orcamentaria cadastrada.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ENDDOC*/

Static Function RetCOCT1(_cVarAux)

DbSelectArea("CT1")
DbSetOrder(1)
DbSeek(xFilial("CT1")+Alltrim(_cVarAux))
	_cRet := Alltrim(CT1->CT1_X_CO) 

Return(_cRet)


