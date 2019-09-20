#include "rwmake.ch"
#include "TopConn.ch"

// Programa para solicitação de liberação para exclusão de notas fiscais
// de entrada e saida via e-mail.

User Function SolExNF()    
                             
Local cDlgTitle	:= "Solicitação exclusão notas fiscais"
Local aTpNf		  := {'Entrada','Saida'}     
Local aTpOp	    := {'Inclusao','Alteracao'}     
cTpOp						:= 'Inclusao'
cTpNf	   				:= 'Entrada'
nOpca						:= 3    
lAltera		      := .F.

Private lContinue := .F.                     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

cNf		:= Space(TAMSX3("F1_DOC")[1])
cSerie 	:= Space(TAMSX3("F1_SERIE")[1])
cClifor	:= Space(TAMSX3("F1_FORNECE")[1])
cLoja	:= Space(TAMSX3("F1_LOJA")[1])
cNome	:= Space(TAMSX3("A2_NOME")[1])
cObs	:= Space(250)
cTiponf	:= Space(15)
dDtDigit:= StoD("  /  /    ")
nTotal	:= 0
cMotivo	:= Space(6)
cDescMot := Space(40)
/*aMotivo			:= {"Cliente errado","CNPJ cancelado na receita","Nota não autorizada na receita","Receita fora do ar",;
					"Cliente não recebeu a mercadoria","Cliente cancelou","Quantidade errada","Loja errada","Faturado antes de carregar",;
					"Sem estoque físico","Imposto errado","Loja errada","TES errada","Erro na impressão","Pedido em duplicidade",;
					"Erro do vendedor","Erro do faturamento","Série errada","Condição de pagamento errada","Cadastro do produto errado",;
					"Produto sem origem","Dados incorretos no rodapé","Produto estragado","Alteração no pedido","Erro no transporte",;
					"Produto vencido","Vendedor errado"}*/

                       
@ 000,000 TO 200,230 DIALOG oDlg1 TITLE "Tipo do Extrato"
@ 010,010 Say "Nota Fiscal de :"
@ 020,010 COMBOBOX cTpNf ITEMS aTpNf SIZE 80,50  
// Guilherme                    
@ 035,010 Say "Tipo de Operação:"
@ 045,010 COMBOBOX cTpOp ITEMS aTpOp SIZE 80,50
@ 065,010 BMPBUTTON TYPE 1 ACTION VerSol(oDlg1)
ACTIVATE DIALOG oDlg1 CENTER 

IF !lContinue
	return
endif	

If cTpOp == 'Alteracao'
	If GetMv("MV_USALTNF") == Alltrim(cUsername)
		lAltera := .T.      	
	Else
		@ 000,000 TO 100,240 DIALOG oDlg2 TITLE "Alerta"
		@ 010,005 Say "Usuário "+ cUsername +" nao tem"
		@ 020,005 Say "permissao para esse tipo de operação!!"
		@ 030,005 BMPBUTTON TYPE 1 ACTION VerSol(oDlg2)
		ACTIVATE DIALOG oDlg2 CENTER 
		return                               
	EndIf		
EndIf

DEFINE MSDIALOG oDlg TITLE cDlgTitle From 3,1 To 260,570 OF oMainWnd PIXEL

