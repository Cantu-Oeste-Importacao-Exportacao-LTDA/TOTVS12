#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 10/05/01

//³Funcao    ³A390AVU   ³Autor  ³ Aurelio               ³ Data ³ 18/05/99 ³±±
//³Descri‡„o ³Ponto de entrada inclusao de cheques avulsos financeiro     ³±±
//³Alteracoes³ 17/09/1999 - Geandre Gomes de Oliveira                     ³±±
//³          ³ A pedido do cliente foi incluido o campo EF_SESTSEN para   ³±±
//³          ³ armazenar o valor referente a INSS SEST/SENAT e atraves    ³±±
//³          ³ de store ser tratado na contabilizacao no lancamento pa-   ³±±
//³          ³ drao 567-02                                                ³±±

User Function A390avu()        // incluido pelo assistente de conversao do AP5 IDE em 10/05/01

Local cPerg := ""       

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

SetPrvt("_NSESTSENAT,_CNATUREZA,_NCONTRPREV,nValor,_NVLPEDAGIO")
  
_nSestSenat := 0.00
_nContrPrev := 0.00
_NVLPEDAGIO := 0.00
_cNatureza := ""
nValor:=SEF->EF_VALOR

cPerg := PadR("RJU016", Len(SX1->X1_GRUPO))

RecLock("SEF", .F.)
   SED->(DbSetOrder(1))
   SED->(DbSeek(xFilial("SED")+SE5->E5_NATUREZ))
   SEF->EF_CCONTAB := SED->ED_CONTA
MsUnLock("SEF")

_cNatureza := GetMv("MV_SESTSEN")

If AllTrim(SED->ED_CODIGO) $ _cNatureza
   f_SesSen()
   f_ContrPrev()
   f_VLPedagio()
   DbSelectArea("SX1")
   SX1->(DbSetOrder(1))
   If SX1->(DbSeek(cPerg + "01",.T.))
      RecLock("SX1")
         SX1->X1_CNT01 := SEF->EF_NUM 
      MsUnLock("SX1") 
   EndIf
   If SX1->(DbSeek(cPerg + "03",.T.))
      RecLock("SX1")
         SX1->X1_CNT01 := Str(SEF->EF_SESTSENAT) 
      MsUnLock("SX1")       
   EndIf                  
   
   If SX1->(DbSeek(cPerg + "05",.T.))
      RecLock("SX1")
         SX1->X1_CNT01 := Str(SEF->EF_CPREVID) 
      MsUnLock("SX1")       
   EndIf   
   If SX1->(DbSeek(cPerg + "06",.T.))
      RecLock("SX1")
         SX1->X1_CNT01 := Str(SEF->EF_VLPEDAG) 
      MsUnLock("SX1")       
   EndIf   
EndIf   

RecLock("SEF")
   SEF->EF_VALOR:=SEF->EF_VALOR-SEF->EF_CPrevid-SEF->EF_SESTSEN+SEF->EF_VLPEDAG
MsUnLock("SEF")  

RecLock("SE5")
   SE5->E5_VALOR:=SEF->EF_VALOR
MsUnLock("SE5")

//³Funcao    ³f_SesSen  ³ Autor ³ Geandr‚ G. Oliveira   ³ Data ³ 17.09.99 ³±±
//³Descricao ³Ponto de Entrada para Gravar Valor Sest/Senat               ³±±
Static Function f_SesSen()
   f_SestSenat()
   @ 000, 000 TO 150,150 DIALOG oDlg1 TITLE "Valor do Sest/Senat"      
   @ 005, 005 TO 040,070 TITLE "Valor: R$"       
   @ 023, 010 Get _nSestSenat Picture "@E 9,999,999.99" SIZE 60,15
   @ 055, 010 BmpButton TYPE 01 Action f_GravaSest()// Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==>    @ 055, 010 BmpButton TYPE 01 Action Execute(f_Grava)
   @ 055, 045 BmpButton TYPE 02 Action Close(oDlg1)
   Activate Dialog oDlg1 Centered
Return   

