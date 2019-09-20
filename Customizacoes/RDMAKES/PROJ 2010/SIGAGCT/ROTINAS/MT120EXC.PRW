#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT120EXC   ºAutor  ³Rafael Parma       º Data ³  01/06/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada executado no estorno da medição, após a ex-º±±
±±º          ³clusão do pedido de compras.                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RJU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*--------------------------*
User Function MT120EXC()
*--------------------------*
Local aAreaTMP  := GetArea()

Private cPRFTIT := "GC "
Private cNATTIT := SuperGetMV("MV_CNNAT")
Private cTIPTIT := "PR "          
Private lMsErroAuto := .F.    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
	
	dbSelectArea("CN9")
	dbSetOrder(1)
	dbGoTop()
	If dbSeek( xFilial("CN9") + SC7->C7_CONTRA )

		dbSelectArea("Z33")
		dbSetOrder(2)	//--Z33_FILIAL+Z33_CONTRA+Z33_MEDICA+Z33_ITEMED
		dbGoTop()    
		If dbSeek( xFilial("Z33") + SC7->(C7_CONTRA+C7_MEDICAO+C7_ITEMED) )
	        While !Z33->(EOF()) .AND. Z33->(Z33_FILIAL+Z33_CONTRA+Z33_MEDICA+Z33_ITEMED) == xFilial("Z33")+SC7->(C7_CONTRA+C7_MEDICAO+C7_ITEMED)
				aTitulo := {	{"E2_FILIAL"	, xFilial("SE2")			,	Nil},;      
								{"E2_PREFIXO"	, cPRFTIT					,	Nil},;      
				  				{"E2_NUM"		, Z33->Z33_TITULO			,	Nil},;      
								{"E2_PARCELA"	, Z33->Z33_PARCEL			,	Nil},;      
								{"E2_NATUREZ"	, cNATTIT					,	Nil},;      
								{"E2_TIPO"		, cTIPTIT	    			,	Nil},;      
								{"E2_FORNECE"	, SC7->C7_FORNECE			,	Nil},;      
								{"E2_LOJA"		, SC7->C7_LOJA  			,	Nil},;
								{"E2_EMISSAO"	, CN9->CN9_DTINIC 			,	Nil},;
								{"E2_VENCTO"	, Z33->Z33_COMPET  			,	Nil},;									
								{"E2_VENCREA"	, Z33->Z33_COMPET 	 		,	Nil},;
								{"E2_ORIGEM"	, "CNTA100"					,	Nil},;
								{"E2_MDCONTR"	, SC7->C7_CONTRA			,	Nil},;																																
								{"E2_VALOR"		, Z33->Z33_VALOR  			,	Nil} }      
			
				MSExecAuto({|x,y,z| FINA050(x,y,z)},aTitulo,,3)
				
				If lMsErroAuto
					DisarmTransaction()
					Mostraerro()
				EndIf
			
				Z33->(dbSkip())
			Enddo
			
			//--Atualização das variáveis de controle.
			cQuery := " UPDATE "+RetSQLName("Z33")+" SET Z33_MEDICA = '"+Space(TAMSX3("Z33_MEDICA")[1])+"', Z33_ITEMED = '"+Space(TAMSX3("Z33_ITEMED")[1])+"' "
			cQuery += " WHERE Z33_FILIAL||Z33_CONTRA||Z33_MEDICA||Z33_ITEMED = '"+xFilial("Z33")+SC7->(C7_CONTRA+C7_MEDICAO+C7_ITEMED)+"' "
			TCSQLEXEC(cQuery)	
						
		EndIf			  	
  	EndIf				

	RestArea(aAreaTMP)

Return