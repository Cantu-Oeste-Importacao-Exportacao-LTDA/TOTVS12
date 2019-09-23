#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "report.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RELBXREC �Autor �Edison Greski Barbieri � Data � 13/07/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     �Relat�rio contendo informa��es de baixas por                ���
���          �recibos.                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � Financeiro                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RELBXREC()
Private oReport
Private cFile		:= "RELBXREC"
Private cPerg		:= "RELBXREC01"
Private cTitle		:= "Baixas por recibos"
Private cHelp		:= "Este relat�rio ter por objetivo detalhar informa��es de baixas por recibos."
Private cAliasTMP	:= GetNextAlias()


//���������������������������������������������������������������
//Executa fun��es de verifica��o do grupo de perguntas utilizado�
//���������������������������������������������������������������
VldPerg(cPerg)  // Chama funcao VldPerg para Verificar se as Perguntas existem no SX1, se nao existir cria

//AjusteSX1(cPerg)
PERGUNTE(cPerg,.F.)

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
oReport := TReport():New(cFile, cTitle, cPerg, {|oReport| REL01PRINT(oReport)}, cHelp,,"Todos os t�tulos")
oReport:SetLandscape()
oReport:EndReport(.F.)
oReport:SetTotalInLine(.F.)

//���������������������������������������������������
//Cria a sess�o principal de CHAMADOS do relat�rio	�
//���������������������������������������������������
oSection1 := TRSection():New(oReport,"Baixa por recibos",{"SE5"})
TRCell():New(oSection1, "EL_FILIAL"		, "SEL", "Filial")
TRCell():New(oSection1, "EL_RECIBO"    	, "SEL", "Recibo")
TRCell():New(oSection1, "EL_NUMERO"     , "SEL", "Titulo")
TRCell():New(oSection1, "EL_PARCELA"	, "SEL", "Parcela")
TRCell():New(oSection1, "E1_VALOR"      , "SE1", "Valor titulo") 
TRCell():New(oSection1, "E1_SALDO"  	, "SE1", "Saldo P/ Baixar")
TRCell():New(oSection1, "E5_VALOR"		, "SE5", "Vlr Baixado")
TRCell():New(oSection1, "E5_VLMULTA"    , "SE5", "Vlr Mt")
TRCell():New(oSection1, "E5_VLJUROS"	, "SE5", "Vlr Jr")
TRCell():New(oSection1, "E5_VLDESCO"	, "SE5", "Vlr Desc")
TRCell():New(oSection1, "EL_EMISSAO"    , "SEL", "Emissao Rec")
TRCell():New(oSection1, "E1_EMISSAO"    , "SE1", "Emissao Tit")
TRCell():New(oSection1, "E1_VENCREA"    , "SE1", "Vencimento")
TRCell():New(oSection1, "E5_DATA"	    , "SE5", "Baixa")
TRCell():New(oSection1, "E1_PORTADO"    , "SE1", "Banco")
TRCell():New(oSection1, "E1_TIPO"       , "SE1", "Tipo")
TRCell():New(oSection1, "E1_CLIENTE"    , "SE1", "Cliente")
TRCell():New(oSection1, "E1_LOJA"       , "SE1", "Loja")
TRCell():New(oSection1, "E1_NOMCLI"     , "SE1", "N. Cliente")
TRCell():New(oSection1, "E5_TIPODOC"    , "SE5", "Tp Doc")
TRCell():New(oSection1, "E5_HISTOR"     , "SE5", "Hist�rico")

Return oReport

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �REL01PRINT     �Autor  �Edison        � Data � 17/07/2016   ���
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
			Column EL_EMISSAO as Date  
			Column E1_EMISSAO as Date  
			Column E1_VENCREA as Date
			Column E5_DATA    as Date  
			
	 SELECT 
         
           EL.EL_FILIAL,
           EL.EL_RECIBO,
           EL.EL_NUMERO,
           EL.EL_PARCELA,
           E1.E1_VALOR,
           E1.E1_SALDO,
           E5.E5_VALOR,
           E5.E5_VLMULTA,
           E5.E5_VLJUROS,
           E5.E5_VLDESCO,
           EL.EL_EMISSAO,
           E1.E1_EMISSAO,
           E1.E1_VENCREA,
           E5.E5_DATA,
           E1.E1_PORTADO,
           E1.E1_TIPO,
           E1.E1_CLIENTE,
           E1.E1_LOJA,
           E1.E1_NOMCLI,
           E5.E5_TIPODOC,
           E5.E5_HISTOR       
           FROM %Table:SEL% EL
		      INNER JOIN %Table:SE1% E1 
				   ON EL.EL_FILIAL = E1.E1_FILIAL 
				   AND EL.EL_NUMERO = E1.E1_NUM
				   AND EL.EL_PARCELA = E1.E1_PARCELA
				   AND EL.EL_CLIORIG = E1.E1_CLIENTE
				   AND EL.EL_LOJORIG = E1.E1_LOJA
				   AND EL.EL_TIPO = E1.E1_TIPO
				   
				   LEFT JOIN %Table:SE5% E5
				   ON  E5.E5_FILIAL = EL.EL_FILIAL 
				   AND E5.E5_NUMERO = EL.EL_NUMERO
				   AND E5.E5_PARCELA = EL.EL_PARCELA
				   AND E5.E5_CLIFOR = EL.EL_CLIORIG
				   AND E5.E5_LOJA = EL.EL_LOJORIG
				   AND E5.E5_TIPO = EL.EL_TIPO
				   
			
			WHERE  E1.E1_FILIAL >= %Exp:MV_PAR01% AND E1.E1_FILIAL	<= %Exp:MV_PAR02%
		           AND El.EL_RECIBO >= %Exp:MV_PAR03% AND El.EL_RECIBO  <= %Exp:MV_PAR04%	
                   AND EL.%Notdel%
                   AND E1.%Notdel%
                   //AND E5.%Notdel%
                   AND (E5.E5_TIPODOC NOT IN ('DB','JR', 'MT','DC')
                   OR   E1.E1_SALDO >0)     			
			
				   	
		    order by EL.EL_FILIAL, El.EL_RECIBO, EL.EL_NUMERO, EL.EL_PARCELA
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

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AJUSTASX1  �Autor  �Marcelo           � Data � 06/06/2014   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o respons�vel pela cria��o do grupo de perguntas utili-���
���          �zado como par�metros do relat�rio.                          ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico Treinamento                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function VldPerg(cPerg)
PutSx1(cPerg,"01","Filial  De        ?"      ,"Filial De         ?"         ,"Filial De           ?"      ,"MV_CH1"  ,"C",02,0,0 ,"G","","   ", "", "","MV_PAR01")
PutSx1(cPerg,"02","Filial At�        ?"      ,"Filial At�        ?"         ,"Filial At�          ?"      ,"MV_CH2"  ,"C",02,0,0 ,"G","","   ","",""  ,"MV_PAR02")
PutSx1(cPerg,"03","Recibo  De        ?"      ,"Recibo De         ?"         ,"Recibo De           ?"      ,"MV_CH3"  ,"C",06,0,0 ,"G","","   ", "", "","MV_PAR03")
PutSx1(cPerg,"04","Recibo  At�       ?"      ,"Recibo At�        ?"         ,"Recibo At�          ?"      ,"MV_CH4"  ,"C",06,0,0 ,"G","","   ", "", "","MV_PAR04")



Return