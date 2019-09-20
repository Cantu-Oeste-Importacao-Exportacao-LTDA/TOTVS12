#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT010INC ºAutor  ³Rafael Parma         º Data ³  12/09/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PE executado após a inclusão do produto, responsável por    º±±
±±º          ³gravar flag de integração Import SYS.                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³CANTU                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-------------------------*
User Function MT010INC() 
*-------------------------*
Local aAreaTMP := GetArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	Begin Transaction 
		If RecLock("SB1",.F.)
			//--Tratamento ImportSYS	
			//SB1->B1_X_ESYS := "S" 
				
			//--Tratamento B2B Vertis
			If SB1->B1_X_EB2B == "S"
				SB1->B1_X_AB2B := "S"
				MsAguarde( {|| U_RJB2BDA1(SB1->B1_COD) }, "Aualizando tabelas de preço... Aguarde!")	
			EndIf			
			SB1->(MsUnLock())
		EndIf             
	End Transaction 
	
	MailComp()
	
	RestArea(aAreaTMP)

Return

                                          

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJB2BDA1 ºAutor  ³Rafael Parma         º Data ³  26/05/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualização de flag de sobre itens das tabelas de preço da  º±±
±±º          ³integração B2B Vertis.                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³CANTU                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*---------------------------------------------------------------------------*
User Function RJB2BDA1(cCODPRD)                                              
*---------------------------------------------------------------------------*
Local cAliasTMP	:= GetNextAlias()
Local cAliasZ60	:= GetNextAlias()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())


	//--Centros de distribuição	
	BeginSql Alias cAliasZ60
		SELECT		Z60.Z60_CODEM, Z60.Z60_CODFL, Z60.Z60_CODCD
		FROM 		%Table:Z60% Z60
		WHERE 		Z60.Z60_ATIVO = %Exp:'S'%
		AND			Z60.%NotDel%
		ORDER BY	Z60.Z60_CODEM, Z60.Z60_CODFL
	EndSql
	
	dbSelectArea(cAliasZ60)
	(cAliasZ60)->(dbGoTop())
	While !(cAliasZ60)->(EOF())

      	 If (cAliasZ60)->Z60_CODEM == "31"
			cTABDA0 := "% DA0300 %"
		    cCODFIL := "% '"+Space(TAMSX3("DA0_FILIAL")[1])+"' %"
		 Else 
			cTABDA0 := "% DA0"+(cAliasZ60)->Z60_CODEM+"0 %"
		    cCODFIL := "% '"+(cAliasZ60)->Z60_CODFL+"' %"
		 EndIf

		BeginSql Alias cAliasTMP
			SELECT		DA0.DA0_FILIAL, DA0.DA0_CODTAB
			FROM 		%Exp:cTABDA0% DA0
			WHERE		DA0.DA0_FILIAL	= %Exp:cCODFIL%
			AND 		DA0.DA0_X_EB2B	= %Exp:'S'%
			AND			DA0.%NotDel%
			ORDER BY	DA0.DA0_FILIAL, DA0.DA0_CODTAB
		EndSql
		
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbGoTop())
		While !(cAliasTMP)->(EOF())
			cQuery := " UPDATE "+RetSQLName("DA1")+" SET DA1_X_AB2B = 'S' "
			cQuery += " WHERE DA1_FILIAL = '"+(cAliasTMP)->DA0_FILIAL+"' AND DA1_CODTAB = '"+(cAliasTMP)->DA0_CODTAB+"' AND DA1_CODPRO = '"+cCODPRD+"' "
			TCSQLEXEC(cQuery)
			(cAliasTMP)->(dbSkip())
		Enddo
		(cAliasTMP)->(dbCloseArea())
		
		(cAliasZ60)->(dbSkip())	
	Enddo
	(cAliasZ60)->(dbCloseArea())    


Return

/*
 Dioni               º Data ³  22/12/11
 WORKFLOW NOVO CADASTRO DE PRODUTOS -  chamado 251      
*/
//MailComp()


/******************************************************************************************
Workflow para novo cadastro de produto -- Enviar apenas qdo for cadastrada um novo produto
 *****************************************************************************************/
Static Function MailComp()
Local cQuery   := ""
Local cEmail   := ""                 
//Local lFlag    := .F.                     
//Local nDesc    := 0
Local aArea    := GetArea()  
Local oHtml    := nil 
Local oProcess

cQuery := " SELECT SB1.B1_COD, SB1.B1_DESC"
cQuery += " FROM "+RetSqlName("SB1")+" SB1" 
cQuery += " WHERE SB1.R_E_C_N_O_ IN (SELECT MAX(SB1.R_E_C_N_O_)"  
cQuery += " FROM "+RetSqlName("SB1")+" SB1 WHERE SB1.D_E_L_E_T_ <> '*') "   

//MemoWrite("c:\sqlCadProd.txt", cQuery)       

TCQUERY cQuery NEW ALIAS "TMP"

dbSelectArea("TMP")

If !TMP->(EOF())   
       
    //enviar apenas para o setor contábil
	oProcess := TWFProcess():New( "WFCADPROD", "Novo Cadastro de Produto Efetuado")  
	oProcess:NewTask( "WFCADPROD", "\workflow\wfcadprod.htm" )
   	oProcess:cSubject := "Novo Cadastro de Produto Efetuado " + DTOC(DDATABASE) + " - Empresa - " + SM0->M0_NOME
   	oHTML := oProcess:oHTML 
 		  
    oHtml:ValByName("CODDESC", TMP->B1_COD + ' - ' + TMP->B1_DESC) //'M->' PEGANDO DA MEMÓRIA                            
   
    //Enviados para os e-mails que a Valéria Solicitou
   	// cEmail := 'fiscal2@cantu.com.br, gabriela.couto@advanceconsult.com.br, contabil@cantu.com.br, fiscal.vto@cantu.com.br, gabriela.couto@cantupneus.com.br, aline@advanceconsult.com.br, joel.goncalves@cantupneus.com.br, estoque.cadastro@cantu.com.br'
   	oProcess:cTo  := GetMv('MV_X_PROD') //parametro criado no cfg -> atualizaçao-> cadastro ->paramentros	 
   	oProcess:Start()
	oProcess:Finish()
	Conout("WF - WFCADPROD - FIM DO ENVIO DE NOVO PRODUTO CADASTRADO - "+dToS(DDATABASE))
//	lFlag := .T.
	     	
EndIf
TMP->(dbclosearea())

Return