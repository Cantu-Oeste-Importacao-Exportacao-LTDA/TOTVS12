#INCLUDE "FiveWin.ch"
#INCLUDE "GPER500.CH"
#INCLUDE "Report.ch"
#IFDEF TOP
	#INCLUDE "TOPCONN.CH"
#ENDIF

/*

苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噮o    � GPER500  � Autor  � R.H.                     � Data � 30.10.96 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o � Relacao de Movimentacoes de Funcionarios  (TURN-OVER)          潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe   � GPER500(void)                                                  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros�                                                                潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � Generico                                                       潮�
北媚哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北�         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.                 潮�
北媚哪哪哪哪哪穆哪哪哪哪履哪哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅rogramador � Data   � BOPS     �  Motivo da Alteracao                     潮�
北媚哪哪哪哪哪呐哪哪哪哪拍哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砃atie       �22/11/05�0088267   � Nova estrutura do relatorio              潮�
北砃atie       �06/03/06�0093233   � Ajuste na contagem inicial               潮�
北砃atie       �06/03/06�0093864   � Duplicava trasnferencias entre filiais   潮�
北�            �        �          � qdo se pedia todas as filiais            潮�
北砃atie       �28/04/06�0096708   � Ajuste na impr.da descricao do CC e conta潮�
北�            �        �          � gem do func. admitido e transferido no   潮�
北�            �        �          � mes da admissao no CC de origem          潮�
北矨ndreia	   �28/08/06�0100152   � Conversao em Relatorio personalizavel pa-潮�
北�        	   �        �          � ra atender ao Release 4.                 潮�
北砃atie       �08/11/06�0107245   � Transf.entre empresas.Estava trazendo o  潮�
北�            �        �          � mvto de entrada na empresa de origem onde潮�
北�            �        �          � deveria aparecer somente na empr. destino潮�
北砃atie       �08/02/07�0117652   � Ajuste de impressao das colunas          潮�
北砇enata      �16/07/07�0127903   � Ajuste em fR500ACum para emissao c.custo 潮�
北�            �        �          � origem qdo nao existe este c.custo no SRA潮�
北矼arcelo     �18/03/09�0006146   � Ajustes em PrintReport, GR500Imp e       潮�
北�            �        �   2009   � fR500Impr p/ quebrar por CC corretamente.潮�
北矨ndreia	   �07/10/09�0022961/09� Ajuste para trazer as informacoes de en- 潮�
北�        	   �        �          � trada por transferencia e admissao.      潮�
北滥哪哪哪哪哪牧哪哪哪哪聊哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�*/
User Function GPER500() 

Local	oReport   
Local	aArea	:= GetArea()

Private aEmpresa	:= {} 			//-- Array com  as filiais da Empresa 
Private cPerg	:= "GPR500CUS" 
Private cTitulo	:= OemToAnsi(STR0001)
Private	cAliasSRA:= "SRA"
Private lRelNew	:= .F.  

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
//矯hama fun玢o para monitor uso de fontes customizados�
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
U_USORWMAKE(ProcName(),FunName())

GPER500R3()


RestArea( aArea )

Return    


// a partir daqui RELEASE 3
/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐�
北篎uncao    矴PER500R3 篈utor  矼icrosiga           � Data �  08/25/06   罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北篋esc.     �                                                            罕�
北�          �                                                            罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       � AP                                                        罕�
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function GPER500R3()

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Define Variaveis Locais (Basicas)                            �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
Local cString:= "SRA"        // Alias do arquivo principal (Base)
Local aOrd   := {"C.Custo","Segmento"}
Local cDesc1 := STR0001  //"Rela噭o de Movimenta嚁es Funcionarios (Turn-Over)"
Local cDesc2 := STR0002  //"Sera impresso de acordo com os parametros solicitados pelo"
Local cDesc3 := STR0003  //"usuario."

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Define Variaveis Private(Basicas)                            �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
Private aReturn  := { STR0004, 1,STR0005, 2, 2, 1, "",1 }  //"Zebrado"###"Administra噭o"
Private nomeprog := "GPER500"
Private nLastKey := 0
Private cPerg    := "GPR500CUS" 
Private	cAliasSRA:= "SRA"
Private nTamCC	 := TamSx3("RA_CC")[1] 

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Define Variaveis Private(Programa)                           �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
Private aInfo   := {}

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Variaveis Utilizadas na funcao IMPR                          �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
Private Titulo
Private Colunas  := 132
Private AT_PRG   := "GPER500"
Private wCabec0  := 1
Private wCabec1  := Substr(STR0009,1,1) + Space(nTamCC)  + Space(30) + STR0009   			//--"| MES/ANO |  INICIO  | ADMISSAO | ENT.TRANSF.| SAI.TRANSF.| DEMISSAO |   FIM   |"
Private wCabec2  := ""
Private Contfl   := 1
Private Li       := 0
Private nTamanho := "M"
Private nDescCC	 := nTamCC+ 30
Private aLog		:= {}			//-- Log de controle interno- indica a localizacao inicial do func. - Filial/ CC / Mat 
Private aLogTitle 	:= {}
Private nCont		:= 0 

