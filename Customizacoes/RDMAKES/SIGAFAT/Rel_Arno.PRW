#include "rwmake.ch"

User Function Rju005()
SetPrvt("CSAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CSAVSCR1,CBTXT")
SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("CSTRING,ARETURN,NOMEPROG,NLASTKEY,CPERG,M_PAG")
SetPrvt("TREGS,M_MULT,M_SAV20,M_SAV7,NLI,NTOTITENS")
SetPrvt("NPESOLIQ,NQUANT,NPESOBRUT,NBASEICM,NTOTICM,CVAR,cMsgRed")
SetPrvt("CVAR1,_I,CMENSAGEM,CMENSAGE2,CMENSPAD,CCODTRAN")
SetPrvt("CNOMTRAN,CENDTRAN,CMUNTRAN,CESTTRAN,CCGCTRAN,CINSTRAN")
SetPrvt("CFRETE,CPLACA,CTIPOSEG,CUF,T,")
SetPrvt("xNOME_EMP,xEND_EMP,xCOMP_EMP,xBAIR_EMP,xTEL_EMP,xFAX_EMP,xCEP_EMP")
SetPrvt("xCID_EMP,xEST_EMP,xCGC_EMP,xINSC_EMP")
SetPrvt("aCols")     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//³Funcao    ³ NFSGenerica   ³            ³ Data ³24/06/2004³±±
//³Descricao ³ Nota Fiscal Saida 
//³Uso       ³ CANTU             

CbTxt     := ""
CbCont    := ""
cabec1    := ""
cabec2    := ""
cabec3    := ""
wnrel     := ""
nOrdem    := 0
Tamanho   := "M"
Limite    := 132
Titulo    := "Nota Fiscal de Saida"
cDesc1    := "Este programa tem por objetivo a impressao da Nota Fiscal de Saida"
cDesc2    := ""
cDesc3    := ""
cString   := "SF2"
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
NomeProg  := "RJU007"
nLastKey  := 0
cPerg     := "RJU007"
WnRel     := "SAIDAS"
m_Pag     := 1   //Variaveis utilizadas para Impressao do Cabecalho e Rodape
aCols     := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // Da Nota Fiscal                       ³
//³ mv_par02             // Ate a Nota Fiscal                    ³ 
//³ mv_par03             // Da Serie                             ³ 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If !Pergunte(cPerg)
   Return
EndIf

//Envia controle para a funcao SETPRINT
WnRel := SetPrint(cString, wnrel, cPerg, Titulo, cDesc1, cDesc2, cDesc3, .F.,"")

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn, cString)

If LastKey() == 27 .OR. nLastKey == 27
   Return
Endif

TRegs     := RecCount()   //Salva posicoes para movimento da regua de processamento
m_Mult    := 1

If TRegs > 0
   m_Mult := 70 / TRegs
EndIf

//³Selecao de Chaves para os arquivos                            ³
SE1->(DbSetOrder(1))               // filial+num+pref+parc Tit.Receber 
SA1->(DbSetOrder(1))               // filial+cod           Clientes
SA2->(DbSetOrder(1))               // filial+cod           Fornecedores
SA3->(DbSetOrder(1))               // filial+cod           Vendedores
SA4->(DbSetOrder(1))               // filial+cod           Transportadoras
SB1->(DbSetOrder(1))               // filial+cod           Produtos
SB5->(DbSetOrder(1))               // filial+cod           Complemento
SC5->(DbSetOrder(1))               // filial+ped           Ped. Vendas
SC6->(DbSetOrder(1))               // filial+ped+item      It. De PV
SF2->(dbSetOrder(1))               // filial+doc+serie     Cab. Nota Fiscal
SD2->(DbSetOrder(3))               // filial+doc+serie     Itens NF
SF4->(DbSetOrder(1))               // filial+cod tes       TES
SM0->(DbSetOrder(1))

dbSelectArea("SM0")                   // * Sigamat.emp
xNOME_EMP :=SM0->M0_NOMECOM
xEND_EMP  :=SM0->M0_ENDCOB  
xCOMP_EMP  :=SM0->M0_COMPCOB
xBAIR_EMP  :=SM0->M0_BAIRCOB
xTEL_EMP  :=SM0->M0_TEL
xFAX_EMP  :=SM0->M0_FAX
xCEP_EMP  :=SM0->M0_CEPCOB
xCID_EMP  :=SM0->M0_CIDCOB
xEST_EMP  :=SM0->M0_ESTCOB 
xCGC_EMP  :=SM0->M0_CGC 
xINSC_EMP :=SM0->M0_INSC
    
