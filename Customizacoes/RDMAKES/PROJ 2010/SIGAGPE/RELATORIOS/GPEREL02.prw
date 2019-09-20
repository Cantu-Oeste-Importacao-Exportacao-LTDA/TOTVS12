/*---------------------------------------------------------------------------+
!                       FICHA TECNICA DO PROGRAMA                            !
+----------------------------------------------------------------------------+
!                          DADOS DO PROGRAMA                                 !
+------------------+---------------------------------------------------------+
!Autor             ! Silvio Rodrigues Lima                                   !
+------------------+---------------------------------------------------------+
!Descricao         ! Relatório de Dependentes       			             !
+------------------+---------------------------------------------------------+
!Nome              ! GPEREL02                                                !
+------------------+---------------------------------------------------------+
!Data de Criação   ! 14/11/2013                                              !
+---------------------------------------------------------------------------*/

#INCLUDE "rwmake.ch"
#INCLUDE "font.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"

User Function GPEREL02()    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

/*======================================================
****** Parametros ******
========================================================
mv_par01 ---> Filial de
mv_par02 ---> Filial até
mv_par03 ---> Centro Custo de
mv_par04 ---> Centro Custo até
mv_par05 ---> Matricula de
mv_par06 ---> Matricula até
mv_par07 ---> Status
mv_par08 ---> Categorias
======================================================*/ 

cPerg := "GPEREL02"
cPerg := PadR(cPerg,10," ")
VldPerg(cPerg)  // Chama funcao VldPerg para Verificar se as Perguntas existem no SX1, se nao existir cria

AjusteSX1(cPerg)
If Pergunte(cPerg,.T.)
	//nHdl    := fCreate(cArqTxt)
	Processa({|| MovFunc() },"Processando...","Selecionando Registros... ")
EndIf
Return

Static Function MovFunc()  

cQuery := "  SELECT "
cQuery += "  RA_FILIAL FILIAL, RA_MAT MATRICULA, RA_NOME NOME, RA_ADMISSA ADMISSAO, RA_CC CC,  "
cQuery += "  RB_NOME DEPENDENTE, RB_DTNASC NASCIMENTODEP, RB_SEXO SEXO, RB_GRAUPAR GRAUPAR, "
cQuery += "  TRIM(CTT_DESC01) DESCCC "
cQuery += "  FROM "+ RetSqlName("SRB") +" SRB "
cQuery += "  INNER JOIN "+ RetSqlName("SRA") +" SRA ON RA_MAT = RB_MAT AND RA_FILIAL = RB_FILIAL AND  SRA.D_E_L_E_T_ <> '*' "
cQuery += "  INNER JOIN CTTCMP CTT ON RA_CC = CTT_CUSTO AND CTT.D_E_L_E_T_ <> '*' "
cQuery += "  WHERE  "   
cQuery += "  RA_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND "
cQuery += "  RA_CC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND " 
cQuery += "  RA_MAT BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND " 
cQuery += "  RA_SITFOLH <> 'D' AND "
cQuery += "  SRB.D_E_L_E_T_ <> '*' "
cQuery += "  ORDER BY 1,3 "

TCQUERY cQuery NEW ALIAS "QRY"

QRY->(dbGoTop())

