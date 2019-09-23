#INCLUDE "rwmake.ch"
#INCLUDE "font.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRELFLUCX  บAutor  ณGustavo Lattmann    บ Data ณ  07/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio com movimenta็๕es bancแrias utilizado para atua-  บฑฑ
ฑฑบ          ณlizar sistema de fluxo de caixa.                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Cantu                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RELFLUCX()

Local cPerg := "RELFLUCX"
Local cPerg := PadR(cPerg,10," ")
VldPerg(cPerg)  // Chama funcao VldPerg para Verificar se as Perguntas existem no SX1, se nao existir cria

//AjusteSX1(cPerg)
If Pergunte(cPerg,.T.)
	Processa({|| MovFunc() },"Processando...","Selecionando Registros... ")
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMOVFUNC  บAutor  ณGustavo Lattmann     บ Data ณ  07/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MovFunc()  

Local cEol 		:= CHR(10) + CHR(13)
Local cSql 		:= "" 
Local cCod		:= "" 
Local aEmp 		:= {}                                                                                                                                                  
Local nCount 	:= 0
Local oFwMsEx 	:= NIL
Local cDirTmp	:= ""
Local cTable 	:= "RELATำRIO DE MOVIMENTAวรO BANCมRIA" //Tํtulo exibido na primiera linha da planilha
Local cTipo 	:= "Arquivos XLS | *.XLS" 
Local cWorkSheet := 'Mov Bancos' //Nome na planilha
Local cArq 		:= "Mov_Bancos " + STRTRAN(DtoC(MV_PAR01),"/","-") +".xls" //Define o nome do arquivo baseado na data dos parโmetros
Local cCadastro := "Gerar XLS" //Tํtulo da tela de quando gera o arquivo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณAbre a tabela de empresas do sistema e adiciona o c๓digo da empresa no aEmpณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณEfetua a montagem do comando SQL que vai fazer a busca das informa็๕es ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

For i := 1 to Len(aEmp)    

	cSql += " SELECT '"+ aEmp[i] +"' AS EMPRESA, E5_FILIAL, E5_DTDISPO, E5_CLIFOR, E5_NUMERO, E5_TIPODOC, E5_LOJA, E5_SITCOB,	"+cEol
	cSql +=	" E5_RECPAG, E5_CONTA, E5_CCC, E5_CCD, E5_CLVLCR, E5_CLVLDB, E5_HISTOR, E5_NATUREZ, E5_VALOR, E5_RECONC,			"+cEol
	cSql += " E5_AGENCIA, E5_TXMOEDA, E5_PREFIXO, E5_PARCELA, E5_TIPO, E5_MULTNAT, E5_SEQ, E5_RECPAG, E5_KEY					"+cEol
	cSql += " FROM SE5" + aEmp[i] + "0 	"+cEol
	cSql += " WHERE D_E_L_E_T_ <> '*' 	"+cEol
	// Guilherme 11/03/15 Solicitado pelo sr. joao para filtrar apenas tit. com Reconciliacao
	// Edison 26/10/16 Solicitado pelo sr. joao para filtrar apenas tit. diferentes de reconciliados.
	cSql += " AND E5_RECONC <> 'x' 		"+cEol  
	cSql += " AND E5_DTDISPO BETWEEN '"+ DtoS(MV_PAR01) +"' AND '"+ DtoS(MV_PAR02) +"' "+cEol
	
	If i != Len(aEmp)
		cSql += " UNION ALL "+cEol
	EndIf

Next i                                                       

cSql := ChangeQuery(cSql)                                        

TCQUERY cSql NEW ALIAS "TBTMP"


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se a tabela nใo esta vaziaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
TBTMP->(dbGoTop())
if (TBTMP->(Eof()))
		MsgAlert('Nใo existe rela็ใo para os parโmetros informados!')
	TBTMP->(DbCloseArea())
	return
endif

Count To nCount
TBTMP->(dbGoTop())

cont := 0

