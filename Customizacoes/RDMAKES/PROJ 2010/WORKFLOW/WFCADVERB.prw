#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³          ºAutor  ³Dioni               º Data ³  13/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     WORKFLOW NOVO CADASTRO DE VERBAS -  chamado 363              º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                               
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Gp40ValPE() //Gp40ValPE()-> ponto de entrada ao cadastrar a verba, chamado atendido pela totvs
// chama função para enviar email 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName()) 

MailComp()
Return .T.

/***************************************************************************************
Workflow para novo cadastro de verba -- Enviar apenas qdo for cadastrada uma nova verba
 ***************************************************************************************/
Static Function MailComp()
Local cQuery   := ""
Local cEmail   := ""                 
Local lFlag    := .F.                     
Local nDesc    := 0
Local aArea    := GetArea()  
Local oHtml    := nil 
Local oProcess
Local lRet := .T.  //entra na funçao Gp40ValPe()

cQuery := " SELECT SRV.RV_COD"
cQuery += " FROM "+RetSqlName("SRV")+" SRV" 
cQuery += " WHERE SRV.R_E_C_N_O_ IN (SELECT MAX(SRV.R_E_C_N_O_)"  
cQuery += " FROM "+RetSqlName("SRV")+" SRV WHERE SRV.D_E_L_E_T_ <> '*') " 

//MemoWrite("c:\sqlCadVerb.txt", cQuery)       

TCQUERY cQuery NEW ALIAS "TMP"

dbSelectArea("TMP")

If !TMP->(EOF())   
       
    //enviar apenas para o setor contábil
		oProcess := TWFProcess():New( "WFCADVERB", "Novo Cadastro de Verbas Efetuado")  
		oProcess:NewTask( "WFCADVERB", "\WORKFLOW\wfcadverb.htm" )
   	oProcess:cSubject := "Novo Cadastro de Verba Efetuado " + DTOC(DDATABASE) + " - Empresa - " + SM0->M0_NOME
   	oHTML := oProcess:oHTML 
 		
    //separando os setores, pq o envio de email tm que ser para o gerente de cada setor
    
    AAdd((oHtml:ValByName( "IT.COD" )), M->RV_COD) //PEGANDO DA MEMÓRIA                            
   
    cEmail  := 'contabil@cantu.com.br' //sera enviado apenas para o contabil, para q o setor faça os procedimentos após o cadastro de verbas.

    oProcess:cTo  := LOWER(cEmail)  	 
    oProcess:Start()
	  oProcess:Finish()
		conout("WF - WFCADVERB - FIM DO ENVIO DE NOVA VERBA CADASTRADA - "+dToS(DDATABASE))
		lFlag := .T.
	     	
EndIf
TMP->(dbclosearea())
Return(lRet) //termina a funçao Gp40ValPE() ponto de entrada