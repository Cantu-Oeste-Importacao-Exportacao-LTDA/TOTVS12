#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 10/05/01

User Function Rju017()        // incluido pelo assistente de conversao do AP5 IDE em 10/05/01
Local aArea := GetArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("AMOEDAS,AHEADER,NMOEDA,NTOTTIT,NXMOEDA,NTITULO")
SetPrvt("ACOLS,COBS,NTOTPART,NCONT,CCODTRAN,CUF")
SetPrvt("CPLACA,CNOMTRAN,CENDTRAN,CMUNTRAN,CESTTRAN,ACOTACAO")

//
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Fun‡„o    ³RJU017    ³       ³                       ³      ³ 05.11.98 ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descri‡„o ³Impressao dos Comprovantes de Entrada de Mercadorias.       ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
  
aMoedas   := {GetMv("MV_Moeda1"), GetMv("MV_Moeda2"), GetMv("MV_Moeda3"), GetMv("MV_Moeda4"), GetMv("MV_Moeda5")}
aHeader   := {}
nMoeda    := 1

DbSelectArea("SX3")
SX3->(DbSetOrder(2))

SX3->(DbSeek("D1_COD"))

Aadd(aHeader, {Trim(SX3->X3_Titulo) , SX3->X3_Campo   , SX3->X3_Picture        ,;
               SX3->X3_Tamanho      , SX3->X3_Decimal , ".F."                  ,;
               SX3->X3_Usado        , SX3->X3_Tipo    , SX3->X3_Arquivo        ,;
               SX3->X3_Context })

SX3->(DbSeek("D1_LOCAL"))

Aadd(aHeader, {Trim(SX3->X3_Titulo) , SX3->X3_Campo   , SX3->X3_Picture        ,;
               SX3->X3_Tamanho      , SX3->X3_Decimal , ".F."                  ,;
               SX3->X3_Usado        , SX3->X3_Tipo    , SX3->X3_Arquivo        ,;
               SX3->X3_Context })

SX3->(DbSeek("D1_QUANT"))

Aadd(aHeader, {Trim(SX3->X3_Titulo) , SX3->X3_Campo   , SX3->X3_Picture        ,;
               SX3->X3_Tamanho      , SX3->X3_Decimal , ".F."                  ,;
               SX3->X3_Usado        , SX3->X3_Tipo    , SX3->X3_Arquivo        ,;
               SX3->X3_Context })

SX3->(DbSeek("D1_VUNIT"))

Aadd(aHeader, {Trim(SX3->X3_Titulo) , SX3->X3_Campo   , SX3->X3_Picture     ,;
               SX3->X3_Tamanho      , SX3->X3_Decimal , "ExecBlock('_Valid02', .F., .F.)",;
               SX3->X3_Usado        , SX3->X3_Tipo    , SX3->X3_Arquivo     ,;
               SX3->X3_Context })

SX3->(DbSeek("D1_TOTAL"))

Aadd(aHeader, {Trim(SX3->X3_Titulo) , SX3->X3_Campo   , SX3->X3_Picture     ,;
               SX3->X3_Tamanho      , SX3->X3_Decimal , "ExecBlock('_Valid02', .F., .F.)",;
               SX3->X3_Usado        , SX3->X3_Tipo    , SX3->X3_Arquivo     ,;
               SX3->X3_Context })

If !Pergunte("RJU017") 
	Return
EndIf

if !empty(MV_PAR04)
	DbSelectArea("SF1")
	SF1->(DbSetOrder(1))
	If !SF1->(DbSeek(xFilial("SF1") + MV_Par01 + MV_Par03 + MV_PAR04 + MV_PAR06, .T.))
		Aviso("Atenção","Nenhum documento encontrado para os parâmetros informados!")	
	End
elseIf !empty(mv_par05)
	DbSelectArea("SF1")
	SF1->(DbSetOrder(1))
	If !SF1->(DbSeek(xFilial("SF1") + MV_Par01 + MV_Par03 + MV_PAR05 + MV_PAR06, .T.))
		Aviso("Atenção","Nenhum documento encontrado para os parâmetros informados!")		
	End
endIf
 
