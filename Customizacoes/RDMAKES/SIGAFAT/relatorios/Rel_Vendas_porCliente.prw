//#INCLUDE "MATR780.CH" 
#INCLUDE "FIVEWIN.CH"  


/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MATR780  � Autor � Marco Bianchi         � Data � 19/07/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao de Vendas por Cliente, quantidade de cada Produto, ���
���          � Release 4.                                                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFAT                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function MATR780()

Local oReport
	U_MATR780A()
	
//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR780R3� Autor � Gilson do Nascimento  � Data � 01.09.93 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao de Vendas por Cliente, quantidade de cada Produto  ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � MATR780(void)                                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ���
�������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                   ���
�������������������������������������������������������������������������Ĵ��
��� Bruno        �05.04.00�Melhor�Acertar as colunas para 12 posicoes.    ���
��� Marcello     �29/08/00�oooooo�Impressao de casas decimais de acordo   ���
���              �        �      �com a moeda selecionada e conversao     ���
���              �        �      �(xmoeda)baseada na moeda gravada na nota���
��� Rubens Pante �04/07/01�Melhor�Utilizacao de SELECT nas versoes TOP    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
	


User Function Matr780A()
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
LOCAL wnrel
LOCAL tamanho:=IIF(cPaisLoc=="MEX","G","M")
LOCAL titulo := OemToAnsi("Estatisticas de Vendas (Cliente x Produto)")	//"Estatisticas de Vendas (Cliente x Produto)"
LOCAL cDesc1 := OemToAnsi("Este programa ira emitir a relacao das compras efetuadas pelo Cliente,")	//"Este programa ira emitir a relacao das compras efetuadas pelo Cliente,"
LOCAL cDesc2 := OemToAnsi("totalizando por produto e escolhendo a moeda forte para os Valores.")	//"totalizando por produto e escolhendo a moeda forte para os Valores."
LOCAL cDesc3 := ""
LOCAL cString:= "SD2"

PRIVATE aReturn := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 1, 2, 1, "",1 }		//"Zebrado"###"Administracao"
PRIVATE nomeprog:="MATR780"
PRIVATE nLastKey := 0
PRIVATE cPerg   :="MR780A"

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������

// Ajusta os SXs
PutSx1(cPerg,"18","Grupo Inicial ?","Grupo Inicial ?","Grupo Inicial ?", "mv_gin", "C", 4, 0, ,"G", "", "SBM", "", "","MV_PAR18")
PutSx1(cPerg,"19","Grupo Final ?","Grupo Final ?","Grupo Final ?", "mv_gfi", "C", 4, 0, ,"G", "", "SBM", "", "","MV_PAR19")
PutSx1(cPerg,"20","Armazem Inicial ?","Armazem Inicial ?","Armazem Inicial ?", "mv_ain", "C", 2, 0, ,"G", "", "SZA", "", "","MV_PAR20")
PutSx1(cPerg,"21","Armazem Final ?","Armazem Final ?","Armazem Final ?", "mv_afi", "C", 2, 0, ,"G", "", "SZA", "", "","MV_PAR21")
PutSx1(cPerg,"22","Valor Venda Minimo?","Valor Venda Minimo?","Valor Venda Minimo?", "mv_vvm", "N", 14, 2, ,"G", "", "", "", "","MV_PAR22")
pergunte(cPerg,.F.)
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01             // De Cliente                           �
//� mv_par02             // Ate Cliente                          �
//� mv_par03             // De Data                              �
//� mv_par04             // Ate a Data                           �
//� mv_par05             // De Produto                           �
//� mv_par06             // Ate o Produto                        �
//� mv_par07             // Do Vendedor                          �
//� mv_par08             // Ate Vendedor                         �
//� mv_par09             // Moeda                                �
//� mv_par10             // Inclui Devolu��o                     �
//� mv_par11             // Mascara do Produto                   �
//� mv_par12             // Aglutina Grade                       �
//� mv_par13	// Quanto a Estoque Movimenta/Nao Movta/Ambos    �
//� mv_par14	// Quanto a Duplicata Gera/Nao Gera/Ambos        �
//� mv_par15   // Quanto a Devolucao NF Original/NF Devolucao    �
//� mv_par16   // Quanto a Descricao  Produto  Prod x Cli.       �
//� mv_par17   // converte moeda da devolucao                    �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Monta o Cabecalho de acordo com o tipo de emissao            �
//����������������������������������������������������������������
titulo := "ESTATISTICAS DE VENDAS (Cliente X Produto)"	//"ESTATISTICAS DE VENDAS (Cliente X Produto)"
Cabec1 := "CLIENTE   RAZAO SOCIAL"	//"CLIENTE   RAZAO SOCIAL"
Cabec2 := "PRODUTO         DESCRICAO                  NOTA FISCAL        EMISSAO   UN   QUANTIDADE    PRECO UNITARIO            TOTAL  VENDEDOR" //"PRODUTO         DESCRICAO                  NOTA FISCAL        EMISSAO   UN   QUANTIDADE    PRECO UNITARIO            TOTAL  VENDEDOR"
// 123456789012345 123456789012345678901234567890 123456/123 12/12/1234 123456789012 1234567890123456 1234567890123456 123456/123456/123456/123456/123456

wnrel:="MATR780"

wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho,,.T.)

If nLastKey==27
	dbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| C780Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � C780IMP  � Autor � Rosane Luciane Chene  � Data � 09.11.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR780                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function C780Imp(lEnd,WnRel,cString)

