#include "rwmake.ch"

User Function U_RELARNO()
/*
+---------------------------------------------------------------------+
| Declaracao de variaveis utilizadas no programa atraves da funcao    |
| SetPrvt, que criara somente as variaveis definidas pelo usuario,    |
| identificando as variaveis publicas do sistema utilizadas no codigo |
| Incluido pelo assistente de conversao do AP5 IDE                    |
+---------------------------------------------------------------------+
*/
SetPrvt("cItem,cArq,cArqInd,nPag,cAmb")
SetPrvt("nQuant,nPrcven,nTotal,nTotalGeralDia,dEmissao,cCod,cDesc,cUm")

//Variaveis Padrao
SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,TITULO,CABEC1,CABEC2")
SetPrvt("CCANCEL,M_PAG,WNREL,")  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

/*
+-----------+------------------------------------------+------+----------+
| Funcao    | RJU005                                   | Data | 26.04.06 |
+-----------+------------------------------------------+------+----------+
| Descricao | Romaneio de Vendas - Pronta Entrega                        |
+-----------+------------------------------------------------------------+
*/  
cString  := "SF2"
cDesc1   := OemToAnsi("Este programa tem como objetivo Gerar um ")
cDesc2   := OemToAnsi("romaneio de vendas a pronta entrega.")
cDesc3   := ""
Tamanho  := "P"
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
NomeProg := "RJU005"
aLinha   := {}
nLastKey := 0
Titulo   := "Romaneio de Vendas - Pronta Entrega"
//           00       10        20        30        40        50        60        70        80       
//           12345678901234567890123456789012345678901234567890123456789012345678901234567890
Cabec1   := "Data  Cod.     Produto                           Quant.  U.M. Prc.Uni. Vlr.Total"
Cabec2   := ""
cCancel  := "***** Cancelado Pelo Operador *****"

m_Pag    := 1                      //Variavel que acumula numero da pagina

WnRel    := "RJU005"               //Nome Default do relatorio em Disco

Pergunte(NomeProg)

WnRel := SetPrint(cString, WnRel, NomeProg, Titulo, cDesc1, cDesc2, cDesc3, .F., "",.F., Tamanho)

SetDefault(aReturn, cString,,,"P",1)

if nLastKey == 27
   Set Filter To
   Return
Endif

/*
+-----------+------------------------------------------+------+----------+
| Funcao    | GeraTemp                                 | Data | 26.04.06 |
+-----------+------------------------------------------+------+----------+
| Descricao | Gera arquivo de trabalho                                   |
+-----------+------------------------------------------------------------+
*/  
Processa( {|| GeraTmp() }, "Arquivo de Trabalho")
Return

Static Function GeraTmp()
aDbf := {}
Aadd(aDbf,{"EMISSAO" , "D", 08, 0})
Aadd(aDbf,{"COD"     , "C", 15, 0})
Aadd(aDbf,{"DESC"    , "C", 30, 0})
Aadd(aDbf,{"QUANT"   , "N", 14, 5})
Aadd(aDbf,{"UM"      , "C", 02, 0})
Aadd(aDbf,{"PRCVEN"  , "N", 08, 2})
Aadd(aDbf,{"TOTAL"   , "N", 08, 2})

ProcRegua(SF2->(LastRec()))

cArq := CriaTrab(aDbf, .T.)

Use (cArq) Alias TRB Shared New

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos Indices e arquivos                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SF2->(DbSetOrder(4))	// Filial+Serie+DTEmissao+Codigo+...
SD2->(DbSetOrder(3))	// Filial+Doc+Serie+Cliente+...
SB1->(DbSetOrder(1))	// Filial+Cod+...

SF2->(DbSeek(xFilial("SF2") + Mv_Par05 + DToS(Mv_Par01), .T.) )
SETPRC(0,0)  

