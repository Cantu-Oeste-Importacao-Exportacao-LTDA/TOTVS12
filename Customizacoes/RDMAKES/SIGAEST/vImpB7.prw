#Include 'Protheus.ch'

#DEFINE CR	chr(13)+chr(10)
#DEFINE LF 	Replicate('-',80)
/*/{Protheus.doc} vImpB7
Wizard que importa os produtos para o uso no inventario;
@author Tiago.leao
@since 19/08/2015
@version 1.0
@return Nil
/*/User Function vImpB7()
Private oWinWiz		:= Nil 
Private	cFileCSV 	:= Space(1)
Private lCabec		:= .f.
Private	cFunName	:= 'vImpB7'
Private	cEventos	:= ' '
Private	aColOrder	:= {{'B7_COD',.T.,' '},{'B7_LOCAL',.T.,' '},{'B7_QUANT',.T.,0},{'B7_FILIAL',.F.,xFilial("SB7")},;
						{'B7_DATA',.F.,dDatabase},{'B7_DOC',.F.,StrTran(DtoC(dDatabase),'/')}}
Private	nMinCols	:= 0
Private	nMaxCols	:= Len(aColOrder)
Private	aTelas		:= {"Selecione o arquivo no formato CSV com os dados para importação.",;
						"Confira se as colunas previamente selecionadas conferem com "+CR+"o respectivo valor e avance para iniciar a importação.",;
						"Confira o log de processamento para ver os produtos incluidos."}
	
	aEval(aColOrder,{|x| nMinCols+=IIF(x[2],1,0)})
						
	oWinWiz := ApWizard():New(cFunName,"Inclusao de produtos para inventario",;
			 AllTrim(Capital(FWFilialName())),;
			 "Atenção: Este programa é um facilitador para inventariar as quantidades de um produto."+CR+;
			 "Esteja atento aos dados para garantir a integridade das informações contidas no arquivo CSV.",;
			  {|| WizNext() }, {|| WizFinish() } )

	For nx:=1 to Len (aTelas)
		oWinWiz:NewPanel(cFunName,"Passo "+StrZero(nx,2)+": "+aTelas[nx],;
				{ || WizBack()},;
				{|| WizNext()},;
				{|| WizFinish() },;
				 .T./*TPanel ou Scroll*/,;
				 {|| xExecWin()} )
	Next nx
		
	oWinWiz:Activate( .T.,/*bValid*/, /*bInit*/, /*bWhen*/ )


Return


//------------------------------------------
// FUNCOES DE CONTROLE DE TRANSIÇÃO DE TELAS
//------------------------------------------

Static Function WizBack()
Local nPAtu		:= oWinWiz:nPanel
Local oBtBack	:= oWinWiz:oBack
Local lCanBack	:= .t.


	Do Case 
		Case	nPAtu == 1 
			lCanBack	:= .f.  
		Case	nPAtu == 2
			lCanBack	:= .t.
		Case	nPAtu == 3
			lCanBack	:= .t.
		Case	nPAtu == 4
			lCanBack	:= .f.
		OtherWise
			lCanBack	:= .f.
	End Case
	
	If ! lCanBack
		oBtBack:Disable()
	Else
		oBtBack:Show()
	EndIf
		oBtBack:Refresh()
Return lCanBack

//Funcao que verifica se habilita ou nao avançar para proxima tela.
Static Function WizNext()
Local nPAtu		:= oWinWiz:nPanel
Local lCanNext	:= .T.
	
		If nPAtu == 2 .and. ( Empty(cFileCSV) .or. ! File(cFileCSV))
			lCanNext := .F.
			Alert('Selecione um arquivo valido!')	
		EndIf
		
Return lCanNext


Static Function WizFinish()
Local nPAtu		:= oWinWiz:nPanel
Local lCanEnd:= .t.

	Do Case 
		Case	nPAtu == 1 
			lCanEnd	:= .t.  
		Case	nPAtu == 2
			lCanEnd	:= .f.
		Case	nPAtu == 3
			lCanEnd	:= .f.
		Case	nPAtu == 4
			lCanEnd	:= .t.
		OtherWise
			lCanEnd	:= .f.
	End Case
	
Return lCanEnd


Static Function xExecWin()
Local nPAtu		:= oWinWiz:nPanel
Local oPanel	:= oWinWiz:GetPanel(nPAtu)
Local lCanEnd	:= .t.


	Do Case 
		Case	nPAtu == 2
			xSelectCSV(oPanel)
		Case	nPAtu == 3
			xSelCols(oPanel)
		Case	nPAtu == 4
			Processa( {||xImpSB7(oPanel)},'Inserindo Inventario','Iniciando Sincronismo',.T.)
	End Case


