#include "rwmake.ch"  
#include "topconn.ch"
#include "protheus.ch"
#include "tbiconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GPEREL03 �Autor  �TOTVS CASCAVEL       � Data �  23/04/2014 ���
�������������������������������������������������������������������������͹��
���Desc.     �Relat�rio de fretes por fornecedores pessoa f�sica.         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �RJU                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/       
*--------------------------*
User Function GPEREL03()         
*--------------------------*

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := ""
Local cPict         := ""
Local titulo        := "RELA��O DE FRETES POR FORNECEDOR PESSOA F�SICA"
Local nLin          := 80
Local Cabec1 		:= "FORNECEDOR                                                  INSC.PIS    FILIAL  EMISS�O       DOCUMENTO   SERIE    TOTAL DOC.     BASE IRRF      VALOR IRRF     BASE INSS      VALOR INSS     BASE SEST      VALOR SEST"
Local Cabec2 		:= ""
Local imprime       := .T.
Local aOrd          := {}
Private nOrdem		:= 0
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "GPEREL03" 
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "GPEREL03"
Private cPerg       := "GPEREL03X1"
Private cString     := "SF1"
Private STRING_NULL := ""     

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

	dbSelectArea(cString)
	dbSetOrder(1)

	//���������������������������������������������������������������������Ŀ
	//� Monta a interface padrao com o usuario...                           �
	//�����������������������������������������������������������������������
	
	AjustaSX1()
	Pergunte(cPerg, .F.)
	
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
	   Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
		
	
	//���������������������������������������������������������������������Ŀ
	//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
	//�����������������������������������������������������������������������
	
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin,nOrdem) },Titulo)
	
	
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT �Autor  �TOTVS CASCAVEL      � Data �  23/04/2014 ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

