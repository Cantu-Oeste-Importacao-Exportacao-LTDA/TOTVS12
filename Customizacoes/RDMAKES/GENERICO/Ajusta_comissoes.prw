#include "rwmake.ch"
#include "TopConn.ch"

// Adriano Novachaelley - 31-01-2011
// Atualiza comissoes nas tabelas SC6 e SD2 com base na comissão cadastrada no SB1->B1_COMISS

User function AjComiss()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If cEmpAnt <> '50'
	MsgInfo("Empresa não autorizada para utilizar esta rotina.")
	Return(.T.)
Endif
If MsgBox("Deseja atualizar comissões dos Pedidos de Venda com base no cadastro de Produtos?","Atualiza Comissões","YESNO")
	cSql := "SELECT C5.C5_FILIAL, "
	cSql += "C5.C5_NUM, C5.C5_CLIENTE, C5.C5_LOJACLI, C5.C5_VEND1 "
	cSql += "FROM "+RetSqlName("SC5")+" C5 "
	cSql += "WHERE C5.D_E_L_E_T_ <> '*' "
	cSql += "AND C5.C5_FILIAL = '"+xFilial("SC5")+"' "
	cSql += "AND C5.C5_VEND1  = 'V00047' "
//	cSql += "AND C5.C5_VEND1  IN ('V00033','V00047') " //admin
//	cSql += "AND SubStr(C5.C5_VEND1,1,1) = 'V' "     //Guilherme 23/05 atualizar as comissoes dos representantes do vinho solicitado pelo Joao.
//	cSql += "AND C5.C5_NUM IN ('000269','000894')
	cSql += "ORDER BY C5.C5_FILIAL, C5.C5_NUM "
	TCQUERY cSql NEW ALIAS "TMPSC5"
	
	TMPSC5->(DbSelectArea("TMPSC5"))
	TMPSC5->(DbGotop())
	While !TMPSC5->(Eof())
		_cChave := TMPSC5->C5_FILIAL+TMPSC5->C5_NUM
		SC6->(DbSelectArea("SC6"))
		SC6->(DbSetOrder(1))
		SC6->(DbSeek(TMPSC5->C5_FILIAL+TMPSC5->C5_NUM))
		While !SC6->(Eof()) .AND. SC6->C6_FILIAL+SC6->C6_NUM == _cChave
			_nComis := 0
			SB1->(DbSelectArea("SB1"))
			SB1->(DbSetOrder(1))
			If SB1->(DbSeek(xFilial("SB1")+SC6->C6_PRODUTO))
				_nComis := SB1->B1_COMIS
				If _nComis	<> 0
					If SC6->C6_COMIS1 = 0 //Guilherme alterado para atualizar as comissoes independente se esta com 0 ou nao. conversado com a Solange 21/05/2011
		   				SC6->(Reclock("SC6",.F.))
							SC6->C6_COMIS1	:= _nComis
							SC6->C6_COMIS2	:= _nComis
							SC6->C6_COMIS3	:= _nComis	
							SC6->C6_COMIS4	:= _nComis	
							SC6->C6_COMIS5	:= _nComis	
						SC6->(MsUnlock("SC6"))
						SD2->(DbSelectArea("SD2"))
						SD2->(DbSetOrder(8)) // SD2->D2_FILIAL+SD2->D2_PEDIDO+SD2->D2_ITEMPV
						If SD2->(DbSeek(xFilial("SD2")+SC6->C6_NUM+SC6->C6_ITEM))
							While !SD2->(Eof()) .AND. SD2->D2_FILIAL+SD2->D2_PEDIDO+SD2->D2_ITEMPV == SC6->C6_FILIAL+SC6->C6_NUM+SC6->C6_ITEM
								If SD2->D2_COMIS1 = 0
									SD2->(Reclock("SD2",.F.))
										SD2->D2_COMIS1	:= _nComis
										SD2->D2_COMIS2	:= _nComis	
										SD2->D2_COMIS3	:= _nComis	
										SD2->D2_COMIS4	:= _nComis	
										SD2->D2_COMIS5	:= _nComis	
									SD2->(MsUnlock("SD2"))
								Endif
								SD2->(DbSkip())
							End
						Endif
					Endif //guilherme 21/05/2011
				Endif			
			Endif
			SC6->(DbSelectArea("SC6"))
			SC6->(DbSkip())
		End
		TMPSC5->(DbSkip())
	End
	MsgInfo("Rotina finalizada com sucesso.")
	TMPSC5->(DbSelectArea("TMPSC5"))
	TMPSC5->(DbCloseArea())
Endif 

Return