While SF1->(!Eof()) .And. SF1->F1_Filial == xFilial("SF1");
                    .And. SF1->F1_Doc    <= Mv_Par02
          
   If SF1->F1_Serie #Mv_Par03
      SF1->(DbSkip())
      Loop
   EndIf

   If SF1->F1_FORNECE #Mv_Par04 .and. !Empty(Mv_Par04)
      SF1->(DbSkip())
      Loop
   EndIf
   
   If SF1->F1_FORNECE #Mv_Par05 .and. !Empty(Mv_Par05)//alteramos o campo Mv_par04 para Mv_Par05 - Alessandro 
      SF1->(DbSkip())
      Loop
   EndIf
   
   //Roberto -> adicionado MV_PAR06 para filtrar a loja do cliente
   if SF1->F1_LOJA #MV_PAR06 .and. !empty(MV_PAR06)
		  SF1->(DbSkip())
		  Loop
   endIf
   
   nTitulo := 0 
    
   DbSelectArea("SD1")
   SD1->(DbSetOrder(1))
   SD1->(DbSeek(xFilial("SD1") + SF1->F1_Doc     + SF1->F1_Serie;
                               + SF1->F1_Fornece + SF1->F1_Loja))  
   
   DbSelectArea("SA2")
   SA2->(DbSetOrder(1))
   SA2->(DbSeek(xFilial("SA2") + SF1->F1_Fornece + SF1->F1_Loja))
    
   //Dioni -> posiciona o cliente conforme o paramentro 05                         
   DbSelectArea("SA1")	//** Posiciona no Cliente do Titulo
	 SA1->(DbSetOrder(1))
   SA1->(DbSeek(xFilial("SA1") + SF1->F1_Fornece + SF1->F1_LOJA))
       
   aCols     := {}
   cOBS      := Space(50)
   nTotPart  := 0
   nCont     := 0   
   cCodTran  := Space(6)
   cUF       := Space(2)
   cPlaca    := Space(8)
   cNomTran  := SA4->A4_Nome
   cEndTran  := SA4->A4_End
   cMunTran  := SA4->A4_Mun
   cEstTran  := SA4->A4_Est
   cBanco    := ""
   While SD1->D1_Filial == xFilial("SD1") .And. SD1->D1_Doc     == SF1->F1_Doc;
                                          .And. SD1->D1_Serie   == SF1->F1_Serie;
                                          .And. SD1->D1_Fornece == SF1->F1_Fornece;
                                          .And. SD1->D1_Loja    == SF1->F1_Loja
     nTitulo := 1
     
     Aadd(aCols, Array(6))
     nCont := nCont + 1
     
     aCols[nCont][1] := SD1->D1_Cod
     aCols[nCont][2] := SD1->D1_Local
     aCols[nCont][3] := SD1->D1_Quant
     aCols[nCont][4] := SD1->D1_VUnit
     aCols[nCont][5] := SD1->D1_Total       
     aCols[nCont][6] := .F.
      
     SD1->(DbSkip())
   End
                   
   IF nTitulo > 0 .and. !Empty(MV_PAR04)     // Retirado o campo If nTitulo > 0 .and. MV_PAR04 <> '' - Alessandro 
      @ 200, 1 To 500, 610 Dialog oDlg1 Title "Particular - Pedidos de Venda"
      
      @ 5, 5 To 93, 300 Multiline Modify
      
      @ 100, 250 Button "_Ok" Size 50, 20 Action Particular()// Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==>       @ 100, 250 Button "_Ok" Size 50, 20 Action Execute(Particular)
      
      @ 100,  10 Say "Nota Fiscal:"
      @ 100,  50 Say SF1->F1_Serie + ' / ' + SF1->F1_Doc
      @ 110,  10 Say "Fornecedor:"
      @ 110,  50 Say SF1->F1_Fornece + '/' + SF1->F1_Loja + ' - ' + SA2->A2_Nome
      @ 135,  10 Say "Observacoes:"
      @ 135,  50 Get cOBS                 Picture '@!S42'
       
      Activate Dialog oDlg1 Centered            
   
   ElseIf !Empty(MV_PAR05) // Retirado o campo If nTitulo > 0 .and. MV_PAR05 <> '' - Alessandro 
      @ 200, 1 To 500, 610 Dialog oDlg1 Title "Particular - Pedidos de Venda"
      
      @ 5, 5 To 93, 300 Multiline Modify
      
      @ 100, 250 Button "_Ok" Size 50, 20 Action Particular()// Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==>       @ 100, 250 Button "_Ok" Size 50, 20 Action Execute(Particular)
      
      @ 100,  10 Say "Nota Fiscal:"
      @ 100,  50 Say SF1->F1_Serie + ' / ' + SF1->F1_Doc
      @ 110,  10 Say "Cliente:"
      @ 110,  50 Say SA1->A1_COD + '/' + SF1->F1_Loja + ' - ' + SA1->A1_Nome
      @ 135,  10 Say "Observacoes:"
      @ 135,  50 Get cOBS                 Picture '@!S42'
       
      Activate Dialog oDlg1 Centered            
   endif   
   If nTitulo < 0 
      MsgInfo("Nao Existem registros que atendam aos parametros!!!")   
   EndIf
   
   SF1->(DbSkip())           
