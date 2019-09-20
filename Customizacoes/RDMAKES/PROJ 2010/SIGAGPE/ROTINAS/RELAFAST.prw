/*---------------------------------------------------------------------------+
!                       FICHA TECNICA DO PROGRAMA                            !
+----------------------------------------------------------------------------+
!                          DADOS DO PROGRAMA                                 !
+------------------+---------------------------------------------------------+
!Autor             ! Keslen de Andrade Deléo                                 !
+------------------+---------------------------------------------------------+
!Descricao         ! Relatório de Afastamentos					             !
+------------------+---------------------------------------------------------+
!Nome              ! RELAFAST                                                !
+------------------+---------------------------------------------------------+
!Data de Criação   ! 06/11/2013                                              !
+-------------------------------------------+-----------+-----------+-------*/
#INCLUDE "rwmake.ch"
#INCLUDE "font.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"

User Function RELAFAST()
/*======================================================
****** Parametros ******
========================================================
mv_par01 ---> Filial de
mv_par02 ---> Filial até
mv_par03 ---> Centro Custo de
mv_par04 ---> Centro Custo até
mv_par05 ---> Matricula de
mv_par06 ---> Matricula até
mv_par07 ---> Data de
mv_par08 ---> Data até
mv_par09 ---> Gera Excel?


======================================================*/    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

cPerg := "RELAFAST"
cPerg := PadR(cPerg,10," ")
VldPerg(cPerg)  // Chama funcao VldPerg para Verificar se as Perguntas existem no SX1, se nao existir cria

AjusteSX1(cPerg)
If Pergunte(cPerg,.T.)
	//nHdl    := fCreate(cArqTxt)
	Processa({|| MovFunc() },"Processando...","Selecionando Registros... ")
EndIf
Return

Static Function MovFunc()  


Public oPrn   := tAvPrinter():New( "RELATÓRIO DE MOVIMENTAÇÕES" ),;
oBrush		  := TBrush():New(,4),;    // Definicao de Preenchimento
oPen		  := TPen():New(0,5,CLR_BLACK),;  // Definicao da Espessura da Impressao
cLogotipo 	  := "\SIGAADV\NEWBRITA.BMP" ,;
oFont6N 	  := TFont():New( "Arial",,06,,.T.,,,,,.F.),;  // Definicao das Fontes (Instaladas no Windows)
oFont6		  := TFont():New( "Arial",,06,,.F.,,,,,.F.),;
oFont7N	      := TFont():New( "Arial",,07,,.T.,,,,,.F.),;
oFont7		  := TFont():New( "Arial",,07,,.F.,,,,,.F.),;
oFont8N		  := TFont():New( "Arial",,08,,.T.,,,,,.F.),;
oFont8		  := TFont():New( "Arial",,08,,.F.,,,,,.F.),;
oFont9N		  := TFont():New( "Arial",,09,,.T.,,,,,.F.),;
oFont9		  := TFont():New( "Arial",,09,,.F.,,,,,.F.),;
oFont10N	  := TFont():New( "Arial",,10,,.T.,,,,,.F.),;
oFont10		  := TFont():New( "Arial",,10,,.F.,,,,,.F.),;
oFont11N	  := TFont():New( "Arial",,11,,.T.,,,,,.F.),;
oFont11 	  := TFont():New( "Arial",,11,,.F.,,,,,.F.),;
oFont12N	  := TFont():New( "Arial",,12,,.T.,,,,,.F.),;
oFont12	      := TFont():New( "Arial",,12,,.F.,,,,,.F.),;
oFont13N	  := TFont():New( "Arial",,13,,.T.,,,,,.F.),;
oFont13	      := TFont():New( "Arial",,13,,.F.,,,,,.F.),;
oFont14N	  := TFont():New( "Arial",,14,,.T.,,,,,.F.),;
oFont14	      := TFont():New( "Arial",,14,,.F.,,,,,.F.),;
oFont15N	  := TFont():New( "Arial",,15,,.T.,,,,,.F.),;
oFont15	      := TFont():New( "Arial",,15,,.F.,,,,,.F.),;
oFont16N	  := TFont():New( "Arial",,16,,.T.,,,,,.F.),;
oFont16	      := TFont():New( "Arial",,17,,.F.,,,,,.F.)

