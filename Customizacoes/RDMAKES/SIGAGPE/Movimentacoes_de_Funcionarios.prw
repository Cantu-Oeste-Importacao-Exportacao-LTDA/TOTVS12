#INCLUDE "FiveWin.ch"
//#INCLUDE "GPER500.CH"
#INCLUDE "Report.ch"
#IFDEF TOP
	#INCLUDE "TOPCONN.CH"
#ENDIF

/*

��������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���Fun��o    � GPER500  � Autor  � R.H.                     � Data � 30.10.96 ���
�����������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao de Movimentacoes de Funcionarios  (TURN-OVER)          ���
�����������������������������������������������������������������������������Ĵ��
���Sintaxe   � GPER500(void)                                                  ���
�����������������������������������������������������������������������������Ĵ��
���Parametros�                                                                ���
�����������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                       ���
�����������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.                 ���
�����������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS     �  Motivo da Alteracao                     ���
�����������������������������������������������������������������������������Ĵ��
���Natie       �22/11/05�0088267   � Nova estrutura do relatorio              ���
���Natie       �06/03/06�0093233   � Ajuste na contagem inicial               ���
���Natie       �06/03/06�0093864   � Duplicava trasnferencias entre filiais   ���
���            �        �          � qdo se pedia todas as filiais            ���
���Natie       �28/04/06�0096708   � Ajuste na impr.da descricao do CC e conta���
���            �        �          � gem do func. admitido e transferido no   ���
���            �        �          � mes da admissao no CC de origem          ���
���Andreia	   �28/08/06�0100152   � Conversao em Relatorio personalizavel pa-���
���        	   �        �          � ra atender ao Release 4.                 ���
���Natie       �08/11/06�0107245   � Transf.entre empresas.Estava trazendo o  ���
���            �        �          � mvto de entrada na empresa de origem onde���
���            �        �          � deveria aparecer somente na empr. destino���
���Natie       �08/02/07�0117652   � Ajuste de impressao das colunas          ���
���Renata      �16/07/07�0127903   � Ajuste em fR500ACum para emissao c.custo ���
���            �        �          � origem qdo nao existe este c.custo no SRA���
���Marcelo     �18/03/09�0006146   � Ajustes em PrintReport, GR500Imp e       ���
���            �        �   2009   � fR500Impr p/ quebrar por CC corretamente.���
���Andreia	   �07/10/09�0022961/09� Ajuste para trazer as informacoes de en- ���
���        	   �        �          � trada por transferencia e admissao.      ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/
User Function GPER500() 

Local	oReport   
Local	aArea	:= GetArea()

Private aEmpresa	:= {} 			//-- Array com  as filiais da Empresa 
Private cPerg	:= "GPR500CUS" 
Private cTitulo	:= OemToAnsi("Detalle de movimiento de empleados (Turn-Over)  ")
Private	cAliasSRA:= "SRA"
Private lRelNew	:= .F.  

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

GPER500R3()


RestArea( aArea )

Return    


// a partir daqui RELEASE 3
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �GPER500R3 �Autor  �Microsiga           � Data �  08/25/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GPER500R3()

//��������������������������������������������������������������Ŀ
//� Define Variaveis Locais (Basicas)                            �
//����������������������������������������������������������������
Local cString:= "SRA"        // Alias do arquivo principal (Base)
Local aOrd   := {"C.Custo","Segmento"}
Local cDesc1 := "Detalle de movimiento de empleados (Turn-Over)  "  //"Rela��o de Movimenta��es Funcionarios (Turn-Over)"
Local cDesc2 := "Se imprimira de acuerdo con los parametros solicitados por"  //"Sera impresso de acordo com os parametros solicitados pelo"
Local cDesc3 := "Utilizador."  //"usuario."

//��������������������������������������������������������������Ŀ
//� Define Variaveis Private(Basicas)                            �
//����������������������������������������������������������������
Private aReturn  := { "C�digo de barras", 1,"Administra��o", 2, 2, 1, "",1 }  //"Zebrado"###"Administra��o"
Private nomeprog := "GPER500"
Private nLastKey := 0
Private cPerg    := "GPR500CUS" 
Private	cAliasSRA:= "SRA"
Private nTamCC	 := TamSx3("RA_CC")[1] 

//��������������������������������������������������������������Ŀ
//� Define Variaveis Private(Programa)                           �
//����������������������������������������������������������������
Private aInfo   := {}

//��������������������������������������������������������������Ŀ
//� Variaveis Utilizadas na funcao IMPR                          �
//����������������������������������������������������������������
Private Titulo
Private Colunas  := 132
Private AT_PRG   := "GPER500"
Private wCabec0  := 1
Private wCabec1  := Substr("|m�s/ano |  in�cio  | admiss�o | ent.transf.| sai.transf.| demiss�o |   fim   |",1,1) + Space(nTamCC)  + Space(30) + "|m�s/ano |  in�cio  | admiss�o | ent.transf.| sai.transf.| demiss�o |   fim   |"   			//--"| MES/ANO |  INICIO  | ADMISSAO | ENT.TRANSF.| SAI.TRANSF.| DEMISSAO |   FIM   |"
Private wCabec2  := ""
Private Contfl   := 1
Private Li       := 0
Private nTamanho := "M"
Private nDescCC	 := nTamCC+ 30
Private aLog		:= {}			//-- Log de controle interno- indica a localizacao inicial do func. - Filial/ CC / Mat 
Private aLogTitle 	:= {}
Private nCont		:= 0 

ValidPerg()
//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
pergunte(cPerg,.F.)
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01        //  Filial  De                               �
//� mv_par02        //  Filial  Ate                              �
//� mv_par03        //  Centro de Custo De                       �
//� mv_par04        //  Centro de Custo Ate                      �
//� mv_par05        //  Inicio do Mes/Ano Pesquisa               �
//� mv_par06        //  Final  do Mes/Ano Pesquisa               �
//����������������������������������������������������������������
Titulo := "RELA��O DE MOVIMENTA��ES DE EMPREGADOS"  //"RELA��O DE MOVIMENTA��ES FUNCIONARIOS"

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � GPER500  � Autor � R.H.                  � Data � 30.10.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao dos Salarios de Contribuicao                       ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � GR500Imp(lEnd,wnRel,cString)                               ���
�������������������������������������������������������������������������Ĵ��
���Parametros� lEnd        - A��o do Codelock                             ���
���          � wnRel       - T�tulo do relat�rio                          ���
���Parametros� cString     - Mensagem                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
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

//��������������������������������������������������������������Ŀ
//� Define Variaveis Privates (Programa)                         �
//����������������������������������������������������������������
Private aTurnOver  	:= {}
Private aTurnOveF  	:= {}
Private lImpressao 	:= .F. 
Private lContou		:= .F. 
Private lTransfAll	:= .F. 			//-- Carregou aTransfAll  
Private aAnoMes		:= {} 
Private aEmpresa	:= {} 			//-- Array com  as filiais da Empresa 

//��������������������������������������������������������������Ŀ
//� Carregando variaveis mv_par?? para Variaveis do Sistema.     �
//����������������������������������������������������������������
cFilDe    := mv_par01
cFilAte   := mv_par02
cCcDe     := mv_par03
cCcAte    := mv_par04
cMesAnoI  := mv_par05
cMesAnoF  := mv_par06
cSegDe	  := mv_par07
cSegAte	  := mv_par08

//�������������������������������������������������������������������������Ŀ
//� Adiciona as filiais que serao processadas 								�
//���������������������������������������������������������������������������
fAdEmpresa(2, @aEmpresa)
If Len(aEmpresa) == 0
	Return
EndIf

//��������������������������������������������������������������Ŀ
//� Incrementa o Array aTurnOver/aAnoMes Com o Intervalo de Datas�
//����������������������������������������������������������������
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
	
	//��������������������������������������������������������������Ŀ
	//� Aborta Impressao ao se clicar em cancela					 �
	//����������������������������������������������������������������
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
	                
	//��������������������������������������������������������������Ŀ
	//�                                                              �
	//����������������������������������������������������������������
	If !empty(SRA->RA_DEMISSA ) .and. MesAno(SRA->RA_DEMISSA) <  SubStr(cMesAnoI,3,4) + SubStr(cMesAnoI,1,2) 
		dbSkip()
		Loop
	Endif 
	
	//��������������������������������������������������������������Ŀ
	//� Consiste controle de acessos e filiais validas               �
	//����������������������������������������������������������������
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
		//���������������������������������������������������������������������������
		//� Apurar quantidade inicial do C.Custo                                    �
		//���������������������������������������������������������������������������
		If nAnoMes = 1 											//-- Somente preciso apurar onde o funcionario estava no primeiro periodo
			If  MesAno(SRA->RA_ADMISSA) <  aAnoMes[1] .And. ( Empty(SRA->RA_DEMISSA) .or. ; 
		        (MesAno(SRA->RA_DEMISSA) >= aAnoMes[1] ) ) 

				//���������������������������������������������������������������������������
				//� Carrega o array aTransfAll - TODAS as transferencias do funcionario     �
				//���������������������������������������������������������������������������
				dbSelectArea( "SRE" )
				fTransfAll( @aTransfAll,,,.T.) 			
		
				//���������������������������������������������������������������������������������
				//� Se nao houve transferencias, entao deve-se contar o func. de acordo com  a    |
				//� Emp/Filial/CC atual                                                           |				
				//���������������������������������������������������������������������������������
				If Len(aTransfAll) <= 0
					If fR500Acum( (cFilialAnt +Alltrim( cCcAnt) + aAnoMes[1] + cEmpAnt ) , cFilialAnt, cCcAnt, 4) 
						ncont ++ 
						aAdd( aLog , cFilialAnt +SPACE(1)+ cCcAnt+SPACE(1) + SRA->RA_MAT+SPACE(1)+ strzero(ncont,4) +SPACE(1)+ " +"  )
					Endif		
				Else 
					For nX := 1 to Len(aTransfAll)
						//���������������������������������������������������������������������������������
						//� Se houve transferencias, deve-se verificar onde o func. estava no inicio do   |
  						//� periodo desejado                                                              |
						//���������������������������������������������������������������������������������
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
	
		//���������������������������������������������������������������������������
		//�Se n�o existe nenhum funcionario no inicio do CC                         �
		//���������������������������������������������������������������������������
		If !lTransfAll
			dbSelectArea( "SRE" )
			aTransfAll := {}
			fTransfAll( @aTransfAll,,,.T.) 
			lTransfAll	:= .T. 
		Endif
		//���������������������������������������������������������������������������
		//� Apurar a movimenta�ao do funcionario dentro do periodo                  �
		//���������������������������������������������������������������������������
		If  Len(aTransfAll) > 0
			//���������������������������������������������������������������������������
			//� Movtimentacao de transferencias                                         �
			//���������������������������������������������������������������������������		
			lAdmitiu	:= .F.
			For nTransf := 1 to Len(aTransfAll) 
				If aAnoMes[nAnoMes] == aTransfAll[nTransf,12]  .and. ; 
					(nPos:= ascan(aJaContou, {|X| X[1] == "01"+aTransfAll[nTransf,1]+aTransfAll[nTransf,2]+aTransfAll[nTransf,3]+ dtos(aTransfAll[nTransf,7])  } ) )<= 0  //-- Empresa De+ Filial De + Matricula De + data 
				
					If nOrdem <> 2
						//�����������������������������������������������Ŀ
						//� Apurar Saidas por Transferencia               �
						//�������������������������������������������������
						fR500Acum( (aTransfAll[nTransf,08] + Alltrim(aTransfAll[nTransf,03] ) + aAnoMes[nAnoMes] + aTransfAll[nTransf,01]) , aTransfAll[nTransf,08] , aTransfAll[nTransf,03], 7, aTransfAll[nTransf,01]) 
	
						//�����������������������������������������������Ŀ
						//� Apurar Entradas por Transferencia             �
						//�������������������������������������������������
						fR500Acum( (aTransfAll[nTransf,10] + Alltrim( aTransfAll[nTransf,06])  + aAnoMes[nAnoMes]+ aTransfAll[nTransf,04] ) , aTransfAll[nTransf,10] , aTransfAll[nTransf,06], 6 , aTransfAll[nTransf,04]) 
						//�����������������������������������������������Ŀ
						//� Como ja computou entrada e saida, nao devo con�
						//� tar novamente qdo estiver processando mais de �
						//� uma  filial                                   �	
						//�������������������������������������������������
	
						aadd(aJaContou, {"01"+aTransfAll[nTransf,1]+aTransfAll[nTransf,2]+aTransfAll[nTransf,3]+ dtos(aTransfAll[nTransf,7])} )  
					Else
						//�����������������������������������������������Ŀ
						//� Apurar Saidas por Transferencia               �
						//�������������������������������������������������
						fR500Acum( (aTransfAll[nTransf,08] + Alltrim(SRA->RA_X_SEGME ) + aAnoMes[nAnoMes] + aTransfAll[nTransf,01]) , aTransfAll[nTransf,08] , SRA->RA_X_SEGME, 7, aTransfAll[nTransf,01]) 
	
						//�����������������������������������������������Ŀ
						//� Apurar Entradas por Transferencia             �
						//�������������������������������������������������
						fR500Acum( (aTransfAll[nTransf,10] + Alltrim( SRA->RA_X_SEGME)  + aAnoMes[nAnoMes]+ aTransfAll[nTransf,04] ) , aTransfAll[nTransf,10] , SRA->RA_X_SEGME, 6 , aTransfAll[nTransf,04]) 
						//�����������������������������������������������Ŀ
						//� Como ja computou entrada e saida, nao devo con�
						//� tar novamente qdo estiver processando mais de �
						//� uma  filial                                   �	
						//�������������������������������������������������
	
						aadd(aJaContou, {"01"+aTransfAll[nTransf,1]+aTransfAll[nTransf,2]+aTransfAll[nTransf,3]+ dtos(aTransfAll[nTransf,7])} )  					
					Endif

				Endif 
				//�����������������������������������������������Ŀ
				//� Apurar Admissao qdo tem transferencias        �
				//� Casos onde ha transf. no mesmo mes da admissao�
				//�������������������������������������������������
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
			//���������������������������������������������������������������������������
			//� Admissoes do periodo                                                    �
			//���������������������������������������������������������������������������
			If MesAno(SRA->RA_ADMISSA) = aAnoMes[nAnoMes]
				If nOrdem <> 2
					fR500Acum( (cFilialAnt + Alltrim( SRA->RA_CC ) + aAnoMes[nAnoMes] + cEmpAnt) , cFilialAnt , SRA->RA_CC, 5 ) 
				Else
					fR500Acum( (cFilialAnt + Alltrim( SRA->RA_X_SEGME ) + aAnoMes[nAnoMes] + cEmpAnt) , cFilialAnt , SRA->RA_X_SEGME, 5 ) 				
				Endif
			Endif
		Endif		
		//���������������������������������������������������������������������������
		//� Demissoes do periodo                                                    �
		//���������������������������������������������������������������������������
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
    
//��������������������������������������������������������������Ŀ
//� Impressao do Relatorio                                       �
//����������������������������������������������������������������
If lImpressao 
	fR500Impr( aTurnOver ) 
Endif	

//aAdd( aLogTitle , "R500" )	//"Arquivo Registro   Chave/Conteudo" 

//fMakeLog({aLog},aLogTitle,"GPER500")

//��������������������������������������������������������������Ŀ
//� Termino do relatorio                                         �
//����������������������������������������������������������������
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

//��������������������������������������������������������������Ŀ
//� Impressao do Relatorio                                       �
//����������������������������������������������������������������
If Len(aTurnOver)> 0 
	//����������������������������������������������������������������Ŀ
	//� Filtra impressao somente das movimentacoes da empresa corrente �
	//������������������������������������������������������������������
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
	//�������������������������������������������������������������������������Ŀ
	//� Verifica se Filial /CC pertencem  a empresa atual                 		�
	//���������������������������������������������������������������������������
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
				Det := "| " + aTurnOver[Nx,1] + "-"+ ALLTRIM(aTurnOver[Nx,2]) + " - " +  substr(  "N�o Cadastrado."+ Space(25),1,25 ) + space( nDescCC )
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

//��������������������������������������������������������������Ŀ
//� Impressao da ultima filial                                   �
//����������������������������������������������������������������
fSumFilial( cFilialAtu )
fImpFil() 
        
Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GPER500   �Autor  �Microsiga           � Data �  11/25/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GPER500   �Autor  �Microsiga           � Data �  11/28/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static function fSumFilial(cFilAtu)

Local nX		:= 0                  
Local nPos		:= 0 
Local aTurnAux	:= {}

//��������������������������������������������������������������Ŀ
//� Incrementa o Array aTurnOver/aAnoMes Com o Intervalo de Datas�
//����������������������������������������������������������������
fR500Add("3",cFilAtu)

aEval( aTurnOver , { |x,y| IF(aTurnOver[Y,1] == cFilAtu, aAdd( aTurnAux , aClone( aTurnOver[y] ) ) , NIL ) } )

For Nx:= 1  to Len(aTurnAux)
	//�������������������������������������������������������������������������Ŀ
	//� Posiciona no CEI/CNPJ (Centro de Custo ) que esta sendo processado		�
	//���������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GPER500   �Autor  �Microsiga           � Data �  12/02/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
	//�������������������������������������������������������������������������Ŀ
	//� Verifica se Filial /CC pertencem  a empresa atual                 		�
	//���������������������������������������������������������������������������
	If ( nEmpAtu  := (Ascan( aEmpresa, { |x| alltrim(x[2]+ X[3]) == Alltrim(cFilialAtu+cCcusto)  } ) > 0) .OR. ;
			        ((nTipo == 7 .OR. nTipo == 4 .OR. nTipo == 5.OR. nTipo == 6) .and. Ascan( aEmpresa, { |x| alltrim(x[2]) == Alltrim(cFilialAtu)  } ) > 0 ))
		//��������������������������������������������������������������Ŀ
		//� Incrementa o Array aTurnOver/aAnoMes Com o Intervalo de Datas�
		//����������������������������������������������������������������
	
		If ( nPos 	:= Ascan( aTurnOver, {|x| x[1]+ x[2]+ x[3]+ x[10] == cChave   } )   ) > 0  	//-- C.C. + Periodo + Empresa 
			aTurnOver[nPos,01]		:= cFilialAtu
			aTurnOver[nPos,02]		:= alltrim(cCcusto )
			aTurnOver[nPos,nTipo]	+= 1  
		Else
			//��������������������������������������������������������������Ŀ
			//� Incrementa o Array aTurnOver/aAnoMes Com o Intervalo de Datas�
			//����������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GPER500   �Autor  �Microsiga           � Data �  12/02/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fChkParam(cFilAtu, cCcAtu )

//��������������������������������������������������������������Ŀ
//� Garanto a impressao somente das filiais e C.C. indicadas     �
//� nos parametros                                               �
//����������������������������������������������������������������
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