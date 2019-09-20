#INCLUDE "AP5MAIL.CH"

/*
+-------------------------------------------------------------------------------------------------------+
!                             FICHA TÉCNICA DO PROGRAMA                                                 !
+-------------------------------------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                                                   !
+------------------+------------------------------------------------------------------------------------+
!Tipo              ! Ponto de Entrada                                                                   !
+------------------+------------------------------------------------------------------------------------+
!Módulo            ! Call Center                                                                        !
+------------------+------------------------------------------------------------------------------------+
!Nome              ! TK272HTM                                                                    				!
+------------------+------------------------------------------------------------------------------------+
!Descrição         ! Envia copia de e-mail no envio de WF para o responsavel da ação.                   !
!                  ! 			                                                                              !
+------------------+------------------------------------------------------------------------------------+
!Autor             ! Carlos Eduardo                                                                     !
+------------------+------------------------------------------------------------------------------------+
!Data de Criação   ! 31/05/12                                                                           !
+------------------+------------------------------------------------------------------------------------+
!   ATUALIZACÕES                                                                                        !
+-------------------------------------------------------------------------------------------------------+
!   Descrição detalhada da atualização      			         !Nome do         ! Analista     !Data da     !
!                                                          !Solicitante     ! Respons.     !Atualiz.    !
+----------------------------------------------------------+----------------+--------------+------------+
! Alteração para inicializar corretamente as variaveis de  !                !Carlos        !11/06/2012  !
! encerramento do atendimento                              !                !Eduardo       !            !
+----------------------------------------------------------+----------------+--------------+------------+
*/

User Function TK272HTM 

Local aCabecalho	:= {}  
Local aItens 			:= {}  
Local aSx3SUC			:= Tk273Sx3("SUC")
Local cMensagem   := ' '
Local nOpc
Local cTipSta    := "Planejada"	// "Planejada"


Local nPAssunto := aPosicoes[1][2]												// Assunto
Local nPDescAss := aPosicoes[2][2]												// Descricao do Assunto
Local nPProd 		:= aPosicoes[3][2]											  // Produto
Local nPDescPro := aPosicoes[4][2]												// Descricao do produto
Local nPOcorren	:= aPosicoes[5][2]												// Ocorrencia	
Local nPDescOco	:= aPosicoes[6][2]                        // Descricao da Ocorrencia
Local nPCodOpe 	:= aPosicoes[7][2]												// Codigo do Operador
Local nPDescOpe	:= aPosicoes[8][2]												// Descricao do Operador		
Local nPData		:= aPosicoes[9][2]												// Data			
Local nPAcao   	:= aPosicoes[10][2]												// Acao
Local nPDescAca	:= aPosicoes[11][2]												// Descricao da Acao
Local nPObs			:= aPosicoes[12][2]												// Observacao
Local nPStatus  := aPosicoes[13][2]												// Status
Local nPDtExec  := aPosicoes[14][2]												// Data de Execucao
Local nPObsExec := aPosicoes[15][2]												// Observacao da Execucao
Local aStatus 	:= IIF(nPStatus > 0,TkSX3Box("UD_STATUS"),{})					// Array com o conteudo do campo UD_STATUS
Private cAssunto := " "    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If INCLUI
	nOpc := 3
Else
	nOpc := 4
Endif


//Preenche o tipo do status 
If (Val(M->UC_STATUS) == 2)
	cTipSta := "Pendente" //"Pendente"  
ElseIf (Val(M->UC_STATUS) == 3)
	cTipSta := "Encerrada" //"Encerrada"
Endif  
	


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega dados do cadastro do contato para colocar no e-mail - quando existe envio de e-mail³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cDescCnt	:= SU5->U5_CONTAT
cCidade		:= SU5->U5_MUN
cEst			:= SU5->U5_EST
cTelRes 	:= SU5->U5_FCOM1
cTelCom1	:= SU5->U5_FONE
cEnd			:= SU5->U5_END
cDDD			:= SU5->U5_DDD
cBairro 	:= SU5->U5_BAIRRO


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta o ARRAY  com o cabecalho do atendimento de Telemarketing ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aCabecalho,M->UC_CODIGO )																													// Atendimento 					-01
Aadd(aCabecalho,M->UC_CHAVE + "-" + M->UC_DESCCHA)																			// Entidade             -02
Aadd(aCabecalho,cDescCnt)     																													// Contato              -03
Aadd(aCabecalho,cCidade + "-" + cEst)																										// Cidade - Estado	 		-04
Aadd(aCabecalho,cEnd)																																		// Endereco			 				-05
Aadd(aCabecalho,Transform(cDDD,"@R 999-") + Transform(cTelRes,"@R 9999-9999") + "/" +;
				Transform(cDDD,"@R 999-") + Transform(cTelCom1,"@R 9999-9999") )								// Telefone Resid/Comer -06
