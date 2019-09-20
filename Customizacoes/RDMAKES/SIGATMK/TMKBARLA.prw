#Include "Protheus.ch"

/*
+----------------------------------------------------------------------------+
!                       FICHA TECNICA DO PROGRAMA                            !
+----------------------------------------------------------------------------+
!                          DADOS DO PROGRAMA                                 !
+------------------+---------------------------------------------------------+
!Autor             ! Carlos Eduardo                                          !
+------------------+---------------------------------------------------------+
!Descricao         ! Ponto de entrada para inclusão de botão no atendimento  !
+------------------+---------------------------------------------------------+
!Nome              ! TMKBARLA                                                !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 10/10/2012                                              !
+------------------+---------------------------------------------------------+
*/

User Function TMKBARLA(aBotao, aTitulo)   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// nFolder // Numero referente a pasta do atendimento 1- Telemarketing; 2 - Televendas; 3 - Telecobrança

aAdd(aBotao,{"BUDGET"  , {|| U_RenegTmk()} ,"Renegociação"})

Return( aBotao )


/*
+----------------------------------------------------------------------------+
!                       FICHA TECNICA DO PROGRAMA                            !
+----------------------------------------------------------------------------+
!                          DADOS DO PROGRAMA                                 !
+------------------+---------------------------------------------------------+
!Autor             ! Carlos Eduardo                                          !
+------------------+---------------------------------------------------------+
!Descricao         ! Rotina para geração de renegociação Call Center         !
+------------------+---------------------------------------------------------+
!Nome              ! RenegTmk                                                !                                                                  
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 10/10/2012                                              !
+------------------+---------------------------------------------------------+
!Alteracao         ! 06/06/2013  - Criado parametro  MV_JURDIA taxa de juros !
!                  ! diaria                                                            !
+------------------+---------------------------------------------------------+



*/

User Function RenegTmk

Private nValor := 0
Private nVlTit := 0
Private nJuros := 0
Private nTotal := 0
Private dDataPag
Private aVencto := {}

Private cCondicao := ""

Private cMsgTit   := ""

Private cPerg := "RENEGTMK  " // Incluído espaços para o seek na criação das perguntas

Private aVetor := {}

Private nValParc		:= 0 // Variavel para corrigir o valor das parcelas caso sobre resto na divisão.

Private nPosFilial	:= aScan(aHeader,{|x| AllTrim(x[2])=="ACG_FILORI"})
Private nPosValRec	:= aScan(aHeader,{|x| AllTrim(x[2])=="ACG_RECEBE"})
Private nPosValor	:= aScan(aHeader,{|x| AllTrim(x[2])=="ACG_VALOR"})   //Lucilene
Private nPosPrefix	:= aScan(aHeader,{|x| AllTrim(x[2])=="ACG_PREFIX"})
Private nPosTit	:= aScan(aHeader,{|x| AllTrim(x[2])=="ACG_TITULO"})
Private nPosParc	:= aScan(aHeader,{|x| AllTrim(x[2])=="ACG_PARCEL"})
Private nPosTipo	:= aScan(aHeader,{|x| AllTrim(x[2])=="ACG_TIPO"})
Private nPosVenc	:= aScan(aHeader,{|x| AllTrim(x[2])=="ACG_DTVENC"})
Private nPosAtraso	:= aScan(aHeader,{|x| AllTrim(x[2])=="ACG_ATRASO"})
Private nPosTotal	:= aScan(aHeader,{|x| AllTrim(x[2])=="ACG_RECEBE"})
Private lRet := .T.
Private lImprime := .F.


//Variaveis para guardar as informacoes dos titulos que vao ser baixados - Renata
Private _CLVLCR := 0
Private _CCC    := ""
Private _e1porcjur :=  GetMv( "MV_JURDIA") 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

if nFolder <> 3
	MsgInfo("Rotina disponível apenas para o Telecobrança!", "Informação")
	return
Endif


//final()

// Pergunta para solicitar a condição de pagamento
ValidPerg(cPerg)
If Pergunte(cPerg,.T.)
	cCondicao    := Mv_Par01
	While (.t.)
		If Empty(cCondicao)
			APMsgInfo("Necessário selecionar uma condição de pagamento para geração dos novos títulos!")
			If Pergunte(cPerg,.T.)
			Else
				Return
			Endif
			cCondicao := Mv_Par01
		ELSE
			EXIT
		EndIf
	END
