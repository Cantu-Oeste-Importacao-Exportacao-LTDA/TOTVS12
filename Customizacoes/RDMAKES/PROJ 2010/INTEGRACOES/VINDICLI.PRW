#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VINDICLI  ºAutor  ³Gustavo Lattmann    º Data ³  09/12/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Integração de clientes do clube do vinho, via VINDI.		  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function VindiCli() 

Local aClientes := {}
Private cEmpIni	  := "10"
Private cFilIni	  := "01"
Private lMsErroAuto := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Recupera empresa/filial do APPSERVER.INI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cEMPFIL := GetJobProfString("PREPAREIN", "")
cCODEMP := SubSTR(cEMPFIL,1,2) 
cCODFIL := SubSTR(cEMPFIL,4,2)

Conout("VINDICLI - INICIO DE EXECUÇÃO") 

If !Empty(cCODEMP) .and. !Empty(cCODFIL)
	cEmpIni	:= cCODEMP
	cFilIni	:= cCODFIL
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona o sistema em uma empresa para dar início na seleção dos dados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RpcClearEnv()
RpcSetType(3)
RpcSetEnv(cEmpIni, cFilIni,,,,GetEnvServer(),{"SA1"})	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criação de arquivo temporário sobre a execução da rotina³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLock := 0
While !LockByName(iif(!Empty(cCODEMP),"VINDICLI"+cCODEMP,"VINDICLI"),.T.,.F.,.T.)
	nLock += 1
	Sleep(1000)
	If nLock > 10
		ConOut("CONTROLE DE SEMAFORO - Rotina finalizada pois já esta sendo executada!")
		Return
	EndIf		
EndDo    

ConOut("VINDICLI - CONECTANDO NO BANCO INTERMEDIÁRIO...")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Busca os clientes pendentes de integração ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
cSql := "SELECT NOMECLIE, EMAICLIE, DOC_CLIE, RUA_CLIE, NUMECLIE, COMPCLIE, CEP_CLIE, BAIRCLIE, CIDACLIE, ESTACLIE, PAISCLIE "
cSql += " FROM VINDI.VINDCLIE "
cSql += " WHERE V__SCLIE = 0"                                                

TCQUERY cSql NEW ALIAS "TBTMP"

dbSelectArea("TBTMP")
TBTMP->(dbGoTop())  

If TBTMP->(Eof())
	TBTMP->(DbCloseArea())	
	ConOut("VINDICLI - SEM CLIENTES A IMPORTAR") 
	Return  
EndIf          

While TBTMP->(!Eof())
	Aadd(aClientes, {Upper(ALLTRIM(TBTMP->NOMECLIE)),; //1
					Lower(ALLTRIM(TBTMP->EMAICLIE)),; //2
					ALLTRIM(TBTMP->DOC_CLIE),;  //3
					Upper(ALLTRIM(TBTMP->RUA_CLIE)),;  //4
					Upper(ALLTRIM(TBTMP->NUMECLIE)),;  //5
					Upper(ALLTRIM(TBTMP->COMPCLIE)),;  //6
					Upper(ALLTRIM(TBTMP->CEP_CLIE)),;  //7
					Upper(ALLTRIM(TBTMP->BAIRCLIE)),;  //8
					Upper(ALLTRIM(TBTMP->CIDACLIE)),;  //9
					Upper(ALLTRIM(TBTMP->ESTACLIE)),;  //10
					ALLTRIM(TBTMP->PAISCLIE)})  //11
	TBTMP->(dbSkip())
EndDo

TBTMP->(dbCloseArea())

If Len(aClientes) > 0 
	IncluiCliente(aClientes)
EndIf  

  

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VINDICLI  ºAutor  ³Gustavo Lattmann    º Data ³  09/12/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IncluiCliente(aClientes)
	

