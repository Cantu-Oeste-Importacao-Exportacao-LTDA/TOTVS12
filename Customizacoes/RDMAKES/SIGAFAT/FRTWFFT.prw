/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FRTWFFT   ºAutor  ³Adriano Novachaelley Data ³  12/11/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Workflow para comunicar os faturistas que as cargas montadasº±±
±±º          ³pela rotina customizada dos fretes, foram faturadas.        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FRTWFFT(_aNFWf)
Local _cMail	:= SuperGetMV("MV_FRTWF",,"novachaelley@gmail.com")
Local _nDias	:= 0
Local cSql 		:= ""
Local _aArea	:= SM0->(GetArea())
//aAdd(_aNFWf,{cEmpAnt,cFilAnt,SD2->D2_DOC,SD2->D2_SERIE,cCarga,SD2->D2_EMISSAO})
 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If Len(_aNFWf) > 0
	
	_cDir 	:= Alltrim(SuperGetMV("MV_WFDIR",,"\workflow\"))
	_cArq	:= "frtwfft.html"
    If Substr(_cDir,Len(_cDir),1) != "\"
		_cDir += "\"
    Endif   
	If !File(_cDir+_cArq)
		conout("ARQUIVO NÃO ENCONTRADO "+_cDir+_cArq)  
	    Return .t.
	Endif 
	oProcess := TWFProcess():New("FRTWFFT","Faturamento de Cargas")
	oProcess:NewTask("FRTWFFT",_cDir+_cArq)
	oProcess:cTo := _cMail
	oProcess:cSubject := "CARGA "+AllTrim(_aNFWf[1,5])+" FATURADA"
	
	oHTML := oProcess:oHTML 
	oHTML:ValByName( 'CODCARGA'		,_aNFWf[1,5])
	

	For nR := 1 To Len(_aNFWf)
		SM0->(DbSelectArea("SM0"))
		SM0->(DbSetOrder(1))
		SM0->(DbGotop())
		SM0->(DbSeek(_aNFWf[nR,1]+_aNFWf[nR,2]))
		AAdd( oHtml:ValByName( "IT.EMP" )		,SM0->M0_NOME)	
		AAdd( oHtml:ValByName( "IT.FILIAL" )	,SM0->M0_FILIAL)
		AAdd( oHtml:ValByName( "IT.NFISCAL" )	,_aNFWf[nR,3]+"/"+_aNFWf[nR,4])
		AAdd( oHtml:ValByName( "IT.DATA" )		,_aNFWf[nR,6])
	Next nR
	RestArea(_aArea)
	oProcess:Start()
	oProcess:Finish()
	oProcess:Free()	
Endif

Return