End
           
Ms_Flush()
Set Printer to
Set Device To Screen
RestArea(aArea)
Return
       

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Fun‡„o    ³Particular³       ³                       ³      ³ 22.09.98 ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descri‡„o ³Entrada dos dados do particular de Carga.                   ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
  
// Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==> Function Particular
Static Function Particular()
Local aDup:= {}
Local aArea := GetArea()
@ 100, 100 To 380, 650 Dialog oDlg Title "Particular"
@  10,  10 Say "Nota Fiscal"
@  10, 130 Say "Pedido" 

IF !Empty(MV_PAR04)
   @  20,  10 Say "Fornecedor"
else                          
   @  20,  10 Say "Cliente"
endif   
@  40,  10 Say "Nome"
@  50,  10 Say "Endereco"
@  60,  10 Say "Municipio"
@  60, 175 Say "Estado"
@  70,  10 Say "Placa"
@  70, 175 Say "Estado"

@  10,  55 Say SF1->F1_Serie + '/' + SF1->F1_Doc
@  10, 155 Say SD1->D1_Pedido 
IF !Empty(MV_PAR04)
   @  20,  55 Say SA2->A2_Cod + '/' + SA2->A2_Loja + ' - ' + SA2->A2_Nome
else
   @  20,  55 Say SA1->A1_Cod + '/' + SA1->A1_Loja + ' - ' + SA1->A1_Nome
endif   
@  40,  55 Get cCodTran  Picture "@S6" Valid Atualiza() F3 "SA4"// Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==> @  40,  55 Get cCodTran  Picture "@S6" Valid Execute(Atualiza) F3 "SA4"
@  40, 105 Get cNomTran  Picture "@S28"                   When Empty(cCodTran)
@  50,  55 Get cEndTran  Picture '@S37'                   When Empty(cCodTran)
@  60,  55 Get cMunTran  Picture '@S20'                   When Empty(cCodTran)
@  60, 250 Get cEstTran  Picture '@! XX'                  When Empty(cCodTran)
@  70,  55 Get cPlaca    Picture '@!S10 XXX-XXXX'
@  70, 250 Get cUF       Picture '@! XX'

@ 120, 235 BmpButton Type 01 Action Close(oDlg)

Activate Dialog oDlg Center

aCotacao := FuncaMoeda(SF1->F1_Emissao, 1, 1)

DbSelectArea("SE2")
SE2->(DbSetOrder(6))
if (SE2->(DbSeek(xFilial("SE2") + SF1->F1_Fornece + SF1->F1_Loja;
                            + SF1->F1_Serie   + SF1->F1_Doc)))
	nXMoeda    := SE2->E2_Moeda                            
else
	nXMoeda    := 1
EndIf

If nXMoeda #1
   For nCont := 1 To Len(aCols)
       aCols[nCont][4] := aCols[nCont][4] / aCotacao[nXMoeda]
       aCols[nCont][5] := aCols[nCont][5] / aCotacao[nXMoeda]
   Next
EndIf

