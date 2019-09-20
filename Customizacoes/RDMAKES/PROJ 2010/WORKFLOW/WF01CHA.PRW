#include "rwmake.ch"
#include "topconn.ch"
/*/
+----------+----------+-------+-----------------------+------+----------+
|Programa  |WF01CHA   | Autor | Maycon Lazarotto      | Data | 22/08/06 |
+----------+----------+-------+-----------------------+------+----------+
|EMPRESA   : CANTU - CHAPECO                                            |
|Descricao : Relatorio (MENSAL) enviado por email, com o credito        |
|           (devedor ou credor, de cada vendedor informado na clausula  |
|																		|
|cQuery += dtDe+"' AND '"+dtAte+"' AND D_E_L_E_T_ <> '*' AND C5_VEND1   |
|          BETWEEN 'XX.XXX' AND 'XX.XXX' GROUP BY C5_VEND1"             |
|                                                                       |
|            Esse relatorio e enviado por email, para os emails         |
|            cadastrados na tabela ZWF. Isso e separado por empresa     |
|            pelo fato de que os codigos de vendedores diferem de empre-|
|            sa para empresa.                                           |
+----------+------------------------------------------------------------+
|Uso       | SIGAFIN - Especifico Cantu                                 |
+----------+------------------------------------------------------------+
/*/
User Function WF01CHA()    
Local oProcess
Local cQuery  := ""
Local cEmail  := ""
Local cEmailC := ""
Local cEmailO := ""                      
Local lFlag   := .F.                     
Local xCodEmp := "10"  // Empresa 
Local xCodFil := "01"  // Filial 
Local nDesc   := 0
Local aArea   := GetArea()  
Local dtDe    := ""
Local dtAte   := ""
Local TOT     := 0  // Totalizador geral
Local TOTVEND := 0  // Totalizador por vendedor
Local cAux    := 0 //Armazena o codigo do vendor anterior 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

RPCSetEnv(xCodEmp,xCodFil,"","","","",{"SC5","SA3"})
cQuery := " SELECT ZWF_ATIVO, ZWF_EMAIL, ZWF_EMAILC, ZWF_EMAILO FROM "+RetSQLName("ZWF")
cQuery += " WHERE "
cQuery += " ZWF_USERFC = 'WF01CHA' AND "
cQuery += " ZWF_LISFIL LIKE '%"+xFilial("SC5")+"%' AND "
cQuery += " D_E_L_E_T_ <> '*' "

TCQUERY cQuery NEW ALIAS "TMP"
MEMOWRITE("TESTE.SQL",CQUERY)	
dbSelectArea("TMP")
If !TMP->(EOF())
	If TMP->ZWF_ATIVO == "S"
		dtAte:= DtoS(DDATABASE-1)
		dtDe := Left(DtoS(DDATABASE-1),6)+"01" //pega o ano e o mes + 01 (para iniciar no primeiro dia do mes)
		
		conout("WF - SLDVND - INICIO DO ENVIO DE EMAIL SALDOS POR VENDEDOR MENSAL - "+DTOS(DDATABASE-1))
		oProcess := TWFProcess():New( "WF01CHA", "SALDOS POR VENDEDOR MENSAL")
		oProcess:NewTask( "WF01CHA", "\WORKFLOW\SLDVNDM.HTML" )
		oProcess:cSubject := "Rel Mensal de Saldos por Vendedor ate "+DtOc(DDATABASE-1)
		oHTML := oProcess:oHTML	
		oHtml:ValByName("DATA1", DtOc(DDATABASE-1))
		cQuery := "SELECT SUM(C5_SLDSFA) AS SLDSFA, SUM(C5_SLDPED) AS SLDPED, C5_VEND1 AS VENDEDOR FROM SC5100 WHERE C5_EMISSAO BETWEEN '"
		cQuery += dtDe+"' AND '"+dtAte+"' AND D_E_L_E_T_ <> '*' AND C5_VEND1 BETWEEN '01.001' AND '01.015' GROUP BY C5_VEND1"
		TCQUERY cQuery NEW ALIAS "TMPSLD"
		MEMOWRITE("SLDVND.SQL",CQUERY)			
		dbSelectArea("TMPSLD")
		dbGoTop()
		TOT := 0
		While TMPSLD->(!Eof())
			SA3->(DbSetOrder(1)) //Filial+Cod.
			SA3->(DbSeek(xFilial("SA3") + TMPSLD->VENDEDOR))
	
	    	AAdd( (oHtml:ValByName( "IT.CODIGO" )), TMPSLD->VENDEDOR )		              
		    AAdd( (oHtml:ValByName( "IT.VENDEDOR" )), SA3->A3_NOME )
	    	TOTVEND := TMPSLD->SLDSFA + TMPSLD->SLDPED
			AAdd( (oHtml:ValByName( "IT.SALDO"  )), TRANSFORM( TOTVEND ,'@E 99,999.99' ) )
			TOT += TOTVEND 
            TMPSLD->(DbSkip())			
		    conout("PASSOU PELO WHILE")
		End
	    AAdd((oHtml:ValByName( "IT.CODIGO"  )), "<strong>TOTAL</strong>")
	    AAdd((oHtml:ValByName( "IT.VENDEDOR"  )), " ")
	    AAdd((oHtml:ValByName( "IT.SALDO"  )), "<strong>"+TRANSFORM( TOT ,'@E 999,999.99')+"</strong>")

		cEmail  := TMP->ZWF_EMAIL
		cEmailC := TMP->ZWF_EMAILC
		cEmailO := TMP->ZWF_EMAILO              
		oProcess:cTo  := LOWER(cEmail)
		oProcess:cCC  := LOWER(cEmailC)
		oProcess:cBCC := LOWER(cEmailO)
		oProcess:Start()
		oProcess:Finish()         
		conout("WF - WF01CHA - FIM DO ENVIO DE EMAIL SALDOS POR VENDEDOR MENSAL- "+dToS(DDATABASE))
		lFlag := .T.
	EndIf
EndIf

If lFlag
	cQuery := " UPDATE " + RetSQLName("ZWF") + " SET ZWF_ULTEXC = '"+DTOS(dDataBase)+"'"
    cQuery += " WHERE ZWF_USERFC = 'WF01CHA' AND "
//	cQuery += " ZWF_LISFIL LIKE '%"+xFilial("SF2")+"%' AND "
	cQuery += " D_E_L_E_T_ <> '*' "
	TCSQLEXEC(cQuery)	
Endif
TMP->(dbCloseArea())
TMPSLD->(dbCloseArea())
RestArea(aArea)
Return