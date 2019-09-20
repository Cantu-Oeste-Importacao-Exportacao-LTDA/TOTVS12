#include "protheus.ch"
#INCLUDE "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "TbiCode.ch"

/*---------------------------------------------------------------------------+
!                          FICHA TECNICA DO PROGRAMA                         !
+----------------------------------------------------------------------------+
!DADOS DO PROGRAMA                                                           !
+------------------+---------------------------------------------------------+
!Tipo              ! User Function                                           !
+------------------+---------------------------------------------------------+
!Modulo            ! SIGAFIN			                                     !
+------------------+---------------------------------------------------------+
!Descricao         ! RELATÓRIO DE MOVIMENTAÇÕES BANCÁRIAS			         !
!                  ! modo gráfico utilizando tReport		                 !
+------------------+---------------------------------------------------------+
!Autor             ! Jair Matos de Andrade                                   !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 07/01/2013                                          	 !
+------------------+---------------------------------------------------------+
!                               ATUALIZACOES                                 !
+-------------------------------------------+-----------+-----------+--------+
!   Descricao detalhada da atualizacao      !  Nome do  ! Analista  !Data da !
!                                           !Solicitante! Respons.  !Atualiz.!
+-------------------------------------------+-----------+-----------+--------+
!		                                    !    	    !           !        !
+-------------------------------------------+-----------+-----------+-------*/

*/
User Function RELFIN01()

Local cTitle
Local cHelp     := OemToAnsi("RELATÓRIO DE MOVIMENTAÇÕES BANCÁRIAS")
Local cQuery := ""
Local oRel
Local oPatr
Local NomeEmp := ""
Static dGetDtIni := Date()
Static dGetDtFim := Date()
Static cGetCam:='\financeiro\SE5\'


Private rs := 0
Private cPerg := padr("RELFIN01",10)
Private aProds := {}
Private nItens := 0   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//VERIFICA SE ESTA RODANDO VIA MENU OU SCHEDULE
If Select("SX6") == 0
	cData:=dtos(date())
	cTime := TIME() // Resultado: 10:00:00
	cHora := SUBSTR(cTime, 1, 2) // Resultado: 10
	cMinutos := SUBSTR(cTime, 4, 2) // Resultado: 37
	lWeb := .T.
	RpcSetType(3)
	Prepare Environment Empresa '06' Filial '01'
	GravaEX(cGetCam,"SE5_"+cData+cHora+cMinutos,dGetDtIni, dGetDtFim)
	RESET ENVIRONMENT
	return //jair 24/10/2013
EndIf

//Cria as perguntas se não existerem
CriaPerg()
Pergunte(cPerg, .T.)
cTitle    := OemToAnsi("RELATÓRIO DE MOVIMENTAÇÕES BANCÁRIAS")

//Criacao do componente de impressao
oRel := tReport():New("RELFIN01",cTitle,cPerg,{|oRel|ReportPrint(oRel)},cHelp)
//oRel:SetLogo('britanite.bmp')
//Seta a orientação do papel
oRel:SetLandscape()


oPatr := trSection():New(oRel,cTitle,{},)                                                                                    //01
trCell():New(oPatr,"EMP",	   		"","Empresa",  		   			"@!",15)                                                 //02
trCell():New(oPatr,"FILIAL",		"",RetTitle("E5_FILIAL"	),		PesqPict("SE5","E5_FILIAL"),TamSx3("E5_FILIAL")[1])      //03
trCell():New(oPatr,"DATA",			"",RetTitle("E5_DATA"	),		PesqPict("SE5","E5_DATA"),TamSx3("E5_DATA")[1])          //04
trCell():New(oPatr,"CLIFOR",		"",RetTitle("E5_CLIFOR"	),		PesqPict("SE5","E5_CLIFOR"),TamSx3("E5_CLIFOR")[1])      //05
trCell():New(oPatr,"NUMERO",		"",RetTitle("E5_NUMERO"	) ,		PesqPict("SE5","E5_NUMERO"),TamSx3("E5_NUMERO")[1])      //06
trCell():New(oPatr,"TIPODOC",		"",RetTitle("E5_TIPODOC"),		PesqPict("SE5","E5_TIPODOC"),TamSx3("E5_TIPODOC")[1])    //07
trCell():New(oPatr,"LOJA",   		"",RetTitle("E5_LOJA"	),		PesqPict("SE5","E5_LOJA"),TamSx3("E5_LOJA")[1])          //08
trCell():New(oPatr,"SITCOB",		"",RetTitle("E5_SITCOB"	),		PesqPict("SE5","E5_SITCOB"),TamSx3("E5_SITCOB")[1])      //09
trCell():New(oPatr,"RECPAG",		"",RetTitle("E5_RECPAG"	),		PesqPict("SE5","E5_RECPAG"),TamSx3("E5_RECPAG")[1])      //10
trCell():New(oPatr,"CONTA",			"",RetTitle("E5_CONTA"	),		PesqPict("SE5","E5_CONTA"),TamSx3("E5_CONTA")[1])        //11
trCell():New(oPatr,"CCC",			"",RetTitle("E5_CCC"	),  	PesqPict("SE5","E5_CCC"),TamSx3("E5_CCC")[1])            //12
trCell():New(oPatr,"CCD",			"",RetTitle("E5_CCD"	),  	PesqPict("SE5","E5_CCD"),TamSx3("E5_CCD")[1])            //13
trCell():New(oPatr,"CLVLCR",		"",RetTitle("E5_CLVLCR"	),		PesqPict("SE5","E5_CLVLCR"),TamSx3("E5_CLVLCR")[1])      //14
trCell():New(oPatr,"CLVLDB",		"",RetTitle("E5_CLVLDB"	),		PesqPict("SE5","E5_CLVLDB"),TamSx3("E5_CLVLDB")[1])      //15
trCell():New(oPatr,"HISTOR",   		"",RetTitle("E5_HISTOR"	),		PesqPict("SE5","E5_HISTOR"),TamSx3("E5_HISTOR")[1])      //16
trCell():New(oPatr,"NATUREZA", 		"",RetTitle("E5_NATUREZ"),		PesqPict("SE5","E5_NATUREZ"),TamSx3("E5_NATUREZ")[1])    //17
trCell():New(oPatr,"VALORSE5",		"","VALOR SE5",					PesqPict("SE5","E5_VALOR"),TamSx3("E5_VALOR")[1])        //18
trCell():New(oPatr,"RECONC", 		"",RetTitle("E5_RECONC"),				PesqPict("SE5","E5_RECONC"),TamSx3("E5_RECONC")[1])//19 reconciliados
trCell():New(oPatr,"AGENCIA",		"",RetTitle("E5_AGENCIA"),		PesqPict("SE5","E5_AGENCIA"),TamSx3("E5_AGENCIA")[1])    //20


//Executa o relatório
oRel:PrintDialog()

Return


/*-----------------+---------------------------------------------------------+
!Nome              ! ReportPrint                                             !
+------------------+---------------------------------------------------------+
!Descrição         ! Processamento dos dados e impressao do relatório        !
+------------------+---------------------------------------------------------+
!Autor             ! Jair Matos de Andrade                                   !
+------------------+--------------------------------------------------------*/
static Function ReportPrint(oRel)
Local oPatr := oRel:Section(1)
Local aEmp     := {}
cAlias := "SE5"

oPatr:BeginQuery()
DbSelectArea("SM0")
DbSetOrder(01)
DbGoTop()

cCod := ""
While !SM0->(EOF())
	if cCod != SM0->M0_CODIGO
		cCod := SM0->M0_CODIGO
		aAdd(aEmp, SM0->M0_CODIGO)
	EndIf
	SM0->(dbSkip())
End
cQuery := ""
for i := 1 to len(aEmp)
	
	cQuery += " SELECT '"+aEmp[i]+"' AS EMP,E5_FILIAL,E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_TIPO,E5_CLIFOR,E5_LOJA,E5_DATA,E5_TIPODOC,E5_SITCOB,E5_RECPAG, "
	cQuery += " E5_CONTA,E5_CCC,E5_CCD,E5_CLVLCR,E5_CLVLDB,E5_HISTOR,E5_NATUREZ,E5_VALOR,E5_AGENCIA,E5_RECONC "
	cQuery += " FROM " + cAlias + aEmp[i] + "0 "
	cQuery += " WHERE  E5_DATA BETWEEN  '" + DTOS(MV_PAR01)  + "' AND '" + DTOS(MV_PAR02) + "'"
	cQuery += " AND E5_TIPODOC='VL' "
	
	if i == len(aEmp)
		cQuery += "ORDER BY E5_FILIAL,E5_RECPAG,E5_NUMERO "
	Else
		cQuery += "UNION ALL "
	EndIf
Next

MemoWrite("C:/movbanc.txt", cQuery)
oPatr:EndQuery()

if select("QCT") > 0
	dbSelectArea("QCT")
	dbCloseArea()
endIf

TcQuery cQuery New Alias "QCT"
nCount:= 0
Count to nCount
DbSelectArea("QCT")
DbGoTop()

oPatr:Init()


oRel:SetMeter(nCount)