If lAltera != .T. 
	If cTpNf == 'Entrada'
		@ 015,005 Say OemToAnsi("NF")
		@ 022,005 Get cNf PICTURE '@!' 	Size 30,10 F3 "SF1DOC" Valid VerNFE() When .T.
		@ 015,045 Say OemToAnsi("Serie")
		@ 022,045 Get cSerie PICTURE '@!' SIZE 05,10 When .F.
		@ 015,070 Say OemToAnsi("Fornecedor")
		@ 022,070 Get cClifor Picture '@!' Size 35,10 When .F.
		@ 015,110 Say OemToAnsi("Loja")
		@ 022,110 Get cLoja Picture '@!' Size 15,10 When .F.	
		@ 015,130 Say OemToAnsi("Nome")
		@ 022,130 Get cNome Picture '@!' Size 155,10 When .F.
		
		
		@ 035,005 Say OemToAnsi("Motivo da Exclusão")
		@ 042,005 Get cMotivo Size 15, 10 F3 "43" Valid GetMotivo()
		@ 042,040 Get cDescMot Size 90, 10 When .F.
	//	@ 042,005 COMBOBOX cMotivo ITEMS aMotivo SIZE 125,50 
		
		@ 035,130 Say OemToAnsi("Tipo Nota fiscal")
		@ 042,130 Get cTipoNf Size 55,10 When .F. 
		@ 035,190 Say OemToAnsi("Digitação")
		@ 042,190 Get dDtDigit Size 35,10 When .F.
		@ 035,230 Say OemToAnsi("Valor Total")
		@ 042,230 Get nTotal Size 55,10 Picture "@E 999,999,999.99" When .F. 
		
		@ 060,005 Say OemToAnsi("Observações")		
		@ 067,005 Get cObs Memo Size 280,60 When .T.
	ElseIf cTpNf == 'Saida'
		@ 015,005 Say OemToAnsi("NF")
		@ 022,005 Get cNf PICTURE '@!' 	Size 30,10 F3 "SF2DOC" Valid VerNFS() When .T.
		@ 015,045 Say OemToAnsi("Serie")
		@ 022,045 Get cSerie PICTURE '@!' SIZE 05,10 When .F.
		@ 015,070 Say OemToAnsi("Cliente")
		@ 022,070 Get cClifor Picture '@!' Size 35,10 When .F.
		@ 015,110 Say OemToAnsi("Loja")
		@ 022,110 Get cLoja Picture '@!' Size 15,10 When .F.	
		@ 015,130 Say OemToAnsi("Nome")
		@ 022,130 Get cNome Picture '@!' Size 155,10 When .F.
		
		
		@ 035,005 Say OemToAnsi("Motivo da Exclusão")
		@ 042,005 Get cMotivo Size 15, 10 F3 "43" Valid GetMotivo()
		@ 042,040 Get cDescMot Size 90, 10 When .F.
		
		//@ 042,005 COMBOBOX cMotivo ITEMS aMotivo SIZE 125,50 
		
		@ 035,130 Say OemToAnsi("Tipo Nota fiscal")
		@ 042,130 Get cTipoNf Size 55,10 When .F. 
		@ 035,190 Say OemToAnsi("Digitação")
		@ 042,190 Get dDtDigit Size 35,10 When .F.
		@ 035,230 Say OemToAnsi("Valor Total")
		@ 042,230 Get nTotal Size 55,10 Picture "@E 999,999,999.99" When .F. 
		
		@ 060,005 Say OemToAnsi("Observações")		
		@ 067,005 Get cObs Memo Size 280,60 When .T.	
	Endif 
