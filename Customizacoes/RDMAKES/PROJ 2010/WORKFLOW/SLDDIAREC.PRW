#include "rwmake.ch"
#include "topconn.ch"

//Recife
User Function SLDRECDIA()    
	Local oProcess
	Local cQuery  := ""
	Local cQuerySfa  := ""	
	Local cEmail  := ""
	Local cEmailC := ""
	Local cEmailO := ""                      
	Local lFlag   := .F.                     
	Local xCodEmp := "20"  // Empresa 
	Local xCodFil := "02"  // Filial 
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

RPCSetEnv(xCodEmp,xCodFil,"","","","",{"SC5","SA3"})
cQuery := " SELECT ZWF_ATIVO, ZWF_EMAIL, ZWF_EMAILC, ZWF_EMAILO FROM "+RetSQLName("ZWF")
cQuery += " WHERE "
cQuery += " ZWF_USERFC = 'SLDVND' AND "
cQuery += " ZWF_LISFIL LIKE '%"+xFilial("SC5")+"%' AND "
cQuery += " D_E_L_E_T_ <> '*' "

TCQUERY cQuery NEW ALIAS "TMP"
MEMOWRITE("TESTE.SQL",CQUERY)	
dbSelectArea("TMP")
If !TMP->(EOF())
	If TMP->ZWF_ATIVO == "S"
		conout("WF - SLDVND - INICIO DO ENVIO DE EMAIL SALDOS POR VENDEDOR - "+DTOS(DDATABASE-1))
		oProcess := TWFProcess():New( "SLDVND", "SALDOS POR VENDEDOR")
		oProcess:NewTask( "SLDVND", "\WORKFLOW\SLDVND.HTML" )
		oProcess:cSubject := "Relatorio Diario de Saldos por Vendedor - "+DTOC(DDATABASE-1)
		oHTML := oProcess:oHTML	

		oHtml:ValByName( "DATA1", dDataBase - 1)

			cQuerySfa := "SELECT C5_SLDSFA AS SLDSFA, C5_SLDPED AS SLDPED, C5_VEND1 AS VENDEDOR "
			cQuerySfa += "FROM SC5500 "
			cQuerySfa += " WHERE ((C5_EMISSAO = '" + DtoS(DDATABASE-1) + "') AND (D_E_L_E_T_ <> '*') AND "
	        cQuerySfa += " (C5_VEND1 BETWEEN '01.001' AND '01.022')) ORDER BY C5_VEND1"
	
			TCQUERY cQuerySfa NEW ALIAS "TMPSFA"
			MEMOWRITE("SLDSFA.SQL",CQUERYSFA)			
	
			dbSelectArea("TMPSFA")
			dbGoTop()
			TOT := 0
			cArqInd := CriaTrab(NIL, .F.)

			//controla o indice da tabela temporaria
//			IndRegua("TMPSFA", cArqInd, "VENDEDOR+SLDPED",,, "Selecionando Registros...")
//			SetRegua(TMPSFA->(LastRec()))
			TMPSFA->(DbGoTop())
            cod_Vendedor  :=0
			nome_Vendedor :=''
			While TMPSFA->(!EOF())
                codVendedor := TMPSFA->VENDEDOR
	            TOTVEND:=0
	            TOTPED:=0
	            TOTSFA:=0
				SA3->(DbSetOrder(1)) //Filial+Cod.
				SA3->(DbSeek(xFilial("SA3") + TMPSFA->VENDEDOR))
				cod_Vendedor := TMPSFA->VENDEDOR
				nome_Vendedor:= SA3->A3_NOME
				While TMPSFA->VENDEDOR = codVendedor
	    		    if TMPSFA->SLDPED <> 0
	    		       TOTVEND:=TOTVEND+TMPSFA->SLDPED
	    		    else 
 	    		       TOTVEND:=TOTVEND+TMPSFA->SLDSFA		        	    		       
	    		    endIf
		            TMPSFA->(DbSkip())			
		        End    
			    AAdd((oHtml:ValByName( "IT.CODIGO" )), cod_Vendedor )		              
				AAdd((oHtml:ValByName( "IT.VENDEDOR" )), nome_Vendedor )
				AAdd((oHtml:ValByName( "IT.SALDO"  )), TRANSFORM( TOTVEND ,'@E 999,999,999.99' ) )
				TOT:= TOT + TOTVEND 
			End
		    AAdd((oHtml:ValByName( "IT.CODIGO"  )), "<strong>TOTAL</strong>")
		    AAdd((oHtml:ValByName( "IT.VENDEDOR"  )), " ")
		    AAdd((oHtml:ValByName( "IT.SALDO"  )), "<strong>"+TRANSFORM( TOT ,'@E 999,999,999.99')+"</strong>")

		cEmail  := TMP->ZWF_EMAIL
		cEmailC := TMP->ZWF_EMAILC
		cEmailO := TMP->ZWF_EMAILO 
		oProcess:cTo  := LOWER(cEmail)
		oProcess:cCC  := LOWER(cEmailC)
		oProcess:cBCC := LOWER(cEmailO)
		oProcess:Start()
		oProcess:Finish()         
		conout("WF - SLDVND - FIM DO ENVIO DE EMAIL SALDOS POR VENDEDOR - "+dToS(DDATABASE))
		lFlag := .T.
	EndIf
EndIf
If lFlag
	cQuery := " UPDATE " + RetSQLName("ZWF") + " SET ZWF_ULTEXC = '"+DTOS(dDataBase)+"'"
	cQuery += " WHERE ZWF_USERFC = 'SLDVND' AND "
	cQuery += " ZWF_LISFIL LIKE '%"+xFilial("SF2")+"%' AND "
	cQuery += " D_E_L_E_T_ <> '*' "
	TCSQLEXEC(cQuery)	
Endif
TMP->(dbCloseArea())
TMPSFA->(dbCloseArea())
RestArea(aArea)
Return