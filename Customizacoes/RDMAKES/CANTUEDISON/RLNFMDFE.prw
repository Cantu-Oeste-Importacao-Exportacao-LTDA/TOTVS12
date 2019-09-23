#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "report.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RLNFMDFE �Autor �Edison Greski Barbieri � Data � 18/03/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Relat�rio contendo informa��es de notas                     ���
���          �com manifesto.                                              ���
�������������������������������������������������������������������������͹��
���Uso       � Financeiro                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                                                                     

User Function RLNFMDFE()
Private oReport
Private cFile		:= "RLNFMDFE"
Private cPerg		:= "RLNFMDFE01"
Private cTitle		:= "Notas manifestos"
Private cHelp		:= "Este relat�rio ter por objetivo detalhar notas se manisfesto de destinatario."
Private cAliasTMP	:= GetNextAlias()



//�������������������������������������������������������
//Cria o objeto pertinente ao processamento do relat�rio�
//�������������������������������������������������������
oReport := REL01()
oReport:PRINTDIALOG()

Return


Static Function REL01()

Local aOrder := {}

//������������������������������������������������
//Cria o componente de processamento do relat�rio�
//������������������������������������������������
oReport := TReport():New(cFile, cTitle, cPerg, {|oReport| REL01PRINT(oReport)}, cHelp,,"Todas as Notas")
oReport:SetLandscape()
oReport:EndReport(.F.)
oReport:SetTotalInLine(.F.)

//���������������������������������������������������
//Cria a sess�o principal de CHAMADOS do relat�rio	�
//���������������������������������������������������
oSection1 := TRSection():New(oReport,"Notas Manifestos",{"SF2"})
TRCell():New(oSection1, "F2_FILIAL"		, "SF2", "Filial"             ,/*cPicture*/,2,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
TRCell():New(oSection1, "F2_EMISSAO"   	, "SF2", "Emissao"            ,/*cPicture*/,8,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
TRCell():New(oSection1, "F2_DOC"    	, "SF2", "Nota"               ,/*cPicture*/,9,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
TRCell():New(oSection1, "F2_SERIE"      , "SF2", "Serie"              ,/*cPicture*/,3,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
TRCell():New(oSection1, "F2_CLIENTE"	, "SF2", "Cliente"            ,/*cPicture*/,9,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
TRCell():New(oSection1, "F2_LOJA"	    , "SF2", "Loja"               ,/*cPicture*/,4,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
TRCell():New(oSection1, "F2_NUMMDF "	, "SF2", "Manifesto"          ,/*cPicture*/,9,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
TRCell():New(oSection1, "F2_SERMDF"	    , "SF2", "Serie Manifesto"    ,/*cPicture*/,3,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)

Return oReport

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �REL01PRINT     �Autor  �Edison        � Data � 18/03/2018   ���
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
			Column F2_EMISSAO as Date   
			
	 SELECT 
           F2.F2_FILIAL,
           F2.F2_EMISSAO,
           F2.F2_DOC,
           F2.F2_SERIE,
           F2.F2_CLIENTE,
           F2.F2_LOJA,
           F2.F2_NUMMDF,
           F2.F2_SERMDF,	
           CASE WHEN F2.F2_NUMMDF = ' ' AND F2.F2_SERMDF = ' ' THEN '2'
           WHEN F2.F2_NUMMDF <> ' ' AND F2.F2_SERMDF <>' ' THEN '1'
           END 
           FROM %Table:SF2% F2
		           
				   	
		   WHERE   F2.%Notdel%      
		           AND F2.F2_FILIAL  >= %Exp:MV_PAR01%       AND F2.F2_FILIAL  <= %Exp:MV_PAR02%
				   AND F2.F2_EMISSAO >= %Exp:DTOS(MV_PAR03)% AND F2.F2_EMISSAO <= %Exp:DTOS(MV_PAR04)%
		   		   
           GROUP BY F2.F2_FILIAL, F2.F2_EMISSAO, F2.F2_DOC, F2.F2_SERIE, F2.F2_CLIENTE, F2.F2_LOJA, F2.F2_NUMMDF, F2.F2_SERMDF
           HAVING CASE WHEN F2.F2_NUMMDF = ' ' AND F2.F2_SERMDF = ' ' THEN '2'
                       WHEN F2.F2_NUMMDF <> ' ' AND F2.F2_SERMDF <>' ' THEN '1'
                  END = %Exp:MV_PAR05%
            
		   ORDER BY F2.F2_FILIAL, F2.F2_EMISSAO, F2.F2_DOC, F2.F2_NUMMDF
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