Else
	Return
Endif

If Mv_Par02 = 1
	lImprime := .T.
Endif

// Somar valores aCols da tela de cobrança para alimentar nValor

For i := 1 to Len (aCols)
	nValor += aCols [ i, nPosValRec]
Next
***************************************************
//Verifica a data de vencto dos novos títulos

//Private nPosValRec	:= aScan(aHeader,{|x| AllTrim(x[2])=="ACG_RECEBE"})
//Private nPosValor	:= aScan(aHeader,{|x| AllTrim(x[2])=="ACG_VALOR"})   //Lucilene


aVencto := Condicao(nValor,cCondicao,,dDataBase)

dDataPag := aVencto[len(aVencto)][1]//maior data de vencimento

/*
nJuros	+= FaJuros(	SE1->E1_VALOR	, SE1->E1_SALDO		, dDataPag			, SE1->E1_VALJUR	,;
SE1->E1_PORCJUR	, SE1->E1_MOEDA		, SE1->E1_EMISSAO	, dDataPag			,;
SE1->E1_BAIXA	, SE1->E1_VENCREA	)


*/
**************************************************************
// Gera parcelas 

aParcelas := Condicao (nValor,cCondicao,,dDataBase)

for i := 1 to len(aParcelas)
	_vljurdia := (aParcelas[i][2] * _e1porcjur) /100
     //   alert("valor  de juros " + cvaltochar(	_vljurdia))


//alert("valor antes de juros " + cvaltochar(	aParcelas[i][2] ))

	aParcelas[i][2] += _vljurdia * (aParcelas[i][1] - dDatabase)                

//alert("valor antes de juros " + cvaltochar(	aParcelas[i][2] ))


next

if Len(aParcelas) > 0
	cMsgTit := " Deseja baixar o(s) título(s) em aberto e gerar o(s) novo(s) <br> "
	cMsgTit += " título(s) abaixo? <br> "
	cMsgTit += " <table border='1' cellpadding='5' cellspacing='0' width='100%'> "
	cMsgTit += " <tr> "
	cMsgTit += " <th style='text-align:left'>Vencimento</th> "
	cMsgTit += " <th style='text-align:left'>Valor</th> "
	cMsgTit += " </tr> "
	For i := 1 to Len (aParcelas)
		cMsgTit += " <tr> "
		cMsgTit += " <td align=center width='50%'>"+DTOC(aParcelas[i][1])+"</td> "
		cMsgTit += " <td align=center width='50%'>"+Transform(aParcelas[i][2],"@E 999,999,999.99")+"</td> "
		cMsgTit += " </tr> "
		
	Next
	cMsgTit += " </table> "
	
Endif
 
If ApMsgYesNo(cMsgTit, "Renegociação") 	//Opção que será habilitada se o usuário clicar no botão "Yes"
	
	
	// Pega o número do titulo para gerar as faturas
	cNum := GetSxeNum('SE1','E1_NUM')
	
	// Cliente para gerar as faturas
	cCliente := M->ACF_CLIENT // PEGAR DA TELA DA COBRANÇA
	cLoja := M->ACF_LOJA        // PEGAR DA TELA DA COBRANÇA
	
	CancBord (@aCols)
	
	begin transaction
	
	Processa( {|| lRet := BxRengTmk() }, "Aguarde...", "Executando baixa dos títulos...",.F.)
	
	if !lRet
		MsgStop("Houve erro ao baixar os títulos. Não é possível continuar.","Erro")
		mostraerro()
		Return // Caso a rotina de baixa não seja concluída sai da rotina de renegociação
	Endif
	
	
	Processa( {|| lRet := GrTitTmk() }, "Aguarde...", "Criando novos títulos...",.F.)
	
	if !lRet
		MsgStop("Houve erro na criação dos novos títulos. Não é possível continuar.","Erro")
		Return // Caso a rotina de Geração de títulos não seja concluída sai da rotina de renegociação
	Endif
	
	ConfirmSx8()
	
	End Transaction
	
	ApMsgInfo("Renegociação Concluída!")
	
	If lImprime //Gera contrato = Sim
		//Chama o relatório de Termo de Renegociação
		u_CANRW001()
	Endif
	
Else                                                    	//Opção que será habilitada se o usuário clicar no botão "No"
	
	ApMsgInfo("Renegociação cancelada!")
EndIf




Return