Aadd(aCabecalho,M->UC_DATA)	          																									// Data da ligacao      -07
Aadd(aCabecalho,cTimeIni)																																// Hora inicial         -08
Aadd(aCabecalho,M->UC_OPERADO + "-" + M->UC_DESCOPE)																		// Codigo - Operador    -09
Aadd(aCabecalho,M->UC_DESCTIP)																													// Tipo de comunicacao  -10
Aadd(aCabecalho,cTipSta)		           																									// Status               -11
Aadd(aCabecalho,M->UC_MIDIA + "-" + M->UC_DESCMID) 																			// Midia                -12
Aadd(aCabecalho,MSMM(SUC->UC_CODOBS,80)) 																								// Observacao TMK       -13
Aadd(aCabecalho,cBairro)																																// Bairro								-14
If Val(M->UC_STATUS) == 3//Encerrada
	Aadd(aCabecalho,SUN->UN_ENCERR + " - " + SUN->UN_DESC)	// Motivo do encerramento 		-15
	Aadd(aCabecalho,MSMM(SUC->UC_CODMOT))							 																								// Descricao do encerramento	-16
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta o ARRAY  com os itens do atendimento do Telemarketing 	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nLinhas := 1 TO len(aCols)

	If !(aCols[nLinhas][Len(aHeader)+1])	// Se a linha nao estiver apagada.
		If !Empty(aCols[nLinhas][nPCodOpe])
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Tratamento do Box do campo UD_STATUS, pois o inicilizador padrao³
		//³nao esta sendo executado (TKCONFIG()).	    				   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
               If Val(aCols[nLinhas][nPStatus])= 0 .OR. Val(aCols[nLinhas][nPStatus])>Len(aStatus)
                                    

		   		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		   		//³Trata antes de Atribuir³
		   		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

                  If Len(aStatus) > 0
                  	cStatus := aStatus[1]
                  Endif	
               Else   
                  cStatus := aStatus[Val(aCols[nLinhas][nPStatus])]
               Endif   
		   Aadd(aItens,{ aCols[nLinhas][nPAssunto]		,;				// 01- Assunto 
		   				 aCols[nLinhas][nPDescAss]		,;				// 02- Descricao do Assunto
						 aCols[nLinhas][nPProd]   		,;				// 03- Produto
						 aCols[nLinhas][nPDescPro]		,;				// 04- Descricao do Produto
						 aCols[nLinhas][nPOcorren]		,;				// 05- Ocorrencia
						 aCols[nLinhas][nPDescOco]		,;				// 06- Descricao da Ocorrencia
						 aCols[nLinhas][nPAcao]   		,;				// 07- Acao
						 aCols[nLinhas][nPDescAca]		,;				// 08- Descricao da Acao
						 aCols[nLinhas][nPCodOpe] 		,;				// 09- Codigo do Operador
						 aCols[nLinhas][nPDescOpe]		,;				// 10- Descricao do Operador	
						 DTOC(aCols[nLinhas][nPData])	,;				// 11- Data
						 aCols[nLinhas][nPObs]	   		,;  			// 12- Observacao
						 cStatus						,;				// 13- Status
						 DTOC(aCols[nLinhas][nPDtExec])	,;				// 14- Data de Execucao
						 aCols[nLinhas][nPObsExec]	})					// 15- Memo da Execucao	
						
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Monta o ARRAY para o numero de usuarios que vao receber³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cEmail 	 := "carlos.eduardo@smsti.com.br" //UsrRetMail(aCols[nLinhas][nPCodOpe])+";" //+=
			cAssunto := "Atendimento" + " " + M->UC_CODIGO + " " +"realizado pelo CALL CENTER" //"Atendimento"###"realizado pelo CALL CENTER"
			
		
		Endif      
	Endif
	
