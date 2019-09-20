#Include "PROTHEUS.CH"
#Include "rwmake.CH"
#INCLUDE "COLORS.CH"   
#include "TopConn.ch"


// Funcao que faz a chamada do webservice, a
User Function GetOnixSat(cDados)
Local cRet := "" 

Local oWS    := WSwsonixsat():New()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If oWS:ComunicaSrv(AllTrim(cDados))
   cRet := oWS:cComunicaSrvResult
Else
   cRet := ""
EndIf  

/*FT_FUSE('c:\arq.xml')
FT_FGOTOP()
cRet := ""
While !FT_FEOF()
	cRet += ALLtRIM(Ft_Freadln())
	FT_FSKIP()
End
*/

cRet	:= NoAcento(cRet)

oWS := Nil
Return cRet

User Function GetOnix()
Local oDlg1
Local cAviso	:= ""
Local cErro	:= ""     
Local oRet
Local _cViag := "" 
Local _cVeic	:= ""
Private cXmlEnv := ""
Private cXmlRet := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())


cXmlEnv	:= "<RequestMensagemCB>"
cXmlEnv	+= "<login>78575149000196</login>"
cXmlEnv += "<senha>154912</senha>"
cXmlEnv += "<mId>10000</mId>"
cXmlEnv += "</RequestMensagemCB>"

/*
@ 140,100 TO 420,450 DIALOG oDlg1 TITLE "Testar Onix Sat"
@ 002,010 Say "Xml a enviar:"
@ 012,010 Get cXmlEnv MEMO Size 160, 40
@ 052,010 Say "Xml retorno:"
@ 062,010 Get cXmlRet MEMO Size 160, 40
@ 105,100 BMPBUTTON TYPE 1 ACTION (cXmlRet := U_ConsOnixSat(cXmlEnv), oDlg1:Refresh())
ACTIVATE DIALOG oDlg1 CENTER
*/

cXmlRet := U_GetOnixSat(cXmlEnv)
oRet := XmlParser(cXmlRet,"_",@cAviso,@cErro)