SF2->(DbSeek(xFilial("SF2") + Mv_Par01 + Mv_Par03, .T.))
SETPRC(0,0)
//aCols[1]:= "10"
//alert(aCols[1])
//aCols[2]:= "11"
//alert(aCols[2])

While SF2->(!Eof()) .And. SF2->F2_Filial == xFilial("SF2");
                    .And. SF2->F2_Doc    <= Mv_Par02
          
   IF LastKey() == 286
      Exit
   Endif
   
   	If !Empty(SF2->F2_FImp)
		MsgBox("Liberar Flag da NF: "+SF2->F2_Doc)
	ENdif
          
   If !Empty(SF2->F2_FImp) .Or. SF2->F2_Serie #Mv_Par03
      SF2->(DbSkip())
      Loop
   EndIf
   
   SA1->(DbSeek(xFilial("SA1") + SF2->F2_Cliente + SF2->F2_Loja))
   SA2->(DbSeek(xFilial("SA2") + SF2->F2_Cliente + SF2->F2_Loja))
   SA3->(DbSeek(xFilial("SA3") + SF2->F2_Vend1))
   SA4->(DbSeek(xFilial("SA4") + SF2->F2_Transp))
   SD2->(DbSeek(xFilial("SD2") + SF2->F2_Doc + SF2->F2_Serie))
   SC5->(DbSeek(xFilial("SC5") + SD2->D2_Pedido))
   SF4->(DbSeek(xFilial("SF4") + SD2->D2_TES))
   SM4->(DbSeek(xFilial("SM4") + SC5->C5_MenPad))
                                               
   nLi        := 0
   nTotItens  := 18                   
   
   @ 00        ,  00 PSay Chr(27) + Chr(120) + Chr(0)
   @ 00        ,  00 PSay Chr(27) + Chr(15)
   @ PRow() + 1, 123 PSay SF2->F2_Doc
   @ PRow() + 1, 031 PSay ""//AllTrim(xEND_EMP)+" "+AllTrim(xCOMP_EMP)+" "+AllTrim(xBAIR_EMP)
   @ PRow()    , 063 PSay "XX"   
   @ PRow() + 1, 031 PSay ""//"FONE: ("+SubStr(xTEL_EMP,2,2)+") "+SubStr(xTEL_EMP,4,8)+" - "
   @ PRow()    , 063 PSay ""//"CEP:  "+SubStr(xCEP_EMP,1,5)+"-"+SubStr(xCEP_EMP,6,3)
   @ PRow() + 1, 031 PSay ""//xCID_EMP+" "+xEST_EMP
   @ PRow()    , 092 PSay ""//xCGC_EMP
   @ PRow() + 2,  02 PSay SF4->F4_Texto
   @ PRow()    ,  43 PSay SD2->D2_CF                Picture "@R 9.999"
   @ PRow()    , 092 PSay ""//xINSC_EMP
   @ PRow() + 3,  02 PSay Iif(SF2->F2_Tipo $ "BD", SA2->A2_Cod , SA1->A1_Cod ) + ' -'
   @ PRow()    ,  11 PSay Iif(SF2->F2_Tipo $ "BD", SA2->A2_Nome, SA1->A1_Nome)
   @ PRow()    ,  92 PSay Iif(SF2->F2_Tipo $ "BD", SA2->A2_CGC , SA1->A1_CGC )  Picture Iif(SA1->A1_Tipo == "F", "@R 999.999.999-99", "@R 99.999.999/9999-99")
                  
   @ PRow()    , 126 PSay SF2->F2_Emissao
   @ PRow() + 2,  02 PSay Iif(SF2->F2_Tipo $ "BD", SA2->A2_End   , SA1->A1_End)
   @ PRow()    ,  72 PSay Iif(SF2->F2_Tipo $ "BD", SA2->A2_Bairro, SA1->A1_Bairro)
   @ PRow()    , 100 PSay Iif(SF2->F2_Tipo $ "BD", SA2->A2_Cep   , SA1->A1_Cep)
   @ PRow()    , 126 PSay SF2->F2_Emissao      
   @ PRow() + 2,  02 PSay Iif(SF2->F2_Tipo $ "BD", SA2->A2_Mun  , SA1->A1_Mun)
   @ PRow()    ,  59 PSay Iif(SF2->F2_Tipo $ "BD", SA2->A2_Tel  , SA1->A1_Tel)  Picture "@R (999)999-9999 9999"
   @ PRow()    ,  80 PSay Iif(SF2->F2_Tipo $ "BD", SA2->A2_Est  , SA1->A1_Est)

   IF AllTrim(SA1->A1_Inscr) #'I S E N T O'
      @ PRow()    ,  92 PSay Iif(SF2->F2_Tipo $ "BD", SA2->A2_Inscr, SA1->A1_Inscr)
   EndIf
