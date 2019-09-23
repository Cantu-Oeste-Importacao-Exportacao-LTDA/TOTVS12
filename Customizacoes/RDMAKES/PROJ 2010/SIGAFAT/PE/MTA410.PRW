#include "TOTVS.CH"
#include "TOPCONN.CH"
                           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA410     ºAutor  ³Rafael Parma       º Data ³  20/01/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Validações na confirmação do pedido de venda.               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*----------------------------*
User Function MTA410()
*----------------------------*
Local lRet := .T.
Local aArea  := GetArea()                                                                        
Local aDADOS := {}
Local nPCFOP := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_CF"      })  // CFOP DO ITEM
Local nPITEM := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_ITEM"    })  // NUMERO DO ITEM
Local nPPROD := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="C6_PRODUTO" })  // PRODUTO DO ITEM  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se for devolução de compra ou utilzar fornecedor não valida³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If M->C5_TIPO $ "BD"
		Return lRet
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Validação de pedido já incluido em carga do OMS³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		
	dbSelectArea("DAI")
	dbSetOrder(4)
	dbGoTop()
	If dbSeek ( xFilial("DAI") + M->C5_NUM )
		Aviso("Atenção","Este pedido já foi relacionado a uma carga do OMS e não poderá ser alterado! Qualquer manutenção sobre o pedido deverá ser efetuado na carga número: "+DAI->DAI_COD,{"OK"},2)
		lRet := .F.	
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Flavio - se vier do SIM3G nao faz a validação, não há intevenção humana para ter erro³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If M->C5_SIM3G .or. M->C5_SIM3GM .or. M->C5_X_EECO .or. M->C5_X_IB2B=="S"
		Return lRet
	EndIf
    
	/* GUSTAVO 31/05/16 - COMENTADO, POIS O CAMPO CFOP NÃO É EDITÁVEL
	                      E ESTAVA DANDO PROBLEMA EM VENDAS PARA TURISTA EXTRANGEIRO.
	                      
	If POSICIONE("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_EST") == "EX"

		For nI := 1 to Len(aCols)     
			If !acols[nI,Len(aHeader)+1] 
	       		If SubSTR(aCols[nI,nPCFOP],1,1) != "7"
	       			ConOut("Cfop errado: " + aCols[nI,nPCFOP] + "  - Cliente EX")
	       			aAdd ( aDADOS, {aCols[nI,nPITEM], aCols[nI,nPPROD]} )
	       		EndIf
			EndIf
		Next nI
		        
		If Len(aDADOS) > 0
			cTEXTO := ""
			For nI := 1 to Len(aDADOS)
				cTEXTO += "ITEM: "+aDADOS[nI,1]+" - PRODUTO: "+aDADOS[nI,2]+CHR(13)+CHR(10)
			Next nI
			Aviso("Atenção","Os itens abaixo estão com CFOP incorretos, favor validar e verificar se o TES está correto (alterando ou redigitando):"+CHR(13)+CHR(10)+cTEXTO,{"OK"},3)
			lRet := .F.
		EndIf
	
	ElseIf Alltrim(GETMV("MV_ESTADO")) != POSICIONE("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_EST")
		For nI := 1 to Len(aCols)     
			If !acols[nI,Len(aHeader)+1] 
	   		If SubSTR(aCols[nI,nPCFOP],1,1) != "6"
	   			ConOut("Cfop errado: " + aCols[nI,nPCFOP] + "  - Cliente Fora UF")
  	 			aAdd ( aDADOS, {aCols[nI,nPITEM], aCols[nI,nPPROD]} )
     		EndIf
			EndIf
		Next nI
		        
		If Len(aDADOS) > 0
			cTEXTO := ""
			For nI := 1 to Len(aDADOS)
				cTEXTO += "ITEM: "+aDADOS[nI,1]+" - PRODUTO: "+aDADOS[nI,2]+CHR(13)+CHR(10)
			Next nI
			Aviso("Atenção","Os itens abaixo estão com CFOP incorretos, favor validar e verificar se o TES está correto (alterando ou redigitando):"+CHR(13)+CHR(10)+cTEXTO,{"OK"},3)
			lRet := .F.
		EndIf
		
	Else

		For nI := 1 to Len(aCols)     
			If !acols[nI,Len(aHeader)+1] 
	       		If SubSTR(aCols[nI,nPCFOP],1,1) != "5"
	       			ConOut("Cfop errado: " + aCols[nI,nPCFOP] + "  - Cliente no estado")
	       			aAdd ( aDADOS, {aCols[nI,nPITEM], aCols[nI,nPPROD]} )
	       		EndIf
			EndIf
		Next nI
		        
		If Len(aDADOS) > 0
			cTEXTO := ""
			For nI := 1 to Len(aDADOS)
				cTEXTO += "ITEM: "+aDADOS[nI,1]+" - PRODUTO: "+aDADOS[nI,2]+CHR(13)+CHR(10)
			Next nI
			Aviso("Atenção","Os itens abaixo estão com CFOP incorretos, favor validar e verificar se o TES está correto (alterando ou redigitando):"+CHR(13)+CHR(10)+cTEXTO,{"OK"},3)
			lRet := .F.
			
		EndIf	
	
	EndIf
	*/
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Flavio - Adicionado validação de alteração do pedido para impedir alterar se exitir uma carga amarrada³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	if lRet
		lRet := U_ValPedFrt(M->C5_NUM)
	EndIf

	RestArea(aArea)

