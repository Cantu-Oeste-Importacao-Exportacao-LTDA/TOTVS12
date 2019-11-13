#INCLUDE "parmtype.ch""
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"
#INCLUDE "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³INCPAYTRACK  ºAutor  ³Gustavo Lattmann   Data ³  15/10/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Realizado a inclusão do fornecedor baseado no arquivo txt  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IMPSA2WM()

	Local cPathArq := "/fornecedores/"

	Local nLinha := 0
	Local cLinha := ""
	Local aLinArq := {}
	Local aLinha := {}
	Local cTipo := ""
	

	//-- Cria diretorio para gravar arquivos importados
	MakeDir(cPathArq + "imp/")

	//-- Cria diretorio para gravar arquivos com erros
	MakeDir(cPathArq + "erro/")

	//-- Busca arquivos txt dentro do diretório do servidor
	aFiles := Directory(cPathArq +"*.txt")

	If Empty(aFiles)
		Conout("IMPSA2WM - SEM ARQUIVOS A IMPORTAR")
		Return
	EndIf

	For nFileImp := 1 to Len(aFiles)
		cFileImp := cPathArq + aFiles[nFileImp,1]
		cFileMov := cPathArq + "imp/" + aFiles[nFileImp,1]
		cFileErr := cPathArq + "erro/" + aFiles[nFileImp,1]
		
		//-- Verifica pelo nome do arquivo o tipo do cadastro
		Do Case
			Case "JURIDICA" $ Upper(aFiles[nFileImp,1])
				cTipo := "J"
			Case "FISICA" $ Upper(aFiles[nFileImp,1])
				cTipo := "F"
			Case "PRODUTOR" $ Upper(aFiles[nFileImp,1])
				cTipo := "P"	
			Case "TARGET" $ Upper(aFiles[nFileImp,1]) 
				cTipo := "T"
			Otherwise
				cTipo := "J"
		EndCase

		//-- Abre o arquivo posicionado
		FT_FUSE(cFileImp)
		nLinha := FT_FLASTREC()
		FT_FGOTOP()
		//-- Percorre todas as linhas do arquivo
		For nX := 1 To nLinha
			cLinha := FT_FREADLN()
			//-- Converte a linha do arquivo para um array
			aLinArq := StrTokArr2(cLinha,";",.T.)

			/*
			//-- Trativa para caso o arquivo venha diferente do layout
			If Len(aLinArq) != 9
				Conout("IMPSA2WM - Linha do arquivo fora do padrão")
				FRename(cFileImp,cFileErr)
				Return
			EndIf
			*/
			
			aAdd(aLinha,aLinArq)
			FT_FSKIP()
			aLinArq := {}
		Next nX

		FT_FUse()

		//-- Antes de passar para o próximo arquivo deve fazer a inclusão do fornecedor
		lRet := U_EXECSA2WS(aLinha,cTipo)
		
		//-- Caso a inclusão do fornecedor tenha sido realizada move para a pasta imp, senão para a pasta erro
		If lRet
			FRename(cFileImp,cFileMov)
		Else
			FRename(cFileImp,cFileErr)
		End
		aLinha := {}

	Next nFileImp

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EXECPAYTR    ºAutor  ³Gustavo Lattmann   Data ³  01/08/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Realizado a inclusão da pré-nota baseado no arquivo txt    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function EXECSA2WS(aDados,cTipoCad)

	Local nOpc := 3 //Inclusão
	
	//-- Posição dos campos dentro do arquivo 
	Local nPosSoli 	:= 0 //Solicitante
	Local nPosFili	:= 0 //Filial
	Local nPosCNPJ 	:= 0 //CNPJ	
	Local nPosNome 	:= 0 //Razão Social
	Local nPosFant 	:= 0 //Fantasia
	Local nPosIE   	:= 0 //Inscrição Estadual
	Local nPosInsM  := 0 //Inscrição Municipal
	Local nPosCEP 	:= 0 //CEP
	Local nPosEnd	:= 0 //Endereco
	Local nPosBair	:= 0 //Bairro
	Local nPosUF	:= 0 //Estado
	Local nPosMun	:= 0 //Municipio
	Local nPosComp	:= 0 //Complemento
	Local nPosPais	:= 0 //País
	Local nPosDDD	:= 0 //DDD
	Local nPosFone	:= 0 //Telefone
	Local nPosMail	:= 0 //E-mail
	Local nPosNatu	:= 0 //Natureza Financeira
	Local nPosCond	:= 0 //Condiação Pagamento
	Local nPosPgto	:= 0 //Forma de Pagamento
	Local nPosBanc	:= 0 //Banco
	Local nPosAgen	:= 0 //Agencia
	Local nPosDAge	:= 0 //Digito Agencia
	Local nPosCont	:= 0 //Conta
	Local nPosDCon	:= 0 //Digito Conta		

	Local lSucesso := .F.
	Local cCNPJ := ""
	
	Private aForn      := {}
	Private cEmpIni := "06"
	Private cFilIni := "01"
	Private lMsErroAuto := .F.
	
	Do Case 
		Case cTipoCad == "J"
			cTipo := "J"
			nPosSoli 	:= 1 //Solicitante
			nPosFili	:= 2 //Filial
			nPosCNPJ 	:= 3 //CNPJ	
			nPosNome 	:= 4 //Razão Social
			nPosFant 	:= 5 //Fantasia
			nPosIE   	:= 6 //Inscrição Estadual
			nPosInsM  	:= 7 //Inscrição Municipal
			nPosCEP 	:= 8 //CEP
			nPosEnd		:= 9 //Endereco
			nPosBair	:= 10 //Bairro
			nPosUF		:= 11 //Estado
			nPosMun		:= 12 //Municipio
			nPosComp	:= 13 //Complemento
			nPosPais	:= 14 //País
			nPosDDD		:= 15 //DDD
			nPosFone	:= 16 //Telefone
			nPosMail	:= 17 //E-mail
			nPosNatu	:= 18 //Natureza Financeira
			nPosCond	:= 19 //Condiação Pagamento
			nPosPgto	:= 20 //Forma de Pagamento
			nPosBanc	:= 21 //Banco
			nPosAgen	:= 22 //Agencia
			nPosDAge	:= 23 //Digito Agencia
			nPosCont	:= 24 //Conta
			nPosDCon	:= 25 //Digito Conta
		Case cTipoCad == "F"
			cTipo := "F"
			nPosSoli 	:= 1 //Solicitante
			nPosFili	:= 2 //Filial
			nPosCNPJ 	:= 3 //CNPJ	
			nPosNome 	:= 4 //Razão Social
			nPosFant 	:= 4 //Fantasia
			//nPosIE   	:= 6 //Inscrição Estadual
			//nPosInsM 	:= 7 //Inscrição Municipal
			nPosCEP 	:= 5 //CEP
			nPosEnd		:= 6 //Endereco
			nPosBair	:= 7 //Bairro
			nPosUF		:= 8 //Estado
			nPosMun		:= 9 //Municipio
			nPosComp	:= 10 //Complemento
			nPosPais	:= 11 //País
			nPosDDD		:= 12 //DDD
			nPosFone	:= 13 //Telefone
			nPosMail	:= 14 //E-mail
			nPosNatu	:= 15 //Natureza Financeira
			nPosCond	:= 16 //Condiação Pagamento
			nPosPgto	:= 17 //Forma de Pagamento
			nPosBanc	:= 18 //Banco
			nPosAgen	:= 19 //Agencia
			nPosDAge	:= 20 //Digito Agencia
			nPosCont	:= 21 //Conta
			nPosDCon	:= 22 //Digito Conta
		Case cTipoCad == "T"
			cTipo = "F"
			nPosSoli 	:= 1 //Solicitante
			nPosFili	:= 2 //Filial
			nPosCNPJ 	:= 3 //CNPJ	
			nPosNome 	:= 4 //Razão Social
			nPosFant 	:= 4 //Fantasia
			nPosIE   	:= 8 //Inscrição Estadual
			nPosInsM 	:= 9 //Inscrição Municipal
			nPosCEP 	:= 10 //CEP
			nPosEnd		:= 11 //Endereco
			nPosBair	:= 12 //Bairro
			nPosUF		:= 13 //Estado
			nPosMun		:= 14 //Municipio
			nPosComp	:= 15 //Complemento
			nPosPais	:= 16 //País
			nPosDDD		:= 17 //DDD
			nPosFone	:= 18 //Telefone
			nPosMail	:= 19 //E-mail
			nPosNatu	:= 20 //Natureza Financeira
			nPosCond	:= 21 //Condiação Pagamento
			nPosPgto	:= 22 //Forma de Pagamento
			nPosBanc	:= 23 //Banco
			nPosAgen	:= 24 //Agencia
			nPosDAge	:= 25 //Digito Agencia
			nPosCont	:= 26 //Conta
			nPosDCon	:= 27 //Digito Conta	
		Case cTipoCad == "P" 
			cTipo := "F"
			nPosSoli 	:= 1 //Solicitante
			nPosFili	:= 2 //Filial
			nPosCNPJ 	:= 3 //CNPJ	
			nPosNome 	:= 4 //Razão Social
			nPosFant 	:= 4 //Fantasia
			nPosIE   	:= 8 //Inscrição Estadual
			nPosInsM 	:= 9 //Inscrição Municipal
			nPosCEP 	:= 10 //CEP
			nPosEnd		:= 11 //Endereco
			nPosBair	:= 12 //Bairro
			nPosUF		:= 13 //Estado
			nPosMun		:= 14 //Municipio
			nPosComp	:= 15 //Complemento
			nPosPais	:= 16 //País
			nPosDDD		:= 17 //DDD
			nPosFone	:= 18 //Telefone
			nPosMail	:= 19 //E-mail
			nPosNatu	:= 20 //Natureza Financeira
			nPosCond	:= 21 //Condiação Pagamento
			nPosPgto	:= 22 //Forma de Pagamento
			nPosBanc	:= 23 //Banco
			nPosAgen	:= 24 //Agencia
			nPosDAge	:= 25 //Digito Agencia
			nPosCont	:= 26 //Conta
			nPosDCon	:= 27 //Digito Conta					
	EndCase
	
	
	PREPARE ENVIRONMENT EMPRESA cEmpIni FILIAL cFilIni MODULO "COM" TABLES "SA2"
	
	//-- Trata para deixar apenas números no CNPJ/CPF
	cCNPJ := Replace(aDados[1][nPosCNPJ],'.','')
	cCNPJ := Replace(cCNPJ,'-','')
	cCNPJ := Replace(cCNPJ,'/','')
	
	//-- Valida se o fornecedor já não esta cadastrado
	dbSelectArea("SA2")
	SA2->(dbSetOrder(3)) //FILIAL + CGC
	SA2->(dbGoTop())
	If SA2->(dbSeek(xFilial("SA2") + cCNPJ))
		Conout("IMPSA2WM - Fornecedor já cadastrado " + cCNPJ)
		lSucesso := .F.
		SA2->(DbCloseArea())
		Return lSucesso
	Else
		SA2->(DbCloseArea())
	EndIf
	
	//-- Funções para retornar os códigos com base nas descrições
    cMun 	:= fGetMunicipio(aDados[1][nPosUF],NoAcento(aDados[1][nPosMun]))
    cCond 	:= fGetCondicao(aDados[1][nPosCond])

    cPais 	:= fGetPais(aDados[1][nPosPais])
    cBacen 	:= fGetBacen(aDados[1][nPosPais])    
    cCep 	:= Replace(aDados[1][nPosCep],'-','')
    cBanco  := Substr(aDados[1][nPosBanc],1,3)
    
    //-- No caso de pessoa física onde não tem o campo IE no formulário
    If nPosIE == 0
    	cIE := "ISENTO"
    ElseIf aDados[1][nPosIE] == ""
    	cIE := "ISENTO"
    Else
    	cIE := Replace(aDados[1][nPosIE],"-","")
    EndIf
    
    //-- Tratar para quando usuário informa a natureza incorreta
    If Len(aDados[1][nPosNatu]) != 7
    	cNaturez := "2111001"
    Else
    	cNaturez := aDados[1][nPosNatu]
    EndIf
    
    //-- Tratar quando nome fantasia é enviado em branco
    If aDados[1][nPosFant] == ""
    	cFant := cCNPJ
    Else
    	cFant := SubsTr(aDados[1][nPosFant],1,40)
    EndIf
    
    //-- Tratar a forma de pagamento quando enviada como dinheiro
    If Upper(SubStr(aDados[1][nPosPgto],1,2)) == "DI"
    	cFormPg := "R$"
    Else
    	cFormPg := Upper(SubStr(aDados[1][nPosPgto],1,2))
    EndIf
    
	aAdd(aForn,{'A2_TIPO',cTipo,NIL})
	aAdd(aForn,{'A2_CGC',cCNPJ,NIL})
	aAdd(aForn,{'A2_NOME',aDados[1][nPosNome],NIL})
	aAdd(aForn,{"A2_NREDUZ",cFant, nil})
	aAdd(aForn,{"A2_END",aDados[1][nPosEnd], nil})
	aAdd(aForn,{"A2_ENDCOMP",SubsTr(aDados[1][nPosComp],1,20), nil})	
	aAdd(aForn,{"A2_BAIRRO",aDados[1][nPosBair], nil})
	aAdd(aForn,{"A2_EST",aDados[1][nPosUF], nil})
	aAdd(aForn,{"A2_COD_MUN",cMun, nil})
	aAdd(aForn,{"A2_CEP",cCep, nil})
	aAdd(aForn,{"A2_DDD",aDados[1][nPosDDD], nil})
	aAdd(aForn,{"A2_TEL",aDados[1][nPosFone], nil})
	aAdd(aForn,{"A2_INSCR",Substr(cIE,1,18), nil})
	aAdd(aForn,{"A2_INSCRM",IIf(nPosInsM == 0,"",Substr(aDados[1][nPosInsM],1,18)), nil})
	aAdd(aForn,{"A2_BANCO",cBanco, nil})
	aAdd(aForn,{"A2_AGENCIA",aDados[1][nPosAgen], nil})
	aAdd(aForn,{"A2_DIGAGEN",aDados[1][nPosDAge], nil})			
	aAdd(aForn,{"A2_NUMCON",aDados[1][nPosCont], nil})
	aAdd(aForn,{"A2_DIGCON",aDados[1][nPosDCon], nil})	
	aAdd(aForn,{"A2_COND",cCond, nil})
	aAdd(aForn,{"A2_FORMPAG",cFormPg, nil})	
	aAdd(aForn,{"A2_NATUREZ",cNaturez, nil})	
	aAdd(aForn,{"A2_PAIS",cPais, nil})
	aAdd(aForn,{"A2_CODPAIS",AllTrim(cBacen), nil})	
	aAdd(aForn,{"A2_EMAIL",aDados[1][nPosMail], nil})
	aAdd(aForn,{"A2_X_MAILN",aDados[1][nPosMail], nil})	
	aAdd(aForn,{"A2_MSBLQL","1", nil})
	aAdd(aForn,{"A2_TIPOTRP","1", nil})
	aAdd(aForn,{"A2_XORIGE","2", nil}) //Integração RM
	aAdd(aForn,{"A2_RECPIS","2", nil})
	aAdd(aForn,{"A2_RECCOFI","2", nil})
	aAdd(aForn,{"A2_RECCSLL","2", nil})			
														
	MSExecAuto({|x,y| MATA020(x,y)},aForn,nOpc)

	// VALIDAÇÃO DE ERRO NA ROTINA
	If (!lMsErroAuto) // OPERAÇÃO FOI EXECUTADA COM SUCESSO
		ConOut(PadC("IMPSA2WM - Execauto MATA020 executado com sucesso!", 80))
		lSucesso := .T.

	Else // OPERAÇÃO EXECUTADA COM ERRO

		If (!IsBlind()) // COM INTERFACE GRÁFICA
			MostraErro()
		Else // EM ESTADO DE JOB
			cError := MostraErro("/fornecedores/log", "error.log") // ARMAZENA A MENSAGEM DE ERRO

			ConOut(PadC("Automatic routine ended with error", 80))
			ConOut("Error: "+ cError)
		EndIf
	EndIf

	RESET ENVIRONMENT

