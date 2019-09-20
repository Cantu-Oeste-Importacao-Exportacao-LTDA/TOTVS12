/*---------------------------------------------------------------------------+
!                       FICHA TECNICA DO PROGRAMA                            !
+----------------------------------------------------------------------------+
!                          DADOS DO PROGRAMA                                 !
+------------------+---------------------------------------------------------+
!Autor             ! Silvio Rodrigues Lima                                   !
+------------------+---------------------------------------------------------+
!Descricao         ! Relat�rio Cadastral    					             !
+------------------+---------------------------------------------------------+
!Nome              ! GPEREL01                                                !
+------------------+---------------------------------------------------------+
!Data de Cria��o   ! 13/11/2013                                              !
+---------------------------------------------------------------------------*/

#INCLUDE "rwmake.ch"
#INCLUDE "font.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"

User Function GPEREL01() 

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

If !ApOleClient("MsExcel")  
	MsgStop("Microsoft Excel nao instalado.")  
	Return
EndIf

/*======================================================
****** Parametros ******
========================================================
mv_par01 ---> Filial de
mv_par02 ---> Filial at�
mv_par03 ---> Centro Custo de
mv_par04 ---> Centro Custo at�
mv_par05 ---> Matricula de
mv_par06 ---> Matricula at�
mv_par07 ---> Status
mv_par08 ---> Categorias
======================================================*/ 

cPerg := "GPEREL01"
cPerg := PadR(cPerg,10," ")
VldPerg(cPerg)  // Chama funcao VldPerg para Verificar se as Perguntas existem no SX1, se nao existir cria

AjusteSX1(cPerg)
If Pergunte(cPerg,.T.)
	//nHdl    := fCreate(cArqTxt)
	Processa({|| MovFunc() },"Processando...","Selecionando Registros... ")
EndIf
Return

Static Function MovFunc()  

xParSituac := mv_par08 

cQuery := "  SELECT "
cQuery += "  RA_FILIAL FILIAL, "
cQuery += "  RA_MAT MATRICULA, "
cQuery += "  TRIM(RA_NOME) NOME, "
cQuery += "  RA_CC CC, "
cQuery += "  TRIM(CTT_DESC01) DESCCC, "
cQuery += "  RA_ADMISSA ADMISSAO, " 
cQuery += "  RA_CATFUNC, "
cQuery += "  RA_CODFUNC FUNCAO, "
cQuery += "  TRIM(RJ_DESC) DESCFUNCAO, "
cQuery += "  RA_X_SEGME CODSEG, "
cQuery += "  TRIM(RA_X_DESCS) DESCSEGMENTO, " 
cQuery += "  RA_SALARIO SALARIO "
cQuery += "  FROM "
cQuery += "  "+ RetSqlName("SRA") +" SRA "
cQuery += "  INNER JOIN "+ RetSqlName("SRJ") +" SRJ ON RA_CODFUNC = RJ_FUNCAO AND SRJ.d_e_l_e_t_ <> '*' "
cQuery += "  INNER JOIN "+ RetSqlName("CTT") +" CTT ON RA_CC = CTT_CUSTO AND CTT.d_e_l_e_t_ <> '*' "
cQuery += "  WHERE "
cQuery += "  RA_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND "
cQuery += "  RA_MAT BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND " 
cQuery += "  RA_CC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND " 
cQuery += "  RA_SITFOLH <> 'D' AND "
cQuery += "  SRA.d_e_l_e_t_ <> '*' AND "
cQuery += "  ctt.r_e_c_n_o_ <> ctt.r_e_c_d_e_l_ "
cQuery += "  ORDER BY 1,3 "
                                
TCQUERY cQuery NEW ALIAS "QRY"
 

MemoWrite("D:\cQuery.txt", cQuery)

QRY->(dbGoTop())

if (QRY->(Eof()))
	MsgAlert('N�o existe rela��o para os par�metros informados!')
	QRY->(DbCloseArea())
	return
endif

nCount := 0
Count To nCount
QRY->(dbGoTop())

cont := 0