Return (lRet)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ@¿
//³Flavio - 25/08/2011                                 ³
//³Função que valida o pedido se o mesmo encontra no   ³
//³controle de cargas.                                 ³
//³Criado parâmetro para não ter impacto para quem não ³
//³utiliza tal funcionalidade                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ@Ù

*------------------------------*
User Function ValPedFrt(cPed)   
*------------------------------*
Local lOk := .T.
Local lUsaCtlFrt := SuperGetMv("MV_X_CTFRT",,.F.)   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If lUsaCtlFrt
	ZZS->(dbSetOrder(5))
	lOK := ZZS->(!DbSeek(xFilial("ZZS") + cEmpAnt + cFilAnt + cPed))
	if !lOk
		MsgStop("Pedido/N.F. não poderá ser alterado/eliminado resíduo pois está incluso na carga " + ZZS->ZZS_NUMROM + ".")
	EndIf
EndIf
Return lOk     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ@¿
//³Adriano - 11/02/2012                                ³
//³Função que valida a nota fiscal encontra no         ³
//³controle de cargas.                                 ³
//³Criado parâmetro para não ter impacto para quem não ³
//³utiliza tal funcionalidade                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ@Ù

*-------------------------------------------------------*
User Function ValNFSFrt(_cNf,_cPref,_cFor,_cLoja)        
*-------------------------------------------------------*
Local lOk := .T.
Local lUsaCtlFrt := SuperGetMv("MV_X_CTFRT",,.F.)
Local _cPar	:= "FR1"
Local _cTp	:= "PR "
Local _cEmpGrp	:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If lUsaCtlFrt
	_cEmpAtu	:= SM0->(GetArea())
	SM0->(DbSelectArea("SM0"))
	SM0->(DbSetOrder(1))
	SM0->(DbGotop())
	While !SM0->(Eof())
		aAdd(_cEmpGrp,{SM0->M0_CGC})
		SM0->(DbSkip())
	End
	SM0->(RestArea(_cEmpAtu)) 
	
	SA2->(DbSelectArea("SA2"))
	SA2->(dbSetOrder(1))
	SA2->(dbSeek(xFilial("SA2")+_cFor+_cLoja))	
   	nPosicao  := aScan(_cEmpGrp,{|_x| SA2->A2_CGC == _x[1]})
	If nPosicao = 0
		SE2->(DbSelectArea("SE2"))
		SE2->(DbGotop())
		SE2->(DbSetorder(1))
		If SE2->(DbSeek(xFilial("SE2") + _cPref + _cNf + _cPar + _cTp + _cFor + _cLoja))
			RecLock("SE2", .F.)
				SE2->(DbDelete())
		  	SE2->(MsUnlock())
		Else
			MsgStop("Titulo provisorio para o não encontrado.")
			lOk := .F.	
		Endif
	EndIf		
EndIf

Return lOk

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ponto de entrada na confirmação da eliminação de resíduo - Flavio³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

*-------------------------*
User Function M410VRES()   
*-------------------------*
Local lOk := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Flavio - parte de controle de exclusão da carga³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

lOk := U_ValPedFrt(SC5->C5_NUM)

if SC5->(FieldPos("C5_DTHRALT") > 0)
	RecLock("SC5", .F.)
	SC5->C5_DTHRALT := DToS(dDataBase) + ' ' + Substr(Time(), 1, 5)
	SC5->(MsUnlock())
EndIf                      

Return lOk