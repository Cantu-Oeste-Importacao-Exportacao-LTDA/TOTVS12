#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF380BTCUST บAutor  ณRafael Parma        บ Data ณ  13/01/11  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo de pesquisa auxiliar na janela de reconcilia็ใo      บฑฑ
ฑฑบ          ณbancแria.                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RJU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-------------------------------*
User Function F380BTCUST() 
*-------------------------------*
Private cSelFil := {"Valor","N๚mero","Documento","Beneficiแrio","Cheque"}   
Private cVALOR  := Space(20)
Private nOpca   := 0     

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

	If Paramixb[1] == 1 
		Return "Pesquisar" 
	ElseIf Paramixb[1] == 2 
		Return "Pesquisar" 
	Else
		U_RJFIL380(@nOpca,@cVALOR,@cSelFil)
		If nOpca == 1
			dbSelectArea("TRB")
			// posicao atual
			nRec1 := Recno()
			nRec2 := Recno()
			// primeiro registro
			dbGoTop()
			nRecT := Recno()
			// reposiciono
			dbGoTo(nRec1)
			If !TRB->(EOF())
				TRB->(dbSkip())
			Else
				dbGoTop()
			EndIf
			// percorre todos os proximos registros a partir do posicionamento atual
			While !EOF()
				do case
					case cSelFil  = "Valor"
						If TRB->E5_VALOR == VAL(cVALOR)
							nRec2 := Recno()
							Exit
						EndIf
					case cSelFil  = "N๚mero"
						If ALLTRIM(cVALOR) $ ALLTRIM(TRB->E5_NUMERO)
							nRec2 := Recno()
							Exit
						EndIf
					case  cSelFil  = "Documento"
						If ALLTRIM(cVALOR) $ ALLTRIM(TRB->E5_DOCUMEN)
							nRec2 := Recno()
							Exit
						EndIf
					case  cSelFil  = "Beneficiแrio"
						If ALLTRIM(cVALOR) $ ALLTRIM(TRB->E5_BENEF)
							nRec2 := Recno()
							Exit
						EndIf
					case  cSelFil  = "Cheque"
						If ALLTRIM(cVALOR) $ ALLTRIM(TRB->E5_NUMCHEQ)
							nRec2 := Recno()
							Exit
						EndIf						
				endcase
				TRB->(dbSkip())
			Enddo
			// caso nใo encontre a chave e o registro atual diferente do primeiro
			// percorre os registros anteriores ate o ponto do registro atual.
			If nRec1 == nRec2 .and. nRecT != nRec1
				dbSelectArea("TRB")
				dbGoTop()
				While !EOF()
					If nRec1 == Recno()
						Exit
					EndIf
					do case
						case cSelFil  = "Valor"
							If TRB->E5_VALOR == VAL(cVALOR)
								nRec2 := Recno()
								Exit
							EndIf
						case cSelFil  = "N๚mero"
							If ALLTRIM(cVALOR) $ ALLTRIM(TRB->E5_NUMERO)
								nRec2 := Recno()
								Exit
							EndIf
						case  cSelFil  = "Documento"
							If ALLTRIM(cVALOR) $ ALLTRIM(TRB->E5_DOCUMEN)
								nRec2 := Recno()
								Exit
							EndIf
						case  cSelFil  = "Beneficiแrio"
							If ALLTRIM(cVALOR) $ ALLTRIM(TRB->E5_BENEF)
								nRec2 := Recno()
								Exit
							EndIf
						case  cSelFil  = "Cheque"
							If ALLTRIM(cVALOR) $ ALLTRIM(TRB->E5_NUMCHEQ)
								nRec2 := Recno()
								Exit
							EndIf							
					endcase
					TRB->(dbSkip())
				Enddo
			EndIf
			dbGoTo(nRec2)
		EndIf	
	 	Return 
	Endif 
	
Return

*----------------------------------------------*
User Function RJFIL380(nOpca,cVALOR,cSelFil)
*----------------------------------------------*
Local oDlg, oCbx1                

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())                                      
 
	DEFINE MSDIALOG oDlg FROM 010,100 TO 160,400 TITLE "Pesquisar"  OF oMainWnd PIXEL
	@ 015,015 SAY "Pesquisar por ?"  SIZE 200,10 OF oDlg PIXEL 
	@ 015,060 MSCOMBOBOX oCbx1 VAR cSelFil ITEMS cSelFil      SIZE 060,09 OF oDlg PIXEL 
	@ 035,015 SAY "Chave:"  SIZE 200,10 OF oDlg PIXEL
	@ 035,060 GET cVALOR SIZE 050,10 OF oDlg PIXEL
	
	DEFINE SBUTTON FROM 055, 060 TYPE 1 ACTION (nOpca:=1,oDlg:End())ENABLE OF oDlg PIXEL
	DEFINE SBUTTON FROM 055, 090 TYPE 2 ACTION (nOpca:=2,oDlg:End())ENABLE OF oDlg PIXEL
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
Return (nOpca)