If MsgBox("Imprimir Comprovante de Entrada?","Comprovante","YESNO")
   cString   := "SF1"  // nome do arquivo a ser impresso
   tamanho   := "P"    // P(80c), M(132c),G(220c)
   nLastKey  := 0
   titulo    := "TITULO DA CABECALHO"
   cDesc1    := "Este programa listara ......."
   cDesc2    := "continua descricao .........."
   cDesc3    := "continua descricao .........." 
   cabec1    := "Linha1 do titulo de cabecalhos"
   cabec2    := "Linha2 do titulo de cabecalhos"
   aReturn   := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
   nomeprog  := "RJU017"  // nome do programa que aparece no cabecalho do relatorio
   wnrel     := "RJU017"  // nome do arquivo que sera gerado em disco
   m_pag     :=  1         // Variavel que acumula numero da pagina
   wnrel:=SetPrint(cString,wnrel,,titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,tamanho)
   If nLastKey == 27
      Return
   Endif
	
   SetDefault(aReturn,cString)
   If nLastKey == 27
      Return
   Endif

   SetPrc(0,0)
   @ 00        , 00 Psay AvalImp(80)	
   @ 00        , 00 PSay Chr(27) + Chr(120) + Chr(0) //Modo Draft
   @ 00        , 00 PSay Chr(17)
   @ 00        , 00 PSay Chr(27) + Chr(67) + Chr(33)
   @ 00        , 00 PSay Chr(27) + Chr(18)
	//Gustavo 23/01/15 - Alterado para mostrar a empresa e filial	
   @ 02        , 00          PSay 'Empresa:' 
   @ PRow()    , PCol() + 01 PSay  SM0->M0_CODIGO + '/' + SF1->F1_FILIAL
   @ PRow()    , PCol() + 02 PSay 'Documento:'
   @ PRow()    , PCol() + 01 PSay  SF1->F1_Doc + '/' + SF1->F1_Serie   
   @ PRow()    , PCol() + 03 PSay 'Emissao:'
   @ PRow()    , PCol() + 01 PSay SF1->F1_Emissao 
   @ PRow()    , PCol() + 03 PSay 'Digitação:'
   @ PRow()    , PCol() + 01 PSay SF1->F1_DTDIGIT   

IF !Empty(MV_PAR04)   
   If Empty(cCodTran) .And. Empty(cNomTran)
      @ PRow() + 2, 00          PSay 'Fornecedor:'
      @ PRow()    , PCol() + 02 PSay SA2->A2_Cod + '/' + SA2->A2_Loja + ' - ' + SA2->A2_Nome
      @ PRow() + 1, 00          PSay 'CNPJ/CPF  :'
      @ PRow()    , PCol() + 02 PSay SA2->A2_CGC Picture Iif(SA2->A2_Tipo == "F", "@R 999.999.999-99", "@R 99.999.999/9999-99")
      @ PRow() + 1, 00          PSay 'Endereco  :'
      @ PRow()    , PCol() + 02 PSay SA2->A2_End
      @ PRow() + 1, 00          PSay 'Cidade    :'
      @ PRow()    , PCol() + 02 PSay SA2->A2_Mun
      @ PRow()    , PCol() + 01 PSay ' - ' + SA2->A2_Est
      @ PRow() + 1,          00 PSay Repli('-', 80)
     // @ PRow() + 1,          00 PSay 'Produto'
      @ PRow() + 1,          00 PSay 'CODIGO   PRODUTO                      U.M.    QTDE.     VLR UNIT.     VLR. TOTAL'
      @ PRow() + 1,          00 PSay Repli('-', 80)
   Else
      @ PRow() + 2, 00          PSay 'Fornecedor:  '
      @ PRow()    , PCol() + 02 PSay cNomTran
      @ PRow() + 1, 00          PSay 'Endereco:    '
      @ PRow()    , PCol() + 02 PSay cEndTran
      @ PRow() + 1, 00          PSay 'Cidade:      '
      @ PRow()    , PCol() + 02 PSay cMunTran
      @ PRow()    , PCol() + 01 PSay ' - ' + cEstTran
      @ PRow() + 1,          00 PSay Repli('-', 80)