Return .t.


//------------------------------------------
// 			FUNCOES AUXILIARES
//------------------------------------------


Static Function xSelectCSV(oPanel)
Local oGet		:= Nil
Local bAction 	:= {|| cPath:=cGetFile( 'Separado por virgula |*.csv' , 'Selecione o arquivo *.CSV',1,'C:\',.T.,nOr(GETF_LOCALHARD,GETF_NETWORKDRIVE),.F.,.T. ),oGet:CtrlRefresh(),cFileCSV:=cPath}
Local cPath		:= IIF(!Empty(cFileCSV),cFileCSV,Space(150))
		
		TSay():New(010,005, { || OemToAnsi("Pesquisar Arquivo: ") }, oPanel,,,.F.,.F.,.F.,.T.,CLR_BLUE,,050,09,.F.,.F.,.F.,.F.,.F.)
		oGet := TGet():New( 025,005,{|u| If(Pcount()==0, cPath,cPath:=u)},oPanel,150,009,"@!",,,,,,,.T.,,,,,,,.T. /*R.O.*/,,,'cPath')
		oBtn := TButton():New(025, 160, "Procurar" ,oPanel,bAction,40,10,,,.F.,.T.)
		
Return cPath

//---------------------------------------------------------------
//Permite o usuario escolher qual é a coluna respectiva ao campo. 
//---------------------------------------------------------------

Static Function xSelCols(oPanel)
Local oCheck	:= Nil
Local aX3Area	:= SX3->(GetArea())
Local nHandle	:= FT_FUse(cFileCSV) //Abre arquivo para ler a primeira linha
Local nError	:= 0
Local aCabec	:= {}
Local aContent	:= {}
Local nC		:= 1
Private	oBrwCols:= Nil
Private cVal	:= ""


		//Verifica se pôde abrir o arquivo com sucesso
		If	nHandle == -1    
			nError:= fError()
			Do Case
			  Case nError == 516
				cErr:= 'O arquivo esta sendo usado por outro processo!'
			  Case nError == 13
				cErr:= 'Acesso negado!'
			  Otherwise
			  	cErr:= 'Codigo:'+Str(nErro,4)
			EndCase			
			MsgStop('Erro ao tentar abrir o arquivo '+cFile+' :'+cErr)
			Return .F.
		EndIf

	aCabec:=StrTokArr(FT_FReadLn(),';')
	
	DbSelectArea('SX3')
	If Len(aCabec) >= nMinCols 
		
		For nC:=1 To Len(aCabec)
			If IsAlpha(aCabec[nC]) //VERIFICA SE A PRIMEIRA LINHA É DESCRITIVA E MARCA COMO CABEÇALHO
				lCabec:=.t.
				Exit
			EndIf
		Next nC
		aADD(aContent,aCabec)
		oCheck := TCheckBox():New(010,005,'Minha planilha possui cabeçalho.',{|u| If(PCount()==0,lCabec,lCabec:=u)},oPanel,120,10,,,,,,,,.T.) 
		TSay():New(025,005, { || OemToAnsi("Verifique se os dados do arquivo correspondem com as colunas abaixo:")}, oPanel,,,.F.,.F.,.F.,.T.,CLR_BLUE,,250,09,.F.,.F.,.F.,.F.,.F.)
		oBrwCols:=TcBrowse():New(040,005,Min(350,Len(aCabec)*35),040,,,,oPanel,,,,,,,,,,,,.F.,,.T.,,.F.)
		For nX:=1 to Len(aCabec)
			If nX <= nMaxCols
				SX3->(DbSetOrder(2))//X3_CAMPO
				SX3->(DbSeek(aColOrder[nX,1]))
				oBrwCols:AddColumn(TCColumn():New(SX3->X3_TITULO,&("{|| aContent[1,"+V2C(nX)+"] }"),,,,"LEFT",5,.F.,.F.))
			Else
				Exit
			EndIf
	 	Next nX
	 	oBrwCols:SetArray(aContent)
		oBrwCols:Refresh()
	 
	Else 
		MsgAlert('Erro: Verifique se a estrutura do arquivo contem pelo menos '+V2C(nMinCols)+' colunas separadas por ponto e virgula')
 	EndIf
 
 
 	FT_FUse() //Fecha o arquivo em uso
 	RestArea(aX3Area)
 
Return .t.
 

 
Static Function xImpSB7(oPanel)
Local oHistory	:= Nil
Local nHandle	:= FT_FUse(cFileCSV) //Abre arquivo para ler a primeira linha
Local nError	:= 0
Local aLine		:= {}
Local nLin		:= 0
Local nAlt		:= 0
Local cFile		:= ''
Local nSzPrd	:= TamSx3("B2_COD")[1]
Local nSzArm	:= TamSx3("B2_LOCAL")[1]
Local nSzFil	:= TamSx3("B2_FILIAL")[1]
Local cProd		:= Space(nSzPrd)
Local cArmPad	:= Space(nSzArm)
Local xData		:= Nil
Local bAction 	:= {|| cFile:=cGetFile( 'Texto |*.txt' , 'Salvar arquivo de LOG',1,'C:\',.F.,nOr(GETF_LOCALHARD,GETF_NETWORKDRIVE),.F.,.T. ),IIF(!Empty(cFile),MemoWrite(cFile,cEventos),)}
Local aPrdADD	:= {}
Local lContinua	:= .t.
Private lMsErroAuto := .F.


		//Verifica se pôde abrir o arquivo com sucesso
		If	nHandle == -1    
			nError:= fError()
			Do Case
			  Case nError == 516
				cErr:= 'O arquivo esta sendo usado por outro processo!'
			  Case nError == 13
				cErr:= 'Acesso negado!'
			  Otherwise
			  	cErr:= 'Codigo:'+Str(nErro,4)
			EndCase			
			MsgStop('Erro ao tentar abrir o arquivo '+cFile+' :'+cErr)
			Return .F.
		EndIf
		 
		ProcRegua(FT_FLastRec())

		//Vai para a Primeira Linha do Arquivo CSV
		FT_FGoTop()

		DbSelectArea('SB7')
		DbSelectArea('SB2')
		DbSelectArea('SB1')
		xAddLog('INICIANDO IMPORTACAO DE PRODUTOS -  '+DtoC(Date())+' '+Time())
		xAddLog(LF)
		While ! FT_FEof() //Enquanto nao for final do arquivo
			nLin++
			If lCabec //Se o arquivo possui cabeçalho avança uma linha
			    FT_FSkip()
				lCabec:=.f.			
			EndIf
			
			aLine:=StrTokArr(FT_FReadLn(),';')//Le a linha atual
						
			If Len(aLine) <= nMaxCols  .and. Len(aLine) >= nMinCols
			
				cProd	:=PaD(AllTrim(aLine[xPos('B7_COD')]),nSzPrd)
				cArmPad	:=PaD(AllTrim(aLine[xPos('B7_LOCAL')]),nSzArm)
				nQtd	:=xValTrans(aLine[xPos('B7_QUANT')])
				
				IncProc('PRODUTO: '+cProd)
				
				SB1->(DbSetOrder(1))
				IF SB1->(DbSeek(xFilial('SB1')+cProd))
				
					If SB1->B1_MSBLQL == '1'
						lContinua:=.F.
						xAddLog('CADASTRO DO PRODUTO: '+cProd+' BLOQUEADO.')
					EndIF
					SB2->(DbSetOrder(1))
					If !SB2->(DbSeek(xFilial("SB2")+cProd+cArmPad))
						xAddLog('CRIANDO REGISTRO DE SALDO PARA O PRODUTO: '+cProd+' NA FILIAL: '+xFilial("SB2"))
						CriaSb2(cProd,cArmPad)
					ElseIf SB2->B2_STATUS == "2"
						xAddLog('SALDO DO PRODUTO: '+cProd+' BLOQUEADO NA FILIAL: '+xFilial("SB2"))
						lContinua:=.f.
					EndIf
					
					If lContinua
					
						SB7->(DbSetOrder(1)) //B7_FILIAL+DTOS(B7_DATA)+B7_COD+B7_LOCAL
						If !SB7->(DbSeek(xFilial("SB7")+DTOS(dDatabase)+cProd+cArmPad))
							nOpc:=3
						Else
							nOpc:=4
						EndiF
						
						For nA:=1 to Len(aColOrder)
							SX3->(DbSetOrder(2))//X3_CAMPO
							SX3->(DbSeek(aColOrder[nA,1]))
							
							If xPos(aColOrder[nA,1]) <= Len(aLine) 
								If SX3->X3_TIPO == 'N'
									xData:=xValTrans(aLine[nA])
								ElseIf SX3->X3_TIPO == 'C'
									xData:=PaD(AllTrim(aLine[nA]),SX3->X3_TAMANHO)
								EndIf
							Else
								xData:=aColOrder[nA,3] //Valor Inicial para o campo
							EndIf
							
							aADD(aPrdADD,{aColOrder[nA,1],xData,Nil})
						Next nA
					EndIf
						
				Else
					xAddLog('PRODUTO '+cProd+' SEM CADASTRO.')
					xAddLog(LF+CR)
				EndIf
			Else
				xAddLog('INCONSISTENCIA DE REGISTROS. LINHA -> '+StrZero(nLin,4))
			EndIf
			
			If Len(aPrdADD) > 0
				If nOpc==4 .and. !SB7->(FOUND())
					xAddLog('ERRO NO POSICIONAMENTO DO SB7')
					lContinua:=.f.
				EndIf
				If lContinua
				
					xAddLog('REGISTRO '+IIF(nOpc==3,'INCLUIDO','ALTERADO')+': '+cProd+' - '+cArmPad)
					lMsErroAuto:=.F.
			    	MSExecAuto({|x,y,z| MATA270(x,y,z)},aPrdADD,.F.,nOpc)
			    	
			    	If lMsErroAuto
			    		MostraErro("/log/","MATA270_"+StrZero(nLin,4)+".txt")
			    		xAddLog('ERRO NA ROTINA AUTOMATICA LINHA:'+StrZero(nLin,4))
				    Else
				    	nAlt++
				    EndIf
				    
				EndIf
		    EndIf

		    aPrdADD		:= {}
		    lContinua	:= .t.
		    FT_FSkip()
		End Do
		
		xAddLog(V2C(nAlt)+' DE '+V2C(nLin)+' REGISTRO(S) IMPORTADOS(S).')

		FT_FUse() //Fecha o arquivo em uso
		
		oHistory:=TSimpleEditor():New(005,005,oPanel,285,110,' ',.T./*readonly*/,,,.T./*pixel*/)
		oHistory:Align:=CONTROL_ALIGN_TOP
		oHistory:TextFormat(2) //1-HTML | 2-Texto simples
		oHistory:TextAlign(4) //Alinha o texto justificado
		oHistory:Load(cEventos)
		oHistory:Refresh()
		
		TButton():New(125, 240, "Salvar Log" ,oPanel,bAction,40,10,,,.F.,.T.)
	
Return

Static Function xPos(cField)
Return aScan(aColOrder,{|Z| Z[1]==cField})

Static Function xValTrans(cVal)
Local	nValor	:= 0

		If	ValType(cVal) == 'C'
			If	IsDigit(cVal)
				cVal:= StrTran(cVal,'.',',')
				cVal:= StrTran(cVal,',','.')
				nValor:= Val(cVal)
			EndIf
		EndIf

Return nValor 

Static Function Any2Char(xDataIn,lAGG)   
LOCAL	xData       := "" 
Local 	cDataOut	:= " "
DEFAULT xDataIn		:= ""                
DEFAULT lAGG		:= .F.


	 Do Case                  
	 	Case ValType(xDataIn) == 'A'  
	 	  	For nA:=1 to	Len(xDataIn)  
	 	  	 	xData	+= Any2Char(xDataIn[nA],.T.)
			Next nA		                  
	 	Case ValType(xDataIn) == 'B'
			xData	:= Any2Char(Eval(xDataIn))  
		Case ValType(xDataIn) == 'C' 
			xData	:= xDataIn   
	 	Case ValType(xDataIn) == 'D' 
			xData	:= DtoC(xDataIn)
		Case ValType(xDataIn) == 'L'
			If xDataIn
				xData	:= '.T.'
			Else 
				xData	:= '.F.'
			EndIF               
		Case ValType(xDataIn) == 'N'
			xData	:= V2C(xDataIn)
		Case ValType(xDataIn) == 'O'  
			xData	:= ''
		OtherWise     
			xData	:= '' 
	 End Case

	//Agrega itens por um separador ;
	If lAGG
		xData		+= ';'
		cDataOut	:= xData
	Else
   		cDataOut	:= xData	
	EndIf

Return cDataOut      

Static Function V2C(nVal)
Return cValToChar(nVal)

Static Function xAddLog(_cText)
Default	_cText := ""
cEventos += _cText + CR
Return
