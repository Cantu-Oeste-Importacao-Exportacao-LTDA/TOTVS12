#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"   


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CadSemana  �Autor  �Gustavo Lattmann    � Data �  15/09/16  ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro de semanas para controle de produ��o dos avi�rios.���
���          �															  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Cantu                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function LOTEGRAN()     

Private cCadastro := "Cadastro Lotes | Granja" //Variavel padr�o para o t�tulo do mBrowse
Private aRotina	:= MENUDEF() //Vari�vel padr�o para as op��es do mBrowse
    
//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

dbSelectArea("Z76")
Z76->(dbsetOrder(1))  // FILIAL + COD
Z76->(dbGoTop())

//Os parametros s�o padr�es do tamanho da tela que abriu
mBrowse(6,1,22,75,"Z76") //Compenente para gerar a tela sobre a tabela Z76

Return       

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MENUDEF     �Autor  �Gustavo          � Data � 16/02/2015   ���
�������������������������������������������������������������������������͹��
���Desc.     � Op��es que ir�o compor o menu na tela.                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Analise BI                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MENUDEF()
Local aOpcoes := {}

AADD(aOpcoes, {"Pesquisar"		, "AxPesqui"   		, 0, 1})
AADD(aOpcoes, {"Visualizar"		, "AxVisual"		, 0, 2})
AADD(aOpcoes, {"Incluir"		, "U_IncLote()"		, 0, 3})
AADD(aOpcoes, {"Alterar"		, "U_AltLote()"		, 0, 4})
AADD(aOpcoes, {"Excluir"		, "U_DelLote()"  	, 0, 5})

Return aOpcoes     


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �INCLOTE  �Autor  �Gustavo Lattmann     � Data �  28/12/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function IncLote()
    
	nOpca := AxInclui("Z76",Recno(),3,,,,"U_IncLoteOk()")
	If nOpca == 1
		MsAguarde({|| fGeraSemana()},"Aguarde","Gerando Semanas...")
	EndIf

Return   


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LOTEGRAN  �Autor  �Microsiga           � Data �  12/28/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function IncLoteOk() 
	
	Local lRet := .T.  
	Local cSql := "" 
	Local cAliasTMP := GetNextAlias()
    
	//-- Valida para n�o cadastrar lote duplicado
	dbSelectArea("Z76")
	Z76->(dbGoTop())
	Z76->(dbSetOrder(1)) //FILIAL + LOTE
	If Z76->(dbSeek(xFilial("Z76")+M->Z76_LOTE))
		ShowHelpDlg("Aten��o!",{"Lote j� cadastrado."},5,{"Informe outro c�digo de lote, ou altere o existente."},5)	
		lRet := .F.
	EndIf             
	
	
	//-- Valida para n�o incluir lote para aviario j� ocupado        
	cSql += "SELECT COUNT(*) AS QUANT "
	cSql += "  FROM " + RetSqlName("Z80") 
	cSql += " WHERE D_E_L_E_T_ = ' ' "
	cSql += " AND Z80_AVIARI = '" + M->Z76_AVIARI + "'"
	cSql += " AND Z80_DIAINI >= '" + DTOS(M->Z76_DIAINI) + "'"
	//cSql += " AND Z80_DIAFIM >= '" + DTOS(M->Z76_DIAINI) + "'"
	
	TCQUERY cSql NEW ALIAS "Z80TMP"

	
	If Z80TMP->QUANT > 0
		ShowHelpDlg("Aten��o!",{"J� existem lote cadastrado para esse per�odo."},5,{"Corrija a data inicial informada."},5)	
		lRet := .F.	
	EndIf     
	
	Z80TMP->(dbCloseArea())
 
Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ALTLOTE  �Autor  �Gustavo Lattmann     � Data �  28/12/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Altera os lotes e atualiza a tabela de semanas.            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function AltLote()

 	nOpca := AxAltera("Z76",Recno(),4)  
 	If nOpca == 1
		MsAguarde({|| fGeraSemana()},"Aguarde","Atualizando Semanas...")
	EndIf

Return
        

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DelLote  �Autor  �Gustavo Lattmann     � Data �  19/09/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o que realiza a exclus�o dos lotes e das semanas      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function DelLote()

 	nOpca := AxDeleta("Z76",Recno(),5) 

	//--Se a exclus�o foi confirmada deve excluir as semanas do lote	
	If nOpca == 2
		dbSelectArea("Z80")
		Z80->(dbSetOrder(1))
		Z80->(dbGoTop())
		Z80->(dbSeek(xFilial("Z80")+Z76->Z76_LOTE))	
		While Z80->Z80_FILIAL == Z76->Z76_FILIAL .And. Z80->Z80_LOTE == Z76->Z76_LOTE
			RecLock("Z80",.F.)
				Z80->(dbDelete())	
				Z80->(MSUNLOCK())
			Z80->(dbSkip())	
		EndDo	
	EndIf

Return        



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VldDiaSem  �Autor  �Microsiga           � Data �  04/11/16  ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para validar o dia da semana que inicia o lote.     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function VldDiaSem()

Local lRet := .T.

//-- A semana deve iniciar no domingo e terminar no s�bado
If DOW(M->Z76_DIAINI) != 1    
	ShowHelpDlg("Aten��o!",{"Data informado n�o � um domingo. O lote deve sempre iniciar em um domingo."},5,{"Selecione uma data que seja um domingo."},5)	
	lRet := .F.
EndIf

Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GERASEMANA  �Autor  �Microsiga           � Data �  01/11/16 ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o respons�vel por fazer calculo das semanas de cada   ���
���          � lote, para facilitar a analise dos dados no BI.            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function fGeraSemana()  

Local dDiaIni := Z76->Z76_DIAINI 
Local nSemana := 1
//Local dDiaFim  
Local aDados := {}

//-- Realiza o calculo das semanas para facilitar apura��o no BI
While dDiaIni <= Z76->Z76_DIAFIM
 	For nX := 1 To 7
		Aadd(aDados,{dDiaIni,nSemana,Z76->Z76_LOTE,Z76->Z76_AVIARI}) 
		dDiaIni := DaySum(dDiaIni,1)
	Next nX
	nSemana += 1    
EndDo

//-- Caso seja altera��o exclui primeiro e depois inclui
dbSelectArea("Z80")
Z80->(dbGoTop())
Z80->(dbSetOrder(1)) // FILIAL + LOTE
If Z80->(dbSeek(xFilial("Z80") + Z76->Z76_LOTE))
	While Z80->Z80_FILIAL == Z76->Z76_FILIAL .And. Z80->Z80_LOTE == Z76->Z76_LOTE
		RecLock("Z80",.F.)
			Z80->(dbDelete())	
			Z80->(MSUNLOCK())
		Z80->(dbSkip())	
	EndDo
EndIf

//--Faz a grava��o na tabela
If Len(aDados) > 0     
	BEGIN TRANSACTION
		For nI := 1 to Len(aDados)
			RecLock("Z80", .T.)
				Z80->Z80_FILIAL	:= xFilial("Z80")  
				Z80->Z80_DIAINI := aDados[nI][1]
				//Z80->Z80_DIAFIM := aDados[nI][2]       
				Z80->Z80_SEMANA := cValToChar(aDados[nI][2])
				Z80->Z80_LOTE	:= aDados[nI][3]
				Z80->Z80_AVIARI := aDados[nI][4]
			Z80->(MSUNLOCK())
		Next nI	         
	END TRANSACTION
EndIf

Return