//   @ PRow()    , 126 PSay Time()          //hora   
//   @ PRow() + 3,  00 PSay ''
   @ pRow() + 2, 00   PSay Chr(27) + Chr(15)   
   nPesoLiq  := 0
   nQuant    := 0
   nPesoBrut := 0
   nBaseICM  := 0
   nTotICM   := 0
   cVar      := Space(30)
   cVar1     := Space(30)
   cMsgRed   := Space(30)
   @ pRow()+3, 00   PSay Chr(27) + Chr(15)   
   While !SD2->(Eof()) .And. SD2->D2_Filial == xFilial("SD2");
                       .And. SD2->D2_Doc    == SF2->F2_Doc;
                       .And. SD2->D2_Serie  == SF2->F2_Serie 
          
      SB1->(DbSeek(xFilial("SB1")+SD2->D2_Cod))       // PRODUTO
      SB5->(DbSeek(xFilial("SB5")+SD2->D2_Cod))       // COMPL. DE PRODUTO
      SC6->(DbSeek(xFilial("SC6")+SD2->D2_Pedido + SD2->D2_ItemPV))
      SF4->(DbSeek(xFilial("SF4") + SD2->D2_TES))
//ALTERADO PARA CHAMAR A GERACAO DO PARTICULAR AO TERMINO DA IMPRESSAO DA NF  **INICIO
/*
      IF SC6->C6_VALVEND > 0
         _PART := 1
      End If   
*/
//ALTERADO PARA CHAMAR A GERACAO DO PARTICULAR AO TERMINO DA IMPRESSAO DA NF  **FIM
      If Len(Alltrim(SC6->C6_DESCRI)) > 50
         nLi  := nLi + 2
      Else
         nLi  := nLi + 1
      Endif
      
      @ pRow()+1, 00   PSay Chr(27) + Chr(15)
      @ pRow()  , 002  PSay SD2->D2_Cod      
      cMsgRed   := Space(30)      
      IF SUBSTR(SC6->C6_DESCRI,1,4)=="MACA"
      	cMsgRed := Formula("RED")
      ENDIF
      For _i:=1 to Len(SC6->C6_DESCRI)

          @ pRow()  , 011  PSay Substr(SC6->C6_DESCRI,_i,50)

          _i := _i + 49

          If Len(Alltrim(SC6->C6_DESCRI)) > 50 .and. _i < 99
             @ pRow() + 1 , 00  PSay Chr(27) + Chr(15)  //""
          Endif

      Next

//17/07      If Iif(SF2->F2_Tipo $ "BD", SA2->A2_Est == 'PR', SA1->A1_Est == 'PR')
      @ pRow()  , 060  PSay SB1->B1_Origem+SF4->F4_SITTRIB
//17/07      Else
//17/07         iF !Empty(SB1->B1_SitTrib)
//17/07            @ pRow()  , 068  PSay SB1->B1_SitTrib
//17/07         Else
//17/07         @ pRow()  , 068  PSay SB1->B1_Origem+SF4->F4_SITTRIB
//17/07         EndIf            
//17/07      EndIf
                                 

	If SC6->C6_IMPUNI == "1"	// IMPRESSAO 1 UN MEDIDA
		  @ pRow()  , 064  PSay SD2->D2_UM
    	  @ pRow()  , 065  PSay SD2->D2_Quant    Picture "@E 999999.99"
	      @ pRow()  , 078  PSay SD2->D2_PrcVen   Picture "@E 9999999999.99"
    	  @ pRow()  , 097  PSay SD2->D2_Total    Picture "@E 9999999999.99"
          nPesoLiq := nPesoLiq  + (SB1->B1_Peso * SD2->D2_Quant)
          nPesoBrut := nPesoBrut + (SB1->B1_PesBru * SD2->D2_Quant)
	Else	// IMPRESSAO 2 UN MEDIDA
	      @ pRow()  , 064  PSay SD2->D2_SEGUM 
          // Alterado por0 Geraldo em 26/05/2005 para corrigir erro de conversão de/para segunda unidade de medida
          // Não deverá ser feito faturamento parcial para que esta rotina funcione carretamente
    	  @ pRow()  , 065  PSay SC6->C6_UNSVEN    Picture "@E 999999.99" 
	      @ pRow()  , 078  PSay IIF(SB1->B1_TIPCONV=="M",SC6->C6_PrcSu,SD2->D2_PrcVen*SB1->B1_CONV)   Picture "@E 9999999999.99" //SD2->D2_PrcVen
