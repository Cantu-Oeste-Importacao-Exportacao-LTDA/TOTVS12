#include "rwmake.ch"
#include "TopConn.ch"

User Function RomCarg3()
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,AORD")
SetPrvt("WNREL,LBLOQUEADO,CPEDIDOS,CPERG,ARETURN,NLASTKEY")
SetPrvt("TAMANHO,NTIPO,NPAG,ADBF,CARQ,CARQIND")
SetPrvt("CENTREG,CPROD,CDESC,CLOCAL,CORDEM,CUM")
SetPrvt("NSOMAPRODU,NPED,NPESO,nSomaPeso,nTotalPeso,ntotitem,nitenstotal,nitem") 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//?Funcao    ? RomCarga ?       ?                       ? Data ? 01/09/98 ???
//?Descricao ? Romaneio de Carga                                          ???
//? Uso      ? CANTU                                                      ???

Titulo      := "Mapa de separacao"
cDesc1      := "Este programa tem como objetivo emitir o Romaneio de Carga"
cDesc2      := "de Produtos."
cDesc3      := ""
cString     := "SC5"
aOrd        := {}
wnrel       := "RJU070"
lBloqueado  := .F.
cPedidos    := ""
cPerg       := 'RJU004'
Tamanho     := "P"
//???????????????????????????????????????????????????????????????
//? Variaveis padrao de todos os relatorios                      ?
//????????????????????????????????????????????????????????????????
aReturn     := { "Normal", 1,"Administracao", 1, 2, 1, "", 1}
nLastKey    := 0   

AjustaPerg(cPerg)

//???????????????????????????????????????????????????????????????
//? Variaveis utilizadas para parametros                         ?
//? mv_par01             // Periodo Inicial                      ?
//? mv_par02             // Periodo Final                        ?
//? mv_par03             // Do Entregador                        ?
//? mv_par04             // Ate o Entregador                     ?
//???????????????????????????????????????????????????????????????? 
// AjustaSX1() // Adriano
Pergunte(cPerg)

//???????????????????????????????????????????????????????????????
//? Envia controle para a funcao SETPRINT                        ?
//????????????????????????????????????????????????????????????????
//SetPrint(cString, WnRel, cPerg, Titulo, cDesc1, cDesc2, cDesc3, .F., "",, Tamanho)
If nLastKey == 27 .Or. nLastKey == 27
	Return
Endif

//SetDefault(aReturn,cString)
//If nLastKey == 27 .Or. nLastkey == 27
//   Return
//Endif

nTipo     := 0
nPag      := 1
Processa( {|| GeraTmp() }, "Arquivo de Trabalho")
Return

//?Funcao    ? GeraTmp  ?       ?                       ? Data ? 18/11/98 ???
//?Descricao ? Gera o Arquivo de Trabalho do Romaneio                     ???

Static Function GeraTmp()
Local cAliasSC6 := GetNextAlias()
Local cLocal := iif(mv_par05 == 1, "INDUST", "NACION")
Local dEmissao
aDbf := {}
Aadd(aDbf,{"Emissao" , "D", 08, 0})
Aadd(aDbf,{"Transp " , "C", 06, 0})
Aadd(aDbf,{"Produto" , "C", 15, 0})
Aadd(aDbf,{"Desc"    , "C", 30, 0})
Aadd(aDbf,{"Grupo"   , "C",  4, 0})
Aadd(aDbf,{"Local"   , "C", 02, 0})
Aadd(aDbf,{"Quant"   , "N", 15, 2})
Aadd(aDbf,{"Pedido"  , "C", 06, 0})
Aadd(aDbf,{"UM"      , "C", 02, 0})
Aadd(aDbf,{"Ordem"   , "N", 04, 0})
Aadd(aDbf,{"Peso"    , "N", 15, 2})
Aadd(aDbf,{"CXKL"    , "C", 01, 0})

ProcRegua(SC5->(LastRec()))

cArq := CriaTrab(aDbf, .T.)

Use (cArq) Alias TRB Shared New

