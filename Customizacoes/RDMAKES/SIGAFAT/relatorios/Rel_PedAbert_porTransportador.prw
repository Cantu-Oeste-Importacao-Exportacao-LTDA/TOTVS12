#include "rwmake.ch"
User Function PedTransp()
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,AORD")
SetPrvt("WNREL,LBLOQUEADO,CPEDIDOS,CPERG,ARETURN,NLASTKEY")
SetPrvt("TAMANHO,NTIPO,NPAG,ADBF,CARQ,CARQIND")
SetPrvt("CENTREG,CPROD,CDESC,CLOCAL,CORDEM,CUM")
SetPrvt("NSOMAPRODU,NPED,NPESO,nSomaPeso,nTotalPeso,ntotitem,nitenstotal,nitem")  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

Titulo      := "Pedidos em aberto - Transportador"
cDesc1      := "Este programa tem como objetivo emitir relação de pedidos"
cDesc2      := " por transportador."
cDesc3      := ""
cString     := "SC5"
aOrd        := {}
wnrel       := "PEDTRASP"
lBloqueado  := .F.
cPedidos    := ""
cPerg       := 'RJU004'
Tamanho     := "P"
m_pag     :=  1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis padrao de todos os relatorios                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aReturn     := { "Normal", 1,"Administracao", 1, 2, 1, "", 1}
nLastKey    := 0   


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // Periodo Inicial                      ³
//³ mv_par02             // Periodo Final                        ³
//³ mv_par03             // Do Entregador                        ³
//³ mv_par04             // Ate o Entregador                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetPrint(cString, WnRel, cPerg, Titulo, cDesc1, cDesc2, cDesc3, .F., "",, Tamanho)
If nLastKey == 27 .Or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)
If nLastKey == 27 .Or. nLastkey == 27
   Return
Endif


nTipo     := 0
nPag      := 1
Processa( {|| GeraTmp() }, "Arquivo de Trabalho")
Return

//³Funcao    ³ GeraTmp  ³       ³                       ³ Data ³ 18/11/98 ³±±
//³Descricao ³ Gera o Arquivo de Trabalho do Romaneio                     ³±±

Static Function GeraTmp()
Local cAliasSC5 := GetNextAlias()
Local cLocal := iif(mv_par05 == 1, "03.", "01.")
Local dEmissao
aDbf := {}
Aadd(aDbf,{"PEDIDO" , "C", 06, 0})
Aadd(aDbf,{"CLIENTE" , "C", 06, 0})
Aadd(aDbf,{"LOJA" , "C", 2, 0})
Aadd(aDbf,{"NOMECLI"    , "C", 50, 0})
Aadd(aDbf,{"TOTAL"   , "N",  14, 2})
Aadd(aDbf,{"PESO"   , "N", 14, 2})
Aadd(aDbf,{"MUNICIPIO"   , "C", 30, 0})
Aadd(aDbf,{"UF"  , "C", 02, 0})
Aadd(aDbf,{"TRANSP" , "C", 06, 0})


ProcRegua(SC5->(LastRec()))

cArq := CriaTrab(aDbf, .T.)

Use (cArq) Alias TRB Shared New

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos Indices e arquivos                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SA4->(DbSetOrder(1))   // Filial+Codigo
SB1->(DbSetOrder(1))   // Filial+Codigo do Produto
SC5->(DbSetOrder(2))   // Filial+Emissao+Numero
SC6->(DbSetOrder(1))   // Filial+Numero

SC5->(DbSeek(xFilial("SC5") + DToS(Mv_Par01), .T.) )
SETPRC(0,0)

BeginSql Alias cAliasSC5
	select C5_NUM, C5_CLIENTE, C5_LOJACLI, A1_NOME, A1_MUN, A1_EST, C5_TRANSP
  from %table:SC5% SC5
    inner join %table:SA1% SA1 on A1_COD = C5_CLIENTE and A1_LOJA = C5_LOJACLI
  where C5_Transp >= %Exp:Mv_Par03%
    and C5_Transp <= %Exp:Mv_Par04%
    And C5_Emissao >= %Exp:Mv_Par01%
    And C5_Emissao <= %Exp:Mv_Par02%
    and C5_Filial = %xFilial:SC5%
    And C5_Nota = "      "
    and SA1.D_E_L_E_T_ = " "
    And SC5.D_E_L_E_T_ = " "
  Order by C5_TRANSP, A1_MUN, A1_NOME
