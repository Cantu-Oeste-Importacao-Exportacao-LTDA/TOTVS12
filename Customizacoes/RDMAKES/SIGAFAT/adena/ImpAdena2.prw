#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

User Function ImpAdn2()
Local cDir := GetSrvProfString("ROOTPATH","") + "Adena\"
Local aFiles     := {} 
Local _cCodMun := ""   
Local _cMun := ""
Local _cLocal:=""   
Local _cEstado:=""
Local _cMuni:=""
Local _xPedido:=""  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())   

//RpcClearEnv() 
//RpcSettype(3)
//RpcSetEnv("30","01")  

fDownLoad(cDir) //Busca os arquivos no ftp

Makedir("\Adena\")
Makedir("\Adena\importado\")
Makedir("\Adena\erro\")

aFiles := Directory(cDir+"*.XML")   

If Len(aFiles) > 0

//	Processa({|| ImpArquivo(cDir, aFiles) })
	ImpArq2(cDir, aFiles)
//	Conout("depois imparquivo")

EndIf

//RpcClearEnv()

Return     

Static Function ImpArq2(pDir, aFiles)
local oXML := nil
Local cDirArq := pDir
local cErro := ""
local cAviso := ""
local lOK := .F.

//conout("entrou no impArquivo")

For _Ni := 1 To Len(aFiles)
	
	oXML := XmlParserFile("\Adena\"+aFiles[_Ni][1],"_",@cAviso,@cErro)
	
	If oXML <> NIL
		lOK := U_FPEDAD2(oXML, 1, aFiles[_Ni,1])
		
		If lOk 
			__CopyFile(cDirArq+aFiles[_Ni,1],cDirArq+"importado\"+aFiles[_Ni,1])
		Else
			__CopyFile(cDirArq+aFiles[_Ni,1],cDirArq+"erro\"+aFiles[_Ni,1])
		EndIf                                    
	Endif
	
	FErase(cDirArq+aFiles[_Ni,1]) 
	
//	RpcSetType(3) 
//	RpcClearEnv()
//	RPCSetEnv("30","01")	
	
Next _Ni

Return

User Function FPEDAD2(oXML, pTipo, pArquivo)
Local cModo
Local nSaldo := 0
Local lImporta := .F.
Local aCabec:= {}
Local aItens:= {}
Local aItem	:= {}
Local cEstados := ""
Local lImportado:=.F.    
Local cFormaPag:=""
Local cParcelas:=""   
Local _cCodMun := ""  
Local _xPedido:= ""     

Local aEmp := {}
Local _xEMP := 0      
Local _Empresa:= ""
Local _Filial := ""   

Local aSB2 := {}
Local nPos := 0

Private lMsErroAuto := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//Valida cliente, caso nao possuir deve ser incluido
dbSelectArea("SA1")
dbSetOrder(3)
If !DbSeek(xFilial("SA1")+alltrim(oXML:_Pedido:_Dados_Cliente:_documento_de_registro:TEXT))
	
	If alltrim(oXML:_Pedido:_Dados_Cliente:_Tipo:TEXT) == "F"
		_cTipo 	:= "F" 
		cNum 	:= SubStr(alltrim(oXML:_Pedido:_Dados_Cliente:_documento_de_registro:TEXT),1,9)
	Else
		_cTipo := "R"
		cNum 	:= SubStr(alltrim(oXML:_Pedido:_Dados_Cliente:_documento_de_registro:TEXT),1,8)		
	EndIf
	
	dbSelectArea("CC2")
	dbSetOrder(2)
	If dbSeek(xFilial("CC2")+UPPER(NOACENTO(ANSITOOEM(oXML:_Pedido:_endereco_cobranca:_cidade:TEXT))))
		_cMun := ALLTRIM(CC2->CC2_MUN)
		_cCodMun := ALLTRIM(CC2->CC2_CODMUN)
	Else
		fLog(oXML:_Pedido:_dados_do_pedido:_ID:TEXT, "municipio nao encontrado", pArquivo, "2")
		return .F.
	Endif
	
	RecLock("SA1",.T.)
	SA1->A1_FILIAL 	:= XFILIAL("SA1")
	SA1->A1_COD 	:= cNum
	SA1->A1_LOJA 	:= "0001"
	SA1->A1_TIPO 	:= _cTipo
	SA1->A1_PESSOA 	:= alltrim(oXML:_Pedido:_Dados_Cliente:_Tipo:TEXT)
	SA1->A1_DTNASC 	:= Stod(substr(oXML:_Pedido:_Dados_Cliente:_data_nascimento:TEXT,7,4)+substr(oXML:_Pedido:_Dados_Cliente:_data_nascimento:TEXT,4,2)+substr(oXML:_Pedido:_Dados_Cliente:_data_nascimento:TEXT,1,2))
	SA1->A1_CGC 	:= alltrim(oXML:_Pedido:_Dados_Cliente:_documento_de_registro:TEXT)
	SA1->A1_NOME 	:= UPPER(alltrim(oXML:_Pedido:_Dados_Cliente:_Nome:TEXT))
	SA1->A1_NREDUZ 	:= UPPER(alltrim(oXML:_Pedido:_Dados_Cliente:_Nome:TEXT))
	SA1->A1_EMAIL 	:= alltrim(oXML:_Pedido:_Dados_Cliente:_Email:TEXT)
	SA1->A1_X_MAILN := alltrim(oXML:_Pedido:_Dados_Cliente:_Email:TEXT)
	SA1->A1_END 	:= alltrim(oXML:_Pedido:_endereco_cobranca:_endereco:TEXT)  + "," + alltrim(oXML:_Pedido:_endereco_cobranca:_numero:TEXT)
	SA1->A1_COMPLEM := SUBSTR(alltrim(oXML:_Pedido:_endereco_cobranca:_Complemento:TEXT),1,50)
	SA1->A1_EST 	:= UPPER(alltrim(oXML:_Pedido:_endereco_cobranca:_Estado:TEXT))
	SA1->A1_COD_MUN := _cCodMun
	SA1->A1_MUN 	:= _cMun
	SA1->A1_BAIRRO 	:= alltrim(oXML:_Pedido:_endereco_cobranca:_Bairro:TEXT)
	SA1->A1_CEP 	:= alltrim(oXML:_Pedido:_endereco_cobranca:_cep:TEXT)
	SA1->A1_PAIS	:= "105"
	SA1->A1_CODPAIS := "01058 "
	SA1->A1_NATUREZ := "1012001"
	SA1->A1_VEND	:= Alltrim(oXML:_Pedido:_dados_do_pedido:_operacao_kmv:TEXT)
	SA1->A1_CONTA	:= "1120201001"
	SA1->A1_CONTRIB	:= "2"
	SA1->A1_DTCADAS := dDataBase
	SA1->A1_RISCO   := "D"
	SA1->A1_MOEDALC := 1
	SA1->A1_LC	:= VAL(oXML:_Pedido:_dados_do_pedido:_total:TEXT)
	SA1->A1_VENCLC	:= dDataBase
	If alltrim(oXML:_Pedido:_Dados_Cliente:_inscricao_estadual:TEXT) == ""
		SA1->A1_INSCR 	:= "ISENTO"
	else
		SA1->A1_INSCR 	:= alltrim(oXML:_Pedido:_Dados_Cliente:_inscricao_estadual:TEXT)
	EndIf
	SA1->A1_DDD 	:= alltrim(oXML:_Pedido:_endereco_cobranca:_ddd:TEXT)
	SA1->A1_TEL 	:= alltrim(oXML:_Pedido:_endereco_cobranca:_Telefone:TEXT)
	SA1->A1_X_COBEX	:= "N"
	SA1->A1_X_SERAS := "N" 
	SA1->A1_FORMPAG := "R$"
	SA1->A1_MSBLQL  := "2"
	MsUnlock()
else

	dbSelectArea("CC2")
	dbSetOrder(2)
	If dbSeek(xFilial("CC2")+UPPER(NOACENTO(ANSITOOEM(oXML:_Pedido:_endereco_cobranca:_cidade:TEXT))))
		_cMun := ALLTRIM(CC2->CC2_MUN)
		_cCodMun := ALLTRIM(CC2->CC2_CODMUN)
	Else
		fLog(oXML:_Pedido:_dados_do_pedido:_ID:TEXT, "municipio nao encontrado", pArquivo, "2")
		return .F.
	Endif


	RecLock("SA1",.F.)
	SA1->A1_DTCADAS := dDataBase
	SA1->A1_RISCO   := "D"
	SA1->A1_MOEDALC := 1
	SA1->A1_LC	:= VAL(oXML:_Pedido:_dados_do_pedido:_total:TEXT)
	SA1->A1_VENCLC	:= dDataBase
	SA1->A1_VEND	:= Alltrim(oXML:_Pedido:_dados_do_pedido:_operacao_kmv:TEXT)
	SA1->A1_EMAIL 	:= alltrim(oXML:_Pedido:_Dados_Cliente:_Email:TEXT)
	SA1->A1_X_MAILN := alltrim(oXML:_Pedido:_Dados_Cliente:_Email:TEXT)
	SA1->A1_END 	:= alltrim(oXML:_Pedido:_endereco_cobranca:_endereco:TEXT)  + "," + alltrim(oXML:_Pedido:_endereco_cobranca:_numero:TEXT)
   	SA1->A1_COMPLEM := SUBSTR(alltrim(oXML:_Pedido:_endereco_cobranca:_Complemento:TEXT),1,50)
   	SA1->A1_EST 	:= UPPER(alltrim(oXML:_Pedido:_endereco_cobranca:_Estado:TEXT))
	SA1->A1_COD_MUN := _cCodMun
	SA1->A1_MUN 	:= _cMun
	SA1->A1_BAIRRO 	:= alltrim(oXML:_Pedido:_endereco_cobranca:_Bairro:TEXT)
	SA1->A1_CEP 	:= alltrim(oXML:_Pedido:_endereco_cobranca:_cep:TEXT)
	SA1->A1_DDD 	:= alltrim(oXML:_Pedido:_endereco_cobranca:_ddd:TEXT)
	SA1->A1_TEL 	:= alltrim(oXML:_Pedido:_endereco_cobranca:_Telefone:TEXT)
	SA1->A1_X_COBEX	:= "N"
	SA1->A1_X_SERAS := "N" 
	SA1->A1_FORMPAG := "R$"
	SA1->A1_MSBLQL  := "2"
	MsUnlock()
EndIf

If fTemPed(oXML:_Pedido:_dados_do_pedido:_ID:TEXT)

	If pTipo = 1 //importação automatica
		
		//SELECIONAR OS ESTADOS QUE TEM % PARA A UF DO CLIENTE
		cQuery := "SELECT ZX2_UFORI , MIN(ZX2_PERC) ZX2_PERC FROM " + RetSqlName("ZX2") + " ZX2 "
		cQuery += " WHERE ZX2_UFDEST = '" + UPPER(SA1->A1_EST) + "' "
		cQuery += " AND ZX2.D_E_L_E_T_ <> '*' "
		cQuery += " GROUP BY ZX2_UFORI ORDER BY ZX2_PERC  "
		
		cQuery := ChangeQuery(cQuery)
		
		If Select("WORK") != 0
			WORK->( DbCloseArea() )
		EndIf
		
		TCQUERY cQuery NEW ALIAS "WORK"
		dbSelectArea("WORK")
		
		While WORK->(!EOF())
			//SELECIONAR EMPRESAS/FILIAIS
			//cIndex := CriaTrab(Nil, .F.)
			//IndRegua("SM0", cIndex, "M0_CODIGO+M0_CODFIL",, "M0_ESTCOB='"+WORK->ZX2_UFORI+"'", "",.F.) 
			dbSelectArea("SM0") 		
			SM0->(dbGoTop())
			
			aEmp := {}
			While SM0->(!EOF()) 
				If SM0->M0_ESTCOB == WORK->ZX2_UFORI
					aadd(aEmp,{SM0->M0_CODIGO,SM0->M0_CODFIL})
				EndIf
	
				dbSelectArea("SM0")
				SM0->(DBSKIP())
			EndDo  
			
		   //	FErase(cIndex)
			
			ASORT(aEmp,,,{|x,y| x[1]+X[2]>y[1]+y[2]})
					
			For _xEMP := 1 to len(aEmp)			
				//ABRE EMPRESA E VERIFICA O SALDO
				EmpOpenFile("SB1","SB1",1,.T.,aEmp[_xEMP][1],@cModo)
				
				aSB2 := {}				
				lImporta := .F.      				
				_nChild := IIF(ValType(oXML:_Pedido:_PRODUTOS:_Produto)=="O",XmlChildCount(oXML:_Pedido:_PRODUTOS),len(oXML:_Pedido:_PRODUTOS:_Produto) )
				For x := 1 to _nChild
					SB1->(DbSetOrder(1))
					
					_cProduto := IIF(_nChild>1,oXML:_Pedido:_PRODUTOS:_Produto[x]:_SKU:text,oXML:_Pedido:_PRODUTOS:_Produto:_SKU:text)
					If SB1->(DbSeek(xFilial("SB1")+ALLTRIM(_cProduto)))
						//sql
						cQuery := "SELECT DISTINCT ZX0_LOCAL "
						cQuery += " FROM " + RetSqlName("ZX0") + "  ZX0   "
						cQuery += " WHERE (ZX0_PRODUT = '"+SB1->B1_COD+"' OR ZX0_GRUPO = '"+SB1->B1_GRUPO+"')  "
						cQuery += " AND ZX0_EMPEXP = '"+aEmp[_xEMP][1]+"'"
						cQuery += " AND ZX0_FILEXP = '"+aEmp[_xEMP][2]+"'"
						cQuery += " AND ZX0.D_E_L_E_T_ <> '*'"
						
						cQuery := ChangeQuery(cQuery)
						
						If Select("TRBZX0") != 0
							TRBZX0->( DbCloseArea() )
						EndIf
						
						TCQUERY cQuery NEW ALIAS "TRBZX0"
						dbSelectArea("TRBZX0")
						
						//BUSCO OS SALDOS DE TODOS OS ARMAZENS CADASTRADOS 
						While TRBZX0->(!EOF())
							EmpOpenFile("SB2","SB2",1,.T.,aEmp[_xEMP][1],@cModo)
							EmpOpenFile("SD4","SD4",1,.T.,aEmp[_xEMP][1],@cModo)
							EmpOpenFile("SC2","SC2",1,.T.,aEmp[_xEMP][1],@cModo)
							EmpOpenFile("SDC","SDC",1,.T.,aEmp[_xEMP][1],@cModo)
							
							SB2->(DbSetOrder(1))
							SB2->(DbSeek(aEmp[_xEMP][2]+SB1->B1_COD+TRBZX0->ZX0_LOCAL))
							nSaldo := SaldoSB2()
							
							If nSaldo > 0
								lImporta := .T. 
								//salva o armazem com saldo  
								AADD(aSB2,{ALLTRIM(SB1->B1_COD),TRBZX0->ZX0_LOCAL})
							EndIf
							
							SB2->( dbCloseArea() )
							SD4->( dbCloseArea() )
							SC2->( dbCloseArea() )
							SDC->( dbCloseArea() )
							
							dbSelectArea("TRBZX0")
							TRBZX0->(DBSKIP())
						EndDo
					ENDIF
				Next x
				
				SB1->( dbCloseArea() )
				
				If lImporta  
				
					_Empresa:= aEmp[_xEMP][1] 
					_Filial := aEmp[_xEMP][2] 				

					EXIT
				endif
	
			Next _xEMP
			
			If lImporta
				EXIT
			endif
			
			dbSelectArea("WORK")
			WORK->(DBSKIP())
		EndDo 
		
		/*If _xEMP > 0 .AND. _xEMP < LEN(aEmp)
			_Empresa:= aEmp[_xEMP][1] 
			_Filial := aEmp[_xEMP][2] 
		else
			_Empresa:= cEmpAnt
			_Filial := cFilAnt			
		endif */
	Else
		lImporta := .T.
		
		_Empresa := MV_PAR05
		_Filial := MV_PAR06
	EndIf
	
	If lImporta

		_Cliente := SA1->A1_COD
		_Loja := SA1->A1_LOJA
		_Tipo := SA1->A1_PESSOA	
//		If _Empresa <> "" .AND. (_Empresa <> cEmpAnt .or. _Filial <> cFilAnt)
//	  		RpcSetType(3)
//			RpcClearEnv()
//			RPCSetEnv(_Empresa,_Filial)
//		EndIf

		If fTemPed(oXML:_Pedido:_dados_do_pedido:_ID:TEXT)
		
			cDoc := GetSxeNum("SC5","C5_NUM") 
			_cTes:= SuperGetMv("MVX_TESADE",.F.,"681")
			
			aAdd(aCabec,{"C5_FILIAL"	,xFilial("SC5")			,Nil})
			aAdd(aCabec,{"C5_NUM"		,cDoc					,Nil})
			aAdd(aCabec,{"C5_TIPO"		,"N"					,Nil}) 
			aAdd(aCabec,{"C5_TPVENDA"	,"N"					,Nil})
			aAdd(aCabec,{"C5_CLIENTE"	,_Cliente			,Nil})
			aAdd(aCabec,{"C5_LOJACLI"	,_Loja			,Nil})
			aAdd(aCabec,{"C5_EMISSAO"	,dDataBase				,Nil})
			//aqui diana
			if Alltrim(oXML:_Pedido:_dados_do_pedido:_operacao_kmv:TEXT) = "P00422"
					_xPedido:= Alltrim(oXML:_Pedido:_dados_do_pedido:_ID:TEXT)+"P"
			elseif 	Alltrim(oXML:_Pedido:_dados_do_pedido:_operacao_kmv:TEXT) = "P00253"
					_xPedido:= Alltrim(oXML:_Pedido:_dados_do_pedido:_ID:TEXT)+"K"
			elseif Alltrim(oXML:_Pedido:_dados_do_pedido:_operacao_kmv:TEXT) = "P00466"
					_xPedido:= Alltrim(oXML:_Pedido:_dados_do_pedido:_ID:TEXT)+"E"
			endif
			//fim		
			aAdd(aCabec,{"C5_VEND1"		,Alltrim(oXML:_Pedido:_dados_do_pedido:_operacao_kmv:TEXT)				,Nil})
			aAdd(aCabec,{"C5_X_CLVL"	,Alltrim(oXML:_Pedido:_dados_do_pedido:_segmento:TEXT)	,Nil})
			aAdd(aCabec,{"C5_TPFRETE"	,"C"					,Nil})
			aAdd(aCabec,{"C5_XPEDADE"	,_xPedido	,Nil})    
			//condiçao de pagamento
			If valtype(oXML:_Pedido:_formas_de_pagamento:_pagamento)=="A"  
				cFormaPag:=Alltrim(oXML:_Pedido:_formas_de_pagamento:_pagamento[1]:_forma_de_pagamento:TEXT)
				cParcelas:=Alltrim(oXML:_Pedido:_formas_de_pagamento:_pagamento[1]:_parcelas_cartao:TEXT)
			Else                                                                                         
				cFormaPag:=Alltrim(oXML:_Pedido:_formas_de_pagamento:_pagamento:_forma_de_pagamento:TEXT)
				cParcelas:=Alltrim(oXML:_Pedido:_formas_de_pagamento:_pagamento:_parcelas_cartao:TEXT)	
			Endif
			If cFormaPag == "DEPOSIT"
				aAdd(aCabec,{"C5_CONDPAG"	,"001"				,Nil})
			ElseIf cFormaPag == "BILLED_BY_THIRD_PARTS"
				aAdd(aCabec,{"C5_CONDPAG"	,"008"				,Nil})			
			Else //VERIFICAR CAMPO CUSTOMIZADO
				dbSelectArea("SE4")
				SET FILTER TO SE4->E4_XPARADE == VAL(cParcelas)
				SE4->(DbGoTop())
				
				If SE4->(!EOF())
					aAdd(aCabec,{"C5_CONDPAG"	,SE4->E4_CODIGO	,Nil})
				Else
					fLog(oXML:_Pedido:_dados_do_pedido:_ID:TEXT, "CONDICAO DE PAGAMENTO NAO ENCONTRADA: " + cParcelas + " PARCELAS", pArquivo, "2")
					return .F.
				Endif
				
				dbSelectArea("SE4")
				SET FILTER TO
				SE4->(DbGoTop())
			Endif
			//Transportadora
		   	dbSelectArea("ZX4") 
		   	ZX4->(DbGoTop())
			CONOUT("ANTES TRANSPORTADORA")
			If ZX4->(DbSeek(xFilial("ZX4")+_Empresa+_Filial))            
				//PROCURA ESTADO/MUNICIPIO DO CLIENTE		
				_cLocal:=ZX4->ZX4_LOCAL
				dbSelectArea("SA1")
				DBSETORDER(1)
				DBSEEK(xFilial("SA1")+_Cliente+_Loja)
				_cEstado:=SA1->A1_EST
				_cMuni:=SA1->A1_COD_MUN
				dbSelectArea("ZX3")
				ZX3->(DbGoTop())
				If ZX3->(DbSeek(xFilial("ZX3")+_cLocal+_cEstado+_cMuni))	  
				//If ZX3->(DbSeek(xFilial("ZX3")+ZX4->ZX4_LOCAL+SA1->A1_EST+SA1->A1_COD_MUN))	  
					aAdd(aCabec,{"C5_TRANSP"	,ZX3->ZX3_TRANSP ,Nil})			
					conout("Entrou if tranportadora")
				ElseIf ZX3->(DbSeek(xFilial("ZX3")+_cLocal+_cEstado+"TODOS"))				
					aAdd(aCabec,{"C5_TRANSP"	,ZX3->ZX3_TRANSP ,Nil})			
					conout("Entrou if tranportadora TODOS")
				EndIf
			EndIf
			
			aItens	:= {}
			cItem	:= "00"
			_nChild := IIF(ValType(oXML:_Pedido:_PRODUTOS:_Produto)=="O",XmlChildCount(oXML:_Pedido:_PRODUTOS),len(oXML:_Pedido:_PRODUTOS:_Produto) )
			
			//calcular desconto/acrescimo  
			nValDeAc := 0 
			If XmlChildCount(oxml:_Pedido:_descontos) > 0
				_nCntDesc:= IIF(ValType(oxml:_Pedido:_descontos:_desconto)=="A",len(oxml:_Pedido:_descontos:_desconto),XmlChildCount(oxml:_Pedido:_descontos)) 
				If _nCntDesc > 0   
					If ValType(oxml:_Pedido:_descontos:_desconto)=="A"
						For x := 1 to _nCntDesc 
							nValDeAc += Val(oXML:_Pedido:_Descontos:_Desconto[x]:_valor:text)
						Next x
					else
						nValDeAc := Val(oXML:_Pedido:_Descontos:_Desconto:_valor:text)
					endif                                                                
					
					nValDeAc := (nValDeAc + Val(oXML:_Pedido:_acrescimos:_acrescimo:_valor:text)) / _nChild
				endif
			elseif xmlchildcount(oxml:_Pedido:_acrescimos) > 0
				nValDeAc := Val(oXML:_Pedido:_acrescimos:_acrescimo:_valor:text) / _nChild
			EndIf	            
			
			//array itens do pedido
			For x := 1 to _nChild 
				cItem		:= Soma1(cItem)
				aItem		:= {}
		
				If _nChild > 1
					nQtdPed := VAL(oXML:_Pedido:_PRODUTOS:_Produto[x]:_quantidade:text)
					nPrcVen := Round(VAL(oXML:_Pedido:_PRODUTOS:_Produto[x]:_preco:text),TamSX3("C6_PRCVEN")[2]) //TransForm(VAL(oXML:_Pedido:_PRODUTOS:_Produto:_preco:text),PesqPict("SC6","C6_PRCVEN")) //
					_cProduto:= ALLTRIM(oXML:_Pedido:_PRODUTOS:_Produto[x]:_SKU:text)
				else		
					nQtdPed := VAL(oXML:_Pedido:_PRODUTOS:_Produto:_quantidade:text)
					nPrcVen := Round(VAL(oXML:_Pedido:_PRODUTOS:_Produto:_preco:text),TamSX3("C6_PRCVEN")[2]) //TransForm(VAL(oXML:_Pedido:_PRODUTOS:_Produto:_preco:text),PesqPict("SC6","C6_PRCVEN")) //
					_cProduto:= ALLTRIM(oXML:_Pedido:_PRODUTOS:_Produto:_SKU:text)
				Endif
				
				nPrcVen += (nValDeAc / nQtdPed)
				
				aAdd(aItem,{"C6_FILIAL"	,xFilial("SC6")		,Nil})
				aAdd(aItem,{"C6_ITEM"	,cItem				,Nil})
				aAdd(aItem,{"C6_PRODUTO",_cProduto			,Nil})
				aAdd(aItem,{"C6_QTDVEN"	,nQtdPed   			,Nil})
				aAdd(aItem,{"C6_PRCVEN"	,NoRound(nPrcVen,2)	,Nil})
				aAdd(aItem,{"C6_VALOR"	,nQtdPed * NoRound(nPrcVen,TamSX3("C6_VALOR")[2])		,Nil})
				aAdd(aItem,{"C6_PRUNIT"	,NoRound(nPrcVen,2)	,Nil})
				aAdd(aItem,{"C6_QTDLIB"	,nQtdPed   			,Nil})
				aAdd(aItem,{"C6_TES"	,_cTes 				,Nil})

				//CORREÇÃO DO ARMAZEM
				nPos := aScan( aSB2, { |x| x[1] == _cProduto } ) 						
				If nPos > 0
					aAdd(aItem,{"C6_LOCAL"	,aSB2[nPos][2] 	,Nil})				
				Endif
				
				aAdd(aItens,aItem)
			Next x                 
			
			BeginTran()

			lMsErroAuto:= .F.
			lImportado:=.F.
			MsExecAuto({|x,y,z| Mata410(x,y,z)}, aCabec, aItens,3)
			
			If lMsErroAuto   		  
				MsUnlockAll()	
				DisarmTransaction()
				
				cErro:= NoAcento(AnsiToOem(MemoRead(NomeAutoLog())))
				fLog(oXML:_Pedido:_dados_do_pedido:_ID:TEXT, cErro, pArquivo, "2")
			Else
				lImportado:=.T.
				ConfirmSX8()
				EndTran()
				
				fLog(oXML:_Pedido:_dados_do_pedido:_ID:TEXT, "Pedido Importado", pArquivo, "1")	
				
				//liberação do pedido - não é necessário                                                                            
				/*dbSelectArea("SC6")
				SC6->(dbSeek(xFilial("SC6")+SC5->C5_NUM))
				While SC6->(!EOF()) .AND. SC6->C6_NUM == SC5->C5_NUM
					MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN   ,.T.     ,.T.    ,.F.   ,.T.    )	
					
					SC6->(DbSkip())
				EndDo */
			Endif          
		
			MsUnlockAll() 
		EndIf
	Else
		fLog(oXML:_Pedido:_dados_do_pedido:_ID:TEXT, "Sem saldo dos itens", pArquivo, "2")	
	EndIf

Endif

Return lImportado

Static Function fLog(pIDPed, pTexto, pFile, pStatus)
Local nRecn := 1
local cTabZX1 := "ZX1300"

cQuery := "SELECT R_E_C_N_O_ RECZX1 FROM " + cTabZX1
cQuery += " WHERE ZX1_PEDADE = '" + pIDPed + "' "
cQuery += " AND D_E_L_E_T_ <> '*' "

cQuery := ChangeQuery(cQuery)

If Select("TMPID") != 0
	TMPID->( DbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "TMPID"
dbSelectArea("TMPID")

If TMPID->(EOF())
	
	TMPID->( DbCloseArea() )
	
	cQuery := "SELECT MAX(R_E_C_N_O_) MAXR FROM " + cTabZX1
	TCQUERY cQuery NEW ALIAS "TMPID"
	dbSelectArea("TMPID")
	If TMPID->(!EOF())
		nRecn += TMPID->MAXR
	Endif
	
	cQry := " INSERT INTO " + cTabZX1 + " " + ;
	" (ZX1_FILIAL, ZX1_PEDADE, ZX1_DATA, ZX1_FILE, ZX1_STATUS, ZX1_PEDIDO, R_E_C_N_O_ , ZX1_TEXTO, ZX1_EMPIMP, ZX1_FILIMP) " + ;
	" VALUES(' ','" + pIDPed + "','" + DTOS(dDataBase) + "','"  + pFile + "','" + pStatus + "','" + IIF(pStatus=="1",SC5->C5_NUM, space(2)) + "'," + ;
	" " + str(nRecn) + ",RAWTOHEX('" + Alltrim(pTexto) + "'),'" + IIF(pStatus=="1",cEmpAnt, space(2)) + "','"+ IIF(pStatus=="1",SC5->C5_FILIAL, space(2)) +"')"
	TCSQLEXEC(cQry)

	TcSqlExec( "COMMIT" )	
Else
	cQry := " UPDATE " + cTabZX1 + " " + ;
	" SET ZX1_DATA = '"+ DTOS(dDataBase) + "',"  + ;
	" ZX1_TEXTO = RAWTOHEX('" + Alltrim(pTexto) + "')," + ;
	" ZX1_FILE = '" + pFile + "'," + ;
	" ZX1_STATUS = '" + pStatus + "'," + ;
	" ZX1_PEDIDO = '" + IIF(pStatus=="1",SC5->C5_NUM, space(2)) + "'," + ; 
	" ZX1_EMPIMP = '" + IIF(pStatus=="1",cEmpAnt, space(2)) + "'," + ;
	" ZX1_FILIMP = '" + IIF(pStatus=="1",SC5->C5_FILIAL, space(2)) + "'" + ;	
	" WHERE R_E_C_N_O_ = " + STR(TMPID->RECZX1)
	
	TCSQLEXEC(cQry)
	
	TcSqlExec( "COMMIT" )	
Endif

Return

Static Function fDownload(pDir)
Local aArqs := {}  
Local aFTPKmv := StrToKArr(SuperGetMv("MVX_FTPKMV",.F.,"www.kmvpneus.com.br;21;kmvpneus;topgear"),";")
Local aFTPPS  := StrToKArr(SuperGetMv("MVX_FTPPS" ,.F.,"www.pneustore.com.br;21;pneustore;topgear"),";")
Local cFolderFTP := SuperGetMv("MVX_FOLDPE" ,.F.,"/acceptance/pedidos")

If FTPConnect(aFTPKmv[1],Val(aFTPKmv[2]),aFTPKmv[3],aFTPKmv[4])
	If FTPDirChange(cFolderFTP)
		aArqs := FTPDIRECTORY( "*.xml" )
		For n := 1 to Len(aArqs)
			If !FTPDOWNLOAD("\Adena\"+aArqs[n][1], LOWER(aArqs[n][1] ))
			   //	APMsgInfo( 'Problemas ao copiar arquivo '+ aArqs[n][1] )
			Else
				If !FTPERASE( aArqs[n][1] )
					//APMsgInfo('Problemas ao apagar o arquivo ' + aArqs[n][1] )
				EndIf
			EndIf
		Next n
	EndIf  
	
	FTPDisConnect()
EndIf

If FTPConnect(aFTPPS[1],Val(aFTPPS[2]),aFTPPS[3],aFTPPS[4])
	If FTPDirChange(cFolderFTP)
		aArqs := FTPDIRECTORY( "*.xml" )
		For n := 1 to Len(aArqs)
			If !FTPDOWNLOAD("\Adena\"+aArqs[n][1], aArqs[n][1] )
			   //	APMsgInfo( 'Problemas ao copiar arquivo '+ aArqs[n][1] )
			Else
				If !FTPERASE( aArqs[n][1] )
					//APMsgInfo('Problemas ao apagar o arquivo ' + aArqs[n][1] )
				EndIf
			EndIf
		Next n
	EndIf 
	
	FTPDisConnect()	
EndIf

Return       

Static Function fTemPed(pIDPed)
Local cQuery := ""

cQuery := "SELECT C5_XPEDADE FROM " + RetSqlName("SC5")
cQuery += " WHERE C5_XPEDADE = '" + pIDPed + "' "
cQuery += " AND D_E_L_E_T_ <> '*' "

cQuery := ChangeQuery(cQuery)

If Select("TMPID") != 0
	TMPID->( DbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "TMPID"
dbSelectArea("TMPID")

Return TMPID->(EOF())