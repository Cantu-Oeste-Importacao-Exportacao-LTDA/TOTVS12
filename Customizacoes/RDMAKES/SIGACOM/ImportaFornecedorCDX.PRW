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
±±ºDescricao ³ Importação de FORNECEDORs.                                    º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 		                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function IMPFORCDX()
Local aCli := {}
Private cFile := 	Space(100)  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

    
@ 140,100 TO 300,430 DIALOG oDlg1 TITLE "Importação de Fornecedores"
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
Local aFields := {"A2_COD", "A2_LOJA", "A2_NOME", "A2_END", "A2_MUN", "A2_COD_MUN", "A2_BAIRRO", "A2_CEP", "A2_CODPAIS","A2_EST", "A2_INSCR"}
Local lSohAtivos := .F.

Private nSA2 	:= fCreate("c:\logImpFor_" + RetFileName(cFile)+ ".txt") // Local para log

If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

lSohAtivos := MsgBox("Importar somente ativos","Imp. Fornecedores","YESNO")

MsOpEndbf(.T.,"CTREECDX",cFile,"TMPA2",.F.,.F.,.F.,.F.)
       
TMPA2->(DbSelectArea("TMPA2"))
TMPA2->(DbGotop())
ProcRegua(LastRec())
                    
// Salva todos os campos do SA1 mais o campo de status
aCposTmp := TMPA2->(dbStruct())
Aadd(aCposTmp, {"STATUS"    , "C", 15, 0})
//Aadd(aCposTmp, {"A2_OK"     , "C", 02, 0})

cArqTmp 	:= CriaTrab(aCposTmp,.T.)
dbUseArea( .T.,, cArqTmp,"TRBSA2", .T. , .F. )