EndSql

While (cAliasSC5)->(!Eof())
  IncProc()
	nPeso := 0//(cAliasSC5)->C6_QTDVEN * (cAliasSC5)->B1_PESO
 	RecLock("TRB", .T.)
 	
 	TRB->PEDIDO := (cAliasSC5)->C5_Num
	TRB->CLIENTE := (cAliasSC5)->C5_CLIENTE
	TRB->LOJA := (cAliasSC5)->C5_LOJACLI
	TRB->NOMECLI := (cAliasSC5)->A1_NOME
	TRB->TOTAL := 0 //(cAliasSC5)->C5_TOTAL
	TRB->PESO := 0 //(cAliasSC5)->C5_PESO
	TRB->MUNICIPIO := (cAliasSC5)->A1_MUN
	TRB->UF := (cAliasSC5)->A1_EST 	
	TRB->TRANSP := (cAliasSC5)->C5_TRANSP
  MsUnlock("TRB")
	
	(cAliasSC5)->(DbSkip())
End

TRB->(DbGoTop())

If LastRec() == 0
	MsgInfo("ATENCAO!!! Nao Foram encontrados pedidos que satisfacam os parametros digitados.", "Ped. Transp.")
	DbSelectArea("TRB")
	TRB->(DbCloseArea("TRB"))
	Return
EndIf

cArqInd := CriaTrab(NIL,.f.)

DbSelectArea("TRB")

//IndRegua("TRB", cArqInd, "StrZero(TRB->Ordem, 4)+Transp+Desc+Local+UM",,, "Selecionando Registros...")

RptStatus({|| Rel004() }, "Mapa de separacao")

Return


//³Fun‡„o    ³Rel004    ³       ³                       ³ Data ³ 01.09.98 ³±±
//³Descri‡„o ³Impressao do corpo do relatorio                             ³±±

Static Function Rel004()
SetPrvt("Cabec1,Cabec2")
Titulo   := "Relacao de Pedidos em aberto"
Cabec1   := "PEDIDO CLI./LOJA  NOME CLIENTE                        MUNICIPIO              UF"
Cabec2   := ""
cEntreg    := TRB->Transp
nsomaprodu := 0
nSomaPeso  := 0
nTotalPeso := 0
ntotitem   := 0
nitenstotal:= 0
SETPRC(0,0)

Cabec(titulo, cabec1, "", "PedTransp", "P", 18)
@ PRow(), 00 PSay "Transportador: " + TRB->Transp

SetRegua(TRB->(LastRec()))

TRB->(DbGotop())

While TRB->(!Eof())
  cEntreg := TRB->Transp
  IncRegua()
  While TRB->(!Eof()) .And. cEntreg == TRB->Transp    
    
    @ PRow() + 1,          00 PSay TRB->PEDIDO
    @ PRow()    ,          08 PSay TRB->CLIENTE + "/" + TRB->LOJA
    @ PRow()    ,          19 PSay Left(TRB->NOMECLI, 36)
    @ PRow()    ,         055 PSay Left(TRB->MUNICIPIO, 23)
    @ PRow()    ,         078 PSay TRB->UF

  	If PRow() >= 58
    	Cabec(titulo, cabec1, "", "PedTransp", "P", 18)
  	EndIf
  	
  	TRB->(DbSkip())
	End
  if (TRB->(!Eof()))
  	@ PRow() + 1, 00 PSay Repl("_", 80)
  	@ PRow() + 1, 00 PSay "Transportador: " + TRB->Transp
  EndIf
End

If aReturn[5] = 3 //** Direto na Porta
	Eject
Endif

//Eject
DbSelectArea("TRB")
TRB->(DbCloseArea("TRB"))
Set Device To Screen
If aReturn[5] == 1
  Set Printer To
  OurSpool(WnRel)
Endif
FT_PFlush()
Return