Return lSucesso


Static Function fGetMunicipio(cEst, cDescMun)

//-- Posiciona na tabela de municipio
dbSelectArea("CC2")
CC2->(dbSetOrder(4)) //FILIAL + EST + MUNICIPIO
CC2->(dbGoTop())
CC2->(dbSeek(xFilial("CC2") + Upper(cEst) + Upper(cDescMun)))

cMun := CC2->CC2_CODMUN

CC2->(dbCloseArea())
   
Return cMun


Static Function fGetCondicao(cDescricao)

//-- Posiciona na tabela de Condição
dbSelectArea("SE4")
SE4->(dbSetOrder(2)) //DESCRICAO
SE4->(dbGoTop())
SE4->(dbSeek(xFilial("SE4") + Upper(cDescricao)))

cCond := SE4->E4_CODIGO

SE4->(dbCloseArea())
   
Return cCond


Static Function fGetPais(cDescricao)

//-- Posiciona na tabela de Pais
dbSelectArea("SYA")
SYA->(dbSetOrder(2)) //DESCRICAO
SYA->(dbGoTop())
SYA->(dbSeek(xFilial("SYA") + Upper(cDescricao)))

cPais := SYA->YA_CODGI

SYA->(dbCloseArea())
   
Return cPais

Static Function fGetBacen(cDescricao)