//                                    123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
      @ PRow() + 1,          00 PSay 'CODIGO   PRODUTO                      U.M.    QTDE.     VLR UNIT.     VLR. TOTAL'
      @ PRow() + 1,          00 PSay Repli('-', 80)      
   EndIf
        
ELSE
   If Empty(cCodTran) .And. Empty(cNomTran)
      @ PRow() + 2, 00          PSay 'Cliente:'
      @ PRow()    , PCol() + 02 PSay SA1->A1_Cod + '/' + SA1->A1_Loja + ' - ' + SA1->A1_Nome
      @ PRow() + 1, 00          PSay 'CNPJ/CPF  :'
      @ PRow()    , PCol() + 02 PSay SA1->A1_CGC Picture Iif(SA1->A1_Tipo == "F", "@R 999.999.999-99", "@R 99.999.999/9999-99")
      @ PRow() + 1, 00          PSay 'Endereco  :'
      @ PRow()    , PCol() + 02 PSay SA1->A1_End
      @ PRow() + 1, 00          PSay 'Cidade    :'
      @ PRow()    , PCol() + 02 PSay SA1->A1_Mun
      @ PRow()    , PCol() + 01 PSay ' - ' + SA1->A1_Est
      @ PRow() + 1,          00 PSay Repli('-', 80)
     // @ PRow() + 1,          00 PSay 'Produto'
      @ PRow() + 1,          00 PSay 'CODIGO   PRODUTO                      U.M.    QTDE.     VLR UNIT.     VLR. TOTAL'
      @ PRow() + 1,          00 PSay Repli('-', 80)
   Else
      @ PRow() + 2, 00          PSay 'Cliente:  '
      @ PRow()    , PCol() + 02 PSay cNomTran
      @ PRow() + 1, 00          PSay 'Endereco:    '
      @ PRow()    , PCol() + 02 PSay cEndTran
      @ PRow() + 1, 00          PSay 'Cidade:      '
      @ PRow()    , PCol() + 02 PSay cMunTran
      @ PRow()    , PCol() + 01 PSay ' - ' + cEstTran
      @ PRow() + 1,          00 PSay Repli('-', 80)
//                                    123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
      @ PRow() + 1,          00 PSay 'CODIGO   PRODUTO                      U.M.    QTDE.     VLR UNIT.     VLR. TOTAL'
      @ PRow() + 1,          00 PSay Repli('-', 80)      
   EndIf
    
ENDIF 
   
   For nCont := 1 To Len(aCols)
       SB1->(DbSetOrder(1))
       SB1->(DbSeek(xFilial("SB1") + aCols[nCont][1]))
       
       @ PRow() + 1,         00 PSay Left(aCols[nCont][1], 9)
