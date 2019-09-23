#include "rwmake.ch"
#include "topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Alt venc depositos   �Autor �Edison G. barbieri�  01/07/19  ���
�������������������������������������������������������������������������͹��
���Desc.     �  Fun��o que faz altera��o data de vencimento para depositos���
��                 conforme a necessidade do usu�rio.	        		  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Financeiro Oeste                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ALVENPAG()
	Private oAltvenc
	Private cPerg     := "ALTVEN01"

	//�����������������������������������������������������
	//�Chama fun��o para monitor uso de fontes customizados�
	//�����������������������������������������������������
	U_USORWMAKE(ProcName(),FunName())

	//�����������������������������������������������������
	//�Chama abertura de perguntas SX1                    �
	//�����������������������������������������������������

	Pergunte(cPerg,.F.)

	@ 200,001 TO 380,380 DIALOG oAltvenc TITLE OemToAnsi("Altera data de Vencimento Pag fornecedores")
	@ 002,010 TO 080,190
	@ 010,018 Say " Este programa faz a altera��o dos vencimentos para "
	@ 018,018 Say " pagamento de FORNECEDORES."
	@ 60,090 BMPBUTTON TYPE 01 ACTION U_ALTCTO()
	@ 60,120 BMPBUTTON TYPE 02 ACTION Close(oAltvenc)
	@ 60,150 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

    //Pergunta que recebe o conteudo do novo vencimento
	MV_PAR11	  := ''
	
	Activate Dialog oAltvenc Centered

return

User Function ALTCTO()
    Local cSql 		:= ""
	Local cAlias 	:= GetNextAlias()
    Local aArea     := GetArea()

	Conout("Empresa atual: " + cEmpAnt)
	ConOut("Inicializando o processo")
	ConOut("BUSCANDO T�TULOS PARA ALTERA��O...")

	cSql := "SELECT E2.E2_EMISSAO, E2.E2_NUM, E2.E2_PARCELA, E2.E2_VENCTO, E2.E2_FORNECE, E2.E2_LOJA, E2.E2_NOMFOR, E2.E2_VALOR , E2.R_E_C_N_O_ AS RNO"
	cSql += " FROM " + RetSqlName("SE2")+ " E2"
	cSql += " WHERE  E2.E2_FILIAL >= '" + %Exp:mv_par01% 		  + "' AND E2.E2_FILIAL	 <= '" + %Exp:mv_par02%  + "'"
	cSql += " AND E2.E2_FORNECE 	>= '" + %Exp:mv_par03%  	  + "' AND E2.E2_FORNECE <= '" + %Exp:mv_par04%  + "'"
	cSql += " AND E2.E2_LOJA 		>= '" + %Exp:mv_par05%  	  + "' AND E2.E2_LOJA 	 <= '" + %Exp:mv_par06%  + "'"
	cSql += " AND E2.E2_EMISSAO 	>= '" + %Exp:DtoS(mv_par07)%  + "' AND E2.E2_EMISSAO <= '" + %Exp:DtoS(mv_par08)%  + "'"
	cSql += " AND E2.E2_VENCTO   	>= '" + %Exp:DtoS(mv_par09)%  + "' AND E2.E2_VENCTO  <= '" + %Exp:DtoS(mv_par10)%  + "'"
	cSql += " AND E2.E2_FORMPAG = 'DE' AND E2.E2_SALDO > 0  AND E2.d_e_l_e_t_ = ' '"

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
		SE2->(dbGoTo((cAlias)->RNO))

		RecLock("SE2", .F.)

		SE2->E2_VENCTO := mv_par11
		SE2->E2_VENCREA := mv_par11

		SE2->(MsUnlock())

		IncProc("Processados " + Str(nCount, 3, 0) + " registros")

		(cAlias)->(dbSkip())
	EndDo

	MsgInfo("Atualizado data de vencimento : "+ Str(nCount, 3, 0) + " registros com sucesso no contas a pagar.")

	(cAlias)->(dbCloseArea())
	
	Close(oAltvenc)
RestArea(aArea)	
Return