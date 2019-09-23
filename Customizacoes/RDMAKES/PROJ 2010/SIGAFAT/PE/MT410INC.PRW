#include "rwmake.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT410INC  ºAutor  ³Rafael Parma        º Data ³  20/10/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada chamado após a inclusão do pedido de venda.º±±
±±º          ³Responsável pelo calculo de comissões com base nos contratosº±±
±±º          ³de comissões e regras de desconto de comissões.             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RJU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 

*-------------------------*
User Function MT410INC()
*-------------------------*
Local aArea := GetArea()   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se deve calcular comissão com base em contratos. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    
	If ALLTRIM(SuperGetMV("MV_X_ATCCV",,"N")) == "S"
		MsAguarde( {|| U_RJF410CC() }, "Calculando comissões... Aguarde!")
  	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se deve calcular comissão com base em regras desconto.   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    	
  	If ALLTRIM(SuperGetMV("MV_X_ATCDC",,"N")) == "S"
		MsAguarde( {|| U_RJF410CD() }, "Calculando comissões... Aguarde!")
  	EndIf
  
 	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama o cálculo da Base do Valor Flex na inclusão do pedido de venda ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	
  	MsAguarde( {|| U_BaseFlex() }, "Calculando base do saldo flex... Aguarde!")

 	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Verifica situação tributária dos itens                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	
  	MsAguarde( {|| U_RJF410ST() }, "Verificando situação tributária... Aguarde!")


  
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se pedido esta liberado e seta flag.             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	lRet := .F.
	MsAguarde( {|| lRet := U_RJCHKSC9(SC5->C5_NUM) }, "Verificando liberação do pedido... Aguarde!")		
	If lRet
		If RecLock("SC5",.F.)
			SC5->C5_X_BLQ := "N"
			SC5->(MsUnLock())				
		EndIf
	Else
		If RecLock("SC5",.F.)
			SC5->C5_X_BLQ := "S"
			SC5->(MsUnLock())				
		EndIf	
	EndIf
  
          
	RestArea(aArea)

Return
			

/**********************************************************
 Flavio - 01/05/2011
 Adicionado PE abaixo para situações de copia de pedido, 
 onde deve ser chamado também ponto de entrada para cálculo das comissões
 **********************************************************/