nCont	:= 0
lContinua := .T.
While !TMPA2->(Eof())
	IncProc("Processados "+cFile+" ("+AllTrim(Str(nCont))+")")
	// avalia se importa somente os bloqueados
	if !(TMPA2->A2_MSBLQL == "1" .And. lSohAtivos)			
		DbSelectArea("SA2")
		DbSetOrder(3)
		DbGoTop()
		If !DbSeek(xFilial("SA2")+TMPA2->A2_CGC)
	  			                               
	 		numPos := iIf(TMPA2->A2_TIPO = 'J', 8, 9)
	    _cCOD  := SUBSTR(TMPA2->A2_CGC, 1, numPos)
	    // se for pj, formata com 4 casas decimais e o codigo é o final do cnpj, caso negativo é sequencial (produtor rural)
	    _nLoja := iIf(TMPA2->A2_TIPO = 'J', Val(SUBSTR(TMPA2->A2_CGC, 9, 4)),1)
	    lContinua := .T.
		  
		  if (lContinua)
			  SA2->(RecLock("SA2",.T.))
				_cCampo := ""
		    For nR := 1 To SA2->(fCount())
					_cCampo := SA2->(FieldName(nR))
					If _cCampo	$ "A2_COD/A2_LOJA"
		    		SA2->A2_COD 	:= _cCOD
		    		SA2->A2_LOJA	:= StrZero(_nLoja,4) // seta com 4 digitos
		    	Else
						nPosicao  := TMPA2->(FieldPos(_cCampo))
						// verifica se ambos os alias possuem 
						If nPosicao > 0 .And. SA2->(FieldPos(_cCampo)) > 0
							SA2->(FieldPut(nR, TMPA2->&_cCampo)) // := Iif(aEstrA1[nPosicao,2]== "D",StoD(TMPA2->&_cCampo),TMPA2->&_cCampo)
						Endif
					Endif
				Next nR
			  SA2->(MsUnLock())
		    cLin := "FORNECEDOR: "+TMPA2->A2_NOME+" COM O CNPJ: "+TMPA2->A2_CGC+" IMPORTADO COM SUCESSO."+;
		    			" NOVO CODIGO E LOJA SÃO: "+_cCOD+"/"+StrZero(_nLoja,4)
				cLin += cEOL 
				fWrite(nSA2,cLin,Len(cLin))
			endif
		elseif TMPA2->A2_EST = "EX" // se for do exterior, valida se já existe com os mesmos campos, se nao existir faz a importação diretamente
			lIgual := .T.            // sem a intervenção do usuário
			For i:= 3 to len(aFields) -1
				cCpoTmp := aFields[i]
				lIgual := .T.
				if !(SA2->&cCpoTmp == TMPA2->&cCpoTmp)
					lIgual := .F.
				EndIf
			Next	
			
			if !(lIgual)
			  SA2->(RecLock("SA2",.T.))
				_cCampo := ""
				_nLoja := 1
				_cCOD := "EX" + GetNextEX()
		    For nR := 1 To SA2->(fCount())
					_cCampo := SA2->(FieldName(nR))
					If _cCampo	$ "A2_COD/A2_LOJA"
		    		SA2->A2_COD 	:= _cCOD
		    		SA2->A2_LOJA	:= StrZero(_nLoja,4) // seta com 4 digitos
		    	Else
						nPosicao  := TMPA2->(FieldPos(_cCampo))
						// verifica se ambos os alias possuem 
						If nPosicao > 0 .And. SA2->(FieldPos(_cCampo)) > 0
							SA2->(FieldPut(nR, TMPA2->&_cCampo)) // := Iif(aEstrA1[nPosicao,2]== "D",StoD(TMPA2->&_cCampo),TMPA2->&_cCampo)
						Endif
					Endif
				Next nR
			  SA2->(MsUnLock())
		    cLin := "FORNECEDOR: "+TMPA2->A2_NOME+" COM O UF EX IMPORTADO COM SUCESSO."+;
		    			" NOVO CODIGO E LOJA SÃO: "+_cCOD+"/"+StrZero(_nLoja,4)
				cLin += cEOL 
				fWrite(nSA2,cLin,Len(cLin))
			endif
			
			
		// CNPJ ou CPF já existe, entao compara os campos chaves. se forem iguais ignora o registro automaticamente
		elseif !Empty(TMPA2->A2_CGC)
			lIgual := .T.
			For i:= 3 to len(aFields) -1
				cCpoTmp := aFields[i]
				lIgual := .T.
				if !(SA2->&cCpoTmp == TMPA2->&cCpoTmp)
					lIgual := .F.
				EndIf
			Next
			
			// copia o registro para o arquivo temporário
			if (!lIgual)
				                    
				While !SA2->(EOF()) .and. SA2->A2_CGC == TMPA2->A2_CGC
					// se nao tiver cnpj desconsidera o registro
					if empty(TMPA2->A2_CGC)
						SA2->(DbSkip())
						Loop
					EndIf
					
					// copia o registro existente
					TRBSA2->(RecLock("TRBSA2", .T.))
					// trabalha com base no alias TMPSA1, devido a manter compatibilidade na gravacao do registro
					For nR := 1 To TMPA2->(fCount())
						// obtém o nome do campo
						_cCampo := TMPA2->(FieldName(nR))
						// obtém a posicao no arquivo
						nPosicao  := TRBSA2->(FieldPos(_cCampo))
						If nPosicao > 0 .And. SA2->(FieldPos(_cCampo)) > 0
							TRBSA2->(FieldPut(nPosicao, SA2->&_cCampo))
						Endif
					Next nR
					TRBSA2->STATUS := "Existente"
					TRBSA2->(MsUnlock())
			  	SA2->(DbSkip())
		    End
				
				// copia o registro a ser importado
				TRBSA2->(RecLock("TRBSA2", .T.))
				// trabalha com base no alias TMPSA1, devido a manter compatibilidade na gravacao do registro
				For nR := 1 To TMPA2->(fCount())
					// obtém o nome do campo
					_cCampo := TMPA2->(FieldName(nR))
					// obtém a posicao no arquivo
					nPosicao  := TRBSA2->(FieldPos(_cCampo))
					If nPosicao > 0 .And. TMPA2->(FieldPos(_cCampo)) > 0
						TRBSA2->(FieldPut(nPosicao, TMPA2->&_cCampo))
					Endif
				Next nR
				TRBSA2->STATUS := "Novo"
				TRBSA2->(MsUnlock())
				
				cLin := "FORNECEDOR: "+TMPA2->A2_NOME+" COM O CPF: "+TMPA2->A2_CGC+" EXISTENTE E SERÁ AVALIADO PARA IMPORTAÇÃO."		    			
				cLin += cEOL
				fWrite(nSA2,cLin,Len(cLin))
				
			Else			
				cLin := "FORNECEDOR: "+TMPA2->A2_NOME+" COM O CPF: "+TMPA2->A2_CGC+" EXISTENTE E NÃO SERÁ IMPORTADO."		    			
				cLin += cEOL
				fWrite(nSA2,cLin,Len(cLin))						
			EndIf
		EndIf	  
  EndIf
	nCont += 1
	TMPA2->(DbSelectArea("TMPA2"))
  
	TMPA2->(DbSkip())