_cQry := " SELECT RA_FILIAL, RA_MAT ,(CASE WHEN RA_NOMECMP <> ' ' THEN RA_NOMECMP ELSE RA_NOME END) NOME, R8_DATAINI, R8_DATAFIM, R8_AFARAIS, R8_TIPO, RA_CC,"
_cQry += " RA_CODFUNC,RA_CARGO, SRJ.RJ_DESC FUNCAO,SRJ.RJ_CARGO ,"
_cQry += " (select CTT_DESC01 FROM "+ RetSqlName("CTT") +" WHERE CTT_CUSTO = RA_CC  and D_E_L_E_T_ <> '*') CC_DESC, "
_cQry += " (SELECT X5_DESCRI FROM  "+ RetSqlName("SX5") +" SX5 WHERE SX5.D_E_L_E_T_ <> '*' AND X5_FILIAL = R8_FILIAL AND X5_TABELA = '30' AND X5_CHAVE = R8_TIPO) TIPO,  " 
_cQry += " (SELECT Q3_DESCSUM FROM "+ RetSqlName("SQ3") +" SQ3 WHERE SQ3.D_E_L_E_T_ <> '*' AND Q3_CARGO = (CASE WHEN RA_CARGO <> ' ' THEN RA_CARGO ELSE RJ_CARGO END)  ) CARGO  
_cQry += " FROM " + RetSqlName("SRA") + " SRA "     
_cQry += " INNER JOIN " + RetSqlName("SR8") + " SR8 ON RA_FILIAL = R8_FILIAL AND RA_MAT = R8_MAT "
_cQry += " LEFT JOIN " + RetSqlName("SRJ") + " SRJ ON RJ_FUNCAO = RA_CODFUNC AND SRJ.D_E_L_E_T_ <> '*' "
_cQry += " WHERE SRA.D_E_L_E_T_ <> '*' "
_cQry += "   AND SR8.D_E_L_E_T_ <> '*' "
_cQry += "   AND SR8.R8_TIPO <> 'F' "
_cQry += "   AND RA_FILIAL BETWEEN '"+ mv_par01 +"' AND '"+ mv_par02 +"' " //FILIAL
_cQry += "   AND RA_CC BETWEEN '"+ mv_par03 +"' AND '"+ mv_par04 +"' " //CENTRO CUSTO
_cQry += "   AND RA_MAT BETWEEN '"+ mv_par05 +"' AND '"+ mv_par06 +"' " //MATRICULA
_cQry += "   AND ((R8_DATAINI BETWEEN '"+ DTOS(mv_par07) +"' AND '"+ DTOS(mv_par08) +"') " //DATA ADMISSÃO
_cQry += "   		OR (R8_DATAFIM BETWEEN '"+ DTOS(mv_par07) +"' AND '"+ DTOS(mv_par08) +"')) " //DATA ADMISSÃO
_cQry += " ORDER BY RA_FILIAL, RA_MAT, R8_DATAFIM "

TCQUERY _cQry NEW ALIAS "AFA"

AFA->(dbGoTop())

if (AFA->(Eof()))
	MsgAlert('Não existe relação para os parâmetros informados!')
	AFA->(DbCloseArea())
	return
endif

nCount := 0
Count To nCount
AFA->(dbGoTop())

cont := 0

Procregua(nCount)

IF MV_PAR09 = 2  
	oPrn:SetLandscape()
	//oPrn:SetPortrait()

	oPrn:StartPage()  // Inicio da Pagina
	nTipo := 0

	nLinha := 300
	nTipo := 2
	CabecOP() // Imprime o Cabecalho da OP
	
	
	While !AFA->(Eof())
		
		if (nLinha >= 2450)
			oPrn:EndPage() // Fim da Pagina
			cont := 0
			nLinha := 300
			oPrn:StartPage()
			CabecOp()
		endif

		oPrn:Say(nLinha,60,AFA->RA_FILIAL,oFont9) //FILIAL
		oPrn:Say(nLinha,135,AFA->RA_MAT,oFont9)	  //MATRICULA
		oPrn:Say(nLinha,290,AFA->NOME,oFont9)	  //NOME
		oPrn:Say(nLinha,1200,DTOC(STOD(AFA->R8_DATAINI)),oFont9)	  //DATA INICIAL
		oPrn:Say(nLinha,1400,DTOC(STOD(AFA->R8_DATAFIM)),oFont9)	  //DATA FINAL
		oPrn:Say(nLinha,1600,AFA->TIPO,oFont9)	  //TIPO AFASTAMENTO
		nLinha := nLinha + 35 
		nLinha := nLinha + 50 
		cont := cont + 1
		AFA->(dbSkip())
		
	EndDo
	AFA->(DbCloseArea()) 

	oPrn:EndPage() // Fim da Pagina
	oPrn:Preview()
	
