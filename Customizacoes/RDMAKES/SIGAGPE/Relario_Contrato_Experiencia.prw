#INCLUDE "FIVEWIN.CH"
//#INCLUDE "GPER190.CH"
#INCLUDE "report.ch"

/*

�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    � GPER190  � Autor � R.H. - Marcos Stiefano� Data �  04.01.96  ���
���������������������������������������������������������������������������Ĵ��
���Descri��o � Relario Contrato Experiencia / Exame Medico                  ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe   � GPER190(void)                                                ���
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
���Aldo        � 24/03/97 �xxxxxx� Inclusao de cancelamento de impressao.   ���
���Cristina    � 21/05/98 �xxxxxx� Conversao para outros idiomas.           ���
��� Aldo       � 30/03/99 �------� Passagem de nTamanho para SetPrint().    ���
��� Marinaldo  � 27/07/00 �------� Retirada Dos e Validacao Filial/Acesso.  ���
��� Andreia    � 02/09/02 �------� Impressao do campo SRA->RA_VCTEXP2.      ���
��| Tania      �23/12/2005�99401/� Selecao pelo segundo vencimento da expe- ��� 
��|            �          �71079 � riencia (SRA->VCTEXP2).                  ��� 
���Tania 	   �07/07/2006�100158� Conversao em Relatorio personalizavel pa-���
���        	   �          �      � ra atender ao Release 4.                 ���
���Luiz Gustavo|24/01/2007�      �Retiradas funcoes de ajuste de dicionario ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/

USER Function GPER190()
Local	oReport   
Local	aArea 	:= GetArea()
Private	cString	:= "SRA"				// alias do arquivo principal (Base)
Private cPerg	:= "GP190R"
Private aOrd    := {OemToAnsi("Registo"),OemToAnsi("Centro De Custo"),OemToAnsi("Nome")}	//"Matr�cula"###"Centro de Custo"###"Nome"
Private cTitulo	:= OemToAnsi("Relat�rio Exame M�dico / Contrato Experi�ncia")	//"Relatorio Exame M�dico / Contrato Experi�ncia" 

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

GPER190R3()

RestArea( aArea )

Return


Static Function GPER190R3()
LOCAL cDesc1  := "Relat�rio Exame M�dico / Contrato Experi�ncia"		//"Relatorio Exame M�dico / Contrato Experi�ncia"
LOCAL cDesc2  := "Sera impresso de acordo com os par�metro s solicitados pelo"		//"Ser� impresso de acordo com os parametros solicitados pelo"
LOCAL cDesc3  := "Utilizador."		//"usu�rio."
LOCAL cString := "SRA"  					// Alias do arquivo principal (Base)
LOCAL aOrd    := {"Registo","Centro De Custo","Nome","Segmento"}	//"Matr�cula"###"Centro de Custo"###"Nome"

//��������������������������������������������������������������Ŀ
//� Define Variaveis Private(Basicas)                            �
//����������������������������������������������������������������
Private aReturn  := {"C�digo de barras",1,"Administra��o",2,2,1,"",1 }	// "Zebrado"###"Administra��o"
Private NomeProg := "GPER190"
Private aLinha   := {}
Private nLastKey := 0
Private cPerg    := "GPR190CUS"

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
Private AT_PRG   := "GPR190CUS"
Private wCabec0  := 2
Private wCabec1  := ""
Private wCabec2  := ""
Private Contfl   := 1
Private Li       := 0
Private nTamanho := "M"
                          
Validperg()
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
//� mv_par09        //  Data De                                  �
//� mv_par10        //  Data Ate                                 �
//� mv_par11        //  Rela��o 1-Exame Medico 2-Contr. Exper.   �
//� mv_par12        //  Situacoes                                �
//� mv_par13        //  Categorias                               �
//� mv_par14        //  Imprime C.C em Outra Pagina              �
//����������������������������������������������������������������
cTit := " RELA��O DE EXAME MEDICO / CONTRATO DE EXPERIENCIA "		//" RELA��O DE EXAME MEDICO / CONTRATO DE EXPERIENCIA "

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel:="GPER190"            //Nome Default do relatorio em Disco
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
dDataDe    := mv_par09
dDataAte   := mv_par10
nTipRel    := mv_par11
cSituacao  := mv_par12
cCategoria := mv_par13 
cSegDe		:= mv_par15
cSegAte		:= mv_par16
lSalta     := If( mv_par14 == 1 , .T. , .F. )

If	mv_par11 == 1
	Titulo  := " rela��o de exame m�dico "		//" RELACAO DE EXAME MEDICO "
	Wcabec1 := "Mes/ano referencia: " + SubStr(DtoC(dDataBase),4,2)+"/"+SubStr(DtoC(dDataBase),7,IF(nTData==10,4,2))	//"MES/ANO REFERENCIA: "
Else
	Titulo  := " rela��o de vencimentos de contrato de experi�ncia "		//" RELACAO DE VENCIMENTOS DE CONTRATO DE EXPERIENCIA "
	Wcabec1 := "Data de refer�ncia: " + PADR(DtoC(dDataBase),10)		//"DATA REFERENCIA: "
Endif
Wcabec2 := "Filial  c. custo              reg.    nome empregado                      admiss�o    "+If(mv_par11==1,SPACE(02)+"Exame M�dico","Contr.exper.1�. per�od."+" "+"Contr.exper.2�. per�od.") //"FILIAL  C. CUSTO   MATR.   NOME FUNCIONARIO                    DATA ADMISSAO    "###"EXAME MEDICO"###"CONTR.EXPER.1�PERIOD."###"CONTR.EXPER.2�PERIOD."

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| GR190Imp(@lEnd,wnRel,cString)},cTit)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � GPER190  � Autor � R.H. - Marcos Stiefano� Data � 04.01.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relario Contrato Experiencia / Exame Medico                ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � GPR190Imp(lEnd,wnRel,cString)                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros� lEnd        - A��o do Codelock                             ���
���          � wnRel       - T�tulo do relat�rio                          ���
���Parametros� cString     - Mensagem			                             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GR190Imp(lEnd,WnRel,cString)
//��������������������������������������������������������������Ŀ
//� Define Variaveis Locais (Basicas)                            �
//����������������������������������������������������������������
LOCAL CbTxt //Ambiente
LOCAL CbCont
Local aCodFol := {}
Local nCont   := 0

/*
��������������������������������������������������������������Ŀ
� Variaveis de Acesso do Usuario                               �
����������������������������������������������������������������*/
Local cAcessaSRA	:= &( " { || " + ChkRH( "GPER190" , "SRA" , "2" ) + " } " )