ValidPerg()
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Verifica as perguntas selecionadas                           �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
pergunte(cPerg,.F.)
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Variaveis utilizadas para parametros                         �
//� mv_par01        //  Filial  De                               �
//� mv_par02        //  Filial  Ate                              �
//� mv_par03        //  Centro de Custo De                       �
//� mv_par04        //  Centro de Custo Ate                      �
//� mv_par05        //  Inicio do Mes/Ano Pesquisa               �
//� mv_par06        //  Final  do Mes/Ano Pesquisa               �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
Titulo := STR0006  //"RELA�嶰 DE MOVIMENTA�橢S FUNCIONARIOS"

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Envia controle para a funcao SETPRINT                        �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
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
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噮o    � GPER500  � Autor � R.H.                  � Data � 30.10.96 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o � Relacao dos Salarios de Contribuicao                       潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe e � GR500Imp(lEnd,wnRel,cString)                               潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros� lEnd        - A嚻o do Codelock                             潮�
北�          � wnRel       - Tulo do relatio                          潮�
北砅arametros� cString     - Mensagem                                     潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � Generico                                                   潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�*/
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

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Define Variaveis Privates (Programa)                         �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
Private aTurnOver  	:= {}
Private aTurnOveF  	:= {}
Private lImpressao 	:= .F. 
Private lContou		:= .F. 
Private lTransfAll	:= .F. 			//-- Carregou aTransfAll  
Private aAnoMes		:= {} 
Private aEmpresa	:= {} 			//-- Array com  as filiais da Empresa 

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Carregando variaveis mv_par?? para Variaveis do Sistema.     �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
cFilDe    := mv_par01
cFilAte   := mv_par02
cCcDe     := mv_par03
cCcAte    := mv_par04
cMesAnoI  := mv_par05
cMesAnoF  := mv_par06
cSegDe	  := mv_par07
cSegAte	  := mv_par08

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
//� Adiciona as filiais que serao processadas 								�
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
fAdEmpresa(2, @aEmpresa)
If Len(aEmpresa) == 0
	Return
