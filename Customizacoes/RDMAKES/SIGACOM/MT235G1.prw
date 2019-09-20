#INCLUDE "RWMAKE.ch"
#INCLUDE "TOPCONN.ch"
#Include "PROTHEUS.Ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT235G1   �Autor  �Flavio Dias         � Data �  19/01/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Eliminar t�tulos provis�rios do financeiro ao eliminar      ���
���	         �res�duo.                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT235G1()
Local cNum := SC7->C7_NUM      

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

//Fun��o para eliminar t�tulos provis�rios 
If ALLTRIM(SuperGetMV("MV_X_APRGB",,"N")) == "S"			
	MsAguarde( {|| fDropPROV() }, "Eliminando provis�rios... Aguarde!")	
EndIf	 

Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fDropPROV  �Autor  �Rafael Parma       � Data �  01/12/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Elimina t�tulos provis�rios relacionados ao pedido utilizado���
���          �no documento de entrada.                                    ���
�������������������������������������������������������������������������͹��
���Uso       �RJU                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*----------------------------*
Static Function fDropPROV()
*----------------------------*
Local aArea := GetArea()
Local lResiduo := .F.
Local lPergunt := .F.
Private lMsErroAuto := .F.

//��������������������������������������������������������������Ŀ
//� Elimina t�tulos provis�rios relacionados ao pedido           �
//����������������������������������������������������������������	
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