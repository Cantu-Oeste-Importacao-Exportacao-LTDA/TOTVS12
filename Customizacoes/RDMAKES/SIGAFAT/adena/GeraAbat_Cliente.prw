#include "rwmake.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SF2460I   ºAutor  ³Microsiga           º Data ³  05/24/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Este ponto de entrada gera um abatimento para cada titulo  º±±
±±º          ³ da nota fiscal utilizando para calculo o % do cadastra     º±±
±±º          ³ de cliente (A1_DESVEN)                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function SF2460I()   
Local _aArea	:= GetArea()
Local _Filial   := SF2->F2_FILIAL
Local _Num      := SF2->F2_DOC
Local _Prefixo  := SF2->F2_SERIE
Local _Cliente  := SF2->F2_CLIENTE
Local _Loja     := SF2->F2_LOJA
Local _Desconto := 0
Local _RegSE1   := 0
Local _DesFat   := " "   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

dbSelectArea("SC5")
dbSetOrder(1)
dbSeek(xFilial("SC5")+ alltrim(SD2->D2_PEDIDO))

If !Empty(SC5->C5_XPEDADE)
	
	//Posiciona nos titulos a receber e pega vencimento/parcela e valor
	dbSelectArea("SE1")
	SE1->(dbGoTop())
	If dbSeek(xFilial("SE1")+ _Prefixo + _Num)
		
		While SE1->(!EOF()) .AND. SE1->E1_PREFIXO == _Prefixo .AND. SE1->E1_NUM == _Num
			RecLock("SE1",.F.)
			SE1->E1_PORTADO := "999"
			MsUnlock()
			
			SE1->(dbSkip())
		EndDo
		
	endIf
	SE1->(dbCloseArea())  

	dbSelectArea("SA1")
	dbSetOrder(1)
	If dbSeek(xFilial("SA1") + _Cliente + _Loja)	
		RecLock("SA1",.F.)
		SA1->A1_LC := 0
		MsUnlock()
		SA1->(dbSkip())
	Endif
EndIf  

RestArea(_aArea)