EndIf

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Incrementa o Array aTurnOver/aAnoMes Com o Intervalo de Datas�
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
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
	
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Aborta Impressao ao se clicar em cancela					 �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
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
	                
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//�                                                              �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	If !empty(SRA->RA_DEMISSA ) .and. MesAno(SRA->RA_DEMISSA) <  SubStr(cMesAnoI,3,4) + SubStr(cMesAnoI,1,2) 
		dbSkip()
		Loop
	Endif 
	
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Consiste controle de acessos e filiais validas               �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
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
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪���
		//� Apurar quantidade inicial do C.Custo                                    �
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
		If nAnoMes = 1 											//-- Somente preciso apurar onde o funcionario estava no primeiro periodo
			If  MesAno(SRA->RA_ADMISSA) <  aAnoMes[1] .And. ( Empty(SRA->RA_DEMISSA) .or. ; 
		        (MesAno(SRA->RA_DEMISSA) >= aAnoMes[1] ) ) 

				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪���
				//� Carrega o array aTransfAll - TODAS as transferencias do funcionario     �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
				dbSelectArea( "SRE" )
				fTransfAll( @aTransfAll,,,.T.) 			
		
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪��哪哪���
				//� Se nao houve transferencias, entao deve-se contar o func. de acordo com  a    |
				//� Emp/Filial/CC atual                                                           |				
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪��哪哪�
				If Len(aTransfAll) <= 0
					If fR500Acum( (cFilialAnt +Alltrim( cCcAnt) + aAnoMes[1] + cEmpAnt ) , cFilialAnt, cCcAnt, 4) 
						ncont ++ 
						aAdd( aLog , cFilialAnt +SPACE(1)+ cCcAnt+SPACE(1) + SRA->RA_MAT+SPACE(1)+ strzero(ncont,4) +SPACE(1)+ " +"  )
					Endif		
				Else 
					For nX := 1 to Len(aTransfAll)
						//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪��哪哪���
						//� Se houve transferencias, deve-se verificar onde o func. estava no inicio do   |
  						//� periodo desejado                                                              |
						//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪��哪哪�
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
	
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪���
		//砈e n鉶 existe nenhum funcionario no inicio do CC                         �
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
		If !lTransfAll
			dbSelectArea( "SRE" )
			aTransfAll := {}
			fTransfAll( @aTransfAll,,,.T.) 
			lTransfAll	:= .T. 
		Endif
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪���
		//� Apurar a movimenta鏰o do funcionario dentro do periodo                  �
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
		If  Len(aTransfAll) > 0
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪���
			//� Movtimentacao de transferencias                                         �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�		
			lAdmitiu	:= .F.
			For nTransf := 1 to Len(aTransfAll) 
				If aAnoMes[nAnoMes] == aTransfAll[nTransf,12]  .and. ; 
					(nPos:= ascan(aJaContou, {|X| X[1] == "01"+aTransfAll[nTransf,1]+aTransfAll[nTransf,2]+aTransfAll[nTransf,3]+ dtos(aTransfAll[nTransf,7])  } ) )<= 0  //-- Empresa De+ Filial De + Matricula De + data 
				
					If nOrdem <> 2
						//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
						//� Apurar Saidas por Transferencia               �
						//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
						fR500Acum( (aTransfAll[nTransf,08] + Alltrim(aTransfAll[nTransf,03] ) + aAnoMes[nAnoMes] + aTransfAll[nTransf,01]) , aTransfAll[nTransf,08] , aTransfAll[nTransf,03], 7, aTransfAll[nTransf,01]) 
	
						//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
						//� Apurar Entradas por Transferencia             �
						//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
						fR500Acum( (aTransfAll[nTransf,10] + Alltrim( aTransfAll[nTransf,06])  + aAnoMes[nAnoMes]+ aTransfAll[nTransf,04] ) , aTransfAll[nTransf,10] , aTransfAll[nTransf,06], 6 , aTransfAll[nTransf,04]) 
						//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
						//� Como ja computou entrada e saida, nao devo con�
						//� tar novamente qdo estiver processando mais de �
						//� uma  filial                                   �	
						//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
	
						aadd(aJaContou, {"01"+aTransfAll[nTransf,1]+aTransfAll[nTransf,2]+aTransfAll[nTransf,3]+ dtos(aTransfAll[nTransf,7])} )  
					Else
						//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
						//� Apurar Saidas por Transferencia               �
						//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
						fR500Acum( (aTransfAll[nTransf,08] + Alltrim(SRA->RA_X_SEGME ) + aAnoMes[nAnoMes] + aTransfAll[nTransf,01]) , aTransfAll[nTransf,08] , SRA->RA_X_SEGME, 7, aTransfAll[nTransf,01]) 
	
						//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
						//� Apurar Entradas por Transferencia             �
						//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
						fR500Acum( (aTransfAll[nTransf,10] + Alltrim( SRA->RA_X_SEGME)  + aAnoMes[nAnoMes]+ aTransfAll[nTransf,04] ) , aTransfAll[nTransf,10] , SRA->RA_X_SEGME, 6 , aTransfAll[nTransf,04]) 
						//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
						//� Como ja computou entrada e saida, nao devo con�
						//� tar novamente qdo estiver processando mais de �
						//� uma  filial                                   �	
						//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
	
						aadd(aJaContou, {"01"+aTransfAll[nTransf,1]+aTransfAll[nTransf,2]+aTransfAll[nTransf,3]+ dtos(aTransfAll[nTransf,7])} )  					
					Endif

				Endif 
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
				//� Apurar Admissao qdo tem transferencias        �
				//� Casos onde ha transf. no mesmo mes da admissao�
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
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
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪���
			//� Admissoes do periodo                                                    �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
			If MesAno(SRA->RA_ADMISSA) = aAnoMes[nAnoMes]
				If nOrdem <> 2
					fR500Acum( (cFilialAnt + Alltrim( SRA->RA_CC ) + aAnoMes[nAnoMes] + cEmpAnt) , cFilialAnt , SRA->RA_CC, 5 ) 
				Else
					fR500Acum( (cFilialAnt + Alltrim( SRA->RA_X_SEGME ) + aAnoMes[nAnoMes] + cEmpAnt) , cFilialAnt , SRA->RA_X_SEGME, 5 ) 				
				Endif
			Endif
		Endif		
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪���
		//� Demissoes do periodo                                                    �
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
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
    
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Impressao do Relatorio                                       �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
If lImpressao 
	fR500Impr( aTurnOver ) 