//???????????????????????????????????????????????????????????????
//? Definicao dos Indices e arquivos                             ?
//????????????????????????????????????????????????????????????????
SET DELETED OFF
SA4->(DbSetOrder(1))   // Filial+Codigo
SET DELETED ON

SB1->(DbSetOrder(1))   // Filial+Codigo do Produto
SC5->(DbSetOrder(2))   // Filial+Emissao+Numero
SC6->(DbSetOrder(1))   // Filial+Numero

SC5->(DbSeek(xFilial("SC5") + DToS(Mv_Par01), .T.) )

SETPRC(0,0)

BeginSql Alias cAliasSC6
	select C5_Transp, C6_QTDVEN, C5_Emissao, C5_Transp, C6_Produto, B1_Desc, 
			B1_Grupo, C6_Local, C6_Num, C6_ImpUni, C6_UM, C6_QtdVen, 
			C6_SEGUM, C6_UnsVen, B1_PESO
	from %table:SC5% SC5 
		inner join %table:SC6% SC6 on C6_NUM = C5_NUM and C5_FILIAL = C6_FILIAL
		inner join %table:SB1% SB1 on B1_COD = C6_PRODUTO and B1_FILIAL = %xFilial:SB1%
	where C5_Transp >= %Exp:Mv_Par03% 
		and C5_Transp <= %Exp:Mv_Par04%
		And C5_Emissao >= %Exp:Mv_Par01%  
		And C5_Emissao <= %Exp:Mv_Par02%
		and C6_Filial = %xFilial:SC6%
		And C6_Nota = "      "
		And SC6.D_E_L_E_T_ = " "
		and SB1.D_E_L_E_T_ = " "
		And SC5.D_E_L_E_T_ = " "
		And C6_LOCAL = %Exp:cLocal%
	ORDER BY C6_NUM
EndSql

While (cAliasSC6)->(!Eof())
  IncProc()
	nPeso := (cAliasSC6)->C6_QTDVEN * (cAliasSC6)->B1_PESO
 	RecLock("TRB", .T.)
 	dEmissao := (cAliasSC6)->C5_Emissao
  TRB->Emissao := SToD(dEmissao)
  TRB->Transp  := (cAliasSC6)->C5_Transp
  TRB->Produto := (cAliasSC6)->C6_Produto
	TRB->Desc    := (cAliasSC6)->B1_Desc
  TRB->Grupo   := (cAliasSC6)->B1_Grupo
  TRB->Local   := (cAliasSC6)->C6_Local
  TRB->Pedido  := (cAliasSC6)->C6_Num

	If (cAliasSC6)->C6_ImpUni == "1" //primeira unidade de medida
  	TRB->UM    := (cAliasSC6)->C6_UM
   	TRB->Quant := (cAliasSC6)->C6_QtdVen
  Else
    TRB->UM 	 := (cAliasSC6)->C6_SEGUM
   	TRB->Quant := (cAliasSC6)->C6_UnsVen
  EndIf


  TRB->Peso    := nPeso
  TRB->CXKL    := (cAliasSC6)->C6_IMPUNI
  MsUnlock("TRB")
	
	(cAliasSC6)->(DbSkip())
End

TRB->(DbGoTop())

If LastRec() == 0
	MsgInfo("ATENCAO!!! Nao Foram encontrados pedidos que satisfacam os parametros digitados.", "Romaneio")
	DbSelectArea("TRB")
	TRB->(DbCloseArea("TRB"))
	Return
EndIf

cArqInd := CriaTrab(NIL,.f.)

DbSelectArea("TRB")

IndRegua("TRB", cArqInd, "Transp+Desc+Local+UM",,, "Selecionando Registros...")

RptStatus({|| Rel004() }, "Mapa de separacao")

Return


//?Funcao    ?Rel004    ?       ?                       ? Data ? 01.09.98 ???
//?Descricao ?Impressao do corpo do relatorio                             ???

Static Function Rel004()