Do While (!QCT->(Eof()))
	If oRel:Cancel()
		Exit
	EndIf
	oRel:IncMeter()
	
	//Posiciona na SE5 para verificação dos títulos
	DbSelectArea("SE5")
	SE5->(DbSetOrder(7))
	SE5->(DbSeek(QCT->E5_FILIAL+QCT->E5_PREFIXO+QCT->E5_NUMERO+QCT->E5_PARCELA+QCT->E5_TIPO+QCT->E5_CLIFOR+QCT->E5_LOJA))
	If SE5->(Found())
		
		//CONTAS PAGAR
		IF QCT->E5_RECPAG =='P'
			
			// Posiciona na SE2 para verificar se a baixa é parcial ou total
			DbSelectArea("SE2")
			SE2->(DbSetOrder(1))
			SE2->(DbSeek(SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_FORNECE+SE5->E5_LOJA))
			If SE2->(Found())
				
				// Se e2_multnat  = vazio , não calcula nada
				IF (SE2->E2_MULTNAT=="1")   .or. (SE5->E5_MULTNAT=="1")
					
					//se E2_SALDO = 0 tratamento de baixas totais.
					IF SE2->E2_SALDO = 0
						
						//Posiciona na SEV - MULTIPLAS NATUREZAS POR TÍTULO
						DbSelectArea("SEV")
						SEV->(DbSetOrder(1))
						SEV->(DbSeek(SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA))
						If SEV->(Found())
							While SEV->(!EOF()) .AND. (SEV->EV_FILIAL==SE5->E5_FILIAL) .AND. (SEV->EV_PREFIXO==SE5->E5_PREFIXO) ;
								.AND. (SEV->EV_NUM==SE5->E5_NUMERO);
								.AND. (SEV->EV_PARCELA==SE5->E5_PARCELA) .AND. (SEV->EV_TIPO==SE5->E5_TIPO) .AND. (SEV->EV_CLIFOR==SE5->E5_CLIFOR);
								.AND. (SEV->EV_LOJA==SE5->E5_LOJA)
								
								//VERIFICA se existe rateio de centro de custo por natureza
								IF SEV->EV_RATEICC = '2' //(2 = SEM RATEIO POR CC)
									//oPatr:Cell("CCUSTO"):SetValue("")
									//oPatr:Cell("EZNATURE"):SetValue(SEV->EV_NATUREZ)
									//	oPatr:Cell("VALORSEV"):SetValue(SEV->EV_VALOR)
									//oPatr:Cell("VALORSEZ"):SetValue(0)
									oPatr:Cell("VALORSE5"):SetValue(QCT->E5_VALOR)
									oPatr:Cell("EMP"):SetValue(QCT->EMP)
									oPatr:Cell("FILIAL"):SetValue(QCT->E5_FILIAL)
									oPatr:Cell("DATA" ):SetValue(STOD(QCT->E5_DATA))
									oPatr:Cell("CLIFOR"):SetValue(QCT->E5_CLIFOR)
									oPatr:Cell("NUMERO"):SetValue(QCT->E5_NUMERO)
									oPatr:Cell("TIPODOC"):SetValue(QCT->E5_TIPODOC)
									oPatr:Cell("LOJA" ):SetValue(QCT->E5_LOJA)
									oPatr:Cell("SITCOB"):SetValue(QCT->E5_SITCOB)
									oPatr:Cell("RECPAG"):SetValue(QCT->E5_RECPAG)
									oPatr:Cell("CONTA"):SetValue(QCT->E5_CONTA)
									oPatr:Cell("CCC"):SetValue(QCT->E5_CCC)
									oPatr:Cell("CCD"):SetValue(QCT->E5_CCD)
									oPatr:Cell("CLVLCR"):SetValue(QCT->E5_CLVLCR)
									oPatr:Cell("CLVLDB"):SetValue(QCT->E5_CLVLDB)
									oPatr:Cell("HISTOR"):SetValue(QCT->E5_HISTOR)
									oPatr:Cell("NATUREZA"):SetValue(QCT->E5_NATUREZ)
									oPatr:Cell("AGENCIA"):SetValue(QCT->E5_AGENCIA)
									oPatr:PrintLine()
									
								ELSE //(1 = COM RATEIO POR CC)
									
									IF SEV->EV_IDENT ='1'
										//Valor da Baixa * Percentual de distribuição da natureza.
										
										nTotSEV:= SEV->EV_VALOR
										
										DbSelectArea("SEZ")
										SEZ->(DbSetOrder(1))
										SEZ->(DbSeek(SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA))
										IF SEZ->(Found())
											
											While SEZ->(!EOF()) .AND. (SEZ->EZ_FILIAL==SE5->E5_FILIAL) .AND. (SEZ->EZ_PREFIXO==SE5->E5_PREFIXO) ;
												.AND. (SEZ->EZ_NUM==SE5->E5_NUMERO);
												.AND. (SEZ->EZ_PARCELA==SE5->E5_PARCELA) .AND. (SEZ->EZ_TIPO==SE5->E5_TIPO) .AND. (SEZ->EZ_CLIFOR==SE5->E5_CLIFOR);
												.AND. (SEZ->EZ_LOJA==SE5->E5_LOJA)
												
												if SEV->EV_NATUREZ == SEZ->EZ_NATUREZ
													
													nTotSEZ := SEV->EV_VALOR * SEZ->EZ_PERC
													
													//oPatr:Cell("CCUSTO"):SetValue(SEZ->EZ_CCUSTO)
													//oPatr:Cell("EZNATURE"):SetValue(SEZ->EZ_NATUREZ)
													//oPatr:Cell("VALORSEV"):SetValue(nTotSEV)
													//oPatr:Cell("VALORSEZ"):SetValue(nTotSEZ)
													oPatr:Cell("VALORSE5"):SetValue(QCT->E5_VALOR)
													oPatr:Cell("EMP"):SetValue(QCT->EMP)
													oPatr:Cell("FILIAL"):SetValue(QCT->E5_FILIAL)
													oPatr:Cell("DATA" ):SetValue(STOD(QCT->E5_DATA))
													oPatr:Cell("CLIFOR"):SetValue(QCT->E5_CLIFOR)
													oPatr:Cell("NUMERO"):SetValue(QCT->E5_NUMERO)
													oPatr:Cell("TIPODOC"):SetValue(QCT->E5_TIPODOC)
													oPatr:Cell("LOJA" ):SetValue(QCT->E5_LOJA)
													oPatr:Cell("SITCOB"):SetValue(QCT->E5_SITCOB)
													oPatr:Cell("RECPAG"):SetValue(QCT->E5_RECPAG)
													oPatr:Cell("CONTA"):SetValue(QCT->E5_CONTA)
													oPatr:Cell("CCC"):SetValue(QCT->E5_CCC)
													oPatr:Cell("CCD"):SetValue(QCT->E5_CCD)
													oPatr:Cell("CLVLCR"):SetValue(QCT->E5_CLVLCR)
													oPatr:Cell("CLVLDB"):SetValue(QCT->E5_CLVLDB)
													oPatr:Cell("HISTOR"):SetValue(QCT->E5_HISTOR)
													oPatr:Cell("NATUREZA"):SetValue(QCT->E5_NATUREZ)
													oPatr:Cell("AGENCIA"):SetValue(QCT->E5_AGENCIA)
													oPatr:PrintLine()
												ENDIF
												SEZ->(dbSkip())
											EndDo
											
											
										ENDIF
										
									endif
									
									
								ENDIF
								SEV->(dbSkip())
							EndDo
							
						ENDIF
						
						
						//E2_SALDO > 0 tratamento de baixa parcial
					ELSE
						
						//Posiciona na SEV-MULTIPLAS NATUREZAS POR TÍTULO
						DbSelectArea("SEV")
						SEV->(DbSetOrder(1))
						SEV->(DbSeek(SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA))
						If SEV->(Found())
							IF SEV->EV_IDENT ='1'
								
								While SEV->(!EOF()) .AND. (SEV->EV_FILIAL==SE5->E5_FILIAL) .AND. (SEV->EV_PREFIXO==SE5->E5_PREFIXO) ;
									.AND. (SEV->EV_NUM==SE5->E5_NUMERO);
									.AND. (SEV->EV_PARCELA==SE5->E5_PARCELA) .AND. (SEV->EV_TIPO==SE5->E5_TIPO) .AND. (SEV->EV_CLIFOR==SE5->E5_CLIFOR);
									.AND. (SEV->EV_LOJA==SE5->E5_LOJA)
									
									//VERIFICA se existe rateio de centro de custo por natureza
									IF SEV->EV_RATEICC = '2' //(2 = SEM RATEIO POR CC)
										
										//oPatr:Cell("CCUSTO"):SetValue("")
										//oPatr:Cell("EZNATURE"):SetValue(SEV->EV_NATUREZ)
										//oPatr:Cell("VALORSEV"):SetValue(SE5->E5_VALOR * SEV->EV_PERC)
										//oPatr:Cell("VALORSEZ"):SetValue(0)
										oPatr:Cell("VALORSE5"):SetValue(QCT->E5_VALOR)
										oPatr:Cell("EMP"):SetValue(QCT->EMP)
										oPatr:Cell("FILIAL"):SetValue(QCT->E5_FILIAL)
										oPatr:Cell("DATA" ):SetValue(STOD(QCT->E5_DATA))
										oPatr:Cell("CLIFOR"):SetValue(QCT->E5_CLIFOR)
										oPatr:Cell("NUMERO"):SetValue(QCT->E5_NUMERO)
										oPatr:Cell("TIPODOC"):SetValue(QCT->E5_TIPODOC)
										oPatr:Cell("LOJA" ):SetValue(QCT->E5_LOJA)
										oPatr:Cell("SITCOB"):SetValue(QCT->E5_SITCOB)
										oPatr:Cell("RECPAG"):SetValue(QCT->E5_RECPAG)
										oPatr:Cell("CONTA"):SetValue(QCT->E5_CONTA)
										oPatr:Cell("CCC"):SetValue(QCT->E5_CCC)
										oPatr:Cell("CCD"):SetValue(QCT->E5_CCD)
										oPatr:Cell("CLVLCR"):SetValue(QCT->E5_CLVLCR)
										oPatr:Cell("CLVLDB"):SetValue(QCT->E5_CLVLDB)
										oPatr:Cell("HISTOR"):SetValue(QCT->E5_HISTOR)
										oPatr:Cell("NATUREZA"):SetValue(QCT->E5_NATUREZ)
										oPatr:Cell("AGENCIA"):SetValue(QCT->E5_AGENCIA)
										oPatr:PrintLine()
										
									ELSE //(1 = COM RATEIO POR CC)
										
										//Valor da Baixa * Percentual de distribuição da natureza.
										
										nTotSEV:= SE5->E5_VALOR * SEV->EV_PERC
										
										DbSelectArea("SEZ")
										SEZ->(DbSetOrder(1))
										SEZ->(DbSeek(SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA))
										IF SEZ->(Found())
											if SEV->EV_NATUREZ = SEZ->EZ_NATUREZ
												While SEZ->(!EOF()) .AND. (SEZ->EZ_FILIAL==SE5->E5_FILIAL) .AND. (SEZ->EZ_PREFIXO==SE5->E5_PREFIXO) ;
													.AND. (SEZ->EZ_NUM==SE5->E5_NUMERO);
													.AND. (SEZ->EZ_PARCELA==SE5->E5_PARCELA) .AND. (SEZ->EZ_TIPO==SE5->E5_TIPO) .AND. (SEZ->EZ_CLIFOR==SE5->E5_CLIFOR);
													.AND. (SEZ->EZ_LOJA==SE5->E5_LOJA)
													
													nTotSEZ := SEV->EV_VALOR * SEZ->EZ_PERC
													
													//oPatr:Cell("CCUSTO"):SetValue(SEZ->EZ_CCUSTO)
													//oPatr:Cell("EZNATURE"):SetValue(SEZ->EZ_NATUREZ)
													oPatr:Cell("VALOR"):SetValue(nTotSEV)
													oPatr:Cell("EMP"):SetValue(QCT->EMP)
													oPatr:Cell("FILIAL"):SetValue(QCT->E5_FILIAL)
													oPatr:Cell("DATA" ):SetValue(STOD(QCT->E5_DATA))
													oPatr:Cell("CLIFOR"):SetValue(QCT->E5_CLIFOR)
													oPatr:Cell("NUMERO"):SetValue(QCT->E5_NUMERO)
													oPatr:Cell("TIPODOC"):SetValue(QCT->E5_TIPODOC)
													oPatr:Cell("LOJA" ):SetValue(QCT->E5_LOJA)
													oPatr:Cell("SITCOB"):SetValue(QCT->E5_SITCOB)
													oPatr:Cell("RECPAG"):SetValue(QCT->E5_RECPAG)
													oPatr:Cell("CONTA"):SetValue(QCT->E5_CONTA)
													oPatr:Cell("CCC"):SetValue(QCT->E5_CCC)
													oPatr:Cell("CCD"):SetValue(QCT->E5_CCD)
													oPatr:Cell("CLVLCR"):SetValue(QCT->E5_CLVLCR)
													oPatr:Cell("CLVLDB"):SetValue(QCT->E5_CLVLDB)
													oPatr:Cell("HISTOR"):SetValue(QCT->E5_HISTOR)
													oPatr:Cell("NATUREZA"):SetValue(QCT->E5_NATUREZ)
													oPatr:Cell("AGENCIA"):SetValue(QCT->E5_AGENCIA)
													oPatr:PrintLine()
													SEZ->(dbSkip())
												EndDo
												
											ENDIF
										ENDIF
									ENDIF
									SEV->(dbSkip())
								EndDo
							ENDIF
							
						ENDIF
						
					ENDIF
				ELSE
					//oPatr:Cell("CCUSTO"):SetValue("")
					//oPatr:Cell("EZNATURE"):SetValue("")
					//oPatr:Cell("VALORSEV"):SetValue(0)
					//oPatr:Cell("VALORSEZ"):SetValue(0)
					oPatr:Cell("VALORSE5"):SetValue(QCT->E5_VALOR)
					oPatr:Cell("EMP"):SetValue(QCT->EMP)
					oPatr:Cell("FILIAL"):SetValue(QCT->E5_FILIAL)
					oPatr:Cell("DATA" ):SetValue(STOD(QCT->E5_DATA))
					oPatr:Cell("CLIFOR"):SetValue(QCT->E5_CLIFOR)
					oPatr:Cell("NUMERO"):SetValue(QCT->E5_NUMERO)
					oPatr:Cell("TIPODOC"):SetValue(QCT->E5_TIPODOC)
					oPatr:Cell("LOJA" ):SetValue(QCT->E5_LOJA)
					oPatr:Cell("SITCOB"):SetValue(QCT->E5_SITCOB)
					oPatr:Cell("RECPAG"):SetValue(QCT->E5_RECPAG)
					oPatr:Cell("CONTA"):SetValue(QCT->E5_CONTA)
					oPatr:Cell("CCC"):SetValue(QCT->E5_CCC)
					oPatr:Cell("CCD"):SetValue(QCT->E5_CCD)
					oPatr:Cell("CLVLCR"):SetValue(QCT->E5_CLVLCR)
					oPatr:Cell("CLVLDB"):SetValue(QCT->E5_CLVLDB)
					oPatr:Cell("HISTOR"):SetValue(QCT->E5_HISTOR)
					oPatr:Cell("NATUREZA"):SetValue(QCT->E5_NATUREZ)
					oPatr:Cell("AGENCIA"):SetValue(QCT->E5_AGENCIA)
					oPatr:PrintLine()
				ENDIF//E2_MULTNAT VAZIO
				
			ENDIF
			
		ELSE//CONTAS RECEBER
			
			// identifica se o rateio foi efetuado na inclusão do título.
			//	IF  !empty(E5_MULTNAT)
			
			// Posiciona na SE1 para verificar se a baixa é parcial ou total
			DbSelectArea("SE1")
			SE1->(DbSetOrder(1))
			SE1->(DbSeek(SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_FORNECE+SE5->E5_LOJA))
			If SE1->(Found())
				
				// Se e1_multnat  = vazio , não calcula nada
				IF (SE1->E1_MULTNAT=="1")   .or. (SE5->E5_MULTNAT=="1")
					
					//se E2_SALDO = 0 tratamento de baixas totais.
					IF SE1->E1_SALDO = 0
						
						//Posiciona na SEV - MULTIPLAS NATUREZAS POR TÍTULO
						DbSelectArea("SEV")
						SEV->(DbSetOrder(1))
						SEV->(DbSeek(SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA))
						If SEV->(Found())
							
							While SEV->(!EOF()) .AND. (SEV->EV_FILIAL==SE5->E5_FILIAL) .AND. (SEV->EV_PREFIXO==SE5->E5_PREFIXO) ;
								.AND. (SEV->EV_NUM==SE5->E5_NUMERO);
								.AND. (SEV->EV_PARCELA==SE5->E5_PARCELA) .AND. (SEV->EV_TIPO==SE5->E5_TIPO) .AND. (SEV->EV_CLIFOR==SE5->E5_CLIFOR);
								.AND. (SEV->EV_LOJA==SE5->E5_LOJA)
								
								//VERIFICA se existe rateio de centro de custo por natureza
								IF SEV->EV_RATEICC = '2' //(2 = SEM RATEIO POR CC)
									
									
									//oPatr:Cell("CCUSTO"):SetValue("")
									//oPatr:Cell("EZNATURE"):SetValue(SEV->EV_NATUREZ)
									//oPatr:Cell("VALORSEV"):SetValue(SEV->EV_VALOR)
									//oPatr:Cell("VALORSEZ"):SetValue(0)
									oPatr:Cell("VALORSE5"):SetValue(QCT->E5_VALOR)
									oPatr:Cell("EMP"):SetValue(QCT->EMP)
									oPatr:Cell("FILIAL"):SetValue(QCT->E5_FILIAL)
									oPatr:Cell("DATA" ):SetValue(STOD(QCT->E5_DATA))
									oPatr:Cell("CLIFOR"):SetValue(QCT->E5_CLIFOR)
									oPatr:Cell("NUMERO"):SetValue(QCT->E5_NUMERO)
									oPatr:Cell("TIPODOC"):SetValue(QCT->E5_TIPODOC)
									oPatr:Cell("LOJA" ):SetValue(QCT->E5_LOJA)
									oPatr:Cell("SITCOB"):SetValue(QCT->E5_SITCOB)
									oPatr:Cell("RECPAG"):SetValue(QCT->E5_RECPAG)
									oPatr:Cell("CONTA"):SetValue(QCT->E5_CONTA)
									oPatr:Cell("CCC"):SetValue(QCT->E5_CCC)
									oPatr:Cell("CCD"):SetValue(QCT->E5_CCD)
									oPatr:Cell("CLVLCR"):SetValue(QCT->E5_CLVLCR)
									oPatr:Cell("CLVLDB"):SetValue(QCT->E5_CLVLDB)
									oPatr:Cell("HISTOR"):SetValue(QCT->E5_HISTOR)
									oPatr:Cell("NATUREZA"):SetValue(QCT->E5_NATUREZ)
									oPatr:Cell("AGENCIA"):SetValue(QCT->E5_AGENCIA)
									oPatr:PrintLine()
									
								ELSE //(1 = COM RATEIO POR CC)
									
									IF SEV->EV_IDENT ='1'
										//Valor da Baixa * Percentual de distribuição da natureza.
										
										nTotSEV:= SEV->EV_VALOR
										
										DbSelectArea("SEZ")
										SEZ->(DbSetOrder(1))
										SEZ->(DbSeek(SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA))
										IF SEZ->(Found())
											
											While SEZ->(!EOF()) .AND. (SEZ->EZ_FILIAL==SE5->E5_FILIAL) .AND. (SEZ->EZ_PREFIXO==SE5->E5_PREFIXO) ;
												.AND. (SEZ->EZ_NUM==SE5->E5_NUMERO);
												.AND. (SEZ->EZ_PARCELA==SE5->E5_PARCELA) .AND. (SEZ->EZ_TIPO==SE5->E5_TIPO) .AND. (SEZ->EZ_CLIFOR==SE5->E5_CLIFOR);
												.AND. (SEZ->EZ_LOJA==SE5->E5_LOJA)
												
												if SEV->EV_NATUREZ == SEZ->EZ_NATUREZ
													
													nTotSEZ := SEV->EV_VALOR * SEZ->EZ_PERC
													
													//oPatr:Cell("CCUSTO"):SetValue(SEZ->EZ_CCUSTO)
													//oPatr:Cell("EZNATURE"):SetValue(SEZ->EZ_NATUREZ)
													//oPatr:Cell("VALORSEV"):SetValue(nTotSEV)
													//oPatr:Cell("VALORSEZ"):SetValue(nTotSEZ)
													oPatr:Cell("VALORSE5"):SetValue(QCT->E5_VALOR)
													oPatr:Cell("EMP"):SetValue(QCT->EMP)
													oPatr:Cell("FILIAL"):SetValue(QCT->E5_FILIAL)
													oPatr:Cell("DATA" ):SetValue(STOD(QCT->E5_DATA))
													oPatr:Cell("CLIFOR"):SetValue(QCT->E5_CLIFOR)
													oPatr:Cell("NUMERO"):SetValue(QCT->E5_NUMERO)
													oPatr:Cell("TIPODOC"):SetValue(QCT->E5_TIPODOC)
													oPatr:Cell("LOJA" ):SetValue(QCT->E5_LOJA)
													oPatr:Cell("SITCOB"):SetValue(QCT->E5_SITCOB)
													oPatr:Cell("RECPAG"):SetValue(QCT->E5_RECPAG)
													oPatr:Cell("CONTA"):SetValue(QCT->E5_CONTA)
													oPatr:Cell("CCC"):SetValue(QCT->E5_CCC)
													oPatr:Cell("CCD"):SetValue(QCT->E5_CCD)
													oPatr:Cell("CLVLCR"):SetValue(QCT->E5_CLVLCR)
													oPatr:Cell("CLVLDB"):SetValue(QCT->E5_CLVLDB)
													oPatr:Cell("HISTOR"):SetValue(QCT->E5_HISTOR)
													oPatr:Cell("NATUREZA"):SetValue(QCT->E5_NATUREZ)
													oPatr:Cell("AGENCIA"):SetValue(QCT->E5_AGENCIA)
													oPatr:PrintLine()
												ENDIF
												SEZ->(dbSkip())
											EndDo
											
											
										ENDIF
										
									ENDIF
									
								ENDIF
								SEV->(dbSkip())
							EndDo
							
						ENDIF
						
						
						//E2_SALDO > 0 tratamento de baixa parcial
					ELSE
						
						//Posiciona na SEV-MULTIPLAS NATUREZAS POR TÍTULO
						DbSelectArea("SEV")
						SEV->(DbSetOrder(1))
						SEV->(DbSeek(SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA))
						If SEV->(Found())
							IF SEV->EV_IDENT ='1'
								
								While SEV->(!EOF()) .AND. (SEV->EV_FILIAL==SE5->E5_FILIAL) .AND. (SEV->EV_PREFIXO==SE5->E5_PREFIXO) ;
									.AND. (SEV->EV_NUM==SE5->E5_NUMERO);
									.AND. (SEV->EV_PARCELA==SE5->E5_PARCELA) .AND. (SEV->EV_TIPO==SE5->E5_TIPO) .AND. (SEV->EV_CLIFOR==SE5->E5_CLIFOR);
									.AND. (SEV->EV_LOJA==SE5->E5_LOJA)
									
									//VERIFICA se existe rateio de centro de custo por natureza
									IF SEV->EV_RATEICC = '2' //(2 = SEM RATEIO POR CC)
										
										
										//oPatr:Cell("CCUSTO"):SetValue("")
										//oPatr:Cell("EZNATURE"):SetValue(SEV->EV_NATUREZ)
										//oPatr:Cell("VALORSEV"):SetValue(SE5->E5_VALOR * SEV->EV_PERC)
										//oPatr:Cell("VALORSEZ"):SetValue(0)
										oPatr:Cell("VALORSE5"):SetValue(QCT->E5_VALOR)
										oPatr:Cell("EMP"):SetValue(QCT->EMP)
										oPatr:Cell("FILIAL"):SetValue(QCT->E5_FILIAL)
										oPatr:Cell("DATA" ):SetValue(STOD(QCT->E5_DATA))
										oPatr:Cell("CLIFOR"):SetValue(QCT->E5_CLIFOR)
										oPatr:Cell("NUMERO"):SetValue(QCT->E5_NUMERO)
										oPatr:Cell("TIPODOC"):SetValue(QCT->E5_TIPODOC)
										oPatr:Cell("LOJA" ):SetValue(QCT->E5_LOJA)
										oPatr:Cell("SITCOB"):SetValue(QCT->E5_SITCOB)
										oPatr:Cell("RECPAG"):SetValue(QCT->E5_RECPAG)
										oPatr:Cell("CONTA"):SetValue(QCT->E5_CONTA)
										oPatr:Cell("CCC"):SetValue(QCT->E5_CCC)
										oPatr:Cell("CCD"):SetValue(QCT->E5_CCD)
										oPatr:Cell("CLVLCR"):SetValue(QCT->E5_CLVLCR)
										oPatr:Cell("CLVLDB"):SetValue(QCT->E5_CLVLDB)
										oPatr:Cell("HISTOR"):SetValue(QCT->E5_HISTOR)
										oPatr:Cell("NATUREZA"):SetValue(QCT->E5_NATUREZ)
										oPatr:Cell("AGENCIA"):SetValue(QCT->E5_AGENCIA)
										oPatr:PrintLine()
										
									ELSE //(1 = COM RATEIO POR CC)
										
										//Valor da Baixa * Percentual de distribuição da natureza.
										
										nTotSEV:= SE5->E5_VALOR * SEV->EV_PERC
										
										DbSelectArea("SEZ")
										SEZ->(DbSetOrder(1))
										SEZ->(DbSeek(SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA))
										IF SEZ->(Found())
											if SEV->EV_NATUREZ = SEZ->EZ_NATUREZ
												While SEZ->(!EOF()) .AND. (SEZ->EZ_FILIAL==SE5->E5_FILIAL) .AND. (SEZ->EZ_PREFIXO==SE5->E5_PREFIXO) ;
													.AND. (SEZ->EZ_NUM==SE5->E5_NUMERO);
													.AND. (SEZ->EZ_PARCELA==SE5->E5_PARCELA) .AND. (SEZ->EZ_TIPO==SE5->E5_TIPO) .AND. (SEZ->EZ_CLIFOR==SE5->E5_CLIFOR);
													.AND. (SEZ->EZ_LOJA==SE5->E5_LOJA)
													
													nTotSEZ := SEV->EV_VALOR * SEZ->EZ_PERC
													
													//oPatr:Cell("CCUSTO"):SetValue(SEZ->EZ_CCUSTO)
													//oPatr:Cell("EZNATURE"):SetValue(SEZ->EZ_NATUREZ)
													oPatr:Cell("VALOR"):SetValue(nTotSEV)
													oPatr:Cell("EMP"):SetValue(QCT->EMP)
													oPatr:Cell("FILIAL"):SetValue(QCT->E5_FILIAL)
													oPatr:Cell("DATA" ):SetValue(STOD(QCT->E5_DATA))
													oPatr:Cell("CLIFOR"):SetValue(QCT->E5_CLIFOR)
													oPatr:Cell("NUMERO"):SetValue(QCT->E5_NUMERO)
													oPatr:Cell("TIPODOC"):SetValue(QCT->E5_TIPODOC)
													oPatr:Cell("LOJA" ):SetValue(QCT->E5_LOJA)
													oPatr:Cell("SITCOB"):SetValue(QCT->E5_SITCOB)
													oPatr:Cell("RECPAG"):SetValue(QCT->E5_RECPAG)
													oPatr:Cell("CONTA"):SetValue(QCT->E5_CONTA)
													oPatr:Cell("CCC"):SetValue(QCT->E5_CCC)
													oPatr:Cell("CCD"):SetValue(QCT->E5_CCD)
													oPatr:Cell("CLVLCR"):SetValue(QCT->E5_CLVLCR)
													oPatr:Cell("CLVLDB"):SetValue(QCT->E5_CLVLDB)
													oPatr:Cell("HISTOR"):SetValue(QCT->E5_HISTOR)
													oPatr:Cell("NATUREZA"):SetValue(QCT->E5_NATUREZ)
													oPatr:Cell("AGENCIA"):SetValue(QCT->E5_AGENCIA)
													oPatr:PrintLine()
													SEZ->(dbSkip())
												EndDo
												
											ENDIF
										ENDIF
									ENDIF
									SEV->(dbSkip())
								EndDo
								
							ENDIF
							
						ENDIF
						
					ENDIF
					
				ELSE
					//oPatr:Cell("CCUSTO"):SetValue("")
					//oPatr:Cell("EZNATURE"):SetValue("")
					//oPatr:Cell("VALORSEV"):SetValue(0)
					//oPatr:Cell("VALORSEZ"):SetValue(0)
					oPatr:Cell("VALORSE5"):SetValue(QCT->E5_VALOR)
					oPatr:Cell("EMP"):SetValue(QCT->EMP)
					oPatr:Cell("FILIAL"):SetValue(QCT->E5_FILIAL)
					oPatr:Cell("DATA" ):SetValue(STOD(QCT->E5_DATA))
					oPatr:Cell("CLIFOR"):SetValue(QCT->E5_CLIFOR)
					oPatr:Cell("NUMERO"):SetValue(QCT->E5_NUMERO)
					oPatr:Cell("TIPODOC"):SetValue(QCT->E5_TIPODOC)
					oPatr:Cell("LOJA" ):SetValue(QCT->E5_LOJA)
					oPatr:Cell("SITCOB"):SetValue(QCT->E5_SITCOB)
					oPatr:Cell("RECPAG"):SetValue(QCT->E5_RECPAG)
					oPatr:Cell("CONTA"):SetValue(QCT->E5_CONTA)
					oPatr:Cell("CCC"):SetValue(QCT->E5_CCC)
					oPatr:Cell("CCD"):SetValue(QCT->E5_CCD)
					oPatr:Cell("CLVLCR"):SetValue(QCT->E5_CLVLCR)
					oPatr:Cell("CLVLDB"):SetValue(QCT->E5_CLVLDB)
					oPatr:Cell("HISTOR"):SetValue(QCT->E5_HISTOR)
					oPatr:Cell("NATUREZA"):SetValue(QCT->E5_NATUREZ)
					oPatr:Cell("AGENCIA"):SetValue(QCT->E5_AGENCIA)
					oPatr:PrintLine()
				ENDIF//E2_MULTNAT VAZIO
				
			ENDIF
			
			
			//ENDIF//E2_MULTNAT VAZIO
			
		ENDIF
	Endif
	
	
	QCT->(dbSkip())