Next nLinhas

  
  

/*
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ExpC1 - Mensagem para envio no e-mail                       º±±
±±º          ³ExpA2 - Elementos do cabecalho do atendimento               º±±
±±º          ³ExpA3 - Elementos dos itens do atendimento                  º±±
±±º          ³ExpN4 - Tipo da operacao                                    º±±
±±º          ³ExpA5 - Campos do SUC do dicionario de dados                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß 



*/

// Cria o corpo da mensagem com cabeçalho e itens.
Tk272Body(	@cMensagem, aCabecalho, aItens, nOpc, aSx3SUC		)


// Envia cópia de e-mail para os e-mails do parametro MV_X_MAILC
enviaEmails(GetMv("MV_X_MAILC"),cMensagem, cAssunto)
	
	

Return " "





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³TK272Body ºAutor  ³Vendas Clientes     º Data ³  25/05/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Monta o corpo do e-mail em HTML para a rotina de            º±±
±±º          ³Telemarketing                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³TELEMARKETING                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ExpC1 - Mensagem para envio no e-mail                       º±±
±±º          ³ExpA2 - Elementos do cabecalho do atendimento               º±±
±±º          ³ExpA3 - Elementos dos itens do atendimento                  º±±
±±º          ³ExpN4 - Tipo da operacao                                    º±±
±±º          ³ExpA5 - Campos do SUC do dicionario de dados                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Tk272Body(	cMensagem	,aCabecalho	,aItens		,nOpc		,;
							aSx3SUC		)

Local nCont  		:= 0			// Contador
Local cAtend		:= ""			// Descricao do campo "UC_CODIGO"
Local cCliente		:= ""			// Descricao do campo "UC_CHAVE"
Local cContato		:= ""			// Descricao do campo "UC_CODCONT"
Local cData			:= ""			// Descricao do campo "UC_DATA"
Local cHoraIni		:= ""			// Descricao do campo "UC_HRPEND"
Local cOperador		:= ""			// Descricao do campo "UC_OPERADO"
Local cComunica 	:= ""			// Descricao do campo "UC_TIPO"
Local cSTatusSUC	:= ""			// Descricao do campo "UC_STATUS"
Local cMotEnc		:= "Motivo do encerramento"		// "Motivo do encerramento"
Local cDesEnc		:= "Descrição do encerramento"		// "Descrição do encerramento"
Local cMidia        := ""			// Descricao do campo "UC_MIDIA"
Local cObsSUC		:= ""			// Observacao do atendimento
Local cItem			:= ""			// Descricao do campo "UD_ITEM"
Local cAssunto		:= ""			// Descricao do campo "UD_ASSUNTO"
Local cProduto		:= ""			// Descricao do campo "UD_PRODUTO"
Local cOcorren		:= ""			// Descricao do campo "UD_OCORREN"
Local cAcao			:= ""			// Descricao do campo "UD_SOLUCAO"
Local cResp			:= ""			// Descricao do campo "UD_OPERADO"
Local cDataAcao	    := ""			// Descricao do campo "UD_DATA"
Local cObsSUD       := ""			// Descricao do campo "UD_OBS"
Local cStatusSUD    := ""			// Descricao do campo "UD_STATUS"
Local cDataExec	    := ""			// Descricao do campo "UD_DTEXEC"
Local cCompl	    := ""			// Descricao do campo "UD_OBSEXEC"
                       
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Pesquisa no SX3 qual a descricao dos campos, caso o usuario tenha alterado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPos := Ascan(aSx3SUC,{|x| x[4] $ "UC_CODIGO"})
If (nPos > 0)
	cAtend	:= aSx3SUC[nPos][4]
Else
	cAtend	:= "Atendimento"
Endif
	
nPos := Ascan(aSx3SUC,{|x| x[1] $ "UC_CHAVE"})
If (nPos > 0)
	cCliente := aSx3SUC[nPos][4]
Else	
	cCliente := "Cliente"
Endif	

