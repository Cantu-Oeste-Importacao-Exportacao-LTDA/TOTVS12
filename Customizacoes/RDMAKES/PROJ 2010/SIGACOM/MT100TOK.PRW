#include "protheus.ch"
#include "topconn.ch"
#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100TOK  ºAutor  ³Rafael Parma       º Data ³  01/10/2010  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada acionado após o usuario confirmar a inclusão±±
±±º          ³do documento de entrada.                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/    
*----------------------------*
User Function MT100TOK() 
*----------------------------*
Local aArea    := GetArea()
Local lRetPAD  := PARAMIXB[1]
Local cMVATCFC := ALLTRIM(SuperGetMV("MV_X_ATCFC",,"N"))
Local cMVAPRGB := ALLTRIM(SuperGetMV("MV_X_APRGB",,"N"))
Local _lEmpGrp := .F.  
Local cNatureza := MaFisRet(,"NF_NATUREZA")  
Local nPosTes := aScan(aHeader,{|x| AllTrim(x[2])=="D1_TES"})
Local cFormpg := ALLTRIM(SA2->A2_FORMPAG)


Public __lDOCDEV := .F.                                       

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

U_USORWMAKE(ProcName(),FunName())


//-- 02/06/15 - VALIDA SE É CHAMADA DA ROTINA DE CLASSIFICAÇÃO AUTOMATICA DE CTE³
//-- 29/12/16 - VALIDA SE É CHAMADA PELA ROTINA DE INUTILIZAÇÃO
if !ISINCALLSTACK("U_SCHCLACTE") .and. !ISINCALLSTACK("SPEDINUT")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Retorno das validações padrões                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		

	If ! lRetPAD
		Return (lRetPAD)
		
	ElseIf ALLTRIM(FUNNAME()) == "MATA920"
		Return (lRetPAD)
		
	Else 
	
		//-- Adiciona zeros antes do número do documento		
		
		//Gustavo 22/01/15 - Alterado para validar casos em que o formulário é branco
		
		//If CFORMUL == "N"
		If CFORMUL != "S" 
			If Len(ALLTRIM(cNFiscal)) < TamSX3("F1_DOC")[1]
				cNFiscal := STRZero(Val(cNFiscal),TamSX3("F1_DOC")[1])	
			EndIf
		EndIf                                
		
		//-- Validação sobre segmento, centro de custo e conta contabil.
		lRetPAD := fCheckCTB()
		
		//-- Validação sobre preenchimento de campos para documento de devolução.
		lRetPAD := fCheckDEV()
		
		//-- Validações documento de importação
		If lRetPAD
			If ALLTRIM(SuperGetMV("MV_X_ACIMP",,"N")) == "S"
				If POSICIONE("SA2",1,xFilial("SA2")+CA100FOR+CLOJA,"A2_EST") == "EX"
		
					If ValType(__nVLRMAME) == "N" 

						If __cNUMDI != Space(20) .and. ( __cLOCDES == Space(60) .or. __cUFDES == Space(02) .or. __dDATDI == ctod("") .or. __dDATDES == ctod("") )
							Aviso("Atenção", "Favor preencher os demais campos referente a DI (Data Registro DI, Local Desembaraço DI, UF Desembaraço DI, Data Desembaraço DI), verifique!", {"OK"}, 2)
							lRetPAD := .F.						
						EndIf
						
						If __nVLRMAME > 0
							If __cFORMME == Space(TamSX3("D1_FORNECE")[1]) .or. __cLOJMME == Space(TamSX3("D1_LOJA")[1])
								Aviso("Atenção", "O fornecedor referente a Marinha Mercante de Importação não foi informado, verifique!", {"OK"}, 2)
								lRetPAD := .F.
							EndIf
						EndIf                       

						If MaFisRet(,"NF_SEGURO") > 0 .and. ( __cFORSEG == Space(TamSX3("D1_FORNECE")[1]) .or. __cLOJSEG == Space(TamSX3("D1_LOJA")[1]) )
							Aviso("Atenção", "O fornecedor referente ao SEGURO de Importação não foi informado, verifique!", {"OK"}, 2)
							lRetPAD := .F.						
						EndIf						
						
						If SubSTR(__cTIPOFRT,1,1) == "A" .AND. ( cEmpAnt $ "30/60" .OR. ( cEmpAnt == "50" .and. cFilAnt == "11" ) )
							If __cFORFRT == Space(TamSX3("D1_FORNECE")[1]) .or. __cLOJFRT == Space(TamSX3("D1_LOJA")[1])
								Aviso("Atenção", "O fornecedor referente ao FRETE de Importação não foi informado, verifique!", {"OK"}, 2)
								lRetPAD := .F.
							ElseIf MaFisRet(,"NF_FRETE") == 0 .or. ( __vVFRTHC == 0 .and. __cMOEDA != "Reais (R$)" )
								Aviso("Atenção", "O valor de FRETE A PAGAR de Importação não foi informado, verifique!", {"OK"}, 2)
								lRetPAD := .F.						
							EndIf						
						EndIf
					
					EndIf
				EndIf
			EndIf
		EndIf        
		
		// VALIDAÇÃO DE ESPECIE DE NOTA FISCAL - GUILHERME 14/04/11
   /*	If lRetPAD                                                        		
	  	Do Case
	  		Case Alltrim(cEspecie) == "NFCF" .or. Alltrim(cEspecie) == "NFPS" .or. Alltrim(cEspecie) == "NFS" .or. Alltrim(cEspecie) == "RPS" .or. Alltrim(cEspecie) == "NTST" .or. Alltrim(cEspecie) == "NTSC"
				MsgBox("Especie de nota ("+Alltrim(cEspecie)+") utilizada somente para operações de saída no grupo Cantu!!","Alerta","ERRO")
				lRetPAD := .F. 
	 		End Case
		EndIf
  */			
		// FIM - GUILHERME 14/04/11
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Validação da forma e condição de pagamento.³
		//³Edison G. Barbieri             19/02/2019  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If lRetPAD                                                        		
			Do Case
				Case !Alltrim(M->cTipo) $ "D/I/P/B/C" .and. Empty(cFormpg)  
					 MsgBox("Divergencia na forma de pagamento para este fornecedor, favor entrar em contato com o cadastro, tel: 46 2101-4091, após ajuste refaça o lançamento!","Alerta","ERRO")
					 lRetPAD := .F.
				 	   
			End Case
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Validação de desconto condicional retorno.³
		//³Edison G. Barbieri             11/04/2019  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If lRetPAD
		   DbSelectArea("Z16")
		   DbSetOrder(03)
		   
		   If dbSeek( xFilial("Z16") + CA100FOR)
		   		If Alltrim(M->cTipo) == "D" .and. Z16_REGRA == "C" .and.  Z16_ATIVO = 'S'
		   			MsgBox("Cliente cadastrado com desconto condicional, verifique se o boleto esta corretamente com o seu devido desconto, em caso de divergência, favor entrar em contato com o cliente!","Alerta","ERRO")		
		   			lRetPAD := .T.
		   		EndIf	
		   EndIf
		   
		EndIf
  
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Validação da especie, caso cte obrigório. ³
		//³necessario informar a UF origem/destino   ³
		//³Edison G. Barbieri             12/07/2019 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
     
  
		If Alltrim(M->cEspecie) == "CTE" 	  	 
	  	   Aviso( "Lançamento de Cte!", "necessário informar os campos Uf Origem e Destino da aba Informações Adicionais, caso não informado, cancelar a tela a seguir e informar.")
	  	Endif
		
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Validação do código da natureza informada.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		/*
		if lRetPAD
			DbSelectArea("SED")
			DbSetOrder(01)

			if DbSeek(xFilial("SED")+AllTrim(cNatureza))
			    DbSelectArea("SF1")
			    DbSetOrder(1)
                  If dbSeek( xFilial("SF1") + CNFISCAL + CSERIE + CA100FOR + CLOJA)	        
				    RecLock("SF1", .F.)
				    SF1->F1_NATUREZ := cNatureza
				    SF1->(MsUnlock())                                              
				  EndIf
			Else
				Alert("Você deve informar uma natureza válida!")
				lRetPAD := .F.	
			EndIf
		EndIf    */

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se controla conferência cega na classificação       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		
		If lRetPAD .and. cMVATCFC == "S" 
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se é classificação                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
			If ALTERA
			
				dbSelectArea("SF1")
				dbSetOrder(1)	//F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
				dbGoTop()
				If dbSeek ( xFilial("SF1") + CNFISCAL + CSERIE + CA100FOR + CLOJA )			
					If Empty(SF1->F1_STATUS) .and. !Empty(SF1->F1_X_CODCC) 
	
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Checagem dos itens lançados na conferência cega p/ doc       ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						MsAguarde( {|| lRetPAD := fChkCONF( CNFISCAL, CSERIE, CA100FOR, CLOJA, SF1->F1_X_CODCC ) }, "Checando conferência cega...")							
						
						If ! lRetPAD
							Aviso("Atenção", "O processo de conferência cega ainda não foi realizado para este documento, verifique!", {"OK"}, 2)
						Else
							While U_RJWINDES(CNFISCAL, CSERIE, CA100FOR, CLOJA, SF1->F1_X_CODCC) != 1
							Enddo							
						EndIf
						
					EndIf			
				EndIf
			
			EndIf 
					
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Realiza controle de único pedido por documento.              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		If lRetPAD .and. cMVAPRGB == "S"
			
			lRetPAD := fChkFCPED()
			
			If ! lRetPAD
				Aviso("Atenção", "Não é possível inserir o documento de entrada utilizando produto com pedido e produto sem pedido!", {"OK"}, 2)
			EndIf
			
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Realiza controle sobre CFOPs e especie do documento.         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
	    // Comentado por Guilherme 03/02/17 a pedido da Joziane do Fiscal para poder lançar um CT-e de Ativo onde o CFOP nao atende a regra, 
	    //   e voltado apos o termino do lançamento, quem fez o lançamento foi a jaqueline.
		If lRetPAD
			lRetPAD := fValCFOP()
		EndIf
		
		// Valida os rateios - Verificar ainda
		
 		If lRetPAD
			lRetPAD := U_ValRatCC()    
		EndIf

	EndIf
	
	// Validacoes do usuário se pode ou nao incluir e validacao de cfop
	if (lRetPAD)
		lObrigPed := .F.
		lPedOK := .T.		
		nPosPed := aScan(aHeader, { |x| x[2] = "D1_PEDIDO"})
		
		// faz validação do CFOP informado apenas para recife
		if (cEmpAnt == "20")
			lRetPAD := lRetPAD .And. U_ValCFOP()
		EndIf
		// Adriano 19/01/2011
		_lEmpGrp	:= .F. 
		dbSelectArea("SF1")
		dbSetOrder(1)	//F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
		dbGoTop()
		If dbSeek ( xFilial("SF1") + CNFISCAL + CSERIE + CA100FOR + CLOJA )
			If SF1->F1_FORGRP == 'S'
				_lEmpGrp := .T.	       
			Endif
		Endif
		// verifica se o arquivo existe
		if (lRetPAD) .And. MsFile( "SZK" + cEmpAnt + "0" , NIL , __cRdd ) .AND. !_lEmpGrp
			DBSelectArea("SZK")
			SZK->(DbSetOrder(01))
			lObrigPed := SZK->(DbSeek(xFilial("SZK") + AllTrim(cUserName)))  
		EndIf
		
		if (lObrigPed)
		  for i:= 1 to len(aCols)
		    lPedOK := lPedOK .And. !Empty(aCols[i, nPosPed])
		    if !lPedOk
		      Exit
		    EndIf
		  Next
		EndIf   
		// Adriano 19/01/2011		
		If _lEmpGrp
			lPedOK := .T.	
		Endif
		if (!lPedOK) .And. (cTipo == "N")
			lRetPAD := .F.
			Alert("O usuário atual não tem permissão para incluir documento de entrada sem pedido de compra - Importação xml.")
		EndIf	
	EndIf
	
	if (lRetPAD)
		lRetPAD :=	ValGrProd()
		If !(lRetPAD) .AND. !_lEmpGrp
			Alert("O usuário atual não tem permissão para incluir documento de entrada sem pedido de compra.")
		Endif
	EndIf     
	
	// Jean - Avalia se a conta contabil do item da nota é o mesmo da linha do item no pedido para garantir saldo do PCO.
	if (lRetPAD)
		lRetPAD := fValCtaCtbl()
	EndIf
	    
	// Adriano 19/01/2011
	If _lEmpGrp 
		lRetPAD := .T.
	Endif

	// Flavio - Se for entrada referente a outra empresa, então busca os lotes dos produtos
	if (_lEmpGrp .And. cFormul == "N")
		ObtemLotes()
	EndIf   
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Regras de obrigatoriedade de informação de Rateio CC na inclusão do documento de entrada³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
/*
  //Alteração realizada pelo Marcelo, porém não foi continuado e estava dando problema.
	If Len(aBackColsSDE) <= 0
	    Alert("Favor informar os dados de Rateio de CC para nota fiscal") 
		lRetPAD := .F.
	EndIf
*/
   
    //Gustavo 11/06/2014 - Não permitir que a natureza seja em branco quando a TES gerar duplicata.
   		For nI := 1 to len(aCols)
 			dbSelectArea("SF4")
 			dbSetOrder(1)
 			dbGoTop()
 			If dbSeek( xFilial("SF4") + aCols[nI][nPosTes] )
				If SF4->F4_DUPLIC == "S" .and. Trim(cNatureza) == ""
					MsgAlert("Natureza obrigatória quando a TES gera duplicata.","Natureza Obrigatória")
					lRetPAD := .F.
				//Não permitir que seja utilizada uma TES que gere financeiro quando for transferência entre filiais
				ElseIf SF4->F4_DUPLIC == "S" .And. AllTrim(CA100FOR) == AllTrim(SUBSTR(SM0->M0_CGC,1,8)) .And. !SF4->F4_CODIGO $ SuperGetMV("MV_X_TESTR",.F.,"")
					lRetPAD := .F.
					ShowHelpDlg("Atenção",{"Não é possível fazer transferência entre filiais com TES que movimente financeiro."}, 5,{"Verifique a TES informada."}, 5)
				EndIf
			EndIf
		Next
	//Fim Gustavo 11/06/2014