Else // guilherme    
 		If cTpNf == 'Entrada'
	 		@ 015,005 Say OemToAnsi("NF")
			@ 022,005 Get cNf PICTURE '@!' 	Size 30,10 F3 "SF1DOC" Valid VerNFE() When .T.
			@ 015,045 Say OemToAnsi("Serie")
			@ 022,045 Get cSerie PICTURE '@!' SIZE 05,10 When .F.
			@ 015,070 Say OemToAnsi("Fornecedor")
			@ 022,070 Get cClifor Picture '@!' Size 35,10 When .F.
			@ 015,110 Say OemToAnsi("Loja")
			@ 022,110 Get cLoja Picture '@!' Size 15,10 When .F.	
			@ 015,130 Say OemToAnsi("Nome")
			@ 022,130 Get cNome Picture '@!' Size 155,10 When .F.
			
			
			@ 035,005 Say OemToAnsi("Motivo da Exclusão")
			@ 042,005 Get cMotivo Size 15, 10 F3 "43" Valid GetMotivo()
			@ 042,040 Get cDescMot Size 90, 10 When .F.
		//	@ 042,005 COMBOBOX cMotivo ITEMS aMotivo SIZE 125,50 
			
			@ 035,130 Say OemToAnsi("Tipo Nota fiscal")
			@ 042,130 Get cTipoNf Size 55,10 When .F. 
			@ 035,190 Say OemToAnsi("Digitação")
			@ 042,190 Get dDtDigit Size 35,10 When .F.
			@ 035,230 Say OemToAnsi("Valor Total")
			@ 042,230 Get nTotal Size 55,10 Picture "@E 999,999,999.99" When .F. 
			
			@ 060,005 Say OemToAnsi("Observações")		
			@ 067,005 Get cObs Memo Size 280,60 When .T.
		ElseIf cTpNf == 'Saida'
			@ 015,005 Say OemToAnsi("NF")
			@ 022,005 Get cNf PICTURE '@!' 	Size 30,10 F3 "SF2DOC" Valid VerNFS() When .T.
			@ 015,045 Say OemToAnsi("Serie")
			@ 022,045 Get cSerie PICTURE '@!' SIZE 05,10 When .F.
			@ 015,070 Say OemToAnsi("Cliente")
			@ 022,070 Get cClifor Picture '@!' Size 35,10 When .F.
			@ 015,110 Say OemToAnsi("Loja")
			@ 022,110 Get cLoja Picture '@!' Size 15,10 When .F.	
			@ 015,130 Say OemToAnsi("Nome")
			@ 022,130 Get cNome Picture '@!' Size 155,10 When .F.
			
			
			@ 035,005 Say OemToAnsi("Motivo da Exclusão")
			@ 042,005 Get cMotivo Size 15, 10 F3 "43" Valid GetMotivo()
			@ 042,040 Get cDescMot Size 90, 10 When .F.
			
			//@ 042,005 COMBOBOX cMotivo ITEMS aMotivo SIZE 125,50 
			
			@ 035,130 Say OemToAnsi("Tipo Nota fiscal")
			@ 042,130 Get cTipoNf Size 55,10 When .F. 
			@ 035,190 Say OemToAnsi("Digitação")
			@ 042,190 Get dDtDigit Size 35,10 When .F.
			@ 035,230 Say OemToAnsi("Valor Total")
			@ 042,230 Get nTotal Size 55,10 Picture "@E 999,999,999.99" When .F. 
			
			@ 060,005 Say OemToAnsi("Observações")		
			@ 067,005 Get cObs Memo Size 280,60 When .T.	
		Endif 
EndIf

If lAltera != .T. 
	ACTIVATE MSDIALOG oDlg ON INIT EnChoiceBar(oDlg,{||nOpca:=1,if(TudoOk(),oDlg:End(),.f.) } , {||nOpca:=2,oDlg:End()})  CENTER
	If (nOpca == 1) 
	  MsAguarde( {|| SendMail()}, "Aguarde...", "Enviando mensagem..." )         
	  GravaSol()
	Endif                            
Else 
	ACTIVATE MSDIALOG oDlg ON INIT EnChoiceBar(oDlg,{||nOpca:=1,if(TudoOk(),oDlg:End(),.f.) } , {||nOpca:=2,oDlg:End()})  CENTER
	If (nOpca == 1) 
	  MsAguarde( {|| SendMail()}, "Aguarde...", "Enviando mensagem..." )         
	  AlteraSol()
	Endif                            
EndIf	
     
Return

Static Function VerSol(oDlg)

	lContinue := .T.
	
	Close(oDlg)	

Return

Static Function GetMotivo()
cDescMot := Posicione("SX5", 01, xFilial("SX5") + "43" + AllTrim(cMotivo), "X5_DESCRI")
Return .T.


Static Function VerNFE()
Local lRet	:= .T.

cSql := "SELECT F1.F1_FORNECE, F1.F1_LOJA, F1.F1_TIPO, F1.F1_DTDIGIT, F1.F1_VALBRUT "
cSql += "FROM "+RetSqlName("SF1")+" F1 "
cSql += "WHERE F1.F1_FILIAL = '"+xFilial("SF1")+"' "
cSql += "AND F1.D_E_L_E_T_ <> '*' " 
cSql += "AND F1.F1_DOC = '"+cNf+"' AND F1.F1_SERIE = '"+cSerie+"' "
cSql += "AND F1.F1_FORNECE = '"+cClifor+"' AND F1.F1_LOJA = '"+cLoja+"' "
TCQUERY cSql NEW ALIAS "TMPSF1"
                          	