Procregua(nCount)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAbre a tela para o usuแrio selecionar em qual diretorio deseja salvar o arquivoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cDirTmp := cGetFile( cTipo , "Selecione o local para salvar o arquivo...", 0,"",.F., GETF_RETDIRECTORY + GETF_LOCALHARD)
	
	nCount := 0 
	Count To nCount
	TBTMP->(dbGoTop())
		

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤะ
	//ณInstancia a classe que permite gerar arquivo XLSณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤะ
	oFwMsEx := FWMsExcel():New()	
	
	oFwMsEx:SetBgColorHeader('#C0C0C0') //Define a cor da preenchimento do estilo do Cabe็alho
	oFwMsEx:SetLineBgColor('#FFFFFF') //Define a cor da preenchimento do estilo da Linha
	oFwMsEx:Set2LineBgColor('#FFFFFF') //Define a cor da preenchimento do estilo da Linha 2   
	
    oFwMsEx:SetFontSize(8) //Define o tamanho da fonte da planilha	  
	oFwMsEx:AddWorkSheet( cWorkSheet )
	oFwMsEx:AddTable( cWorkSheet, cTable )	
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Empresa"     		, 1,1)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Filial"      		, 1,1)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Data Disp"	  		, 1,1)  
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Cli/For"	  		, 1,1)  	  
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Num Titulo"  		, 1,1)  	  
    oFwMsEx:AddColumn( cWorkSheet, cTable , "Tipo Doc" 	   		, 1,1)  	  		  
    oFwMsEx:AddColumn( cWorkSheet, cTable , "Loja"	   	   		, 1,1)  	  		  	
    oFwMsEx:AddColumn( cWorkSheet, cTable , "Sit Cobran็a" 		, 1,1)  	  		  					
   	oFwMsEx:AddColumn( cWorkSheet, cTable , "Rec/Pag"	   		, 1,1)  	  		  					
   	oFwMsEx:AddColumn( cWorkSheet, cTable , "Conta"	   			, 1,1)  	  		  						      
   	oFwMsEx:AddColumn( cWorkSheet, cTable , "C.C. Cr้dito"  	, 1,1)  	  		  						      
   	oFwMsEx:AddColumn( cWorkSheet, cTable , "C.C. D้bito"		, 1,1)  	  		  						      
   	oFwMsEx:AddColumn( cWorkSheet, cTable , "Segmento Cr้dito" 	, 1,1)  	  		  						      
   	oFwMsEx:AddColumn( cWorkSheet, cTable , "Segmento D้bito"	, 1,1)  	  		  						                                                                                                                    
   	oFwMsEx:AddColumn( cWorkSheet, cTable , "Hist๓rico"			, 1,1)  	  		  						      
   	oFwMsEx:AddColumn( cWorkSheet, cTable , "Natureza" 			, 1,1)  	  		  						      	      
   	oFwMsEx:AddColumn( cWorkSheet, cTable , "Valor"				, 1,1)  	  		  						      	      
   	oFwMsEx:AddColumn( cWorkSheet, cTable , "Reconciliado"		, 1,1)  	  		  						      	      
   	oFwMsEx:AddColumn( cWorkSheet, cTable , "Agencia"			, 1,1)  	  		  						      	         	      
   	oFwMsEx:AddColumn( cWorkSheet, cTable , "Taxa Moeda"		, 1,1)  	  		  						      	         	      
   	oFwMsEx:AddColumn( cWorkSheet, cTable , "Prefixo"			, 1,1)  	  		  						      	         	      
   	         	      
	Procregua(nCount)
	

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVarre a tabela e grava os registros na planilhaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	While !TBTMP->(Eof()) 
  		Incproc("Aguarde, processando " + cValToChar(nCount) + " registro(s).")
  		
  		                 
  		//--Tratamento para nใo exportar registros de inclusใo/exclusใo de PA/RA
  		If ALLTRIM(TBTMP->E5_TIPODOC) $ "PA/RA/ES"
  			If Empty(TBTMP->E5_NUMERO) .and. !Empty(TBTMP->E5_KEY)
				lLoop := .F.
				cTIPODOC := IIF(ALLTRIM(TBTMP->E5_TIPODOC)$"PA/RA","ES",ALLTRIM(TBTMP->E5_TIPODOC))				
				cQuery := " SELECT COUNT(*) NUMREC 								"
				cQuery += " FROM SE5"+ TBTMP->EMPRESA + "0 SE5 					"
				cQuery += " WHERE SE5.D_E_L_E_T_	= ' ' 					 	"
				cQuery += " AND SE5.E5_FILIAL  		= '"+TBTMP->E5_FILIAL+"' 	"
				cQuery += " AND SE5.E5_KEY 			= '"+TBTMP->E5_KEY+"' 		"
				cQuery += "	AND SE5.E5_TIPODOC		= '"+cTIPODOC+"' 			"
			 	cQuery := ChangeQuery(cQuery)                                        
	
				TCQUERY cQuery NEW ALIAS "TMPEST"
			 	If TMPEST->(!EOF())
			 		If TMPEST->NUMREC > 0
			 			lLoop := .T.
			 		EndIf
			 	EndIf
			 	TMPEST->(dbCloseArea())
  				
  				If lLoop
	  				TBTMP->(dbSkip())
	  				Loop
  				EndIf  				
  			EndIf
  		EndIf        
  		
  		
  		
  		
  		If TBTMP->E5_MULTNAT == "1"   
		    
		  //	dbSelectArea("SEZ")     Guilherme 11-03-15 Comentado para selecionar de forma diferente
			//SEZ->(DbSetOrder(1))
			
			//Guilherme 11-03-15 Consulta para pegar o registro correto na SEZ
			cQuery := "SELECT EZ.EZ_FILIAL,EZ.EZ_PREFIXO,EZ.EZ_NUM,EZ.EZ_PARCELA,EZ.EZ_TIPO,EZ.EZ_CLIFOR,EZ.EZ_LOJA, "
			cQuery += "       EZ.EZ_CCUSTO,EZ.EZ_CLVL,EZ.EZ_NATUREZ,EZ.EZ_VALOR,EZ.EZ_IDENT,EZ.EZ_SEQ "
			cQuery += "  FROM SEZ"+ TBTMP->EMPRESA + "0 EZ "
			cQuery += " WHERE EZ.D_E_L_E_T_ = ' ' "
			cQuery += "   AND EZ.EZ_FILIAL  = '"+TBTMP->E5_FILIAL+"' "
			cQuery += "  	AND EZ.EZ_PREFIXO = '"+TBTMP->E5_PREFIXO+"' "
			cQuery += "		AND EZ.EZ_NUM			= '"+TBTMP->E5_NUMERO+"' "
			cQuery += "		AND EZ.EZ_PARCELA = '"+TBTMP->E5_PARCELA+"' "
			cQuery += "		AND EZ.EZ_TIPO		= '"+TBTMP->E5_TIPO+"' "
			cQuery += "		AND EZ.EZ_CLIFOR  = '"+TBTMP->E5_CLIFOR+"' "
			cQuery += "		AND EZ.EZ_LOJA		= '"+TBTMP->E5_LOJA+"' "
			
		 	cQuery := ChangeQuery(cQuery)                                        

			TCQUERY cQuery NEW ALIAS "TMPSEZ"		
						
		 	If TMPSEZ->(!Eof())
				/* Guilherme 11-03-15 Comentado para refazer com a nova area temporaria
				  If SEZ->(dbSeek(TBTMP->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+Alltrim(E5_TIPO)+E5_CLIFOR+E5_LOJA)) )
					While SEZ->(!EOF()) .AND. (SEZ->EZ_FILIAL==TBTMP->E5_FILIAL) .AND. (SEZ->EZ_PREFIXO==TBTMP->E5_PREFIXO) .AND. ;
					(SEZ->EZ_NUM==TBTMP->E5_NUMERO) .AND. (SEZ->EZ_PARCELA==TBTMP->E5_PARCELA) .AND. ;
					(SEZ->EZ_TIPO==TBTMP->E5_TIPO) .AND. (SEZ->EZ_CLIFOR==TBTMP->E5_CLIFOR) .AND. ;
					(SEZ->EZ_LOJA==TBTMP->E5_LOJA)   */
				 While TMPSEZ->(!EOF()) .AND. (TMPSEZ->EZ_FILIAL==TBTMP->E5_FILIAL) .AND. (TMPSEZ->EZ_PREFIXO==TBTMP->E5_PREFIXO) .AND. ;
					(TMPSEZ->EZ_NUM==TBTMP->E5_NUMERO) .AND. (TMPSEZ->EZ_PARCELA==TBTMP->E5_PARCELA) .AND. ;
					(TMPSEZ->EZ_TIPO==TBTMP->E5_TIPO) .AND. (TMPSEZ->EZ_CLIFOR==TBTMP->E5_CLIFOR) .AND. ;
					(TMPSEZ->EZ_LOJA==TBTMP->E5_LOJA)	
					
					If TMPSEZ->EZ_IDENT == "2" .and. TMPSEZ->EZ_SEQ == TBTMP->E5_SEQ

					    cE5_CCC		:= TBTMP->E5_CCC
					    cE5_CCD		:= TBTMP->E5_CCD
					    cE5_CLVLCR	:= TBTMP->E5_CLVLCR
					    cE5_CLVLDB	:= TBTMP->E5_CLVLDB
					    cE5_NATUREZ	:= TMPSEZ->EZ_NATUREZ
					    nE5_VALOR	:= TMPSEZ->EZ_VALOR
					    If TBTMP->E5_RECPAG == "R"
						    cE5_CCC		:= TMPSEZ->EZ_CCUSTO
						    cE5_CLVLCR	:= TMPSEZ->EZ_CLVL
					    Else
						    cE5_CCD		:= TMPSEZ->EZ_CCUSTO
						    cE5_CLVLDB	:= TMPSEZ->EZ_CLVL
					    EndIf
					    
					    // Guilherme 11-03-15 Alterado de SEZ-> PARA TMPSEZ->
					    oFwMsEx:AddRow( cWorkSheet, cTable, { VAL(TBTMP->EMPRESA), TBTMP->E5_FILIAL, TBTMP->E5_DTDISPO, TBTMP->E5_CLIFOR, TBTMP->E5_NUMERO, TBTMP->E5_TIPODOC, ;
				    				TBTMP->E5_LOJA, TBTMP->E5_SITCOB, TBTMP->E5_RECPAG, TBTMP->E5_CONTA, cE5_CCC, cE5_CCD, cE5_CLVLCR, cE5_CLVLDB,;
				    				TBTMP->E5_HISTOR, cE5_NATUREZ, nE5_VALOR, TBTMP->E5_RECONC, TBTMP->E5_AGENCIA, TBTMP->E5_TXMOEDA, TBTMP->E5_PREFIXO} )			
					EndIf
					TMPSEZ->(dbSkip())
				 Enddo				
			EndIf   
			TMPSEZ->(DbCloseArea())  //Guilherme 11-03-15 - Fim
				
	    Else
	    
		    oFwMsEx:AddRow( cWorkSheet, cTable, { VAL(TBTMP->EMPRESA), TBTMP->E5_FILIAL, TBTMP->E5_DTDISPO, TBTMP->E5_CLIFOR, TBTMP->E5_NUMERO, TBTMP->E5_TIPODOC, ;
	    				TBTMP->E5_LOJA, TBTMP->E5_SITCOB, TBTMP->E5_RECPAG, TBTMP->E5_CONTA, TBTMP->E5_CCC, TBTMP->E5_CCD, TBTMP->E5_CLVLCR, TBTMP->E5_CLVLDB,;
	    				 TBTMP->E5_HISTOR, TBTMP->E5_NATUREZ, TBTMP->E5_VALOR, TBTMP->E5_RECONC, TBTMP->E5_AGENCIA, TBTMP->E5_TXMOEDA, TBTMP->E5_PREFIXO} )			
	  		
  		EndIf
  		
  		TBTMP->(dbSkip()) 
  
	EndDo   
	
	oFwMsEx:Activate()
	
	LjMsgRun( "Gerando o arquivo, aguarde...", cCadastro, {|| oFwMsEx:GetXMLFile( cArq ) } )
	If __CopyFile( cArq, cDirTmp + cArq )
		If MsgYesNo("Deseja abrir o arquivo gerado?","Abrir arquivo")
			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open( cDirTmp + cArq )
		 	oExcelApp:SetVisible(.T.)
		EndIf
	Else
		MsgInfo( "Arquivo nใo copiado para temporแrio do usuแrio." )
	Endif  
	TBTMP->(DbCloseArea()) 

Return   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVLDPERG  บAutor  ณGustavo Lattmann     บ Data ณ  07/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel pelo parโmetros informados pelo usuแrio  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณProtheus                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldPerg(cPerg)

PutSX1(cPerg,"01","Data de "	,"Data de "   ,"Data de "  ,"MV_CH1","D",008,0,0,"G","","","","","MV_PAR01","","","","","","","","","", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")
PutSX1(cPerg,"02","Data at้ "	,"Data at้ "  ,"Data at้ " ,"MV_CH1","D",008,0,0,"G","","","","","MV_PAR02","","","","","","","","","", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")

Return