For nX := 1 To Len(aClientes)
	 
	Conout("VINDICLI - INICIANDO INTEGRACAO CLIENTE " + aClientes[nX][03])
	AltStatus(aClientes[nX][03],"1","C")
	
	//-- Ajustado o código do cliente
   	cCodCli := Substr(aClientes[nX][03],1,9)
	
	//-- Ajusta endereço no padrão Protheus "Rua, numero"
	cEnder := Alltrim(aClientes[nX][4]) + ", " + Alltrim(aClientes[nX][5])
    
	//-- Retorna o código do Municipio conforme tabela Protheus
    cMun :=	fGetMunicipio(aClientes[nX][10],aClientes[nX][09])

	aVetor:= ;
	{{"A1_PESSOA"   ,"F"				,Nil},;  // Tipo Pessoa F=Fisica
	{"A1_COD"    	,cCodCli  			,Nil},;  // Codigo
	{"A1_LOJA"    	,"0001"  			,Nil},;  // Loja	
	{"A1_TIPO"      ,"F"  				,Nil},;  // Tipo F=Consumidor Final	
	{"A1_INSCR"   	,"ISENTO"			,Nil},;  // IE	
	{"A1_NOME"      ,aClientes[nX][01]	,Nil},;  // Nome
	{"A1_NREDUZ"    ,aClientes[nX][01]	,Nil},;  // Nome reduz.
	{"A1_DDD" 	    ,"46"  				,Nil},;  // DDD	
	{"A1_TEL" 	    ,"21014000"			,Nil},;  // Telefone		
	{"A1_END"       ,cEnder				,Nil},;  // Endereco				 
	{"A1_COMPLEM"   ,aClientes[nX][06] 	,Nil},;  // Complemento
	{"A1_BAIRRO"    ,aClientes[nX][08]	,Nil},;  // Bairro	             
	{"A1_CEP"	    ,aClientes[nX][07]	,Nil},;  // CEP	 	
	{"A1_MUN"       ,aClientes[nX][09]	,Nil},;  // Cidade
	{"A1_EST"       ,aClientes[nX][10]	,Nil},;	 // Estado
	{"A1_COD_MUN"   ,cMun				,Nil},;  // Cod. Municipio 
	{"A1_CODPAIS" 	,"01058"			,Nil},;  // Pais Bacen
	{"A1_EMAIL" 	,aClientes[nX][02] 	,Nil},;  // E-mail
	{"A1_X_MAILN" 	,aClientes[nX][02] 	,Nil},;  // E-mail NF-e
	{"A1_NATUREZ" 	,"1012001"		 	,Nil},;  // Natureza
	{"A1_CONTA" 	,"1120201001"		,Nil},;  // Conta Contábil
	{"A1_RISCO" 	,"D"				,Nil},;  // Risco
	{"A1_FORMPAG" 	,"CC"				,Nil},;  // Forma Pagamento CC=Cartão de crédito
	{"A1_COND"	 	,"951"				,Nil},;  // Condição Pagamento	
	{"A1_TPESSOA" 	,"PF"				,Nil},;  // Tipo Fiscal
	{"A1_TPFRET" 	,"C"				,Nil},;  // Frete C=CIF
	{"A1_LC" 		,0					,Nil},;  // Limite Crédito
	{"A1_X_SERAS" 	,"N"				,Nil},;  // Envia Serasa
	{"A1_GRPVEN" 	,"000044"			,Nil}}   // Grupo

    //-- Posiciona na SA1 para verificar se cliente já existe
	dbSelectArea("SA1")
	SA1->(dbSetOrder(1))
	SA1->(dbGoTop())
	
	If SA1->(dbSeek(xFilial("SA1")+ cCodCli))   
	   	Conout("CLIENTE " + aClientes[nX][3] + " JA CADASTRADO, SERA ATUALIZADO") 
	   	MSExecAuto({|x,y| Mata030(x,y)},aVetor,4) //4- Alteração
	Else 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Só passa o CPF quando for inclusão, senão o sistema altera a loja para 0002³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Aadd(aVetor, {"A1_CGC"    	,aClientes[nX][03]	,Nil})
		MSExecAuto({|x,y| Mata030(x,y)},aVetor,3) //3- Inclusão
	EndIf
	
	If lMsErroAuto
		Conout(MOSTRAERRO())
	Else
		Conout("VINDICLI - CLIENTE CADASTRADO COM SUCESSO.")
		AltStatus(aClientes[nX][03],"2","C")
		GeraFatura(aClientes[nX][03])
		EnviaWf(cCodCli)  
	Endif

Next nX 

Return 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VINDICLI  ºAutor  ³Microsiga           º Data ³  01/09/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fGetMunicipio(cEst, cDescMun)

//-- Posiciona na tabela de municipio
dbSelectArea("CC2")
CC2->(dbSetOrder(4)) //FILIAL + EST + MUNICIPIO
CC2->(dbGoTop())
CC2->(dbSeek(xFilial("CC2") + Upper(cEst) + Upper(cDescMun)))

cMun := CC2->CC2_CODMUN

CC2->(dbCloseArea())
   
Return cMun    


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VINDICLI  ºAutor  ³Microsiga           º Data ³  01/09/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AltStatus(cChave,cStatus,cOpc)