LOCAL CbTxt
LOCAL CbCont,cabec1,cabec2,cabec3
LOCAL nTotCli1:= 0,nTotCli2:=0,nTotGer1 := 0,nTotGer2 := 0
LOCAL nOrdem
LOCAL tamanho:= "P"
LOCAL limite := IIF(cPaisLoc=="MEX",80,80)
LOCAL titulo := OemToAnsi("ESTATISTICAS DE VENDAS (Cliente X Produto)")	//"ESTATISTICAS DE VENDAS (Cliente X Produto)"
LOCAL cDesc1 := OemToAnsi("Este programa ira emitir a relacao das compras efetuadas pelo Cliente,")	//"Este programa ira emitir a relacao das compras efetuadas pelo Cliente,"
LOCAL cDesc2 := OemToAnsi("totalizando por produto e escolhendo a moeda forte para os Valores.")	//"totalizando por produto e escolhendo a moeda forte para os Valores."
LOCAL cDesc3 := ""
LOCAL cMoeda
LOCAL nAcN1  := 0, nAcN2 := 0, nV := 0
LOCAL cClieAnt := "", cProdAnt := "", cLojaAnt := "", cNF := "", cSerie := ""
LOCAL lContinua := .T. , lProcessou := .F. , lNewProd := .T.
LOCAL cMascara :=GetMv("MV_MASCGRD")
LOCAL nTamRef  :=Val(Substr(cMascara,1,2))
LOCAL nTamLin  :=Val(Substr(cMascara,4,2))
LOCAL nTamCol  :=Val(Substr(cMascara,7,2))
LOCAL cProdRef :=""
Local cUM      :=""
LOCAL nTotQuant:=0
LOCAL nReg     :=0
LOCAL cFiltro  := ""
Local cEstoq := If( (mv_par13 == 1),"S",If( (mv_par13 == 2),"N","SN" ))
Local cDupli := If( (mv_par14 == 1),"S",If( (mv_par14 == 2),"N","SN" ))
Local cArqTrab1, cArqTrab2, cCondicao1
Local aDevImpr := {}
Local cVends   := ""
Local nVend    := FA440CntVend()
Local nDevQtd 	:=0
Local nDevVal 	:=0
Local aDev		:={}
Local nIndD2    :=0
Local cQuery, aStru
Local lNfD2Ori   := .F. 
// variaveis criadas para realinhamento das colunas para o Mexico (factura com 20 digitos)
Local aColuna   := IIf(cPaisLoc=="MEX",{46,71,82,86,99,116,135},{10,30,46,76,89,106,125})
#IFDEF TOP
	Local nj := 0
	Local cAliasSA1 := "SA1"
#ENDIF

Private cSD1, cSD2
Private nIndD1  :=0
Private nDecs:=msdecimais(mv_par09)

//��������������������������������������������������������������Ŀ
//� Seleciona ordem dos arquivos consultados no processamento    �
//����������������������������������������������������������������
SF1->(dbsetorder(1))
SF2->(dbsetorder(1))
SB1->(dbSetOrder(1))
SA7->(dbSetOrder(2))

//��������������������������������������������������������������Ŀ
//� Monta o Cabecalho de acordo com o tipo de emissao            �
//����������������������������������������������������������������
titulo := "ESTATISTICAS DE VENDAS (Cliente X Venda)"
Cabec1 := "CLIENTE  RAZAO SOCIAL"

Cabec2 := "          NOTA FISCAL        EMISSAO                   TOTAL"
If cPaisLoc=="MEX"
   Cabec2 := Substr(Cabec2,1,54)+space(10)+Substr(Cabec2,55)
EndIf

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1

cMoeda := "Valores em "+GetMV("MV_SIMB"+Str(mv_par09,1))		//"Valores em "
titulo := titulo+" "+cMoeda

//��������������������������������������������������������������Ŀ
//� Cria filtro para impressao das devolucoes                    �
//� *** este filtro possui 208 posicoes  ***                     �
//����������������������������������������������������������������
dbSelectArea("SD1")
cArqTrab1  := CriaTrab( "" , .F. )
#IFDEF TOP
    If (TcSrvType()#'AS/400')
        //��������������������������������Ŀ
        //� Query para SQL                 �
        //����������������������������������
	    cSD1   := "SD1TMP"
	    aStru  := dbStruct()
	    cQuery := "SELECT * FROM " + RetSqlName("SD1") + " SD1 "
	    cQuery += "WHERE SD1.D1_FILIAL = '"+xFilial("SD1")+"' AND "
	    cQuery += "SD1.D1_FORNECE BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
	    cQuery += "SD1.D1_DTDIGIT BETWEEN '"+DtoS(mv_par03)+"' AND '"+DtoS(mv_par04)+ "' AND "
	    cQuery += "SD1.D1_COD BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' AND "
	    cQuery += "SD1.D1_TIPO = 'D' AND "
    	 cQuery += " NOT ("+IsRemito(3,'SD1.D1_TIPODOC')+ ") AND "
	    cQuery += "SD1.D_E_L_E_T_ <> '*' "
	    cQuery += " AND SD1.D1_GRUPO between '" + MV_PAR18 + "' AND '" + MV_PAR19 + "' "
	    cQuery += " AND SD1.D1_LOCAL BETWEEN '" + MV_PAR20 + "' AND '" + MV_PAR21 + "' "
	    cQuery += " ORDER BY SD1.D1_FILIAL,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_COD"
	    cQuery := ChangeQuery(cQuery)
	    MsAguarde({|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),'SD1TRB', .F., .T.)},OemToAnsi("Selecionando Registros...")) //"Seleccionado registros"
	    For nj := 1 to Len(aStru)
		    If aStru[nj,2] != 'C'
			   TCSetField('SD1TRB', aStru[nj,1], aStru[nj,2],aStru[nj,3],aStru[nj,4])
		    EndIf	
	    Next nj
	    A780CriaTmp(cArqTrab1, aStru, cSD1, "SD1TRB")
	    IndRegua(cSD1,cArqTrab1,"D1_FILIAL+D1_FORNECE+D1_LOJA+D1_COD",,".T.","Selecionando Registros...")		//"Selecionando Registros..."
	Else    
