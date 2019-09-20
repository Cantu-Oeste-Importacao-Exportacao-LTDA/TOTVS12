#include "rwmake.ch"
#include "topconn.ch"
// UTILIZADO PARA ENVIAR WORKFLOW, VERIFICANDO OS CLIENTES QUE ESTÃO BLOQUEADOS POR PRAZO

User Function BLOQCLI()    
	Local oProcess
	Local cQuery  := ""
	Local cQryBloq  := ""	
	Local cEmail  := ""
	Local cEmailC := ""
	Local cEmailO := ""                      
	Local lFlag   := .F.                     
	Local xCodEmp := "50"  // Empresa 
	Local xCodFil := "01"  // Filial 
	Local nDesc   := 0
	Local aArea   := GetArea()  
	Local dtDe    := ""
	Local dtAte   := ""
	Local TOT     := 0  // Totalizador geral
	Local TOTVEND := 0  // Totalizador por vendedor
	Local cAux    := 0 //Armazena o codigo do vendor anterior
	LOCAL count   := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//RPCSetEnv(xCodEmp,xCodFil,"","","","",{"SE1"})
cQuery := " SELECT ZWF_ATIVO, ZWF_EMAIL, ZWF_EMAILC, ZWF_EMAILO FROM "+RetSQLName("ZWF")
cQuery += " WHERE "
cQuery += " ZWF_USERFC = 'BLOQCLI' AND "
cQuery += " ZWF_LISFIL LIKE '%"+xFilial("SE1")+"%' AND "
cQuery += " D_E_L_E_T_ <> '*' "

TCQUERY cQuery NEW ALIAS "TMP"
MEMOWRITE("TESTE.SQL",CQUERY)	
dbSelectArea("TMP")
dbGoTop()
If !TMP->(EOF())
	If TMP->ZWF_ATIVO == "S"
 		conout("WF - BLOQCLI - INICIO DO ENVIO DE EMAIL DE CLIENTES BLOQUEADOS POR PRAZO - "+DTOS(DDATABASE-1))
		oProcess := TWFProcess():New( "BLOQCLI", "RELAÇÃO DE CLIENTES COM ATRASO DE PAGAMENTO")
		oProcess:NewTask( "BLOQCLI", "\WORKFLOW\BLOQCLI.HTML" )
		oProcess:cSubject := "Relatorio de clientes com titulos em atraso ate - "+DTOC(DDATABASE-1)
		oHTML := oProcess:oHTML	

		oHtml:ValByName( "DATA1", dDataBase)

cQryBloq :="SELECT DISTINCT E1_CLIENTE AS COD_CLI, E1_LOJA AS LOJA_CLI, E1_NOMCLI AS NOM_CLI FROM SE1500 WHERE ((E1_FILIAL = '01') AND (SUBSTR(E1_VEND1,1,3)='01.') AND (E1_BAIXA = '') AND ((INT(E1_SALDO) > 0) AND (INT(VARCHAR(E1_VENCREA)) < INT(VARCHAR(SUBSTR(VARCHAR(CURRENT DATE),7,4) CONCAT SUBSTR(VARCHAR(CURRENT DATE),1,2) CONCAT SUBSTR(VARCHAR(CURRENT DATE),4,2)))-5) AND (D_E_L_E_T_ <> '*'))) ORDER BY E1_NOMCLI"
       
//		cQryBloq := "SELECT DISTINCT E1_CLIENTE AS COD_CLI, E1_LOJA AS LOJA_CLI, E1_NOMCLI AS NOM_CLI"
//		cQryBloq += " FROM SE1500 "
//		cQryBloq += " WHERE ((E1_FILIAL = '01') AND (SUBSTR(E1_VEND1,1,3)='01.') AND (E1_BAIXA = '') AND ((INT(E1_SALDO) > 0) AND "
//		cQryBloq += " (INT(VARCHAR(E1_VENCREA)) < INT(VARCHAR(SUBSTR(VARCHAR(CURRENT DATE),7,4) CONCAT SUBSTR(VARCHAR(CURRENT DATE),1,2) "
//		cQryBloq += " CONCAT SUBSTR(VARCHAR(CURRENT DATE),4,2)))-5) AND (D_E_L_E_T_ <> '*'))) ORDER BY E1_NOMCLI"

			TCQUERY cQryBloq NEW ALIAS "TMP1"
			dbSelectArea("TMP1")
			dbGoTop()
			CONOUT(cQryBloq)
            cod_Cliente  :=''
			nome_Cliente :=''
            conout("antes do while" + IIF(EOF(),"OK","NOT OK"))
			While !EOF()
                cod_Cliente:= TMP1->COD_CLI
                loja_Cliente:= TMP1->LOJA_CLI
                nome_Cliente:= TMP1->NOM_CLI
			    AAdd((oHtml:ValByName( "IT.CODIGO_CLIENTE" )), cod_Cliente)		              
			    AAdd((oHtml:ValByName( "IT.LOJA_CLIENTE" )), loja_Cliente)		              
				AAdd((oHtml:ValByName( "IT.NOME_CLIENTE" )), nome_Cliente)
				AAdd((oHtml:ValByName( "IT.ATRASO"  )), loja_cliente ) 
    	     	conout("esta passando pelo while, daqui a pouco vai sair")  			    
  			    dbSelectArea("TMP1")
				dbskip()
			Enddo
			
			dbSelectArea("TMP1")
			TMP1->(dbclosearea())
	                                  
    		conout("WF - BLOQCLI - INICIO DO ENVIO DE EMAIL DE CLIENTES BLOQUEADOS POR PRAZO - "+DTOS(DDATABASE-1))
			cEmail  := TMP->ZWF_EMAIL
			cEmailC := TMP->ZWF_EMAILC
			cEmailO := TMP->ZWF_EMAILO   
	
			oProcess:cTo  := LOWER(cEmail)
			oProcess:cCC  := LOWER(cEmailC)
			oProcess:cBCC := LOWER(cEmailO) 
			oProcess:Start()
			oProcess:Finish()         
	
		conout("WF - BLOQCLI - FIM DO ENVIO DE EMAIL DE CLIENTES BLOQUEADOS POR PRAZO - "+dToS(DDATABASE))
		lFlag := .T.
	EndIf
EndIf

If lFlag
	cQuery := " UPDATE " + RetSQLName("ZWF") + " SET ZWF_ULTEXC = '"+DTOS(dDataBase)+"'"
	cQuery += " WHERE ZWF_USERFC = 'BLOQCLI' AND "
	cQuery += " ZWF_LISFIL LIKE '%"+xFilial("SE1")+"%' AND "
	cQuery += " D_E_L_E_T_ <> '*' "
	TCSQLEXEC(cQuery)	
Endif
TMP->(dbCloseArea())
RestArea(aArea)
Return


User Function TstSched()         

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

RPCSetEnv("50","01")
oProcess := TWFProcess():New( "TSTSCHED", "Teste de Schedule")
oProcess:NewTask( "VerifSched", "\WORKFLOW\BLOQCLI.HTML" )
oProcess:cSubject := "Verificacao do Schedule " + dToC(Date()) + " " + Time()
oProcess:cTo  := "suporte@cantuimportadora.com.br"
oProcess:Start()
oProcess:Finish()
RpcClearEnv()
Return Nil