For nR := 1 To Len(oRet:_Responsemensagemcb:_mensagemcb)
	If oRet:_Responsemensagemcb:_mensagemcb[nR]:_TPMSG:text == '3'
		// Busca dados no cadastro do veiculo atraves do ID Onixsat
		cSql := "SELECT DA3_COD, DA3_PLACA, DA3_CODRAS "
		cSql += "FROM "+RetSqlName("DA3")+"  " 
		cSql += "WHERE DA3_FILIAL = '"+xFilial("DA3")+"' "
		cSql += "AND D_E_L_E_T_ <> '*' "
		cSql += "AND DA3_CODRAS = '"+oRet:_Responsemensagemcb:_mensagemcb[nR]:_VEIID:text+"' "
		TCQUERY AllTrim(cSql) NEW ALIAS "DA3TMP"
		DA3TMP->(DbSelectArea("DA3TMP"))
		DA3TMP->(DbGotop())
		If !DA3TMP->(Eof())			
			_cVeic :=  DA3TMP->DA3_COD
		Endif
		DA3TMP->(DbCloseArea("DA3TMP"))
		// Busca veiculo vinculado a viagem 
		cSql := "SELECT MAX(DTR_VIAGEM) DTR_VIAGEM "
		cSql += "FROM "+RetSqlName("DTR")+"  " 
		cSql += "WHERE DTR_FILIAL = '"+xFilial("DTR")+"' "
		cSql += "AND D_E_L_E_T_ <> '*' "
		cSql += "AND DTR_CODVEI = '"+_cVeic+"' "
		TCQUERY AllTrim(cSql) NEW ALIAS "DTRTMP"
		DTRTMP->(DbSelectArea("DTRTMP"))
		DTRTMP->(DbGotop())
		If !DTRTMP->(Eof())			
			_cViag :=  DTRTMP->DTR_VIAGEM
		Endif		
		DTRTMP->(DbCloseArea("DTRTMP"))
		// Dados da Viagem
	    If !Empty(AllTrim(_cViag))
	    	cSql := "SELECT * " 
	    	cSql += "FROM "+RetSqlName("DTQ")+"  "
	    	cSql += "WHERE DTQ_FILIAL = '"+xFilial("DTQ")+"' "
	    	cSql += "AND D_E_L_E_T_ <> '*' "
	    	cSql += "AND DTQ_STATUS IN ('2','4','5') " // Busco somente viagens com status ativo
	    	cSql += "AND DTQ_VIAGEM = '"+_cViag+"' "
			TCQUERY AllTrim(cSql) NEW ALIAS "DTQTMP"
			DTQTMP->(DbSelectArea("DTQTMP"))
			DTQTMP->(DbGotop())
			If !DTQTMP->(Eof())
				// Verifica se existe amarração entre a mensagem da ONIXSAT x MICROSIGA
				cSql := "SELECT * "
				cSql += "FROM "+RetSqlName("ZZK")+" "
				cSql += "WHERE ZZK_FILIAL = '"+xFilial("ZZK")+"' "
				cSql += "AND D_E_L_E_T_ <> '*' "
				cSql += "AND ZZK_CODONI = '"+oRet:_Responsemensagemcb:_mensagemcb[nR]:_TfrID:text+"' "
				TCQUERY AllTrim(cSql) NEW ALIAS "ZZKTMP"
				ZZKTMP->(DbSelectArea("ZZKTMP"))
				ZZKTMP->(DbGotop())
				If !ZZKTMP->(Eof())
					cSql := "SELECT * "
					cSql += "FROM "+RetSqlName("DTW")+ " 
					cSql += "WHERE DTW_FILORI = '"+cFilAnt+"' "
					cSql += "AND D_E_L_E_T_ <> '*' "
					cSql += "AND DTW_VIAGEM = '"+_cViag+"' "
					cSql += "AND Trim(DTW_ATIVID) = '"+AllTrim(ZZKTMP->ZZK_CODSIG)+"' "
					TCQUERY AllTrim(cSql) NEW ALIAS "DTWTMP"
					DTWTMP->(DbSelectArea("DTWTMP"))
					DTWTMP->(DbGotop())
					If !DTWTMP->(Eof())
						DTW->(DbSelectArea("DTW"))
						DTW->(DbSetOrder(1))
						DTW->(DbGotop())
						If DTW->(DbSeek(DTWTMP->DTW_FILIAL+DTWTMP->DTW_FILORI+DTWTMP->DTW_VIAGEM+DTWTMP->DTW_SEQUEN))
							DTWTMP->(DbSelectArea("DTWTMP"))	    	
							DTWTMP->(DbCloseArea("DTWTMP"))						
							// Data envio mensagem.
							_dDtRea	:= StoD(SubStr(oRet:_Responsemensagemcb:_mensagemcb[nR]:_Dt:text,1,4)+;
								SubStr(oRet:_Responsemensagemcb:_mensagemcb[nR]:_Dt:text,6,2)+;
								SubStr(oRet:_Responsemensagemcb:_mensagemcb[nR]:_Dt:text,9,2))
							// hora envio mensagem
							_DHoRea	:= SubStr(oRet:_Responsemensagemcb:_mensagemcb[nR]:_Dt:text,12,2)+;
								SubStr(oRet:_Responsemensagemcb:_mensagemcb[nR]:_Dt:text,15,2)
							If DTW->DTW_STATUS <> '2'
								DTW->(Reclock("DTW",.F.))
									DTW->DTW_DATINI := _dDtRea
									DTW->DTW_DATREA := _dDtRea								
									DTW->DTW_HORINI := _DHoRea
									DTW->DTW_HORREA := _DHoRea
									DTW->DTW_OBSERV	:= "ONIXSAT"
									DTW->DTW_STATUS	:= "2"
								DTW->(MsUnlock("DTW"))
							Else
								// BUSCAR ULTIMA SEQUENCIA DA VIAGEM + 1
								cSql := "SELECT MAX(DTW_SEQUEN) DTW_SEQUEN "
								cSql += "FROM "+RetSqlName("DTW")+ " 
								cSql += "WHERE DTW_FILORI = '"+cFilAnt+"' "
								cSql += "AND D_E_L_E_T_ <> '*' "
								cSql += "AND DTW_VIAGEM = '"+_cViag+"' "
								TCQUERY AllTrim(cSql) NEW ALIAS "DTWTMP"
								DTWTMP->(DbSelectArea("DTWTMP"))
								DTWTMP->(DbGotop())	
								_nSeq := StrZero(Val(DTWTMP->DTW_SEQUEN)+1,6)							
								DTW->(DbSelectArea("DTW"))
								DTW->(Reclock("DTW",.T.))
									DTW->DTW_FILORI	:= cFilAnt
									DTW->DTW_VIAGEM	:= _cViag
									DTW->DTW_SEQUEN	:= _nSeq
									DTW->DTW_TIPOPE	:= '2'
									DTW->DTW_DATPRE	:= _dDtRea
									DTW->DTW_HORPRE	:= _DHoRea						
									DTW->DTW_DATINI := _dDtRea
									DTW->DTW_DATREA := _dDtRea								
									DTW->DTW_HORINI := _DHoRea
									DTW->DTW_HORREA := _DHoRea
									DTW->DTW_SERVIC	:= ' ' // VERIFICAR NECESSIDADE DE GRAVAR
									DTW->DTW_TAREFA	:= ' ' // VERIFICAR NECESSIDADE DE GRAVAR
									DTW->DTW_ATIVID	:= ZZKTMP->ZZK_CODSIG                    
									DTW->DTW_SERTMS	:= '3'
									DTW->DTW_TIPTRA	:= '1'
									DTW->DTW_FILATI	:= cFilAnt
									DTW->DTW_STATUS	:= "2"
									DTW->DTW_FILATU	:= cFilAnt								
									DTW->DTW_CATOPE	:= '1'			
									DTW->DTW_OBSERV	:= "ONIXSAT"					
								DTW->(MsUnlock("DTW"))						
