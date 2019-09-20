#INCLUDE "rwmake.ch"
#INCLUDE "font.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"   

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RELCIT  �Autor  �Gustavo Lattmann    � Data �  07/03/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Relat�rio com saldos dos segmentos por empresa			  ���
���          �															  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Cantu                                           ���
�������������������������������������������������������������������������ͼ��
���Chamado   � 12904			                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RELCTI()

Local cPerg := "RELCTI"
Local cPerg := PadR(cPerg,10," ")

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

VldPerg(cPerg)  //Verificar se as Perguntas existem no SX1, se nao existir cria

AjusteSX1(cPerg)
If Pergunte(cPerg,.T.)
	Processa({|| GeraRel() },"Processando...","Selecionando Registros... ")
EndIf

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MOVFUNC  �Autor  �Gustavo Lattmann     � Data �  25/07/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o respons�vel por executar o relat�rio, gera um arquivo���
���          �por empresa                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GeraRel()  

Local cEol 		:= CHR(10) + CHR(13)
Local cSql 		:= "" 
Local cCod		:= "" 
Local aEmp 		:= {}                                                                                                                                                  
Local nCount 	:= 0
Local oFwMsEx 	:= NIL
Local cDirTmp	:= ""
Local cTable 	:= "RELAT�RIO DE SALDO CLASSE VALOR" //T�tulo exibido na primiera linha da planilha
Local cTipo 	:= "Arquivos XLS | *.XLS" 
Local cWorkSheet := 'Saldos Segmento' //Nome na planilha
//Local cArq 		:= "Saldo_Seg " + STRTRAN(DtoC(MV_PAR01),"/","-") +".xls" //Define o nome do arquivo baseado na data dos par�metros
Local cArq		:= ""
Local cCadastro := "Gerar XLS" //T�tulo da tela de quando gera o arquivo   
Local cEmp		:= ""
Local cMes		:= ""

//����������������������������������������������������������������������������
//�Abre a tabela de empresas do sistema e adiciona o c�digo da empresa no aEmp�
//����������������������������������������������������������������������������
DbSelectArea("SM0")
DbSetOrder(01)
DbGoTop()
       
While !SM0->(EOF())
	if cCod != SM0->M0_CODIGO
		cCod := SM0->M0_CODIGO
		aAdd(aEmp, SM0->M0_CODIGO)
	EndIf
	SM0->(dbSkip())
End

//�����������������������������������������������������������������������Ŀ
//�Efetua a montagem do comando SQL que vai fazer a busca das informa��es �
//�������������������������������������������������������������������������

For i := 1 to Len(aEmp)

	cSql += "SELECT '"+ aEmp[i] +"' AS EMPRESA, CTI_FILIAL, CTI_CLVL, CTI_CUSTO, CTI_ITEM, CTI_CONTA, CTI_DATA, CTI_DEBITO,  	 	 " +cEol
	cSql +=	"CTI_CREDIT, CTI_STATUS, CTI_ATUDEB, CTI_ATUCRD, CTI_ANTDEB, CTI_ANTCRD	   								 				 " +cEol
	cSql += "FROM CTI" + aEmp[i] + "0 "	   																							   +cEol
	cSql += "WHERE D_E_L_E_T_ <> '*' "                                                                               				   +cEol
	cSql += "AND CTI_DATA BETWEEN '"+ DtoS(MV_PAR01) +"' AND '"+ DtoS(MV_PAR02) +"' "  		                                           +cEol
	cSql += "AND CTI_FILIAL <> '99'												                                               		 " +cEol	
	cSql += "AND CTI_TPSALD = '1'												                                               		 " +cEol		
	If i != Len(aEmp)
		cSql += "UNION ALL "                                                                                                           +cEol
	EndIf

Next i                                                          

cSql := ChangeQuery(cSql)                                        

TCQUERY cSql NEW ALIAS "TBTMP"

//�������������������������������������������������������Ŀ
//�M�s para ser utilizado na composi��o do nome do arquivo�
//���������������������������������������������������������
cMes := SUBSTR(DtoC(MV_PAR01),4,2)

Do Case
	Case cMes == "01"
		cRet := "janeiro"
	Case cMes == "02"
		cRet := "fevereiro"
	Case cMes == "03"
		cRet := "mar�o"
	Case cMes == "04"
		cRet := "abril"
	Case cMes == "05"
		cRet := "maio"
	Case cMes == "06"
		cRet := "junho"
	Case cMes == "07"
		cRet := "julho"
	Case cMes == "08"
		cRet := "agosto"
	Case cMes == "09"
		cRet := "setembro"
	Case cMes == "10"
		cRet := "outubro"
	Case cMes == "11"
		cRet := "novembro"
	Case cMes == "12"
		cRet := "dezembro" 
EndCase

//�����������������������������������Ŀ
//�Verifica se a tabela n�o esta vazia�
//�������������������������������������
TBTMP->(dbGoTop())
If (TBTMP->(Eof()))
		MsgAlert('N�o existe rela��o para os par�metros informados!')
	TBTMP->(DbCloseArea())
	return
Endif

Count To nCount
TBTMP->(dbGoTop())

//cont := 0