dbSelectArea( "SRA" )
If nOrdem == 1
	dbSetOrder( 1 )
ElseIf nOrdem == 2
	dbSetOrder( 2 )
ElseIf nOrdem == 3
	DbSetOrder(3)
ElseIf nOrdem == 4
	dbOrderNickName("CLVLCUS   ")
Endif

DbGoTop()

If nOrdem == 1
	dbSeek(cFilDe + cMatDe,.T.)
	cInicio := "SRA->RA_FILIAL + SRA->RA_MAT"
	cFim    := cFilAte + cMatAte
ElseIf nOrdem == 2
	dbSeek(cFilDe + cCcDe + cMatDe,.T.)
	cInicio := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT"
	cFim    := cFilAte + cCcAte + cMatAte
ElseIf nOrdem == 3
	DbSeek(cFilDe + cNomeDe + cMatDe,.T.)
	cInicio := "SRA->RA_FILIAL + SRA->RA_NOME + SRA->RA_MAT"
	cFim    := cFilAte + cNomeAte + cMatAte 
Elseif nOrdem = 4
	dbSeek(cFilDe + cSegDe,.T.)
	cInicio := "SRA->RA_FILIAL + SRA->RA_X_SEGME"
	cFim    := cFilAte + cSegAte
Endif

cFilialAnt := Space(FWGETTAMFILIAL)
cCcAnt     := Space(9)

dbSelectArea( "SRA" )
SetRegua(SRA->(RecCount()))

