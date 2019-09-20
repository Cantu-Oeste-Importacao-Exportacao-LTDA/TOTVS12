#INCLUDE "FIVEWIN.CH"
#INCLUDE "GPER260.CH"
#INCLUDE "report.ch"

/*

�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    � GPER260  � Autor � R.H. - Marcos Stiefano  � Data � 04.01.96 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o � Rela��o de Aniversariantes do Mes                            ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe   � GPER260(void)                                                ���
���������������������������������������������������������������������������Ĵ��
���Parametros�                                                              ���
���������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                     ���
���������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.               ���
���������������������������������������������������������������������������Ĵ��
���Programador � Data     � BOPS �  Motivo da Alteracao                     ���
���������������������������������������������������������������������������Ĵ��
���Fernando J. � 28/03/96 �XXXXXX� Inclusao de Rotina que Consiste parame-  ���
���            �          �      � trizacao do Intervalo de Impressao.      ���
���Mauro       � 23/12/96 �08605a� Acerto na Indregua erro no Ads           ���
���Aldo        � 24/03/97 �xxxxxx� Inclusao de cancelamento de impressao.   ���
���Mauro       � 18/04/97 �XXXXXX� Ordem Data Nasc. para todas versoes      ���
���Aldo        � 18/09/97 �xxxxxx� Tirar a expressao "funcionario" do Cabec.���
���Aldo        � 03/03/98 �xxxxxx� Apagar corretamente o indice temporario. ���
���Cristina    � 21/05/98 �xxxxxx� Conversao para outros idiomas.           ���
���Kleber      � 03/02/99 �XXXXXX� Acerto Bug do Mil�nio.                   ���
���Aldo        � 30/03/99 �------� Passagem de nTamanho para SetPrint().    ���
���Cristina    � 25/05/99 �------� Checagem De/At� na Dt.Nascimento.        ���
���Marinaldo   � 27/07/00 �XXXXXX� Retirada Dos e Validacao Filial/Acessos  ���
���Mauro       � 07/12/01 �011125� Para o Relatorio o Set Century sera on   ���
���            �          �      � na saida retorna o tamanho  versoes      ���
���Natie       � 18/05/02 �------� Acerto tamanho campo Centro Custo(tam 20)���
���Tania 	   �11/07/2006�100158� Conversao em Relatorio personalizavel pa-���
���        	   �          �      � ra atender ao Release 4.                 ���
���Luiz Gustavo|24/01/2007�      �Retiradas funcoes de ajuste de dicionario ���
���Marcelo     |06/04/2009�005257�Ajuste na indexacao por Data de Nascimento���
���        	   �          �  2009�para imprimir corretamente em formato R4. ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������*/
User Function GPER260()
Local	oReport   
Local	aArea 	:= GetArea()
Private	cString	:= "SRA"				// alias do arquivo principal (Base)
Private cPerg	:= "GP260R"
Private aOrd    := {OemToAnsi(STR0004),OemToAnsi(STR0005),OemToAnsi(STR0006),OemToAnsi(STR0007),OemToAnsi(STR0008)}	
					//"Matricula"###"Centro de Custo"###"Nome"###"Chapa"###"Data Nascimento"
Private cTitulo	:= OemToAnsi(STR0011)	//" RELA��O DE ANIVERSARIANTES DO MES "

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

GPER260R3()

RestArea( aArea )

Return


