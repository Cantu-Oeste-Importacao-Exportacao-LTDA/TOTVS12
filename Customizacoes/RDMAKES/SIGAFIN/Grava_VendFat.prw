#INCLUDE "TOPCONN.CH"
#INCLUDE "rwmake.ch"

/*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFA280     บAutor  ณ ANTONIO CARLOS     บ Data ณ  11/03/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ - GRAVAR O VENDEDOR EM UMA FATURA                          บฑฑ
ฑฑบ          ณ - GRAVA O DESCONTO FINANCEIRO NA FATURA                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                                            

User Function FA280()              
Local _Filial  := xFilial("SE1")         
Local _Prefixo := SE1->E1_PREFIXO
Local _Numero  := SE1->E1_NUM
Local _Tipo    := SE1->E1_TIPO  
Local _Vendedor:= "      "
Local _Cliente := SE1->E1_CLIENTE 
Local _Loja    := SE1->E1_LOJA  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

********************************
** GRAVA O VENDEDOR NA FATURA **
********************************  
cQuery := "SELECT E.E1_VEND1
cQuery += " FROM " + RetSqlName("SE1")+ " E  "
cQuery += " WHERE 	E.E1_FILIAL = '"+_Filial+ "' AND "
cQuery += "         E.E1_FATPREF = '" + _Prefixo + "' AND "   
cQuery += "         E.E1_FATURA  = '" + _Numero  + "' AND "   
cQuery += "         E.E1_TIPOFAT = '" + _Tipo    + "' AND "   
cQuery += "         E.D_E_L_E_T_ <> '*' "

TCQUERY cQuery NEW ALIAS "TMP1"
DBGOTOP()
_Vendedor := TMP1->E1_VEND1 // resultado do peso total 
DBCLOSEAREA("TMP1")

If MsgBox("Confirma a gravacao do vendedor " + _VENDEDOR + " na fatura ? ","ATENCAO","YESNO")  
   RecLock("SE1",.f.)
   SE1->E1_VEND1 := _Vendedor
   SE1->(Msunlock())
Endif



***************************************************
** GRAVA O ABATIMENTO PARA O DESCONTO FINANCEIRO ** 26/07/2006
***************************************************

If AllTrim(Upper(GetMV("MV_ABATFIN"))) = "S"  
   dbSelectArea("SA1")
   dbSetOrder(1)
   If dbSeek(xFilial("SA1") + _Cliente + _Loja)
      _Desconto := SA1->A1_DESVEN
      _DesFat   := SA1->A1_DFFAT
   Endif
   If _Desconto > 0 .and. AllTrim(_DesFat) == "S"
      //RecLock("SF2",.f.)
      //SF2->F2_DESVEN := _Desconto
      //SF2->(MsUnlock())
      //dbSelectArea("SE1") 
      //dbSetOrder(1)         
      //If dbSeek(xFilial("SE1") + _Prefixo + _Num)
        // While !eof("SE1") .and. SE1->E1_FILIAL + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_TIPO =  _Filial + _Prefixo + _Num + "NF" 
          //  If SE1->E1_TIPO <> "AB-"
               _RegSE1 := SE1->(Recno())
               GravaAbat(SE1->E1_FILIAL , SE1->E1_PREFIXO, SE1->E1_NUM    , SE1->E1_PARCELA, SE1->E1_CLIENTE, SE1->E1_LOJA   , SE1->E1_NATUREZ, SE1->E1_EMISSAO,;
                         SE1->E1_VENCTO , SE1->E1_VENCREA, SE1->E1_VALOR  , SE1->E1_VEND1  , SE1->E1_VEND2  , SE1->E1_VEND3  , SE1->E1_VEND4  , SE1->E1_VEND5  ,;
                         SE1->E1_COMIS1 , SE1->E1_COMIS2 , SE1->E1_COMIS3 , SE1->E1_COMIS4 , SE1->E1_COMIS5 , SE1->E1_BASCOM1, SE1->E1_BASCOM2, SE1->E1_BASCOM3,;
                         SE1->E1_BASCOM4, SE1->E1_BASCOM5, SE1->E1_VALCOM1, SE1->E1_VALCOM2, SE1->E1_VALCOM3, SE1->E1_VALCOM4, SE1->E1_VALCOM5, SE1->E1_PEDIDO ,;
                         SE1->E1_SERIE  , _Desconto)    
            //   dbSelectArea("SE1") 
            //   dbSetOrder(1)         
            //   SE1->(dbGoto(_RegSE1))
            //Endif             
            //dbSelectArea("SE1") 
            //dbSetOrder(1)         
            //SE1->(dbSkip())
         //EndDo
      //Endif
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
   mostraerro() // se ocorrer erro no sigaauto gera mensagem de informa็ใo do erro  
   MsgBox("Abatimento nao gerado. Corrija o erro, exclua a FAT e gere novamente.")
Endif


Return .t.