Endif	

//aAdd( aLogTitle , "R500" )	//"Arquivo Registro   Chave/Conteudo" 

//fMakeLog({aLog},aLogTitle,"GPER500")

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Termino do relatorio                                         �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
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
			Det := "| " + STR0011 + aTurnOveF[Nw,1] + " - " + PadR(aInfo[1],15) + Space(nDescCC)  //"FILIAL: "
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

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Impressao do Relatorio                                       �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
If Len(aTurnOver)> 0 
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Filtra impressao somente das movimentacoes da empresa corrente �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
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
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
	//� Verifica se Filial /CC pertencem  a empresa atual                 		�
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
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
				Det := "| " + aTurnOver[Nx,1] + "-"+ ALLTRIM(aTurnOver[Nx,2]) + " - " +  substr(  "N鉶 Cadastrado."+ Space(25),1,25 ) + space( nDescCC )
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

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Impressao da ultima filial                                   �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
fSumFilial( cFilialAtu )
fImpFil() 
        
Return Nil


/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐�
北篜rograma  矴PER500   篈utor  矼icrosiga           � Data �  11/25/05   罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北篋esc.     �                                                            罕�
北�          �                                                            罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       � AP                                                         罕�
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
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
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐�
北篜rograma  矴PER500   篈utor  矼icrosiga           � Data �  11/28/05   罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北篋esc.     �                                                            罕�
北�          �                                                            罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       � AP                                                         罕�
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static function fSumFilial(cFilAtu)

Local nX		:= 0                  
Local nPos		:= 0 
Local aTurnAux	:= {}

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Incrementa o Array aTurnOver/aAnoMes Com o Intervalo de Datas�
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
fR500Add("3",cFilAtu)

aEval( aTurnOver , { |x,y| IF(aTurnOver[Y,1] == cFilAtu, aAdd( aTurnAux , aClone( aTurnOver[y] ) ) , NIL ) } )

For Nx:= 1  to Len(aTurnAux)
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
	//� Posiciona no CEI/CNPJ (Centro de Custo ) que esta sendo processado		�
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
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
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐�
北篜rograma  矴PER500   篈utor  矼icrosiga           � Data �  12/02/05   罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北篋esc.     �                                                            罕�
北�          �                                                            罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       � AP                                                         罕�
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
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
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
	//� Verifica se Filial /CC pertencem  a empresa atual                 		�
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
	If ( nEmpAtu  := (Ascan( aEmpresa, { |x| alltrim(x[2]+ X[3]) == Alltrim(cFilialAtu+cCcusto)  } ) > 0) .OR. ;
			        ((nTipo == 7 .OR. nTipo == 4 .OR. nTipo == 5.OR. nTipo == 6) .and. Ascan( aEmpresa, { |x| alltrim(x[2]) == Alltrim(cFilialAtu)  } ) > 0 ))
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//� Incrementa o Array aTurnOver/aAnoMes Com o Intervalo de Datas�
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	
		If ( nPos 	:= Ascan( aTurnOver, {|x| x[1]+ x[2]+ x[3]+ x[10] == cChave   } )   ) > 0  	//-- C.C. + Periodo + Empresa 
			aTurnOver[nPos,01]		:= cFilialAtu
			aTurnOver[nPos,02]		:= alltrim(cCcusto )
			aTurnOver[nPos,nTipo]	+= 1  
		Else
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Incrementa o Array aTurnOver/aAnoMes Com o Intervalo de Datas�
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
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
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐�
北篜rograma  矴PER500   篈utor  矼icrosiga           � Data �  12/02/05   罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北篋esc.     �                                                            罕�
北�          �                                                            罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       � AP                                                         罕�
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function fChkParam(cFilAtu, cCcAtu )

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Garanto a impressao somente das filiais e C.C. indicadas     �
//� nos parametros                                               �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
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