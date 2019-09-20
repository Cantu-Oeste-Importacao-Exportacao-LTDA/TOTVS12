#include "rwmake.ch" 
#include "colors.ch"
#include "Topconn.ch"
#include "Protheus.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPCLI001 º Autor ³ Adriano Novachaelley Data ³  26/09/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Importação de Clientes.                                    º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 		                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function IMPCLICDX()
Local aCli := {}
Private cFile := 	Space(100)  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

    
@ 140,100 TO 300,430 DIALOG oDlg1 TITLE "Importação de Clientes"
// @ 005,005 TO 060,160
@ 010,010 Say "O arquivo DTC:" PIXEL
@ 010,070 Get cFile Size 60, 10 PIXEL
@ 010,140 BUTTON "..." SIZE 10, 10 ACTION (cFile := cGetFile( "DTC | *.dtc" , "Selecione o arquivo DTC", 0,"",.T.)) PIXEL
@ 065,100 BMPBUTTON TYPE 1 ACTION Processa({|| ProcArq() }) 
@ 065,130 BMPBUTTON TYPE 2 ACTION Finaliza()
ACTIVATE DIALOG oDlg1 CENTER
    
Return()


Static Function ProcArq()
Local cEOL    	:= "CHR(13)+CHR(10)"
Local cAliasTmp := GetNextAlias()
Local cArqTmp
Local aCposTmp := {}
Local aFields := {"A1_COD", "A1_LOJA", "A1_NOME", "A1_END", "A1_MUN", "A1_COD_MUN", "A1_BAIRRO", "A1_CEP", "A1_CODPAIS","A1_EST", "A1_INSCR"}
Local lSohAtivos := .F.

Private nSA1 	:= fCreate("c:\logImpCli.txt") // Local para log

If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

lSohAtivos := MsgBox("Importar somente ativos","Imp. Clientes","YESNO")

MsOpEndbf(.T.,"CTREECDX",cFile,"TMPA1",.F.,.F.,.F.,.F.)
       
TMPA1->(DbSelectArea("TMPA1"))
TMPA1->(DbGotop())
ProcRegua(LastRec())
                    
// Salva todos os campos do SA1 mais o campo de status
aCposTmp := TMPA1->(dbStruct())
Aadd(aCposTmp, {"STATUS"    , "C", 15, 0})
Aadd(aCposTmp, {"A1_OK"     , "C", 02, 0})

cArqTmp 	:= CriaTrab(aCposTmp,.T.)
dbUseArea( .T.,, cArqTmp,"TRBSA1", .T. , .F. )

