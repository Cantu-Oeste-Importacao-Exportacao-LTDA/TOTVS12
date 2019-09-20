#include "rwmake.ch" 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VerDescto    ºAutor  ³Flavio Dias      º Data ³  10/08/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validar o desconto digitado na nota fiscal para que        º±±
±±º          ³ quando passar do máximo liberado para o armazém seja       º±±
±±º          ³ seja enviado email para os gerentes notificando do mesmo   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VerDescto()
Local aArea := GetArea()
Local nVTot := 0
Local nVTotTab := 0
Local cVend
Local nDescto
Local nPerDesc
Local lEnvMail := .F.
Local aValGrup := {}
Local nPos
Local i
Local lRevend := .F.
Local nDesMax
Local cGrupo := ""
Local cEmail := "" 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

if SF2->F2_TIPO = "N"  
	If dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
		While !Eof() .and. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA == ;
					   xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA       
		  nPos := aScan(aValGrup, { |x| x[1] = SD2->D2_LOCAL + SD2->D2_GRUPO})
		  if nPos <= 0     // local + grupo								 preco vendido  preco de tabela                
		    AAdd(aValGrup, {SD2->D2_LOCAL + SD2->D2_GRUPO, SD2->D2_TOTAL, SD2->D2_QUANT * SD2->D2_PRUNIT})
		  Else
		    aValGrup[nPos, 2] += SD2->D2_TOTAL
 		    aValGrup[nPos, 3] += SD2->D2_QUANT * SD2->D2_PRUNIT
		  EndIf
      SD2->(dbSkip())
		Enddo
		// verifica o tipo do cliente
		for i:= 1 to len(aValGrup)
		  SZA->(DbSetOrder(01))
		  SZA->(DbSeek(xFilial("SZA") + Left(aValGrup[i, 1], 2)))
		  nDesMax := SZA->ZA_DESCREV
			nPerDesc := (1 - (aValGrup[i, 2] / aValGrup[i, 3])) * 100
			nPerDesc := Round(nPerDesc, 2)
			// Verificar quando deve enviar email, se quando passa do limite do palm ou quando
			lEnvMail := lEnvMail .Or. (nPerDesc > nDesMax)
			if (nPerDesc > nDesMax)
			  cEmail += SZA->ZA_EMAIL + ";"
			EndIf
		Next
	EndIf
EndIf

If lEnvMail
  // Localiza o vendedor
  cVend := Posicione("SA3", 01, xFilial("SA3") + SF2->F2_VEND1, "A3_NREDUZ")  
  conout("WF - SF2DESC - INICIO DO ENVIO DE EMAIL DESCONTO ACIMA DO PERMITIDO - "+SF2->F2_DOC+"/"+SF2->F2_SERIE)
	oProcess := TWFProcess():New( "SF2520E", "VENDA COM DESCONTO ACIMA DO PERMITIDO")
	oProcess:NewTask( "SF2520E", "\WORKFLOW\SF2DESC.HTM" )
	oProcess:cSubject := "Venda com desconto acima do permitido"
	oHTML := oProcess:oHTML	
	oHtml:ValByName( "EMPRESA"  , SM0->M0_CODIGO+"-"+UPPER(SM0->M0_NOMECOM) )    
	oHtml:ValByName( "FILIAL"   , SM0->M0_CODFIL+"-"+UPPER(SM0->M0_FILIAL)  )
	oHtml:ValByName( "VENDEDOR"  , SF2->F2_VEND1 + " - " + cVend )
	oHtml:ValByName( "HORAATU"  , time() )
	oHtml:ValByName( "DDATABASE", dDataBase )
	oHtml:ValByName( "NOTAF"    , SF2->F2_DOC+"/"+SF2->F2_SERIE 			)
	oHtml:ValByName( "CLIENTE"  , SF2->F2_CLIENTE+"/"+SF2->F2_LOJA+" - "+Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_NOME"))
	oHtml:ValByName( "EMISSAO"  , DTOC(SF2->F2_EMISSAO)	 )

	dbSelectArea("SD2")
	dbSetOrder(3)
	If dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
		While !EOF() .and. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA == ;
						   xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA
	       AAdd( (oHtml:ValByName( "IT.CODIGO" )), SD2->D2_COD )		              
	       AAdd( (oHtml:ValByName( "IT.DESCRI" )), Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_DESC") )		              
	       AAdd( (oHtml:ValByName( "IT.QUANT"  )), TRANSFORM( SD2->D2_QUANT ,'@E 9,999,999.99' ) )		              
	       AAdd( (oHtml:ValByName( "IT.PRCVEN" )), TRANSFORM( SD2->D2_PRCVEN,'@E 9,999,999.99' ) )		              
	       AAdd( (oHtml:ValByName( "IT.TOTAL"  )), TRANSFORM( SD2->D2_TOTAL ,'@E 9,999,999.99' ) )
	       nDescto := (SD2->D2_QUANT * SD2->D2_PRUNIT) - SD2->D2_TOTAL
	       nPerDesc := (1 - (SD2->D2_TOTAL / (SD2->D2_QUANT * SD2->D2_PRUNIT))) * 100
	       AAdd( (oHtml:ValByName( "IT.DESCTO"  )), TRANSFORM( nDescto ,'@E 99,999.99' ) + " (" + TRANSFORM( nPerDesc ,'@E 99.99' ) + " %)" )	       
	       SD2->(dbSkip())
		EndDo
		For i:= 1 to len(aValGrup)
		  nPerDesc := (1 - (aValGrup[i, 2] / aValGrup[i, 3])) * 100
		  nPerDesc := Round(nPerDesc, 2)
		  nDescto := aValGrup[i, 3] - aValGrup[i, 2]
		  AAdd( (oHtml:ValByName( "IT.Grupo" )), Left(aValGrup[i, 1], 2) + "/" + Right(aValGrup[i, 1], 4) )
		  AAdd( (oHtml:ValByName( "IT.Descto" )), TRANSFORM( nDescto ,'@E 99,999.99' ) + " (" + TRANSFORM( nPerDesc ,'@E 99.99' ) + " %)" )
		Next
		oHtml:ValByName( "DESCTOT"  , TRANSFORM( nDescto ,'@E 99,999.99' ) + " (" + TRANSFORM( nPerDesc ,'@E 99.99' ) + " %)" )
	Endif
	
	oProcess:cTo  := LOWER(cEmail)
	oProcess:cCC  := ""
	oProcess:cBCC := ""
	oProcess:Start()
	oProcess:Finish()
	conout("WF - SF2DESC - FIM DO ENVIO DE EMAIL DESCONTO ACIMA DO PERMITIDO - "+SF2->F2_DOC+"/"+SF2->F2_SERIE)
EndIf
Return Nil