Return
/*

Rafael: Comentado em 29/12/2010, não será mais necessário, utilizar contratos de descontos de clientes.



If AllTrim(Upper(GetMV("MV_ABATFIN"))) = "S"  .AND. SF2->F2_TIPO = "N"
dbSelectArea("SA1")
dbSetOrder(1)
If dbSeek(xFilial("SA1") + _Cliente + _Loja)
_Desconto := SA1->A1_DESVEN
_DesFat   := SA1->A1_DFFAT
Endif
If _Desconto > 0 .and. _DesFat <> "S"
RecLock("SF2",.f.)
SF2->F2_DESVEN := _Desconto
SF2->(MsUnlock())
dbSelectArea("SE1")
dbSetOrder(1)
If dbSeek(xFilial("SE1") + _Prefixo + _Num)
While !eof("SE1") .and. SE1->E1_FILIAL + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_TIPO =  _Filial + _Prefixo + _Num + "NF"
If SE1->E1_TIPO <> "AB-"
_RegSE1 := SE1->(Recno())
GravaAbat(SE1->E1_FILIAL , SE1->E1_PREFIXO, SE1->E1_NUM    , SE1->E1_PARCELA, SE1->E1_CLIENTE, SE1->E1_LOJA   , SE1->E1_NATUREZ, SE1->E1_EMISSAO,;
SE1->E1_VENCTO , SE1->E1_VENCREA, SE1->E1_VALOR  , SE1->E1_VEND1  , SE1->E1_VEND2  , SE1->E1_VEND3  , SE1->E1_VEND4  , SE1->E1_VEND5  ,;
SE1->E1_COMIS1 , SE1->E1_COMIS2 , SE1->E1_COMIS3 , SE1->E1_COMIS4 , SE1->E1_COMIS5 , SE1->E1_BASCOM1, SE1->E1_BASCOM2, SE1->E1_BASCOM3,;
SE1->E1_BASCOM4, SE1->E1_BASCOM5, SE1->E1_VALCOM1, SE1->E1_VALCOM2, SE1->E1_VALCOM3, SE1->E1_VALCOM4, SE1->E1_VALCOM5, SE1->E1_PEDIDO ,;
SE1->E1_SERIE  , _Desconto)
dbSelectArea("SE1")
dbSetOrder(1)
SE1->(dbGoto(_RegSE1))
Endif
dbSelectArea("SE1")
dbSetOrder(1)
SE1->(dbSkip())
EndDo
Endif
Endif
Endif
Return .t.


Static Function GravaAbat(_Fil,_Pre,_Num,_Par,_Cli,_Loj,_Nat,_Emi,_Ve1,_Ve2,_Val,_Vd1,_Vd2,_Vd3,_Vd4,_Vd5,_Co1,_Co2,_Co3,_Co4,_Co5,;
_Ba1,_Ba2,_Ba3,_Ba4,_Ba5,_Vc1,_Vc2,_Vc3,_Vc4,_Vc5,_Ped,_Ser,_Des)


Local aVetor := {}

lMsErroAuto := .F.

aVetor  := {	{"E1_PREFIXO"  ,_Pre             ,Nil },;
{"E1_NUM"	   ,_Num             ,Nil },;
{"E1_PARCELA"  ,_Par             ,Nil },;
{"E1_TIPO"	   ,"AB-"            ,Nil },;
{"E1_NATUREZ"  ,_Nat             ,Nil },;
{"E1_CLIENTE"  ,_Cli             ,Nil },;
{"E1_LOJA"	   ,_Loj             ,Nil },;
{"E1_EMISSAO"  ,_Emi             ,Nil },;
{"E1_VENCTO"   ,_Ve1             ,Nil },;
{"E1_VENCREA"  ,_Ve2             ,Nil },;
{"E1_VALOR"	   ,(_Val*_Des/100)  ,Nil },;
{"E1_VEND1"	   ,_Vd1             ,Nil },;
{"E1_VEND2"	   ,_Vd2             ,Nil },;
{"E1_VEND3"	   ,_Vd3             ,Nil },;
{"E1_VEND4"	   ,_Vd4             ,Nil },;
{"E1_VEND5"	   ,_Vd5             ,Nil },;
{"E1_COMIS1"   ,_Co1             ,Nil },;
{"E1_COMIS2"   ,_Co2             ,Nil },;
{"E1_COMIS3"   ,_Co3             ,Nil },;
{"E1_COMIS4"   ,_Co4             ,Nil },;
{"E1_COMIS5"   ,_Co5             ,Nil },;
{"E1_BASCOM1"  ,_Ba1             ,Nil },;
{"E1_BASCOM2"  ,_Ba1             ,Nil },;
{"E1_BASCOM3"  ,_Ba1             ,Nil },;
{"E1_BASCOM4"  ,_Ba1             ,Nil },;
{"E1_BASCOM5"  ,_Ba1             ,Nil },;
{"E1_VALCOM1"  ,_Vc1             ,Nil },;
{"E1_VALCOM2"  ,_Vc1             ,Nil },;
{"E1_VALCOM3"  ,_Vc1             ,Nil },;
{"E1_VALCOM4"  ,_Vc1             ,Nil },;
{"E1_VALCOM5"  ,_Vc1             ,Nil },;
{"E1_PEDIDO"   ,_Ped             ,Nil },;
{"E1_SERIE"    ,_Ser             ,Nil }}


MSExecAuto({|x,y| Fina040(x,y)},aVetor,3) //Inclusao

If lMsErroAuto
mostraerro() // se ocorrer erro no sigaauto gera mensagem de informação do erro
MsgBox("Abatimento nao gerado. Corrija o erro, exclua a NF e fature novamente.")
Endif


Return .t.

*/

/*
********************
EXEMPLO DO SIGAAUTO PARA FUNCAO FINA040
**********************
User Function TFina040()
Local aVetor := {}

lMsErroAuto := .F.

aVetor  := {	{"E1_PREFIXO" ,"   "           ,Nil},;
{"E1_NUM"	   ,"000001"         ,Nil},;
{"E1_PARCELA" ," "             ,Nil},;
{"E1_TIPO"	   ,"DP "            ,Nil},;
{"E1_NATUREZ" ,"001"      ,Nil},;
{"E1_CLIENTE" ,"999999"        ,Nil},;
{"E1_LOJA"	   ,"00"            ,Nil},;
{"E1_EMISSAO" ,dDataBase       ,Nil},;
{"E1_VENCTO"	,dDataBase       ,Nil},;
{"E1_VENCREA" ,dDataBase       ,Nil},;
{"E1_VALOR"	,125             ,Nil }}

MSExecAuto({|x,y| Fina040(x,y)},aVetor,3) //Inclusao


aVetor  := {	{"E1_PREFIXO" ,"   "           ,Nil},;
{"E1_NUM"	   ,"000001"         ,Nil},;
{"E1_PARCELA" ," "             ,Nil},;
{"E1_TIPO"	   ,"DP "            ,Nil},;
{"E1_NATUREZ" ,"001"      ,Nil},;
{"E1_VALOR"	,250             ,Nil }}

MSExecAuto({|x,y| Fina040(x,y)},aVetor,4) //Alteracao


aVetor  := {	{"E1_PREFIXO" ,"   "           ,Nil},;
{"E1_NUM"	   ,"000001"         ,Nil},;
{"E1_PARCELA" ," "             ,Nil},;
{"E1_TIPO"	   ,"DP "            ,Nil},;
{"E1_NATUREZ" ,"001"      ,Nil}}

MSExecAuto({|x,y| Fina040(x,y)},aVetor,5) //Exclusao


If lMsErroAuto
Alert("Erro")
Else
Alert("Ok")
Endif
Return */