//========>>>>>>>>>>>>>>> Daqui em diante trata-se de release 3

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � GPER260  � Autor � R.H. - Marcos Stiefano� Data � 04.01.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rela��o de Aniversariante No Mes                           ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � GPER260(void)                                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���Fernando J. �28/03/96�XXXXXX� Inclusao de Rotina que Consiste parame-  ���
���            �        �      � trizacao do Intervalo de Impressao.      ���
���Mauro       �23/12/96�08605a� Acerto na Indregua erro no Ads           ���
���Aldo        �24/03/97�xxxxxx� Inclusao de cancelamento de impressao.   ���
���Mauro       �18/04/97�XXXXXX� Ordem Data Nasc. para todas versoes      ���
���Aldo        �18/09/97�xxxxxx� Tirar a expressao "funcionario" do Cabec.���
���Aldo        �03/03/98�xxxxxx� Apagar corretamente o indice temporario. ���
���Cristina    �21/05/98�xxxxxx� Conversao para outros idiomas.           ���
���Kleber      �03/02/99�XXXXXX� Acerto Bug do Mil�nio.                   ���
���Aldo        �30/03/99�------� Passagem de nTamanho para SetPrint().    ���
���Cristina    �25/05/99�------� Checagem De/At� na Dt.Nascimento.        ���
���Marinaldo   �27/07/00�XXXXXX� Retirada Dos e Validacao Filial/Acessos  ���
���Mauro       �07/12/01�011125� Para o Relatorio o Set Century sera on	  ���
���            �        �      � na saida retorna o tamanho  versoes      ���
���Natie       �18/05/02�------� Acerto tamanho campo Centro Custo(tam 20)���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function GPER260R3()

//��������������������������������������������������������������Ŀ
//� Define Variaveis Locais(Basicas)                             �
//����������������������������������������������������������������
Local cDesc1  := STR0001		//"Rela��o de Aniversariante no Mes"
Local cDesc2  := STR0002		//"Ser� impresso de acordo com os parametros solicitados pelo"
Local cDesc3  := STR0003		//"usu�rio."
Local cString := "SRA"  					// alias do arquivo principal (Base)
Local aOrd    := {STR0004,STR0005,STR0006,STR0007,STR0008,"Segmento"}  //"Matricula"###"Centro de Custo"###"Nome"###"Chapa"###"Data Nascimento"

//��������������������������������������������������������������Ŀ
//� Define Variaveis Private(Basicas)                            �
//����������������������������������������������������������������
Private aReturn  := {STR0009,1,STR0010,2,2,1,"",1 }	//"Zebrado"###"Administra��o"
Private NomeProg := "GPER260"
Private aLinha   := {}
Private nLastKey := 0
Private cPerg    := "GPR260CUS"

//��������������������������������������������������������������Ŀ
//� Define Variaveis Private(Programa)                           �
//����������������������������������������������������������������
Private aPosicao1 := {} // Array das posicoes
Private aTotCc1   := {}
Private aTotFil1  := {}
Private aTotEmp1  := {}
Private aInfo     := {}

//��������������������������������������������������������������Ŀ
//� Variaveis Utilizadas na funcao IMPR                          �
//����������������������������������������������������������������
Private Titulo
Private AT_PRG   := "GPER260"
Private wCabec0  := 2
Private wCabec1  := ""
Private wCabec2  := ""
Private Contfl   := 1
Private Li       := 0
Private nTamanho := "M"

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

//--MUDAR ANO PARA 4 DIGITOS
SET CENTURY ON
ValidPerg()
//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
pergunte(cPerg,.F.)

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01        //  Filial De                                �
//� mv_par02        //  Filial Ate                               �
//� mv_par03        //  Centro de Custo De                       �
//� mv_par04        //  Centro de Custo Ate                      �
//� mv_par05        //  Matricula De                             �
//� mv_par06        //  Matricula Ate                            �
//� mv_par07        //  Nome De                                  �
//� mv_par08        //  Nome Ate                                 �
//� mv_par09        //  Chapa De                                 �
//� mv_par10        //  Chapa Ate                                �
//� mv_par11        //  Data Nascimento De                       �
//� mv_par12        //  Data Nascimento Ate                      �
//� mv_par13        //  Mes De                                   �
//� mv_par14        //  Mes Ate                                  �
//� mv_par15        //  Situacoes                                �
//� mv_par16        //  Categorias                               �
//� mv_par17        //  Imprime Salario                          �
//� mv_par18        //  Imprime Ano de Nascimento                �
//� mv_par19        //  Imprime Estado Civil                     �
//� mv_par20        //  Salta Pagina Quebra Filial               �
//����������������������������������������������������������������
cTit    := STR0011		//" RELA��O DE ANIVERSARIANTES NO MES "
Titulo  := STR0011		//" RELA��O DE ANIVERSARIANTES NO MES "

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel:="GPER260"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,cTit,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho)