#ENDIF
	    cSD1	   := "SD1"
	    cCondicao1 := 'D1_FILIAL=="' + xFilial("SD1") + '".And.'
	    cCondicao1 += 'D1_FORNECE>="' + mv_par01 + '".And.'
	    cCondicao1 += 'D1_FORNECE<="' + mv_par02 + '".And.'
	    cCondicao1 += 'DtoS(D1_DTDIGIT)>="' + DtoS(mv_par03) + '".And.'
	    cCondicao1 += 'DtoS(D1_DTDIGIT)<="' + DtoS(mv_par04) + '".And.'
	    cCondicao1 += 'D1_COD>="' + mv_par05 + '".And.'
	    cCondicao1 += 'D1_COD<="' + mv_par06 + '".And.'
	    cCondicao1 += 'D1_TIPO=="D" .And. !('+IsRemito(2,'SD1->D1_TIPODOC')+')'	    		

	    cArqTrab1  := CriaTrab("",.F.)
	    IndRegua(cSD1,cArqTrab1,"D1_FILIAL+D1_FORNECE+D1_LOJA+D1_COD",,cCondicao1,"Selecionando Registros...")		//"Selecionando Registros..."
	    nIndD1 := RetIndex()

        #IFNDEF TOP	    
	       dbSetIndex(cArqTrab1+ordBagExt())
        #ENDIF

	    dbSetOrder(nIndD1+1)
#IFDEF TOP
    Endif  	    
#ENDIF   

dbSeek(xFilial("SD1"))

//��������������������������������������������������������������Ŀ
//� Monta filtro para processar as vendas por cliente            �
//����������������������������������������������������������������
DbSelectArea("SD2")
cFiltro := SD2->(dbFilter())
If Empty(cFiltro)
	bFiltro := { || .T. }
Else
	cFiltro := "{ || " + cFiltro + " }"
	bFiltro := &(cFiltro)
Endif
//��������������������������������������������������������������Ŀ
//� Monta filtro para processar as vendas por cliente            �
//����������������������������������������������������������������
cArqTrab2  := CriaTrab( "" , .F. )
#IFDEF TOP            
    If (TcSrvType()#'AS/400')
        //��������������������������������Ŀ
        //� Query para SQL                 �
        //����������������������������������
	    cSD2   := "SD2TMP"
	    aStru  := dbStruct() // D2_FILIAL, D2_DOC, D2_SERIE, D2_EMISSAO, D2_CLIENTE, D2_LOJA, D2_TOTAL, D2_ITEM, D2_COD, D2_GRADE, D2_PEDIDO, D2_QUANT, D2_PRCVEN
	    cQuery := "SELECT * FROM " + RetSqlName("SD2") + " SD2 "
	    cQuery += "WHERE SD2.D2_FILIAL = '"+xFilial("SD2")+"' AND "
	    cQuery += "SD2.D2_CLIENTE BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
	    cQuery += "SD2.D2_EMISSAO BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"' AND "
	    cQuery += "SD2.D2_COD     BETWEEN '"+ mv_par05+"' AND '"+mv_par06+"' AND "
	    cQuery += "SD2.D2_TIPO <> 'B' AND SD2.D2_TIPO <> 'D' AND "
    	cQuery += " NOT ("+IsRemito(3,'SD2.D2_TIPODOC')+ ") AND "
	    cQuery += "SD2.D_E_L_E_T_ <> '*' "
	    // Espec�fico Cantu
	    // filtro quanto a limite de venda dos clientes e filtros de armaz�m e local
	    cQuery += " AND SD2.D2_GRUPO between '" + MV_PAR18 + "' AND '" + MV_PAR19 + "' "
	    cQuery += " AND SD2.D2_LOCAL BETWEEN '" + MV_PAR20 + "' AND '" + MV_PAR21 + "' "
	    if (mv_par22 > 0)
	      cQuery += " AND ((SELECT sum(d.d2_total) from " + RetSqlName("SD2") + " d " 
        cQuery += "     where d.d_e_l_e_t_ <> '*' AND "
        cQuery += "       D.D2_CLIENTE = SD2.D2_CLIENTE AND D.D2_FILIAL = SD2.D2_FILIAL AND "
	      cQuery += "       D.D2_EMISSAO BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"' AND "
	      cQuery += "       D.D2_COD     BETWEEN '"+ mv_par05+"' AND '"+mv_par06+"' AND "
	      cQuery += "       D.D2_TIPO <> 'B' AND SD2.D2_TIPO <> 'D' AND "
    	  cQuery += "       NOT ("+IsRemito(3,'SD2.D2_TIPODOC')+ ") AND "
	      cQuery += "       D.D_E_L_E_T_ <> '*' "
        cQuery += "       AND D.D2_GRUPO between '" + MV_PAR18 + "' AND '" + MV_PAR19 + "' "
        cQuery += "       AND D.D2_LOCAL BETWEEN '" + MV_PAR20 + "' AND '" + MV_PAR21 + "' ) > " + Replace(Transform(MV_PAR22, "@E 9999999999.99"), ",", ".") + ")"	      
	    EndIf
	    // fim do espec�fico Cantu
	    cQuery += "ORDER BY SD2.D2_FILIAL,SD2.D2_CLIENTE,SD2.D2_LOJA,SD2.D2_SERIE, SD2.D2_DOC,SD2.D2_ITEM"
	    cQuery := ChangeQuery(cQuery)
	    MsAguarde({|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),'SD2TRB', .F., .T.)},OemToAnsi("Selecionando Registros...")) //"Seleccionado registros"
	    // monta a mesma estrutra da query
	    ///aStru := SD2TRB->(dbStruct())
	    
	    For nj := 1 to Len(aStru)
		    If aStru[nj,2] != 'C'
			    TCSetField('SD2TRB', aStru[nj,1], aStru[nj,2],aStru[nj,3],aStru[nj,4])
		    EndIf	
	    Next nj

	    CriaTmpSD2(cArqTrab2, aStru, cSD2, "SD2TRB")
	    IndRegua(cSD2,cArqTrab2,"D2_FILIAL+D2_CLIENTE+D2_LOJA+D2_SERIE+D2_DOC+D2_COD+D2_ITEM",,".T.","Selecionando Registros...")		//"Selecionando Registros..."
    Else
