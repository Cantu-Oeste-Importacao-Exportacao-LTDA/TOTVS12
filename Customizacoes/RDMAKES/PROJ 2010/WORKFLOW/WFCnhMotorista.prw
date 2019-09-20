#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH" 
#INCLUDE "TOPCONN.CH" 


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ WfCNH    º Autor ³ Adriano Novachaelley Data ³  23/11/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³  Workflow para envio de listagem de motoristas com CNH x   º±±
±±º          ³  vencimento de CNH.                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function WFcnh(_aParm)
Local _aFils	:= {}
Local _cMail	:= "" 
Local _nDias	:= 0  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())


If	Select('SX2') == 0						
	RPCSetType( 3 )					
	RpcSetEnv(_aParm[1,1],_aParm[1,2],,,,GetEnvServer(),{ })
	If !Empty(AllTrim(xFilial("DA4"))) 
	    DbSelectArea("SM0")
	    SM0->(DbGotop())
	    While !SM0->(Eof())
	    	If SM0->M0_CODIGO == _aParm[1,1]
				aAdd(_aFils,{SM0->M0_CODIGO,SM0->M0_CODFIL})
			Endif
	    	SM0->(DbSkip())
	    End
	    DbSelectArea("SM0")
	    DbSeek(_aParm[1,1]+_aParm[1,2])
    Else
		aAdd(_aFils,{_aParm[1,1],xFilial("DA4")})
    Endif
    
    For nR := 1 To Len(_aFils)
		RpcSetEnv(_aFils[nR,1],_aFils[nR,2],,,,GetEnvServer(),{ })  
		_cMail	:= SUPERGETMV("MV_CNHMAIL",,"")
		_cDir 	:= Alltrim(SuperGetMV("MV_WFDIR",,"\workflow\"))
		_cArq	:= "wfcnh.html"

	    If Substr(_cDir,Len(_cDir),1) != "\"
			_cDir += "\"
	    Endif   
		If !File(_cDir+_cArq)
			conout("ARQUIVO NÃO ENCONTRADO "+_cDir+_cArq)  
		    Return .t.
		Endif 
		
		cSql := "SELECT DA4.DA4_FILIAL, DA4.DA4_COD, DA4.DA4_NOME, DA4.DA4_NUMCNH, DA4.DA4_DTVCNH "
		cSql += "FROM "+RetSqlName("DA4")+ " DA4 "
		cSql += "WHERE DA4.D_E_L_E_T_ <> '*' "
		cSql += "AND DA4.DA4_FILIAL = '"+_aFils[nR,2]+"' "
		cSql += "AND DA4.DA4_BLQMOT <> '1' "
		cSql += "ORDER BY DA4.DA4_NOME "
		cSql := ChangeQuery(cSql)
		TcQuery cSql NEW ALIAS "TMPCNH"
		TMPCNH->(DbSelectArea("TMPCNH"))
		TMPCNH->(DbGotop())
		If !TMPCNH->(Eof())
			oProcess := TWFProcess():New("DA4CNH","MOTORISTAS")
			oProcess:NewTask("MOTORISTAS",_cDir+_cArq)
			oProcess:cSubject := dtoc(MsDate())+" MOTORISTAS "+SM0->M0_NOME 
			ConOut(SM0->M0_NOME)
			oProcess:cTo := _cMail 
			oHTML := oProcess:oHTML 
			oHTML:ValByName( 'DATA'		,Date())		
			While !TMPCNH->(Eof())
				AAdd( oHtml:ValByName( "IT.FILIAL" )				,TMPCNH->DA4_FILIAL)
				AAdd( oHtml:ValByName( "IT.CODIGO_MOTORISTA" )		,TMPCNH->DA4_COD)
				AAdd( oHtml:ValByName( "IT.NOME_MOTORISTA" )		,TMPCNH->DA4_NOME)				
				AAdd( oHtml:ValByName( "IT.VENCIMENTO" )			,StoD(TMPCNH->DA4_DTVCNH))				
				AAdd( oHtml:ValByName( "IT.CNH" )					,TMPCNH->DA4_NUMCNH)
				TMPCNH->(DbSkip())	
			End
			oProcess:Start()
			oProcess:Finish()
			oProcess:Free()
		Else
			ConOut("WFCNH - Nenhum motorista cadastrado.")
		Endif
		TMPCNH->(DbSelectArea("TMPCNH"))
		TMPCNH->(DbCloseArea())
		RpcClearEnv() // Zera ambiente para possibilitar o posicionamento na proxima filial.  
    Next nR
EndIf

Return