EndIf          

RestArea(aArea)
	
Return (lRetPAD)    


// Valida se o usuário pode incluir documento de entrada
Static Function ValGrProd()
Local lGrpOK := .T.
Local i
Local lBloqUser := .F.
Local nPosProd := aScan(aHeader, { |x| x[2] = "D1_COD"}) 
Local nPosPed := aScan(aHeader, { |x| x[2] = "D1_PEDIDO"})
Local cProduto := ""
Local nPosDel  := Len(aHeader) + 1
// verifica se o alias existe
if MsFile( "SZH" + cEmpAnt + "0" , NIL , __cRdd )
	DBSelectArea("SZH")
	SZH->(DbSetOrder(01))
	lBloqUser := .T. //SZH->(DbSeek(xFilial("SZH") + AllTrim(cUserName)))
EndIf

If cTipo == "N"	
	If lBloqUser                                                                    		
		lGrpOK := .F.
		SB1->(dbSetOrder(01))
		// verifica se o usuário está cadastrado para liberacao de alguns grupos
		For i := 1 to len(aCols)
			// Valida se está excluído
			If (aCols[i][nPosDel])
				Loop
			EndIf
			// BUSCA O PRODUTO
			SB1->(DbSeek(xFilial("SB1") + aCols[i, nPosProd]))
			
			// busca se o grupo de produto está liberado
			// Se tiver pedido é liberado para inserir docuemnto de entrada
			// nao preenchido (linha em branco) ou se tem pedido deixa passar
		  lGrpOK := (AllTrim(aCols[i, nPosProd]) == "") .Or. !Empty(aCols[i, nPosPed]) 
		  
		  if !lGrpOk
		  	// Valido se bloqueia tudo.
				SZH->(DBSelectArea("SZH"))
				SZH->(DbSetOrder(01))
				If SZH->(DbSeek(xFilial("SZH") + AllTrim(cUserName)))
					_cChave	:= xFilial("SZH")+AllTrim(cUserName)
					While !SZH->(Eof()) .AND. SZH->ZH_FILIAL+ALLTRIM(SZH->ZH_USER) == _cChave .And. !lGrpOk
						If Len(AllTrim(SZH->ZH_GRUPO)) == 2 						
							If SubStr(SB1->B1_GRUPO,1,2) == AllTrim(SZH->ZH_GRUPO)
								If Empty(SZH->ZH_PRODUTO)
									lGrpOk := .T.
								ElseIf aCols[i, nPosProd] == SZH->ZH_PRODUTO
									lGrpOk := .T.
								EndIf
							Endif
						Endif
						If Len(AllTrim(SZH->ZH_GRUPO)) == 4
							If SubStr(SB1->B1_GRUPO,1,4) == SZH->ZH_GRUPO
								If Empty(SZH->ZH_PRODUTO)
									lGrpOk := .T.
								ElseIf aCols[i, nPosProd] == SZH->ZH_PRODUTO
									lGrpOk := .T.
								EndIf
							Endif
						Endif
						
						SZH->(DbSkip())
					End
				Endif
	                                
			  	// Valido se bloqueia tudo.
				SZH->(DBSelectArea("SZH"))
				SZH->(DbSetOrder(01))
				If SZH->(DbSeek(xFilial("SZH") + AllTrim(cUserName)))
					_cChave	:= xFilial("SZH")+AllTrim(cUserName)
					While !SZH->(Eof()) .AND. xFilial("SZH")+AllTrim(SZH->ZH_USER) == _cChave 
						If AllTrim(SZH->ZH_GRUPO) == "0"
							lGrpOk := .T.
						Endif
						SZH->(DbSkip())
					End
				Endif

		  	
		  	// SZH->(DbSeek(xFilial("SZH") + PadR(AllTrim(cUserName), 20)) .Or. ;
		  EndIf
		  	
		  if !lGrpOK
		  	cProduto := aCols[i, nPosProd]
		  	Exit
		  EndIf
		Next
	else
		lGrpOK := .T.	
	EndIf
	
	If (!lGrpOK) .and. !(lPedOK)
		Alert("O usuário atual não tem permissão para Incluir/Classificar documento de entrada para o produto " + cProduto + ".")
	EndIf