//��������������������������������������������������������������Ŀ
//� Carregando variaveis mv_par?? para Variaveis do Sistema.     �
//����������������������������������������������������������������
nOrdem     := aReturn[8]
cFilDe     := mv_par01
cFilAte    := mv_par02
cCcDe      := mv_par03
cCcAte     := mv_par04
cMatDe     := mv_par05
cMatAte    := mv_par06
cNomeDe    := mv_par07
cNomeAte   := mv_par08
cChapaDe   := mv_par09
cChapaAte  := mv_par10
dDatNaDe   := mv_par11
dDatNaAte  := mv_par12
cMesDe     := mv_par13
cMesAte    := mv_par14
cSituacao  := mv_par15
cCategoria := mv_par16
lImpSal    := If( mv_par17 == 1 , .T. , .F. )
lAnoNas    := If( mv_par18 == 1 , .T. , .F. )
lImpEst    := If( mv_par19 == 1 , .T. , .F. )
lSalta     := If( mv_par20 == 1 , .T. , .F. )

If nOrdem # 4
    Wcabec1 := STR0012	//"FILIAL   C. CUSTO              MATR.   NOME                                  DATA DE      ESTADO                  "
    Wcabec2 := STR0013	//"                                                                             NASCIMENTO    CIVIL                   "
Else
    Wcabec1 := STR0014	//"FILIAL   C. CUSTO              CHAPA  MATR.    NOME                                DATA DE      ESTADO             "
    Wcabec2 := STR0015	//"                                                                                   NASCIMENTO    CIVIL              "    
Endif


Wcabec1 += If( lImpSal , STR0016,"")
Wcabec1 += Iif(nOrdem=6,"SEGMENTO","")

If nLastKey == 27
	If nTdata > 8
		SET CENTURY ON
	Else
		SET CENTURY OFF
	Endif
	Return
Endif
SetDefault(aReturn,cString)
If nLastKey = 27
	If nTdata > 8
		SET CENTURY ON
	Else
		SET CENTURY OFF
	Endif
	Return
Endif

RptStatus({|lEnd| GR260Imp(@lEnd,wnRel,cString)},cTit)

If nTdata > 8
	SET CENTURY ON
Else
	SET CENTURY OFF
Endif


Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � GPER260  � Autor � R.H. - Marcos Stiefano� Data � 04.01.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rela��o de Aniversariante No Mes                           ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � GPER260(lEnd,WnRel,cString)                                ���
�������������������������������������������������������������������������Ĵ��
���Parametros� lEnd        - A��o do Codelock                             ���
���          � wnRel       - T�tulo do relat�rio                          ���
���Parametros� cString     - Mensagem			                          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function GR260Imp(lEnd,WnRel,cString)
//��������������������������������������������������������������Ŀ
//� Define Variaveis Locais (Programa)                           �
//����������������������������������������������������������������
Local CbTxt //Ambiente
Local CCont
Local aCodFol := {}
Local nCont   := 0
Local aCampos,cArqTrb

/*
��������������������������������������������������������������Ŀ
� Variaveis de Acesso do Usuario                               �
����������������������������������������������������������������*/
Local cAcessaSRA	:= &( " { || " + ChkRH( "GPER260" , "SRA" , "2" ) + " } " )

dbSelectArea( "SRA" )
If nOrdem == 1 
	dbSetOrder( 1 )
ElseIf nOrdem == 2
	dbSetOrder( 2 )
ElseIf nOrdem == 3
	dbSetOrder(3)
ElseIf nOrdem == 4
	dbSetOrder(1)
ElseIf nOrdem == 5
	dbSetOrder(1)
ElseIf nOrdem == 6
	dbOrderNickName("CLVLCUS   ")	
Endif

dbGoTop()

If nOrdem == 1
	dbSeek(cFilDe + cMatDe,.T.)
	cInicio := "SRA->RA_FILIAL + SRA->RA_MAT"
	cFim    := cFilAte + cMatAte
ElseIf nOrdem == 2
	dbSeek(cFilDe + cCcDe + cMatDe,.T.)
	cInicio := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT"
	cFim    := cFilAte + cCcAte + cMatAte
