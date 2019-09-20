#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �          �Autor  �Dioni               � Data �  13/12/11   ���
�������������������������������������������������������������������������͹��
���Desc.     WORKFLOW NOVO CADASTRO DE VERBAS -  chamado 363              ���
�����������������������������������������������������������������������������                               
�����������������������������������������������������������������������������
*/

User Function Gp40ValPE() //Gp40ValPE()-> ponto de entrada ao cadastrar a verba, chamado atendido pela totvs
// chama fun��o para enviar email 

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
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
Local lRet := .T.  //entra na fun�ao Gp40ValPe()

cQuery := " SELECT SRV.RV_COD"
cQuery += " FROM "+RetSqlName("SRV")+" SRV" 
cQuery += " WHERE SRV.R_E_C_N_O_ IN (SELECT MAX(SRV.R_E_C_N_O_)"  
cQuery += " FROM "+RetSqlName("SRV")+" SRV WHERE SRV.D_E_L_E_T_ <> '*') " 

//MemoWrite("c:\sqlCadVerb.txt", cQuery)       

TCQUERY cQuery NEW ALIAS "TMP"

dbSelectArea("TMP")

If !TMP->(EOF())   
       
    //enviar apenas para o setor cont�bil
		oProcess := TWFProcess():New( "WFCADVERB", "Novo Cadastro de Verbas Efetuado")  
		oProcess:NewTask( "WFCADVERB", "\WORKFLOW\wfcadverb.htm" )
   	oProcess:cSubject := "Novo Cadastro de Verba Efetuado " + DTOC(DDATABASE) + " - Empresa - " + SM0->M0_NOME
   	oHTML := oProcess:oHTML 
 		
    //separando os setores, pq o envio de email tm que ser para o gerente de cada setor
    
    AAdd((oHtml:ValByName( "IT.COD" )), M->RV_COD) //PEGANDO DA MEM�RIA                            
   
    cEmail  := 'contabil@cantu.com.br' //sera enviado apenas para o contabil, para q o setor fa�a os procedimentos ap�s o cadastro de verbas.

    oProcess:cTo  := LOWER(cEmail)  	 
    oProcess:Start()
	  oProcess:Finish()
		conout("WF - WFCADVERB - FIM DO ENVIO DE NOVA VERBA CADASTRADA - "+dToS(DDATABASE))
		lFlag := .T.
	     	
EndIf
TMP->(dbclosearea())
Return(lRet) //termina a fun�ao Gp40ValPE() ponto de entrada