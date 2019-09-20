#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH" 
#INCLUDE "TOPCONN.CH" 


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ WfNcc    º Autor ³ Adriano Novachaelley Data ³  23/11/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³  Workflow para envio de e-mail com NCC´s em aberto e       º±±
±±º          ³  lançadas a mais de x dias.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function WfNcc(_aParm)
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
//	RpcSetEnv('01','01',,,,GetEnvServer(),{ })
	If !Empty(AllTrim(xFilial("SE1"))) 
	    DbSelectArea("SM0")
	    SM0->(DbGotop())
	    While !SM0->(Eof())
	    	If SM0->M0_CODIGO == _aParm[1,1]
				aAdd(_aFils,{SM0->M0_CODIGO,SM0->M0_CODFIL})
			Endif
	    	SM0->(DbSkip())
	    End
    Else
		aAdd(_aFils,{_aParm[1,1],xFilial("SE1")})
//		aAdd(_aFils,{'01',xFilial("SE1")})
    Endif
    For nR := 1 To Len(_aFils)    
		RpcSetEnv(_aFils[nR,1],_aFils[nR,2],,,,GetEnvServer(),{ })
		_cMail	:= SUPERGETMV("MV_NCCMAIL",,"")
		_nDias	:= SUPERGETMV("MV_NCCDIAS",,365)
		_cDir 	:= Alltrim(SuperGetMV("MV_WFDIR",,"\workflow\"))
		_cArq	:= "wfncc.html"

	    If Substr(_cDir,Len(_cDir),1) != "\"
			_cDir += "\"
	    Endif   
		If !File(_cDir+_cArq)
			conout("ARQUIVO NÃO ENCONTRADO "+_cDir+_cArq)  
		    Return .t.
		Endif 		
		cSql := "SELECT E1.E1_NUM, E1.E1_CLIENTE, E1.E1_LOJA, E1.E1_EMISSAO, "
		cSql += "E1.E1_VALOR, E1.E1_SALDO, A1.A1_NOME "
		cSql += "FROM "+RetSqlName("SE1")+" E1, "+RetSqlName("SA1")+" A1 "
		cSql += "WHERE E1.E1_FILIAL = '"+_aFils[nR,2]+"' AND A1.A1_FILIAL = '"+xFilial("SA1")+"' "
		cSql += "AND E1.D_E_L_E_T_ <> '*' AND A1.D_E_L_E_T_ <> '*' "
		cSql += "AND A1.A1_COD = E1.E1_CLIENTE AND A1.A1_LOJA = E1.E1_LOJA "
		cSql += "AND E1.E1_TIPO = 'NCC' AND E1.E1_SALDO > 0 "
		cSql += "AND E1.E1_EMISSAO <= '"+DtoS(Date()-_nDias)+"' "
		cSql += "ORDER BY E1.E1_EMISSAO, E1.E1_CLIENTE, E1.E1_LOJA "
		cSql := ChangeQuery(cSql)
		TcQuery cSql NEW ALIAS "TMPNCC"
		TMPNCC->(DbSelectArea("TMPNCC"))
		TMPNCC->(DbGotop())
		If !TMPNCC->(Eof())
			oProcess := TWFProcess():New("NCCAB","NCCABERTO")
			oProcess:NewTask("NCCSDO",_cDir+_cArq)
			oProcess:cSubject := dtoc(MsDate())+" TITULOS NCC EM ABERTO " + SM0->M0_NOMECOM + " - " + SM0->M0_FILIAL
			oProcess:cTo := _cMail 
			oHTML := oProcess:oHTML 
			oHTML:ValByName( 'DATA1'		,Date())		
			While !TMPNCC->(Eof())
				AAdd( oHtml:ValByName( "IT.TITULO" )		,TMPNCC->E1_NUM)
				AAdd( oHtml:ValByName( "IT.CODIGO_CLIENTE")	,TMPNCC->E1_CLIENTE+"/"+TMPNCC->E1_LOJA)	
				AAdd( oHtml:ValByname( "IT.NOME_CLIENTE")		,TMPNCC->A1_NOME)
				AAdd( oHtml:ValByname( "IT.EMISSAO")		,StoD(TMPNCC->E1_EMISSAO))
				AAdd( oHtml:ValByName( "IT.VALOR")			,Transform(TMPNCC->E1_VALOR,PesqPict("SE1","E1_VALOR")))
				AAdd( oHtml:ValByName( "IT.SALDO")			,Transform(TMPNCC->E1_SALDO,PesqPict("SE1","E1_SALDO")))
				TMPNCC->(DbSkip())	
			End
			oProcess:Start()
			oProcess:Finish()
//			oProcess:Free()
		Else
			ConOut("WFNCC - Nenhuma NCC em aberto foi encontrada.")
		Endif
		TMPNCC->(DbSelectArea("TMPNCC"))
		TMPNCC->(DbCloseArea())
		RpcClearEnv() // Zera ambiente para possibilitar o posicionamento na proxima filial.  
    Next nR
EndIf

Return  