User Function M410STTS()
/* Gustavo 17/03/2017 -- Comentado
local oError 	:=ErrorBlock({|e| CONOUT(PROCNAME()+ CRLF +e:Description + e:ErrorStack)})
local cPathXML 	:= "\salesforce\xml\oportunidade\"
local cNomArqXML:= ""
local cXML		:= ""
local lSFGrvXml := GetMv("MV_X_SFXML",.F.,.T.)
local aRet		:= {}
local lSFCrdCli := GetMv("MV_X_SFCRD",.F.,.T.)  
local _cEmp		:= ""
local _cFil		:= "" 
local cFilZ38	:= ""
local cFilSM0   := ""

if !ExistDir ( cPathXML )
	
	FWMakeDir ( cPathXML, .f.)
	
endif 
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If IsInCallStack(" A410Copia ")
	U_MT410INC()
//ElseIf IsInCallStack( " A410ProcDv " ) 
//ApMsgInfo( " Liberacao " )
//ElseIf IsInCallStack( " A410Altera " ) 
//ApMsgInfo( " Alteracao " )
//ElseIf IsInCallStack( " A410Inclui " ) 
//ApMsgInfo( " Inclusao " )
/* Gustavo 17/03/17 -- Comentado parte SF
ElseIf IsInCallStack( "A410Deleta" ) 
	// DEVAIR 30/03/2015
	// Remove informação de integração com ERP da oportunidade
	
	if SC5->C5_X_ORIPD =='S' .and. !empty(SC5->C5_X_NUMPD) .and. SuperGetMv('MV_X_INTSF', .F. ,.F.)
	    aDados	:= {}
	    
	    aadd(aDados, {"Id",ALLTRIM(SC5->C5_X_NUMPD)})
	    aadd(aDados, {"urn1:fieldsToNull","Codigo_ERP__c"}) 
	    aadd(aDados, {"StageName"	 ,"Proposta"})
	    		
	    
	    //monta XML do cabecalho da nota
		cXML 	:= u_SFMonXML("Opportunity", "update",  aDados)
		
		//grava XML da nota
		if lSFGrvXml      
			cNomArqXML:= cEmpAnt+"_"+ALLTRIM(SC5->C5_FILIAL)+"_"+ALLTRIM(SC5->C5_NUM)+"_"+alltrim(CUSERNAME)+"_"+dtos(date())+time()
   			cNomArqXML:= strtran(cNomArqXML,":","")
			MemoWrite(cPathXML + cNomArqXML+".xml", cXML  )
		endif
		
		aRet	:= {}
		aRet	:= U_SFEnvXml(cXML )    
		
		if aRet[1,1]
				
			Aviso("Integracao SalesForce","Ocorreu o seguinte erro:" + CRLF + "Erro: "+ aRet[1,3], {"Fechar"},3)
		
		endif
		
		//MONTA DADOS DE CREDITO DO CLIENTE	  
		if lSFCrdCli		
			dbSelectArea("SA1")   
			SA1->(dbSetOrder(1))
			SA1->(dbSeek(xFilial('SA1')+SC5->(C5_CLIENTE+C5_LOJACLI)))
			
			//atualiza dados de credito do cliente, após integrado o pedido.
			U_SFCLICRE({SA1->(RECNO())}, lSFGrvXml)
			 
		endif 
		
	elseif SC5->C5_X_ORIPD =='A' .and. !empty(SC5->C5_X_NUMPD)	 
	
		
		dbSelectArea('SA1')         
		SA1->(dbSetOrder(1))
		SA1->(dbSeek(xFilial('SA1')+ SC5->C5_CLIENTE + SC5->C5_LOJACLI))
		
		aAreaSM0:= SM0->(getArea())
		
		cFilSM0:="M0_CGC='"+SA1->A1_CGC+"'"
                
 		dbSelectArea("SC5") 
		SM0->(DBSetFilter ( {||&cFilSM0}, cFilSM0 ))
		SM0->(DBGOTOP())	                
	    if SM0->(!EOF())
		     _cEmp	:= SM0->M0_CODIGO
		     _cFil 	:= SM0->M0_CODFIL
	    endif
		SM0->(dbClearFilter())
		RestArea(aAreaSM0)
		
		
		cFilZ38:= "Z38_FILIAL=='"+xFilial('Z38')+"'"
		cFilZ38+= " .AND. Z38_CODEMP=='"+_cEmp+"'"
		cFilZ38+= " .AND. Z38_CODFIL=='"+_cFil+"'"
		cFilZ38+= " .AND. Z38_PEDSAI=='"+SC5->C5_NUM+"'"    
					
		dbSelectArea("Z38")
		Z38->(DBSetFilter ( {||&cFilZ38}, cFilZ38 ))
		Z38->(DBGOTOP())	                
        
		begin transaction
		do while Z38->(!EOF())
		    reclock('Z38',.F.)
		    Z38->(dbDelete())
		    Z38->(msUnlock()) 
		    Z38->(DBSKIP())
	    enddo            
	    end transaction
	    
		Z38->(dbClearFilter())
		Z38->(dbCloseArea())
		
	endif 
*/
EndIf 
//ErrorBlock(oError)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJF410CC  ºAutor  ³Rafael Parma        º Data ³  20/10/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função de calculo de comissões com base nos contratos de co-º±±
±±º          ³missões do vendedor 1.                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RJU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
*---------------------------*
User Function RJF410CC() 
*---------------------------*
Local aArea := GetArea()
Local lFOUNDC := .F.
Local cCODCON := "" 
Local cNUMPED := SC5->C5_NUM
Local cCODVEN := SC5->C5_VEND1
Local cCODCLI := SC5->C5_CLIENTE
Local cLOJCLI := SC5->C5_LOJACLI 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica a existência de contrato para o vendedor + cliente    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	dbSelectArea("Z12")	//CABECALHO CONTRATOS VENDEDORES
	dbSetOrder(3)	//Z12_FILIAL+Z12_VENDED+Z12_CODCLI+Z12_LOJCLI
	dbGoTop()
    If dbSeek ( xFilial("Z12") + cCODVEN + cCODCLI )
    	While !Z12->(EOF()) .and. Z12->Z12_FILIAL == xFilial("Z12") .and. Z12->Z12_VENDED == cCODVEN .and. Z12->Z12_CODCLI == cCODCLI 
    	    
    	    If !Empty(Z12->Z12_LOJCLI) .and. Z12->Z12_LOJCLI != cLOJCLI
    	    	Z12->(dbSkip())
    	    	Loop
    	    EndIf
    		
    		If Z12->Z12_ATIVO == "S"
    			cCODCON := Z12->Z12_CONTRA
    			lFOUNDC := .T.
    			Exit
    		EndIf
    			
    		Z12->(dbSkip())
    	Enddo
    EndIf


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica a existência de contrato para o vendedor + grupo de clientes    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    
    
    If ! lFOUNDC 	    
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona sobre cliente do pedido                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	        
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek( xFilial("SA1") + cCODCLI + cLOJCLI )       

    	If !Empty(SA1->A1_GRPVEN)		                    
			dbSelectArea("Z12")	//CABECALHO CONTRATOS VENDEDORES
			dbSetOrder(2)	//Z12_FILIAL+Z12_VENDED+Z12_GRPCLI 
			dbGoTop()
		    If dbSeek ( xFilial("Z12") + cCODVEN + SA1->A1_GRPVEN )	    	
		    	While !Z12->(EOF()) .and. Z12->Z12_FILIAL == xFilial("Z12") .and. Z12->Z12_VENDED == cCODVEN .and. Z12->Z12_GRPCLI == SA1->A1_GRPVEN 
		    	    
		    		If Z12->Z12_ATIVO == "S"
		    			cCODCON := Z12->Z12_CONTRA
		    			lFOUNDC := .T.
		    			Exit
		    		EndIf
		    			
		    		Z12->(dbSkip())
		    	Enddo
		    EndIf		
	    EndIf	    
	EndIf


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica a existência de contrato apenas para o vendedor       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    
    If ! lFOUNDC                                     
		dbSelectArea("Z12")	//CABECALHO CONTRATOS VENDEDORES
		dbSetOrder(3)	//Z12_FILIAL+Z12_VENDED+Z12_CODCLI+Z12_LOJCLI
		dbGoTop()
	    If dbSeek ( xFilial("Z12") + cCODVEN )
	    	While !Z12->(EOF()) .and. Z12->Z12_FILIAL == xFilial("Z12") .and. Z12->Z12_VENDED == cCODVEN 
	    	    
	    	    If !Empty(Z12->Z12_CODCLI)
	    	    	Z12->(dbSkip())
	    	    	Loop
	    	    EndIf

	    	    If !Empty(Z12->Z12_GRPCLI)
	    	    	Z12->(dbSkip())
	    	    	Loop
	    	    EndIf
	    		
	    		If Z12->Z12_ATIVO == "S"
	    			cCODCON := Z12->Z12_CONTRA
	    			lFOUNDC := .T.
	    			Exit
	    		EndIf
	    			
	    		Z12->(dbSkip())
	    	Enddo
	    EndIf 	
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se contrato existe                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If lFOUNDC    
		dbSelectArea("Z12")	//CABECALHO CONTRATOS VENDEDORES
		dbSetOrder(1)	//Z12_FILIAL+Z12_CONTRA+Z12_VENDED    
		dbGoTop()
	    dbSeek ( xFilial("Z12") + cCODCON )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se contrato ativo e dentro do intervalo de datas ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
    	If Z12->Z12_ATIVO == "S" .and. SC5->C5_EMISSAO >= Z12->Z12_DATINI .and. SC5->C5_EMISSAO <= Z12->Z12_DATFIN
    		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Percorre itens do pedido de venda                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    		dbSelectArea("SC6")
    		dbSetOrder(1)
    		If dbSeek ( xFilial("SC6") + cNUMPED )
    		    While !SC6->(EOF()) .and. SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUM == cNUMPED

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Posiciona sobre o cadastro de produto.                    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
    		    	dbSelectArea("SB1")
    		    	dbSetOrder(1)
    		    	dbSeek ( xFilial("SB1") + SC6->C6_PRODUTO )

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se o contrato possui o produto do pedido         ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    		    	
    		    	dbSelectArea("Z13")	//ITENS CONTRATOS VENDEDORES 
    		    	dbSetOrder(3)	//Z13_FILIAL+Z13_CONTRA+Z13_CODPRD 
    		    	dbGoTop()
    		    	If dbSeek ( xFilial("Z13") + Z12->Z12_CONTRA + SC6->C6_PRODUTO )

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Altera comissão do item conforme percentual do contrato.       ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    		    		If RecLock("SC6", .F.)
    		    		    SC6->C6_COMIS1 := Z13->Z13_PERCOM
    		    			SC6->(MsUnLock())
    		    		EndIf
    		    		
    		    	Else 

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica se o contrato possui o grupo de produto do pedido     ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	    		    	dbSelectArea("Z13")	//ITENS CONTRATOS VENDEDORES 
	    		    	dbSetOrder(2)	//Z13_FILIAL+Z13_CONTRA+Z13_CODGRP
	    		    	dbGoTop()
	    		    	If dbSeek ( xFilial("Z13") + Z12->Z12_CONTRA + SB1->B1_GRUPO )

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Altera comissão do item conforme percentual do contrato.       ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	    		    		If RecLock("SC6", .F.)
	    		    		    SC6->C6_COMIS1 := Z13->Z13_PERCOM
	    		    			SC6->(MsUnLock())
	    		    		EndIf
	
						Else
							nTAMGRP := TAMSX3("B1_GRUPO")[1] - 2
	    		    		If dbSeek ( xFilial("Z13") + Z12->Z12_CONTRA + SUBSTR(SB1->B1_GRUPO,1,2) + Space(nTAMGRP) , .T. )

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Altera comissão do item conforme percentual do contrato.       ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		    		    		If RecLock("SC6", .F.)
		    		    		    SC6->C6_COMIS1 := Z13->Z13_PERCOM
		    		    			SC6->(MsUnLock())
		    		    		EndIf
		    				
		    				EndIf
						
						EndIf	    		    	
    		    	
    		    	EndIf
    		    	
    		    	SC6->(dbSkip())    		    	
    		    Enddo
    		EndIf
    		
    	EndIf    
	EndIf

	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJF410CD  ºAutor  ³Rafael Parma        º Data ³  20/10/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para calculo de desconto de comissões com base sobre º±±