nPos := Ascan(aSx3SUC,{|x| x[1] $ "UC_CODCONT"})
If (nPos > 0)
	cContato := aSx3SUC[nPos][4]
Else
	cContato :="Contato"
Endif

nPos := Ascan(aSx3SUC,{|x| x[1] $ "UC_DATA"})
If (nPos > 0)
	cData := aSx3SUC[nPos][4]
Else
	cData := "Data"
Endif

nPos := Ascan(aSx3SUC,{|x| x[1] $ "UC_HRPEND"})
If (nPos > 0)
	cHoraIni := aSx3SUC[nPos][4]
Else
	cHoraIni := "Hora Inicial"   
Endif

nPos := Ascan(aSx3SUC,{|x| x[1] $ "UC_OPERADO"})
If (nPos > 0)
	cOperador := aSx3SUC[nPos][4]
Else
	cOperador := "Operador"   
Endif

	
nPos := Ascan(aSx3SUC,{|x| x[1] $ "UC_TIPO"})
If (nPos > 0)
	cComunica := aSx3SUC[nPos][4]
Else
	cComunica := "Comunicação"  
Endif

nPos := Ascan(aSx3SUC,{|x| x[1] $ "UC_STATUS"})
If (nPos > 0)
	cSTatusSUC	:= aSx3SUC[nPos][4]
Else
	cSTatusSUC	:= "Status"
Endif

nPos := Ascan(aSx3SUC,{|x| x[1] $ "UC_MIDIA"})
If (nPos > 0)
	cMidia := aSx3SUC[nPos][4]
Else
	cMidia := "Mídia"         
Endif
	
nPos := Ascan(aSx3SUC,{|x| x[1] $ "UC_OBS"})
If (nPos > 0)
	cObsSUC	:= aSx3SUC[nPos][4]
Else
	cObsSUC	:= "Observação do Atendimento"
Endif

DbSelectArea("SX3")
DbSetOrder(2)

If DbSeek("UD_ITEM")
	cItem		:= Alltrim(X3Titulo())       
Endif

If DbSeek("UD_ASSUNTO")
	cAssunto	:= Alltrim(X3Titulo())       
Endif

If DbSeek("UD_PRODUTO")
	cProduto	:= Alltrim(X3Titulo())       
Endif
	
If DbSeek("UD_OCORREN")
	cOcorren	:= Alltrim(X3Titulo())       
Endif

If DbSeek("UD_SOLUCAO")
	cAcao := Alltrim(X3Titulo())       
Endif

If DbSeek("UD_OPERADO")
	cResp		:= Alltrim(X3Titulo())       	
Endif
	
If DbSeek("UD_DATA")
	cDataAcao	:= Alltrim(X3Titulo())       
Endif
	
If DbSeek("UD_OBS")
	cObsSUD     := Alltrim(X3Titulo())       
Endif
	
If DbSeek("UD_STATUS")
	cStatusSUD  := Alltrim(X3Titulo())       
Endif
	
If DbSeek("UD_DTEXEC")
	cDataExec	:= Alltrim(X3Titulo())       
Endif
	
If DbSeek("UD_OBSEXEC")
	cCompl := Alltrim(X3Titulo())     
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Prepara o cabecalho do atendimento - SUC³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cMensagem += "<html>"  
cMensagem += "<body>"  

cMensagem += '<p align="center"><b><font color="#000080" face="Arial" size="4">'   // Alinhamento e tamanho do fonte titulo
If nOpc == 3 // Inclusao
	cMensagem += "Inclusão de Atendimento - Call Center - Telemarketing" // "Inclusão de Atendimento - Call Center - Telemarketing"
ElseIf nOpc == 4 // Alteracao
	cMensagem += "Alteração no Atendimento - Call Center - Telemarketing" // "Alteração no Atendimento - Call Center - Telemarketing"
Endif	
cMensagem += '</font></b></p>'

cMensagem += '<hr>'                	// Linha horizontal do corpo do email

cMensagem += '<p><font face="Arial"><b>'
cMensagem +=  "Dados do Atendimento" // Dados do Atendimento
cMensagem += '</b></font></p>'

cMensagem += '<table border="1" width="100%">'