Enddo

oPatr:Finish()

Return


/*
+----------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                      !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Descricao         ! Função para criação das perguntas na SX1	             !
+------------------+---------------------------------------------------------+
!Autor             ! Jair Matos de Andrade                                   !
+------------------+---------------------------------------------------------+
*/

static function CriaPerg
PutSx1(cPerg,"01", "Data de  ?", "Data de?  ", "Data de      ", 					"mv_ch1", "D",	8,0,0, 	"G", "", ""   , "", "", "mv_par01",""            , ""            , ""            , "", ""         , ""         , ""         , "", "", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")
PutSx1(cPerg,"02", "Data até ?", "Data até? ", "Data até     ", 					"mv_ch2", "D", 	8,0,0, 	"G", "", ""   , "", "", "mv_par02",""            , ""            , ""            , "", ""         , ""         , ""         , "", "", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")

Return


/*
+----------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                      !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Descricao         ! Função que grava os arquivos em CSV para o servidor     !
+------------------+---------------------------------------------------------+
!Autor             ! Jair Matos de Andrade                                   !
+------------------+---------------------------------------------------------+
*/
Static Function GravaEX(cCaminho,nomearq,dDataIni, dDataFim)

Local cQuery   := ""
Local aEmp     := {}
Local aArea    := SM0->(GetArea('SM0'))
Local cCrLf 	 := Chr(13) + Chr(10)
Local oExcelApp
Local nHandle
Local nCnt := 0
Local aHeader  := {}
Local aFields  := {}
Local cAlias := ""
Local cStr := ""
Local cCaminho:=cCaminho+nomearq
Local nomeArq:=nomearq
Local cValorSE5:=""
Local cValorSEV:=""
Local cValorSEZ:=""
Local cNaturez:=""
Local cCusto:=""
cAlias := "SE5"

aFields := {"EMPRESA","E5_FILIAL", "E5_DATA", "E5_CLIFOR", "E5_NUMERO", "E5_TIPODOC", "E5_LOJA", "E5_SITCOB",;
"E5_RECPAG", "E5_CONTA", "E5_CCC", "E5_CCD", "E5_CLVLCR", "E5_CLVLDB", "E5_HISTOR", "E5_NATUREZ",;
"E5_VALOR", "E5_RECONC","E5_AGENCIA"}


// Define propriedades dos campos baseado no SX3
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFields)
	If SX3->(DbSeek(aFields[nX]))
		if aFields[nX] =="E5_VALOR"
			Aadd(aHeader, {"VALOR SE5",SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
			SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		ELSE
			Aadd(aHeader, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
			SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		endif
	elseIF aFields[nX] =="EMPRESA"
		Aadd(aHeader, {"Empresa","","@!",15,0,"","","C","","R","",""})
	ELSE
		Aadd(aHeader, {"     ","","@!",15,0,"","","C","","R","",""})
	Endif
Next nX

DbSelectArea("SM0")
DbSetOrder(01)
DbGoTop()

cCod := ""
While !SM0->(EOF())
	if cCod != SM0->M0_CODIGO
		cCod := SM0->M0_CODIGO
		aAdd(aEmp, SM0->M0_CODIGO)
	EndIf
	SM0->(dbSkip())
End
for i := 1 to len(aEmp)
	cQuery += " SELECT '"+aEmp[i]+"' AS EMP,E5_FILIAL,E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_TIPO,E5_CLIFOR,E5_LOJA,E5_DATA,E5_TIPODOC,E5_SITCOB,E5_RECPAG, "
	cQuery += " E5_CONTA,E5_CCC,E5_CCD,E5_CLVLCR,E5_CLVLDB,E5_HISTOR,E5_NATUREZ,E5_VALOR,E5_AGENCIA,E5_RECONC "
 	cQuery += " FROM " + cAlias + aEmp[i] + "0 "
   	cQuery += " WHERE  E5_DATA BETWEEN  '" + DTOS(dDataIni)  + "' AND '" + DTOS(dDataFim) + "'
 //	cQuery += " WHERE  E5_DATA BETWEEN  '20140115' AND '20140115' "
	cQuery += " AND E5_TIPODOC='VL' "
	
	if i == len(aEmp)
		cQuery += "ORDER BY E5_FILIAL,E5_RECPAG,E5_NUMERO "
	Else
		cQuery += "UNION ALL "
	EndIf
Next

TcQuery cQuery NEW Alias "SETMP"

if At(".",cCaminho) > 0
	cCaminho := SubStr(cCaminho,1,At(".",cCaminho)-1)
EndIf

If !ExistDir(cGetCam)
	nRet := makeDir(cGetCam)
	If nRet != 0
		conout("Não foi possível criar o diretório "+cGetCam )
	EndIf
EndIf

nHandle := MsfCreate(AllTrim(cCaminho) + ".CSV",0)

If nHandle > 0
	
	// Grava o cabecalho do arquivo
	aEval(aHeader, {|e, nX| fWrite(nHandle, e[1] + If(nX < Len(aHeader), ";", "") ) } )
	fWrite(nHandle, cCrLf ) // Pula linha
	
	
	dbSelectArea('SETMP')
	SETMP->(dbGoTop())
	If SETMP->(Eof())
		RETURN
	ENDIF
	
	while !(SETMP->(EOF()))
		nCnt ++
		SETMP->(DbSkip())
	EndDo
	If !lWeb
		SetRegua(nCnt)
	endif
	SETMP->(dbGoTop())
	while !(SETMP->(EOF()))
		
		//Posiciona na SE5 para verificação dos títulos
		DbSelectArea("SE5")
		SE5->(DbSetOrder(7))
		SE5->(DbSeek(SETMP->E5_FILIAL+SETMP->E5_PREFIXO+SETMP->E5_NUMERO+SETMP->E5_PARCELA+SETMP->E5_TIPO+SETMP->E5_CLIFOR+SETMP->E5_LOJA))
		If SE5->(Found())
			
			//CONTAS PAGAR
			IF SETMP->E5_RECPAG =='P'
				
				// identifica se o rateio foi efetuado na inclusão do título.
				//	IF  !empty(E5_MULTNAT)
				
				// Posiciona na SE2 para verificar se a baixa é parcial ou total
				DbSelectArea("SE2")
				SE2->(DbSetOrder(1))
				SE2->(DbSeek(SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_FORNECE+SE5->E5_LOJA))
				If SE2->(Found())
					
					// Se e2_multnat  = vazio , não calcula nada
					IF (SE2->E2_MULTNAT=="1")   .or. (SE5->E5_MULTNAT=="1")
						
						//se E2_SALDO = 0 tratamento de baixas totais.
						IF SE2->E2_SALDO = 0
							
							//Posiciona na SEV - MULTIPLAS NATUREZAS POR TÍTULO
							DbSelectArea("SEV")
							SEV->(DbSetOrder(1))
							SEV->(DbSeek(SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA))
							If SEV->(Found())
								
								While SEV->(!EOF()) .AND. (SEV->EV_FILIAL==SE5->E5_FILIAL) .AND. (SEV->EV_PREFIXO==SE5->E5_PREFIXO) ;
									.AND. (SEV->EV_NUM==SE5->E5_NUMERO);
									.AND. (SEV->EV_PARCELA==SE5->E5_PARCELA) .AND. (SEV->EV_TIPO==SE5->E5_TIPO) .AND. (SEV->EV_CLIFOR==SE5->E5_CLIFOR);
									.AND. (SEV->EV_LOJA==SE5->E5_LOJA)
									
									//VERIFICA se existe rateio de centro de custo por natureza
									IF SEV->EV_RATEICC = '2' //(2 = SEM RATEIO POR CC)
										
										cCusto		:= ""
										cNaturez 	:= SEV->EV_NATUREZ
										cValorSEV	:= Transform(SEV->EV_VALOR,"@E 999,999,999.99")
										cValorSEZ 	:= Transform(0,"@E 999,999,999.99")
										cValorSE5 	:= Transform(SETMP->E5_VALOR,"@E 999,999,999.99")
										cData:=dtoc(stod(SETMP->E5_DATA))
										fWrite(nHandle, chr(160)+UPPER(SETMP->EMP)+";"+chr(160)+SETMP->E5_FILIAL +";"+ cData +";"+ chr(160)+SETMP->E5_CLIFOR +";"+chr(160)+SETMP->E5_NUMERO +";"+;
										SETMP->E5_TIPODOC +";"+chr(160)+SETMP->E5_LOJA +";"+ SETMP->E5_SITCOB +";"+;
										SETMP->E5_RECPAG +";"+chr(160)+SETMP->E5_CONTA +";"+ chr(160)+SETMP->E5_CCC +";"+ chr(160)+SETMP->E5_CCD +";"+ chr(160)+SETMP->E5_CLVLCR +";"+ chr(160)+SETMP->E5_CLVLDB +";"+;
										UPPER(SETMP->E5_HISTOR) +";"+ chr(160)+SETMP->E5_NATUREZ +";"+ chr(160)+cValorSE5 +";"+ chr(160)+SETMP->E5_RECONC +";"+ chr(160)+SETMP->E5_AGENCIA +";")
										fWrite(nHandle, cCrLf ) // Pula linha
										
									ELSE //(1 = COM RATEIO POR CC)
										
										IF SEV->EV_IDENT ='1'
											//Valor da Baixa * Percentual de distribuição da natureza.
											
											cValorSEV:= Transform(SEV->EV_VALOR,"@E 999,999,999.99")
											
											DbSelectArea("SEZ")
											SEZ->(DbSetOrder(1))
											SEZ->(DbSeek(SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA))
											IF SEZ->(Found())
												
												While SEZ->(!EOF()) .AND. (SEZ->EZ_FILIAL==SE5->E5_FILIAL) .AND. (SEZ->EZ_PREFIXO==SE5->E5_PREFIXO) ;
													.AND. (SEZ->EZ_NUM==SE5->E5_NUMERO);
													.AND. (SEZ->EZ_PARCELA==SE5->E5_PARCELA) .AND. (SEZ->EZ_TIPO==SE5->E5_TIPO) .AND. (SEZ->EZ_CLIFOR==SE5->E5_CLIFOR);
													.AND. (SEZ->EZ_LOJA==SE5->E5_LOJA)
													
													if SEV->EV_NATUREZ == SEZ->EZ_NATUREZ
														
														cValorSEZ 	:= Transform(SEV->EV_VALOR * SEZ->EZ_PERC,"@E 999,999,999.99")
														cValorSE5 	:= Transform(SETMP->E5_VALOR,"@E 999,999,999.99")
														cCusto		:=  SEZ->EZ_CCUSTO
														cNaturez	:=	SEZ->EZ_NATUREZ
														cData:=dtoc(stod(SETMP->E5_DATA))
														fWrite(nHandle, chr(160)+UPPER(SETMP->EMP)+";"+chr(160)+SETMP->E5_FILIAL +";"+ cData +";"+ chr(160)+SETMP->E5_CLIFOR +";"+chr(160)+SETMP->E5_NUMERO +";"+;
														SETMP->E5_TIPODOC +";"+chr(160)+SETMP->E5_LOJA +";"+ SETMP->E5_SITCOB +";"+;
														SETMP->E5_RECPAG +";"+chr(160)+SETMP->E5_CONTA +";"+ chr(160)+SETMP->E5_CCC +";"+ chr(160)+SETMP->E5_CCD +";"+ chr(160)+SETMP->E5_CLVLCR +";"+ chr(160)+SETMP->E5_CLVLDB +";"+;
														UPPER(SETMP->E5_HISTOR) +";"+ chr(160)+SETMP->E5_NATUREZ +";"+ chr(160)+cValorSE5 +";"+ chr(160)+SETMP->E5_RECONC +";"+ chr(160)+SETMP->E5_AGENCIA +";")
														fWrite(nHandle, cCrLf ) // Pula linha
													ENDIF
													SEZ->(dbSkip())
												EndDo
												
												
											ENDIF
										endif
										
									ENDIF
									SEV->(dbSkip())
								EndDo
								
							ENDIF
							
							
							//E2_SALDO > 0 tratamento de baixa parcial
						ELSE
							
							//Posiciona na SEV-MULTIPLAS NATUREZAS POR TÍTULO
							DbSelectArea("SEV")
							SEV->(DbSetOrder(1))
							SEV->(DbSeek(SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA))
							If SEV->(Found())
								IF SEV->EV_IDENT ='1'
									
									While SEV->(!EOF()) .AND. (SEV->EV_FILIAL==SE5->E5_FILIAL) .AND. (SEV->EV_PREFIXO==SE5->E5_PREFIXO) ;
										.AND. (SEV->EV_NUM==SE5->E5_NUMERO);
										.AND. (SEV->EV_PARCELA==SE5->E5_PARCELA) .AND. (SEV->EV_TIPO==SE5->E5_TIPO) .AND. (SEV->EV_CLIFOR==SE5->E5_CLIFOR);
										.AND. (SEV->EV_LOJA==SE5->E5_LOJA)
										
										//VERIFICA se existe rateio de centro de custo por natureza
										IF SEV->EV_RATEICC = '2' //(2 = SEM RATEIO POR CC
											
											cCusto		:= ""
											cNaturez 	:= SEV->EV_NATUREZ
											cValorSEV	:= Transform((SEV->EV_VALOR * SEV->EV_PERC),"@E 999,999,999.99")
											cValorSEZ 	:= Transform(0,"@E 999,999,999.99")
											cValorSE5 	:= Transform(SETMP->E5_VALOR,"@E 999,999,999.99")
											cData:=dtoc(stod(SETMP->E5_DATA))
											fWrite(nHandle, chr(160)+UPPER(SETMP->EMP)+";"+chr(160)+SETMP->E5_FILIAL +";"+ cData +";"+ chr(160)+SETMP->E5_CLIFOR +";"+chr(160)+SETMP->E5_NUMERO +";"+;
											SETMP->E5_TIPODOC +";"+chr(160)+SETMP->E5_LOJA +";"+ SETMP->E5_SITCOB +";"+;
											SETMP->E5_RECPAG +";"+chr(160)+SETMP->E5_CONTA +";"+ chr(160)+SETMP->E5_CCC +";"+ chr(160)+SETMP->E5_CCD +";"+ chr(160)+SETMP->E5_CLVLCR +";"+ chr(160)+SETMP->E5_CLVLDB +";"+;
											UPPER(SETMP->E5_HISTOR) +";"+ chr(160)+SETMP->E5_NATUREZ +";"+chr(160)+cValorSE5 +";"+  chr(160)+SETMP->E5_RECONC +";"+ chr(160)+SETMP->E5_AGENCIA +";")
											fWrite(nHandle, cCrLf ) // Pula linha
											
										ELSE //(1 = COM RATEIO POR CC)
											
											//Valor da Baixa * Percentual de distribuição da natureza.
											
											cValorSEV:= Transform((SE5->E5_VALOR * SEV->EV_PERC),"@E 999,999,999.99")
											
											DbSelectArea("SEZ")
											SEZ->(DbSetOrder(1))
											SEZ->(DbSeek(SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA))
											IF SEZ->(Found())
												if SEV->EV_NATUREZ = SEZ->EZ_NATUREZ
													While SEZ->(!EOF()) .AND. (SEZ->EZ_FILIAL==SE5->E5_FILIAL) .AND. (SEZ->EZ_PREFIXO==SE5->E5_PREFIXO) ;
														.AND. (SEZ->EZ_NUM==SE5->E5_NUMERO);
														.AND. (SEZ->EZ_PARCELA==SE5->E5_PARCELA) .AND. (SEZ->EZ_TIPO==SE5->E5_TIPO) .AND. (SEZ->EZ_CLIFOR==SE5->E5_CLIFOR);
														.AND. (SEZ->EZ_LOJA==SE5->E5_LOJA)
														
														cValorSEZ := Transform((SEV->EV_VALOR * SEV->EV_PERC),"@E 999,999,999.99")
														cValorSE5 	:= Transform(SETMP->E5_VALOR,"@E 999,999,999.99")
														cCusto		:=  SEZ->EZ_CCUSTO
														cNaturez	:=	SEZ->EZ_NATUREZ
														cData:=dtoc(stod(SETMP->E5_DATA))
														fWrite(nHandle, chr(160)+UPPER(SETMP->EMP)+";"+chr(160)+SETMP->E5_FILIAL +";"+ cData +";"+ chr(160)+SETMP->E5_CLIFOR +";"+chr(160)+SETMP->E5_NUMERO +";"+ SETMP->E5_TIPODOC +";"+chr(160)+SETMP->E5_LOJA +";"+ SETMP->E5_SITCOB +";"+;
														SETMP->E5_RECPAG +";"+chr(160)+SETMP->E5_CONTA +";"+ chr(160)+SETMP->E5_CCC +";"+ chr(160)+SETMP->E5_CCD +";"+ chr(160)+SETMP->E5_CLVLCR +";"+ chr(160)+SETMP->E5_CLVLDB +";"+;
														UPPER(SETMP->E5_HISTOR) +";"+ chr(160)+SETMP->E5_NATUREZ +";"+ chr(160)+cValorSE5 +";"+ chr(160)+SETMP->E5_RECONC +";"+chr(160)+SETMP->E5_AGENCIA+";")
														fWrite(nHandle, cCrLf ) // Pula linha
														SEZ->(dbSkip())
													EndDo
													
												ENDIF
											ENDIF
											
										ENDIF
										SEV->(dbSkip())
									EndDo
									
								ENDIF
								
							ENDIF
							
						ENDIF
						
					ELSE
						cCusto		:=  ""
						cNaturez	:=	""
						cValorSEZ:=Transform(0,"@E 999,999,999.99")
						cValorSEV:=Transform(0,"@E 999,999,999.99")
						cValorSE5 	:= Transform(SETMP->E5_VALOR,"@E 999,999,999.99")
						cData:=dtoc(stod(SETMP->E5_DATA))
						fWrite(nHandle, chr(160)+UPPER(SETMP->EMP)+";"+chr(160)+SETMP->E5_FILIAL +";"+ cData +";"+ chr(160)+SETMP->E5_CLIFOR +";"+chr(160)+SETMP->E5_NUMERO +";"+ SETMP->E5_TIPODOC +";"+chr(160)+SETMP->E5_LOJA +";"+ SETMP->E5_SITCOB +";"+;
						SETMP->E5_RECPAG +";"+chr(160)+SETMP->E5_CONTA +";"+ chr(160)+SETMP->E5_CCC +";"+ chr(160)+SETMP->E5_CCD +";"+ chr(160)+SETMP->E5_CLVLCR +";"+ chr(160)+SETMP->E5_CLVLDB +";"+;
						UPPER(SETMP->E5_HISTOR) +";"+ chr(160)+SETMP->E5_NATUREZ +";"+ chr(160)+cValorSE5 +";"+ chr(160)+SETMP->E5_RECONC +";"+chr(160)+SETMP->E5_AGENCIA +";")
						fWrite(nHandle, cCrLf ) // Pula linha
					ENDIF//E2_MULTNAT VAZIO
					
				ENDIF
				
			ELSE//CONTAS RECEBER
				
				// Posiciona na SE1 para verificar se a baixa é parcial ou total
				DbSelectArea("SE1")
				SE1->(DbSetOrder(1))
				SE1->(DbSeek(SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_FORNECE+SE5->E5_LOJA))
				If SE1->(Found())
					
					// Se e2_multnat  = vazio , não calcula nada
					IF (SE1->E1_MULTNAT=="1")   .or. (SE5->E5_MULTNAT=="1")
						
						//se E2_SALDO = 0 tratamento de baixas totais.
						IF SE1->E1_SALDO = 0
							
							//Posiciona na SEV - MULTIPLAS NATUREZAS POR TÍTULO
							DbSelectArea("SEV")
							SEV->(DbSetOrder(1))
							SEV->(DbSeek(SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA))
							If SEV->(Found())
								
								While SEV->(!EOF()) .AND. (SEV->EV_FILIAL==SE5->E5_FILIAL) .AND. (SEV->EV_PREFIXO==SE5->E5_PREFIXO) ;
									.AND. (SEV->EV_NUM==SE5->E5_NUMERO);
									.AND. (SEV->EV_PARCELA==SE5->E5_PARCELA) .AND. (SEV->EV_TIPO==SE5->E5_TIPO) .AND. (SEV->EV_CLIFOR==SE5->E5_CLIFOR);
									.AND. (SEV->EV_LOJA==SE5->E5_LOJA)
									
									//VERIFICA se existe rateio de centro de custo por natureza
									IF SEV->EV_RATEICC = '2' //(2 = SEM RATEIO POR CC)
										
										cCusto		:= ""
										cNaturez 	:= SEV->EV_NATUREZ
										cValorSEV	:= Transform((SEV->EV_VALOR),"@E 999,999,999.99")
										cValorSEZ 	:= Transform(0,"@E 999,999,999.99")
										cValorSE5 	:= Transform(SETMP->E5_VALOR,"@E 999,999,999.99")
										cData:=dtoc(stod(SETMP->E5_DATA))
										fWrite(nHandle, chr(160)+UPPER(SETMP->EMP)+";"+chr(160)+SETMP->E5_FILIAL +";"+ cData +";"+ chr(160)+SETMP->E5_CLIFOR +";"+chr(160)+SETMP->E5_NUMERO +";"+;
										SETMP->E5_TIPODOC +";"+chr(160)+SETMP->E5_LOJA +";"+ SETMP->E5_SITCOB +";"+;
										SETMP->E5_RECPAG +";"+chr(160)+SETMP->E5_CONTA +";"+ chr(160)+SETMP->E5_CCC +";"+ chr(160)+SETMP->E5_CCD +";"+ chr(160)+SETMP->E5_CLVLCR +";"+ chr(160)+SETMP->E5_CLVLDB +";"+;
										UPPER(SETMP->E5_HISTOR) +";"+ chr(160)+SETMP->E5_NATUREZ +";"+ chr(160)+cValorSE5 +";"+ chr(160)+SETMP->E5_RECONC +";"+chr(160)+SETMP->E5_AGENCIA +";")
										fWrite(nHandle, cCrLf ) // Pula linha
										
									ELSE //(1 = COM RATEIO POR CC)
										
										IF SEV->EV_IDENT ='1'
											//Valor da Baixa * Percentual de distribuição da natureza.
											
											
											cValorSEV 	:= Transform(SEV->EV_VALOR,"@E 999,999,999.99")
											
											DbSelectArea("SEZ")
											SEZ->(DbSetOrder(1))
											SEZ->(DbSeek(SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA))
											IF SEZ->(Found())
												
												While SEZ->(!EOF()) .AND. (SEZ->EZ_FILIAL==SE5->E5_FILIAL) .AND. (SEZ->EZ_PREFIXO==SE5->E5_PREFIXO) ;
													.AND. (SEZ->EZ_NUM==SE5->E5_NUMERO);
													.AND. (SEZ->EZ_PARCELA==SE5->E5_PARCELA) .AND. (SEZ->EZ_TIPO==SE5->E5_TIPO) .AND. (SEZ->EZ_CLIFOR==SE5->E5_CLIFOR);
													.AND. (SEZ->EZ_LOJA==SE5->E5_LOJA)
													
													if SEV->EV_NATUREZ == SEZ->EZ_NATUREZ
														
														cValorSEZ 	:= Transform(SEV->EV_VALOR * SEZ->EZ_PERC,"@E 999,999,999.99")
														cCusto		:=  SEZ->EZ_CCUSTO
														cNaturez	:=	SEZ->EZ_NATUREZ
														cValorSE5 	:= Transform(SETMP->E5_VALOR,"@E 999,999,999.99")
														cData:=dtoc(stod(SETMP->E5_DATA))
														fWrite(nHandle, chr(160)+UPPER(SETMP->EMP)+";"+chr(160)+SETMP->E5_FILIAL +";"+ cData +";"+ chr(160)+SETMP->E5_CLIFOR +";"+chr(160)+SETMP->E5_NUMERO +";"+;
														SETMP->E5_TIPODOC +";"+chr(160)+SETMP->E5_LOJA +";"+ SETMP->E5_SITCOB +";"+;
														SETMP->E5_RECPAG +";"+chr(160)+SETMP->E5_CONTA +";"+ chr(160)+SETMP->E5_CCC +";"+ chr(160)+SETMP->E5_CCD +";"+ chr(160)+SETMP->E5_CLVLCR +";"+ chr(160)+SETMP->E5_CLVLDB +";"+;
														UPPER(SETMP->E5_HISTOR) +";"+ chr(160)+SETMP->E5_NATUREZ +";"+ chr(160)+cValorSE5 +";"+ chr(160)+SETMP->E5_RECONC +";"+chr(160)+SETMP->E5_AGENCIA +";")
														fWrite(nHandle, cCrLf ) // Pula linha
													ENDIF
													SEZ->(dbSkip())
												EndDo
												
												
											ENDIF
										endif
										
									ENDIF
									SEV->(dbSkip())
								EndDo
							ENDIF
							
							//E2_SALDO > 0 tratamento de baixa parcial
						ELSE
							
							//Posiciona na SEV-MULTIPLAS NATUREZAS POR TÍTULO
							DbSelectArea("SEV")
							SEV->(DbSetOrder(1))
							SEV->(DbSeek(SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA))
							If SEV->(Found())
								IF SEV->EV_IDENT ='1'
									
									While SEV->(!EOF()) .AND. (SEV->EV_FILIAL==SE5->E5_FILIAL) .AND. (SEV->EV_PREFIXO==SE5->E5_PREFIXO) ;
										.AND. (SEV->EV_NUM==SE5->E5_NUMERO);
										.AND. (SEV->EV_PARCELA==SE5->E5_PARCELA) .AND. (SEV->EV_TIPO==SE5->E5_TIPO) .AND. (SEV->EV_CLIFOR==SE5->E5_CLIFOR);
										.AND. (SEV->EV_LOJA==SE5->E5_LOJA)
										
										//VERIFICA se existe rateio de centro de custo por natureza
										IF SEV->EV_RATEICC = '2' //(2 = SEM RATEIO POR CC)
											
											cCusto		:= ""
											cNaturez 	:= SEV->EV_NATUREZ
											cValorSEV	:= Transform((SEV->EV_VALOR),"@E 999,999,999.99")
											cValorSEZ 	:= Transform(0,"@E 999,999,999.99")
											cValorSE5 	:= Transform(SETMP->E5_VALOR,"@E 999,999,999.99")
											cData:=dtoc(stod(SETMP->E5_DATA))
											fWrite(nHandle, chr(160)+UPPER(SETMP->EMP)+";"+chr(160)+SETMP->E5_FILIAL +";"+ cData +";"+ chr(160)+SETMP->E5_CLIFOR +";"+chr(160)+SETMP->E5_NUMERO +";"+;
											SETMP->E5_TIPODOC +";"+chr(160)+SETMP->E5_LOJA +";"+ SETMP->E5_SITCOB +";"+;
											SETMP->E5_RECPAG +";"+chr(160)+SETMP->E5_CONTA +";"+ chr(160)+SETMP->E5_CCC +";"+ chr(160)+SETMP->E5_CCD +";"+ chr(160)+SETMP->E5_CLVLCR +";"+ chr(160)+SETMP->E5_CLVLDB +";"+;
											UPPER(SETMP->E5_HISTOR) +";"+ chr(160)+SETMP->E5_NATUREZ +";"+ chr(160)+cValorSE5 +";"+ chr(160)+SETMP->E5_RECONC +";"+chr(160)+SETMP->E5_AGENCIA +";")
											fWrite(nHandle, cCrLf ) // Pula linha
											
										ELSE //(1 = COM RATEIO POR CC)
											
											//Valor da Baixa * Percentual de distribuição da natureza.
											
											cValorSEV:= Transform((SE5->E5_VALOR * SEV->EV_PERC),"@E 999,999,999.99")
											
											DbSelectArea("SEZ")
											SEZ->(DbSetOrder(1))
											SEZ->(DbSeek(SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA))
											IF SEZ->(Found())
												if SEV->EV_NATUREZ = SEZ->EZ_NATUREZ
													While SEZ->(!EOF()) .AND. (SEZ->EZ_FILIAL==SE5->E5_FILIAL) .AND. (SEZ->EZ_PREFIXO==SE5->E5_PREFIXO) ;
														.AND. (SEZ->EZ_NUM==SE5->E5_NUMERO);
														.AND. (SEZ->EZ_PARCELA==SE5->E5_PARCELA) .AND. (SEZ->EZ_TIPO==SE5->E5_TIPO) .AND. (SEZ->EZ_CLIFOR==SE5->E5_CLIFOR);
														.AND. (SEZ->EZ_LOJA==SE5->E5_LOJA)
														
														cValorSEZ 	:= Transform(SEV->EV_VALOR * SEZ->EZ_PERC,"@E 999,999,999.99")
														
														cCusto		:=  SEZ->EZ_CCUSTO
														cNaturez	:=	SEZ->EZ_NATUREZ
														cData:=dtoc(stod(SETMP->E5_DATA))
														cValorSE5 	:= Transform(SETMP->E5_VALOR,"@E 999,999,999.99")
														fWrite(nHandle, chr(160)+UPPER(SETMP->EMP)+";"+chr(160)+SETMP->E5_FILIAL +";"+ cData +";"+ chr(160)+SETMP->E5_CLIFOR +";"+chr(160)+SETMP->E5_NUMERO +";"+;
														SETMP->E5_TIPODOC +";"+chr(160)+SETMP->E5_LOJA +";"+SETMP->E5_SITCOB +";"+;
														SETMP->E5_RECPAG +";"+chr(160)+SETMP->E5_CONTA +";"+ chr(160)+SETMP->E5_CCC +";"+ chr(160)+SETMP->E5_CCD +";"+ chr(160)+SETMP->E5_CLVLCR +";"+ chr(160)+SETMP->E5_CLVLDB +";"+;
														UPPER(SETMP->E5_HISTOR) +";"+ chr(160)+SETMP->E5_NATUREZ +";"+ chr(160)+cValorSE5 +";"+ chr(160)+SETMP->E5_RECONC +";"+chr(160)+SETMP->E5_AGENCIA +";")
														fWrite(nHandle, cCrLf ) // Pula linha
														SEZ->(dbSkip())
													EndDo
													
												ENDIF
											ENDIF
										ENDIF
										SEV->(dbSkip())
									EndDo
								ENDIF
								
							ENDIF
							
						ENDIF
						
					ELSE
						cCusto		:=  ""
						cNaturez	:=	""
						cValorSEZ:=Transform(0,"@E 999,999,999.99")
						cValorSEV:=Transform(0,"@E 999,999,999.99")
						cValorSE5 	:= Transform(SETMP->E5_VALOR,"@E 999,999,999.99")
						cData:=dtoc(stod(SETMP->E5_DATA))
						fWrite(nHandle, chr(160)+UPPER(SETMP->EMP)+";"+chr(160)+SETMP->E5_FILIAL +";"+ cData +";"+ chr(160)+SETMP->E5_CLIFOR +";"+chr(160)+SETMP->E5_NUMERO +";"+ SETMP->E5_TIPODOC +";"+chr(160)+SETMP->E5_LOJA +";"+SETMP->E5_SITCOB +";"+;
						SETMP->E5_RECPAG +";"+chr(160)+SETMP->E5_CONTA +";"+chr(160)+ SETMP->E5_CCC +";"+ chr(160)+SETMP->E5_CCD +";"+chr(160)+ SETMP->E5_CLVLCR +";"+ chr(160)+SETMP->E5_CLVLDB +";"+;
						UPPER(SETMP->E5_HISTOR) +";"+ chr(160)+SETMP->E5_NATUREZ +";"+chr(160)+cValorSE5 +";"+ chr(160)+SETMP->E5_RECONC +";"+chr(160)+SETMP->E5_AGENCIA +";")
						fWrite(nHandle, cCrLf ) // Pula linha
					ENDIF//E2_MULTNAT VAZIO
					
				ENDIF
				
				
				//ENDIF//E5_MULTNAT VAZIO
				
			ENDIF
		Endif
		
		
		
		SETMP->(DbSkip())
	EndDo
	
	SETMP->(DbCloseArea())
	
	fClose(nHandle)
	
	//envia email para o responsavel
	ENVMAIL(cCaminho+".CSV")
	
Else
	ConOut( Time()+" - Falha na criação do arquivo" )
Endif

RestArea(aArea)

Return



/*
+----------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                      !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Descricao         ! Função para enviar o e-mail para o responsavel          !
+------------------+---------------------------------------------------------+
!Autor             ! Jair Matos de Andrade                                   !
+------------------+---------------------------------------------------------+
*/
Static Function ENVMAIL(cCaminho)

Local nInd, cBody
Local lResult        := .f.    // Resultado da tentativa de comunicacao com servidor de E-Mail
Local cDestin           := GetMV("MV_XMAILFI")
Local cTitulo           := "RELATÓRIO DE MOVIMENTAÇÕES BANCÁRIAS DIÁRIAS"
Local cMensagem         := "Relatório de movimentações bancárias diárias gerado automaticamente!"
Local cFrom        		:= 'workflowtst@cantutecnologia.com.br'//GetMV("MV_WFADMIN")
Local lAutentica    := GetMV("MV_RELAUTH")
Local aFiles := {cCaminho}


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tenta conexao com o servidor de E-Mail ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CONNECT SMTP                         ;
SERVER       GetMV("MV_RELSERV");      // Nome do servidor de e-mail
ACCOUNT GetMV("MV_RELACNT");      // Nome da conta a ser usada no e-mail
PASSWORD GetMV("MV_RELPSW") ;      // Senha
RESULT   lResult                  // Resultado da tentativa de conexão

If lResult
	// Verifica se o E-mail necessita de Autenticacao
	If lAutentica
		lRet := MailAuth(GetMV("MV_RELACNT"),GetMV("MV_RELPSW"))
	Else
		lRet := .T.
	Endif
	
	If lRet
		
		SEND MAIL;
		FROM        cFrom;
		TO            cDestin;
		SUBJECT   cTitulo;
		BODY    cMensagem;
		ATTACHMENT aFiles[1];
		RESULT      lResult
		
		If !lResult
			//Erro no envio do email
			GET MAIL ERROR cError
			Help(" ",1,"ATENCAO",,cError+ " " + cEmailTo,4,5)     //STR0006
		Endif
	Else
		GET MAIL ERROR cError
		Help(" ",1,"Autenticacao",,cError,4,5)
		MsgStop("Erro de autenticação","Verifique a conta e a senha para envio")
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza conexao com o servidor de E-Mail ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DISCONNECT SMTP SERVER
Else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	Help(" ",1,"Atencao",,cError,4,5)
Endif
Return