//       @ PRow()    , PCol()     PSay '/' + aCols[nCont][2]
       @ PRow()    , 10 PSay AllTrim(Substr(SB1->B1_Desc,1,28))
       @ PRow()    , 40 PSay SB1->B1_UM
       @ PRow()    , 42 PSay aCols[nCont][3]     Picture '@E 9999999.99'
       @ PRow()    , 56 PSay aCols[nCont][4]     Picture '@E 9999999.99'
       @ PRow()    , 70 PSay aCols[nCont][5]     Picture '@E 9999999.99'
        
       nTotPart := nTotPart + aCols[nCont][5]
   Next
    
  	// Impressao das duplicatas   
    // Gustavo 20/05/2016 - Alterado para pegar dados da NCC quando NF for devolução
  	If SF1->F1_TIPO == 'D'
    	dbSelectArea("SE1")
    	SE1->(dbSetOrder(2))
    	SE1->(dbSeek(xFilial("SE1") + SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_SERIE + SF1->F1_DOC))
    	
    	While SE1->E1_FILIAL  == xFilial("SE1") .And. SE1->E1_PREFIXO == SF1->F1_SERIE .And. SE1->E1_NUM == SF1->F1_DOC .And. ;
		    SE1->E1_CLIENTE == SF1->F1_FORNECE .And. SE1->E1_TIPO == "NCC"
				Aadd(aDup, {SE1->E1_NUM + Iif(AllTrim(SE1->E1_PARCELA) == "", "", "/" + SE1->E1_PARCELA), DTOC(SE1->E1_VENCTO), SE1->E1_VALOR})	            
		    SE1->(dbSkip())
		EndDo
		  
	Else
		dbSelectArea("SE2")
		SE2->(DbSetOrder(6))
		SE2->(DbSeek(xFilial("SE2") + SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_SERIE + SF1->F1_DOC))
			                                         
		While SE2->E2_Filial  == xFilial("SE2") .And. ;
		    SE2->E2_Prefixo == SF1->F1_Serie  .And. ;
		    SE2->E2_Num     == SF1->F1_Doc    .And. ;
		    SE2->E2_Fornece == SF1->F1_Fornece
		  
		  nXMoeda    := SE2->E2_Moeda
		   // nTotTit    := nTotTit + SE2->E2_Valor
		  Aadd(aDup, {SE2->E2_Num + iif(AllTrim(SE2->E2_Parcela) == "", "", "/" + SE2->E2_Parcela), DToC(SE2->E2_Vencto), SE2->E2_Valor})	            
		  SE2->(DbSkip())
		EndDo
	End
		
	While len(aDup) < 6
	  Aadd(aDup, { "  --  ", "   --   ", 0.00})
	EndDo 
   
   @ PRow() + 1,          70 PSay '----------'
   @ PRow() + 1,          00 PSay 'Moeda : (' + aMoedas[nXMoeda] + ")"
   @ PRow() + 0,          61 PSay 'TOTAL:'
   @ PRow()    , PCol() + 02 PSay nTotPart       Picture '@E 99999999.99'
   @ PRow() + 1,          00 PSay Repli('-', 80)      
   
	
	// imprime os seis itens das duplicatas
		
  @ PRow() + 1, 00 PSay("Duplicata     Vencimento      Valor          Duplicata   Vencimento      Valor" )
  @ PRow() + 1, 01 PSay aDup[1,1]
  @ PRow()    , 15 PSay aDup[1,2]
  @ PRow()    , 25 PSay aDup[1,3] Picture '@E 9,999,999.99'
  @ PRow()    , 45 PSay aDup[2,1] 
  @ PRow()    , 56 PSay aDup[2,2]
  @ PRow()    , 68 PSay aDup[2,3] Picture '@E 9,999,999.99'
  @ PRow() + 1, 01 PSay aDup[3,1]
  @ PRow()    , 13 PSay aDup[3,2]
  @ PRow()    , 25 PSay aDup[3,3] Picture '@E 9,999,999.99'
  @ PRow()    , 45 PSay aDup[4,1] 
  @ PRow()    , 56 PSay aDup[4,2]
  @ PRow()    , 68 PSay aDup[4,3] Picture '@E 9,999,999.99'
  @ PRow() + 1, 01 PSay aDup[5,1]
  @ PRow()    , 13 PSay aDup[5,2]
  @ PRow()    , 25 PSay aDup[5,3] Picture '@E 9,999,999.99'
  @ PRow()    , 45 PSay aDup[6,1] 
  @ PRow()    , 56 PSay aDup[6,2]
  @ PRow()    , 68 PSay aDup[6,3] Picture '@E 9,999,999.99'
  