Public oFont1 := TFont():New( "Courier New",,08,,.F.,,,,,.F. )
Public oFont2 := TFont():New( "Courier New",,11,,.F.,,,,,.F. )
Public oFont3 := TFont():New( "Courier New",,13,,.F.,,,,,.F. )
Public oFont4 := TFont():New( "Courier New",,16,,.F.,,,,,.F. )
Public oFont5 := TFont():New( "Courier New",,18,,.F.,,,,,.F. )
Public oFont11:= TFont():New( "Courier New",,08,,.T.,,,,,.F. )
Public oFont12:= TFont():New( "Courier New",,12,,.T.,,,,,.F. )
Public oFont13:= TFont():New( "Courier New",,14,,.T.,,,,,.F. )
Public oFont14:= TFont():New( "Courier New",,16,,.T.,,,,,.F. )
Public oFont15:= TFont():New( "Courier New",,18,,.T.,,,,,.F. )

Public oPrn
Public nPag := 1
Public nLin := 0

SetPrvt("nLM,nRM,nTM,nBM,nLH,nCW,nLine,nCol,nRP,nCP,nRD,nCD,nLineZero") //nLineZero -> Ajuste para quando a linha comecar na posicao zero.

nLM  :=  100	//Left Margin
nRM  := 2261	//Right Margin
nTM  :=  100	//Top Margin
nBM  := 3300	//Botton Margin
nRH  :=   50	//Line Height   original:50
nCW  :=   26	//Character Width
nRow :=    1	//Linha atual
nCol :=    1	//Coluna Atual
nRP  := nTM+3	//Posicao da Primeira Linha Atual
nCP  := nLM+3	//Posicao da Primeira Coluna Atual
nRD  := nTM+45	//Posicao da Primeira Linha (divisao) Atual
nCD  := nLM+0	//Posicao da Primeira Coluna (divisao) Atual
nLinha  := 1
nColuna := 1

oPrn:=TMSPrinter():New()
oPrn:SetPortrait() // ou SetLandscape()
oPrn:SetPage(9)	//Folha A4
oPrn:Setup()
oPrn:Say(0,0," ",oFont1)							//Inicio