While   !EOF() .And. &cInicio <= cFim
	
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
	 If (Sra->Ra_Nome < cNomeDe) .Or. (Sra->Ra_Nome > cNomeAte) .Or. ;
	    (Sra->Ra_Mat < cMatDe) .Or. (Sra->Ra_Mat > cMatAte) .Or. ;
	    (Sra->Ra_CC < cCcDe) .Or. (Sra->Ra_CC > cCCAte) .Or. ;
   	    (Sra->RA_X_SEGME < cSegDe) .Or. (Sra->RA_X_SEGME > cSegAte)
            fTestaTotal()			 
            Loop
	 EndIf
	    
	/*
	�����������������������������������������������������������������������Ŀ
	�Consiste Filiais e Acessos                                             �
	�������������������������������������������������������������������������*/
	IF !( SRA->RA_FILIAL $ fValidFil() ) .or. !Eval( cAcessaSRA )
		fTestaTotal()			 	
	   	Loop
	EndIF

    //��������������������������������������������������������������Ŀ
    //� Verifica Data De / Ate da Data Exame - Data Vencimento       �
    //����������������������������������������������������������������
    If  nTipRel == 1
	    If  DtoS(SRA->RA_EXAMEDI) < DtoS(dDataDe) .Or. DtoS(SRA->RA_EXAMEDI) > DtoS(dDataAte)
		    fTestaTotal()
		    Loop
	    Endif    
    Elseif nTipRel == 2
	    If  (DtoS(SRA->RA_VCTOEXP) < DtoS(dDataDe) .Or. DtoS(SRA->RA_VCTOEXP) > DtoS(dDataAte)) 
	    	If (DtoS(SRA->RA_VCTEXP2) < DtoS(dDataDe) .Or. DtoS(SRA->RA_VCTEXP2) > DtoS(dDataAte))
			    fTestaTotal()
			    Loop
			EndIf
	    Endif    
    Endif

    //��������������������������������������������������������������Ŀ
    //� Verifica Situacao e Categoria do Funcionario                 �
    //����������������������������������������������������������������
    If  !( SRA->RA_SITFOLH $ cSituacao ) .OR. !( SRA->RA_CATFUNC $ cCategoria )
	    fTestaTotal()
	    Loop
    Endif

    //��������������������������������������������������������������Ŀ
    //� Calcula o Bloco para o Funcionario                           �
    //����������������������������������������������������������������
    aPosicao1 := { } // Limpa Arrays
    Aadd( aPosicao1 , { 0 } )

    //��������������������������������������������������������������Ŀ
    //� Atualiza o Bloco para os Totalizadores                       �
    //����������������������������������������������������������������
    nPos0 := nCont + 1
    Atualiza(@aPosicao1,1,nPos0)

    //��������������������������������������������������������������Ŀ
    //� Atualizando Totalizadores                                    �
    //����������������������������������������������������������������
    fAtuCont(@aToTCc1)  // Centro de Custo
    fAtuCont(@aTotFil1) // Filial
    fAtuCont(@aTotEmp1) // Empresa

    //��������������������������������������������������������������Ŀ
    //� Impressao do Funcionario                                     �
    //����������������������������������������������������������������
    fImpFun()

    fTestaTotal()  // Quebras e Skips
EndDo

//��������������������������������������������������������������Ŀ
//� Termino do Relatorio                                         �
//����������������������������������������������������������������
dbSelectArea( "SRA" )
Set Filter to
dbSetOrder(1)
Set Device To Screen
If aReturn[5] = 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif

MS_FLUSH()

*-------------------------------------------*
Static Function Atualiza(aMatriz,nElem,nPos0)
*-------------------------------------------*
aMatriz[nElem,1] := nPos0

Return Nil

*--------------------------*
Static Function fTestaTotal
*--------------------------*
dbSelectArea( "SRA" )
cFilialAnt := SRA->RA_FILIAL              // Iguala Variaveis
If nOrdem <> 4
	cCcAnt     := SRA->RA_CC
Else
	cCcAnt     := SRA->RA_X_SEGME
Endif

dbSkip()

If  Eof() .Or. &cInicio > cFim
	fImpCc()
	fImpFil()
	fImpEmp()
Elseif cFilialAnt # SRA->RA_FILIAL
	fImpCc()
	fImpFil()
Elseif cCcAnt # Iif(nOrdem <> 4,SRA->RA_CC,SRA->RA_X_SEGME)
	fImpCc()
Endif

Return Nil

*------------------------*
Static Function fImpFun()
*------------------------*
Local cVencimento	:= "  /  /  "
cVencimento	:=	IIF(!Empty(DtoC(SRA->RA_VCTOEXP)),DtoC(SRA->RA_VCTOEXP),DtoC(SRA->RA_VCTEXP2))
cDet := "  "+SRA->RA_FILIAL+"    "+Subs(SRA->RA_CC+Space(20),1,20)+"  "+SRA->RA_MAT+"  "+Left(SRA->RA_NOME,30)
cDet += SPACE(8) + PADR(DtoC(SRA->RA_ADMISSA),10)
cDet += Iif(nTipRel == 1 , SPACE(6) + PADR(DtoC(SRA->RA_EXAMEDI),10) , SPACE(10) + PADR(cVencimento,10)+space(10)+PADR(DtoC(SRA->RA_VCTEXP2),10))

Impr(cDet,"C")

Return Nil

*-----------------------*
Static Function fImpCc()
*-----------------------*
Local lRetu1 := .T.

If  Len(aTotCc1) == 0 .Or. !AllTrim(Str(nOrdem)) $ ("2/4")
	Return Nil
Endif

If nOrdem <> 4
	cDet := Repl("-",132)
	Impr(cDet,"C")
	cDet := "Total c.custo -> "+ cCcAnt +" - "+DescCc(cCcAnt,cFilialAnt) + Space(11)		//"TOTAL C.CUSTO -> "