#ENDIF                   
	    cSD2	  := "SD2"
	    cCondicao := 'D2_FILIAL == "' + xFilial("SD2") + '" .And. '
	    cCondicao += 'D2_CLIENTE >= "' + mv_par01 + '" .And. '
	    cCondicao += 'D2_CLIENTE <= "' + mv_par02 + '" .And. '
	    cCondicao += 'DTOS(D2_EMISSAO) >= "' + DTOS(mv_par03) + '" .And. '
	    cCondicao += 'DTOS(D2_EMISSAO) <= "' + DTOS(mv_par04) + '" .And. '
	    cCondicao += 'D2_COD >= "' + mv_par05 + '" .And. '
	    cCondicao += 'D2_COD <= "' + mv_par06 + '" .And. '
	    cCondicao += '!(D2_TIPO $ "BD")'
	    cCondicao += '.And. !('+IsRemito(2,'SD2->D2_TIPODOC')+')'		
 
	    IndRegua(cString,cArqTrab2,"D2_FILIAL+D2_CLIENTE+D2_LOJA+D2_COD+D2_SERIE+D2_DOC+D2_ITEM",,cCondicao,"Selecionando Registros...")		//"Selecionando Registros..."
	    nIndD2 := RetIndex()

        #IFNDEF TOP	    
	       dbSetIndex(cArqTrab2+ordBagExt())
        #ENDIF
        
	    dbSetOrder(nIndD2+1)
#IFDEF TOP	    
	Endif    
#ENDIF


dbSelectArea("SA1")
dbSetOrder(1)
#IFDEF TOP
    cAliasSA1 := GetNextAlias()
    aStru  := dbStruct()
    cQuery := "SELECT A1_FILIAL,A1_COD,A1_LOJA,A1_NOME,A1_OBSERV "    
    cQuery += "FROM " + RetSqlName("SA1") + " SA1 "
    cQuery += "WHERE SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND "
    cQuery += "SA1.A1_COD >= '"        +MV_PAR01+"' AND "
	  cQuery += "SA1.A1_COD <= '"        +MV_PAR02+"' AND "
	  // filtro de grupo e armaz�m
	  
    cQuery += "SA1.D_E_L_E_T_ = ' ' "
    cQuery += " ORDER BY "+SqlOrder(SA1->(IndexKey()))
    cQuery := ChangeQuery(cQuery)
    dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cAliasSA1, .F., .T.)
#ELSE
	cAliasSA1 := "SA1"
#ENDIF

//��������������������������������������������������������������Ŀ
//� Verifica se aglutinara produtos de Grade                     �
//����������������������������������������������������������������
SetRegua(RecCount())		// Total de Elementos da regua

If ( (cSD2)->D2_GRADE=="S" .And. MV_PAR12 == 1)
	lGrade := .T.
	bGrade := { || Substr((cSD2)->D2_COD, 1, nTamref) }
Else
	lGrade := .F.
	bGrade := { || (cSD2)->D2_COD }
Endif
//��������������������������������������������������������������Ŀ
//� Procura pelo 1o. cliente valido                              �
//����������������������������������������������������������������
#IFNDEF TOP
	dbSeek(xFilial()+mv_par01, .t.)
#ENDIF