cEntreg    := TRB->Transp
cProd      := TRB->Produto
cDesc      := TRB->Desc
cLocal     := TRB->Local
cUM        := TRB->UM
cCodRom	   := GeraCod()
nsomaprodu := 0
nSomaPeso  := 0
nTotalPeso := 0
ntotitem   := 0
nitenstotal:= 0
//SETPRC(0,0)
SetRegua(TRB->(LastRec()))
TRB->( DbGotop() )
While TRB->(!Eof() )
  cPedidos  := ""
  CabcPar()
  _cTransp   := TRB->Transp
  _cLocal	 := TRB->Transp
  IncRegua()
  	While TRB->(!Eof()) .And. cEntreg == TRB->Transp
	 	While cProd == TRB->Produto .And. TRB->transp == cEntreg ;
	                                  .And. TRB->Local  == cLocal  ;
	                                  .And. TRB->UM     == cUM     ;
	                                  .And. TRB->(!Eof())
		    If cPedidos == ""
		    	cPedidos  := TRB->Pedido
		    Else
		    If !TRB->Pedido $ cPedidos
		      	cPedidos  := cPedidos  + ", " + TRB->Pedido
		    EndIf
	    End
	    SB1->(DbSeek(xFilial("SB1")+TRB->PRODUTO))       // PRODUTO
	    nSomaProdu := nSomaProdu + TRB->QUANT
    	 
  		nSomaPeso  := nSomaPeso  + TRB->Peso      
      	ntotitem   := ntotitem + TRB->QUANT   		
      	TRB->(DbSkip())
    End
   
    If nLinha >= 50
      PrintS(IncLin(2) , 68, '|     |     |    ', 3)
      DrawH(IncLin(0), 0, 90, 3)
      PrintS(IncLin(2) , 68, '|     |     |    ', 3)
      DrawH(IncLin(0), 0, 90, 3)
      PrintS(58, 09 , SubStr(cUsuario, 07, 15), 3)
      PrintS(59, 00, '-------------------------   -------------------------   ------------------------', 3)
      PrintS(61, 00, '        Emitente                   Conferente                Placa do Veiculo   ', 3)
      oPrn:EndPage()
      nLInha := 1
      CabcPar()
    EndIf    
    
    
    	PrintS(IncLin(2) , 00,PadR(Left(cProd, 7), 8), 3)
    	PrintS(IncLin(0) , 09, PadR(cDesc, 30), 3)
    	PrintS(IncLin(0) , 42, PadL(Transform(nSomaPeso, "@E 9,999.99"), 8), 3)
    	PrintS(IncLin(0) , 50, PadL(Transform(nSomaProdu, "@E 9,999.99"), 8), 3)
    	PrintS(IncLin(0) , 62, cUM, 3)
    	PrintS(IncLin(0) , 68, '|     |     |    ', 3)
    	DrawH(IncLin(0), 0, 90, 3)
    	IncLin(0) // aumenta duas linhas para o pr?ximo
   	 	cProd      := TRB->Produto
    	cDesc      := TRB->Desc
    	nTotalPeso := nTotalPeso + nSomaPeso
    	nSomaPeso  := 0
	nSomaProdu := 0
	cLocal     := TRB->Local
	cUM        := TRB->UM
	nitenstotal:= nitenstotal+1      
	End

  If PRow() >= 53
    
    oPrn:EndPage()    
    CabCPar()
  EndIf
  
  DrawH(IncLin(1), 0, 90, 3)
  
  PrintS(IncLin(2), 00, "Peso Total da Carga : ", 3)
  PrintS(IncLin(0), 25, Transform(nTotalPeso, "@E 999,999,999.99"), 3)  
  PrintS(IncLin(1), 00, "Tot. Itens do Mapa  : ", 3)
  PrintS(IncLin(0), 25, Transform(nItenstotal, "@E 999,999,999.99"), 3)
  PrintS(IncLin(1), 00, "Pedidos:", 3)
   
  For nPed := 1 To Len(cPedidos) Step 71
    If nPed == 1      
      PrintS(IncLin(0), 09, SubStr(cPedidos, nPed, 71), 3)
    Else
      PrintS(IncLin(1), 08, SubStr(cPedidos, nPed, 71), 3)
    EndIf
   Next 

  oPrn:EndPage()
  CabCPar()
  nLinha := 24
  
  PrintS(IncLin(0), 00, "CONTROLE DE CAIXAS", 3)
  PrintS(IncLin(2), 00, " T I P O  DESCRI??O                                                      QTDE", 3)
  PrintS(IncLin(2), 00, "|  X01  | Bagulho.....................................................|________|", 3)
  PrintS(IncLin(2), 00, "|  X02  | Valor  .....................................................|________|", 3)
  PrintS(IncLin(2), 00, "|  X03  | Caixa de 1/2 ...............................................|________|", 3)
  PrintS(IncLin(2), 00, "|  X04  | Banana .....................................................|________|", 3)
  PrintS(IncLin(2), 00, "|  X05  | Mam?o  .....................................................|________|", 3)
  PrintS(IncLin(2), 00, "|  X06  | Pl?stica ...................................................|________|", 3)
  
	nLinha := 45
  PrintS(IncLin(0), 00, "Separador:______________________________________________________________________", 3)
  PrintS(IncLin(2), 00, "Hr. Inicio Separacao:__________________Hr. Final Separacao:_____________________", 3)
  PrintS(IncLin(2), 00, "Hr. Inicio Separacao Ceasa:____________Hr. Final Separacao Ceasa________________", 3)
  PrintS(IncLin(2), 00, "Carregador:_____________________________________________________________________", 3)
  PrintS(IncLin(2), 00, "Hr. Inicio Conferencia:________________Hr. Final Conferencia:___________________", 3)

  nLinha := 58
  PrintS(IncLin(0), 09, SubStr(cUsuario, 07, 15), 3)
  PrintS(IncLin(1), 02, '-------------------------   -------------------------   ---------------------', 3)
  PrintS(IncLin(2), 02, '        Emitente                   Conferente              Placa do Veiculo  ', 3)
  cEntreg := TRB->Transp
 
  Reclock("SZQ",.T.)
  	SZQ->ZQ_FILIAL		:= xFilial("SZQ")
  	SZQ->ZQ_CODIGO		:= cCodRom
  	SZQ->ZQ_PEDIDOS		:= cPedidos
  	SZQ->ZQ_EMITENT		:= SubStr(cUsuario, 07, 15)
  	SZQ->ZQ_HORAEM 		:= Time()
  	SZQ->ZQ_EMISSAO		:= Date()
  	SZQ->ZQ_TRANSP		:= _cTransp
  	SZQ->ZQ_LOCAL		:= _cLocal
  SZQ->(MsUnlock("SZQ"))
  cCodRom	   := GeraCod()

  If !TRB->(Eof())
    oPrn:EndPage()
  EndIf