//³Funcao    ³f_ContrPrev Autor ³ Ruth Lene de Zorzi    ³ Data ³06/05/2003³±±
//³Descricao ³Tela para confirmacao do valor a ser gravado no EF_CPREVI   ³±±
Static Function f_ContrPrev()
   f_ContribPrevid()
   @ 000, 000 TO 150,150 DIALOG oDlg1 TITLE "Valor da Contribuicao Previdenciaria"      
   @ 005, 005 TO 040,070 TITLE "Valor: R$"       
   @ 023, 010 Get _nContrPrev Picture "@E 9,999,999.99" SIZE 60,15
   @ 055, 010 BmpButton TYPE 01 Action f_GravaCPrev()// Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==>    @ 055, 010 BmpButton TYPE 01 Action Execute(f_Grava)
   @ 055, 045 BmpButton TYPE 02 Action Close(oDlg1)
   Activate Dialog oDlg1 Centered
Return   

//³Funcao    ³f_VLPedagio Autor ³ Ruth Lene de Zorzi    ³ Data ³02/08/2004³±±
//³Descricao ³Tela para confirmacao do valor a ser gravado no EF_CPREVI   ³±±
Static Function f_VLPEDAGIO()
   @ 000, 000 TO 150,150 DIALOG oDlg1 TITLE "Valor do Vale Pedagio"      
   @ 005, 005 TO 040,070 TITLE "Valor: R$"       
   @ 023, 010 Get _nVLPEDAGIO Picture "@E 9,999,999.99" SIZE 60,15
   @ 055, 010 BmpButton TYPE 01 Action f_GravaVLPedagio()// Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==>    @ 055, 010 BmpButton TYPE 01 Action Execute(f_Grava)
   @ 055, 045 BmpButton TYPE 02 Action Close(oDlg1)
   Activate Dialog oDlg1 Centered
Return   

//nao funcionou chamar o Recibo automaticamente para impressao, porque com isso nao faz a contabilizacao
//If MsgBox("Deseja Imprimir Recibo de Frete?","Recibo de Frete","YESNO")
//  U_Rju016()
//Endif
//Return()  


//³Funcao    ³f_GravaSest³ Autor ³ Geandr‚ G. Oliveira   ³ Data ³ 17.09.99 ³±±
//³Descricao ³Grava o valor Sest/Senat no registro de cheque               ³±±
Static Function f_GravaSest()
   DbSelectArea("SEF")
   RecLock("SEF")
      SEF->EF_SESTSEN := _nSestSenat 
      SEF->EF_VALOR   := SEF->EF_VALOR
   MsUnLock("SEF")
   Close(oDlg1)
Return
//³Funcao    ³f_GravaCPrev  ³Autor ³ Ruth Lene de Zorzi    ³ Data ³06/05/2003³±±
//³Descricao ³Grava o valor Contribuicao Previdenciaria no registro de cheque³±±

Static Function f_GravaCPrev()
   DbSelectArea("SEF")
   RecLock("SEF")
      SEF->EF_CPrevid := _nContrPrev                    
      SEF->EF_VALOR   := SEF->EF_VALOR
   MsUnLock("SEF")
   Close(oDlg1)
Return

//³Funcao    ³f_GravaVLPedagio ³Autor ³ Ruth Lene de Zorzi    ³ Data ³02/08/2004³±±
//³Descricao ³Grava o valor Vale Pedagio no registro de cheque                  ³±±
Static Function f_GravaVLPedagio()
   DbSelectArea("SEF")
   RecLock("SEF")
      SEF->EF_VLPEDAG := _nVLPedagio                    
      SEF->EF_VALOR   := SEF->EF_VALOR
   MsUnLock("SEF")
   Close(oDlg1)
Return

//³Funcao    ³f_SestSenat³ Autor ³ Geandr‚ G. Oliveira   ³ Data ³ 17.09.99 ³±±
//³Descricao ³Calcula Sest/Senat                                           ³±±
Static Function f_SestSenat()
   _nSestSenat := NoRound((((SEF->EF_VALOR*20)/100)*2.5)/100)
Return

//³Funcao    ³f_ContribPrevid Autor ³ Ruth Lene de Zorzi ³ Data ³06/05/2003³±±
//³Descri‡„o ³Calcula Contribuicao Previdenciaria                          ³±±
Static Function f_ContribPrevid()
   _nContrPrev := NoRound((((SEF->EF_VALOR*20)/100)*11)/100)
Return