While SF2->(!Eof()) .And. SF2->F2_EMISSAO >= Mv_Par01 .And. SF2->F2_EMISSAO <= Mv_Par02
   IncProc()
   If SF2->F2_VEND1 >= Mv_Par03 .And. SF2->F2_VEND1 <= Mv_Par04 .And. SF2->F2_SERIE <= Mv_Par05
		SD2->(DbSeek(xFilial("SD2") + SF2->F2_DOC + Mv_Par05,.T.))
		While SD2->(!Eof()) .And. SD2->D2_DOC == SF2->F2_DOC
			SB1->(DbSeek(xFilial("SB1") + SD2->D2_COD,.T.))
    	    RecLock("TRB", .T.)
        		TRB->EMISSAO  := SF2->F2_EMISSAO
               	TRB->COD     := SD2->D2_COD 
    	        TRB->DESC    := SB1->B1_DESC
    	        TRB->QUANT   := SD2->D2_QUANT
                TRB->UM      := SD2->D2_UM
    	        TRB->PRCVEN  := TRB->PRCVEN + SD2->D2_PRCVEN
                TRB->TOTAL   := SD2->D2_TOTAL + TRB->TOTAL
			MsUnlock("TRB")
            SD2->(DbSkip())
         EndDo
   EndIf
   SF2->(DbSkip())
EndDo
TRB->(DbGoTop())

If LastRec() == 0
   MsgInfo("ATENCAO!!! Nao Foram encontrados pedidos que satisfacam os parametros digitados.", "Romaneio")
   DbSelectArea("TRB")
   TRB->(DbCloseArea("TRB"))
   Return
EndIf

cArqInd := CriaTrab(NIL,.f.)

DbSelectArea("TRB")

IndRegua("TRB", cArqInd, "DToS(EMISSAO)+COD",,, "Selecionando Registros...")

RptStatus({|| Rel005() }, "Mapa Arno")

Return

/*
+-----------+------------------------------------------+------+----------+
| Funcao    | Rel005                                   | Data | 26.04.06 |
+-----------+------------------------------------------+------+----------+
| Descricao | Impressao do corpo do relatorio                            |
+-----------+------------------------------------------------------------+
*/
Static Function Rel005()
	Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, 15)
	SetRegua(TRB->(LastRec())) 
	TRB->(DbGotop())	
	dEmissao    := TRB->EMISSAO
	While TRB->(!Eof())
		@ PRow() + 1 ,          0  PSay dEmissao
		While dEmissao == TRB->EMISSAO
			cCod			:= TRB->COD
			cDesc			:= TRB->DESC
			nQuant			:= 0
			cUm				:= TRB->UM
			nPrcven			:= 0
			nTotal			:= 0		
			While TRB->(!Eof()) .And. cCod == TRB->COD .And. dEmissao == TRB->EMISSAO
				IncRegua()
				nQuant      	:= nQuant + TRB->QUANT
				nPrcVen     	:= nPrcven + TRB->PRCVEN
				nTotal      	:= nTotal + TRB->TOTAL
				TRB->(DbSkip())
			EndDo
            If PRow() >= 58
				@ PRow() + 1 ,          0  PSay ' '            
				Roda(,,Tamanho)
				//Eject
				Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, 15)
            EndIf		
			@ PRow() + 1 ,          0  PSay '    |-'
			@ PRow()     , PCol() + 0  PSay cCod	Picture "@!S7"
			@ PRow()     , PCol() + 2  PSay cDesc	Picture "@!S30"
			@ PRow()     , PCol() + 2  PSay nQuant	Picture "@E 9,999.99"
	  		@ PRow()     , PCol() + 2  PSay cUm
	  		@ PRow()     , PCol() + 2  PSay nPrcven	Picture "@E 9,999.99"
	  		@ PRow()     , PCol() + 2  PSay nTotal	Picture "@E 99,999.99"			
		EndDo
		//@ PRow() + 1 ,          0  PSay ' '
		dEmissao    := TRB->EMISSAO
	EndDo
	While PRow()<=58 //preencher com linhas em branco, para colocar o rodape no final da pagina
		@ PRow() + 1 ,          0  PSay ' '
	EndDo
	Roda(,,Tamanho)
	DbSelectArea("TRB")
	TRB->(DbCloseArea("TRB"))
	Set Device To Screen
	If aReturn[5] == 1
	   Set Printer To
	   OurSpool(WnRel)
	Endif
	FT_PFlush()
Return