End

TMPA2->(DbSelectArea("TMPA2"))
TMPA2->(DbCloseArea())

dbSelectArea("TRBSA2")
cDestino := "\impfor\"

If !File(cDestino)
	MAKEDIR(cDestino)
EndIf

_cArq := cDestino + "for_" + RetFileName(cFile)
           
If File(_cArq)
	FErase(_cArq+GetDBExtension())
EndIf

COPY TO &(_cArq)

VerCliDup()

TRBSA2->(dbCloseArea())
fErase(cArqTmp + GetDBExtension())

FT_FUSE() 
fClose(nSA2) 
Return(.T.)
   
// Caso cancelamento.
Static Function Finaliza()
   Close(oDlg1)
Return


// Faz a visualização dos FORNECEDORs duplicados
Static Function VerCliDup()
Local aArea
Local cArqInd := ""
Local i, cArq
Local cAlias := "TRBSA2"
Local cEOL    	:= "CHR(13)+CHR(10)"
Local aFields := {"A2_COD", "A2_LOJA", "A2_NOME", "A2_END", "A2_MUN", "A2_COD_MUN", "A2_BAIRRO", "A2_CEP", "A2_CODPAIS","A2_EST", "A2_INSCR"}
Private aCpos := {}

cEOL    	:= &cEOL

cMarca := GetMark(,"TRBSA2", "A2_OK")

AAdd(aCpos, {"A2_OK", " "," ", ""})
aAdd(aCpos, {"STATUS", "", "Status", ""})
aAdd(aCpos, {"A2_CGC", "", "CNPJ/CPF", ""})
                       
SX3->(dbsetorder(02))
for i:= 1 to len(aFields)
	SX3->(dbseek(aFields[i]))
	aAdd(aCpos, {AllTrim(SX3->X3_CAMPO), "", AllTrim(SX3->X3_TITULO), ""})
Next

dbSelectArea("TRBSA2")

linverte := .F.

TRBSA2->(dbGoTop())  

@ 001,001 TO 400,700 DIALOG oDlg TITLE "Selecione os FORNECEDORs a importar"
//@ 001,001 TO 170,350 BROWSE oBrw Alias "TMPSQL" MARK "F2_OK" 
oMark := MsSelect():New("TRBSA2",aCpos[1,1],,aCpos,@lInverte,@cMarca,{1,1,170,350})
oMark:oBrowse:lhasMark = .t.
oMark:oBrowse:lCanAllmark := .t.
@ 180,310 BMPBUTTON TYPE 01 ACTION (Close(oDlg))
ACTIVATE DIALOG oDlg CENTERED
      