//-- cOpc = C (cliente)
//-- cOpc = F (fatura)

If cOpc == "C"

	cSql := "UPDATE VINDI.VINDCLIE "
	cSql += "   SET V__SCLIE = " + cStatus
	cSql += " WHERE DOC_CLIE = '" + cChave + "'"
Else
	cSql := "UPDATE VINDI.FATURA "
	cSql += "   SET INTEGRA_STATUS = " + cStatus     
	cSql += "WHERE FATURA_ID = " + cChave 
EndIf

TcSqlExec(cSql)

Return     


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VINDICLI  ºAutor  ³Microsiga           º Data ³  01/09/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GeraFatura(cCgc)

Local cVencto := ""

Conout("VINDICLI - GRAVANDO FATURAS - " + DTOS(ddatabase))

aVencto := Condicao(1788,"965",,ddatabase)   // valor total das parcelas, condição de pagamento, e data base
 
//cVencto := CVALTOCHAR(Year(Date())) + CVALTOCHAR(Month(Date())) + "20"

dbSelectArea("Z82")
Z82->(dbSetOrder(1))  
Z82->(dbGoTop())

If ! Z82->(dbSeek(xFilial("Z82") + cCgc))
	//--Faz a gravação na tabela
	BEGIN TRANSACTION
		For nI := 1 to 12
			RecLock("Z82", .T.)
				Z82->Z82_FILIAL	:= xFilial("Z82")  
				Z82->Z82_CGC	:= cCgc
				Z82->Z82_VALOR  := aVencto[nI][02]
				Z82->Z82_DTVENC := aVencto[nI][01]
				Z82->Z82_STATUS := "pending"
			Z82->(MSUNLOCK())
		Next nI	         
	END TRANSACTION
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EnviaWf  ºAutor  ³Gustavo Lattmann     º Data ³  06/01/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function EnviaWf(cCodCli)  

Local oProcess
Local oHtml
Local cProcess   := OemToAnsi("008080") 

dbSelectArea("SA1")
SA1->(dbSetOrder(1)) 
SA1->(dbGoTop())
SA1->(dbSeek(xFilial("SA1")+cCodCli))


cStatus  := OemToAnsi("001011")

oProcess := TWFProcess():New(cProcess,OemToAnsi("WF CANTU - Integração cliente Vindi"))
oProcess:NewTask(cStatus,"\workflow\wfclienteintegrado.htm")
oProcess:cSubject := OemToAnsi("WF CANTU - Integração cliente Vindi")

cEmail    := "microsiga@cantu.com.br,suporte@cantu.com.br" 

oProcess:cTo := ALLTRIM(cEmail) 
//oProcess:cCC := "sfa2@cantu.com.br" 
                                    
oHTML:= oProcess:oHTML		
oHtml:ValByName("DATA"      ,DTOC(dDataBase) + " " + SubStr(Time(), 1, 5))
oHtml:ValByName("CPF"   	,SA1->A1_CGC)
oHtml:ValByName("NOME" 		,SA1->A1_NOME)
//oHtml:ValByName("PEDSIM"    ,aCabPed[nPosCot, 02])
//oHtml:ValByName("PEDSIGA"   ,cPedSiga)
//oHtml:ValByName("VALORTOTAL",Transform(nValTot, '@E 9,999,999.99'))

oProcess:Start()
oProcess:Finish()                                              

Return Nil



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VINDIFAT  ºAutor  ³Gustavo Lattmann    º Data ³  09/01/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Realiza a atualização das parcelas da Vindi.               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VindiFat()

Local aFatura 	:= {}
Local nAux	  	:= 0
Private cEmpIni	:= "10"
Private cFilIni	:= "01"   


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Recupera empresa/filial do APPSERVER.INI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cEMPFIL := GetJobProfString("PREPAREIN", "")
cCODEMP := SubSTR(cEMPFIL,1,2) 
cCODFIL := SubSTR(cEMPFIL,4,2)

Conout("VINDIFAT - INICIO DE EXECUÇÃO") 

If !Empty(cCODEMP) .and. !Empty(cCODFIL)
	cEmpIni	:= cCODEMP
	cFilIni	:= cCODFIL
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona o sistema em uma empresa para dar início na seleção dos dados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RpcClearEnv()
RpcSetType(3)
RpcSetEnv(cEmpIni, cFilIni,,,,GetEnvServer(),{"Z82"})	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criação de arquivo temporário sobre a execução da rotina³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLock := 0
While !LockByName(iif(!Empty(cCODEMP),"VINDIFAT"+cCODEMP,"VINDIFAT"),.T.,.F.,.T.)
	nLock += 1
	Sleep(1000)
	If nLock > 10
		ConOut("CONTROLE DE SEMAFORO - Rotina finalizada pois já esta sendo executada!")
		Return
	EndIf		