/*  @ PRow() + 2,          00 PSay 'No. Duplic.:'
  @ PRow()    , PCol() + 02 PSay SF1->F1_Serie + '/' + SF1->F1_Doc
  @ PRow() + 1,          00 PSay 'Valor      :'
  @ PRow()    , PCol() + 02 PSay nTotTit        Picture '@E 99999999.99'
  @ PRow()    , PCol() + 02 PSay '(' + aMoedas[nXMoeda] + ')'*/
   
   @ PRow() + 1,          00 PSay ''
   
   If !Empty(cOBS)
      @ PRow()    ,          00 PSay 'Observacao:'
      @ PRow()    , PCol() + 02 PSay cOBS
   EndIf
   
   If !Empty(cPlaca)
      @ PRow()    ,          64 PSay 'Placa:'
      @ PRow()    , PCol() + 02 PSay cPlaca
   EndIf
   
   //Dioni 01/03 -> Chamado 348
   //se o parametro cliente estiver vazio, faz do forncedor, senao fazer do cliente  
   IF !Empty(MV_PAR04)
      @ PRow() + 1,          00 PSay Repl('-', 80)
      @ PRow() + 1, 00 PSay "Usuario  : " + SubStr(cUsuario, 07, 15)
      @ PRow() + 1,          00 PSay Repl('-', 80)   
      @ PRow() + 1, 00 PSay "DADOS PARA DEPOSITO "
      @ PRow() + 1, 00 PSay "Comprador: " + SA2->A2_CONTATO
      if allTrim(SA2->A2_BANCO) == '001'
         cBanco:= 'Banco do Brasil'
      elseIf allTrim(SA2->A2_BANCO) == '104'
        cBanco:= 'Caixa Economica Federal'   
  	  elseIf allTrim(SA2->A2_BANCO) == '237'
     	  cBanco:= 'Bradesco'   
   		elseIf allTrim(SA2->A2_BANCO) == '341'
        cBanco:= 'Itau'   
   		elseIf allTrim(SA2->A2_BANCO) == '409'
        cBanco:= 'Unibanco'   
   		elseIf allTrim(SA2->A2_BANCO) == '748'
        cBanco:= 'Sicredi'   
   		endIf

   		@ PRow() + 1, 00 PSay "Banco: " + SA2->A2_BANCO + "-" + cBanco 
   		@ PRow()    , 40 PSay "Agencia: " + ALLTRIM(SA2->A2_AGENCIA) + "-" + ALLTRIM(SA2->A2_DIGAGEN)
   		@ PRow()    , 60 PSay "Conta: " + ALLTRIM(SA2->A2_NUMCON) + "-" + ALLTRIM(SA2->A2_DIGCON)
  
   ELSE
      @ PRow() + 1,          00 PSay Repl('-', 80)
      @ PRow() + 1, 00 PSay "Usuario  : " + SubStr(cUsuario, 07, 15)
      @ PRow() + 1,          00 PSay Repl('-', 80)   
      @ PRow() + 1, 00 PSay "DADOS PARA DEPOSITO "
      @ PRow() + 1, 00 PSay "Comprador: " + SA1->A1_CONTATO
      if allTrim(SA1->A1_BANCO) == '001'
         cBanco:= 'Banco do Brasil'
      elseIf allTrim(SA1->A1_BANCO) == '104'
        cBanco:= 'Caixa Economica Federal'   
  	  elseIf allTrim(SA1->A1_BANCO) == '237'
     	  cBanco:= 'Bradesco'   
   		elseIf allTrim(SA1->A1_BANCO) == '341'
        cBanco:= 'Itau'   
   		elseIf allTrim(SA1->A1_BANCO) == '409'
        cBanco:= 'Unibanco'   
   		elseIf allTrim(SA1->A1_BANCO) == '748'
        cBanco:= 'Sicredi'   
   		endIf

   		@ PRow() + 1, 00 PSay "Banco: " + SA1->A1_BANCO + " - " + cBanco 
   		@ PRow()    , 40 PSay "Agencia: " + SA1->A1_AGENCIA
   		@ PRow()    , 60 PSay "Conta: " + SA1->A1_NUMCONT 
  
   ENDIF
   
	Set Device To Screen
	If aReturn[5] == 1
   	Set Printer To
   	OurSpool(WnRel)
	Endif
	FT_PFlush()	
	MS_FLUSH()
EndIf
   
Close(oDlg1)

RestArea(aArea)
Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Descricao ³ Funcoes de Validacao p/ Atualizacao de Variaveis           ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³ Uso      ³ CANTU                                                      ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

// Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==> Function Atualiza
Static Function Atualiza()
DbSelectArea("SA4")
SA4->(DbSetOrder(1))
SA4->(DbSeek(xFilial("SA4") + cCodTran))
cNomTran  := SA4->A4_Nome
cEndTran  := SA4->A4_End
cMunTran  := SA4->A4_Mun
cEstTran  := SA4->A4_Est
// Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==> __Return(.T.)
Return(.T.)        // incluido pelo assistente de conversao do AP5 IDE em 10/05/01