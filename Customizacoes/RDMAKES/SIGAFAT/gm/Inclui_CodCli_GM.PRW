#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

User Function ImpCliGM()
Local cFile
Local cStr
Local aCpos := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

cFile := cGetFile( "Arquivos de pedido GM | *.dat" , "Selecione o arquivo enviado pela GM", 0,"",.T.)

if !File(cFile)
	Alert("Caminho espeficicado não é válido.")
	Return nil
EndIf

if !Empty(cFile)
	nHdl := FT_FUSE(cFile)           		
	nCount := 0
	nImp := 0
	While !FT_FEOF()
		nCount ++
  	cStr := Ft_Freadln()
  	aCpos := SeparaCpos(cStr, ";")
  	if Len(aCpos) >= 13
  		dbSelectArea("N12")
  		dbSetOrder(1)
  		cCnpj := Trim(aCpos[2])
  		cDigCnpj := SubStr(cCnpj, 1,1)
  		cCnpj := StrTran(cCnpj, ".", "")
  		cCnpj := StrTran(cCnpj, "-", "")
  		cCnpj := StrTran(cCnpj, "/", "")
  		cCnpj := PadL(cCnpj, 14, "0")
  		
  		if N12->(!dbSeek(xFilial("N12") + cCnpj)) .And. cDigCnpj $ "0123456789"
  		
	  		RecLock("N12", .T.)
	  		N12_FILIAL := xFilial("N12")
	  		
	  	 	N12_CGC := cCnpj
	  	 	N12_NOME := NoAcento(aCpos[4])
	  	 	N12_NREDUZ := left(NoAcento(aCpos[5]), 15) + " (GM)"
	  	 	N12_END := NoAcento(aCpos[7])
	  	 	N12_BAIRRO := NoAcento(aCpos[8])
	  	 	
	  	 	cCep := StrTran(Trim(aCpos[11]), "-", "")
	  	 	N12_CEP := cCep
	  	 	
	  	 	N12_MUN := aCpos[9]
	  	 	N12_EST := aCpos[10]
	  	 	
	  	 	cTel := StrTran(aCpos[12], " ", "")
	  	 	cTel := Strtran(cTel, "(", "")
	  	 	cTel := StrTran(cTel, ")", "")
	  	 	cTel := StrTran(cTel, "-", "")
	  	 	N12_TEL := cTel
	  	 	
	  	 	cTel := StrTran(aCpos[13], " ", "")
	  	 	cTel := Strtran(cTel, "(", "")
	  	 	cTel := StrTran(cTel, ")", "")
	  	 	cTel := StrTran(cTel, "-", "")
	  	 	N12_FAX := cTel
	  	 	
	  	 	cIE := StrTran(aCpos[3], ".", "")
	  	 	cIE := StrTRan(cIE, "-", "")
	  	 	N12_RG := cIE
	  	 	
	  	 	N12->(MsUnlock())
	  	 	nImp++
  		EndIf 
	  		dbSelectArea("SA1")
	  		dbSetOrder(3)
	  	    IF SA1->(dbSeek(xFilial("SA1") + cCnpj)) .And. cDigCnpj $ "0123456789"   //VERIFICA CNPJ SA1 
	  	      RecLock("SA1", .F.)     	  	    
	  	      A1_X_CLIGM:= substr(cstr,1,6) //CODIGO GM  	  	       
	  	      SA1->(MsUnlock())
	  	    ENDIF
  	EndIf
  	FT_FSKIP()
	EndDo
	
	FT_FUSE()
	fClose(nHdl)
EndIf
MsgInfo("Importados " + Str(nImp) + " de " + Str(nCount))
Return


static FUNCTION NoAcento(cString)
Local cChar  := ""
Local nX     := 0 
Local nY     := 0
Local cVogal := "aeiouAEIOU"
Local cAgudo := "áéíóú"+"ÁÉÍÓÚ"
Local cCircu := "âêîôû"+"ÂÊÎÔÛ"
Local cTrema := "äëïöü"+"ÄËÏÖÜ"
Local cCrase := "àèìòù"+"ÀÈÌÒÙ" 
Local cTio   := "ãõ"
Local cCecid := "çÇ"

if Empty(cString)
	Return cString
EndIf

For nX:= 1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase
		nY:= At(cChar,cAgudo)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCircu)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cTrema)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCrase)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf		
		nY:= At(cChar,cTio)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("ao",nY,1))
		EndIf		
		nY:= At(cChar,cCecid)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("cC",nY,1))
		EndIf
	Endif
Next
For nX:=1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	If Asc(cChar) < 32 .Or. Asc(cChar) > 123
		cString:=StrTran(cString,cChar,".")
	Endif
	If cChar $ '&'
		cString:=StrTran(cString,cChar,"E")
	Endif
Next nX
cString := Upper(cString)
Return cString

Static Function SeparaCpos(cStr, cSep)
Local nPos
Local cParte := ""
Local cCarac := ""
Local cCaracOld := ""
Local aCpos := {}
For nPos := 1 to Len(cStr)
	cCarac := substr(cStr, nPos, 1)
	if cCarac == cSep 
		aAdd(aCpos, cParte)
		cParte := ""
	elseif nPos == Len(cStr)
		cParte := cParte + cCarac
		aAdd(aCpos, cParte)
	elseif cCarac == cCaracOld .and. cCarac == cSep
		aAdd(aCpos, "")
	else	
		cParte := cParte + cCarac
	End
	cCaracOld := cCarac
Next nPos
Return aCpos