Procregua(nCount)

	oFwMsEx := NIL
	cArq := ""
	cDir := GetSrvProfString("Startpath","")
	cWorkSheet := ""
	cTable := ""
	cDirTmp := GetTempPath()   
	cCadastro := "Gerar XML"   
		  
		  nCount := 0 
		  Count To nCount
		  QRY->(dbGoTop())
		  cWorkSheet := 'Cadastro'
		  cTable     := ""
		  oFwMsEx := FWMsExcel():New()	
		  oFwMsEx:SetFrColorHeader('#000000') // Define a cor da fonte do estilo do Cabe�alho   
		  oFwMsEx:SetLineFrColor('#000000') // Define a cor de fonte do estilo da Linha
		  oFwMsEx:Set2LineFrColor('#000000') //Define a cor de fonte do estilo da Linha 2      
	  	  oFwMsEx:SetBgColorHeader('#C0C0C0') //Define a cor da preenchimento do estilo do Cabe�alho
		  oFwMsEx:SetLineBgColor('#FFFFFF') //Define a cor da preenchimento do estilo da Linha
	  	  oFwMsEx:Set2LineBgColor('#FFFFFF') //Define a cor da preenchimento do estilo da Linha 2   
		  
		  oFwMsEx:AddWorkSheet( cWorkSheet )
		  oFwMsEx:AddTable( cWorkSheet, cTable )	
		  oFwMsEx:AddColumn( cWorkSheet, cTable , "Filial"   , 1,1)
		  oFwMsEx:AddColumn( cWorkSheet, cTable , "Matr�cula"    , 1,1)
		  oFwMsEx:AddColumn( cWorkSheet, cTable , "Nome", 1,1)  
		  oFwMsEx:AddColumn( cWorkSheet, cTable , "Segmento", 1,1) 
		  oFwMsEx:AddColumn( cWorkSheet, cTable , "Descri��o Segmento", 1,1) 
		  oFwMsEx:AddColumn( cWorkSheet, cTable , "Centro Custo", 1,1)  
		  oFwMsEx:AddColumn( cWorkSheet, cTable , "Descri��o Centro Custo", 1,1) 
		  oFwMsEx:AddColumn( cWorkSheet, cTable , "Admiss�o", 1,1) 
  		  oFwMsEx:AddColumn( cWorkSheet, cTable , "Func�o", 1,1) 
		  oFwMsEx:AddColumn( cWorkSheet, cTable , "Descri��o Fun��o", 1,1) 
		  oFwMsEx:AddColumn( cWorkSheet, cTable , "Categoria", 1,1)        
		  oFwMsEx:AddColumn( cWorkSheet, cTable , "Sal�rio", 1,1)        
		  
		
		  Procregua(nCount)
		  
		  While !QRY->(Eof()) 
		    
		    Incproc("Aguarde, processando.. ")   
		    		    
		    If QRY->RA_CATFUNC $ xParSituac
		    oFwMsEx:AddRow( cWorkSheet, cTable, { QRY->FILIAL , QRY->MATRICULA , QRY->NOME, QRY->CODSEG,  QRY->DESCSEGMENTO, QRY->CC, QRY->DESCCC, DTOC(STOD(QRY->ADMISSAO)), QRY->FUNCAO,  QRY->DESCFUNCAO, RA_CATFUNC,  STRTRAN(ALLTRIM(STR(QRY->SALARIO)),".",",")   } )			
		  	ENDIF
		  	
		  	QRY->(dbSkip()) 
		  
		  EndDo   
		  oFwMsEx:Activate()
		  cArq := CriaTrab( NIL, .F. ) + ".xls"
			LjMsgRun( "Gerando o arquivo, aguarde...", cCadastro, {|| oFwMsEx:GetXMLFile( cArq ) } )
			If __CopyFile( cArq, cDirTmp + cArq )
		  			oExcelApp := MsExcel():New()
					oExcelApp:WorkBooks:Open( cDirTmp + cArq )
			 		oExcelApp:SetVisible(.T.)
			Else
				MsgInfo( "Arquivo n�o copiado para tempor�rio do usu�rio." )
			Endif

QRY->(DbCloseArea())

Return   


Static Function Acento( cTexto )

Local cAcentos     := " � � Z � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � �"
Local cAcSubst     := " C c A A A A A A a a a a a E E E E e e e e I I I I i O O O O O o o o o U U U U u u u u u N n"
Local cImpCar     := ""
Local cImpLin     := ""
Local nChar        := 0.00
Local nChars     := 0.00
Local nAt     := 0.00

cTexto := IF( Empty( cTexto ) .or. ValType( cTexto ) != "C", "" , cTexto )

nChars := Len( cTexto )
For nChar := 1 To nChars
	cImpCar := SubStr( cTexto , nChar , 1 )
	IF ( nAt := At( cImpCar , cAcentos ) ) > 0
		cImpCar := SubStr( cAcSubst , nAt , 1 )
	EndIF
	cImpLin += cImpCar
Next nChar

Return( cImpLin )


Static Function VldPerg(cPerg)

PutSX1(cPerg,"01","Filial de "      ,"Filial de "      ,"Filial de "      ,"MV_CH1","C",002,0,0,"G"," "      ,"XM0"," " ," ","MV_PAR01",""            , ""            , ""            , "", ""         , ""         , ""         , "", "", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")
PutSX1(cPerg,"02","Filial at� "     ,"Filial at� "     ,"Filial at� "     ,"MV_CH2","C",002,0,0,"G"," "	     ,"XM0"," " ," ","MV_PAR02",""            , ""            , ""            , "", ""         , ""         , ""         , "", "", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")
PutSX1(cPerg,"03","Centro Custo de" ,"Centro Custo de" ,"Centro Custo de" ,"MV_CH3","C",010,0,0,"G"," "	     ,"CTT"     ," " ," ","MV_PAR03",""            , ""            , ""            , "", ""         , ""         , ""         , "", "", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")
PutSX1(cPerg,"04","Centro Custo at�","Centro Custo at�","Centro Custo at�","MV_CH4","C",010,0,0,"G"," "	     ,"CTT"     ," " ," ","MV_PAR04",""            , ""            , ""            , "", ""         , ""         , ""         , "", "", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")
PutSX1(cPerg,"05","Matr�cula de "   ,"Matr�cula de "   ,"Matr�cula de "   ,"MV_CH5","C",006,0,0,"G"," "		 ,"SRA"     ," " ," ","MV_PAR05",""            , ""            , ""            , "", ""         , ""         , ""         , "", "", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")
PutSX1(cPerg,"06","Matr�cula at� "  ,"Matr�cula at� "  ,"Matr�cula at� "  ,"MV_CH6","C",006,0,0,"G"," "		 ,"SRA"     ," " ," ","MV_PAR06",""            , ""            , ""            , "", ""         , ""         , ""         , "", "", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")
PutSX1(cPerg,"07","Status"     ,"Status"     ,"Status"     ,"MV_CH7","C",001,0,0,"C"," "      ," "     ," " ," ","MV_PAR07","Ativos"   	     , ""            , ""            , "", "Demitidos"         , ""         , ""         , "", "", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")
PutSX1(cPerg,"08","Categorias" ,"Categorias" ,"Categorias" ,"MV_CH8","C",010,0,0,  "C","fCategoria()"	     ," "     ," " ," ","MV_PAR08",""            , ""            , ""            , "", ""         , ""         , ""         , "", "", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")

Return