nCont	:= 0
lContinua := .T.
While !TMPA1->(Eof())
	IncProc("Processados "+cFile+" ("+Str(nCont)+")")
	// avalia se importa somente os bloqueados
	if !(TMPA1->A1_MSBLQL == "1" .And. lSohAtivos)			
		if (Empty(TMPA1->A1_CGC) .And. TMPA1->A1_EST != "EX") 
			TMPA1->(dbSkip())
			nCont++
			Loop
		EndIf
		
		DbSelectArea("SA1")
		DbSetOrder(3)
		DbGoTop()
		If !DbSeek(xFilial("SA1")+TMPA1->A1_CGC)
	  			                               
	 		numPos := iIf(TMPA1->A1_PESSOA = 'J', 8, 9)
	    _cCOD  := SUBSTR(TMPA1->A1_CGC, 1, numPos)
	    // se for pj, formata com 4 casas decimais e o codigo é o final do cnpj, caso negativo é sequencial (produtor rural)
	    _nLoja := iIf(TMPA1->A1_PESSOA = 'J', Val(SUBSTR(TMPA1->A1_CGC, 9, 4)),1)
	    lContinua := .T.
		  
		  if (lContinua)
			  SA1->(RecLock("SA1",.T.))
				_cCampo := ""
		    For nR := 1 To SA1->(fCount())
					_cCampo := SA1->(FieldName(nR))
					If _cCampo	$ "A1_COD/A1_LOJA"
		    		SA1->A1_COD 	:= _cCOD
		    		SA1->A1_LOJA	:= StrZero(_nLoja,4) // seta com 4 digitos
		    	Else
						nPosicao  := TMPA1->(FieldPos(_cCampo))
						// verifica se ambos os alias possuem 
						If nPosicao > 0 .And. SA1->(FieldPos(_cCampo)) > 0
							SA1->(FieldPut(nR, TMPA1->&_cCampo)) // := Iif(aEstrA1[nPosicao,2]== "D",StoD(TMPA1->&_cCampo),TMPA1->&_cCampo)
						Endif
					Endif
				Next nR
			  SA1->(MsUnLock())
		    cLin := "CLIENTE: "+TMPA1->A1_NOME+" COM O CNPJ: "+TMPA1->A1_CGC+" IMPORTADO COM SUCESSO."+;
		    			" NOVO CODIGO E LOJA SÃO: "+_cCOD+"/"+StrZero(_nLoja,4)
				cLin += cEOL 
				fWrite(nSA1,cLin,Len(cLin))
			endif
		elseif TMPA1->A1_EST = "EX" // se for do exterior, valida se já existe com os mesmos campos, se nao existir faz a importação diretamente
			lIgual := .T.            // sem a intervenção do usuário
			For i:= 3 to len(aFields) -1
				cCpoTmp := aFields[i]
				lIgual := .T.
				if !(SA1->&cCpoTmp == TMPA1->&cCpoTmp)
					lIgual := .F.
				EndIf
			Next	
			
			if !(lIgual)
			  SA1->(RecLock("SA1",.T.))
				_cCampo := ""
				_nLoja := 1
				_cCOD := "EX" + GetNextEX()
		    For nR := 1 To SA1->(fCount())
					_cCampo := SA1->(FieldName(nR))
					If _cCampo	$ "A1_COD/A1_LOJA"
		    		SA1->A1_COD 	:= _cCOD
		    		SA1->A1_LOJA	:= StrZero(_nLoja,4) // seta com 4 digitos
		    	Else
						nPosicao  := TMPA1->(FieldPos(_cCampo))
						// verifica se ambos os alias possuem 
						If nPosicao > 0 .And. SA1->(FieldPos(_cCampo)) > 0
							SA1->(FieldPut(nR, TMPA1->&_cCampo)) // := Iif(aEstrA1[nPosicao,2]== "D",StoD(TMPA1->&_cCampo),TMPA1->&_cCampo)
						Endif
					Endif
				Next nR
			  SA1->(MsUnLock())
		    cLin := "CLIENTE: "+TMPA1->A1_NOME+" COM O UF EX IMPORTADO COM SUCESSO."+;
		    			" NOVO CODIGO E LOJA SÃO: "+_cCOD+"/"+StrZero(_nLoja,4)
				cLin += cEOL 
				fWrite(nSA1,cLin,Len(cLin))
			endif
			
			
		// CNPJ ou CPF já existe, entao compara os campos chaves. se forem iguais ignora o registro automaticamente
		else			
			lIgual := .T.
			For i:= 3 to len(aFields) -1
				cCpoTmp := aFields[i]
				lIgual := .T.
				if !(SA1->&cCpoTmp == TMPA1->&cCpoTmp)
					lIgual := .F.
				EndIf
			Next
			
			// copia o registro para o arquivo temporário
			if (!lIgual)
				                    
				While !SA1->(EOF()) .and. SA1->A1_CGC == TMPA1->A1_CGC
					// se for cliente do exterior ignora
					if (SA1->A1_EST == "EX") .OR. Empty(SA1->A1_CGC)
						SA1->(DbSkip())
						Loop
					EndIf
					// copia o registro existente					
					TRBSA1->(RecLock("TRBSA1", .T.))
					// trabalha com base no alias TMPSA1, devido a manter compatibilidade na gravacao do registro
					For nR := 1 To TMPA1->(fCount())
						// obtém o nome do campo
						_cCampo := TMPA1->(FieldName(nR))
						// obtém a posicao no arquivo
						nPosicao  := TRBSA1->(FieldPos(_cCampo))
						If nPosicao > 0 .And. SA1->(FieldPos(_cCampo)) > 0
							TRBSA1->(FieldPut(nPosicao, SA1->&_cCampo))
						Endif
					Next nR
					TRBSA1->STATUS := "Existente"
					TRBSA1->(MsUnlock())
			  	SA1->(DbSkip())
		    End
				
				// copia o registro a ser importado
				TRBSA1->(RecLock("TRBSA1", .T.))
				// trabalha com base no alias TMPSA1, devido a manter compatibilidade na gravacao do registro
				For nR := 1 To TMPA1->(fCount())
					// obtém o nome do campo
					_cCampo := TMPA1->(FieldName(nR))
					// obtém a posicao no arquivo
					nPosicao  := TRBSA1->(FieldPos(_cCampo))
					If nPosicao > 0 .And. TMPA1->(FieldPos(_cCampo)) > 0
						TRBSA1->(FieldPut(nPosicao, TMPA1->&_cCampo))
					Endif
				Next nR
				TRBSA1->STATUS := "Novo"
				TRBSA1->(MsUnlock())
				
				cLin := "CLIENTE: "+TMPA1->A1_NOME+" COM O CPF: "+TMPA1->A1_CGC+" EXISTENTE E SERÁ AVALIADO PARA IMPORTAÇÃO."		    			
				cLin += cEOL
				fWrite(nSA1,cLin,Len(cLin))
				
			Else			
				cLin := "CLIENTE: "+TMPA1->A1_NOME+" COM O CPF: "+TMPA1->A1_CGC+" EXISTENTE E NÃO SERÁ IMPORTADO."		    			
				cLin += cEOL
				fWrite(nSA1,cLin,Len(cLin))						
			EndIf
		EndIf
	  /*Else
	   	cLin := "CLIENTE: "+TMPA1->A1_NOME+" COM O CNPJ: "+TMPA1->A1_CGC+;
		    	" JÁ EXISTE NO CADASTRO DE CLIENTES E NÃO FOI IMPORTADO."
			cLin += cEOL 
			fWrite(nSA1,cLin,Len(cLin))	    	
	  Endif    */
  EndIf
	nCont += 1
	TMPA1->(DbSelectArea("TMPA1"))
  
	TMPA1->(DbSkip())