EndIf
	
Return lGrpOK


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fChkCONF  ºAutor  ³Rafael Parma       º Data ³  01/10/2010  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável por checar os itens lançados na confe-   º±±
±±º          ³rência cega para o documento de entrada.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
                
*-------------------------------------------------------------------------*
Static Function fChkCONF( cDOCSF1, cSERSF1, cFORSF1, cLOJSF1, cCODCC )
*-------------------------------------------------------------------------*
Local lDIV    := .F.
Local aDADOS  := {} 
Local nPOSITE := aScan(aHeader,{|x| AllTrim(x[2])=="D1_ITEM"})
Local nPOSPRD := aScan(aHeader,{|x| AllTrim(x[2])=="D1_COD"})
Local nPOSQTD := aScan(aHeader,{|x| AllTrim(x[2])=="D1_QUANT"})
Local nPOSLOC := aScan(aHeader,{|x| AllTrim(x[2])=="D1_LOCAL"})
Local cARMBEN := ALLTRIM(SuperGetMV("MV_X_LCBEN",,"BENEFI"))
Local lDEVAUT := IIF(ALLTRIM(SuperGetMV("MV_X_DEVAU",,"N"))=="S",.T.,.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona sobre registro de conferência cega                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	dbSelectArea("Z00")
	dbSetOrder(1)	//Z00_FILIAL+Z00_COD
	dbGoTop()
	If dbSeek ( xFilial("Z00") + cCODCC )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Conferência cega não realizada				                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		If Empty(Z00->Z00_DTCON) 
			Return (.F.)
		EndIf
		
		dbSelectArea("Z01")
		dbSetOrder(1)	//Z01_FILIAL+Z01_COD+Z01_DOC+Z01_SERIE+Z01_FORNEC+Z01_LOJA
		dbGoTop()
		If dbSeek ( xFilial("Z01") + Z00->Z00_COD + cDOCSF1 + cSERSF1 + cFORSF1 + cLOJSF1 + cCODCC )

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Percorre itens do documento de entrada                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			For nI := 1 to Len(aCols)              

				If !aCols[nI][Len(aCols[nI])]
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Percorre produtos da conferência cega                        ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					lFound := .F.
					dbSelectArea("Z02")
					dbSetOrder(3)	//Z02_FILIAL+Z02_COD+Z02_ITEM+Z02_PRODUT
					dbGoTop()
					If dbSeek ( xFilial("Z02") + Z00->Z00_COD + aCols[nI][nPOSITE] + aCols[nI][nPOSPRD] )
						lFound := .T.
					Else
						dbSelectArea("Z02")
						dbSetOrder(1)	//Z02_FILIAL+Z02_COD+Z02_PRODUT
						dbGoTop()
						If dbSeek ( xFilial("Z02") + Z00->Z00_COD + aCols[nI][nPOSPRD] )
							lFound := .T.
						EndIf	
					EndIf
					
					If lFound
					
						
						If aCols[nI][nPOSQTD] != Z02->Z02_QUANT
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Produto com quantidade divergente                            ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ						
							lDIV := .T.
						EndIf
						aAdd ( aDADOS, { Z00->Z00_COD, aCols[nI][nPOSPRD], aCols[nI][nPOSQTD], Z02->Z02_QUANT, aCols[nI][nPOSITE] } )					
						
						
						//-- Controle de devolução automática --//
						If lDEVAUT
							//-- Verifica situação dos produtos, para posterior inclusão documento devolução. --//
							If Z02->Z02_SITPRD $ "P/R"	// Situação = PESSIMO ou RUIM
								__lDOCDEV := .T.
							EndIf

							//-- Verifica quantidade recebida x nota fiscal, para posterior inclusão documento devolução. --//
							If Z02->Z02_QUANT < aCols[nI][nPOSQTD]
								__lDOCDEV := .T.
							EndIf
							
							//-- Verifica se o produto irá para o armazém de beneficiamento. --//

							If Z02->Z02_DESTIN == "B"	// Desinação = BENEFICIAMENTO
								aCols[nI][nPOSLOC] := cARMBEN
							EndIf
						EndIf
						
					EndIf
				EndIf 
	
			Next nI				
			
			If lDIV
			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Envia workflow                                               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ				
				fWFCONFC(aDADOS, cDOCSF1, cSERSF1, cFORSF1, cLOJSF1)
				Aviso("Atenção", "Existem divergências entre as quantidades da conferência cega e documento classificado!", {"OK"}, 2)

			EndIf
		
		Else
			Aviso("Atenção", "Este documento não está relacionado a conferência cega do documento. Informe ao Administrador!", {"OK"}, 2)
		EndIf
	Else
		Aviso("Atenção", "Conferência cega relacionada ao documento não localizada. Informe ao Administrador!", {"OK"}, 2)
	EndIf

Return (.T.)               


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fWFCONFC  ºAutor  ³Rafael Parma       º Data ³  01/10/2010  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável por enviar workflow de divergências de   º±±
±±º          ³quantidades entre documento x conferência cega.             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*----------------------------------------------------------------------*
Static Function fWFCONFC(aDADOS, cDOCSF1, cSERSF1, cFORSF1, cLOJSF1)
*----------------------------------------------------------------------*
Local oProcess
Local cEmail  := ""
Local nTOTDIV := 0
Local aArea   := GetArea()
    
	conout("WF - WFCONFC - INICIO DO ENVIO DE EMAIL - CONFERENCIA CEGA ")
	
	// Busca o email da configuracao
	cEmail  := ALLTRIM(Posicione("ZWF", 01, xFilial("ZWF") + "WFCONFC", "ZWF_EMAIL"))
	If ALLTRIM(cEmail) == ""
	    MsgAlert("E-mail não cadastrado para o processo: WFCONFC")
		Return 
	EndIf                           
	
	// Busca o email do solicitante
	dbSelectArea("DUE")		//Tabela de solicitante
	dbSetOrder(1)	//DUE_FILIAL+DUE_DDD+DUE_TEL 
	dbGoTop()
	If !dbSeek( xFilial("DEU") + DT5->DT5_DDD + DT5->DT5_TEL )
		
		Return
	Else
	EndIf

	oProcess := TWFProcess():New( "WFCONFC", "Conferência Cega")
	oProcess:NewTask( "WFCONFC", "\workflow\WFCONFC.html")
	
	oProcess:cSubject :=  "WF - DIVERGÊNCIA DOCUMENTO DE ENTRADA X MAPA CONFERÊNCIA CEGA" 
							
	oHTML := oProcess:oHTML
	                                             
	oHtml:ValByName("EMPRESA", ALLTRIM(UPPER(SM0->M0_NOME)) + " - " + ALLTRIM(UPPER(SM0->M0_FILIAL))	)
	oHtml:ValByName("DOCUMEN", cDOCSF1 +"/"+ cSERSF1	)
	oHtml:ValByName("FORNECE", cFORSF1+"/"+cLOJSF1+"-"+ALLTRIM(Posicione("SA2",1,xFilial("SA2")+cFORSF1+cLOJSF1,"A2_NOME"))	)						
	oHtml:ValByName("CODCONF", aDADOS[1][1]		)	
	oHtml:ValByName("DATABAS", dtoc(ddatabase)	)
	oHtml:ValByName("USUARIO", ALLTRIM(UPPER(CUSERNAME))	)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processa itens do array                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	For nI := 1 to Len(aDADOS)	
		nQTDDIV := aDADOS[nI][4] - aDADOS[nI][3]
		nTOTDIV += nQTDDIV
	  	AAdd((oHtml:ValByName("IT.PRODUT" )), aDADOS[nI][5]+"-"+aDADOS[nI][2]+"/"+Posicione("SB1",1,xFilial("SB1")+aDADOS[nI][2],"B1_DESC")	)     
	 	AAdd((oHtml:ValByName("IT.QTDDOC" )), Transform(aDADOS[nI][3], "@E 999,999,999.99")	)     
	  	AAdd((oHtml:ValByName("IT.QTDCON" )), Transform(aDADOS[nI][4], "@E 999,999,999.99")	)     
	  	AAdd((oHtml:ValByName("IT.QTDDIF" )), Transform(nQTDDIV		 , "@E 999,999,999.99")	)     	
	Next NI                         
	
	oHtml:ValByName("TOTALDIV", Transform(nTOTDIV , "@E 999,999,999.99")	)	

	oProcess:cTo  := LOWER(cEmail)
	ConOut("WF - WFCONFC - E-MAIL ENVIADO PARA: " + oProcess:cTo)

	// inicia o processo de envio de workflow
	oProcess:Start()	
	
	// finaliza o processo
	oProcess:Finish()
	
	conout("WF - WFCONFC - FIM DO ENVIO DE EMAIL - CONFERENCIA CEGA ")
	RestArea(aArea)
	

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fChkFCPED ºAutor  ³Rafael Parma       º Data ³  01/10/2010  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável por checar se existem itens de pedidos   º±±
±±º          ³diferentes ou itens com pedido e sem pedido de compras.     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
                
*----------------------------*
Static Function fChkFCPED()
*----------------------------*
Local lRet := .T.
Local lFluxo := .F.
Local lEmpty := .F.
//Local nPCODTES := aScan(aHeader,{|x| AllTrim(x[2])=="D1_TES"}) 
Local nPNUMPED := aScan(aHeader,{|x| AllTrim(x[2])=="D1_PEDIDO"})
Local nPITEPED := aScan(aHeader,{|x| AllTrim(x[2])=="D1_ITEMPC"})
Local aDADOSPED := {}
Local aDADOSIMP := {}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Localiza pedidos existentes nos itens do documento                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nI := 1 to Len(aCols)
		If !aCols[nI][Len(aCols[nI])]
			If Len(aDADOSIMP) == 0
				nPOS := 0
			Else         
				nPOS := aScan ( aDADOSIMP, {|x| x[1] == aCols[nI][nPNUMPED] } )
			EndIf                           
			If nPOS == 0
				aAdd ( aDADOSIMP, { aCols[nI][nPNUMPED] } ) 
			EndIf
			If Empty(aCols[nI][nPNUMPED])
				lEmpty := .T.
			EndIf
		EndIf
	Next nI                

	If Len(aDADOSIMP) > 1 .and. lEmpty
		lRet := .F. 
	EndIf
	
Return (lRet)     


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fValCFOP  ºAutor  ³Rafael Parma       º Data ³  20/01/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável por validar o CFOP de conhecimentos de   º±±
±±º          ³frete conforme suas especies.                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*----------------------------*
Static Function fValCFOP()     
*----------------------------*
Local lRet := .T.
Local aDADOS := {}
Local nPCFOP := aScan(aHeader,{|x| AllTrim(x[2])=="D1_CF"})
Local nPITEM := aScan(aHeader,{|x| AllTrim(x[2])=="D1_ITEM"})
Local nPPROD := aScan(aHeader,{|x| AllTrim(x[2])=="D1_COD"})
 
	If ALLTRIM(CESPECIE) == "CTR" .OR. ALLTRIM(CESPECIE) == "CTE" .OR. ALLTRIM(CESPECIE) == "CTA" .OR. ALLTRIM(CESPECIE) == "FRETE"
		
		For nI := 1 to Len(aCols)
			If !aCols[nI][Len(aCols[nI])]
				If ! SubSTR(aCols[nI,nPCFOP],2,3) $ "351/352/353"
					aAdd ( aDADOS, {aCols[nI,nPITEM], aCols[nI,nPPROD]} )
				EndIf
			EndIf
		Next nI
		
		If Len(aDADOS) > 0
			cTEXTO := ""
			For nI := 1 to Len(aDADOS)
				cTEXTO += "ITEM: "+aDADOS[nI,1]+" - PRODUTO: "+aDADOS[nI,2]+CHR(13)+CHR(10)
			Next nI
			Aviso("Atenção","Os itens abaixo estão com CFOP incorretos para a especie utilizada, favor validar e verificar se o TES está correto :"+CHR(13)+CHR(10)+cTEXTO,{"OK"},3)
			lRet := .F.
		EndIf                                                  
		
	ElseIf ALLTRIM(CESPECIE) != "CTR" .AND. ALLTRIM(CESPECIE) != "CTE" .And. ALLTRIM(CESPECIE) != "CTA" .AND. ALLTRIM(CESPECIE) != "FRETE"
		
		For nI := 1 to Len(aCols)
			If !aCols[nI][Len(aCols[nI])]
				If SubSTR(aCols[nI,nPCFOP],2,3) $ "351/352/353"
					aAdd ( aDADOS, {aCols[nI,nPITEM], aCols[nI,nPPROD]} )
				EndIf
			EndIf
		Next nI
		
		If Len(aDADOS) > 0
			cTEXTO := ""
			For nI := 1 to Len(aDADOS)
				cTEXTO += "ITEM: "+aDADOS[nI,1]+" - PRODUTO: "+aDADOS[nI,2]+CHR(13)+CHR(10)
			Next nI
			Aviso("Atenção","Os itens abaixo estão com CFOP incorretos para a especie utilizada, favor validar e verificar se o TES está correto :"+CHR(13)+CHR(10)+cTEXTO,{"OK"},3)
			lRet := .F.
		EndIf  
	
	EndIf   

Return (lRet)




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fCheckCTB ºAutor  ³Rafael Parma       º Data ³  24/02/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável por validar o segmento, centro de custo eº±±
±±º          ³conta contábil na inclusão do documento de entrada.         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*----------------------------*
Static Function fCheckCTB()   
*----------------------------*
Local lRet := .T.
Local cTEXTO    := ""
Local nPosDEL   := Len(aHeader) + 1
Local nPosCC	  := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_CC"		} )
Local nPosCTA	  := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_CONTA"	} )
Local nPosRAT 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_RATEIO"} )
Local nPosPRD 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_COD"		} )
Local nPosITEM	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_ITEM"	} )
Local nPosCLVL	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_CLVL"	} )
	
	For nI := 1 to Len(aCols)
		If ! aCols[nI][nPosDEL]		
			If nPosRAT > 0 .and. aCols[nI][nPosRAT] != '1' .and. ( Empty(aCols[nI][nPosCC]) .or. Empty(aCols[nI][nPosCTA]) .or. Empty(aCols[nI][nPosCLVL]) )
		   		cTEXTO += "ITEM: "+aCols[nI][nPosITEM]+" - PRODUTO: "+aCols[nI][nPosPRD]+chr(13)+chr(10)
		   		lRet := .F.
			EndIf
		EndIf
	Next nI
                    
	If !lRet
		Aviso("Atenção","Alguns campos obrigatórios (SEGMENTO, CENTRO DE CUSTO OU CONTA CONTÁBIL) não foram preenchidos para os seguintes itens: "+chr(13)+chr(10)+cTEXTO, {"OK"}, 3)
	EndIf
	

Return (lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJWINDES  ºAutor  ³Rafael Parma       º Data ³  23/03/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Janela para o usuário informar o tipo de descarregamento, ti-±±
±±º          ³po de carga e fornecedor do descarregamento.                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                            

*--------------------------------------------------------*
User Function RJWINDES(cDOC, cSER, cFOR, cLOJ, cCODCC )
*--------------------------------------------------------*
Private cFORDES := Space(TamSX3("D1_FORNECE")[1])
Private cLOJDES := Space(TamSX3("D1_LOJA")[1])
Private cNOMDES := Space(TamSX3("A2_NOME")[1])
Private aTIPDES := {"P =Proprio","TD=Terceiro(Dia)","TN=Terceiro(Noite)"}
Private aTIPCAR := {"G=Granel","C=Caixas","P=Palet"}     
Private cTIPDES := ""
Private cTIPCAR := ""                 
Private nPESBAL := 0
Private nOpcao  := 0   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	DEFINE MSDIALOG oDlgIMP FROM 010,100 TO 210,630 TITLE "Descarregamento" PIXEL
	@ 005, 005 TO 095, 260 OF oDlgIMP  PIXEL
	 
	@ 010,010 SAY "Descarregamento:" 	SIZE 200,10 OF oDlgIMP PIXEL 
	@ 010,065 COMBOBOX cTIPDES ITEMS aTIPDES SIZE 050,10 OF oDlgIMP PIXEL
	@ 010,140 SAY "Tipo Carga:"    		SIZE 200,10 OF oDlgIMP PIXEL
	@ 010,200 COMBOBOX cTIPCAR ITEMS aTIPCAR SIZE 050,10 OF oDlgIMP PIXEL
	/*
	@ 030,010 SAY "Peso Balança:"	 	SIZE 200,10 OF oDlgIMP PIXEL 
	@ 030,065 GET nPESBAL PICTURE "@E 9,999,999.99"	SIZE 040,10 OF oDlgIMP PIXEL 
	@ 050,010 SAY "Fornecedor Marinha:" SIZE 200,10 OF oDlgIMP PIXEL            		                                                                          
	@ 050,065 MSGET oCLAS VAR cFORDES SIZE 040,10 F3 "SA2001" WHEN ( cTIPDES=="Terceiro(Dia)" .or. cTIPDES=="Terceiro(Noite)" ) VALID (!VAZIO().AND.EXISTCPO("SA2")) OF oDlgIMP PIXEL
	@ 050,120 GET cLOJDES				SIZE 015,10 WHEN ( cTIPDES=="Terceiro" ) OF oDlgIMP PIXEL
	@ 050,150 GET cNOMDES				SIZE 100,10 WHEN .F. OF oDlgIMP PIXEL 
	*/	
	DEFINE SBUTTON FROM 070, 190 TYPE 1 ACTION (nOpcao:=1,oDlgIMP:End()) ENABLE OF oDlgIMP PIXEL
	DEFINE SBUTTON FROM 070, 220 TYPE 2 ACTION (nOpcao:=2,oDlgIMP:End()) ENABLE OF oDlgIMP PIXEL
	
	ACTIVATE MSDIALOG oDlgIMP CENTERED	
	
	If nOpcao == 1

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona sobre registro de conferência cega                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
		dbSelectArea("Z00")
		dbSetOrder(1)	//Z00_FILIAL+Z00_COD
		dbGoTop()
		cTpDescarga := ''
		If dbSeek ( xFilial("Z00") + cCODCC )
			dbSelectArea("Z01")
			dbSetOrder(1)	//Z01_FILIAL+Z01_COD+Z01_DOC+Z01_SERIE+Z01_FORNEC+Z01_LOJA
			dbGoTop()
			If dbSeek ( xFilial("Z01") + Z00->Z00_COD + cDOC + cSER + cFOR + cLOJ )	
				If RecLock("Z01",.F.)
					/*   Gustavo 28/10 - Ajustado para não precisar fazer essas comparações.
					// Guilherme 21/05/11 alterado o tipo de gravacao para diferenciar terceiro(dia) e terceiro(noite)
					If cTIPDES == Alltrim("Terceiro(Dia)")
						cTpDescarga := "TD"
					ElseIf cTIPDES == Alltrim("Terceiro(Noite)")
						cTpDescarga := "TN"
					Else
						cTpDescarga := "P"                                                                            						
					EndIf					                                                                          
					//
					*/
				
					Z01->Z01_TPDESC := Substr(cTIPDES,1,3) //Guilhere 21/05/11
					Z01->Z01_TPCARG := Substr(cTIPCAR,1,2)
					Z01->Z01_PESOBA := nPESBAL
					Z01->Z01_FORDES := cFORDES
					Z01->Z01_LOJDES := cLOJDES					
					Z01->(MsUnLock())
				EndIf
			EndIf
		EndIf	
	EndIf
		
Return nOpcao		


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fCheckDEV  ºAutor  ³Rafael Parma      º Data ³  01/06/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Validação sobre documento de entrada de devolução, preenchi-º±±
±±º          ³mento de campos necessarios para PCO.                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
Static Function fCheckDEV() 
Local lRet := .T.
Local cTEXTO  := ""
Local nPosDEL := Len(aHeader) + 1
Local nPosNFO := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_NFORI"		} )
Local nPosSER := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_SERIORI"	} )
Local nPosITD := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_ITEMORI"	} )
Local nPosITE := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_ITEM"		} )
Local nPosPRD := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_COD"		} )

	If Type("CTIPO") != "U"
		If CTIPO == "D" .and. nPosNFO > 0 .and. nPosSER > 0 .and. nPosITD > 0 .and. nPosITE > 0 .and. nPosPRD > 0
			For nI := 1 to Len(aCols)
				If ! aCols[nI][nPosDEL]		
					If Empty(aCols[nI][nPosNFO]) .or. Empty(aCols[nI][nPosSER]) .or. Empty(aCols[nI][nPosITD])
				   		cTEXTO += "ITEM: "+aCols[nI][nPosITE]+" - PRODUTO: "+aCols[nI][nPosPRD]+chr(13)+chr(10)
				   		lRet := .F.
					EndIf
					
				EndIf
			Next nI
		                    
			If !lRet
				Aviso("Atenção","Alguns campos obrigatórios DOCUMENTO DE ORIGEM, SERIE DE ORIGEM e ITEM de ORIGEM não foram preenchidos para os seguintes produtos: "+chr(13)+chr(10)+cTEXTO, {"OK"}, 3)
			EndIf                  
		EndIf
	EndIf

Return (lRet)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Incluído validação para que a conta contábil do documento ³
//³de entrada seja a mesma do pedido de compra.              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fValCtaCtbl()

Local lRet      := .T.
Local nPosDEL   := Len(aHeader) + 1
Local nPosCTA	  := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_CONTA"	} )
Local nPosITEM	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_ITEM"	} )
Local nPosPed   := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_PEDIDO"} )
Local nPosRat   := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_RATEIO"} )
Local nPosProd	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_COD"})
Local cNumPed   := ""
Local cCodItem  := ""
Local cNumSeq   := ""
Local cCtaDoc   := ""
Local cCtaPed   := ""
Local cCodProd  := ""
Local cCodFil   := ""
Local cSql      := ""
Local cEol      := CHR(13) + CHR(10)

For nI := 1 to Len(aCols)
	If ! aCols[nI][nPosDEL] 
		
		// Valida se existe um pedido e se não existe rateio. Se tiver rateio a validação é em outro PE.
		if aCols[nI][nPosPed] != " " .and. lRet .and. aCols[nI][nPosRat] != "1"
		
			cNumPed  := aCols[nI][nPosPed]
			cCodItem := aCols[nI][nPosITEM]
			cCtaDoc  := aCols[nI][nPosCTA]
			cCodProd := aCols[nI][nPosProd]
			cCodFil  := xFilial("SC7")
			
			cSql := "SELECT C7.C7_CONTA FROM " + retSqlName("SC7") + " C7 " 
			cSql += "WHERE C7.D_E_L_E_T_ <> '*' "
			cSql += "  AND C7.C7_FILIAL = '" + cCodFil + "' "
			cSql += "  AND C7.C7_NUM = '" + cNumPed + "' "
			cSql += "  AND C7.C7_PRODUTO = '" + cCodProd + "' "

			TCQUERY cSql NEW ALIAS "SC7TMP"
			
			DbSelectArea("SC7TMP")
			SC7TMP->(DbGoTop())
			
			cMsg := ""
			if !SC7TMP->(EOF())
				cCtaPed := SC7TMP->C7_CONTA
			else
				cMsg := "Não encontrei registro com a chave abaixo na tabela de pedidos: "+cEol
				cMsg += "Filial: " + AllTrim(cCodFil) + cEol
				cMsg += "Pedido: " + AllTrim(cNumPed) +	cEol
				cMsg += "Produto: " + AllTrim(cCodProd) +	cEol		
				MsgStop(cMsg, "Registro não encontrado")		
			EndIf
			
			SC7TMP->(DbCloseArea())
			 
			// cCtaPed  := Posicione("SC7", 01, xFilial("SC7") + cNumPed + cCodItem + cNumSeq, "C7_CONTA")
			
			if cCtaDoc != cCtaPed
				lRet := .F.
				Aviso("Atenção","A CONTA CONTÁBIL informada na linha do item "+AllTrim(cCodItem)+" está diferente da conta informada no "+;
							"pedido de compra "+AllTrim(cNumPed)+"."+chr(13)+chr(10)+;
							"Utilize a conta: "+AllTrim(cCtaPed)+".", {"OK"}, 3)
			EndIf
		EndIf
  EndIf
Next nI

Return lRet

// Obtém os lotes da nf que está sendo incluída
Static Function ObtemLotes()
Local nPosProd := aScan(aHeader, {|x| AllTrim(x[2]) == "D1_COD"})
Local nPosLote := aScan(aHeader, { |x| AllTrim(x[2]) = "D1_LOTECTL"}) 
Local aProds := {}
Local cArq := ""
		
For nX := 1 to len(aCols)
	if !Empty(aCols[nX, nPosProd])
		aAdd(aProds, {SubStr(SM0->M0_CGC, 1, 8), SubStr(SM0->M0_CGC, 9, 4), cNFiscal, cSerie, aCols[nX, nPosProd]})
	EndIf
Next nX

aStruct := {}
Aadd(aStruct,{"FORN"     , "C", TamSX3("F1_FORNECE")[1], 0})
Aadd(aStruct,{"LOJA"   , "C", TamSX3("F1_LOJA")[1], 0})
Aadd(aStruct,{"NOTA"    , "C", TamSX3("F1_DOC")[1], 0})
Aadd(aStruct,{"SERIE"   , "C", TamSX3("F1_SERIE")[1], 0})
Aadd(aStruct,{"PRODUTO"   , "C", TamSX3("B1_COD")[1], 0})
Aadd(aStruct,{"LOTE"   , "C", TamSX3("D1_LOTECTL")[1], 0})

cArqTmp := CriaTrab(aStruct, .T.)
dbUseArea( .T.,, cArqTmp,"TRBTRA", .T. , .F. )

For nX := 1 to len(aProds)
	RecLock("TRBTRA", .T.)
	TRBTRA->FORN := aProds[nX, 1]
	TRBTRA->LOJA := aProds[nX, 2]
	TRBTRA->NOTA := aProds[nX, 3]
	TRBTRA->SERIE := aProds[nX, 4]
	TRBTRA->PRODUTO := aProds[nX, 5]
	TRBTRA->LOTE := ""
	TRBTRA->(MsUnlock())
Next nX

nRecSM0 := SM0->(RecNo())
cEmpF1 := ""
cFilF1 := ""

SM0->(dbGoTop())
while SM0->(!Eof())
	if (SubStr(SM0->M0_CGC, 1, 12) == AllTrim(cA100For) + cLoja)
		cEmpF1 := SM0->M0_CODIGO
		cFilF1 := SM0->M0_CODFIL
		Exit
	EndIf
	SM0->(dbSkip())
EndDo

SM0->(dbGoto(nRecSM0))

if len(aProds) > 0
	StartJob("U_D1LoteOri", GetEnvServer(), .T., cEmpF1, cFilF1, cArqTmp)
	
	// Ler o retorno do processamento
	TRBTRA->(dbGoTop())
	While TRBTRA->(!Eof())
		if !Empty(TRBTRA->LOTE)
			nColProd := aScan(aCols, {|x| AllTrim(x[nPosProd]) == AllTrim(TRBTRA->PRODUTO)})
			if !(aCols[nColProd, nPosLote] == TRBTRA->LOTE)
				if MsgYesNo("Corrigir de '" + aCols[nColProd, nPosLote] + "' para '" + TRBTRA->LOTE + "' ?", "Divergência no Lote do produto " + TRBTRA->PRODUTO)
					aCols[nColProd, nPosLote] := TRBTRA->LOTE
				EndIf
			endIf
		EndIf
		TRBTRA->(dbSkip())
	EndDo     
	TRBTRA->(DbCloseArea())
EndIf

FErase(cArqTmp+GetDBExtension())
	
Return .T.

User Function D1LoteOri(cEmpF1, cFilF1, cArqTmp)
RpcSetType(3)
RpcSetEnv(cEmpF1, cFilF1,,,, GetEnvServer(), {"SM0"})
dbUseArea( .T.,, cArqTmp,"TRBTRA", .T. , .F. )
                  
TRBTRA->(dbGotop())
SD2->(dbSetOrder(03)) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

While TRBTRA->(!Eof())
	nRec := TRBTRA->(RecNo())
	
	if SD2->(dbSeek(xFilial("SD2") + TRBTRA->NOTA + TRBTRA->SERIE + TRBTRA->FORN + TRBTRA->LOJA + TRBTRA->PRODUTO))
		RecLock("TRBTRA", .F.)
		TRBTRA->LOTE := SD2->D2_LOTECTL
	  TRBTRA->(MsUnlock())
	EndIf
		
	TRBTRA->(dbGoto(nREc))
	TRBTRA->(dbSkip())
EndDo

RpcClearEnv()
Quit
Return .T.  



	