While (cAliasSA1)->( ! EOF() .AND. A1_COD <= MV_PAR02 ) .And. lContinua .And. (cAliasSA1)->A1_FILIAL == xFilial("SA1")
	
	If lEnd
		@Prow()+1,001 Psay "CANCELADO PELO OPERADOR"	//"CANCELADO PELO OPERADOR"
		lContinua := .F.
		Exit
	EndIf
	
	lNewCli := .T.
	
	//����������������������������������������������������������Ŀ
	//� Procura pelas saidas daquele cliente                     �
	//������������������������������������������������������������
	DbSelectArea(cSD2)
	If DbSeek(xFilial("SD2")+(cAliasSA1)->A1_COD+(cAliasSA1)->A1_LOJA)
		lRet:=ValidMasc((cSD2)->D2_COD,MV_PAR11)
		
		//����������������������������������������������������������Ŀ
		//� Montagem da quebra do relatorio por  Cliente             �
		//������������������������������������������������������������
		cClieAnt := (cAliasSA1)->A1_COD
		cLojaAnt := (cAliasSA1)->A1_LOJA		
		lNewNF := .F.
		lNewCli  := .T.
		nTotCli1 := 0
		nTotCli2 := 0
		While !Eof() .and. ;
			((cSD2)->(D2_FILIAL+D2_CLIENTE+D2_LOJA)) == (xFilial("SD2")+cClieAnt+cLojaAnt)
			
			//����������������������������������������������������������Ŀ
			//� Verifica Se eh uma tipo de nota valida                   �
			//� Verifica intervalo de Codigos de Vendedor                �
			//� Valida o produto conforme a mascara                      �
			//������������������������������������������������������������
			lRet:=ValidMasc((cSD2)->D2_COD,MV_PAR11)
			If	! Eval(bFiltro) .Or. !A780Vend(@cVends,nVend) .Or. !lRet //.or. SD2->D2_TIPO$"BD" ja esta no filtro
				dbSkip()
				Loop
			EndIf
			
			//����������������������������������������������������������Ŀ
			//� Impressao do Cabecalho.                                  �
			//������������������������������������������������������������
			If Li > 55
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
				lProcessou := .T.
			EndIf
			
			
			//����������������������������������������������������������Ŀ
			//� Impressao da quebra por NF                     �
			//������������������������������������������������������������
			cProdAnt := Eval(bGrade)
			lNewProd := .T.
			
			While ! Eof() .And. ;
				(cSD2)->(D2_FILIAL + D2_CLIENTE + D2_LOJA) == ;
				( xFilial("SD2") + cClieAnt   + cLojaAnt)
				IncRegua()
				
				//����������������������������������������������������������Ŀ
				//� Avalia TES                                               �
				//������������������������������������������������������������
				lRet:=ValidMasc((cSD2)->D2_COD,MV_PAR11)
				If !AvalTes((cSD2)->D2_TES,cEstoq,cDupli) .Or. !Eval(bFiltro) .Or. !lRet
					dbSkip()
					Loop
				Endif
				
				If !A780Vend(@cVends,nVend)
					dbskip()
					Loop
				Endif
				
				//����������������������������������������������������������Ŀ
				//� Impressao  dos dados do Cliente                          �
				//������������������������������������������������������������
				If lNewCli
					
					If Li > 51
						cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
						lProcessou := .T.
					EndIf
					
					@ Li,000 Psay Repli('-',limite)
					Li++
					@ Li,000 Psay (cSD2)->D2_CLIENTE+"   "+(cAliasSA1)->A1_NOME
					If !Empty((cAliasSA1)->A1_OBSERV)
						Li++
						@ Li,000 Psay "Obs.: "+(cAliasSA1)->A1_OBSERV		//"Obs.: "
					EndIf
					Li++
					lNewCli := .F.
				Endif
				
				//����������������������������������������������������������Ŀ
				//� Impressao do Cabecalho.                                  �
				//������������������������������������������������������������
				If li > 55
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
					@ Li,000 Psay Repli('-',limite)
					Li++
					@ Li,000 Psay (cSD2)->D2_CLIENTE+"   "+(cAliasSA1)->A1_NOME
					If !Empty((cAliasSA1)->A1_OBSERV)
						Li++
						@ Li,000 Psay "Obs.: "+(cAliasSA1)->A1_OBSERV		//"Obs.: "
					EndIf
					Li+=2
				EndIf
				
				cNF := (cSD2)->D2_Doc
				cSerie := (cSD2)->D2_Serie
				
				nTotNF := 0
				
				While(cNF + cSerie == (cSD2)->D2_Doc + (cSD2)->D2_Serie)// na mesma NF
				
					nDevQtd :=0
					nDevVal :=0					
					If mv_par10 == 1 //inclui Devolucoes
						SomaDev(@nDevQtd, @nDevVal , @aDev, cEstoq, cDupli)
					EndIf
					
					nTotQuant := (cSD2)->D2_QUANT
						
					//����������������������������������������������������������Ŀ
					//� Imprime os dados da NF                                   �
					//������������������������������������������������������������
					
					SF2->(dbSeek(xFilial("SF2")+(cSD2)->(D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)))
					cUM := (cSD2)->D2_UM
					
					nAcN1 += nTotQuant
					
					//����������������������������������������������������������Ŀ
					//� Faz Verificacao da Moeda Escolhida e Imprime os Valores  �
					//������������������������������������������������������������
					nVlrUnit := xMoeda((cSD2)->D2_PRCVEN,SF2->F2_MOEDA,MV_PAR09,(cSD2)->D2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA)
					
					If (cSD2)->D2_TIPO $ "CIP"
						nTotNF += nVlrUnit
						
					Else
						If (cSD2)->D2_GRADE == "S" .And. MV_PAR12 == 1 // Aglutina Grade
							nVlrTot:= nVlrUnit * nTotQuant				
						Else						
							nVlrTot:=xmoeda((cSD2)->D2_TOTAL,SF2->F2_MOEDA,mv_par09,(cSD2)->D2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA)
						EndIf
						nTotNF += nVlrTot
					EndIf
					
					A780Vend(@cVends,nVend)				
					//For nV := 8 to Len(cVends)
						//li ++				
						//nV += 6
					//Next
	
					//����������������������������������������������������������Ŀ
					//� Imprime as devolucoes do produto selecionado             �
					//������������������������������������������������������������
					If nDevQtd!=0
						//Li++
						//@Li,023 Psay "DEV" // "DEV"
						nVlrTot:= nDevVal
						//@Li,aColuna[3] Psay cUM
						//@Li,aColuna[4] Psay nDevQtd          PICTURE "@)"+PesqPictqt("D2_QUANT",14)
						//@Li,aColuna[6] Psay nVlrTot          PICTURE "@)"+PesqPict("SD2","D2_TOTAL",16,mv_par09)
						nAcN1+= nDevQtd
						nTotNF+= nVlrTot
					EndIf
					//Li++
				  dbSkip()
				  
				EndDo// mudou a NF
				@Li, aColuna[1] Psay (cSD2)->(D2_DOC+'/'+D2_SERIE)
				@Li, aColuna[2] Psay (cSD2)->D2_EMISSAO
				@Li, aColuna[3] Psay nTotNF  PICTURE PesqPict("SD2","D2_TOTAL",16,mv_par09)
				
				Li++
				
				nAcN2 += nTotNF
				
				nTotQuant := 0
			EndDo
			
			//����������������������������������������������������������Ŀ
			//� Acumula o total geral do relatorio                       �
			//������������������������������������������������������������
			nTotGer1 += nAcN1
			nTotGer2 += nAcN2
			
			//����������������������������������������������������������Ŀ
			//� Acumula o total por cliente                              �
			//������������������������������������������������������������
			nTotCli1 += nAcN1
			nTotCli2 += nAcN2
			
			//����������������������������������������������������������Ŀ
			//� Imprime o total do produto selecionado                   �
			//������������������������������������������������������������
			If nAcN1#0 .Or. nAcN2#0	.Or. nDevQtd#0
				//Li++
				//@Li ,  07 Psay "TOTAL DO PRODUTO - "+cProdAnt	//"TOTAL DO PRODUTO - "
				//@Li ,  52 Psay "---->"
				//@Li , aColuna[3] Psay cUM
				//@Li , aColuna[4] Psay nAcN1 PICTURE PesqPictqt("D2_QUANT",14)
				//@Li , aColuna[6] Psay nAcN2 PICTURE PesqPict("SD2","D2_TOTAL",16,mv_par09)
				nAcN1 := 0
				nAcN2 := 0
				cProdAnt := (cSD2)->D2_COD
			EndIf
			
		EndDo
		//����������������������������������������������������������Ŀ
		//� Ocorreu quebra por cliente                               �
		//������������������������������������������������������������
		If !(lNewCli)
			LI+=2
			@Li , 07 Psay "TOTAL DO CLIENTE - "+cClieAnt+'/'+cLojaAnt	//"TOTAL DO CLIENTE - "
			@Li , 42 Psay "---->"
			//@Li ,aColuna[4] Psay nTotCli1 PICTURE PesqPictqt("D2_QUANT",16)
			@Li ,aColuna[3] Psay nTotCli2 PICTURE PesqPict("SD2","D2_TOTAL",16,mv_par09)
			LI++
		EndIf
		cClieAnt := ""
		cLojaAnt := ""
		nTotCli1 := 0
		nTotCli2 := 0
		
	EndIf
	//�������������������������������������������������������������Ŀ
	//� Procura pelas devolucoes dos clientes que nao tem NF SAIDA  �
	//���������������������������������������������������������������
	nTotCli1 := 0
	nTotCli2 := 0
	DbSelectArea(cSD1)
	If DbSeek(xFilial("SD1")+(cAliasSA1)->A1_COD+(cAliasSA1)->A1_LOJA)
		lRet:=ValidMasc((cSD1)->D1_COD,MV_PAR11)
		//����������������������������������������������������������Ŀ
		//� Procura as devolucoes do periodo, mas que nao pertencem  �
		//� as NFS ja impressas do cliente selecionado               �
		//������������������������������������������������������������
		If mv_par10 == 1  // Inclui Devolucao
			
			//��������������������������Ŀ
			//� Soma Devolucoes          �
			//����������������������������
			While (cSD1)->(D1_FILIAL + D1_FORNECE + D1_LOJA) == ;
				( xFilial("SD1") + (cAliasSA1)->A1_COD+ (cAliasSA1)->A1_LOJA)  .AND. ! Eof()
				lRet:=ValidMasc((cSD1)->D1_COD,MV_PAR11)
				
				//�������������������������������������Ŀ
				//� Verifica Vendedores da N.F.Original �
				//���������������������������������������
				
				CtrlVndDev := .F.
				lNfD2Ori   := .F.
				If AvalTes((cSD1)->D1_TES,cEstoq,cDupli)
					dbSelectArea("SD2")
					nSavOrd := IndexOrd()
					dbSetOrder(3)

					dbSeek(xFilial("SD2")+(cSD1)->(D1_NFORI+D1_SERIORI+D1_FORNECE+D1_LOJA+D1_COD))
					While !Eof() .And. (xFilial("SD2")+(cSD1)->(D1_NFORI+D1_SERIORI+D1_FORNECE+D1_LOJA+D1_COD)) == ;
						D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD
					
						lRet:=ValidMasc((cSD1)->D1_COD,MV_PAR11)
					
						If !Empty((cSD1)->D1_ITEMORI) .AND. AllTrim((cSD1)->D1_ITEMORI) != D2_ITEM .Or. !lRet .Or. !Eval(bFiltro)
							dbSkip()
							Loop
						Else
							CtrlVndDev := A780Vend(@cVends,nVend)
							If Ascan(aDev,D2_CLIENTE + D2_LOJA + D2_COD + D2_DOC + D2_SERIE + D2_ITEM) > 0
								lNfD2Ori := .T.
							EndIf
						Endif
						dbSkip()
					End
				
					dbSelectArea("SD2")
					dbSetOrder(nSavOrd)
					dbSelectArea(cSD1)
				
					If !(CtrlVndDev) .Or. lNfD2Ori
						dbSkip()
						Loop
					EndIf
				
					lProcessou := .t.
				
					If li > 55
						cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
					EndIf
				
					If lNewCli
					
						If li > 51
							cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
						EndIf
					
						@ Li,000 Psay Repli('-',limite)
					
						Li++
						@ Li,000 Psay (cAliasSA1)->A1_COD
						@ Li,009 Psay (cAliasSA1)->A1_NOME
						If !Empty((cAliasSA1)->A1_OBSERV)
							Li++
							@ Li,000 Psay "Obs.: "+(cAliasSA1)->A1_OBSERV		//"Obs.: "
						EndIf
					
						Li+=2
					
						lNewCli := .F.
					
					EndIf
				
					LI++
					SF1->(dbSeek(xFilial("SF1")+(cSD1)->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)))
					cUM := (cSD1)->D1_UM
				
					//@Li ,  0 Psay (cSD1)->D1_COD
					@li , 5 Psay "DEV" //"DEV"
					@Li , aColuna[1] Psay (cSD1)->(D1_DOC+'/'+D1_SERIE) // 
					nVlrTot:=xMoeda((cSD1)->(D1_TOTAL-D1_VALDESC),SF1->F1_MOEDA,mv_par09,(cSD1)->D1_DTDIGIT,nDecs,SF1->F1_TXMOEDA)
					//@Li,aColuna[3] Psay cUM
					//@Li,aColuna[4] Psay -(cSD1)->D1_QUANT PICTURE "@)"+PesqPictqt("D1_QUANT",14)
					@Li,aColuna[3] Psay -nVlrTot           PICTURE PesqPict("SD1","D1_TOTAL",16,mv_par09)
					nTotCli1 -= (cSD1)->D1_QUANT
					nTotCli2 -= nVlrTot
					nTotGer1 -= (cSD1)->D1_QUANT
					nTotGer2 -= nVlrTot
				Endif
				dbSkip()
			EndDo
			
			If (nTotCli1 != 0) .or. (nTotCli2 != 0)
				LI+=2
				@Li , 07 Psay "TOTAL DO CLIENTE - "+(cAliasSA1)->A1_COD	//"TOTAL DO CLIENTE - "
				@Li , 40 Psay "---->"
				//@Li ,aColuna[4] Psay nTotCli1 PICTURE "@)"+PesqPictqt("D2_QUANT",16)
				@Li ,aColuna[3] Psay nTotCli2 PICTURE PesqPict("SD2","D2_TOTAL",16,mv_par09)
				LI+=1
			EndIf
			
		EndIf
		
	Endif
	
	DbSelectArea(cAliasSA1)
	DbSkip()
