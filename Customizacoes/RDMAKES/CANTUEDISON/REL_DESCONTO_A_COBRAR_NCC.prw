#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "report.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RELAGEDEV �Autor �Edison Greski Barbieri � Data � 05/06/2019���
�������������������������������������������������������������������������͹��
���Desc.     �Relat�rio contendo informa��es de titulos desconto a ser    ���
���          �cobrado em lan�amentos de NCC                               ���
�������������������������������������������������������������������������͹��
���Uso       � Financeiro                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RDESCCOB()
	Private oReport
	Private cFile		:= "RDESCCOB"
	Private cPerg		:= "RTITSDES01"
	Private cTitle		:= "Desconto a cobrar lan�amento de NCC"
	Private cHelp		:= "Este relat�rio ter por objetivo detalhar os desconto a ser cobrado no lan�amento de NCC."
	Private cAliasTMP	:= GetNextAlias()

	//�������������������������������������������������������
	//Cria o objeto pertinente ao processamento do relat�rio�
	//�������������������������������������������������������
	oReport := REL01()
	oReport:PRINTDIALOG()

Return

Static Function REL01()

	Local aOrder := {}
	Local oBreak

	//������������������������������������������������
	//Cria o componente de processamento do relat�rio�
	//������������������������������������������������
	oReport := TReport():New(cFile, cTitle, cPerg, {|oReport| REL01PRINT(oReport)}, cHelp,,"Todos os t�tulos")
	oReport:SetLandscape()
	oReport:EndReport(.F.)
	oReport:SetTotalInLine(.T.)

	//���������������������������������������������������
	//Cria a sess�o principal de CHAMADOS do relat�rio	�
	//���������������������������������������������������
	oSection1 := TRSection():New(oReport,"Titulos",{"SE1"})
	TRCell():New(oSection1, "E1_FILIAL"           , "SE1", "Filial"              ,/*cPicture*/,2,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "E1_NUM"   	          , "SE1", "T�tulo"              ,/*cPicture*/,9,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "E1_PARCELA"	      , "SE1", "Parcela"             ,/*cPicture*/,3,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "E1_CLIENTE"	      , "SE1", "Cliente"             ,/*cPicture*/,9,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "E1_LOJA"	          , "SE1", "Loja"                ,/*cPicture*/,4,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "E1_NOMCLI"   	      , "SE1", "Nome Fornec"         ,/*cPicture*/,40,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "E1_EMISSAO"          , "SE1", "Emiss�o"             ,/*cPicture*/,9,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "E1_VENCREA"	      , "SE1", "Vencimento"          ,/*cPicture*/,8,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "E1_VALOR"            , "SE1", "Vlr T�tulo lan�ado"  ,/*cPicture*/,15,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "E1_DESCFIN"	      , "SE1", "Desc Finan"          ,/*cPicture*/,15,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "PER_DESC"            , "SE1", "Desc a ser Cobrado"  ,/*cPicture*/,15,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "VLR_BOLETO"          , "SE1", "Vlr boleto a cobrar" ,/*cPicture*/,15,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)

	//���������������������������������������������������������������
	//	�
	//���������������������������������������������������������������

	//O break quebra a linha pelo campo que deseja por fornecedor
	oBreak := TRBreak():New(oSection1,{|| (cAliasTMP)->(E1_CLIENTE) },"Total por Cliente:")
	//faz a soma do conteudo desejado e1_valor
	TRFunction():New(oSection1:Cell("PER_DESC"),NIL,"SUM" , oBreak, ,"@E 999,999.99",,.F.,.T.)
	TRFunction():New(oSection1:Cell("VLR_BOLETO"),NIL,"SUM" , oBreak, ,"@E 999,999.99",,.F.,.T.)

	//TRFunction():New(oSection1:Cell("E2_VALOR"),NIL,"SUM",,,,,.F.,.T.)

Return oReport

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �REL01PRINT     �Autor  �Edison        � Data � 05/06/2019   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function REL01PRINT(oReport)
	Local oSection1		:= oReport:Section(1)
	Local oSection2		:= oReport:Section(1):Section(1)

	//������������������������������������������������
	//Efetua montagem da Query da SESS�O DE CHAMADOS �
	//������������������������������������������������
	BEGIN REPORT QUERY oSection1

		BEGINSQL Alias cAliasTMP
			Column E1_EMISSAO as Date
			Column E1_VENCREA as Date

			SELECT
			E1.E1_FILIAL,           
			E1.E1_NUM,   	          
			E1.E1_PARCELA,	      
			E1.E1_CLIENTE,	      
			E1.E1_LOJA,	          
			E1.E1_NOMCLI,   	      
			E1.E1_EMISSAO,          
			E1.E1_VENCREA,	      
			E1.E1_VALOR,            
			E1.E1_DESCFIN,	      
			ROUND(E1.E1_DESCFIN * E1.E1_VALOR / 100, 2) AS PER_DESC,
			ROUND(E1_VALOR - E1_DESCFIN * E1_VALOR / 100, 2) AS VLR_BOLETO

		FROM %Table:SE1% E1
			WHERE   E1.%Notdel%
			AND E1.E1_FILIAL   >= %Exp:MV_PAR01%       AND E1.E1_FILIAL    <= %Exp:MV_PAR02%
			AND E1.E1_CLIENTE  >= %Exp:mv_par03%       AND E1.E1_CLIENTE   <=  %Exp:mv_par04%
			AND E1.E1_LOJA     >= %Exp:mv_par05%       AND E1.E1_LOJA      <=  %Exp:mv_par06%
			AND E1.E1_EMISSAO  >= %Exp:DtoS(mv_par07)% AND E1.E1_EMISSAO   <=  %Exp:DtoS(mv_par08)%
			AND E1.E1_VENCREA  >= %Exp:DtoS(mv_par09)% AND E1.E1_VENCREA    <=  %Exp:DtoS(mv_par10)%
			AND E1_DESCFIN > 0
			AND E1_SALDO > 0
			AND E1_TIPO = 'NCC' 
	

	ORDER BY E1.E1_FILIAL, E1.E1_NUM, E1.E1_PARCELA, E1.E1_CLIENTE, E1.E1_LOJA, E1.E1_EMISSAO
	ENDSQL

	END REPORT QUERY oSection1

	//�������������������������������������������
	//Seta regra de contador do processamento	�
	//�������������������������������������������

	oReport:SetMeter((cAliasTMP)->(RECCOUNT()))

	//�����������������������������������������������
	//Executa a impress�o das sess�es do relat�rio	�
	//�����������������������������������������������
	oSection1:Print()

Return