DbSelectArea("TMPSF1")
TMPSF1->(DbGotop())
If !TMPSF1->(Eof())
	dDtDigit:= StoD(TMPSF1->F1_DTDIGIT)
	nTotal	:= TMPSF1->F1_VALBRUT
	Do Case
		Case TMPSF1->F1_TIPO == 'N'
			cTipoNf := "Normal"
			cNome 	:= 	POSICIONE("SA2",1,xFilial("SA2")+TMPSF1->F1_FORNECE+TMPSF1->F1_LOJA,"A2_NOME")
		Case TMPSF1->F1_TIPO == 'B'
			cTipoNf := "Beneficiamento"
			cNome 	:= POSICIONE("SA1",1,xFilial("SA1")+TMPSF1->F1_FORNECE+TMPSF1->F1_LOJA,"A1_NOME")			
		Case TMPSF1->F1_TIPO == 'D'
			cTipoNf := "Devolução"
			cNome 	:= POSICIONE("SA1",1,xFilial("SA1")+TMPSF1->F1_FORNECE+TMPSF1->F1_LOJA,"A1_NOME")
	End Case
	dlgRefresh(oDlg)
Else
	Alert("Nota fiscal inválida.")	
	lRet := .F.
Endif
TMPSF1->(DbCloseArea())

Return(lRet)

Static Function VerNFS()
Local lRet	:= .T.

cSql := "SELECT F2.F2_CLIENTE, F2.F2_LOJA, F2.F2_TIPO, F2.F2_EMISSAO, F2.F2_VALBRUT "
cSql += "FROM "+RetSqlName("SF2")+" F2 "
cSql += "WHERE F2.F2_FILIAL = '"+xFilial("SF2")+"' "
cSql += "AND F2.D_E_L_E_T_ <> '*' " 
cSql += "AND F2.F2_DOC = '"+cNf+"' AND F2.F2_SERIE = '"+cSerie+"' "
cSql += "AND F2.F2_CLIENTE = '"+cClifor+"' AND F2.F2_LOJA = '"+cLoja+"' "
TCQUERY cSql NEW ALIAS "TMPSF2"
   
DbSelectArea("TMPSF2")
TMPSF2->(DbGotop())
If !TMPSF2->(Eof())
	dDtDigit:= StoD(TMPSF2->F2_EMISSAO)
	nTotal	:= TMPSF2->F2_VALBRUT
	Do Case
		Case TMPSF2->F2_TIPO == 'N'
			cTipoNf := "Normal"
			cNome 	:= POSICIONE("SA1",1,xFilial("SA1")+TMPSF2->F2_CLIENTE+TMPSF2->F2_LOJA,"A1_NOME")
		Case TMPSF2->F2_TIPO == 'B'
			cTipoNf := "Beneficiamento"
			cNome 	:= POSICIONE("SA2",1,xFilial("SA2")+TMPSF2->F2_CLIENTE+TMPSF2->F2_LOJA,"A2_NOME")
		Case TMPSF2->F2_TIPO == 'D'
			cTipoNf := "Devolução"
			cNome 	:= POSICIONE("SA2",1,xFilial("SA2")+TMPSF2->F2_CLIENTE+TMPSF2->F2_LOJA,"A2_NOME")
	End Case
	dlgRefresh(oDlg)
Else
	Alert("Nota fiscal inválida.")	
	lRet := .F.
Endif
TMPSF2->(DbCloseArea())

Return(lRet)

Static Function TudoOk()
Local lRet := .T.
If cTpNf == 'Entrada'
	lRet := VerNFE()
Else
	lRet := VerNFS()
Endif

Return(lRet)

Static Function SendMail()
Local oHtml
        	
conout("WF INICIO - LIBERAÇÃO DE ACESSO PARA EXCLUSÃO DE NF DE "+Upper(cTpNf))
oProcess := TWFProcess():New( "SOLEXNF","LIBERAÇÃO DE ACESSO PARA EXCLUSÃO DE NF DE "+Upper(cTpNf))
oProcess:NewTask( "SOLEXNF", "\workflow\solexnf.html" )
oProcess:cSubject := "LIBERAÇÃO DE ACESSO PARA EXCLUSÃO DE NF DE "+Upper(cTpNf)
oHTML := oProcess:oHTML	