End

TMPA1->(DbSelectArea("TMPA1"))
TMPA1->(DbCloseArea())

dbSelectArea("TRBSA1")
cDestino := "\impcli\"

If !File(cDestino)
	MAKEDIR(cDestino)
EndIf

_cArq := cDestino + "cli_" + RetFileName(cFile)
           
If File(_cArq)
	FErase(_cArq+GetDBExtension())
EndIf

COPY TO &(_cArq)

VerCliDup()

TRBSA1->(dbCloseArea())
fErase(cArqTmp + GetDBExtension())

FT_FUSE() 
fClose(nSA1) 
Return(.T.)
   
// Caso cancelamento.
Static Function Finaliza()
   Close(oDlg1)
Return

// Função que resolve o conflito de alterações de processos concorrentes
Static Function ResolveConf()
Local lContinua := .T. // por padrao adiciona
Local aArea := GetArea()
Local oDlg
Local aColLoc := {}
Local oButton1
Local oButton2
Local aHeaderEx := {}
Local nX
Local aFieldFill := {}
Local aFields := {"A1_COD", "A1_LOJA", "A1_NOME", "A1_END", "A1_MUN", "A1_COD_MUN", "A1_BAIRRO", "A1_CEP", "A1_CODPAIS","A1_EST", "A1_INSCR"}
Local aAlterFields := {}
Local cAliasOper := "TMPA1"
Static oMSNewGe1
Static oDlg                      


// monta o aHeader
SX3->(dbsetorder(02))
for i:= 1 to len(aFields)
	SX3->(dbseek(aFields[i]))
	aAdd(aHeaderEx, {SX3->X3_TITULO, SX3->X3_CAMPO, SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL, .T., , SX3->X3_TIPO, "R"})
Next
// Adiciona o campo de Status
aAdd(aHeaderEx, {"Status", "STATUS", "@!", 40, 0, .T., , "C", "V"})

// obtém os dados do registro atual
For i:= 1 to len(aCol)
	aAdd(aColLoc,aCol[i])
	aAdd(aColLoc[len(aColLoc)], "Existente")
	aAdd(aColLoc[len(aColLoc)], .F.)
Next

// adiciona o registro novo
aAdd(aColLoc, {})
For i:= 1 to len(aHeader) -1
	aAdd(aColLoc[len(aColLoc)], (cAliasOper)->(FieldGet(FieldPos(aHeader[i, 2]))))
Next