*---------------------------------------------------------------------*
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin,nOrdem)
*---------------------------------------------------------------------*
Local cFORNECE	:= STRING_NULL
Local aTOTALFOR	:= {0,0,0,0,0,0,0}
Local aTOTALGRL	:= {0,0,0,0,0,0,0}
Local cAliasTMP := GetNextAlias()
Local cTESFRETE := SuperGetMV("MV_X_CTFGP",,"'042','249'")
Local cNATFRETE := SuperGetMV("MV_X_CNFGP",,"'2110008','2014013'")
                              
	cQuery := "	SELECT																					" + chr(13)
	cQuery += "			SD1.D1_FORNECE, 																" + chr(13)
	cQuery += "			SD1.D1_LOJA, 																	" + chr(13)
	cQuery += "			SD1.D1_FILIAL, 																	" + chr(13)
	cQuery += "			SD1.D1_EMISSAO,																	" + chr(13)
	cQuery += "			SD1.D1_DOC, 																	" + chr(13)
	cQuery += "			SD1.D1_SERIE, 																	" + chr(13)
	cQuery += "			SUM(SD1.D1_CUSTO) D1_CUSTO,														" + chr(13)
	cQuery += "			SUM(SD1.D1_BASEIRR) D1_BASEIRR,													" + chr(13)
	cQuery += "			SUM(SD1.D1_VALIRR) D1_VALIRR,													" + chr(13)
	cQuery += "			SUM(SD1.D1_BASEINS) D1_BASEINS,													" + chr(13)
	cQuery += "			SUM(SD1.D1_VALINS) D1_VALINS,													" + chr(13)
	cQuery += "			SUM(SD1.D1_BASESES) D1_BASESES,													" + chr(13)
	cQuery += "			SUM(SD1.D1_VALSES) D1_VALSES													" + chr(13)
	cQuery += "	FROM "+RetSQLName("SD1")+" SD1															" + chr(13)	
	cQuery += "	INNER JOIN "+RetSQLName("SA2")+" SA2													" + chr(13)	
	cQuery += "			ON		SA2.A2_COD		= SD1.D1_FORNECE										" + chr(13)
	cQuery += "			AND		SA2.A2_LOJA		= SD1.D1_LOJA											" + chr(13)
	cQuery += "			AND 	SA2.A2_TIPO		= 'F'													" + chr(13)
	cQuery += "			AND 	SA2.D_E_L_E_T_	<> '*'													" + chr(13)
	cQuery += "	WHERE 			SD1.D1_FILIAL 	BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'				" + chr(13)
	cQuery += "			AND 	SD1.D1_FORNECE 	BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'				" + chr(13)
	cQuery += "			AND 	SD1.D1_LOJA 	BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'				" + chr(13)
	cQuery += "			AND 	SD1.D1_EMISSAO	BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"'	" + chr(13)
	cQuery += "			AND 	SD1.D1_DTDIGIT	BETWEEN '"+dtos(mv_par09)+"' AND '"+dtos(mv_par10)+"'	" + chr(13)
	cQuery += "			AND 	SD1.D1_TES 		IN ("+cTESFRETE+")										" + chr(13)
	cQuery += "			AND 	SD1.D1_FILIAL || SD1.D1_SERIE || SD1.D1_DOC IN (						" + chr(13)
	cQuery += "					SELECT 		SE2.E2_FILIAL || SE2.E2_PREFIXO || SE2.E2_NUM				" + chr(13)
	cQuery += "					FROM 		"+RetSQLName("SE2")+" SE2									" + chr(13)	
	cQuery += "					WHERE 		SE2.E2_FILIAL 	= SD1.D1_FILIAL 							" + chr(13)
	cQuery += "					AND 		SE2.E2_PREFIXO 	= SD1.D1_SERIE	 							" + chr(13)
	cQuery += "					AND 		SE2.E2_NUM	 	= SD1.D1_DOC	 							" + chr(13)
	cQuery += "					AND 		SE2.E2_FORNECE 	= SD1.D1_FORNECE 							" + chr(13)
	cQuery += "					AND 		SE2.E2_LOJA	 	= SD1.D1_LOJA	 							" + chr(13)
	cQuery += "					AND 		SE2.E2_EMISSAO 	= SD1.D1_EMISSAO 							" + chr(13)
	cQuery += "					AND 		SE2.E2_NATUREZ	IN ("+cNATFRETE+")	 						" + chr(13)
	cQuery += "					AND 		SE2.D_E_L_E_T_	<> '*'	)			 						" + chr(13)
	cQuery += "			AND 	SD1.D_E_L_E_T_	<> '*'													" + chr(13)
	cQuery += "	GROUP BY 																				" + chr(13)
	cQuery += "			SD1.D1_FORNECE, 																" + chr(13)
	cQuery += "			SD1.D1_LOJA, 																	" + chr(13)
	cQuery += "			SD1.D1_FILIAL, 																	" + chr(13)
	cQuery += "			SD1.D1_EMISSAO,																	" + chr(13)
	cQuery += "			SD1.D1_DOC, 																	" + chr(13)
	cQuery += "			SD1.D1_SERIE 																	" + chr(13)
	cQuery += "	ORDER BY 																				" + chr(13)
	cQuery += "			SD1.D1_FORNECE, 																" + chr(13)
	cQuery += "			SD1.D1_LOJA, 																	" + chr(13)
	cQuery += "			SD1.D1_FILIAL, 																	" + chr(13)
	cQuery += "			SD1.D1_EMISSAO,																	" + chr(13)
	cQuery += "			SD1.D1_DOC, 																	" + chr(13)
	cQuery += "			SD1.D1_SERIE 																	" + chr(13)

	memowrite("GPEREL03.SQL",cQuery)
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	SetRegua((cAliasTMP)->(RecCount()))
	
	//���������������������������������������������������������������������Ŀ
	//� Percorre itens selecionados para impress�o                          �
	//�����������������������������������������������������������������������
	
	While (cAliasTMP)->(!EOF())

		//���������������������������������������������������������������������Ŀ
		//� Verifica o cancelamento pelo usuario...                             �
		//�����������������������������������������������������������������������
	
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
	
		//���������������������������������������������������������������������Ŀ
		//� Impressao do cabecalho do relatorio. . .                            �
		//�����������������������������������������������������������������������
	
		If nLin > 55 
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif

		//���������������������������������������������������������������������Ŀ
		//� Impress�o dos totalizadores...                                      �
		//����������������������������������������������������������������������
	    If cFORNECE	!= STRING_NULL .and. cFORNECE != (cAliasTMP)->(D1_FORNECE+D1_LOJA)

			@nLin,000 PSAY "TOTAL: "
			@nLin,112 PSAY aTOTALFOR[1]	PICTURE "@E 99,999,999.99"
			@nLin,127 PSAY aTOTALFOR[2]	PICTURE "@E 99,999,999.99"
			@nLin,142 PSAY aTOTALFOR[3]	PICTURE "@E 99,999,999.99"
			@nLin,157 PSAY aTOTALFOR[4]	PICTURE "@E 99,999,999.99"
			@nLin,172 PSAY aTOTALFOR[5]	PICTURE "@E 99,999,999.99"
			@nLin,187 PSAY aTOTALFOR[6]	PICTURE "@E 99,999,999.99"
			@nLin,202 PSAY aTOTALFOR[7]	PICTURE "@E 99,999,999.99"
	
	    	aTOTALFOR := {0,0,0,0,0,0,0}
	    	nLin += 2
	    EndIf      
	    
	                                 
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek( xFilial("SA2") + (cAliasTMP)->(D1_FORNECE+D1_LOJA) )
		

		//cabec1 := "FORNECEDOR                                                  INSC.PIS    FILIAL  EMISS�O       DOCUMENTO   SERIE    TOTAL DOC.     BASE IRRF      VALOR IRRF     BASE INSS      VALOR INSS     BASE SEST      VALOR SEST"
		//           01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
		//           0         1         2         3         4         5         6         7         8         9        10         11        12        13        14        15        16        17        18        19        20 	   21       22

		@nLin,000 PSAY SA2->A2_COD + "/" + SA2->A2_LOJA + "-" + SubSTR(SA2->A2_NOME,1,40)
		@nLin,060 PSAY SA2->A2_INSCPIS
		@nLin,072 PSAY (cAliasTMP)->D1_FILIAL
		@nLin,080 PSAY DTOC(STOD((cAliasTMP)->D1_EMISSAO))
		@nLin,094 PSAY (cAliasTMP)->D1_DOC
		@nLin,106 PSAY (cAliasTMP)->D1_SERIE				
		@nLin,112 PSAY (cAliasTMP)->D1_CUSTO 	PICTURE "@E 99,999,999.99"
		@nLin,127 PSAY (cAliasTMP)->D1_BASEIRR 	PICTURE "@E 99,999,999.99"
		@nLin,142 PSAY (cAliasTMP)->D1_VALIRR 	PICTURE "@E 99,999,999.99"
		@nLin,157 PSAY (cAliasTMP)->D1_BASEINS 	PICTURE "@E 99,999,999.99"
		@nLin,172 PSAY (cAliasTMP)->D1_VALINS 	PICTURE "@E 99,999,999.99"
		@nLin,187 PSAY (cAliasTMP)->D1_BASESES 	PICTURE "@E 99,999,999.99"
		@nLin,202 PSAY (cAliasTMP)->D1_VALSES 	PICTURE "@E 99,999,999.99"

	
		nLin := nLin + 1 

	    cFORNECE  := (cAliasTMP)->(D1_FORNECE+D1_LOJA)
	    aTOTALFOR[1] += (cAliasTMP)->D1_CUSTO
	    aTOTALFOR[2] += (cAliasTMP)->D1_BASEIRR
	    aTOTALFOR[3] += (cAliasTMP)->D1_VALIRR
	    aTOTALFOR[4] += (cAliasTMP)->D1_BASEINS
	    aTOTALFOR[5] += (cAliasTMP)->D1_VALINS
	    aTOTALFOR[6] += (cAliasTMP)->D1_BASESES
	    aTOTALFOR[7] += (cAliasTMP)->D1_VALSES	    	    	    	    	    
		aTOTALGRL[1] += (cAliasTMP)->D1_CUSTO
		aTOTALGRL[2] += (cAliasTMP)->D1_BASEIRR
		aTOTALGRL[3] += (cAliasTMP)->D1_VALIRR
		aTOTALGRL[4] += (cAliasTMP)->D1_BASEINS		
		aTOTALGRL[5] += (cAliasTMP)->D1_VALINS		
		aTOTALGRL[6] += (cAliasTMP)->D1_BASESES		
		aTOTALGRL[7] += (cAliasTMP)->D1_VALSES							                                 
	    
		IncRegua()
		(cAliasTMP)->(dbSkip())
	EndDo
	(cAliasTMP)->(dbCloseArea())

	
	//���������������������������������������������������������������������Ŀ
	//� Impress�o dos totalizadores...                                      �
	//����������������������������������������������������������������������
    If cFORNECE	!= STRING_NULL 

		@nLin,000 PSAY "TOTAL: "
		@nLin,112 PSAY aTOTALFOR[1]	PICTURE "@E 99,999,999.99"
		@nLin,127 PSAY aTOTALFOR[2]	PICTURE "@E 99,999,999.99"
		@nLin,142 PSAY aTOTALFOR[3]	PICTURE "@E 99,999,999.99"
		@nLin,157 PSAY aTOTALFOR[4]	PICTURE "@E 99,999,999.99"
		@nLin,172 PSAY aTOTALFOR[5]	PICTURE "@E 99,999,999.99"
		@nLin,187 PSAY aTOTALFOR[6]	PICTURE "@E 99,999,999.99"
		@nLin,202 PSAY aTOTALFOR[7]	PICTURE "@E 99,999,999.99"
    	nLin += 2
		@nLin,000 PSAY "TOTAL GERAL: "
		@nLin,112 PSAY aTOTALGRL[1]	PICTURE "@E 99,999,999.99"
		@nLin,127 PSAY aTOTALGRL[2]	PICTURE "@E 99,999,999.99"
		@nLin,142 PSAY aTOTALGRL[3]	PICTURE "@E 99,999,999.99"
		@nLin,157 PSAY aTOTALGRL[4]	PICTURE "@E 99,999,999.99"
		@nLin,172 PSAY aTOTALGRL[5]	PICTURE "@E 99,999,999.99"
		@nLin,187 PSAY aTOTALGRL[6]	PICTURE "@E 99,999,999.99"
		@nLin,202 PSAY aTOTALGRL[7]	PICTURE "@E 99,999,999.99"
    	nLin += 2

    EndIf      


	//���������������������������������������������������������������������Ŀ
	//� Finaliza a execucao do relatorio...                                 �
	//�����������������������������������������������������������������������
	
	SET DEVICE TO SCREEN
	
	//���������������������������������������������������������������������Ŀ
	//� Se impressao em disco, chama o gerenciador de impressao...          �
	//�����������������������������������������������������������������������
	
	If aReturn[5]==1
	   dbCommitAll()
	   SET PRINTER TO
	   OurSpool(wnrel)
	Endif
	
	MS_FLUSH()

Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AJUSTASX1�Autor  �TOTVS CASCAVEL       � Data �  23/04/2014 ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o utilizada para verificar/criar no ambiente o grupo   ���
���          �de perguntas.                                               ���
�������������������������������������������������������������������������͹��
���Uso       �RJU                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