oHtml:ValByName( "EMPRESA"  ,SM0->M0_NOME)
oHtml:ValByName( "FILIAL" 	,SM0->M0_FILIAL)
oHtml:ValByName( "DATA" 	,Date())
oHtml:ValByName( "HORA" 	,Time())
oHtml:ValByName( "USUARIO"	,Upper(SubStr(cUsuario, 07, 15)))                                  	
oHtml:ValByName( "DTDIGIT"  ,dDtDigit)
oHtml:ValByName( "DOC"		, cNf+" - "+cSerie)
oHtml:ValByName( "TIPO"		,cTpNf+" "+cTipoNf) 				
oHtml:ValByName( "CLIFOR"	,cClifor+" - "+cLoja)
oHtml:ValByName( "NOME"		,cNome)
oHtml:ValByName( "MOTIVO"	,cMotivo + "- " + cDescMot)
oHtml:ValByName( "OBS"		,Upper(cObs))

If cTpNf == "Entrada"
	oProcess:cCC  := GetMv("MV_EXNFENT")
Else
	oProcess:cCC  := GetMv("MV_EXNFSAI")
Endif
//oProcess:cCC  := 'helpdesk.ti@grupocantu.com.br'

// Adiciona o email dos responsaveis no html
//oHtml:ValByName( "RESPONSAVEIS"	, oProcess:cCC + ';' + getMail())
oHtml:ValByName( "RESPONSAVEIS"	, oProcess:cCC )
oProcess:Start()
oProcess:Finish()         
conout("WF FINAL - LIBERAÇÃO DE ACESSO PARA EXCLUSÃO DE NF DE "+Upper(cTpNf))
Return(.T.)                

Static Function GravaSol()                
	DbSelectArea("SZT")	
	RecLock("SZT",.T.) 
	
	ZT_FILIAL := xFilial("SZT")
	ZT_NF := cNf
	ZT_SERIE := cSerie
	ZT_FORNEC := cClifor
	ZT_LOJA := cLoja
	ZT_MOTEXCL := cMotivo + " - " + cDescMot
	ZT_TIPONF := SubStr(cTipoNf,01, 01)
	ZT_DTSOL := Date()
	cTime := TIME()
	ZT_HORA := SubStr(cTime,1,5)
	ZT_OBS := Upper(cObs)   	
	ZT_USUARIO := Upper(SubStr(cUsuario, 07, 15)) 
	ZT_SEQ := GetSXENum("SZT","ZT_SEQ")  
	ZT_TPNF := cTpNf
		
	MSUnLock()                         
	ConfirmSX8()
Return(.T.)     

Static Function AlteraSol()                
	dbSelectArea("SZT")
	dbSetOrder(2)
	dbgotop()
		
	If dbSeek(xFilial("SZT") + cNf + cSerie + cClifor + cLoja)
		RecLock("SZT",.F.)
	 	ZT_NF := cNf
		ZT_SERIE := cSerie
		ZT_FORNEC := cClifor
		ZT_MOTEXCL := cMotivo + " - " + cDescMot
		ZT_DTSOL := Date()
		cTime := TIME()
		ZT_HORA := SubStr(cTime,1,5)
		ZT_OBS := Upper(cObs)   	
		ZT_USUARIO := Upper(SubStr(cUsuario, 07, 15)) 
		MSUnLock()                         
	Else
	 	@ 000,000 TO 100,240 DIALOG oDlg3 TITLE "Alerta"
		@ 020,005 Say "NOTA FISCAL SEM REGISTRO PARA ALTERACAO!!"
		@ 030,005 BMPBUTTON TYPE 1 ACTION VerSol(oDlg3)
		ACTIVATE DIALOG oDlg3 CENTER 
		return		
	EndIf 
		
Return(.T.)

//retorna e-mail do usuario
static function getEmail()
  local pcUser:= SubStr(cUsuario,7,15)
	local cArea := getArea()
	local cRet  := ''
	PswOrder(1)
	//
	if PswSeek(pcUser,.t.)
		cRet := PswRet(1)[1,14]
	endif
	restarea(cArea)
return(cRet)