/*
+----------------------------------------------------------------------------+
!                       FICHA TECNICA DO PROGRAMA                            !
+----------------------------------------------------------------------------+
!                          DADOS DO PROGRAMA                                 !
+------------------+---------------------------------------------------------+
!Autor             ! Carlos Eduardo                                          !
+------------------+---------------------------------------------------------+
!Descricao         ! Rotina para geração da pergunta para a renegociação     !
+------------------+---------------------------------------------------------+
!Nome              ! ValidPerg                                               !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 10/10/2012                                              !
+------------------+---------------------------------------------------------+
*/


Static Function ValidPerg(cPerg)
SX1->(DbSetOrder(1))

If !SX1->(dbSeek(cPerg+'01'))
	RecLock("SX1",.T.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := '01'
	SX1->X1_PERGUNT := 'Condição PG?'
	SX1->X1_PERSPA  := 'Condição PG?'
	SX1->X1_PERENG  := 'Condição PG?'
	SX1->X1_VARIAVL := 'mv_ch1'
	SX1->X1_VAR01   := 'MV_PAR01'
	SX1->X1_GSC     := 'G'
	SX1->X1_TIPO    := 'C'
	SX1->X1_TAMANHO := 3
	SX1->X1_F3 := "SE4"
	MsUnlock("SX1")
EndIf

If !SX1->(dbSeek(cPerg+'02'))
	RecLock("SX1",.T.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := '02'
	SX1->X1_PERGUNT := 'Gerar Contrato?'
	SX1->X1_PERSPA  := 'Gerar Contrato?'
	SX1->X1_PERENG  := 'Gerar Contrato'
	SX1->X1_VARIAVL := 'mv_ch2'
	SX1->X1_VAR01   := 'MV_PAR02'
	SX1->X1_DEF01		:= 'Sim'
	SX1->X1_DEFSPA1	:= 'Sim'
	SX1->X1_DEFENG1	:= 'Sim'
	SX1->X1_DEF02		:= 'Não'
	SX1->X1_DEFSPA2	:= 'Não'
	SX1->X1_DEFENG2	:= 'Não'
	SX1->X1_GSC     := 'C'
	SX1->X1_TIPO    := 'N'
	SX1->X1_TAMANHO := 1
	MsUnlock("SX1")
EndIf

Return

Static Function BxRengTmk

ProcRegua(Len(aCols))

//Variavel de controle de erro ExecAuto
lMsErroAuto := .F.


//Fina070 - Baixa dos titulos em questão na tela do telecobrança



//Alteração realizada para pegar Centro de Custo e Segmento do Titulo - Renata

_Filial := aCols[1][nPosFilial]
_nPref 	:= aCols[1][nPosPrefix]
_nTit 	:= aCols[1][nPosTit]
_nParc 	:= aCols[1][nPosParc]
_nTipo 	:= aCols[1][nPosTipo]

DbSelectArea ("SE1")
DbSetOrder (1)
If (DbSeek (_Filial + _nPref + _nTit + _nParc + _nTipo))
	
	_CLVLCR := SE1->E1_CLVLCR
	_CCC    := GetMv("MV_PARCC")
Else
	
	MsgInfo ("Titulo selecionado não possui informação de Segmento")
	
	Return .F.
	
EndIf

//Fim da alteração

DbSelectArea ("SE1")

For i := 1 to Len (aCols)
	aVetor := {{"E1_PREFIXO"	 ,aCols[i][nPosPrefix]             ,Nil},;
	{"E1_NUM"		 ,aCols[i][nPosTit]           ,Nil},;
	{"E1_PARCELA"	 ,aCols[i][nPosParc]               ,Nil},;
	{"E1_TIPO"	    ,aCols[i][nPosTipo]             ,Nil},;
	{"AUTMOTBX"	    ,"REN"             ,Nil},;
	{"AUTDTBAIXA"	 ,dDataBase         ,Nil},;
	{"AUTDTCREDITO" ,dDataBase         ,Nil},;
	{"AUTHIST"	    ,'Baixa Automática Renegociação',Nil},;
	{"AUTVALREC"	 ,aCols[i][nPosTotal]               ,Nil }}
	MSExecAuto({|x,y| fina070(x,y)},aVetor,3) //Baixa
	
	If lMsErroAuto
		DisarmTransaction()
		mostraerro()
		ApMsgInfo("Renegociação cancelada!")
		Return .F. // Sai da rotina caso aconteça erro na baixa
	Else
		
		// Grava informações da fatura no titulo baixado
		If Reclock("SE1",.F.)
			E1_FATPREF := "TCD" // Prefixo da fatura a ser gerada
			E1_FATURA  := cNum  // Numero da Fatura a ser gerada
			E1_DTFATUR := dDataBase // Data da geração da fatura
			E1_TIPOFAT := "FT" // Tipo da fatura a ser gerada
			E1_FLAGFAT := "S" // Flag caso seja gerado fatura
			MsUnLock()
		Endif
		
	Endif
	
	IncProc()
	
Next

Return .T.

Static Function GrTitTmk

ProcRegua(Len(aParcelas))

// Corrige diferença das parcelas
For nCond := 1 to Len (aParcelas)
	nValParc += aParcelas [ nCond, 2]
Next
If nValParc != nValor
	nDifer := round(nValor - nValParc,2)
	aParcelas [ Len(aParcelas), 2 ] += nDifer
EndIf

//Variavel de controle de erro ExecAuto
lMsErroAuto := .F.


//Fina040 - inclusão dos titulos conforme as parcelas geradas pela condição de pagamento

For i := 1 to Len (aParcelas)
	
	aVetor  := {	{"E1_PREFIXO" ,"TCD"           ,Nil},;
	{"E1_NUM"	   , cNum        ,Nil},;
	{"E1_PARCELA" ,STRZERO(i,2)             ,Nil},;
	{"E1_TIPO"	   ,"FT "            ,Nil},;
	{"E1_NATUREZ" ,"1010018  "      ,Nil},;
	{"E1_CLIENTE" , cCliente        ,Nil},;
	{"E1_LOJA"	   , cLoja            ,Nil},;
	{"E1_FATURA"	   , "NOTFAT"            ,Nil},; // PREENCHIDO PELA ROTINA DE FATURA PADRÃO
	{"E1_EMISSAO" ,dDataBase       ,Nil},;
	{"E1_VENCTO"	,aParcelas[i][1]       ,Nil},;
	{"E1_VENCREA" ,aParcelas[i][1]       ,Nil},;
	{"E1_VALOR"	,aParcelas[i][2]             ,Nil }}
	Memowrite("C:\ZZ2HX\aVETOR.html",varinfo("aVETOR",aVETOR))
	MSExecAuto({|x,y| Fina040(x,y)},aVetor,3) //Inclusao
		
	If lMsErroAuto
		DisarmTransaction()
		mostraerro()
		ApMsgInfo("Renegociação cancelada!")
		Return .F. // Sai da rotina caso aconteça erro na geração dos titulos
	Endif
	
	//Grava as informações no novo titulo - Renata
	RecLock ('SE1', .F.)
	SE1->E1_CLVLCR := _CLVLCR
	SE1->E1_CCC := _CCC
	MsUnlock ('SE1')
	
	IncProc()
	
Next

Return .T.    

// Função para cancelamento dos titulos em borderô - Renata

Static Function CancBord (aCols)

//Begin Transaction
For nX := 1 to Len(aCols)
	
	DbSelectArea ("SE1")
	SE1->(DbSetOrder (1))
	
	If 	SE1->(DbSeek (xFilial("SE1") + aCols[nX,1] + aCols[nX,2] + aCols[nX,3] + aCols[nX,4]))
	//If	SE1->(DbSeek (xFilial("SE1") + _nPref + _nTit + _nParc + _nTipo))

		
		RecLock( "SE1", .F. )
		
		Replace E1_NUMBOR With Space(6)
		Replace E1_DATABOR With CTOD("//")
		Replace E1_PORTADO With ""
		Replace E1_AGEDEP  With ""
		Replace E1_CONTA   With ""
		Replace E1_SITUACA With "0"
		Replace E1_NUMBCO  With ""
		
		MsUnlock( )


		DbSelectArea ("SEA")
		SEA->(DbSetOrder (1))
		SEA->(DbSeek (xFilial("SEA") + SE1->E1_NUMBOR + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_TIPO ))
		
		If SEA->EA_CART == "R"
			If SEA->EA_SITUACA # "2/7"
				
				RecLock("SEA",.F.)
				dbDelete()
				MsUnlock()
				
			EndIf
		EndIF
		
	EndIf
	
Next

//End Transaction

Return