//-- Posiciona na tabela de Pais Bacen
dbSelectArea("CCH")
CCH->(dbSetOrder(2)) //DESCRICAO
CCH->(dbGoTop())
CCH->(dbSeek(xFilial("CCH") + Upper(cDescricao)))

cBacen := CCH->CCH_CODIGO

CCH->(dbCloseArea())
   
Return cBacen

//-- Função para remover caracteres especiais de string
Static Function NoAcento(cString)
Local cChar  := ""
Local nX     := 0 
Local nY     := 0
Local cVogal := "aeiouAEIOU"
Local cAgudo := "áéíóú"+"ÁÉÍÓÚ"
Local cCircu := "âêîôû"+"ÂÊÎÔÛ"
Local cTrema := "äëïöü"+"ÄËÏÖÜ"
Local cCrase := "àèìòù"+"ÀÈÌÒÙ" 
Local cTio   := "ãõÃÕ"
Local cCecid := "çÇ"
Local cMaior := "&lt;"
Local cMenor := "&gt;"

For nX:= 1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase
		nY:= At(cChar,cAgudo)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCircu)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cTrema)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCrase)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf		
		nY:= At(cChar,cTio)
		If nY > 0          
			cString := StrTran(cString,cChar,SubStr("aoAO",nY,1))
		EndIf		
		nY:= At(cChar,cCecid)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("cC",nY,1))
		EndIf
	Endif
Next

If cMaior$ cString 
	cString := strTran( cString, cMaior, "" ) 
EndIf
If cMenor$ cString 
	cString := strTran( cString, cMenor, "" )
EndIf

cString := StrTran( cString, CRLF, " " )

Return cString