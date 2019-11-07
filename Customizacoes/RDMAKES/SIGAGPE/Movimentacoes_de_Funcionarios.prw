#INCLUDE "FiveWin.ch"
//#INCLUDE "GPER500.CH"
#INCLUDE "Report.ch"
#IFDEF TOP
	#INCLUDE "TOPCONN.CH"
#ENDIF

/*

ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GPER500  ³ Autor  ³ R.H.                     ³ Data ³ 30.10.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de Movimentacoes de Funcionarios  (TURN-OVER)          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GPER500(void)                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS     ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Natie       ³22/11/05³0088267   ³ Nova estrutura do relatorio              ³±±
±±³Natie       ³06/03/06³0093233   ³ Ajuste na contagem inicial               ³±±
±±³Natie       ³06/03/06³0093864   ³ Duplicava trasnferencias entre filiais   ³±±
±±³            ³        ³          ³ qdo se pedia todas as filiais            ³±±
±±³Natie       ³28/04/06³0096708   ³ Ajuste na impr.da descricao do CC e conta³±±
±±³            ³        ³          ³ gem do func. admitido e transferido no   ³±±
±±³            ³        ³          ³ mes da admissao no CC de origem          ³±±
±±³Andreia	   ³28/08/06³0100152   ³ Conversao em Relatorio personalizavel pa-³±±
±±³        	   ³        ³          ³ ra atender ao Release 4.                 ³±±
±±³Natie       ³08/11/06³0107245   ³ Transf.entre empresas.Estava trazendo o  ³±±
±±³            ³        ³          ³ mvto de entrada na empresa de origem onde³±±
±±³            ³        ³          ³ deveria aparecer somente na empr. destino³±±
±±³Natie       ³08/02/07³0117652   ³ Ajuste de impressao das colunas          ³±±
±±³Renata      ³16/07/07³0127903   ³ Ajuste em fR500ACum para emissao c.custo ³±±
±±³            ³        ³          ³ origem qdo nao existe este c.custo no SRA³±±
±±³Marcelo     ³18/03/09³0006146   ³ Ajustes em PrintReport, GR500Imp e       ³±±
±±³            ³        ³   2009   ³ fR500Impr p/ quebrar por CC corretamente.³±±
±±³Andreia	   ³07/10/09³0022961/09³ Ajuste para trazer as informacoes de en- ³±±
±±³        	   ³        ³          ³ trada por transferencia e admissao.      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function GPER500() 

Local	oReport   
Local	aArea	:= GetArea()

Private aEmpresa	:= {} 			//-- Array com  as filiais da Empresa 
Private cPerg	:= "GPR500CUS" 
Private cTitulo	:= OemToAnsi("Detalle de movimiento de empleados (Turn-Over)  ")
Private	cAliasSRA:= "SRA"
Private lRelNew	:= .F.  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

GPER500R3()


RestArea( aArea )

Return    


// a partir daqui RELEASE 3
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GPER500R3 ºAutor  ³Microsiga           º Data ³  08/25/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GPER500R3()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cString:= "SRA"        // Alias do arquivo principal (Base)
Local aOrd   := {"C.Custo","Segmento"}
Local cDesc1 := "Detalle de movimiento de empleados (Turn-Over)  "  //"Rela‡„o de Movimenta‡”es Funcionarios (Turn-Over)"
Local cDesc2 := "Se imprimira de acuerdo con los parametros solicitados por"  //"Sera impresso de acordo com os parametros solicitados pelo"
Local cDesc3 := "Utilizador."  //"usuario."

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aReturn  := { "Código de barras", 1,"Administração", 2, 2, 1, "",1 }  //"Zebrado"###"Administra‡„o"
Private nomeprog := "GPER500"
Private nLastKey := 0
Private cPerg    := "GPR500CUS" 
Private	cAliasSRA:= "SRA"
Private nTamCC	 := TamSx3("RA_CC")[1] 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aInfo   := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Utilizadas na funcao IMPR                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private Titulo
Private Colunas  := 132
Private AT_PRG   := "GPER500"
Private wCabec0  := 1
Private wCabec1  := Substr("|mês/ano |  início  | admissão | ent.transf.| sai.transf.| demissão |   fim   |",1,1) + Space(nTamCC)  + Space(30) + "|mês/ano |  início  | admissão | ent.transf.| sai.transf.| demissão |   fim   |"   			//--"| MES/ANO |  INICIO  | ADMISSAO | ENT.TRANSF.| SAI.TRANSF.| DEMISSAO |   FIM   |"
Private wCabec2  := ""
Private Contfl   := 1
Private Li       := 0
Private nTamanho := "M"
Private nDescCC	 := nTamCC+ 30
Private aLog		:= {}			//-- Log de controle interno- indica a localizacao inicial do func. - Filial/ CC / Mat 
Private aLogTitle 	:= {}
Private nCont		:= 0 

ValidPerg()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        //  Filial  De                               ³
//³ mv_par02        //  Filial  Ate                              ³
//³ mv_par03        //  Centro de Custo De                       ³
//³ mv_par04        //  Centro de Custo Ate                      ³
//³ mv_par05        //  Inicio do Mes/Ano Pesquisa               ³
//³ mv_par06        //  Final  do Mes/Ano Pesquisa               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Titulo := "RELAÇÃO DE MOVIMENTAÇÕES DE EMPREGADOS"  //"RELA€O DE MOVIMENTA€™ES FUNCIONARIOS"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="GPER500"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho)
nOrdem    := aReturn[8]
If nLastKey = 27 
	Return 
Endif 
SetDefault(aReturn,cString)
If nLastKey = 27
	Return
Endif

RptStatus({|lEnd| GR500Imp(@lEnd,wnRel,cString)},Titulo) 

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GPER500  ³ Autor ³ R.H.                  ³ Data ³ 30.10.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao dos Salarios de Contribuicao                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ GR500Imp(lEnd,wnRel,cString)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd        - A‡Æo do Codelock                             ³±±
±±³          ³ wnRel       - T¡tulo do relat¢rio                          ³±±
±±³Parametros³ cString     - Mensagem                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GR500Imp(lEnd,wnRel,cString)

Local cAcessaSRA  	:= &("{ || " + ChkRH("GPER500","SRA","2") + "}")
Local aJaContou		:= {}											//-- Armazena funcionario que ja foi contado : "01"-Transferencia / "02"-Admissao
Local nReg          := 0
Local M				:= 0 

//-- Variaveis de controle 
Local nX 		:= 0 
Local nAnoMes	:= 0 
Local nTransf	:= 0 
Local lAdmitiu	:= .F. 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Privates (Programa)                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aTurnOver  	:= {}
Private aTurnOveF  	:= {}
Private lImpressao 	:= .F. 
Private lContou		:= .F. 
Private lTransfAll	:= .F. 			//-- Carregou aTransfAll  
Private aAnoMes		:= {} 
Private aEmpresa	:= {} 			//-- Array com  as filiais da Empresa 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carregando variaveis mv_par?? para Variaveis do Sistema.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cFilDe    := mv_par01
cFilAte   := mv_par02
cCcDe     := mv_par03
cCcAte    := mv_par04
cMesAnoI  := mv_par05
cMesAnoF  := mv_par06
cSegDe	  := mv_par07
cSegAte	  := mv_par08

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona as filiais que serao processadas 								³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
fAdEmpresa(2, @aEmpresa)
If Len(aEmpresa) == 0
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Incrementa o Array aTurnOver/aAnoMes Com o Intervalo de Datas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
fR500Add("1")

dbSelectArea( "SRE" )
dbSetOrder( 1 )

dbSelectArea( "SRA" )
If nOrdem <> 2
	dbSetOrder( 2 )
	SRA->( dbgotop() )					//-- Tenho que varrer todo o SRA independente da Filial e CC escolhido no parametro. 
	cInicio := "SRA->RA_FILIAL + SRA->RA_CC"
	cFim    := cFilAte + cCcAte
Else
	dbOrderNickName("CLVLCUS   ")
	SRA->( dbgotop() )				 
	cInicio := "SRA->RA_FILIAL + SRA->RA_X_SEGME"
	cFim    := cFilAte + cSegAte
Endif

cFilialAnt 	:= Replicate("!", FWGETTAMFILIAL)
cCcAnt     := Space(nTamCC)
SetRegua(SRA->(RecCount())) 

While !SRA->( Eof() ) .And. SRA->(&cInicio) <= SRA->( cFim )

	IncRegua() 
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Aborta Impressao ao se clicar em cancela					 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SRA->RA_X_SEGME < cSegDe .OR. SRA->RA_X_SEGME > cSegAte
		dbSkip()
		Loop
	Endif
	If lEnd 
		@Prow()+1,0 PSAY cCancel 
		Exit
	EndIF
	
	If SRA->RA_FILIAL # cFilialAnt 
		If !fInfo(@aInfo,SRA->RA_FILIAL)
			Exit
		Endif
		
		cFilialAnt 	:= SRA->RA_FILIAL
	Endif
	                
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³                                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !empty(SRA->RA_DEMISSA ) .and. MesAno(SRA->RA_DEMISSA) <  SubStr(cMesAnoI,3,4) + SubStr(cMesAnoI,1,2) 
		dbSkip()
		Loop
	Endif 
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste controle de acessos e filiais validas               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !(SRA->RA_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRA)
		dbSkip()
		Loop
	EndIf 
	If nOrdem <> 2
		cCcAnt 		:= SRA->RA_CC
	Else
		cCcAnt 		:= SRA->RA_X_SEGME
	Endif
	nReg 		:= SRA->( Recno() ) 
	aTransfAll 	:= {}
	lContou		:= .F. 
	lTransfAll	:= .F. 
	For nAnoMes:= 1 to Len( aAnoMes )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Apurar quantidade inicial do C.Custo                                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nAnoMes = 1 											//-- Somente preciso apurar onde o funcionario estava no primeiro periodo
			If  MesAno(SRA->RA_ADMISSA) <  aAnoMes[1] .And. ( Empty(SRA->RA_DEMISSA) .or. ; 
		        (MesAno(SRA->RA_DEMISSA) >= aAnoMes[1] ) ) 

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Carrega o array aTransfAll - TODAS as transferencias do funcionario     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea( "SRE" )
				fTransfAll( @aTransfAll,,,.T.) 			
		
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Se nao houve transferencias, entao deve-se contar o func. de acordo com  a    |
				//³ Emp/Filial/CC atual                                                           |				
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If Len(aTransfAll) <= 0
					If fR500Acum( (cFilialAnt +Alltrim( cCcAnt) + aAnoMes[1] + cEmpAnt ) , cFilialAnt, cCcAnt, 4) 
						ncont ++ 
						aAdd( aLog , cFilialAnt +SPACE(1)+ cCcAnt+SPACE(1) + SRA->RA_MAT+SPACE(1)+ strzero(ncont,4) +SPACE(1)+ " +"  )
					Endif		
				Else 
					For nX := 1 to Len(aTransfAll)
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Se houve transferencias, deve-se verificar onde o func. estava no inicio do   |
  						//³ periodo desejado                                                              |
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If nOrdem <> 2
							If aTransfAll[nX,12] < aAnoMes[1] 
								If  ( nX = 1 .and. nX = Len(aTransfAll) ) .or.  ( nX = Len(aTransfAll)) 
									If fR500Acum( (aTransfAll[nX,10]+ Alltrim(aTransfAll[nX,06]) + aAnoMes[1] + aTransfAll[nx,04] ) , aTransfAll[nX,10], aTransfAll[nX,06], 4 , aTransfAll[nx,04]) 
										ncont ++ 
										aAdd( aLog , aTransfAll[nX,10]+SPACE(1)+aTransfAll[nX,06]+SPACE(1)+sra->ra_mat+SPACE(1)+strzero(ncont,4)+SPACE(1)+" +" )
									Endif	
								Endif
							Else
							    //-- Tenho q garantir que nao vou contar  o funcionario Mais de uma vez quando estiver processando mais de uma filial. 
								If  (nX = 1 .or. !lContou)   .and. aTransfAll[nX,8] ==  SRA->RA_FILIAL 
									If fR500Acum( (aTransfAll[nX,08] + Alltrim(aTransfAll[nX,03] )+ aAnoMes[1] + aTransfAll[nx,01] ) , aTransfAll[nX,8], aTransfAll[nX,03], 4 ,aTransfAll[nx,01]) 
										ncont ++
										aAdd( aLog , aTransfAll[nX,08]+SPACE(1)+aTransfAll[nX,03]+SPACE(1)+sra->ra_mat +SPACE(1)+strzero(ncont,4)+SPACE(1)+ " +"  ) 
									Endif
								Endif 
							Endif					
						Else
							If aTransfAll[nX,12] < aAnoMes[1] 
								If  ( nX = 1 .and. nX = Len(aTransfAll) ) .or.  ( nX = Len(aTransfAll)) 
									If fR500Acum( (aTransfAll[nX,10]+ Alltrim(SRA->RA_X_SEGME) + aAnoMes[1] + aTransfAll[nx,04] ) , aTransfAll[nX,10], SRA->RA_X_SEGME, 4 , aTransfAll[nx,04]) 
										ncont ++ 
										aAdd( aLog , aTransfAll[nX,10]+SPACE(1)+aTransfAll[nX,06]+SPACE(1)+sra->ra_mat+SPACE(1)+strzero(ncont,4)+SPACE(1)+" +" )
									Endif	
								Endif
							Else
							    //-- Tenho q garantir que nao vou contar  o funcionario Mais de uma vez quando estiver processando mais de uma filial. 
								If  (nX = 1 .or. !lContou)   .and. aTransfAll[nX,8] ==  SRA->RA_FILIAL 
									If fR500Acum( (aTransfAll[nX,08] + Alltrim(SRA->RA_X_SEGME )+ aAnoMes[1] + aTransfAll[nx,01] ) , aTransfAll[nX,8], SRA->RA_X_SEGME, 4 ,aTransfAll[nx,01]) 
										ncont ++
										aAdd( aLog , aTransfAll[nX,08]+SPACE(1)+aTransfAll[nX,03]+SPACE(1)+sra->ra_mat +SPACE(1)+strzero(ncont,4)+SPACE(1)+ " +"  ) 
									Endif
								Endif 
							Endif					
						Endif
					Next nX 
				Endif	
				lTransfAll	:= .T. 
			Endif
 		Endif 
		DbSelectArea("SRA")
		dbSetOrder(2) 
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se não existe nenhum funcionario no inicio do CC                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !lTransfAll
			dbSelectArea( "SRE" )
			aTransfAll := {}
			fTransfAll( @aTransfAll,,,.T.) 
			lTransfAll	:= .T. 
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Apurar a movimentaçao do funcionario dentro do periodo                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If  Len(aTransfAll) > 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Movtimentacao de transferencias                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
			lAdmitiu	:= .F.
			For nTransf := 1 to Len(aTransfAll) 
				If aAnoMes[nAnoMes] == aTransfAll[nTransf,12]  .and. ; 
					(nPos:= ascan(aJaContou, {|X| X[1] == "01"+aTransfAll[nTransf,1]+aTransfAll[nTransf,2]+aTransfAll[nTransf,3]+ dtos(aTransfAll[nTransf,7])  } ) )<= 0  //-- Empresa De+ Filial De + Matricula De + data 
				
					If nOrdem <> 2
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Apurar Saidas por Transferencia               ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						fR500Acum( (aTransfAll[nTransf,08] + Alltrim(aTransfAll[nTransf,03] ) + aAnoMes[nAnoMes] + aTransfAll[nTransf,01]) , aTransfAll[nTransf,08] , aTransfAll[nTransf,03], 7, aTransfAll[nTransf,01]) 
	
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Apurar Entradas por Transferencia             ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						fR500Acum( (aTransfAll[nTransf,10] + Alltrim( aTransfAll[nTransf,06])  + aAnoMes[nAnoMes]+ aTransfAll[nTransf,04] ) , aTransfAll[nTransf,10] , aTransfAll[nTransf,06], 6 , aTransfAll[nTransf,04]) 
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Como ja computou entrada e saida, nao devo con³
						//³ tar novamente qdo estiver processando mais de ³
						//³ uma  filial                                   ³	
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
						aadd(aJaContou, {"01"+aTransfAll[nTransf,1]+aTransfAll[nTransf,2]+aTransfAll[nTransf,3]+ dtos(aTransfAll[nTransf,7])} )  
					Else
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Apurar Saidas por Transferencia               ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						fR500Acum( (aTransfAll[nTransf,08] + Alltrim(SRA->RA_X_SEGME ) + aAnoMes[nAnoMes] + aTransfAll[nTransf,01]) , aTransfAll[nTransf,08] , SRA->RA_X_SEGME, 7, aTransfAll[nTransf,01]) 
	
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Apurar Entradas por Transferencia             ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						fR500Acum( (aTransfAll[nTransf,10] + Alltrim( SRA->RA_X_SEGME)  + aAnoMes[nAnoMes]+ aTransfAll[nTransf,04] ) , aTransfAll[nTransf,10] , SRA->RA_X_SEGME, 6 , aTransfAll[nTransf,04]) 
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Como ja computou entrada e saida, nao devo con³
						//³ tar novamente qdo estiver processando mais de ³
						//³ uma  filial                                   ³	
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
						aadd(aJaContou, {"01"+aTransfAll[nTransf,1]+aTransfAll[nTransf,2]+aTransfAll[nTransf,3]+ dtos(aTransfAll[nTransf,7])} )  					
					Endif

				Endif 
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Apurar Admissao qdo tem transferencias        ³
				//³ Casos onde ha transf. no mesmo mes da admissao³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ( MesAno(SRA->RA_ADMISSA) == aAnoMes[nAnoMes] ) .and. !(lAdmitiu) .and. ;
					(nPos:= ascan(aJaContou, {|X| X[1] == "02"+aTransfAll[nTransf,1]+aTransfAll[nTransf,2]+aTransfAll[nTransf,3]+ dtos(aTransfAll[nTransf,7])  } ) )<= 0  //-- Empresa De+ Filial De + Matricula De 
					If nOrdem<> 2
						If fR500Acum( (aTransfAll[nTransf,08] + Alltrim(aTransfAll[nTransf,03]) + aAnoMes[nAnoMes] + aTransfAll[nTransf,01] ) , aTransfAll[nTransf,08] , aTransfAll[nTransf,03], 5 , aTransfAll[nTransf,01]) 
							aadd(aJaContou, {"02"+aTransfAll[nTransf,1]+aTransfAll[nTransf,2]+aTransfAll[nTransf,3]+ dtos(aTransfAll[nTransf,7] )} ) 
							lAdmitiu	:= .T. 	
						Endif	
					Else
						If fR500Acum( (aTransfAll[nTransf,08] + Alltrim(SRA->RA_X_SEGME) + aAnoMes[nAnoMes] + aTransfAll[nTransf,01] ) , aTransfAll[nTransf,08] , SRA->RA_X_SEGME, 5 , aTransfAll[nTransf,01]) 
							aadd(aJaContou, {"02"+aTransfAll[nTransf,1]+aTransfAll[nTransf,2]+SRA->RA_X_SEGME+ dtos(aTransfAll[nTransf,7] )} ) 
							lAdmitiu	:= .T. 	
						Endif						
					Endif
				Endif
			Next nTransf
		Else 
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Admissoes do periodo                                                    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If MesAno(SRA->RA_ADMISSA) = aAnoMes[nAnoMes]
				If nOrdem <> 2
					fR500Acum( (cFilialAnt + Alltrim( SRA->RA_CC ) + aAnoMes[nAnoMes] + cEmpAnt) , cFilialAnt , SRA->RA_CC, 5 ) 
				Else
					fR500Acum( (cFilialAnt + Alltrim( SRA->RA_X_SEGME ) + aAnoMes[nAnoMes] + cEmpAnt) , cFilialAnt , SRA->RA_X_SEGME, 5 ) 				
				Endif
			Endif
		Endif		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Demissoes do periodo                                                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If MesAno(SRA->RA_DEMISSA) = aAnoMes[nAnoMes] .and. !(SRA->RA_AFASFGT $ "5*N") 
			If nOrdem <> 2
				fR500Acum( (cFilialAnt + Alltrim(SRA->RA_CC) + aAnoMes[nAnoMes]+ cEmpAnt ) , cFilialAnt , SRA->RA_CC, 8  ) 
			Else
				fR500Acum( (cFilialAnt + Alltrim(SRA->RA_X_SEGME) + aAnoMes[nAnoMes]+ cEmpAnt ) , cFilialAnt , SRA->RA_X_SEGME, 8  ) 			
			Endif
		Endif 
	Next nAnoMes 
	DbSelectArea("SRA")
	dbSetOrder(2) 
	SRA->( DBSKIP() )
Enddo
    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Relatorio                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lImpressao 
	fR500Impr( aTurnOver ) 
Endif	

//aAdd( aLogTitle , "R500" )	//"Arquivo Registro   Chave/Conteudo" 

//fMakeLog({aLog},aLogTitle,"GPER500")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Termino do relatorio                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SRA" )
Set Filter to
dbSetOrder(1)
dbSelectArea( "SRE" )
RetIndex( "SRE" )
dbSetOrder(1)

Set Device To Screen
If aReturn[5] = 1 
	Set Printer To 
	Commit 
	ourspool(wnrel) 
Endif 
MS_FLUSH() 

*---------------------------*
Static Function fImpFil()
*---------------------------*
Local cFilDesc   := Space(FWGETTAMFILIAL)
Local lRet       := .F.
Local nX
Local nV
Local nW
Local nY

	If (Li + Len(aAnoMes)+ 1 )   >= 58 
		Impr(' ','P')
	Endif

	Det :=  "+" + Repl("-",nDescCC )  + "+" + Repl("-",9) + "+" + Repl("-",10) + "+" + Repl("-",10) + "+" + Repl("-",12) + "+" + Repl("-",12) + "+" + Repl("-",10) + "+" + Repl("-",9) + "+"	
	
	Impr(Det,'C')
	For Nw = 1 To Len( aTurnOveF )

		If !fInfo(@aInfo,aTurnOveF[Nw,01])
			Exit
		Endif

		If Nw == 1
			Det := "| " + "Filial:" + aTurnOveF[Nw,1] + " - " + PadR(aInfo[1],15) + Space(nDescCC)  //"FILIAL: "
			Det := substr(Det,1,nDescCC) + " | "
		Else
			Det := "|" + Space(nDescCC ) + "| "
		Endif
		If nTData == 8
			Det += SubStr(aTurnOveF[Nw,3],5,2) + " / " + SubStr(aTurnOveF[Nw,3],3,2) + " |   "
		Else
			Det += SubStr(aTurnOveF[Nw,3],5,2) + "/" + SubStr(aTurnOveF[Nw,3],1,4) + " |   "
		Endif
		Det += TransForm(aTurnOveF[Nw,4] , "@E 999999") + " |   "
		Det += TransForm(aTurnOveF[Nw,5] , "@E 999999") + " |     "
		Det += TransForm(aTurnOveF[Nw,6] , "@E 999999") + " |     "
		Det += TransForm(aTurnOveF[Nw,7] , "@E 999999") + " |   "
		Det += TransForm(aTurnOveF[Nw,8] , "@E 999999") + " |  "
		Det += TransForm( ( aTurnOveF[Nw,4] + aTurnOveF[Nw,5] + aTurnOveF[Nw,6] ) - ( aTurnOveF[Nw,7] + aTurnOveF[Nw,8] ) , "@E 999999") + " |"
		Impr(Det,'C')
	Next nW 
	
	Det :=  "+" + Repl("-",nDescCC )  + "+" + Repl("-",9) + "+" + Repl("-",10) + "+" + Repl("-",10) + "+" + Repl("-",12) + "+" + Repl("-",12) + "+" + Repl("-",10) + "+" + Repl("-",9) + "+"
	Impr(Det,'C')	

	If eof()  .or. &cInicio > cFim
		Impr('','F')
	Else
		Impr('','P')						//Quebra de pagina para cada Filial 
	Endif	
	aTurnOveF	:= {}
	
Return Nil

*---------------------------*
Static Function fR500Impr( aTurnOver ) 
*---------------------------*
Local nX 		:= 0 
Local nY		:= 0 
Local nInicio	:= 0 
Local Det		:= ""
Local cCCAtu	:= ""
Local cFilialAtu:= "" 
Local _aTurnAux	:= {} 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Relatorio                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aTurnOver)> 0 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra impressao somente das movimentacoes da empresa corrente ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aEval( aTurnOver , { |x,y| IF(aTurnOver[Y,10] = cEmpAnt , aAdd( _aTurnAux , aClone( aTurnOver[y] ) ) , NIL ) } ) 

	aTurnOver:= aClone(_aTurnAux)

	aSort( ATurnOver,,, {|x,y|  x[10]+x[1]+x[2]+x[3] < y[10]+y[1]+y[2]+y[3] } ) 

	cFilialAtu := aTurnOver[1,1] 
Endif	

For Nx = 1 To Len( aTurnOver )

	If aTurnOver[Nx,1] # cFilialAtu 
		fSumFilial( cFilialAtu )
		fImpFil() 
		cFilialAtu 	:= aTurnOver[Nx,1]
		cCCAtu		:= ""
		aTurnOveF	:= {}
	Endif 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se Filial /CC pertencem  a empresa atual                 		³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If  !( aTurnOver[Nx,2] == cCCAtu )
		If (Li + Len(aAnoMes) + 1 )  >= 58 
			Impr(' ','P')
		Endif

		Det :=  "+" + Repl("-",nDescCC )  + "+" + Repl("-",9) + "+" + Repl("-",10) + "+" + Repl("-",10) + "+" + Repl("-",12) + "+" + Repl("-",12) + "+" + Repl("-",10) + "+" + Repl("-",9) + "+"	
		Impr(Det,'C')
		If nOrdem <> 2
			Det := "| " + aTurnOver[Nx,1] + "-"+ ALLTRIM(aTurnOver[Nx,2]) + " - " +  substr((  DescCc(aTurnOver[Nx,2],aTurnOver[Nx,1])+ Space(25)),1,25 ) + space( nDescCC )
		Else
			_aArea:= GetArea()
			DbSelectArea("CTH")
			DbSetOrder(1)
			If DbSeek(xFilial("CTH")+aTurnOver[Nx,2])
				Det := "| " + aTurnOver[Nx,1] + "-"+ ALLTRIM(aTurnOver[Nx,2]) + " - " +  substr(  CTH->CTH_DESC01+ Space(25),1,25 ) + space( nDescCC )
			Else
				Det := "| " + aTurnOver[Nx,1] + "-"+ ALLTRIM(aTurnOver[Nx,2]) + " - " +  substr(  "Não Cadastrado."+ Space(25),1,25 ) + space( nDescCC )
			Endif
			RestArea(_aArea)
		Endif
		Det	:= Substr( Det ,1,nDescCC )   + " | "
		nInicio := aTurnOver[Nx,4]
	Else
		Det	:= "|" + Space(nDescCC) + "| " 
	Endif     
	If nTData == 8
		Det += SubStr(aTurnOver[Nx,3],5,2) + " / " + SubStr(aTurnOver[Nx,3],3,2) + " |   "
	Else
		Det += SubStr(aTurnOver[Nx,3],5,2) + "/" + SubStr(aTurnOver[Nx,3],1,4) + " |   "
	Endif
	
	aTurnOver[Nx,4] := nInicio 
	Det += TransForm(aTurnOver[Nx,4] , "@E 999999") + " |   "
	Det += TransForm(aTurnOver[Nx,5] , "@E 999999") + " |     "
	Det += TransForm(aTurnOver[Nx,6] , "@E 999999") + " |     "
	Det += TransForm(aTurnOver[Nx,7] , "@E 999999") + " |   "
	Det += TransForm(aTurnOver[Nx,8] , "@E 999999") + " |  "
	Det += TransForm( ( aTurnOver[Nx,4] + aTurnOver[Nx,5] + aTurnOver[Nx,6] ) - ( aTurnOver[Nx,7] + aTurnOver[Nx,8] ) , "@E 999999") + " |" 
	Impr(Det,'C')
	nInicio := ( aTurnOver[Nx,4] + aTurnOver[Nx,5] + aTurnOver[Nx,6] ) - ( aTurnOver[Nx,7] + aTurnOver[Nx,8] )
	cCCAtu	:= aTurnOver[Nx,2]

Next Nx

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da ultima filial                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
fSumFilial( cFilialAtu )
fImpFil() 
        
Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GPER500   ºAutor  ³Microsiga           º Data ³  11/25/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fR500Add(cTipo, cFilAtu , cCC, cEmpresa)

Local cAnoMesI  := SubStr(cMesAnoI,3,4) + SubStr(cMesAnoI,1,2)
Local cAnoMesF  := SubStr(cMesAnoF,3,4) + SubStr(cMesAnoF,1,2)
Local nMes 		:= 0 
Local nAno		:= 0 

DEFAULT  	cFilAtu	:= SRA->RA_FILIAL
If nOrdem <> 2
	DEFAULT 	cCC		:= SRA->RA_CC
Else
	DEFAULT 	cCC		:= SRA->RA_X_SEGME
Endif
DEFAULT		cEmpresa:= cEmpant

While Val( cAnoMesI ) <= Val( cAnoMesF ) 
	If cTipo ="1"
		Aadd(aAnoMes    , cAnoMesI )
	ElseIf cTipo = "2"
		Aadd(aTurnOver  ,{cFilAtu, cCC , cAnoMesI , 0 , 0 , 0 , 0 , 0 , 0 , cEmpresa } )
	Else
		Aadd(aTurnOveF  ,{cFilAtu, ""  , cAnoMesI , 0 , 0 , 0 , 0 , 0 , 0 , cEmpresa } )
	Endif	
	nMes := Val(Subs(cAnoMesI,5,2)) + 1
	nAno := Val(Subs(cAnoMesI,1,4))
	If nMes > 12
		cAnoMesI := StrZero(nAno + 1,4) + "01"
	Else
		cAnoMesI := StrZero(nAno,4) + StrZero(nMes,2)
	Endif
EndDo

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GPER500   ºAutor  ³Microsiga           º Data ³  11/28/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static function fSumFilial(cFilAtu)

Local nX		:= 0                  
Local nPos		:= 0 
Local aTurnAux	:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Incrementa o Array aTurnOver/aAnoMes Com o Intervalo de Datas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
fR500Add("3",cFilAtu)

aEval( aTurnOver , { |x,y| IF(aTurnOver[Y,1] == cFilAtu, aAdd( aTurnAux , aClone( aTurnOver[y] ) ) , NIL ) } )

For Nx:= 1  to Len(aTurnAux)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona no CEI/CNPJ (Centro de Custo ) que esta sendo processado		³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( nPos := ascan(aTurnOvef, {|z| z[3] == aTurnAux[nX,3]  } )    ) > 0 			//-- Ano/Mes 
		aTurnOveF[nPos,4]	+=  aTurnAux[nX,4]
		aTurnOveF[nPos,5]	+=  aTurnAux[nX,5]
		aTurnOveF[nPos,6]	+=  aTurnAux[nX,6]
		aTurnOveF[nPos,7]	+=  aTurnAux[nX,7]
		aTurnOveF[nPos,8]	+=  aTurnAux[nX,8]	
	Endif 
Next nX 

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GPER500   ºAutor  ³Microsiga           º Data ³  12/02/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fR500ACum(cChave, cFilialAtu,cCcusto, nTipo , cEmpresa)
Local nPos 		:= 0 
Local nEmpAtu	:= 0 

/*
nTipo 04= Qtde Inicial 
      05= Admissao 
      06= Entrada p/transferencias
      07= Saida p/transferencias
      08= Demissoes 
*/

