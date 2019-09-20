#INCLUDE "RWMAKE.ch"
#INCLUDE "TOPCONN.ch"
#Include "PROTHEUS.Ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT235G1   ºAutor  ³Flavio Dias         º Data ³  19/01/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Eliminar títulos provisórios do financeiro ao eliminar      º±±
±±º	         ³resíduo.                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT235G1()
Local cNum := SC7->C7_NUM      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//Função para eliminar títulos provisórios 
If ALLTRIM(SuperGetMV("MV_X_APRGB",,"N")) == "S"			
	MsAguarde( {|| fDropPROV() }, "Eliminando provisórios... Aguarde!")	
EndIf	 

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fDropPROV  ºAutor  ³Rafael Parma       º Data ³  01/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Elimina títulos provisórios relacionados ao pedido utilizadoº±±
±±º          ³no documento de entrada.                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*----------------------------*
Static Function fDropPROV()
*----------------------------*
Local aArea := GetArea()
Local lResiduo := .F.
Local lPergunt := .F.
Private lMsErroAuto := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Elimina títulos provisórios relacionados ao pedido           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
SE2->(dbSetOrder(01))
dbSelectArea("Z11")
dbSetOrder(1)
dbGoTop()
If dbSeek ( xFilial("Z11") + SC7->C7_NUM )
	While !Z11->(EOF()) .and. Z11->Z11_FILIAL + Z11->Z11_PEDIDO == xFilial("Z11") + SC7->C7_NUM
	  lMsErroAuto := .F. 
		cNUMTITULO := Z11->Z11_PEDIDO + Space(TAMSX3("E2_NUM")[1]-TAMSX3("Z11_PEDIDO")[1])
	  
	  lFoundSe2 := SE2->(dbSeek(Z11->Z11_FILIAL+Z11->Z11_PREFIX+cNUMTITULO+Z11->Z11_PARCEL+Z11->Z11_TIPO+Z11->Z11_FORNEC+Z11->Z11_LOJA))
	    	
		if (lFoundSe2)
			aTitulo := {	{"E2_FILIAL"	, Z11->Z11_FILIAL		,	Nil},;      
							{"E2_PREFIXO"	, Z11->Z11_PREFIX		,	Nil},;      
			  			{"E2_NUM"		  , cNUMTITULO			,	Nil},;      
							{"E2_PARCELA"	, Z11->Z11_PARCEL		,	Nil},;      
							{"E2_TIPO"		, Z11->Z11_TIPO    		,	Nil},;      
							{"E2_FORNECE"	, Z11->Z11_FORNEC		,	Nil},;      
							{"E2_LOJA"		, Z11->Z11_LOJA  		,	Nil},;
							{"E2_VALOR"		, Z11->Z11_VALOR  		,	Nil} }
		
			MSExecAuto({|x,y,z| FINA050(x,y,z)},aTitulo,,5)
			If lMsErroAuto
				DisarmTransaction()
				Mostraerro()
				Exit
			EndIf
		EndIf
				    	
		dbSelectArea("Z11")
		Z11->(dbSkip())
		
	Enddo		    	
EndIf

RestArea(aArea)

Return