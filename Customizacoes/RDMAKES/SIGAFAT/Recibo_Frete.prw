#include "rwmake.ch"

User Function Rju016()

LOCAL nTamSX1  := Len(SX1->X1_GRUPO)

//Declaracao de variaveis utilizadas no programa atraves da funcao SetPrvt
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,ARETURN")
SetPrvt("WNREL,N,NVALFRETE,NLASTKEY,NOMEPROG,CPERG")
SetPrvt("xNOME_EMP,xEND_EMP,xCOMP_EMP,xBAIR_EMP,xTEL_EMP,xFAX_EMP,xCEP_EMP")
SetPrvt("xCID_EMP,xEST_EMP,xCGC_EMP,xINSC_EMP")
                                                 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//Funcao    ³ RJU016                                  // Data   28/10/98  
//Descricao ³ Impressao de Recibo sobre Fretes                              
//Uso       ³ Especifico para a CANTU                                       
//Alteracao ³ 06/05/2003 inclusao do valor contribuicao previdenciaria solicitada pelo 
//          ³ contador Roberto Veiga - inclusao no sx1 do parametro mv_par05 no grupo 
//          ³ rju016
//Alteracao ³ 30/07/2004 inclusao do valor de vale pedagio solicitada pelos usuarios 
//          ³ Jane e Luiz - inclusao no sx1 do parametro mv_par06 no grupo RJU016

titulo   :="Recibo de Fretes"
cDesc1   :="Este programa ira emitir recibo sobre Fretes Pagos"
cDesc2   :=""
cDesc3   :=""
cString  :="SE1"
aReturn  := { "PreImpresso", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey := 0
nomeprog  := "RJU016"
cPerg     := PadR("RJU016", nTamSX1)
wnrel     := "RJU016"

//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // Numero do Cheque                     ³
//³ mv_par02             // Rg                                   ³ 
//³ mv_par03             // Sest/Senat                           ³ 
//³ mv_par04             // Insc. Cont. Individ.                 ³ 
//³ mv_par05             // Contr. Previd.                       ³ 
//³ mv_par06             // Vale Pedagio                         ³ 

Pergunte(cPerg)

WnRel := SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"")

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn, cString)

If LastKey() == 27 .OR. nLastKey == 27
   Return
Endif

SM0->(DbSetOrder(1))  
dbSelectArea("SM0")  
xNOME_EMP :=SM0->M0_NOMECOM                 // * Sigamat.emp
xCID_EMP  :=SM0->M0_CIDCOB
xCGC_EMP  :=SM0->M0_CGC 

DbSelectArea("SEF")
SEF->(DbSetOrder(4))               // filial+numcheque.

SEF->(DbSeek(xFilial('SEF') + MV_PAR01 + MV_PAR07))
If SEF->(Found())
   For n := 1 to 2
      nValfrete  := SEF->EF_VALOR + MV_PAR03 +mv_par05 - mv_par06
      @  PRow()   ,2  Psay "=============================================================================="
      @  Prow()+2 ,25 Psay "R E C I B O    D E    F R E T E"
      @  Prow()+2 ,2  Psay "=============================================================================="
      @  Prow()+2 ,2  Psay "Nome: "+SEF->EF_BENEF
      @  Prow()   ,50 Psay "Numero........: "+SEF->EF_NUM
      @  Prow()+2 ,2  Psay "Rg/CPF: "+MV_PAR02
      @  Prow()   ,50 Psay "Valor do Frete: "+TRANSFORM(nValfrete,"@E 999,999.99")
      @  Prow()+2 ,2  Psay "Referente a: "+substr(SEF->EF_HIST,1,34)
      @  Prow()   ,50 Psay "Sest/Senat:...: "+TRANSFORM(MV_PAR03,"@E 999,999.99")
      @  Prow()+1 ,50 Psay "Contr. Previd.: "+TRANSFORM(MV_PAR05,"@E 999,999.99")      
      @  Prow()+1 ,50 Psay "Vale Pedagio:.: "+TRANSFORM(MV_PAR06,"@E 999,999.99")      
      @  Prow()+2 ,2  Psay "Insc.Cont.Ind.: " + mv_par04
      @  Prow()   ,50 Psay "LIQUIDO.......: "+TRANSFORM(SEF->EF_VALOR,"@E 999,999.99")
      @  Prow()+2 ,2  Psay "Recebi de "+xNOME_EMP+"  CNPJ "+xCGC_EMP
      @  Prow()+1 ,2  Psay "A quantia de: "+extenso(nValfrete)+"xxx"
      @  Prow()+3 ,50 Psay "_____________________"
      @  Prow()+1 ,50 Psay "      Assinatura"
      @  Prow()+2 ,40 Psay xCID_EMP+", "+dtoc(dDatabase)
      @  Prow()+5 ,00 Psay Chr(27) + Chr(18) 
	Next
Else
   MsgInfo("Cheque nao Encontrado!", "Recibo de Frete") 
EndIf


SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return 