±±º          ³as regras de desconto de comissões.                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RJU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
*---------------------------*
User Function RJF410CD() 
*---------------------------*
Local aArea := GetArea()
Local lFOUNDR := .F.
Local cCODREG := ""
Local cNUMPED := SC5->C5_NUM
Local cCODVEN := SC5->C5_VEND1
Local cCODCLI := SC5->C5_CLIENTE
Local cLOJCLI := SC5->C5_LOJACLI
Local nPerDesc := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Percorre itens do pedido de venda                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SC6")
	dbSetOrder(1)
	If dbSeek ( xFilial("SC6") + cNUMPED )
		
		While !SC6->(EOF()) .and. SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUM == cNUMPED
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se o item possui desconto                        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
			// C6_PRCTAB - C6_PRCVEN
			//If SC6->C6_DESCONT != 0
			// Flavio - alterado para buscar o desconto de acordo com o campo C6_PRCTAB
			if (SC6->C6_PRCTAB - SC6->C6_PRCVEN) > 0
			  nPerDesc := ((SC6->C6_PRCTAB - (SC6->C6_X_VLORI / SC6->C6_QTDVEN)) / SC6->C6_PRCTAB) * 100

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona sobre o cadastro de produto.                    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
				dbSelectArea("SB1")
			  dbSetOrder(1)
			  dbSeek ( xFilial("SB1") + SC6->C6_PRODUTO )
			
				lFOUNDR := .F.


				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se existe regra de desconto para o vendedor      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				dbSelectArea("Z14")	//CABECALHO DESCONTOS COMISSOES
				dbSetOrder(2)	//Z14_FILIAL+Z14_CODVEN
				dbGoTop()
				If dbSeek ( xFilial("Z14") + cCODVEN )
					While !Z14->(EOF()) .and. Z14->Z14_FILIAL == xFilial("Z14") .and. Z14->Z14_CODVEN == cCODVEN						
						If Z14->Z14_ATIVO == "S"
							cCODREG := Z14->Z14_CODIGO
							lFOUNDR := .T.	
							Exit
						EndIf						
						Z14->(dbSkip())
					Enddo				
				EndIf 

				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se existe regra de desconto para o supervidor do vendedor       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								
				If ! lFOUNDR
	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Posiciona sobre o cadastro do vendedor                    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					
					dbSelectArea("SA3")
					dbSetOrder(1)
					dbSeek( xFilial("SA3") + cCODVEN )
					
					If !Empty(SA3->A3_SUPER)  
					
						dbSelectArea("Z14")	//CABECALHO DESCONTOS COMISSOES
						dbSetOrder(3)	//Z14_FILIAL+Z14_CODSUP
						dbGoTop()
						If dbSeek ( xFilial("Z14") + SA3->A3_SUPER )
							While !Z14->(EOF()) .and. Z14->Z14_FILIAL == xFilial("Z14") .and. Z14->Z14_CODSUP == SA3->A3_SUPER						
								If Z14->Z14_ATIVO == "S"
									cCODREG := Z14->Z14_CODIGO
									lFOUNDR := .T.	
									Exit
								EndIf						
								Z14->(dbSkip())
							Enddo				
						EndIf 
					EndIf
				
				EndIf
			
			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se existe regra de desconto para o gerente do vendedor          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								
				If ! lFOUNDR
	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Posiciona sobre o cadastro do vendedor                    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					
					dbSelectArea("SA3")
					dbSetOrder(1)
					dbSeek( xFilial("SA3") + cCODVEN )
					
					If !Empty(SA3->A3_GEREN)  
					
						dbSelectArea("Z14")	//CABECALHO DESCONTOS COMISSOES
						dbSetOrder(4)	//Z14_FILIAL+Z14_CODGER
						dbGoTop()
						If dbSeek ( xFilial("Z14") + SA3->A3_GEREN )
							While !Z14->(EOF()) .and. Z14->Z14_FILIAL == xFilial("Z14") .and. Z14->Z14_CODGER == SA3->A3_GEREN						
								If Z14->Z14_ATIVO == "S"
									cCODREG := Z14->Z14_CODIGO
									lFOUNDR := .T.	
									Exit
								EndIf						
								Z14->(dbSkip())
							Enddo				
						EndIf 
					EndIf
				
				EndIf
			

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se encontrou a regra e realiza demais validações ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ							
		
		    If lFOUNDR    
		        
					dbSelectArea("Z14")	//CABECALHO DESCONTOS COMISSOES
					dbSetOrder(1)	//Z14_FILIAL+Z14_CODIGO                                                                                                                                           
					dbSeek ( xFilial("Z14") + cCODREG )		                                                 
		        
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se regra ativa e dentro do intervalo de datas    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
			    	If Z14->Z14_ATIVO == "S" .and. SC5->C5_EMISSAO >= Z14->Z14_DATINI .and. SC5->C5_EMISSAO <= Z14->Z14_DATFIN
			    	
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Percorre itens da regra para determinar o percentual de desconto com base no desconto do item.   ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			    		dbSelectArea("Z15")	//ITENS DESCONTOS COMISSOES 
			    		dbSetOrder(1)	//Z15_FILIAL+Z15_CODIGO+Z15_ITEM
			    		dbGoTop()	
			    		If dbSeek ( xFilial("Z15") + Z14->Z14_CODIGO )
			    		    While !Z15->(EOF()) .and. Z15->Z15_FILIAL == xFilial("Z15") .and. Z15->Z15_CODIGO == Z14->Z14_CODIGO
			    		      
			    		      // Flavio - implementado o controle do grupo de produto e do produto, permitindo também que se deixado
			    		      // em branco seja considerado para todos
			    		      // Pode-se também usar somente os dois primeiros dígitos do grupo			    		      
	                  if (Empty(Z15->Z15_CODGRP) .AND. Empty(Z15->Z15_CODPRD)) ;
	                  		.OR. (Z15->Z15_CODPRD == SB1->B1_COD);
	                  		.OR. (Z15->Z15_CODGRP == SB1->B1_GRUPO);
	                  		.OR. (TRIM(Z15->Z15_CODGRP) == SUBSTR(SB1->B1_GRUPO, 1, 2))
	                  // Flavio - alterado para buscar o desconto de acordo com o campo C6_PRCTAB
	                             // SC6->C6_DESCONT                // SC6->C6_DESCONT  	                  	
		                  If nPerDesc >= Z15->Z15_PRCINI .and. nPerDesc <= Z15->Z15_PRCFIN
				    		    		If RecLock("SC6", .F.)
				    		    		  SC6->C6_COMIS1 := SC6->C6_COMIS1 - ( (SC6->C6_COMIS1 * Z15->Z15_PRCDES) / 100 )
				    		    			SC6->(MsUnLock())
				    		    		EndIf
				    		    		// flavio - 06/05/2011 
				    		    		// se encontra um registro com o desconto cadastrado, pula e nao faz novamente o desconto
				    		    		Exit

		                  EndIf
	                  EndIf
	                        	
								Z15->(dbSkip())
							Enddo
						EndIf
					
					EndIf
					
				EndIf
				
      EndIf
            
		SC6->(dbSkip())    		    	
		
  	Enddo
	
	EndIf