Procregua(nCount)
	
	//�������������������������������������������������������������������������������Ŀ
	//�Abre a tela para o usu�rio selecionar em qual diretorio deseja salvar o arquivo�
	//���������������������������������������������������������������������������������
	cDirTmp := cGetFile( cTipo , "Selecione o local para salvar o arquivo...", 0,"",.F., GETF_RETDIRECTORY + GETF_LOCALHARD)
	
	nCount := 0 
	Count To nCount
	TBTMP->(dbGoTop())
	
	While !TBTMP->(Eof())     
		cEmp := TBTMP->EMPRESA
		//��������������������������������������������������
		//�Instancia a classe que permite gerar arquivo XLS�
		//��������������������������������������������������
		oFwMsEx := FWMsExcel():New()	
		
		oFwMsEx:SetBgColorHeader('#FFFFFF') //Define a cor da preenchimento do estilo do Cabe�alho
		oFwMsEx:SetLineBgColor('#FFFFFF') //Define a cor da preenchimento do estilo da Linha
		oFwMsEx:Set2LineBgColor('#DCDCDC') //Define a cor da preenchimento do estilo da Linha 2   
		
	    oFwMsEx:SetFontSize(9) //Define o tamanho da fonte da planilha	  
	    oFwMsEx:SetFont("Calibri")
		oFwMsEx:AddWorkSheet( cWorkSheet )
		oFwMsEx:AddTable( cWorkSheet, cTable )	
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Empresa"   	, 1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Filial"    	, 1,1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Segmento"		, 1,1)  
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Centro de Custo", 1,1)  	  
		oFwMsEx:AddColumn( cWorkSheet, cTable , "Item"			, 1,1)  	  
	    oFwMsEx:AddColumn( cWorkSheet, cTable , "Conta Cont�bil", 1,1)  	  		  
	    oFwMsEx:AddColumn( cWorkSheet, cTable , "Data"	   		, 1,1)  	  		  	
	    oFwMsEx:AddColumn( cWorkSheet, cTable , "Status"		, 1,1)  	  		  					
	   	oFwMsEx:AddColumn( cWorkSheet, cTable , "D�bito"		, 1,1)  	  		  					
	   	oFwMsEx:AddColumn( cWorkSheet, cTable , "Cr�dito"  		, 1,1)  	  		  						      
	   	oFwMsEx:AddColumn( cWorkSheet, cTable , "D�bito Atu."	, 1,1)  	  		  						      
	   	oFwMsEx:AddColumn( cWorkSheet, cTable , "Cr�dito Atu."	, 1,1)  	  		  						      
	   	oFwMsEx:AddColumn( cWorkSheet, cTable , "D�bito Ant."	, 1,1)  	  		  						      
	   	oFwMsEx:AddColumn( cWorkSheet, cTable , "Cr�dito Ant."	, 1,1)  	 	         	      
	   		
		Procregua(nCount)
		
	
		//�����������������������������������������������Ŀ
		//�Varre a tabela e grava os registros na planilha�
		//�������������������������������������������������
	    
		While !TBTMP->(Eof()) .and. cEmp == TBTMP->EMPRESA 
	  		Incproc("Aguarde, processando " + cValToChar(nCount) + " registro(s).")   
		    
		    oFwMsEx:AddRow( cWorkSheet, cTable, { TBTMP->EMPRESA, TBTMP->CTI_FILIAL, TBTMP->CTI_CLVL, TBTMP->CTI_CUSTO, TBTMP->CTI_ITEM,;
							TBTMP->CTI_CONTA, TBTMP->CTI_DATA, TBTMP->CTI_STATUS, TBTMP->CTI_DEBITO, TBTMP->CTI_CREDIT, TBTMP->CTI_ATUDEB, TBTMP->CTI_ATUCRD,;
							TBTMP->CTI_ANTDEB, TBTMP->CTI_ANTCRD})			
	  		TBTMP->(dbSkip()) 
	  
		EndDo   
		
		oFwMsEx:Activate() 
		

		//�������������������������������������������������������
		//�Cria o nome do arquivo a partir da empresa posicionado�
		//�������������������������������������������������������
		cArq := "CTI_EMP_" +cEmp+ "_" + cRet +".xls"  
		
		LjMsgRun( "Gerando o arquivo, aguarde...", cCadastro, {|| oFwMsEx:GetXMLFile( cArq ) } )
		If !__CopyFile( cArq, cDirTmp + cArq ) 
			MsgInfo("Arquivo n�o copiado para local selecionado." )
		   
		   /*	If MsgYesNo("Deseja abrir o arquivo gerado?","Abrir arquivo")
				oExcelApp := MsExcel():New()
				oExcelApp:WorkBooks:Open( cDirTmp + cArq )
			 	oExcelApp:SetVisible(.T.)
			EndIf */
		Endif  
	
	EndDo
	TBTMP->(DbCloseArea()) 
    
Return   

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VLDPERG  �Autor  �Gustavo Lattmann     � Data �  07/03/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o respons�vel pelo par�metros informados pelo usu�rio  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Protheus                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function VldPerg(cPerg)

PutSX1(cPerg,"01","Data de "	,"Data de "   ,"Data de "  ,"MV_CH1","D",008,0,0,"G","","","","","MV_PAR01","","","","","","","","","", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")
PutSX1(cPerg,"02","Data at� "	,"Data at� "  ,"Data at� " ,"MV_CH1","D",008,0,0,"G","","","","","MV_PAR02","","","","","","","","","", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")

Return