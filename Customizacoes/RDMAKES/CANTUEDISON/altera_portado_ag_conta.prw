#include "rwmake.ch"
#include "topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Alt venc depositos   �Autor �Edison G. barbieri�  26/08/19  ���
�������������������������������������������������������������������������͹��
���Desc.     �  Fun��o que faz altera��o dos dados de pagamento depositos ���
��                 conforme a necessidade do usu�rio.	        		  ���
���          � assim evita de fazer manualmente no site do banco          ���
�������������������������������������������������������������������������͹��
���Uso       � Financeiro Oeste                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ALPOAGCT()
	Private oAltpor
	Private cPerg     := "ALPOAGCT"

	//�����������������������������������������������������
	//�Chama fun��o para monitor uso de fontes customizados�
	//�����������������������������������������������������
	U_USORWMAKE(ProcName(),FunName())

	//�����������������������������������������������������
	//�Chama abertura de perguntas SX1                    �
	//�����������������������������������������������������

	Pergunte(cPerg,.F.)

	@ 200,001 TO 380,380 DIALOG oAltpor TITLE OemToAnsi("Altera portador agencia e conta")
	@ 002,010 TO 080,190
	@ 010,018 Say " Este programa faz a altera��o de dados fincanceiros "
	@ 018,018 Say "para a emiss�o de BORDERO."
	@ 60,090 BMPBUTTON TYPE 01 ACTION U_ALTFINRC()
	@ 60,120 BMPBUTTON TYPE 02 ACTION Close(oAltpor)
	@ 60,150 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

    //Pergunta que recebe o conteudo
	MV_PAR11	  := ''
	MV_PAR12	  := ''
	MV_PAR13	  := ''
	
	Activate Dialog oAltpor Centered

return

User Function ALTFINRC()
    Local cSql 		:= ""
	Local cAlias 	:= GetNextAlias()
    Local aArea     := GetArea()

	Conout("Empresa atual: " + cEmpAnt)
	ConOut("Inicializando o processo")
	ConOut("BUSCANDO T�TULOS PARA ALTERA��O...")

	cSql := "SELECT E1.E1_EMISSAO, E1.E1_NUM, E1.E1_PARCELA, E1.E1_VENCREA, E1.E1_CLIENTE, E1.E1_LOJA, E1.E1_VALOR , E1.R_E_C_N_O_ AS RNO"
	cSql += " FROM " + RetSqlName("SE1")+ " E1"
	cSql += " WHERE  E1.E1_FILIAL >= '" + %Exp:mv_par01% 		  + "' AND E1.E1_FILIAL	 <= '" + %Exp:mv_par02%  + "'"
    cSql += " AND E1.E1_NUM     	>= '" + %Exp:mv_par03%  	  + "' AND E1.E1_NUM     <= '" + %Exp:mv_par04%  + "'"
    cSql += " AND E1.E1_PARCELA   	>= '" + %Exp:mv_par05%  	  + "' AND E1.E1_PARCELA <= '" + %Exp:mv_par06%  + "'"
	cSql += " AND E1.E1_CLIENTE 	>= '" + %Exp:mv_par07%  	  + "' AND E1.E1_CLIENTE <= '" + %Exp:mv_par08%  + "'"
	cSql += " AND E1.E1_LOJA 		>= '" + %Exp:mv_par09%  	  + "' AND E1.E1_LOJA 	 <= '" + %Exp:mv_par10%  + "'"
	cSql += " AND E1.E1_EMISSAO 	>= '" + %Exp:DtoS(mv_par11)%  + "' AND E1.E1_EMISSAO <= '" + %Exp:DtoS(mv_par12)%  + "'"
	cSql += " AND E1.E1_VENCREA  	>= '" + %Exp:DtoS(mv_par13)%  + "' AND E1.E1_VENCREA <= '" + %Exp:DtoS(mv_par14)%  + "'"
	cSql += " AND E1.E1_PORTADO = ' '  AND E1.E1_AGEDEP = ' ' AND E1.E1_CONTA = ' ' "
	cSql += " AND E1.E1_SALDO > 0  AND E1.d_e_l_e_t_ = ' '"
	

	TCQUERY cSql NEW ALIAS (cAlias)
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	nTotal := (cAlias)->(RecCount())

	ProcRegua(nTotal)
	nCount := 0

	if (cAlias)->(Eof())
		MsgAlert('N�o existe rela��o para os par�metros informados, verifique!')
		return
	endif

	While (cAlias)->(!Eof())
		nCount++
		SE1->(dbGoTo((cAlias)->RNO))

		RecLock("SE1", .F.)

		SE1->E1_PORTADO := mv_par15
		SE1->E1_AGEDEP  := mv_par16
		SE1->E1_CONTA   := mv_par17
		

		SE1->(MsUnlock())

		IncProc("Processados " + Str(nCount, 3, 0) + " registros")

		(cAlias)->(dbSkip())
	EndDo

	MsgInfo("Atualizado dados : "+ Str(nCount, 3, 0) + " registros com sucesso no contas a receber.")

	(cAlias)->(dbCloseArea())
	
	Close(oAltpor)
RestArea(aArea)	
Return