// Adiciona o registro alterado
aAdd(aColLoc[len(aColLoc)], "Novo")
aAdd(aColLoc[len(aColLoc)], .F.)
                               
// aAdd(aHeaderEx, {"Status", "STATUS", '@!', 20, 0, , .T., 'C'})

DEFINE MSDIALOG oDlg TITLE "Cliente pessoa física já existe com mesmo CPF" FROM 000, 000  TO 400, 500 COLORS 0, 16777215 PIXEL

  oMSNewGe1 := MsNewGetDados():New( 017, 027, 160, 187, , "AllwaysTrue", "AllwaysTrue", "", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aHeaderEx, aColLoc)
  @ 174, 062 BUTTON oButton1 PROMPT "Incluir" SIZE 037, 012 ACTION (lContinua:= .T., Close(oDlg)) OF oDlg  PIXEL
  @ 174, 117 BUTTON oButton2 PROMPT "Descartar" SIZE 056, 012 ACTION (lContinua:= .F., Close(oDlg)) OF oDlg PIXEL

  // Don't change the Align Order
  oMSNewGe1:oBrowse:Align := CONTROL_ALIGN_TOP

ACTIVATE MSDIALOG oDlg CENTERED
Return lContinua


// Faz a visualização dos clientes duplicados
Static Function VerCliDup()
Local aArea
Local cArqInd := ""
Local i, cArq
Local cAlias := "TRBSA1"
Local cEOL    	:= "CHR(13)+CHR(10)"
Local aFields := {"A1_COD", "A1_LOJA", "A1_NOME", "A1_END", "A1_MUN", "A1_COD_MUN", "A1_BAIRRO", "A1_CEP", "A1_CODPAIS","A1_EST", "A1_INSCR"}
/*Private cCadastro := "Clientes com duplicação"
Private aRotina := {}
Private nOpc := 4
Private aHeader := {}
Private aCOLS := {}
Private aREG := {}
Private aFixe := {}
Private aCampos := {}*/
Private aCpos := {}

cEOL    	:= &cEOL

// monta o aHeader
/*SX3->(dbsetorder(02))
for i:= 1 to len(aFields)
	SX3->(dbseek(aFields[i]))
	aAdd(aHeader, {SX3->X3_TITULO, SX3->X3_CAMPO, SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL, .T., , SX3->X3_TIPO, "R"})
Next
// Adiciona o campo de Status
aAdd(aHeader, {"Status", "STATUS", "@!", 40, 0, .T., , "C", "V"})

dbSelectArea(cAlias)
// tem que ter a variavel pq é usada no GetDados
aAdd(aRotina, {"Pesquisar", "AxPesqui", 0, 1})
aAdd(aRotina, {"Alterar"    ,'AxVisual',0,2})

dbSelectArea(cAlias)

// cria um índice a ser usado
cArqInd := CriaTrab(NIL,.f.)

IndRegua(cAlias,cArqInd,"A1_CGC+A1_LOJA",,,"Selecionando Registros...")

dbSetOrder(01)

MBrowse(6, 1, 22, 75, cAlias, aFixe)

fErase(cArqInd+OrdBagExt())*/

cMarca := GetMark(,"TRBSA1", "A1_OK")

AAdd(aCpos, {"A1_OK", " "," ", ""})
aAdd(aCpos, {"STATUS", "", "Status", ""})
aAdd(aCpos, {"A1_CGC", "", "CNPJ/CPF", ""})
                       
SX3->(dbsetorder(02))
for i:= 1 to len(aFields)
	SX3->(dbseek(aFields[i]))
	aAdd(aCpos, {AllTrim(SX3->X3_CAMPO), "", AllTrim(SX3->X3_TITULO), ""})
Next

dbSelectArea("TRBSA1")

linverte := .F.

TRBSA1->(dbGoTop())  

@ 001,001 TO 400,700 DIALOG oDlg TITLE "Selecione os clientes a importar"
//@ 001,001 TO 170,350 BROWSE oBrw Alias "TMPSQL" MARK "F2_OK" 
oMark := MsSelect():New("TRBSA1",aCpos[1,1],,aCpos,@lInverte,@cMarca,{1,1,170,350})
oMark:oBrowse:lhasMark = .t.
oMark:oBrowse:lCanAllmark := .t.
@ 180,310 BMPBUTTON TYPE 01 ACTION (Close(oDlg))
ACTIVATE DIALOG oDlg CENTERED
      