Return

User Function BaseFlex()

Local aArea := GetArea()
Local cFil := SC5->C5_FILIAL
Local cPedido := SC5->C5_NUM
Local cArmaz := ""
Local nVlrTab := 0
Local nDesc := 0                          
Local nBaseFlex := 0

DbSelectArea("SC6")
DbGoTop()
DbSeek(cFil + cPedido) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

While !SC6->(EOF()) .and. SC6->C6_FILIAL == cFil .and. SC6->C6_NUM == cPedido
	cArmaz := SC6->C6_LOCAL
	nVlrTab := SC6->C6_PRCTAB
	
	nDesc := Posicione("SZA", 1, cFil + cArmaz, "ZA_DESCSYN")
	nDesc := nDesc/100
	
	nBaseFlex := Round(nVlrTab - (nVlrTab * nDesc),2)
	
	RecLock("SC6", .F.)
		SC6->C6_X_SFLEX := nBaseFlex	
	MsUnlock("SC6")
	
	SC6->(DbSkip())
End

RestArea(aArea)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJF410ST  ºAutor  ³Rafael Parma        º Data ³  22/11/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função de input sobre campo de situação tributária do pedido.±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RJU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
*---------------------------*
User Function RJF410ST() 
*---------------------------*
Local aArea := GetArea()
Local cNUMPED := SC5->C5_NUM

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Percorre itens do pedido de venda                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SC6")
	dbSetOrder(1)
	If dbSeek ( xFilial("SC6") + cNUMPED )
		
		While !SC6->(EOF()) .and. SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUM == cNUMPED
		    
			cTRIB := ""
			cORIG := ""

			dbSelectArea("SBZ")
			dbSetOrder(1)
			dbGoTop()
			If dbSeek ( xFilial("SBZ") + SC6->C6_PRODUTO )
				cORIG := SUBSTR(SBZ->BZ_ORIGEM,1,1)
			Else
				dbSelectArea("SB1")
				dbSetOrder(1)
				dbGoTop()
				dbSeek ( xFilial("SB1") + SC6->C6_PRODUTO )
				cORIG := SUBSTR(SB1->B1_ORIGEM,1,1)
			EndIf

			dbSelectArea("SF4")
			dbSetOrder(1)
			If dbSeek( xFilial("SF4") + SC6->C6_TES )
				cTRIB := SF4->F4_SITTRIB
			EndIf		
		           
			If cTRIB != "" .and. cORIG != ""
				If SC6->C6_CLASFIS != cORIG+cTRIB
					If RecLock("SC6",.F.)
						SC6->C6_CLASFIS := cORIG+cTRIB
						SC6->(MsUnLock())
					EndIf
				EndIf
			EndIf
			
			SC6->(dbSkip())
		Enddo
	
	EndIf

Return
