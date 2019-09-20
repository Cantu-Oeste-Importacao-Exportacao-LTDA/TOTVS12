#INCLUDE "Protheus.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJGPER03 ºAutor  ³Prado               º Data ³  27/01/11    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para somar os valores de adto de viagem que existem º±±
±±º          ³ no movimento de caixinha para o funcionario (motorista)    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±

±±ºUso       ³ P10 - Especifico GRUPO CANTU                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function RJGPER03()

Local _Fil       := SRA->RA_FILIAL
Local _Mat       := SRA->RA_MAT
Local _Folmes    := GetMv("MV_FOLMES")
Local _Perini    := Substr(_Folmes,1,4) + substr(_Folmes,5,2) + "01"
Local _Perfim    := Substr(_Folmes,1,4) + substr(_Folmes,5,2) + "31"
Local _Valor     := 0     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//*************************** inicio select para somar valores adto de viagem do motorista na tabela de movimento caixinha ***************************
// Valida se a tabela temporaria esta aberta
if select("RJGPER03TMP") > 0
	("RJGPER03TMP")->(dbclosearea())
endif

cQuery := " "
cQuery := "select eu_filial, eu_num, eu_nroadia, eu_valor "
cQuery += " from  "+RetSqlName("SEU")+" seu "
cQuery += " where seu.eu_filial = '"+_Fil+"' and"
cQuery += " seu.eu_emissao <= '"+_perfim+"' and  "
cQuery += " seu.eu_coddes = '9010001' and "
cQuery += " (seu.eu_x_atufp = ' ' or "
cQuery += " seu.eu_x_dtfpg = ' ' or seu.eu_x_dtfpg between '"+_perini+"' and '"+_perfim+"' )  and"
cQuery += " seu.d_e_l_e_t_ <> '*' "
cQuery += " order by eu_filial, eu_nroadia "

MemoWrite("RJGPER03TMP.TXT",cQuery)
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"RJGPER03TMP",.F.,.T.)

If Alias() <> "RJGPER03TMP"
	MsgBox("RJGPER03TMP - Parâmetros Inválidos!")
	Return .f.
Endif

//*************************** final select para somar valores adto de viagem do motorista na tabela de movimento caixinha ***************************

// atribui a variavel abaixo para gravar o ultimo dia do mes que foi calculado a folha de pagamento
if Substr(_Folmes,5,2) = "02"
	_dtfpg := "28" + "/" + Substr(_Folmes,5,2) + "/" + substr(_Folmes,1,4)
else
	_dtfpg := "30" + "/" + Substr(_Folmes,5,2) + "/" + substr(_Folmes,1,4)
endif
// valida se existe movimentacao a na tabela do caixinha
If RJGPER03TMP->EU_VALOR > 0
	WHILE RJGPER03TMP->(!EOF())
		DbSelectArea("SEU")
		DbSetOrder(1)
		DbGoTop()
		IF dbSeek(xFilial("SEU") + RJGPER03TMP->EU_NROADIA )
			
			// valida se a matricula do motorista é igual ao funcionario
			If SEU->EU_CODMOT = _Mat
				_valor += RJGPER03TMP->EU_VALOR
				
				//*************************** inicio select para marcar flag registros encontrados das despesas de viagem do motorista na tabela de movimento caixinha ***************************
				
				cQuery := " "
				cQuery := "select eu_filial, eu_num, eu_nroadia "
				cQuery += " from  "+RetSqlName("SEU")+" seu "
				cQuery += " where seu.eu_filial = '"+_Fil+"' and"
				cQuery += " seu.eu_nroadia = '"+RJGPER03TMP->EU_NROADIA+"' and  "
				cQuery += " seu.eu_emissao <= '"+_perfim+"' and  "
				cQuery += " seu.eu_coddes = '9010001' and "
				cQuery += " (seu.eu_x_atufp = ' ' or "
				cQuery += " seu.eu_x_dtfpg = ' ' or seu.eu_x_dtfpg between '"+_perini+"' and '"+_perfim+"' )  and"
				cQuery += " seu.d_e_l_e_t_ <> '*' "
				cQuery += " order by eu_filial, eu_nroadia "
				
				MemoWrite("TMPRJGPER03.TXT",cQuery)
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPRJGPER03",.F.,.T.)
				
				If Alias() <> "TMPRJGPER03"
					MsgBox("TMPRJGPER03 - Parâmetros Inválidos!")
					Return .f.
				Endif
				//*************************** final select para marcar flag registros encontrados das despesas de viagem do motorista na tabela de movimento caixinha ***************************
				
				// efetua a gravacao do flag nos registros filhos do codmot
				dbGoTop("TMPRJGPER03")
				WHILE TMPRJGPER03->(!EOF())
					DbSelectArea("SEU")
					DbSetOrder(1)
					DbGoTop()
					WHILE SEU->(!EOF())
						
						// valida se o movimento do caixinha é igual ao que foi apurado o valor a ser gerado para o funcionario
						If SEU->EU_NUM = TMPRJGPER03->EU_NUM
							RecLock("SEU",.F.)
							SEU->EU_X_ATUFP  := "S"
							SEU->EU_X_DTFPG  :=  ctod(_dtfpg)
							SEU->(MSUnLock())
						EndIf
						SEU->(DBSKIP())
					ENDDO
					TMPRJGPER03->(DBSKIP())
				ENDDO
				
			EndIf
			// Valida se a tabela temporaria esta aberta
			
			if select("TMPRJGPER03") > 0
				("TMPRJGPER03")->(dbclosearea())
			endif
			
		EndIf
		RJGPER03TMP->(DBSKIP())
	ENDDO
Endif

// Efetua o fechamento das tabelas temporarias

if select("TMPRJGPER03") > 0
	("TMPRJGPER03")->(dbclosearea())
endif

if select("RJGPER03TMP") > 0
	("RJGPER03TMP")->(dbclosearea())
endif

Return _Valor