cMensagem += '<tr>'
cMensagem += '<td width="33%"><b><font size="2">&nbsp;<font color="#0000FF" face="Verdana">' 	//Cor azul
cMensagem += cAtend //Atendimento
cMensagem += '</font>&nbsp;</font></b></td>'
cMensagem += '<td width="67%"><font face="Verdana" size="2">'
cMensagem += aCabecalho[1]
cMensagem += '</font></td>'
cMensagem += '</tr>'

cMensagem += '<tr>'
cMensagem += '<td width="33%"><b><font size="2">&nbsp;<font color="#0000FF" face="Verdana">'
cMensagem += IIF(!lProspect,"Cliente","Prospect")//Cliente , Prospect 
cMensagem += '</font>&nbsp;</font></b></td>'
cMensagem += '<td width="67%"><font face="Verdana" size="2">'
cMensagem += aCabecalho[2]
cMensagem += '</font></td>'
cMensagem += '</tr>'

cMensagem += '<tr>'
cMensagem += '<td width="33%"><b><font size="2">&nbsp;<font color="#FF0000" face="Verdana">'
cMensagem += cContato //Contato
cMensagem += '</font>&nbsp;</font></b></td>'
cMensagem += '<td width="67%"><font color ="#FF0000" face="Verdana" size="2">'
cMensagem += IIF(!Empty(aCabecalho[3]),aCabecalho[3],'&nbsp;') //Se estiver vazio cria o 'espaco' onde estaria o dado.
cMensagem += '</font></td>'					
cMensagem += '</tr>'

cMensagem += '<tr>'
cMensagem += '<td width="33%"><b><font size="2">&nbsp;<font color="#FF0000" face="Verdana">'
cMensagem += "Cidade"
cMensagem += '</font>&nbsp;</font></b></td>'
cMensagem += '<td width="67%"><font color ="#FF0000" face="Verdana" size="2">'
cMensagem += IIF(!Empty(aCabecalho[4]),aCabecalho[4],'&nbsp;') //Se estiver vazio cria o 'espaco' onde estaria o dado.
cMensagem += '</font></td>'
cMensagem += '</tr>'

cMensagem += '<tr>'
cMensagem += '<td width="33%"><b><font size="2">&nbsp;<font color="#FF0000" face="Verdana">'
cMensagem += "Endereço"
cMensagem += '</font>&nbsp;</font></b></td>'
cMensagem += '<td width="67%"><font color ="#FF0000" face="Verdana" size="2">'
cMensagem += IIF(!Empty(aCabecalho[5]),aCabecalho[5],'&nbsp;') //Se estiver vazio cria o 'espaco' onde estaria o dado.
cMensagem += '</font></td>'
cMensagem += '</tr>'

cMensagem += '<tr>'
cMensagem += '<td width="33%"><b><font size="2">&nbsp;<font color="#FF0000" face="Verdana">'
cMensagem += "Bairro"
cMensagem += '</font>&nbsp;</font></b></td>'
cMensagem += '<td width="67%"><font color ="#FF0000" face="Verdana" size="2">'
cMensagem += IIF(!Empty(aCabecalho[14]),aCabecalho[14],'&nbsp;') //Se estiver vazio cria o 'espaco' onde estaria o dado.
cMensagem += '</font></td>'
cMensagem += '</tr>'

cMensagem += '<tr>'
cMensagem += '<td width="33%"><b><font size="2">&nbsp;<font color="#FF0000" face="Verdana">'
cMensagem += "Telefones"
cMensagem += '</font>&nbsp;</font></b></td>'
cMensagem += '<td width="67%"><font color ="#FF0000" face="Verdana" size="2">'
cMensagem += IIF(!Empty(aCabecalho[6]),aCabecalho[6],'&nbsp;') //Se estiver vazio cria o 'espaco' onde estaria o dado.
cMensagem += '</font></td>'
cMensagem += '</tr>'

cMensagem += '<tr>'
cMensagem += '<td width="33%"><b><font size="2">&nbsp;<font color="#0000FF" face="Verdana">'
cMensagem += cData //Data
cMensagem += '</font>&nbsp;</font></b></td>'
cMensagem += '<td width="67%"><font face="Verdana" size="2">'
cMensagem += IIF(!Empty(aCabecalho[7]),DTOC(aCabecalho[7]),'&nbsp;')//Se estiver vazio cria o 'espaco' onde estaria o dado.
cMensagem += '</font></td>'
cMensagem += '</tr>'