TRBSA1->(dbGoTop())
// Faz a inclusao dos registros marcados para importar em que o status é novo
While TRBSA1->(!Eof())
	if (IsMark("A1_OK", ThisMark(), ThisInv()) .And. AllTrim(TRBSA1->STATUS) == "Novo")
	  // se for pessoa jurídica e tiver cnpj, exclui o que está cadastrado
	  if (TRBSA1->A1_PESSOA == "J") .And. !Empty(TRBSA1->A1_CGC)
	  	SA1->(dbSetOrder(03))
	  	if (SA1->(dbSeek(xFilial("SA1") + TRBSA1->A1_CGC)))	  	     
	      RecLock("SA1",.F.)
	  		SA1->(dbDelete())
	  		SA1->(MsUnLock())
	  	EndIf
	  EndIf
		SA1->(RecLock("SA1",.T.))
		_cCampo := ""
		For nR := 1 To SA1->(fCount())
			_cCampo := SA1->(FieldName(nR))
			If _cCampo	$ "A1_COD/A1_LOJA"
				if (TRBSA1->A1_PESSOA == "J")
					if (TRBSA1->A1_EST == "EX")
						SA1->A1_COD 	:= "EX" + GetNextEX()
		    		SA1->A1_LOJA	:= SubStr(TRBSA1->A1_CGC, 9, 4) // seta com 4 digitos
					Else					
						SA1->A1_COD 	:= SubStr(TRBSA1->A1_CGC, 1, 8)
		    		SA1->A1_LOJA	:= SubStr(TRBSA1->A1_CGC, 9, 4) // seta com 4 digitos
		    	EndIf
				else					
					SA1->A1_COD 	:= SubStr(TRBSA1->A1_CGC, 1, 9)
		    	SA1->A1_LOJA	:= GetNextLoja(SA1->A1_COD) // seta com 4 digitos
				EndIf
				
		  Else
				nPosicao  := TRBSA1->(FieldPos(_cCampo))
				If nPosicao > 0
					SA1->(FieldPut(nR, TRBSA1->&_cCampo)) // := Iif(aEstrA1[nPosicao,2]== "D",StoD(TMPA1->&_cCampo),TMPA1->&_cCampo)
				Endif
			Endif
		Next nR
	  SA1->(MsUnLock())
	  
	  cLin := "CLIENTE: "+TRBSA1->A1_NOME+" COM O CNPJ: "+TRBSA1->A1_CGC+" IMPORTADO COM SUCESSO POR OPÇÃO DO USUÁRIO."
		cLin += cEOL 
		fWrite(nSA1,cLin,Len(cLin))
	EndIf
	TRBSA1->(dbSkip())	
Enddo

Return

Static Function GetNextLoja(cCodCli)
Local cLoja
Local cSql
Local cAlias := "SA1LOJ"
cSql := "SELECT MAX(A1_LOJA) as A1_LOJA FROM " + RetSqlName("SA1") + " WHERE A1_COD = '" + cCodCli + "' and d_e_l_e_t_ <> '*'"
TCQUERY cSql NEW ALIAS "SA1LOJ"
if SA1LOJ->(!Eof())
	cLoja := SA1LOJ->A1_LOJA
else
	cLoja := "0000"
EndIf

SA1LOJ->(dbCloseArea())

cLoja := Soma1(PadL(cLoja, 4, "0"))

SA1LOJ->(dbCloseArea())
Return cLoja


// busca proximo codigo sequencial e uf exterior
Static Function GetNextEX()
Local cSeq := "000001"
Local cSql
Local cAlias := "SA1EXT"
cSql := "SELECT MAX(A1_COD) as A1_COD FROM " + RetSqlName("SA1") + " WHERE SubStr(A1_COD, 1, 2) = 'EX' and d_e_l_e_t_ <> '*'"
TCQUERY cSql NEW ALIAS "SA1EXT"
if SA1EXT->(!Eof())
  cSeq := PadL(SubStr(SA1EXT->A1_COD, 3), 6, "0")
EndIf 
SA1EXT->(dbCloseArea())

cSeq := Soma1(cSeq)

Return cSeq