If fChkParam(cFilialAtu, cCcusto )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se Filial /CC pertencem  a empresa atual                 		³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( nEmpAtu  := (Ascan( aEmpresa, { |x| alltrim(x[2]+ X[3]) == Alltrim(cFilialAtu+cCcusto)  } ) > 0) .OR. ;
			        ((nTipo == 7 .OR. nTipo == 4 .OR. nTipo == 5.OR. nTipo == 6) .and. Ascan( aEmpresa, { |x| alltrim(x[2]) == Alltrim(cFilialAtu)  } ) > 0 ))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Incrementa o Array aTurnOver/aAnoMes Com o Intervalo de Datas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
		If ( nPos 	:= Ascan( aTurnOver, {|x| x[1]+ x[2]+ x[3]+ x[10] == cChave   } )   ) > 0  	//-- C.C. + Periodo + Empresa 
			aTurnOver[nPos,01]		:= cFilialAtu
			aTurnOver[nPos,02]		:= alltrim(cCcusto )
			aTurnOver[nPos,nTipo]	+= 1  
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Incrementa o Array aTurnOver/aAnoMes Com o Intervalo de Datas³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			fR500Add("2", cFilialAtu, alltrim(cCcusto ), cEmpresa )
			If ( nPos 	:= Ascan( aTurnOver, {|x| x[1]+ x[2]+ x[3]+ x[10] == cChave } )   ) > 0  	//-- C.C. + Periodo  
				aTurnOver[nPos,01]		:= cFilialAtu
				aTurnOver[nPos,02]		:= Alltrim(cCcusto )
				aTurnOver[nPos,nTipo]	+= 1
			Endif 
		Endif 
		lImpressao	:= .T. 
	Endif 	