cMensagem += '<tr>'
cMensagem += '<td width="33%"><b><font size="2">&nbsp;<font color="#0000FF" face="Verdana">'
cMensagem += cHoraIni //Hora Inicial
cMensagem += '</font>&nbsp;</font></b></td>'
cMensagem += '<td width="67%"><font face="Verdana" size="2">'
cMensagem += IIF(!Empty(aCabecalho[8]),aCabecalho[8],'&nbsp;')//Se estiver vazio cria o 'espaco' onde estaria o dado.
cMensagem += '</font></td>'
cMensagem += '</tr>'

cMensagem += '<tr>'
cMensagem += '<td width="33%"><b><font size="2">&nbsp;<font color="#0000FF" face="Verdana">'
cMensagem += cOperador //Operador
cMensagem += '</font>&nbsp;</font></b></td>'
cMensagem += '<td width="67%"><font face="Verdana" size="2">'
cMensagem += IIF(!Empty(aCabecalho[9]),aCabecalho[9],'&nbsp;')//Se estiver vazio cria o 'espaco' onde estaria o dado.
cMensagem += '</font></td>'
cMensagem += '</tr>'

cMensagem += '<tr>'
cMensagem += '<td width="33%"><b><font size="2">&nbsp;<font color="#0000FF" face="Verdana">'
cMensagem += cComunica //Comunicacao
cMensagem += '</font>&nbsp;</font></b></td>'
cMensagem += '<td width="67%"><font face="Verdana" size="2">'
cMensagem += IIF(!Empty(aCabecalho[10]),aCabecalho[10],'&nbsp;')//Se estiver vazio cria o 'espaco' onde estaria o dado.
cMensagem += '</font></td>'
cMensagem += '</tr>'

cMensagem += '<tr>'
cMensagem += '<td width="33%"><b><font size="2">&nbsp;<font color="#0000FF" face="Verdana">'
cMensagem += cStatusSUC //Status
cMensagem += '</font>&nbsp;</font></b></td>'
cMensagem += '<td width="67%"><font color ="#FF0000" face="Verdana" size="2">'
cMensagem += IIF(!Empty(aCabecalho[11]),aCabecalho[11],'&nbsp;')//Se estiver vazio cria o 'espaco' onde estaria o dado.
cMensagem += '</font></td>'
cMensagem += '</tr>'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se o Status do chamado for "Encerrada", adiciona o   ³
//³Motivo do encerramento e a Descrição do encerramento.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Val(M->UC_STATUS) == 3//Encerrada
	cMensagem += '<tr>'
	cMensagem += '<td width="33%"><b><font size="2">&nbsp;<font color="#0000FF" face="Verdana">'
	cMensagem += cMotEnc //Motivo do encerramento
	cMensagem += '</font>&nbsp;</font></b></td>'
	cMensagem += '<td width="67%"><font color ="#FF0000" face="Verdana" size="2">'
	cMensagem += IIF(!Empty(aCabecalho[15]),aCabecalho[15],'&nbsp;')//Se estiver vazio cria o 'espaco' onde estaria o dado.
	cMensagem += '</font></td>'
	cMensagem += '</tr>'

	cMensagem += '<tr>'
	cMensagem += '<td width="33%"><b><font size="2">&nbsp;<font color="#0000FF" face="Verdana">'
	cMensagem += cDesEnc //Descrição do encerramento
	cMensagem += '</font>&nbsp;</font></b></td>'
	cMensagem += '<td width="67%"><font color ="#FF0000" face="Verdana" size="2">'
	cMensagem += IIF(!Empty(aCabecalho[16]),aCabecalho[16],'&nbsp;')//Se estiver vazio cria o 'espaco' onde estaria o dado.
	cMensagem += '</font></td>'
	cMensagem += '</tr>'
EndIf