EndDo

If lProcessou
	If li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
	EndIf
	Li+=2
	@Li , 07 PSay "T O T A L   G E R A L       ---->"
  //@Li ,aColuna[4] Psay nTotGer1 PICTURE "@)"+PesqPictqt("D2_QUANT",16)
  @Li ,aColuna[3] Psay nTotGer2 PICTURE PesqPict("SD2","D2_TOTAL",16,mv_par09)
	roda(cbcont,cbtxt,tamanho)
Endif

dbSelectArea("SD1")
dbClearFilter()
RetIndex("SD1")

dbSelectArea("SD2")
dbClearFilter()
RetIndex("SD2")

(cSD1)->(DbCloseArea())
(cSD2)->(DbCloseArea())
fErase(cArqTrab1+OrdBagExt())
fErase(cArqTrab2+OrdBagExt())
#IFDEF TOP
    fErase(cArqTrab1+GetDbExtension())
    fErase(cArqTrab2+GetDbExtension())
#ENDIF

If aReturn[5] = 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
EndIf

MS_FLUSH()

Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � A780Vend � Autor � Rogerio F. Guimaraes  � Data � 28.10.97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica Intervalo de Vendedores                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR780			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function A780Vend(cVends,nVend)
Local cAlias:=Alias(),sVend,sCampo
Local lVend, cVend, cBusca
Local nx
lVend  := .F.
cVends := ""
// Nao tem Alias na frente dos campos do SD2 para poder trabalhar em DBF e TOP
cBusca := xFilial("SF2")+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA
dbSelectArea("SF2")
If dbSeek(cBusca)
	cVend := "1"
	For nx := 1 to nVend
		sCampo := "F2_VEND" + cVend
		sVend := FieldGet(FieldPos(sCampo))
		If !Empty(sVend)
			cVends += If(Len(cVends)>0,"/","") + sVend
		EndIf
		If (sVend >= mv_par07 .And. sVend <= mv_par08) .And. (nX == 1 .Or. !Empty(sVend))
			lVend := .T.
		EndIf
		cVend := Soma1(cVend, 1)
	Next