ELSE  // Gera Excel

	oFwMsEx := NIL
	cArq := ""
	cDir := GetSrvProfString("Startpath","")
	cWorkSheet := ""
	cTable := ""
	cDirTmp := GetTempPath()   
	cCadastro := "Gerar XML"   		  
		  nCount := 0 
		  Count To nCount
		  AFA->(dbGoTop())
		  cWorkSheet := 'Afastamentos'
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
		  oFwMsEx:AddColumn( cWorkSheet, cTable , "Data Inicial", 1,1)  	  
		  oFwMsEx:AddColumn( cWorkSheet, cTable , "Data Final", 1,1)  	  
	      oFwMsEx:AddColumn( cWorkSheet, cTable , "Tipo Afastamento", 1,1)  	  		  
	
		
		  Procregua(nCount)
		  While !AFA->(Eof()) 
		    Incproc("Aguarde, processando " + cValToChar(nCount) + " afastamento(s).")   
		    oFwMsEx:AddRow( cWorkSheet, cTable, { AFA->RA_FILIAL, AFA->RA_MAT, AFA->NOME, DTOC(STOD(AFA->R8_DATAINI)),DTOC(STOD(AFA->R8_DATAFIM)),AFA->TIPO } )			
		  	AFA->(dbSkip()) 
		  
		  EndDo   
		  oFwMsEx:Activate()
		  cArq := CriaTrab( NIL, .F. ) + ".xls"
			LjMsgRun( "Gerando o arquivo, aguarde...", cCadastro, {|| oFwMsEx:GetXMLFile( cArq ) } )
			If __CopyFile( cArq, cDirTmp + cArq )
			   //	If aRet[3]
		  			oExcelApp := MsExcel():New()
					oExcelApp:WorkBooks:Open( cDirTmp + cArq )
			 		oExcelApp:SetVisible(.T.)
			//	Else
			 //		MsgInfo( "Arquivo " + cArq + " gerado com sucesso no diretório " + cDir )
			  ///	Endif
			Else
				MsgInfo( "Arquivo não copiado para temporário do usuário." )
			Endif  
			AFA->(DbCloseArea()) 

endif

Return   

Static Function CabecOP()

if (nLinha > 300)
	oPrn:EndPage() // Fim da Pagina
	cont := 0
	nLinha := 300
	oPrn:StartPage()
	
endif

oPrn:Box(45,40,280,3300)//Quadradinho 
oPrn:Say(110,1100,("Relatório de Afastamentos"),oFont15N)
nLinha := 300
		nLinha := nLinha + 80
		oPrn:Say(nLinha,60,"Fil",oFont10N) //FILIAL
		oPrn:Say(nLinha,135,"Mat",oFont10N)	  //MATRICULA
		oPrn:Say(nLinha,300,"Nome",oFont10N)	  //NOME
		oPrn:Say(nLinha,1200,"Data Inicial",oFont10N)	  //Data Final
		oPrn:Say(nLinha,1400,"Data Final",oFont10N)	  //Data Inicial
		oPrn:Say(nLinha,1600,"Tipo Afastamento",oFont10N)	  //Afastamento
		nLinha := nLinha + 80


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
PutSX1(cPerg,"05","Matrícula de "   ,"Matrícula de "   ,"Matrícula de "   ,"MV_CH5","C",006,0,0,"G"," "		 ," "     ," " ," ","MV_PAR05",""            , ""            , ""            , "", ""         , ""         , ""         , "", "", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")
PutSX1(cPerg,"06","Matrícula até "  ,"Matrícula até "  ,"Matrícula até "  ,"MV_CH6","C",006,0,0,"G"," "		 ," "     ," " ," ","MV_PAR06",""            , ""            , ""            , "", ""         , ""         , ""         , "", "", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")
PutSX1(cPerg,"07","Data de "        ,"Data de "        ,"Data de "        ,"MV_CH7","D",008,0,0,"G"," "		 ," "     ," " ," ","MV_PAR07",""            , ""            , ""            , "", ""         , ""         , ""         , "", "", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")
PutSX1(cPerg,"08","Data até "       ,"Data até "       ,"Data até "       ,"MV_CH8","D",008,0,0,"G"," "      ," "     ," " ," ","MV_PAR08",""     	     , ""            , ""            , "", ""         , ""         , ""         , "", "", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")
PutSX1(cPerg,"09","Gerar Excel"     ,"Gerar Excel"     ,"Gerar Excel"     ,"MV_CH9","C",001,0,0,"C"," "      ," "     ," " ," ","MV_PAR09","Sim"   	     , ""            , ""            , "", "Não"         , ""         , ""         , "", "", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")

Return