ElseIf nOrdem == 3
	dbSeek(cFilDe + cNomeDe + cMatDe,.T.)
	cInicio := "SRA->RA_FILIAL + SRA->RA_NOME + SRA->RA_MAT"
	cFim    := cFilAte + cNomeAte + cMatAte
ElseIf nOrdem == 4
	dbSeek(cFilDe + cMatDe,.T.)
	cInicio := "SRA->RA_FILIAL + SRA->RA_MAT"
	cFim    := cFilAte + cMatAte
ElseIf nOrdem == 5
	dbSeek(cFilDe + cMatDe,.T.)
	cInicio := "SRA->RA_FILIAL + SRA->RA_MAT"
	cFim    := cFilAte + cMatAte
	aCampos := {{"RECNO","N",10,0},{"CHAVE","C",6,0}}
	cArqTrb := CriaTrab(aCampos,.t.)
	Use &cArqTrb Alias TRB Exclusive NEW
	Index ON CHAVE to &cArqTrb
	dbSelectArea("SRA")	
	dbSeek(cFilDe+cMatDe,.T.)
	While !Eof() .and. SRA->RA_FILIAL+SRA->RA_MAT <= cFilAte+cMatAte
		
		IF Gpe260Ok()
			dbSelectArea("TRB")
			RecLock("TRB",.t.)
			Replace RECNO With SRA->(Recno())
			Replace CHAVE With SRA->RA_FILIAL+Right(Dtos(SRA->RA_NASC),4)
		Endif
		dbSelectArea("SRA")
		dbSkip()
	End
	TRB->(dbGotop())
ElseIf nOrdem == 6
	dbSeek(cFilDe + "         " + cMatDe,.T.)
	cInicio := "SRA->RA_FILIAL + SRA->RA_X_SEGME"
	cFim    := cFilAte + "ZZZZZZZZZ" + cMatAte
Endif

If nOrdem == 4
       cIndCond:= "RA_FILIAL + RA_CHAPA"
       cFor :='RA_FILIAL >= "'+cFIlDe+'" .and. RA_CHAPA >= "'+cChapaDe+'" .and. RA_FILIAL <= "'+cFIlAte+'" .and. '
       cFor +='RA_CHAPA <= "'+cChapaAte+'"'
       cArqNtx  := CriaTrab(Nil,.F.)
       IndRegua("SRA",cArqNtx,cIndCond,,cFor,STR0017)		//"Selecionando Registros..."
Endif

cFilialAnt := Space(FWGETTAMFILIAL) //ALTERADO REGINALDO
cCcAnt     := Space(20)

dbSelectArea( "SRA" )
cFilAnterior := SRA->RA_FILIAL
IF nOrdem != 5
	SetRegua(SRA->(RecCount()))
Else
	SetRegua(TRB->(RecCount()))
	IF !TRB->(Eof())
		SRA->(dbGoto(TRB->RECNO))
	Else
		SRA->(dbSeek("@@@@@@@@"))
	Endif
Endif


While	!EOF() .And. &cInicio <= cFim	
    //��������������������������������������������������������������Ŀ
    //� Movimenta Regua Processamento                                �
    //����������������������������������������������������������������
	 IncRegua()

	If lEnd
		@Prow()+1,0 PSAY cCancel
		Exit
	Endif	 
    
    If SRA->RA_FILIAL # cFilialAnt
	    If !fInfo(@aInfo,SRA->RA_FILIAL)
		    Exit
	    Endif
	    dbSelectArea( "SRA" )
	    cFilialAnt := SRA->RA_FILIAL
    Endif
       
	//��������������������������������������������������������������Ŀ
	//� Consiste Parametrizacao do Intervalo de Impressao            �
	//����������������������������������������������������������������
	If !GPE260Ok() .and. nOrdem != 5
		fTestaTotal()
		SRA->(dbSkip(1))
		Loop
	Endif

	/*
	�����������������������������������������������������������������������Ŀ
	�Consiste Filiais e Acessos                                             �
	�������������������������������������������������������������������������*/
	IF !( SRA->RA_FILIAL $ fValidFil() ) .or. !Eval( cAcessaSRA )
		fTestaTotal()
      	SRA->(dbSkip())
       	Loop
	EndIF

	//��������������������������������������������������������������Ŀ
	//� Impressao do Funcionario                                     �
	//����������������������������������������������������������������
	fImpFun()
	fTestaTotal()  // Quebras e Skips
	IF nOrdem == 5
		TRB->(dbSkip())
		IF !TRB->(Eof())
			SRA->(dbGoto(TRB->RECNO))
		Else
			SRA->(dbSeek("@@@@@@@@"))
		Endif
	Else
		SRA->(dbSkip())
	Endif
	dbSelectArea("SRA")