EndIf
dbSelectArea(cAlias)
Return(lVend)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � SomaDev  � Autor � Claudecino C Leao     � Data � 28.09.98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Soma devolucoes de Vendas                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR780			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function SomaDev(nDevQtd, nDevVal, aDev, cEstoq, cDupli )

Local DtMoedaDev  := (cSD2)->D2_EMISSAO

If (cSD1)->(dbSeek(xFilial("SD1")+(cSD2)->(D2_CLIENTE + D2_LOJA + D2_COD )))
	//��������������������������Ŀ
	//� Soma Devolucoes          �
	//����������������������������
	While (cSD1)->(D1_FILIAL+D1_FORNECE+D1_LOJA+D1_COD) == (cSD2)->( xFilial("SD2")+D2_CLIENTE+D2_LOJA+D2_COD).AND.!(cSD1)->(Eof())                   
	
		//����������������������������������������������������������Ŀ
		//� Avalia TES                                               �
		//������������������������������������������������������������
		If !AvalTes((cSD1)->D1_TES,cEstoq,cDupli)
	        (cSD1)->(dbSkip())
			Loop
		Endif
	
        DtMoedaDev  := IIF(MV_PAR17 == 1,(cSD1)->D1_DTDIGIT,(cSD2)->D2_EMISSAO)

		SF1->(dbSeek(xFilial("SF1")+(cSD1)->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)))

		If (cSD1)->(D1_NFORI + D1_SERIORI + AllTrim(D1_ITEMORI)) == (cSD2)->(D2_DOC   + D2_SERIE   + D2_ITEM )

			Aadd(aDev, (cSD1)->(D1_FORNECE + D1_LOJA + D1_COD + D1_NFORI + D1_SERIORI + AllTrim(D1_ITEMORI)))
			nDevQtd -= (cSD1)->D1_QUANT
			nDevVal -=xMoeda((cSD1)->(D1_TOTAL-D1_VALDESC),SF1->F1_MOEDA,mv_par09,DtMoedaDev,nDecs+1,SF1->F1_TXMOEDA)

		ElseIf mv_par15 == 2 .And. (cSD1)->D1_DTDIGIT < (cSD2)->D2_EMISSAO .And.;
			   (cSD1)->(D1_NFORI + D1_SERIORI + AllTrim(D1_ITEMORI)) < ;
			   (cSD2)->(D2_DOC   + D2_SERIE   + D2_ITEM ) .And.;
			   Ascan(aDev, (cSD1)->(D1_FORNECE + D1_LOJA + D1_COD + D1_NFORI + D1_SERIORI + AllTrim(D1_ITEMORI))) == 0

			Aadd(aDev, (cSD1)->(D1_FORNECE + D1_LOJA + D1_COD + D1_NFORI + D1_SERIORI + AllTrim(D1_ITEMORI)))
			nDevQtd -= (cSD1)->D1_QUANT
			nDevVal -=xMoeda((cSD1)->(D1_TOTAL-D1_VALDESC),SF1->F1_MOEDA,mv_par09,DtMoedaDev,nDecs+1,SF1->F1_TXMOEDA)

		EndIf

        (cSD1)->(dbSkip())

	EndDo

