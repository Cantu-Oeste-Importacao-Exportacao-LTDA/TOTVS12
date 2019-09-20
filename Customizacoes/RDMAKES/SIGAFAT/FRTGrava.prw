/*
#############################################################################
### Efetua a grava��o dos dados referente ao romaneio de carga e tamb�m   ###
### nas tabelas SC5 e SC9.                                                ###
#############################################################################
*/
User Function FRTGrv(nOpc,aHeader,aCols,cRotina,cNumRom)
Local _aCols  := aCols
// Caso usuario n�o filtre as linhas deletadas, aqui quando for inclus�o
// elas s�o removidas.     

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

If cRotina	== 'INCLUI'
	If nOpc = 3
		aCols := {}
		For nR := 1 To Len(_aCols)             
			If !_aCols[nR,21] .AND. AllTrim(_aCols[nR,1]) <> '' .AND. AllTrim(_aCols[nR,4]) <> ''
				aAdd(aCols,{_aCols[nR,1],_aCols[nR,2],_aCols[nR,3],_aCols[nR,4],_aCols[nR,5],_aCols[nR,6],_aCols[nR,7],;
				_aCols[nR,8],_aCols[nR,9],_aCols[nR,10],_aCols[nR,11],_aCols[nR,12],_aCols[nR,13],_aCols[nR,14],;
				_aCols[nR,15],_aCols[nR,16],_aCols[nR,17],_aCols[nR,18],_aCols[nR,19],_aCols[nR,20],_aCols[nR,21]})
			Endif
		Next nR
	Endif
	If Len(aCols) > 0
		StartJob("U_FRTGRVa",GetEnvServer(), .T.,nOpc, aHeader,aCols)
	Endif
ElseIf cRotina == 'SEPARA'
	StartJob("U_FRTGRVb",GetEnvServer(), .T.,nOpc, aHeader,aCols,cNumRom)
Endif

Return Nil

User Function FRTGRVa(nOpc,aHeader,aCols)
Local nX 			:= 1
Local nPosRom 		:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZZS_NUMROM"})
Local nPosFil 		:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZZS_FILORI"})
Local nPosEmp 		:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZZS_EMPRES"})
Local nPNEmp 		:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZZS_NOMEMP"})
Local nPNFil 		:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZZS_NOMFIL"})
Local nPosPed 		:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZZS_PEDIDO"})
Local nPosCli 		:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZZS_CLIENT"})
Local nPosLoja 		:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZZS_LOJACL"})
Local nPosNomCl 	:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZZS_NOMCL"})
Local nPosUFCl 		:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZZS_UFCLI"})
Local nPosCodM 		:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZZS_CODMUN"})
Local nPosMun 		:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZZS_MUN"})
Local nPosTra 		:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZZS_CODTRA"})
Local nPosNTr 		:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZZS_TRANSP"})
Local nPosBase 		:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZZS_BASEFR"})
Local nPosValFin 	:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZZS_VLRFIN"})
Local nPosValFr		:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZZS_VALFRE"})
Local nPosTPFrt 	:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZZS_TPFRET"})
Local nPosCalc		:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZZS_CALCFR"})
Local nPosNCli		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_NOMCLI"})   // Posi��o Nome do Cliente
Local nPosUfC		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_UFCLI"})   // Posi��o UF do Cliente 
Local nPosMunC		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_MUN"})   // Posi��o Municipio do Cliente 
Local nPosTNF		:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZZS_TOTNF"})
Local nPosObs		:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZZS_OBS"})
Local nPosDup		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_GERDUP"})   // Posi��o Financeiro
Local _nItem		:= "1"

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