EndDo    

ConOut("VINDIFAT - CONECTANDO NO BANCO INTERMEDIARIO...")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Busca somente as faturas pagas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
cSql := "SELECT FATURA_ID, CNPJ_CLIENTE, VENCIMENTO, VALOR, STATUS, DATA_INICIO, DATA_FIM "
cSql += "  FROM VINDI.FATURA "
cSql += " WHERE INTEGRA_STATUS = 0"                                                
cSql += "   AND STATUS = 'paid'"                   

TCQUERY cSql NEW ALIAS "TBTMP"

dbSelectArea("TBTMP")
TBTMP->(dbGoTop())  

If TBTMP->(Eof())
	TBTMP->(DbCloseArea())	
	ConOut("VINDIFAT - SEM FATURAS A IMPORTAR") 
	Return  
EndIf          

While TBTMP->(!Eof())
	Aadd(aFatura, {ALLTRIM(TBTMP->CNPJ_CLIENTE),; //1
					TBTMP->VENCIMENTO,; 		//2
					TBTMP->VALOR,; 				//3
					TBTMP->STATUS,;             //4
					TBTMP->FATURA_ID,;          //5
					TBTMP->DATA_INICIO,; 		//6
					TBTMP->DATA_FIM})		    //7	
	TBTMP->(dbSkip())
EndDo

TBTMP->(dbCloseArea())

If Len(aFatura) > 0 
	For nX := 1 To Len(aFatura)
		dbSelectArea("Z82")
		Z82->(dbSetOrder(1))
		Z82->(dbGoTop())
		If Z82->(dbSeek(xFilial("Z82") + aFatura[nX][1]))
			While !Z82->(Eof()) .and. Z82->Z82_CGC == aFatura[nX][1]
				//-- Procura a primeira fatura que não estiver paga
				If Z82->Z82_STATUS != "paid"
					nAux := nX
					cNum := IncluiPedido(aFatura[nX]) 
					nX := nAux
					If !Empty(cNum)
						BEGIN TRANSACTION
							RecLock("Z82",.F.) 
								Z82->Z82_DTVENC := STOD(aFatura[nX][2])
								Z82->Z82_VALOR := aFatura[nX][3]
								Z82->Z82_STATUS := aFatura[nX][4]  
								Z82->Z82_PEDIDO := cNum
							Z82->(MsUnlock()) 
						END TRANSACTION                  
						AltStatus(cValtoChar(aFatura[nX][5]),"2","F")  //-- Atualiza na tabela da Vindi como integrado
					EndIf
					Exit //-- Ja encontrou o registro, sai do laço
				EndIf
		        Z82->(dbSkip()) 
		  	EndDo 
		Else
			Conout("VINDIFAT - NAO ENCONTRADOS REGISTROS NA Z82")
		Endif
	Next nX
EndIf  

Z82->(dbCloseArea())

Conout("VINDIFAT - FIM EXECUCAO")

Return                    

Static Function IncluiPedido(aFatura)

Local cCgc 		:= aFatura[1]
Local cVencto 	:= aFatura[2]
Local cDataIni	:= aFatura[6]
Local cDataFim	:= aFatura[7]   
Local cSql 		:= ""     
Local aCab		:= {}
Local aItens	:= {}    
Local aItemLin	:= {}    
Private lMsErroAuto := .F.   
Private cItemNovo := PadL("00", Len(SC6->C6_ITEM))

cSql += "SELECT Z81_FILIAL AS FILIAL, Z81_PRODUT AS PRODUTO, Z81_DESC AS DESCRICAO, Z81_QUANT AS QUANTIDADE, "
cSql += "Z81_VALOR AS VALOR, Z81_DESCON AS DESCONTO, Z81_OPER AS OPER "
cSql += "  FROM " + RetSqlName("Z81")                                                                  
cSql += " WHERE D_E_L_E_T_ = ' ' "
cSql += "   AND Z81_DIAINI <= '" + cDataIni + "'"
cSql += "   AND Z81_DIAFIM >= '" + cDataFim + "'" 

TCQUERY cSql NEW ALIAS "ITENS"