EndDo

//��������������������������������������������������������������Ŀ
//� Termino do Relatorio                                         �
//����������������������������������������������������������������
Impr("","F")

If nOrdem == 5
	dbSelectArea("TRB")
	dbCloseArea()
	FERASE(cArqTRB+GetDBExtension())
	#IFDEF CDX
		FERASE(cArqTRB+".CDX")
	#ELSE
		FERASE(cArqTRB+".NTX")
	#ENDIF	
Endif

dbSelectArea( "SRA" )
Set Filter to
If nOrdem == 4 
	RetIndex( "SRA" )
Endif
dbSetOrder(1)
If nOrdem == 4 
	fErase( cArqNtx + OrdBagExt() )
Endif

Set Device To Screen

If aReturn[5] = 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif

MS_FLUSH()

*--------------------------*
Static Function fTestaTotal
*--------------------------*
dbSelectArea( "SRA" )
cFilialAnt := SRA->RA_FILIAL              // Iguala Variaveis
If nOrdem <> 6
	cCcAnt     := SRA->RA_CC
Else
	cCcAnt     := SRA->RA_X_SEGME
Endif

Return Nil

*------------------------*
Static Function fImpFun()
*------------------------*

Local cCivil    := ""
Local cDesCivil := ""
Local cSalario  := Space(14)
                   
DbSelectArea("CTT")
DbSetOrder(1)
DbGotop()

If DbSeek(xFilial("CTT")+SRA->RA_CC)
	cDet 	    := " "+SRA->RA_FILIAL+"      "+substr(CTT->CTT_DESC01+space(20),1,20)
Else
	cDet 	    := " "+SRA->RA_FILIAL+"      "+substr(SRA->RA_CC+space(20),1,20)
Endif
cCivil    := SRA->RA_ESTCIVI
cDesCivil := IF(cCivil="S",STR0018,IF(cCivil="C",STR0019,iF(cCivil="V",STR0020,IF(cCivil="D",STR0021,IF(cCivil="Q",STR0022,STR0023)))))	//"SOLTEIRO"###"CASADO"###"VIUVO"###"DIVORCIADO"###"DESQUITADO"###"MARITAL"
If lImpEst
	cDesCivil := SubStr(cDesCivil+Space(10),1,10)
Else
	cDesCivil := Replicate("-",10)
Endif

If lImpSal
//	cSalario := Transform(SRA->RA_SALARIO,"@E 999,999,999.99") Adriano
	cSalario := Transform(SRA->RA_SALARIO,"@E 99,999.99")	
Else
	cSalario := ""
Endif

If nOrdem # 4
	cDet += Space(02) + SRA->RA_MAT + Space(02) + substr(SRA->RA_NOME,1,30) + Space(07)
	cDet += IF(lAnoNas , PadR(DtoC(SRA->RA_NASC),14) , PadR(SubStr(DtoC(SRA->RA_NASC),1,5),14))
	cDet += cDesCivil + Space(7) + cSalario 
Else
	cDet += Space(02) + SRA->RA_CHAPA + Space(02) + SRA->RA_MAT + Space(03)
	cDet += substr(SRA->RA_NOME,1,30) + Space(05) + IF(lAnoNas , PadR(DtoC(SRA->RA_NASC),14) , PadR(SubStr(DtoC(SRA->RA_NASC),1,5),14))
	cDet += cDesCivil + Space(02) + cSalario
Endif

If cFilAnterior # SRA->RA_FILIAL .And. lSalta
	Impr("","P")
	cFilAnterior := SRA->RA_FILIAL
