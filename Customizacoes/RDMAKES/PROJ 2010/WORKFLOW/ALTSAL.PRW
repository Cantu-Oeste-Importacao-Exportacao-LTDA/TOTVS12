#include "rwmake.ch"
#include "topconn.ch"
                    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALTSAL    ºAutor  ³Microsiga           º Data ³  16/06/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Workflow de alteração salarial.                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AltSal()

Local aArea 	:= GetArea()
Local salAnter  := 0
Local lFlag 	:= .F.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama função para monitor uso de fontes customizados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())

   	dbSelectArea("SRA")
   	dbSetOrder(1)                        
   	dbGotop()
	If dbSeek(xFilial("SRA") + M->RA_MAT)
		salAnter := SRA->RA_SALARIO
		if salAnter <> M->RA_SALARIO
		   lFlag := .T.
       	endIf
    endIf
	if lFlag
		cQuery := " SELECT ZWF_ATIVO, ZWF_EMAIL, ZWF_EMAILC, ZWF_EMAILO FROM "+RetSQLName("ZWF")
		cQuery += " WHERE "
		cQuery += " ZWF_USERFC = 'ALTSAL' AND "
		cQuery += " ZWF_LISFIL LIKE '%"+xFilial("SC5")+"%' AND "
		cQuery += " D_E_L_E_T_ <> '*' "
		
		TCQUERY cQuery NEW ALIAS "TMP"
		MEMOWRITE("TESTE.SQL",CQUERY)	
		dbSelectArea("TMP")
		If !TMP->(EOF())
			If TMP->ZWF_ATIVO == "S"
				conout("WF - ALTERACAO DE SALARIO - INICIO DO ENVIO DE EMAIL FUNCIONARIO : "+ M->RA_MAT)
				oProcess := TWFProcess():New( "ALTSAL", "ALTERACAO DE SALARIO")
				oProcess:NewTask( "ALTSAL", "\WORKFLOW\ALTSAL.HTML" )
				oProcess:cSubject := "ALTERACAO DE SALARIO. - "+DTOC(DDATABASE)
				oHTML := oProcess:oHTML	

				oHtml:ValByName( "DATA1", dDataBase)
				oHtml:ValByName( "COD_FUNC",  M->RA_MAT)
				oHtml:ValByName( "NOME_FUNC", M->RA_NOME)
				oHtml:ValByName( "SAL_ANT",   SRA->RA_SALARIO) //SALARIO ANTERIOR										
				oHtml:ValByName( "SAL_ATU",   M->RA_SALARIO)   //SALARIO ATUAL 														
				oHtml:ValByName( "USUARIO", subStr(cUsuario,7,15))				
				
				cEmail  := TMP->ZWF_EMAIL
				cEmailC := TMP->ZWF_EMAILC
				cEmailO := TMP->ZWF_EMAILO 
				oProcess:cTo  := LOWER(cEmail)
				oProcess:cCC  := LOWER(cEmailC)
				oProcess:cBCC := LOWER(cEmailO)
				oProcess:Start()
				oProcess:Finish()         
				conout("WF - ALTERACAO DE SALARIO - FIM DO ENVIO DE EMAIL CLIENTE : "+ M->RA_MAT + M->RA_NOME)
				lFlag := .T.
			EndIf
		EndIf
		If lFlag
			cQuery := " UPDATE " + RetSQLName("ZWF") + " SET ZWF_ULTEXC = '"+DTOS(dDataBase)+"'"
			cQuery += " WHERE ZWF_USERFC = 'ALTSAL' AND "
			cQuery += " ZWF_LISFIL LIKE '%"+xFilial("SF2")+"%' AND "
			cQuery += " D_E_L_E_T_ <> '*' "
			TCSQLEXEC(cQuery)	
		Endif
		TMP->(dbCloseArea())
	endIf
RestArea(aArea)
Return .T.
