// Faz a troca de agencia e conta na baixa
User Function F200DB1()
Local cAgencia
Local cConta
Local aArea := GetArea()  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// Localiza o banco responsavel pela despesa, alimentando as variaveis cAgencia e cConta
dbSelectArea("ZZH")
dbSetOrder(01)
if ZZH->(dbSeek(xFilial("ZZH") + SA6->A6_COD + SA6->A6_AGENCIA + SA6->A6_NUMCON))
	cAgencia := ZZH->ZZH_AGDESP
	cConta := ZZH->ZZH_CONDES
	
	// faz a gravacao do banco e conta de despesas no se5 
	RecLock('SE5',.F.)
	SE5->E5_AGENCIA := cAgencia
	SE5->E5_CONTA := cConta
	// Seta informaçoes adicionais
//	SE5->E5_MOEDA := '01' // seta o numerário que é obrigatório
	SE5->E5_CLVLCR := SE1->E1_CLVLDB
	SE5->E5_CLVLDB := SE1->E1_CLVLCR
	SE5->E5_CCD := SE1->E1_CCC
	SE5->E5_CCC := SE1->E1_CCD
	SE5->(MsUnlock())
	
//	ConOut("Alterado AG / CC de despesas para "  + cAgencia + " -- " + cConta)
elseif (Empty(SE5->E5_CLVLCR) .And. Empty(SE5->E5_CLVLDB) .And. Empty(SE5->E5_CCC) .And. Empty(SE5->E5_CCD))
	
	RecLock('SE5',.F.)
	// Seta informaçoes adicionais de centro de lucro e segmento
//	SE5->E5_MOEDA := '01' // seta o numerário que é obrigatório
	SE5->E5_CLVLCR := SE1->E1_CLVLDB
	SE5->E5_CLVLDB := SE1->E1_CLVLCR
	SE5->E5_CCD := SE1->E1_CCC
	SE5->E5_CCC := SE1->E1_CCD
	SE5->(MsUnlock())
	
//	Alert("Nao Localizou " + xFilial("ZZG") + SA6->A6_COD + SA6->A6_AGENCIA + SA6->A6_NUMCON)
Endif                                                
RestArea(aArea)
Return


// Baixa de Outras tarifas
User Function F200DB2() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// Chama a funcao acima por ser o mesmo procedimento
U_F200DB1()
Return


User Function MANZZH()
Local cCad := "Contas de Despesas Bancárias"
AxCadastro("ZZH", cCad)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

Return                   


// Função para validar se Banco, Agência e Conta existem no cadastro de Banco (SA6)
User Function ValidConta(banco, agencia, conta)
Local lValid := .F.
dbSelectArea("SA6")
dbSetOrder(01)
lValid := SA6->(Dbseek(xFilial("SA6") + banco + agencia + conta))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())


Return lValid

// Ponto de entrada após gravar a baixa do título e gerar o registro no SE5
/*User Function F70GRSE1()
Alert("F70GRSE1")
Alert(SE1->E1_NUM + " -> " + SE5->E5_NUMERO + " tipo: " + SE5->E5_TIPO)
Return*/
   
// PE para gravar o segmento e centro de custo na baixa do título, juros, descontos e multas, tanto a baixa por cnab quanto a baixa manual
User Function SE5FI070()         


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// Alert(SE1->E1_NUM + " -> " + SE5->E5_NUMERO + " tipo: " + SE5->E5_TIPODOC)
if !(Empty(SE1->E1_CLVLCR) .And. Empty(SE1->E1_CLVLDB) .And. Empty(SE1->E1_CCC) .And. Empty(SE1->E1_CCD)) .And. !Empty(SE5->E5_NUMERO)
	
	RecLock('SE5',.F.)
	
	if SE5->E5_TIPODOC = "DC"	
		// Seta informaçoes adicionais de centro de lucro e segmento
		//	SE5->E5_MOEDA := '01' // seta o numerário que é obrigatório
		SE5->E5_CLVLCR := SE1->E1_CLVLDB
		SE5->E5_CLVLDB := SE1->E1_CLVLCR
		SE5->E5_CCD := SE1->E1_CCC
		SE5->E5_CCC := SE1->E1_CCD
	else
		SE5->E5_CLVLCR := SE1->E1_CLVLCR
		SE5->E5_CLVLDB := SE1->E1_CLVLDB
		SE5->E5_CCD := SE1->E1_CCD
		SE5->E5_CCC := SE1->E1_CCC
	EndIf
	
	SE5->(MsUnlock())
EndIf

Return