cMensagem += '<tr>'
cMensagem += '<td width="33%"><b><font size="2">&nbsp;<font color="#0000FF" face="Verdana">'
cMensagem += cMidia //Midia
cMensagem += '</font>&nbsp;</font></b></td>'
cMensagem += '<td width="67%"><font face="Verdana" size="2">'
cMensagem += IIF(!Empty(aCabecalho[12]),aCabecalho[12],'&nbsp;')//Se estiver vazio cria o 'espaco' onde estaria o dado.
cMensagem += '</font></td>'
cMensagem += '</tr>'

cMensagem += '<tr>'
cMensagem += '<td width="33%"><b><font size="2">&nbsp;<font color="#0000FF" face="Verdana">'
cMensagem += cObsSUC //Observacao do atendimento
cMensagem += '</font>&nbsp;</font></b></td>'
cMensagem += '<td width="67%"><font face="Verdana" size="2">'
cMensagem += IIF(!Empty(aCabecalho[13]),aCabecalho[13],'&nbsp;')//Se estiver vazio cria o 'espaco' onde estaria o dado.
cMensagem += '</font></td>'
cMensagem += '</tr>'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Prepara o corpo dos itens do atendimento - SUD   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cMensagem +='<tr>'
cMensagem += '<td width="50%">&nbsp;</td>'
cMensagem += '<td width="50%">&nbsp;</td>'
cMensagem += '</tr>'

cMensagem += '</table>'
cMensagem += '<table border="1" width="100%">'
cMensagem += '<tr>'

cMensagem += '<td><b><font color="#0000FF" face="Verdana" size=2>'
cMensagem += cItem//"Item"
cMensagem += '</font></b></td>'

cMensagem += '<td><b><font color="#0000FF" face="Verdana" size="2">'
cMensagem += cAssunto//"Assunto"
cMensagem += '</font></b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>'

cMensagem += '<td><b><font color="#0000FF" face="Verdana" size="2">'
cMensagem += cProduto //"Produto"
cMensagem += '</font></b></td>'

cMensagem += '<td><b><font color="#0000FF" face="Verdana" size="2">'
cMensagem += cOcorren //"Ocorrencia"
cMensagem += '</font></b></td>'

cMensagem += '<td><b><font color="#0000FF" face="Verdana" size="2">'
cMensagem += cAcao //"Acao"
cMensagem += '</font></b>&nbsp;&nbsp;&nbsp;</td>'

cMensagem += '<td><b><font color="#0000FF" face="Verdana" size="2">'
cMensagem += cResp //"Responsavel"
cMensagem += '&nbsp;</font></b></td>'

cMensagem += '<td><b><font color="#0000FF" face="Verdana" size="2">'
cMensagem += cDataAcao //"Data da Acao"
cMensagem += '&nbsp;&nbsp;</font></b></td>'

cMensagem += '<td><b><font color="#0000FF" face="Verdana" size="2">'
cMensagem += cObsSUD //"Observacao"
cMensagem += '&nbsp;&nbsp;</font></b></td>'

cMensagem += '<td><b><font color="#0000FF" face="Verdana" size="2">'
cMensagem += cStatusSUD
cMensagem += '&nbsp;&nbsp;</font></b></td>'