//    	  @ pRow()  , 077  PSay (SD2->D2_QUANT*SB1->B1_CONV)    Picture "@E 999999.99" //SD2->D2_QUANT
//	      @ pRow()  , 093  PSay (SD2->D2_PRCVEN/SB1->B1_CONV)   Picture "@E 9999999999.99" //SD2->D2_PrcVen
    	  @ pRow()  , 097  PSay SD2->D2_TOTAL    				Picture "@E 9999999999.99"
          nPesoLiq := nPesoLiq  + ((SB1->B1_Peso)/SB1->B1_Conv)*(SC6->C6_UNSVEN)
          nPesoBrut := nPesoBrut +((SB1->B1_PesBru)/SB1->B1_Conv)*(SC6->C6_UNSVEN)
    Endif
      
      If SF4->F4_LFICM == 'T'.OR. SF4->F4_LFICM == 'O'
         @ pRow()  , 117  PSay SD2->D2_PICM     Picture "@E 99.99"
         
         nBaseICM := nBaseIcm + SD2->D2_BaseICM
         nTotICM  := nTotIcm  + SD2->D2_ValICM
         If SA1->A1_EST == 'PR'
             cVar  := Formula("ICM")
	         If SD2->D2_TES == '710'         //incluido por causa do ICMS diferido do pinhão para dentro do estado
    	      	cVar1 := Formula("PIN")
        	 EndIf 
         EndIf
      Else
         cVar1 := Formula("ISE")
      EndIf
      nQuant   := nQuant    + SD2->D2_Quant
//      If SB1->B1_PBruto > 0
//         nPesoBrut := nPesoBrut + (SB1->B1_PBruto * SD2->D2_Quant)
//      Else
//      EndIf
      SD2->(DbSkip())     // Salta para proximo item
   End
   @ pRow() + (nTotItens - nLI) +1, 001 PSay 'RECLAMACOES SOBRE A MERCADORIA SERAO ACEITAS SOMENTE NO DIA DA DESCARGA'   
   @ pRow() + 3, 00   PSay Chr(27) + Chr(15)   