TRBSA2->(dbGoTop())
// Faz a inclusao dos registros marcados para importar em que o status é novo
While TRBSA2->(!Eof())
	if (IsMark("A2_OK", ThisMark(), ThisInv()) .And. AllTrim(TRBSA2->STATUS) == "Novo")
	  // se for pessoa jurídica e tiver cnpj, exclui o que está cadastrado
	  if (TRBSA2->A2_TIPO == "J") .And. !Empty(TRBSA2->A2_CGC)
	  	SA2->(dbSetOrder(03))
	  	if (SA2->(dbSeek(xFilial("SA2") + TRBSA2->A2_CGC)))	  	     
	      RecLock("SA2",.F.)
	  		SA2->(dbDelete())
	  		SA2->(MsUnLock())
	  	EndIf
	  EndIf
		SA2->(RecLock("SA2",.T.))
		_cCampo := ""
		For nR := 1 To SA2->(fCount())
			_cCampo := SA2->(FieldName(nR))
			If _cCampo	$ "A2_COD/A2_LOJA"
				if (TRBSA2->A2_TIPO == "J")
					if (TRBSA2->A2_EST <> "EX")
						SA2->A2_COD 	:= "EX" + GetNextEX()
		    		SA2->A2_LOJA	:= SubStr(TRBSA2->A2_CGC, 9, 4) // seta com 4 digitos
					Else					
						SA2->A2_COD 	:= SubStr(TRBSA2->A2_CGC, 1, 8)
		    		SA2->A2_LOJA	:= SubStr(TRBSA2->A2_CGC, 9, 4) // seta com 4 digitos
		    	EndIf
				else					
					SA2->A2_COD 	:= SubStr(TRBSA2->A2_CGC, 1, 9)
		    	SA2->A2_LOJA	:= GetNextLoja(SA2->A2_COD) // seta com 4 digitos
				EndIf
				
		  Else
				nPosicao  := TRBSA2->(FieldPos(_cCampo))
				If nPosicao > 0
					SA2->(FieldPut(nR, TRBSA2->&_cCampo)) // := Iif(aEstrA1[nPosicao,2]== "D",StoD(TMPA2->&_cCampo),TMPA2->&_cCampo)
				Endif
			Endif
		Next nR
	  SA2->(MsUnLock())
	  
	  cLin := "FORNECEDOR: "+TRBSA2->A2_NOME+" COM O CNPJ: "+TRBSA2->A2_CGC+" IMPORTADO COM SUCESSO POR OPÇÃO DO USUÁRIO."
		cLin += cEOL 
		fWrite(nSA2,cLin,Len(cLin))
	EndIf
	TRBSA2->(dbSkip())	
Enddo

Return

Static Function GetNextLoja(cCodCli)
Local cLoja
Local cSql
Local cAlias := "SA2LOJ"
cSql := "SELECT MAX(A2_LOJA) as A2_LOJA FROM " + RetSqlName("SA2") + " WHERE A2_COD = '" + cCodCli + "' and d_e_l_e_t_ <> '*'"
TCQUERY cSql NEW ALIAS "SA2LOJ"
if SA2LOJ->(!Eof())
	cLoja := SA2LOJ->A2_LOJA
else
	cLoja := "0000"
EndIf

SA2LOJ->(dbCloseArea())

cLoja := Soma1(PadL(cLoja, 4, "0"))

SA2LOJ->(dbCloseArea())
Return cLoja


// busca proximo codigo sequencial e uf exterior
Static Function GetNextEX()
Local cSeq := "000001"
Local cSql
Local cAlias := "SA2EXT"
cSql := "SELECT MAX(A2_COD) as A2_COD FROM " + RetSqlName("SA2") + " WHERE SubStr(A2_COD, 1, 2) = 'EX' and d_e_l_e_t_ <> '*'"
TCQUERY cSql NEW ALIAS "SA2EXT"
if SA2EXT->(!Eof())
  cSeq := PadL(SubStr(SA2EXT->A2_COD, 3), 6, "0")
EndIf 
SA2EXT->(dbCloseArea())

cSeq := Soma1(cSeq)

Return cSeq