cMensagem += '<td><b><font color="#0000FF" face="Verdana" size="2">'
cMensagem += cDataExec
cMensagem += '&nbsp;&nbsp;</font></b></td>'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Prepara a impressao do conteudo dos itens - SUD  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nCont := 1 To Len(aItens)
	cMensagem += '<tr>'
	
	cMensagem += '<th rowspan=2><font face="Verdana" size=2>'
	cMensagem += StrZero(nCont,3)
	cMensagem += '</font></th>'
	
	cMensagem += '<td><font face="Verdana" size="2">'
	cMensagem += IIF(!Empty(aItens[nCont][2]),AllTrim(aItens[nCont][2]),'&nbsp;') // Assunto - somente descricao
	cMensagem += '</font></td>'
	
	cMensagem += '<td><font face="Verdana" size="2">'
	cMensagem += IIF(!Empty(aItens[nCont][3]),AllTrim(aItens[nCont][3]) + " - " + AllTrim(aItens[nCont][4]),'&nbsp;') //Produto
	cMensagem += '</font></td>'
	
	cMensagem += '<td><font face="Verdana" size="2">'
	cMensagem += IIF(!Empty(aItens[nCont][6]),AllTrim(aItens[nCont][6]),'&nbsp;') // Ocorrencia - somente descricao
	cMensagem += '</font></td>'
	
	cMensagem += '<td><font face="Verdana" size="2">'
	cMensagem += IIF(!Empty(aItens[nCont][8]),AllTrim(aItens[nCont][8]),'&nbsp;') // Acao - Somente descricao
	cMensagem += '</font></td>'
	
	cMensagem += '<td><font face="Verdana" size="2">'
	cMensagem += IIF(!Empty(aItens[nCont][10]),AllTrim(aItens[nCont][10]),'&nbsp;') //Responsavel - somente descricao
	cMensagem += '</font></td>'
	
	cMensagem += '<td><font face="Verdana" size="2">'
	cMensagem += IIF(!Empty(aItens[nCont][11]),AllTrim(aItens[nCont][11]),'&nbsp;')  //Data da acao
	cMensagem +='</font></td>'
	
	cMensagem += '<td><font face="Verdana" size="2">'
	cMensagem += IIF(!Empty(aItens[nCont][12]),AllTrim(aItens[nCont][12]),'&nbsp;')  //Observacao
	cMensagem += '</font></td>'

	cMensagem += '<td><font color ="#FF0000" face="Verdana" size="2">'
	cMensagem += IIF(!Empty(aItens[nCont][13]),AllTrim(aItens[nCont][13]),'&nbsp;')  //Status
	cMensagem += '</font></td>'

	cMensagem += '<td><font face="Verdana" size="2">'
	cMensagem += IIF(!Empty(aItens[nCont][14]),AllTrim(aItens[nCont][14]),'&nbsp;')  //Data
	cMensagem += '</font></td>'

	cMensagem += '</tr>'
	
	cMensagem += '<tr><th colspan=9><font face="Verdana" color="#0000FF" size=1>'
	cMensagem += IIF(!Empty(aItens[nCont][15]),cCompl + ": ","")
	cMensagem += '</font><font face="Verdana" size=1>'
	cMensagem += IIF(!Empty(aItens[nCont][15]),AllTrim(aItens[nCont][15]),'&nbsp;') //Memo
	cMensagem += '</font></th></tr>'
	
Next nCont

cMensagem += '</table>'
cMensagem += '<p>&nbsp;</p>'
cMensagem += '</body>'
cMensagem += '</html>'

Return .T.



/*---------------------------------------------------------------------------+
!                       FICHA TECNICA DO PROGRAMA                            !
+----------------------------------------------------------------------------+
!                          DADOS DO PROGRAMA                                 !
+------------------+---------------------------------------------------------+
!Autor             ! Carlos Eduardo                                          !
+------------------+---------------------------------------------------------+
!Descricao         ! Envia email de cópia para os atendimentos.              !
+------------------+---------------------------------------------------------+
!Nome              ! enviaEmails                                             !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 25/05/2011                                              !
+------------------+--------------------------------------------------------*/ 

Static Function enviaEmails(cMail, cBody, cAssunto)
Local _cAccount		:= SuperGetMV("MV_RELACNT") // Conta do remetente
Local _cPassword	:= SuperGetMV("MV_RELPSW")	// Senha do remetente
Local _cServer		:= SuperGetMV("MV_RELSERV")
Local cFrom				:= UsrRetMail(__cUserID)
Local _cEnvia			:= cMail
Local _cSubject     := cAssunto
Local _cError  
Private _cMesg 		:= cBody
Private cFiles		:= ' '

// Conecta com o Servidor SMTP
 
CONNECT SMTP SERVER _cServer ;
ACCOUNT _cAccount PASSWORD _cPassword ;
RESULT _lOk
 
If _lOk 
	
	If !MailAuth(_cAccount,_cPassword)
		GET MAIL ERROR _cError
//       	MsgStop("Erro de autenticação","Verifique a conta e a senha para envio")
  	Else

		Send Mail FROM _cAccount TO _cEnvia SUBJECT _cSubject BODY _cMesg ATTACHMENT cFiles RESULT _lOk2

  	EndIf
  	
	DISCONNECT SMTP SERVER
 
Else
 
	GET MAIL ERROR _cError
 
Endif
        