//   @ pRow() + 3, 000 PSay ''
   
   If nBaseICM > 0 .And. nTotICM > 0
      @ pRow()   , 009 PSay nBaseICM   Picture "@E 999,999,999.99"
      @ pRow()   , 033 PSay nTotICM    Picture "@E 999,999.99"
   EndIf

   If SF2->F2_BrIcms > 0 
      @ pRow()   , 057 PSay SF2->F2_BrIcms   Picture "@E 999,999,999.99"
      @ pRow()   , 093 PSay SF2->F2_IcmsRet  Picture "@E 999,999.99"
   EndIf
   

   @ pRow()    , 120 PSay SF2->F2_ValMerc    Picture "@E 999,999,999.99"

   @ pRow() + 2, 00   PSay Chr(27) + Chr(15)      
   
   If SF2->F2_Frete > 0
      @ pRow()    , 009 PSay SF2->F2_Frete    Picture "@E 999,999,999.99"
   EndIf
   
   If SF2->F2_Seguro > 0
      @ pRow()    , 033 PSay SF2->F2_Seguro   Picture "@E 999,999.99"
   EndIf

   @ pRow()   , 093 PSay SF2->F2_ValIpi   Picture "@E 999,999,999.99"
  
   If SF2->F2_ValMerc > 0
      @ pRow()    , 120 PSay SF2->F2_ValBrut  Picture "@E 999,999,999.99"
   EndIf
      
   //*****************************************************************
   
   cMensagem := SC5->C5_MenNota
   cMensage2 := Space(40) //SC5->C5_MenNot2
   cMensPad  := SC5->C5_MenPad
   cCodTran  := SA4->A4_Cod
   cNomTran  := SA4->A4_Nome
   cEndTran  := SA4->A4_End
   cMunTran  := SA4->A4_Mun
   cEstTran  := SA4->A4_Est
   cCgcTran  := SA4->A4_Cgc
   cInsTran  := SA4->A4_InsEst
   cFrete    := '1'
   cPlaca    := Space(8)
   cUF       := Space(2)
   cTipoSeg  := Space(6)

   @ 100, 100 To 380, 650 Dialog oDlg Title "Mensagem"
   @  10,  10 Say "Nota Fiscal"
   @  10, 130 Say "Pedido" 
   @  20,  10 Say "Cliente"  
   @  40,  10 Say "Transportador" 
   @  50,  10 Say "Endereco"
   @  60,  10 Say "Municipio"
   @  60, 175 Say "Estado"
   @  70,  10 Say "Cgc"
   @  70, 175 Say "Insc. Est."
   @  80,  10 Say "Frete"
   @  80,  75 Say "Placa"
   @  80, 175 Say "Estado"
   @  90,  10 Say "Tipo de Seguro: RCTR-C/RR"
   @ 100,  10 Say "Mensagem"
   @ 110,  10 Say "Mensagem"
   
   @  10,  55 Say SF2->F2_Serie + '/' + SF2->F2_Doc
   @  10, 155 Say SD2->D2_Pedido
   @  20,  55 Say SA1->A1_Cod + '/' + SA1->A1_Loja + ' - ' + SA1->A1_Nome
   
   @  40,  55 Get cCodTran Picture "@S6" Valid Atualiza() F3 "SA4"// Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==>    @  40,  55 Get cCodTran Picture "@S6" Valid Execute(Atualiza) F3 "SA4"
   @  40, 105 Get cNomTran Picture "@S28"                   When Empty(cCodTran)
   @  50,  55 Get cEndTran Picture '@S37'                   When Empty(cCodTran)
   @  60,  55 Get cMunTran Picture '@S20'                   When Empty(cCodTran)
   @  60, 250 Get cEstTran Picture '@! XX'                  When Empty(cCodTran)
   @  70,  55 Get cCgcTran                                  When Empty(cCodTran)
   @  70, 205 Get cInsTran Picture '@S10'                   When Empty(cCodTran)
   @  80,  55 Get cFrete   Valid Pertence("12")
   @  80,  95 Get cPlaca   Picture '@!S10 XXX-XXXX'
   @  80, 250 Get cUF      Picture '@! XX'
   @  90,  95 Get cTipoSeg Picture '@!S10 XXX X'  
   @ 100,  55 Get cMensagem Picture '@S37'
   @ 110,  55 Get cMensage2 Picture '@S37'
   @ 120,  55 Get cMensPad Valid ChSM4() F3 "SM4"// Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==>    @ 120,  55 Get cMensPad Valid Execute(ChSM4) F3 "SM4"
   @ 120, 100 Say SM4->M4_DESCR Size(200)
   
   @ 120, 235 BmpButton Type 01 Action Close(oDlg)
   Activate Dialog oDlg Center
   
   //*****************************************************************
 
   /*
   RecLock("SC5",.F.)
     SC5->C5_TPFRETE := IIf(cFrete == "1", "C", "F")
     SC5->C5_MENNOTA := cMensagem
     SC5->C5_MENPAD  := cMensPad
	 //SC5->C5_MenNot2 := cMensage2
   MsUnLock("SC5")
   */
 
   @ pRow()+3, 002 PSay cCodTran + ' - ' + cNomTran
   @ pRow()  , 076 PSay IIf(SC5->C5_TpFrete == "C", "1", "2")
   @ pRow()  , 085 PSay cPlaca      Picture "XXX-XXXX"
   @ pRow()  , 101 PSay cUF   
   @ pRow()  , 113 PSay Transf(cCgcTran, "@R 99.999.999/9999-99")
   @ pRow()+2, 002 PSay cEndTran
   @ pRow()  , 061 PSay cMunTran
   @ pRow()  , 101 PSay cEstTran
   @ pRow()  , 113 PSay cInsTran
               
   @ pRow()+2, 002 PSay nQuant     Picture "@E 99999.99"   //SC5->C5_Volume1 
   @ pRow()  , 021 PSay SC5->C5_Especi1   //DIVERSOS
   @ pRow()  , 102 PSay nPesoBrut  Picture "@E 99999.999"
   @ pRow()  , 126 PSay nPesoLiq   Picture "@E 99999.999"

   @ pRow() + 2, 00   PSay Chr(27) + Chr(15)      