//								MsgAlert("Novo existente")
								DTWTMP->(DbSelectArea("DTWTMP"))	    	
								DTWTMP->(DbCloseArea("DTWTMP"))								
							Endif						
						Endif
					Else    	// Adriano 21/10/2011
						DTWTMP->(DbSelectArea("DTWTMP"))	    	
						DTWTMP->(DbCloseArea("DTWTMP"))
						// BUSCAR ULTIMA SEQUENCIA DA VIAGEM + 1
						cSql := "SELECT MAX(DTW_SEQUEN) DTW_SEQUEN "
						cSql += "FROM "+RetSqlName("DTW")+ " 
						cSql += "WHERE DTW_FILORI = '"+cFilAnt+"' "
						cSql += "AND D_E_L_E_T_ <> '*' "
						cSql += "AND DTW_VIAGEM = '"+_cViag+"' "
						TCQUERY AllTrim(cSql) NEW ALIAS "DTWTMP"
						DTWTMP->(DbSelectArea("DTWTMP"))
						DTWTMP->(DbGotop())	
						_nSeq := StrZero(Val(DTWTMP->DTW_SEQUEN)+1,6)
				
						// Data envio mensagem.
						_dDtRea	:= StoD(SubStr(oRet:_Responsemensagemcb:_mensagemcb[nR]:_Dt:text,1,4)+;
							SubStr(oRet:_Responsemensagemcb:_mensagemcb[nR]:_Dt:text,6,2)+;
							SubStr(oRet:_Responsemensagemcb:_mensagemcb[nR]:_Dt:text,9,2))
						// hora envio mensagem
						_DHoRea	:= SubStr(oRet:_Responsemensagemcb:_mensagemcb[nR]:_Dt:text,12,2)+;
							SubStr(oRet:_Responsemensagemcb:_mensagemcb[nR]:_Dt:text,15,2)
						DTW->(DbSelectArea("DTW"))
						DTW->(Reclock("DTW",.T.))
							DTW->DTW_FILORI	:= cFilAnt
							DTW->DTW_VIAGEM	:= _cViag
							DTW->DTW_SEQUEN	:= _nSeq
							DTW->DTW_TIPOPE	:= '2'
							DTW->DTW_DATPRE	:= _dDtRea
							DTW->DTW_HORPRE	:= _DHoRea						
							DTW->DTW_DATINI := _dDtRea
							DTW->DTW_DATREA := _dDtRea								
							DTW->DTW_HORINI := _DHoRea
							DTW->DTW_HORREA := _DHoRea
							DTW->DTW_SERVIC	:= ' ' // VERIFICAR NECESSIDADE DE GRAVAR
							DTW->DTW_TAREFA	:= ' ' // VERIFICAR NECESSIDADE DE GRAVAR
							DTW->DTW_ATIVID	:= ZZKTMP->ZZK_CODSIG                    
							DTW->DTW_SERTMS	:= '3'
							DTW->DTW_TIPTRA	:= '1'
							DTW->DTW_FILATI	:= cFilAnt
							DTW->DTW_STATUS	:= "2"
							DTW->DTW_FILATU	:= cFilAnt								
							DTW->DTW_CATOPE	:= '1'			
							DTW->DTW_OBSERV	:= "ONIXSAT"					
						DTW->(MsUnlock("DTW"))						
//						MsgAlert("Novo")
						DTWTMP->(DbSelectArea("DTWTMP"))	    	
						DTWTMP->(DbCloseArea("DTWTMP"))													
					Endif			
				Endif
				ZZKTMP->(DbSelectArea("ZZKTMP"))	    	
				ZZKTMP->(DbCloseArea("ZZKTMP"))	    	
			Endif			    	
			DTQTMP->(DbSelectArea("DTQTMP"))	    	
			DTQTMP->(DbCloseArea("DTQTMP"))	    	
	    Endif
   
 	Endif
Next nR

Return Nil 

Static FUNCTION NoAcento(cString)
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
//cString := _NoTags(cString)

Return cString            