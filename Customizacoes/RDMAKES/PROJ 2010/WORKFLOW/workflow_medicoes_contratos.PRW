#Include "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ WFMEDCTR º Autor ³ Adriano Novachaelley Data ³  24/04/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³  Workflow para comunicar usuarios responsáveis pelos       º±±
±±º          ³  contratos, que existem medições a serem feitas em uma     º±±
±±º          ³  determinada data.                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function WFMEDCTR()

Local _aFils	:= {}
Local _cMail	:= "" 
Local _nDias	:= 0
Local cSql 		:= ""
Local _aEmp		:= SM0->M0_CODIGO
Local _aFilial	:= SM0->M0_CODFIL
Local _aAreaSM0	:= SM0->(GetArea())  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

DbSelectArea("SM0")
SM0->(DbGotop())
While !SM0->(Eof())
	If SM0->M0_CODIGO == _aEmp
		aAdd(_aFils,{SM0->M0_CODIGO,SM0->M0_CODFIL})
	Endif
	SM0->(DbSkip())
End
DbSelectArea("SM0")
DbSeek(_aEmp+_aFilial)
RestArea(_aAreaSM0)


For nR := 1 To Len(_aFils)
	cSql := "SELECT CNF.*,CNC.CNC_CODIGO,CNC.CNC_LOJA, CN9.CN9_CODOBJ "
	cSql += "FROM "+RetSqlName("CNF")+" CNF, "+RetSqlName("CNC")+" CNC, "+RetSqlName("CN9")+" CN9 "
	cSql += "WHERE CNF.CNF_FILIAL = '"+_aFils[nR,2]+"' AND CNC.CNC_FILIAL = '"+_aFils[nR,2]+"' "
	cSql += "AND CN9.CN9_FILIAL = '"+_aFils[nR,2]+"' "
	cSql += "AND CNF.D_E_L_E_T_ <> '*' AND CNC.D_E_L_E_T_ <> '*' AND CN9.D_E_L_E_T_ <> '*' "
	cSql += "AND CNC.CNC_NUMERO = CNF.CNF_CONTRA "
	cSql += "AND CN9.CN9_NUMERO = CNF.CNF_CONTRA "
	cSql += "AND CNF.CNF_PRUMED = '"+DtoS(Date())+"' "  
//	cSql += "AND CNF.CNF_PRUMED = '20110527' "  
	cSql += "ORDER BY CNF.CNF_NUMERO"
	TCQUERY cSql NEW ALIAS "CNFTMP"
	CNFTMP->(DbSelectArea("CNFTMP"))
	CNFTMP->(DbGotop()) 

	If !CNFTMP->(Eof())			
		_cDir 	:= Alltrim(SuperGetMV("MV_WFDIR",,"\workflow\"))
		_cArq	:= "wfmedctr.html"
	
	    If Substr(_cDir,Len(_cDir),1) != "\"
			_cDir += "\"
	    Endif   
		If !File(_cDir+_cArq)
			conout("ARQUIVO NÃO ENCONTRADO "+_cDir+_cArq)  
		    Return .t.
		Endif 
		
		cSql := "SELECT * "
		cSql += "FROM "+RetSqlName("CNN")+" "
		cSql += "WHERE D_E_L_E_T_ <> '*' "
		cSql += "AND CNN_FILIAL = '"+_aFils[nR,2]+"' "
		cSql += "AND CNN_CONTRA = '"+CNFTMP->CNF_CONTRA+"' "
		TCQUERY cSql NEW ALIAS "CNNTMP"
		CNNTMP->(DbSelectArea("CNNTMP"))
		CNNTMP->(DbGotop())	
		
		While !CNNTMP->(Eof())
			oProcess := TWFProcess():New("CNNTMP","Medição de Contratos")
			oProcess:NewTask("MEDCTR",_cDir+_cArq)
			oProcess:cSubject := " MEDIÇÃO DE CONTRATO PARA O DIA "+dtoc(Date())
			ConOut(SM0->M0_NOME)
		 	_cMail := AllTrim(UsrRetMail(CNNTMP->CNN_USRCOD))
    //	_cMail := 'dioni@grupocantu.com.br'	 
			oProcess:cTo := _cMail
			//oProcess:cBCC := "novachaelley@gmail.com" // Remover após aprovação Yuri. Utilizado somente para testes 			
			oHTML := oProcess:oHTML 
			oHTML:ValByName( 'CODIGOCTR'						,CNFTMP->CNF_CONTRA)
			oHTML:ValByName( 'OBJETO'							,MSMM(CNFTMP->CN9_CODOBJ))		
			AAdd( oHtml:ValByName( "IT.FILIAL" )				,CNFTMP->CNF_FILIAL)
			AAdd( oHtml:ValByName( "IT.COD" )					,AllTrim(CNFTMP->CNF_PARCEL)+"/"+AllTrim(PadL(CNFTMP->CNF_MAXPAR, 3, "0")))
			AAdd( oHtml:ValByName( "IT.DATA" )					,DtoC(StoD(CNFTMP->CNF_PRUMED)))
			AAdd( oHtml:ValByName( "IT.VENC" )					,DtoC(StoD(CNFTMP->CNF_DTVENC)))
			AAdd( oHtml:ValByName( "IT.FORNECEDOR" )			,CNFTMP->CNC_CODIGO+"/"+CNFTMP->CNC_LOJA+"  -  "+;
																SubStr(POSICIONE("SA2",1,xFilial("SA2")+CNFTMP->CNC_CODIGO+CNFTMP->CNC_LOJA,"A2_NOME"),1,40))
			AAdd( oHtml:ValByName( "IT.VALOR" )					,Transform(CNFTMP->CNF_SALDO, "@E 9,999,999.99"))		
	
			oProcess:Start()
			oProcess:Finish()
			oProcess:Free()	
			CNNTMP->(DbSelectArea("CNNTMP"))
			CNNTMP->(DbSkip())		
		End
		
		CNNTMP->(DbSelectArea("CNNTMP"))
		CNNTMP->(DbCloseArea())	
	
		CNFTMP->(DbSelectArea("CNFTMP"))
		CNFTMP->(DbSkip())
	Endif		
	
	CNFTMP->(DbSelectArea("CNFTMP"))
	CNFTMP->(DbCloseArea())
Next nR

Return