Endif
If nOrdem = 6
	_aArea:= GetArea()
	DbSelectArea("CTH")
	DbSetOrder(1)
	If DbSeek(xFilial("CTH")+SRA->RA_X_SEGME)
		cDet+= "  "+SubStr(CTH->CTH_DESC01,1,23)
	Else
		cDet+= "  "+"Vazio"
	Endif
	RestArea(_aArea)
Endif
Impr(cDet,"C")

Return Nil

**************************
Static Function GPE260Ok()
**************************
If (SRA->RA_CHAPA < cChapaDe) .Or. (SRA->RA_CHAPA > cChapaAte) .Or. ;
	(SRA->RA_NOME < cNomeDe)   .Or. (SRA->RA_NOME > cNomeAte)   .Or. ;
	(SRA->RA_MAT < cMatDe)     .Or. (SRA->RA_MAT > cMatAte)     .Or. ;
	(SRA->RA_CC < cCcDe)       .Or. (SRA->RA_CC > cCcAte)			.Or. ;
	(SRA->RA_NASC < dDatNaDe)	.Or. (SRA->RA_NASC > dDatNaAte) 
	Return .f.
EndIf

	//��������������������������������������������������������������Ŀ
	//� Verifica Mes de Nascimento                                   �
	//����������������������������������������������������������������
If Month(SRA->RA_NASC) < VAL(cMesDe) .Or. Month(SRA->RA_NASC) > VAL(cMesAte)
	Return .f.
Endif    

//��������������������������������������������������������������Ŀ
//� Verifica Situacao e Categoria do Funcionario                 �
//����������������������������������������������������������������
If !( SRA->RA_SITFOLH $ cSituacao ) .OR. !( SRA->RA_CATFUNC $ cCategoria )
	Return .f.
Endif

Return .t.


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
aAdd(aRegs,{cPerg,"05","Matricula De           ?","","","mv_ch5","C",06,0,0,"G","        ","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})
aAdd(aRegs,{cPerg,"06","Matricula Ate          ?","","","mv_ch6","C",06,0,0,"G","naovazio","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""}) 
aAdd(aRegs,{cPerg,"07","Nome De                ?","","","mv_ch7","C",30,0,0,"G","        ","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","Nome Ate               ?","","","mv_ch8","C",30,0,0,"G","naovazio","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"09","Chapa De               ?","","","mv_ch9","C",05,0,0,"G","        ","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SRJ",""})
aAdd(aRegs,{cPerg,"10","Chapa Ate              ?","","","mv_ch10","C",05,0,0,"G","naovazio","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SRJ",""})                                                                                          
aAdd(aRegs,{cPerg,"11","Data Nascimento De     ?","","","mv_ch11","D",10,0,0,"G","        ","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","",""})  
aAdd(aRegs,{cPerg,"12","Data Nascimento Ate    ?","","","mv_ch12","D",10,0,0,"G","naovazio","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","",""})  
aAdd(aRegs,{cPerg,"13","Mes De                 ?","","","mv_ch13","C",02,0,0,"G","        ","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"14","Mes Ate                ?","","","mv_ch14","C",02,0,0,"G","naovazio","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"15","Situacao Funcionario   ?","","","mv_ch15","C",05,0,1,"C","fSituacao","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","","","",""})                                                                                          
aAdd(aRegs,{cPerg,"16","Categorias             ?","","","mv_ch16","C",15,0,1,"C","fCategoria","mv_par16","","","","","","","","","","","","","","","","","","","","","","","","","","",""})                                                                                          
aAdd(aRegs,{cPerg,"17","Imprime Salario        ?","","","mv_ch17","N",01,0,1,"C","naovazio","mv_par17","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","",""}) 
aAdd(aRegs,{cPerg,"18","Imprime Ano Nasc.      ?","","","mv_ch18","N",01,0,1,"C","naovazio","mv_par18","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","",""}) 
aAdd(aRegs,{cPerg,"19","Imprime Est. Civil     ?","","","mv_ch19","N",01,0,1,"C","naovazio","mv_par19","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","",""}) 
aAdd(aRegs,{cPerg,"20","Filial Outra Pag.      ?","","","mv_ch20","N",01,0,1,"C","naovazio","mv_par20","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","",""}) 

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