//		RpcClearEnv()
RPCSetType(3)
RpcSetEnv(aCols[nX, nPosEmp], aCols[nX, nPosFil],,,"FAT")
If Len(aCols) > 0
	If nOpc = 3
		cNumRom := GetSxeNum("ZZS","ZZS_NUMROM")
		dbSelectArea("ZZS") 
		dbSetOrder(02) // filial + empresa + romaneio + pedido
		// Faz a grava��o na tabela ZZS compartilhada
		For nX := 1 to len(aCols)
			// Valida se deve incluir ou alterar o registro atual
	
			lInclui := (nOpc == 3) .Or. !ZZS->(dbseek(aCols[nX, nPosFil] + aCols[nX, nPosEmp] + aCols[nX, nPosRom] + aCols[nX, nPosPed]))
		
			RecLock("ZZS", lInclui)
			If lInclui
				ZZS->ZZS_FILORI := aCols[nX, nPosFil]
		  		ZZS->ZZS_EMPRES := aCols[nX, nPosEmp]
				ZZS->ZZS_NOMEMP := aCols[nX, nPNEmp]
		  		ZZS->ZZS_NOMFIL := aCols[nX, nPNFil]		  		
		  		ZZS->ZZS_NUMROM := cNumRom
		  		ZZS->ZZS_EMIROM	:= dDataBase
		  	EndIf
			ZZS->ZZS_ITEM		:= StrZero(Val(_nItem),4)
			ZZS->ZZS_PEDIDO 	:= aCols[nX, nPosPed]
			ZZS->ZZS_CLIENT 	:= aCols[nX, nPosCli]
			ZZS->ZZS_LOJACL 	:= aCols[nX, nPosLoja]
			ZZS->ZZS_NOMCLI  	:= aCols[nX, nPosNCli]
			ZZS->ZZS_UFCLI  	:= aCols[nX, nPosUfC]
	//		ZZS->ZZS_CODMUN 	:= aCols[nX, nPosCodM]
			ZZS->ZZS_MUN    	:= aCols[nX, nPosMunC]
			ZZS->ZZS_CODTRA 	:= aCols[nX, nPosTra]
			ZZS->ZZS_TRANSP 	:= aCols[nX, nPosNTr]
	//			ZZS->ZZS_BASEFRE 	:= aCols[nX, nPosBase]
			ZZS->ZZS_VLRFIN 	:= aCols[nX, nPosValFin]
			ZZS->ZZS_VALFRE   	:= aCols[nX, nPosValFr]
			ZZS->ZZS_TPFRET 	:= aCols[nX, nPosTPFrt]
			ZZS->ZZS_CALCFR		:= aCols[nX, nPosCalc]
			ZZS->ZZS_NOMCLI		:= aCols[nX, nPosNCli]
			ZZS->ZZS_UFCLI		:= aCols[nX, nPosUfC]
			ZZS->ZZS_MUN		:= aCols[nX, nPosMunC]
			ZZS->ZZS_TOTNF		:= aCols[nX, nPosTNF]
			ZZS->ZZS_OBS		:= aCols[nX, nPosObs]
			ZZS->ZZS_GERDUP		:= aCols[nX, nPosDup]
		
		  	ZZS->(MsUnlock())
		  	_nItem := Str(Val(_nItem)+1)
	
		Next nX
		ConfirmSX8() // confirma o n�mero alocado
	ElseIf nOpc = 2
		cNumRom := aCols[1,nPosRom]
		ZZS->(DbSelectArea("ZZS"))
		ZZS->(DbSetOrder(3))
		ZZS->(DbGotop())
		ZZS->(DbSeek(xFilial("ZZS")+cNumRom))
		While !ZZS->(Eof()) .AND. ZZS->ZZS_NUMROM == cNumRom
			ZZS->(RecLock("ZZS",.F.))
				ZZS->(DbDelete())
			ZZS->(MsUnLock())		
			ZZS->(DbSkip())
		End
	ElseIf nOpc = 1
		ODlg1:End()
		Return
	EndIf
	
	// Ordena o aCols para que seja r�pida a troca de environment por empresa e filal e seja trocado somente uma vez para cada
	aCols := aSort(aCols,,, {|X,Y| (X[nPosEmp]+X[nPosFil]) < (Y[nPosEmp]+Y[nPosFil])})
	
	// Faz a grava��o dos dados
	// alimenta a variavel com os dados da filial atual
	cEmpFil := cEmpAnt + cFilAnt //aCols[1, 1] + aCols[1, 2]
	For nX := 1 to len(aCols)
	  	// posiciona na empresa correta antes de iniciar a altera��o
		If (cEmpFil != (AllTrim(aCols[nX, nPosEmp]) + AllTrim(aCols[nX, nPosFil])))
			RpcClearEnv()
			RPCSetType(3)
		
			RpcSetEnv(aCols[nX, nPosEmp], aCols[nX, nPosFil],,,,GetEnvServer())
		EndIf
		
		cEmpFil := AllTrim(aCols[nX, nPosEmp]) + AllTrim(aCols[nX, nPosFil]) // Grava a posi��o atual
		
	    SC5->(DbSelectArea("SC5"))
		SC5->(DbSetOrder(1))
		If SC5->(DbSeek(AllTrim(aCols[nX, nPosFil])+aCols[nX, nPosPed])) .AND. nOpc = 3
			If SC5->C5_TRANSP <> aCols[nX, nPosTra] .or. SC5->C5_TPFRETE <> aCols[nX, nPosTPFrt]
				SC5->(RecLock("SC5", .F.))
	  				SC5->C5_TRANSP := aCols[nX, nPosTra]
	  				SC5->C5_TPFRETE := aCols[nX, nPosTPFrt]
				SC5->(MsUnlock())
				
				// Faz a grava��o em outras tabelas que precisar
				
				// avalia se precisa enviar algum workflow
				// Flavio - 28/07/2011
				// Verificar, por enquanto n�o aplic�vel
			    /*  if (<condi�ao para enviar workflow>)
			    	// envia workfow
			    	EndIf
				//	    MsgInfo("Fim da grava��o")
				EndIf*/
			EndIf		
		Endif
	    If nOpc = 3 // Inclus�o
		    SC9->(DbSelectArea("SC9"))
			SC9->(DbSetOrder(1))
			If SC9->(DbSeek(AllTrim(aCols[nX, nPosFil])+aCols[nX, nPosPed]))
				While !SC9->(Eof()) .AND. SC9->C9_FILIAL+SC9->C9_PEDIDO == aCols[nX, nPosFil]+aCols[nX, nPosPed]
					SC9->(RecLock("SC9", .F.))
		  				SC9->C9_X_CARGA := cNumRom
					SC9->(MsUnlock())
					SC9->(DbSkip())
				End		
			Endif	
		ElseIf nOpc = 2
		    SC9->(DbSelectArea("SC9"))
			SC9->(DbSetOrder(1))
			If SC9->(DbSeek(AllTrim(aCols[nX, nPosFil])+aCols[nX, nPosPed]))
				While !SC9->(Eof()) .AND. SC9->C9_FILIAL+SC9->C9_PEDIDO == aCols[nX, nPosFil]+aCols[nX, nPosPed]
					If SC9->C9_X_CARGA == cNumRom
						SC9->(RecLock("SC9", .F.))
			  				SC9->C9_X_CARGA := Space(09)
						SC9->(MsUnlock())
					Endif
					SC9->(DbSkip())
				End		
			Endif	
		Endif
	
	
	Next nX
