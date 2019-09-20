#include "rwmake.ch"  
#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OM320TOK    ºAutor  ³Rafael Parma      º Data ³  03/11/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada acionado após a confirmação do retorno de  º±±
±±º          ³cargas.                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/       

*---------------------------*
User Function OM320TOK()     
*---------------------------*
Local cEmail := ""
Local lRet   := .T.
Local aArea  := GetArea()
Local lAtivo := Iif(ALLTRIM(SuperGetMV("MV_X_AWCFC",,"N"))=="S",.T.,.F.)
Local oProcess    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o parâmetro está ativo para conferência de carga ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   
	If lAtivo       
	
		dbSelectArea("Z19")	//ITENS DE CONFERENCIA X CARGAS 
		dbSetOrder(1)	//Z19_FILIAL+Z19_CARGA+Z19_SEQ 
		dbGoTop()
		If ! dbSeek ( xFilial("Z19") + DAK->DAK_COD )
        
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Não foi realizada a conferência de itens fiscais p/ carga.   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		    
			conout("WF - OM320TOK - INICIO DO ENVIO DE EMAIL - CONFERENCIA DE ITENS FISCAIS - CARGA OMS")
			
			// Busca o email da configuracao
			cEmail  := ALLTRIM(Posicione("ZWF", 01, xFilial("ZWF") + "OM320TOK", "ZWF_EMAIL"))
		    If ALLTRIM(cEmail) == ""
		    	Return
		    EndIf
		    
		
			oProcess := TWFProcess():New( "OM320TOK", "CONFERENCIA DE ITENS FISCAIS - CARGA OMS")
			oProcess:NewTask( "OM320TOK", "\workflow\OM320TOK.html")
			
			oProcess:cSubject :=  "WF - CONFERENCIA DE ITENS FISCAIS - CARGA OMS" 
									
			oHTML := oProcess:oHTML
			                                             
			oHtml:ValByName("CEMPRESA"	, ALLTRIM(UPPER(SM0->M0_NOME)) + " - " + ALLTRIM(UPPER(SM0->M0_FILIAL))	)
			oHtml:ValByName("DDATABASE"	, dtoc(DDATABASE)			)
			oHtml:ValByName("CUSUARIO"	, ALLTRIM(UPPER(CUSERNAME))	)
			oHtml:ValByName("CHORARET"	, SubSTR(time(),1,5)		)
			oHtml:ValByName("CNUMCARGA"	, DAK->DAK_COD				)
		
			oProcess:cTo  := LOWER(cEmail) 
			
			ConOut("WF - OM320TOK - E-MAIL ENVIADO PARA: " + oProcess:cTo)
		
			// inicia o processo de envio de workflow
			oProcess:Start()	
			
			// finaliza o processo
			oProcess:Finish()
			
			conout("WF - OM320TOK - FIM DO ENVIO DE EMAIL - CONFERENCIA DE ITENS FISCAIS - CARGA OMS")
		    
		EndIf
	EndIf
    
	RestArea(aArea)

Return (lRet)