dbSelectArea("ITENS")
ITENS->(dbGoTop())    
If ITENS->(Eof())
	ITENS->(DbCloseArea())
	Conout("VINDIFAT - NAO ENCONTRADO CLUBE COM DATA VIGENTE PARA ESSA FATURA")
	Return
EndIf

Conout("VINDIFAT - INICIO INCLUSAO PEDIDO DE VENDA")

dbSelectArea("SA1")
SA1->(dbSetOrder(3)) //CPF
SA1->(dbGoTop())
SA1->(dbSeek(xFilial("SA1") + cCgc))  

dbSelectArea("SBZ")
SBZ->(dbSetOrder(1))
SBZ->(dbSeek(xFilial("SBZ") + AllTrim(ITENS->PRODUTO)))

aAdd(aCab, {"C5_FILIAL",  "01",Nil})
aAdd(aCab, {"C5_TIPO",    "N", Nil})		
aAdd(aCab, {"C5_CLIENTE", SA1->A1_COD,Nil})		
aAdd(aCab, {"C5_LOJACLI", SA1->A1_LOJA,Nil})
aAdd(aCab, {"C5_CLIENT" , SA1->A1_COD,Nil})
aAdd(aCab, {"C5_LOJAENT", SA1->A1_LOJA,Nil})      
aAdd(aCab, {"C5_TIPOCLI", SA1->A1_TIPO,Nil})
aAdd(aCab, {"C5_CONDPAG", SA1->A1_COND,Nil}) 
aAdd(aCab, {"C5_VEND1"  , "V00208", Nil})
aAdd(aCab, {"C5_PEDCLI" ," ",Nil})
//aAdd(aCab, {"C5_MENNOTA",iif(Empty(aPedidos[nX, 05]), " ", aPedidos[nX, 05]),Nil})
aAdd(aCab, {"C5_EMISSAO", dDatabase,Nil})
aAdd(aCab, {"C5_DTHRALT", DToS(dDataBase) + ' ' + Substr(Time(), 1, 5),Nil}) 
aAdd(aCab, {"C5_X_DTINC", DToS(dDataBase) + ' ' + Substr(Time(), 1, 5),Nil})
 

cNumPed := GetSxeNum("SC5","C5_NUM") 

aAdd(aCab, {"C5_NUM"    , cNumPed,Nil})
aAdd(aCab, {"C5_X_TPLIC", "4",Nil})     //-- Vindi
aAdd(aCab, {"C5_X_CLVL" , "003001001",Nil})	

ConfirmSX8()    

SA1->(dbCloseArea())   

Conout("VINDIFAT - BUSCANDO ITENS")

While (ITENS->(!Eof()))
	
	cItemNovo := Soma1(cItemNovo)
	aAdd(aItemLin, {"C6_ITEM"   ,cItemNovo,Nil})  
	aAdd(aItemLin, {"C6_PRODUTO",AllTrim(ITENS->PRODUTO),Nil})
	aAdd(aItemLin, {"C6_DESCRI" ,ITENS->DESCRICAO,Nil})
	aAdd(aItemLin, {"C6_QTDVEN" ,ITENS->QUANTIDADE,Nil})
	aAdd(aItemLin, {"C6_PRCVEN" ,ITENS->VALOR,Nil})
	aAdd(aItemLin, {"C6_VALDESC",ITENS->DESCONTO,Nil})	
	aAdd(aItemLin, {"C6_PRCTAB" ,ITENS->VALOR,Nil})
	aAdd(aItemLin, {"C6_VALOR"  ,Round((ITENS->QUANTIDADE * ITENS->VALOR) - ITENS->DESCONTO,2),Nil})
	aAdd(aItemLin, {"C6_LOCAL"  ,SBZ->BZ_LOCPAD,Nil})
	aAdd(aItemLin, {"C6_OPER"	,ITENS->OPER,Nil})
	aAdd(aItemLin, {"C6_QTDEMP" ,0,Nil})	
	
	aAdd(aItens, aItemLin)
	
	aItemLin := {} //-- Zerá vetor para iniciar novo item do pedido

	ITENS->(dbSkip()) 
	
	
EndDo 

ITENS->(dbCloseArea())               
	
MSExecAuto({|x,y,z| Mata410(x,y,z)},aCab,aItens,3) 

If lMsErroAuto
	Conout(MOSTRAERRO())
Else
	Conout("VINDIFAT - PEDIDO INCLUIDO COM SUCESSO " + C5_NUM)    
	//FALTA ATUALIZAR A FATURA COMO INTEGRADA
	//FALTA MANDAR WF DO PEDIDO
Endif
	
Return C5_NUM