End
                                                                          
DbSelectArea("TRB")
TRB->(DbCloseArea("TRB"))
Set Device To Screen

FT_PFlush()	
oPrn:Preview()
MS_FLUSH()

Return

/**********************************************************
 Fun??o respons?vel por aumentar uma linha
 **********************************************************/
Static Function IncLin(n)
nLinha := nLinha + n
Return nLinha

/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????
???Funcao    ? CabcPar  ?       ?                       ? Data ? 01/09/98 ???
?????????????????????????????????????????????????????????????????????????J??
???Descricao ? Cabecalho de Relatorio                                     ???
?????????????????????????????????????????????????????????????????????????J??
??? Uso      ? Especifico para a CANTU                                    ???
????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==> Function CabCPar
Static Function CabCPar()
cAmb := GetEnvServer()
nLinha := 0
PrintS(IncLin(0), 00, 'Folha: ' + Trans(nPag, '999'), 2)
DrawH(IncLin(0), 0, 90, 3)
PrintS(IncLin(1), 00, '                          MAPA DE SEPARACAO DE CARGA' + ' - ' + cAmb, 3)
DrawH(IncLin(0), 0, 90, 3)

SET DELETED OFF

SA4->(Dbseek( xFilial("SA4") + cEntreg))

if ((SM0->M0_CODIGO = '50') .AND. (SM0->M0_CODFIL = '01') .And. (MV_PAR08 == 1))
	PrintS(IncLin(1), 00, 'TRANSPORTADOR: ' + SubStr(SA4->A4_COMPLEM, 4), 3)
else
	PrintS(IncLin(1), 00, 'TRANSPORTADOR: ' + cEntreg, 3)
EndIf

PrintS(IncLin(0), 66, 'DT.Ref.: ' + Dtoc(Mv_Par01), 3)

if (SM0->M0_CODIGO = '50') .AND. (SM0->M0_CODFIL = '01')
	cCodTr := Iif (MV_PAR08 == 1, SA4->A4_COMPLEM, SA4->A4_nReduz)
else
	cCodTr := SA4->A4_Nome
endIf	

SET DELETED ON

PrintS(IncLin(1), 00, 'PRACA        : ' + cCodTr, 3)
PrintS(IncLin(0), 66, 'Emissao: ' + Dtoc(dDatabase), 3)
PrintS(IncLin(1), 00, 'CODIGO MAPA  : '+cCodRom, 3) // Adriano
PrintS(IncLin(0), 66, 'Hora...: '+ Time(), 3)
DrawH(IncLin(1), 0, 90, 3)
//                       12345678901234567890123456789012345678901234567890123456789012345678901234567890
PrintS(IncLin(1), 00, "CODIGO  DESCRICAO                         PESO   QUANT  FATOR  SEPAR/CARREG/CXS", 3)
DrawH(IncLin(0), 0, 90, 3)
nPag := nPag + 1
Return


Static Function PrintS(pfRow,pfCol,pfText,pfFont)
	Do Case 
		Case pfFont == 1
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText, oFont1)
		Case pfFont == 2
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText, oFont2)
		Case pfFont == 3				
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText, oFont3)
		Case pfFont == 4
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText, oFont4)
		Case pfFont == 5
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText, oFont5)		
		Case pfFont == 11
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText,oFont11)
		Case pfFont == 12
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText,oFont12)
		Case pfFont == 13				
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText,oFont13)
		Case pfFont == 14		
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText,oFont14)
		Case pfFont == 15
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText,oFont15)		
	EndCase	