//   @ pRow()+1, 00         PSay ''
     
   DbSelectArea("SM4")
   SM4->(DbSetOrder(1))
   SM4->(DbSeek(xFilial("SM4") + UPPER(SC5->C5_MenPad)))
//   alert(SM4->M4_FORMULA)

   If !Empty(SC5->C5_MenPad)   
      If Upper(Left(SM4->M4_Formula, 9)) == 'EXECBLOCK'
         T := Formula(SC5->C5_MenPad)
      Else
         @ pRow() + 1, 00   PSay Chr(27) + Chr(15)   
//         @ PRow()+1, 00 PSay ''
//       cVar := Formula(SC5->C5_MenPad)
      EndIf
   EndIf

//   @ PRow()+1, 00 PSay cVar

   @ PRow()+1, 01 PSay cVar1
   @ PRow()+1, 01 PSay cMsgRed
   @ PRow()+1, 01 PSay 'Pedido: ' + SC5->C5_NUM
   @ PRow()+0, PCol() + 2 PSay '( ' + SF2->F2_Vend1 + ' )'
   @ PRow()+1, 01 PSay "Hortifruti aliquota zero PIS/COFINS cfe. lei 10865 art. 28 inc. III."
   @ PRow()+1, 01 PSay cMensagem
   @ PRow()+1, 01 PSay cMensage2
   
   @ 62, 07 PSay SF2->F2_Emissao
   
   If (SF2->F2_TIPO == "D") .OR. (SF2->F2_TIPO == "B")
      @ PRow(),  30 PSay SA2->A2_Cod + '/' + SA2->A2_Loja + ' - ' + SA2->A2_Nome
   else
      @ PRow(),  30 PSay SA1->A1_Cod + '/' + SA1->A1_Loja + ' - ' + SA1->A1_Nome
   endIf   
   @ PRow(),  93 PSay SF2->F2_ValBrut  Picture "@E 999,999,999.99"      
   @ PRow(), 123 PSay SF2->F2_Doc
   
   RecLock("SF2",.f.)
     SF2->F2_Pliqui := nPesoBrut
     SF2->F2_Pbruto := nPesoLiq      
     SF2->F2_FImp   := 'x'    
     SF2->F2_PLACA  := cPlaca 
     SF2->F2_TIPOSEG:= cTipoSeg
   MsUnlock("SF2")
   
   SF2->(DbSkip())
//@ prOW()+NLIN, 00 pSAY ""
End

Eject   // 11/11/2002  BIN 06/11/2002
SETPRC(0,0)
Set Printer To
Set Device To Screen
SetPgEject(.F.) 
Ms_Flush()                            //Libera fila de relatorios em spool

//RestScreen(3, 0, 24, 79, cSavScr1)

If aReturn[5] == 1
   Set Printer TO 
   OurSpool(WnRel)
Endif
//ALTERADO PARA CHAMAR A GERACAO DO PARTICULAR AO TERMINO DA IMPRESSAO DA NF
//RJU015()
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Descricao ³ Funcoes de Validacao p/ Atualizacao de Variaveis           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CANTU                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==> Function ChSM4
Static Function ChSM4()
DbSelectArea("SM4")
SM4->(DbSetOrder(1))
SM4->(DbSeek(xFilial("SM4") + cMensPad))
iF SM4->(!Found()) .And. !Empty(cMensPad)
   Return .F.
Else
   Return .T.
EndIf


// Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==> Function Atualiza
Static Function Atualiza()
DbSelectArea("SA4")
SA4->(DbSetOrder(1))
SA4->(DbSeek(xFilial("SA4") + cCodTran))
cNomTran  := SA4->A4_Nome
cEndTran  := SA4->A4_End
cMunTran  := SA4->A4_Mun
cEstTran  := SA4->A4_Est
cCgcTran  := SA4->A4_Cgc
cInsTran  := SA4->A4_InsEst
// Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==> __Return(.T.)
Return(.T.)        // incluido pelo assistente de conversao do AP5 IDE em 10/05/01