EndIf
Return .t.
/*����������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Funcao    �A780CriaTmp� Autor � Rubens Joao Pante     � Data � 04/07/01 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Cria temporario a partir da consulta corrente (TOP)          ���
��������������������������������������������������������������������������Ĵ��
��� Uso      �MATR780 (TOPCONNECT)                                         ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
����������������������������������������������������������������������������*/
Static Function A780CriaTmp(cArqTmp, aStruTmp, cAliasTmp, cAlias)
	Local nI, nF, nPos
	Local cFieldName := ""
	nF := (cAlias)->(Fcount())
    dbCreate(cArqTmp,aStruTmp)
    DbUseArea(.T.,,cArqTmp,cAliasTmp,.T.,.F.)
	(cAlias)->(DbGoTop())
	While ! (cAlias)->(Eof())
        (cAliasTmp)->(DbAppend())
		For nI := 1 To nF 
			cFieldName := (cAlias)->( FieldName( ni ))
		    If (nPos := (cAliasTmp)->(FieldPos(cFieldName))) > 0
		   		    (cAliasTmp)->(FieldPut(nPos,(cAlias)->(FieldGet((cAlias)->(FieldPos(cFieldName))))))
            EndIf   		
		Next
		(cAlias)->(DbSkip())
	End
	(cAlias)->(dbCloseArea())
    DbSelectArea(cAliasTmp)
Return Nil


/*����������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Funcao    �A780CriaTmp� Autor � Rubens Joao Pante     � Data � 04/07/01 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Cria temporario a partir da consulta corrente (TOP)          ���
��������������������������������������������������������������������������Ĵ��
��� Uso      �MATR780 (TOPCONNECT)                                         ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
����������������������������������������������������������������������������*/
Static Function CriaTmpSD2(cArqTmp, aStruTmp, cAliasTmp, cAlias)
Local nI, nF, nPos
Local cFieldName := ""
Local cCliente := ""
Local cLoja := ""
Local cNF := ""
Local cSerie := ""
nF := (cAlias)->(Fcount())
dbCreate(cArqTmp,aStruTmp)
DbUseArea(.T.,,cArqTmp,cAliasTmp,.T.,.F.)
(cAlias)->(DbGoTop())
While ! (cAlias)->(Eof())
  (cAliasTmp)->(DbAppend())
  For nI := 1 To nF 
  	cFieldName := (cAlias)->( FieldName( ni ))
    If (nPos := (cAliasTmp)->(FieldPos(cFieldName))) > 0
   	  (cAliasTmp)->(FieldPut(nPos,(cAlias)->(FieldGet((cAlias)->(FieldPos(cFieldName))))))
		EndIf   		
	Next
	cNF := (cAlias)->D2_DOC
	cSerie := (cAlias)->D2_Serie
	(cAlias)->(DbSkip())	
EndDo
(cAlias)->(dbCloseArea())
DbSelectArea(cAliasTmp)
Return Nil