Return

Static Function DrawH(dhRow,dhCol,dhWidth,dhPen)
	While dhPen >= 1
		oPrn:Line (nRD+(nRH*(dhRow-1))+(dhPen-1) + 2,nCD+(nCW*(dhCol-1)),nRD+(nRH*(dhRow-1))+(dhPen-1),nCD+(nCW*(dhWidth-1)) )
		dhPen:=dhPen-1
	EndDo
Return

Static Function DrawV(dvRow,dvCol,dvHeight,dvPen) 
	If dvRow==0 	//Ajuste para quando a linha comecar na posicao zero.
		nLineZero:=10
	Else
		nLineZero:=0
	EndIf
	While dvPen >= 1
		oPrn:Line (nRD+(nRH*(dvRow-1))+nLineZero,nCD+(nCW*(dvCol-1))+(dvPen-1),nRD+(nRH*(dvHeight-1)),nCD+(nCW*(dvCol-1))+(dvPen-1) )
		dvPen:=dvPen-1
	EndDo
Return

//Gera sequencial para mapa de cargas
Static Function GeraCod()
Local _nRo	:= Space(06)
Local cAliasSZQ := GetNextAlias()

_Query := " SELECT MAX(SZQ.ZQ_CODIGO) CODIGO 	"
_Query += " FROM " + RetSqlName("SZQ")+" SZQ 	"
_Query += " WHERE SZQ.D_E_L_E_T_ <> '*' 		"
_Query += " AND SZQ.ZQ_FILIAL = '" + xFilial('SZQ') + "'	"
TCQUERY _Query NEW ALIAS cAliasSZQ
   
_Nro := StrZero(Val(cAliasSZQ->CODIGO)+1,6)
cAliasSZQ->(DbCloseArea())

Return(_Nro)

Static Function AjustaPerg()
cPerg := PADR(cPerg, Len(SX1->X1_GRUPO))
//Grupo/Ordem/Pergunta/PerSPA/PerENG/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefSPA1/DefENG1/Cnt01/Var02/Def02/DefSPA2/DefENG2/Cnt02/Var03/Def03/DefSPA3/DefENG3/Cnt03/Var04/Def04/DefSPA4/DefENG4/Cnt04/Var05/Def05/DefSPA5/DefENG5/Cnt05/F3/GRPSXG
PutSx1(cPerg,"01","Da Emissão  ?","Da Emissão  ?","Da Emissão  ?","mv_ch1","D",08,0,0,"G","","MV_PAR01")
PutSx1(cPerg,"02","Ate a Emissao   ?","Ate a Emissao   ?","Ate a Emissao   ?","mv_ch2","D",08,0,0,"G","","MV_PAR02")
PutSx1(cPerg,"03","Do Transportador  ?","Do Transportador  ?","Do Transportador  ?", "mv_ch3", "C",6,0,0,"G","", "SA4", "", "","MV_PAR03")
PutSx1(cPerg,"04","Ate o Transportador?","Ate o Transportador?","Ate o Transportador?", "mv_ch4", "C",6,0,0,"G","", "SA4", "", "","MV_PAR04")
PutSx1(cPerg,"05","Imp. Industrializados?","Imp. Industrializados?","Imp. Industrializados?", "mv_ch5", "N", 1, 0, 0,"C", "", "", "", "","MV_PAR05","Sim","Sim","Sim", "","Nao","Nao","Nao")
PutSx1(cPerg,"06","Regiao Inicial?","Regiao Inicial?","Regiao Inicial?", "mv_ch6", "C",6,0,0,"G","", "", "", "","MV_PAR06")
PutSx1(cPerg,"07","Regiao Final?","Regiao Final?","Regiao Final?", "mv_ch7", "C",6,0,0,"G","", "", "", "","MV_PAR07")
PutSx1(cPerg,"08","Altera Transportador?","Altera Transportador?","Altera Transportador?", "mv_ch8", "N", 1, 0, 0,"C", "", "", "", "","MV_PAR08","Sim","Sim","Sim", "","Nao","Nao","Nao")
Return