Endif
lContou 	:= .T.                                                   

Return( lContou )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GPER500   ºAutor  ³Microsiga           º Data ³  12/02/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fChkParam(cFilAtu, cCcAtu )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Garanto a impressao somente das filiais e C.C. indicadas     ³
//³ nos parametros                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Return ( cFilAtu $ fValidFil() .and.  cFilAtu >= cFilDe .and. cFilAtu <= cFilAte .and. Alltrim(cCcAtu) >= Alltrim(cCcDe)  .and. alltrim(cCcAtu) <=alltrim( cCcAte ) )


Static Function ValidPerg()
Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")//Perguntas (filtros) no relatorio
dbSetOrder(1)    

cPerg := PADR(cPerg,10)
// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DEFSP1/DFENG1/Cnt01/Var02/Def02/DEFSP1/DFENG1/Cnt02/Var03/Def03/DEFSP1/DFENG1/Cnt03/Var04/Def04/DEFSP1/DFENG1/Cnt04/Var05/Def05/DEFSP1/DFENG1/Cnt05
aAdd(aRegs,{cPerg,"01","Filial De              ?","","","mv_ch1","C",02,0,0,"G","        ","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Filial Ate             ?","","","mv_ch2","C",02,0,0,"G","naovazio","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})      
aAdd(aRegs,{cPerg,"03","Centro de Custo De     ?","","","mv_ch3","C",09,0,0,"G","        ","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
aAdd(aRegs,{cPerg,"04","Centro de Custo Ate    ?","","","mv_ch4","C",09,0,0,"G","naovazio","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
aAdd(aRegs,{cPerg,"05","Mes e Ano Inicial      ?","","","mv_ch5","C",06,0,0,"G","        ","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Mes e Ano Inicial      ?","","","mv_ch6","C",06,0,0,"G","naovazio","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Segmento De            ?","","","mv_ch7","C",09,0,0,"G","        ","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
aAdd(aRegs,{cPerg,"08","Segmento Ate           ?","","","mv_ch8","C",09,0,0,"G","naovazio","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})

For i:=1 to Len(aRegs)
    If !dbSeek(cPerg+aRegs[i,2])
        RecLock("SX1",.T.)
        For j:=1 to FCount()
            If j <= Len(aRegs[i])
                FieldPut(j,aRegs[i,j])
            Endif
        Next
        MsUnlock()
    Endif
Next
dbSelectArea(_sAlias)

Return