Else
	aArea	:= GetArea()

	DbSelectArea("CTH")
	DbSetOrder(1)
	DbGotop()
	If DbSeek(xFilial("CTH")+cCcAnt)
		cDet := Repl("-",132)
		Impr(cDet,"C")
		cDet := "Total Segmento "+ cCcAnt +" - "+CTH->CTH_DESC01+ Space(11)		//"TOTAL C.CUSTO -> " 
	Else
		cDet := Repl("-",132)
		Impr(cDet,"C")
		cDet := "Total Segmento "+ cCcAnt +" - "+"N�o Cadastrado "+ Space(11)		//"TOTAL C.CUSTO -> " 	
	Endif
	
	RestArea(aArea)
Endif
lRetu1 := fImpComp(aTotCc1) // Imprime
aTotCc1 :={}      // Zera

cDet := Repl("-",132)
Impr(cDet,"C")

//��������������������������������������������������������������Ŀ
//� Salta de Pagina na Quebra de Centro de Custo (lSalta = .T.)  �
//����������������������������������������������������������������
If lSalta
	Impr("","P")
Endif

Return Nil

*------------------------*
Static Function fImpFil()
*------------------------*
Local lRetu1 := .T.
Local cDescFil

If  Len(aTotFil1) == 0
	Return Nil
Endif

If  nOrdem # 2
	cDet := Repl("-",132)
	Impr(cDet,"C")
Endif

cDescFil := aInfo[1] 
cDet     := "Total filial -> " + cFilialAnt+" - " + cDescFil + Space(24)	//"TOTAL FILIAL -> "

lRetu1 := fImpComp(aTotFil1) // Imprime

aTotFil1 :={}      // Zera

cDet := Repl("-",132)
Impr(cDet,"C")

Return Nil

*------------------------*
Static Function fImpEmp()
*------------------------*
Local lRetu1 := .T.

If  Len(aTotEmp1) == 0
	Return Nil
Endif

cDet := "Total empresa -> "+aInfo[3]+Space(3)	//"TOTAL EMPRESA -> "

lRetu1 := fImpComp(aTotEmp1) // Imprime

aTotEmp1 :={}      // Zera

cDet := Repl("-",132)
Impr(cDet,"C")

Impr("","F")

Return Nil

*-------------------------------------------------------------*
Static Function fImpComp(aPosicao) // Complemento da Impressao
*-------------------------------------------------------------*
//��������������������������������������������������������������Ŀ
//� Resultado de Impressao para testar se tudo nao esta zerado   �
//����������������������������������������������������������������
Local nResImp := 0

//��������������������������������������������������������������Ŀ
//� Auxiar para Tratamento do Bloco de Codigo                    �
//����������������������������������������������������������������
AeVal(aPosicao,{ |X| nResImp += X[1] })  // Testa se a Soma == 0

//��������������������������������������������������������������Ŀ
//� Imprime se Possui Valores                                    �
//����������������������������������������������������������������
If  nResImp > 0
	cDet += TRANSFORM(aPosicao[1,1],"@E 999,999,999")
	cDet += If( aPosicao[1,1] == 1 ,"  Empregado","  EMPREGADOS  ")	//"  FUNCIONARIO"###"  FUNCIONARIOS"
	Impr(cDet,"C")
	Return( .T. )
Else
	Return( .F. )
Endif

*---------------------------------------------------------*
Static Function fAtuCont(aArray1)  // Atualiza Acumuladores
*---------------------------------------------------------*
If  Len(aArray1) > 0
	aArray1[1,1] += aPosicao1[1,1]
Else
	aArray1      := Aclone(aPosicao1)
Endif

Return Nil

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
aAdd(aRegs,{cPerg,"09","Periodo De             ?","","","mv_ch9","D",10,0,0,"G","        ","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","",""})  
aAdd(aRegs,{cPerg,"10","Periodo Ate            ?","","","mv_ch10","D",10,0,0,"G","naovazio","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","",""})  
aAdd(aRegs,{cPerg,"11","Relatorio De           ?","","","mv_ch11","N",01,0,1,"C","naovazio","mv_par11","Exame Medico","Exame Medico","Exame Medico","","","Vencto. Exper.","Vencto. Exper.","Vencto. Exper.","","","","","","","","","","","",""}) 
aAdd(aRegs,{cPerg,"12","Situacao Funcionario   ?","","","mv_ch12","C",05,0,1,"C","fSituacao","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","","",""})                                                                                          
aAdd(aRegs,{cPerg,"13","Categorias             ?","","","mv_ch13","C",15,0,1,"C","fCategoria","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","","",""})                                                                                          
aAdd(aRegs,{cPerg,"14","C.C. em Outra Pag.     ?","","","mv_ch14","N",01,0,1,"C","naovazio","mv_par14","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","",""}) 
aAdd(aRegs,{cPerg,"15","Segmento De            ?","","","mv_ch15","C",09,0,0,"G","        ","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
aAdd(aRegs,{cPerg,"16","Segmento Ate           ?","","","mv_ch16","C",09,0,0,"G","naovazio","mv_par16","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})

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