Endif

RpcClearEnv()
//RPCSetType(3)
//RpcSetEnv(aEmpOld[1], aEmpOld[2],,,,GetEnvServer())

Return


User Function FRTGRVb(nOpc,aHeader,aCols,cNumRom)
Local nX 			:= 1
Local nPosSep		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_SEPOK"}) // Posi��o codigo da empresa
Local nPosEmp		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_EMPRES"}) // Posi��o codigo da empresa
Local nPosFil		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_FILORI"})  // Posi��o codigo filial
Local nPNEmp		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_NOMEMP"}) // Posi��o nome da empresa
Local nPNFil		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_NOMFIL"})  // Posi��o nome filial
Local nPosCalc 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_CALCFR"})  // Tipo do calculo utilizado
Local nPosRom		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_NUMROM"})  // Posi��o codigo do romaneio
Local nPosPed		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_PEDIDO"})  // Posi��o pedido de venda
Local nPosCli 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_CLIENT"})  // Posi��o codigo do cliente
Local nPosLoj 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_LOJACL"})  // Posi��o loja do cliente
Local nPosCTr		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_CODTRA"})  // Posi��o codigo do transportador
Local nPosNTr		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_TRANSP"})  // Posi��o nome do transportador
Local nPosBas		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_BASEFR"})  // Base de calculo do frete
Local nPosVal		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_VALFRE"})  // Valor do Frete
Local nPosFin		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_VLRFIN"})  // Posi��o valor do frete combinado (frete final)
Local nPosCF		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_TPFRET"})  // Posi��o Tipo do frete (C=Cif F=Fob)
Local nPosTNf		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_TOTNF"})   // Posi��o Valor total nota fiscal 
Local _nItem		:= "1"

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())     

RPCSetType(3)
RpcSetEnv(aCols[nX, nPosEmp], aCols[nX, nPosFil],,,"FAT")
If Len(aCols) > 0

	// Ordena o aCols para que seja r�pida a troca de environment por empresa e filal e seja trocado somente uma vez para cada
	aCols := aSort(aCols,,, {|X,Y| (X[nPosEmp]+X[nPosFil]) < (Y[nPosEmp]+Y[nPosFil])})
	
	// Faz a grava��o dos dados
	// alimenta a variavel com os dados da filial atual
	cEmpFil := cEmpAnt + cFilAnt //aCols[1, 1] + aCols[1, 2]
	For nX := 1 to len(aCols)
	  	// posiciona na empresa correta antes de iniciar a altera��o
		If (cEmpFil != (AllTrim(aCols[nX, nPosEmp]) + AllTrim(aCols[nX, nPosFil])))
			RpcClearEnv()
			RPCSetType(3)
		
			RpcSetEnv(aCols[nX, nPosEmp], aCols[nX, nPosFil],,,,GetEnvServer())
		EndIf
		
		cEmpFil := AllTrim(aCols[nX, nPosEmp]) + AllTrim(aCols[nX, nPosFil]) // Grava a posi��o atual
		
		If nOpc = 2
		    SC9->(DbSelectArea("SC9"))
			SC9->(DbSetOrder(1))
			If SC9->(DbSeek(AllTrim(aCols[nX, nPosFil])+aCols[nX, nPosPed]))
				While !SC9->(Eof()) .AND. SC9->C9_FILIAL+SC9->C9_PEDIDO == aCols[nX, nPosFil]+aCols[nX, nPosPed]
					If SC9->C9_X_CARGA == cNumRom
						SC9->(RecLock("SC9", .F.))
			  				SC9->C9_X_CARGA := Space(09)
						SC9->(MsUnlock())
					Endif
					SC9->(DbSkip())
				End		
			Endif
		    SC5->(DbSelectArea("SC5"))
			SC5->(DbSetOrder(1))
			If SC5->(DbSeek(AllTrim(aCols[nX, nPosFil])+aCols[nX, nPosPed]))
				SC5->(RecLock("SC5", .F.))
	  				SC5->C5_TRANSP := aCols[nX, nPosTra]
	  				SC5->C5_TPFRETE := aCols[nX, nPosTPFrt]
				SC5->(MsUnlock())				
			Endif
		Endif
	
	
	Next nX
Endif

RpcClearEnv()

Return