*--------------------------*
Static Function AjustaSX1()
*--------------------------*
aRegs  := {} 

	//�������������������������������������������������������
	//�Defini��o dos itens do grupo de perguntas a ser criado�
	//�������������������������������������������������������
	aAdd(aRegs,{cPerg,"01","Filial Doc. De      ?","Filial Doc. De      ?","Filial Doc. De      ?","mv_ch1","C",TAMSX3("A2_FILIAL")[1],0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"02","Filial Doc. At�     ?","Filial Doc. At�     ?","Filial Doc. At�     ?","mv_ch2","C",TAMSX3("A2_FILIAL")[1],0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
 	aAdd(aRegs,{cPerg,"03","Emiss�o Doc. De     ?","Emiss�o Doc. De     ?","Emiss�o Doc. De     ?","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"04","Emiss�o Doc. At�    ?","Emiss�o Doc. At�    ?","Emiss�o Doc. At�    ?","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"05","Fornecedor De       ?","Fornecedor De       ?","Fornecedor De       ?","mv_ch5","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","", "SA2","","001",""})
	aAdd(aRegs,{cPerg,"06","Fornecedor At�      ?","Fornecedor At�      ?","Fornecedor At�      ?","mv_ch6","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","", "SA2","","001",""})
	aAdd(aRegs,{cPerg,"07","Loja De             ?","Loja De             ?","Loja De             ?","mv_ch7","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"08","Loja At�            ?","Loja At�            ?","Loja At�            ?","mv_ch8","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"09","Digita��o Doc. De   ?","Digita��o Doc. De   ?","Digita��o Doc. De   ?","mv_ch9","D",08,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"10","Digita��o Doc. At�  ?","Digita��o Doc. At�  ?","Digita��o Doc. At�  ?","mv_chA","D",08,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	
	dbSelectArea("SX1")
	dbSetOrder(1) 
	
	For i := 1 To Len(aRegs)
		If !dbSeek(cPerg + aRegs[i,2])
			RecLock("SX1", .T.)
			For j := 1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j, aRegs[i,j])	 
				Endif
			Next
			MsUnlock()
		Endif
	Next         

	
Return Nil