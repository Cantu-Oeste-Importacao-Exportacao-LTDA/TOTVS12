#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO4     º Autor ³ AP6 IDE            º Data ³  27/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa para corrigir SB9 no fechamento da Data Informada º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CORSB9()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private _Produto := Space(15), _Local := "  ", _Quant:= 0, _Cust:=0, _CusU:=0, _NQuant:=0,_NCust:=0, _NCusU:=0
Private _Conv := 0, _TipConv := " ",_Fechamento:= "31/07/08"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 200,1 TO 380,600 DIALOG oGeraTxt TITLE OemToAnsi("Corrigir SB9")
@ 02,10 TO 080,295
@ 10,020 Say " Produto/Armaz. "
@ 10,245 Say " Data "

@ 30,020 Say " Quantidade  "
@ 30,110 Say " Custo Total "
@ 30,200 say " Custo Unitario "
@ 50,020 Say " Nova Quantidade  "
@ 50,110 Say " Novo Custo Total "
@ 50,200 Say " Novo Custo Unitario "

@ 10,070 Get _Produto Valid produto(_Produto) F3 "SB1"
@ 10,100 Get _Local   Valid Armaz(_Produto,_Local)
@ 10,260 Get _Fechamento Picture "@E 99/99/99"

@ 30,070 Get _Quant When .f.   Size 40,10  Picture "@E 99999999.99"
@ 30,160 Get _Cust  When .f.   Size 40,10  Picture "@E 99,999,999.99"
@ 30,250 Get _CusU  When .f.   Size 40,10  Picture "@E 99,999,999.99"
@ 50,070 Get _NQuant           Size 40,10  Picture "@E 99,999,999.99"
@ 50,160 Get _NCust When .f.   Size 40,10  Picture "@E 99,999,999.99"
@ 50,250 Get _NCusU            Size 40,10  Valid NCusto(_NQuant,_NCusU) Picture "@E 99,999,999.99"


@ 70,128 BMPBUTTON TYPE 01 ACTION OkGera(_Produto,_Local,_NQuant,_NCusU)
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
   _NQuant:= 0
   _NCusU := 0
Activate Dialog oGeraTxt Centered
Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao para buscar a descricao do produto e os campos para segunda UM
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Produto(_Prod)
Local _Desc := " ",   _Retorno := .t.
_Conv := 0
_TipConv := " "
dbSelectArea("SB1")
dbSetOrder(1)
If dbSeek(xFilial("SB1") + _Prod)
   _Desc    := AllTrim(SB1->B1_DESC) + "(Fech: " + _Fechamento + ")"
   _Local   := SB1->B1_LOCPAD
   _Conv    := SB1->B1_CONV
   _TipConv := SB1->B1_TIPCONV
   @ 10,120 Get _Desc When .f. Size 120,10
Else
  _Retorno := .f.
  MsgBox("Produto nao cadastrado")   
Endif

If Empty(_Produto)
  _Retorno := .t.
Endif

Return _Retorno

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao para buscar os valores do fechamento e verifica se o produto em questao existe no SB9
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Armaz(_Prod,_Local)
Local _Retorno := .t.

   _Quant := 0
   _Cust  := 0
   _CusU  := 0
   _NQuant:= 0
   _NCust := 0
   _NCusU := 0

dbSelectArea("SB9")
dbSetOrder(1)                                          
If dbSeek(xFilial("SB9") + _Prod + _Local + dtos(ctod(_Fechamento)) )
   _Quant := SB9->B9_QINI
   _Cust  := SB9->B9_VINI1
   _CusU  := Round(SB9->B9_VINI1 / SB9->B9_QINI,2)
   _NQuant:= SB9->B9_QINI
   _NCust := SB9->B9_VINI1
   _NCusU := Round(SB9->B9_VINI1 / SB9->B9_QINI,2)

Else
   _Retorno := .f.
   MsgBox("Produto nao encontrado no fechamento de " + _Fechamento + ", verifique nos saldos iniciais" )   
Endif
If Empty(_Local)
   _Retorno := .t.
Endif
Return _Retorno

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao para calcular o novo custo total do fechamento
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function NCusto(_NQuant,_NCusU)
   _NCust := Round(_NQuant * _NCusU,2)
Return .t.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao que grava os novos valores no fechamento (SB9)
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function OkGera(_Produto,_Local,_NQuant,_NCusU)
Local _QSUM := 0
If !Empty(_Produto) .AND. !Empty(_Local)

   dbSelectArea("SB9")
   dbSetOrder(1)                                          
   If dbSeek(xFilial("SB9") + _Produto + _Local + dtos(ctod(_Fechamento)) ) 
      If _TipConv = "M"
         _QSUM := Round(_NQuant * _Conv,2)
      ElseIf _TipConv = "D"
         If _Conv > 0
            _QSUM := Round(_NQuant / _Conv,2)
         Else        
            _QSUM := 0
         Endif   
      Endif
      RecLock("SB9",.f.)
      SB9->B9_QINI    := _NQuant
      SB9->B9_VINI1   := Round(_NQuant * _NCusU,2)
      SB9->B9_QISEGUM := _QSUM
      SB9->(MsUnlock())
      MsgInfo("Gravacao efetuada com Sucesso!!!")
      _Quant := 0
      _Cust  := 0
      _CusU  := 0
      _NQuant:= 0
      _NCust := 0
      _NCusU := 0
   Else
      _Retorno := .f.
      MsgBox("Produto nao encontrado no fechamento de " + _Fechamento + ", verifique nos saldos iniciais" )   
   Endif
Else
   MsgBox("Produto ou Armazem em Branco. Gravacao Cancelada")
Endif   
Return .t.