if (QRY->(Eof()))
	MsgAlert('Não existe relação para os parâmetros informados!')
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
			//preto #000000 // branco #FFFFFF      
	//		SetFrGeneralColor(< cColor >)                           
		  oFwMsEx:SetFrColorHeader('#000000') // Define a cor da fonte do estilo do Cabeçalho   
		  oFwMsEx:SetLineFrColor('#000000') // Define a cor de fonte do estilo da Linha
		  oFwMsEx:Set2LineFrColor('#000000') //Define a cor de fonte do estilo da Linha 2      
	  	  oFwMsEx:SetBgColorHeader('#C0C0C0') //Define a cor da preenchimento do estilo do Cabeçalho
		  oFwMsEx:SetLineBgColor('#FFFFFF') //Define a cor da preenchimento do estilo da Linha
	  	  oFwMsEx:Set2LineBgColor('#FFFFFF') //Define a cor da preenchimento do estilo da Linha 2   
	  	  //oFwMsEx:SettableBgColor
		  
		  oFwMsEx:AddWorkSheet( cWorkSheet )
		  oFwMsEx:AddTable( cWorkSheet, cTable )	
		  oFwMsEx:AddColumn( cWorkSheet, cTable , "Filial"   , 1,1)
		  oFwMsEx:AddColumn( cWorkSheet, cTable , "Matrícula"    , 1,1)
		  oFwMsEx:AddColumn( cWorkSheet, cTable , "Nome", 1,1)  
		  oFwMsEx:AddColumn( cWorkSheet, cTable , "Admissão", 1,1)  
		  oFwMsEx:AddColumn( cWorkSheet, cTable , "Centro Custo", 1,1) 
		  oFwMsEx:AddColumn( cWorkSheet, cTable , "Descrição Centro Custo", 1,1) 
  		  oFwMsEx:AddColumn( cWorkSheet, cTable , "Nome Dependente", 1,1) 
		  oFwMsEx:AddColumn( cWorkSheet, cTable , "Data Nascimento", 1,1)
		  oFwMsEx:AddColumn( cWorkSheet, cTable , "Idade", 1,1) 		   
		  oFwMsEx:AddColumn( cWorkSheet, cTable , "Sexo", 1,1) 
		  oFwMsEx:AddColumn( cWorkSheet, cTable , "Grau Paretesco", 1,1) 
		    		
		  Procregua(nCount) 
		  
		  
		  
		  While !QRY->(Eof()) 
		  
		  Incproc("Aguarde, processando...")   

		  DO CASE
				CASE QRY->SEXO = 'M'
					cSexo := 'MASCULINO'
				CASE QRY->SEXO = 'F'
				    cSexo := 'FEMININO'			    
			ENDCASE  


          DO CASE
				CASE QRY->GRAUPAR  = 'C'
					 cGrauPar  := 'CONJUGE/COMPANHEIRO'
				CASE QRY->GRAUPAR  = 'F'
				     cGrauPar  := 'FILHO'			    
				CASE QRY->GRAUPAR  = 'E'
					 cGrauPar  := 'ENTEADO'
				CASE QRY->GRAUPAR  = 'P'
				     cGrauPar  := 'PAI/MAE'
				CASE QRY->GRAUPAR  = 'O'
				     cGrauPar  := 'AGREGADO/OUTROS'					     			    
             	OTHERWISE				
					cGrauPar  := 'NAO IDENTIFICADO'
			ENDCASE	
			
			cIdadeDep = cvaltochar(DateDiffYear(stod(QRY->NASCIMENTODEP),dDataBase) ) 			

		    oFwMsEx:AddRow( cWorkSheet, cTable, { QRY->FILIAL , QRY->MATRICULA , QRY->NOME, DTOC(STOD(QRY->ADMISSAO)), QRY->CC, QRY->DESCCC,  QRY->DEPENDENTE,  DTOC(STOD(QRY->NASCIMENTODEP)), cIdadeDep, cSexo,  cGrauPar  } )			
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
				MsgInfo( "Arquivo não copiado para temporário do usuário." )
			Endif

QRY->(DbCloseArea())

Return   


Static Function Acento( cTexto )

Local cAcentos     := " Ç ç Z Ä À Â Ã Å à á ã ä å É È Ê Ë è é ê ë Ì Í Î Ï ¡ Ò Ó Ô Õ Ö ¢ § ð ö Ù Ú Û Ü £ ù ú û ü Ñ ñ"
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
PutSX1(cPerg,"02","Filial até "     ,"Filial até "     ,"Filial até "     ,"MV_CH2","C",002,0,0,"G"," "	     ,"XM0"," " ," ","MV_PAR02",""            , ""            , ""            , "", ""         , ""         , ""         , "", "", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")
PutSX1(cPerg,"03","Centro Custo de" ,"Centro Custo de" ,"Centro Custo de" ,"MV_CH3","C",010,0,0,"G"," "	     ,"CTT"     ," " ," ","MV_PAR03",""            , ""            , ""            , "", ""         , ""         , ""         , "", "", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")
PutSX1(cPerg,"04","Centro Custo até","Centro Custo até","Centro Custo até","MV_CH4","C",010,0,0,"G"," "	     ,"CTT"     ," " ," ","MV_PAR04",""            , ""            , ""            , "", ""         , ""         , ""         , "", "", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")
PutSX1(cPerg,"05","Matrícula de "   ,"Matrícula de "   ,"Matrícula de "   ,"MV_CH5","C",006,0,0,"G"," "		 ,"SRA"     ," " ," ","MV_PAR05",""            , ""            , ""            , "", ""         , ""         , ""         , "", "", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")
PutSX1(cPerg,"06","Matrícula até "  ,"Matrícula até "  ,"Matrícula até "  ,"MV_CH6","C",006,0,0,"G"," "		 ,"SRA"     ," " ," ","MV_PAR06",""            , ""            , ""            , "", ""         , ""         , ""         , "", "", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")
Return

