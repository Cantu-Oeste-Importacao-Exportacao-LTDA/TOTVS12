#include "rwmake.ch"        
User Function CRTUNI()     
//________________________Comentários gerais_____________________________//
// As váriaveis mv_par01 e mv_par02 são variáveis que através do cPerg, 
// recebem automaticamente o número e a série da NF informada

//________________________Criação de Variáveis___________________________//

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

SetPrvt("NLIN,NCOL") //Controle de posicionamento de linhas e colunas
SetPrvt("CCFO")
SetPrvt("TPFRETE")   //Controle do tipo de frete (pago ou a pagar) valores : "pago" "apagar"
SetPrvt("CCODREM,CLOJREM")   // Codigo do Remetente, Loja do Remetente
SetPrvt("CNOMREM,CENDREM,CMUNREM,CUFREM,CCGCREM,CINSCREM") //Informacoes do Remetente

SetPrvt("CCODDEST,CLOJDEST")   // Codigo do Destinatário
SetPrvt("CNOMDEST,CENDDEST,CMUNDEST,CUfDEST,CCGCDEST,CINSCDEST") //Informacoes do DESTetente
SetPrvt("CNOMCONSIG,CENDCONSIG,CMUNCONSIG,CUfCONSIG") //Informacoes do Consignatário

SetPrvt("REDESP")   // Informações do consignatário
SetPrvt("CEMPREDESP,CENDREDESP,CMUNREDESP,CUfREDESP,CCGCREDESP,CINSCREDESP,CNCONHECTO") //Informacoes de Redespacho
SetPrvt("REDESPPAGO,REDESPAPAGAR")

SetPrvt("CNATCARG, NQUANT, CESPECIE, NPBRUTO, NPLIQ, NMETROS, CNF, NVLRMERC, NTARIF  ")   // Informações da mercadoria transportada

SetPrvt("NPESOVOL, NFRTVLR, CSECCAT, CDESPAC, NPEDAG, NOUTROS, NTOTPREST, NBASECALC, NALIQ, NICMS") // Informações da composicao do frete

SetPrvt("CNOMSUBCONT, CCNPJSUBCONT, CMUNSUBCONT, CUFSUBCONT, CPLACAVEIC, CMOTORISTA, CLOCCOLETA, CLOCENTREGA, COBS, COBS1, COBS2, cObsFixa")   // Informações da subcontratada(o)

//_____________________Criação de Variáveis de uso geral____________________//
nLin  	  := 5
nCol	  := 10
tpFrete   := ""

//________________________Inicial. Var. Remetente___________________________//
cCodREM   := space(6)
cLojRem   := space(2)
cNomREM   := space(45)
cEndREM   := space(55)
cMunREM   := space(55)
cUfREM    := "  "
cCgcREM   := space(18)
cInscREM  := space(12)

//________________________Inicial. Var. Destinatário________________________//
cCodDest  := space(6)
cLojDest  := space(2)
cNomDest  := space(55)
cEndDest  := space(55)
cMunDest  := space(55)
cUfDest   := "  "
cCgcDest  := space(18)
cInscDest := space(12)

//________________________Inicial. Var. Consignatário______________________//
cNomConsig  := "RJU Com. e Benef. de Frutas e Verduras Ltda.        "
cEndConsig  := "Rod. PR 280 - KM 144.3 S/Nº                         "
cMunConsig  := "Vitorino                                            "
cUfConsig   := "PR"

//________________________Inicial. Var. Redespacho________________________//
Redesp := "nao"
cEmpRedesp  := space (55)
cEndRedesp  := space (55)
cMunRedesp  := space (55)
cUfRedesp   := "  "
cCgcRedesp  := space (18)
cInscRedesp := space (12)
cNConhecto  := space (15)

//__________________Inicial. Var. Mercadoria Transportada_______________//
cNatCarg    := space (55)
nQuant		:= 0
cEspecie	:= space (55)
nPBruto		:= 0
nPLiq		:= 0
nMetros		:= 0
cNF			:= Space(6)
nVlrMerc	:= 0
nTarif		:= 0

//____________________Inicial. Var. Composic. do Frete_________________//
nPesoVol    := 0
nFrtVlr     := 0
cSecCat     := space (15)
cDespac     := space (15)
nPedag      := 0
nOutros     := 0
nTotPrest   := 0
nBaseCalc   := 0
nAliq       := 0
nIcms       := 0

//________________________Inicial. Var. Sub-Contratado(a)______________//
cNomSubCont  := "RJU Com. e Benef. de Frutas e Verd. Ltda."
cCNPJSubCont := "78.575.149/0001-96"
cMunSubCont  := "Vitorino"
cUFSubCont   := "PR"
cPlacaVeic   := space( 15)
cMotorista   := space( 55)
cLocColeta   := space( 55)
cLocEntrega  := space( 55)
cObs         := space(100)
cObs1		 := space(100)
cObs2        := space(100)
cObsFixa     := space(100)
//________________________Inicial. Var. Internas_____________________//
CbCont    := ""
cabec1    := ""
cabec2    := ""
cabec3    := ""
wnrel     := ""
nOrdem    := 0
Tamanho   := "M"
Limite    := 132
Titulo    := "Conhecimento de Frete"
cDesc1    := "Este programa tem por objetivo a impressao do conhecimento de frete"
cDesc2    := ""
cDesc3    := ""
cString   := "SF2"
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
NomeProg  := "RJU007"
nLastKey  := 0
cPerg     := "RJUCFT"
WnRel     := "SAIDAS"

//________________________Inicial. Var. Cabec. e Rodapé________________//
m_Pag     := 1

If !Pergunte(cPerg)
	Return
EndIf


//_________________Seleção das chaves para os arquivos________________//
SF2->(dbSetOrder(1))           // filial+doc+serie  Cab. Nota Fiscal
SF4->(DbSetOrder(1))           // filial+cod tes    TES

//______Posicionamento do ponteiro no nº da NF e Série informados ____//
SF2->(DbSeek(xFilial("SF2") + Mv_Par01 + Mv_Par02, .T.))

SETPRC(0,0)
If SF2->F2_Filial == xFilial("SF2") .And. SF2->F2_Doc == Mv_Par01 .And. SF2->F2_Serie == Mv_Par02
	if MsgBox("Frete pago?","Tipo de Frete","YESNO")
		tpFrete="pago"
        cCodRem:= SF2->F2_Cliente
        cLojRem:= SF2->F2_Loja
        AtualizaRemetente()		
	else
		tpFrete="aPagar"
        cCodDest:= SF2->F2_Cliente
        cLojDest:= SF2->F2_Loja
        AtualizaDestinatario()		
	endIf

    @ 100, 100 To 300, 650 Dialog oDlg Title "Informacoes do Remetente"
//    @ 10,10 BITMAP SIZE 50,200 FILE 'd:\teste.bmp'
	@  nLin+10,  nCol     Say "Cliente"
	@  nLin+20,  nCol     Say "Endereco"
	@  nLin+30,  nCol     Say "Municipio"
	@  nLin+30,  nCol+168 Say "Estado"
	@  nLin+40,  nCol     Say "C.N.P.J / C.P.F"
	@  nLin+40,  nCol+168 Say "Insc. Est."

	@  nLin+7,  nCol+45  Get cCodREM  Picture "@S6"   Valid AtualizaRemetente() F3 "SA1"
	@  nLin+7,  nCol+90  Get cNomREM  Picture "@S55"  When Empty(cCodREM)
	@  nLin+20, nCol+45  Get cEndREM  Picture "@S55"  When Empty(cCodREM)
	@  nLin+30, nCol+45  Get cMunREM  Picture "@S50"  When Empty(cCodREM)
	@  nLin+30, nCol+190 Get cUFREM   Picture '@! XX' When Empty(cCodREM)
	@  nLin+40, nCol+45  Get cCgcREM  Picture "@R 99.999.999/9999-99"  Valid CGC(cCgcREM)  //When Empty(cCodREM)
	@  nLin+40, nCol+190 Get cInscREM Picture "@S25"  When Empty(cCodREM)
	@ 120, 100 Say SM4->M4_DESCR Size(200)

	@ 80, 120 BmpButton Type 01 Action Close(oDlg)
	Activate Dialog oDlg Center

//_________________Obtenção dos dados do destinátário__________________//
  	@ 170, 30 To 450, 680 Dialog oDlg Title " Informações do destinatário e consignatário "
	nLin:=0
	nCol:=7

	@  nLin+10,  nCol     Say "Destinatário"
	@  nLin+20,  nCol     Say "Endereco"
	@  nLin+30,  nCol     Say "Municipio"
	@  nLin+30,  nCol+168 Say "Estado"
	@  nLin+40,  nCol     Say "C.N.P.J / C.P.F"
	@  nLin+40,  nCol+168 Say "Insc. Est."

	@  nLin+7,  nCol+45  Get cCodDest  Picture "@S6"   Valid AtualizaDestinatario() F3 "SA1"
	@  nLin+7,  nCol+90  Get cNomDest  Picture "@S55"  When Empty(cCodDest)
	@  nLin+20, nCol+45  Get cEndDest  Picture "@S55"  When Empty(cCodDest)
	@  nLin+30, nCol+45  Get cMunDest  Picture "@S50"  When Empty(cCodDest)
	@  nLin+30, nCol+190 Get cUFDest   Picture '@! XX' When Empty(cCodDest)
	@  nLin+40, nCol+45  Get cCgcDest  Picture "@R 99.999.999/9999-99"  //Valid CGC(cCgcDest)  //When Empty(cCodDest)
	@  nLin+40, nCol+190 Get cInscDest Picture "@S27"  When Empty(cCodDest)

//_________________Obtenção dos dados do consignatário________________//
	nLin:=70

	@  nLin+10,  nCol     Say "Consignatário"
	@  nLin+20,  nCol     Say "Endereco"
	@  nLin+30,  nCol     Say "Municipio"
	@  nLin+30,  nCol+168 Say "Estado"

	@  nLin+7,  nCol+45  Get cNomConsig  Picture "@S65"         
	@  nLin+20, nCol+45  Get cEndConsig  Picture "@S65"         
	@  nLin+30, nCol+45  Get cMunConsig  Picture "@S65"         
	@  nLin+30, nCol+190 Get cUFConsig   Picture '@! XX'        

	@ 120, 100 BmpButton Type 01 Action Close(oDlg)
	@ 120, 170 BmpButton Type 02 Action Close(oDlg)
	Activate Dialog oDlg Center

//_________________Obtenção dos dados do Redespacho_________________//
	if MsgBox("Possui redespacho?"," Redespacho ","YESNO")
   	   Redesp  = "sim"
	else
	   Redesp = "nao"
	endif

	nLin:=7
	nCol:=7
	if Redesp == "sim"
	    @ 100, 100 To 300, 650 Dialog oDlg Title "Informacoes de Redespacho"
  		@  nLin+10,  nCol     Say "Empresa"
		@  nLin+10,  nCol+168 Say "Frete: "
		@  nLin+20,  nCol     Say "Endereco"
		@  nLin+30,  nCol     Say "Municipio"
		@  nLin+30,  nCol+168 Say "Estado"
		@  nLin+40,  nCol     Say "C.N.P.J / C.P.F"
		@  nLin+40,  nCol+168 Say "Conhecto. Nº."
	
		@  nLin+7,   nCol+45  Get cEmpRedesp     Picture "@S55"
		@  nLin+10,  nCol+210 CHECKBOX "Pago"    VAR RedespPago   Object oCbx
		@  nLin+10,  nCol+240 CHECKBOX "A Pagar" VAR RedespAPagar Object oCbx
		@  nLin+20,  nCol+45  Get cEndRedesp     Picture "@S55"
		@  nLin+30,  nCol+45  Get cMunRedesp     Picture "@S55	"
		@  nLin+30,  nCol+210 Get cUFRedesp      Picture '@! XX'
		@  nLin+40,  nCol+45  Get cCgcRedesp     Picture "@R 99.999.999/9999-99"  Valid CGC(cCgcRedesp)
		@  nLin+40,  nCol+210 Get cNConhecto     Picture "@S15"
		@ 120, 100 Say SM4->M4_DESCR Size(200)
	
		@ 80, 120 BmpButton Type 01 Action Close(oDlg)
		Activate Dialog oDlg Center
    endIf

//______________Obtenção dos dados da mercadoria transportada______________//
	@ 100, 100 To 300, 650 Dialog oDlg Title "Mercadoria Transportada"
	@  nLin+10,  nCol     Say "Natur. da Carga"
	@  nLin+10,  nCol+168 Say "Quantidade"
	@  nLin+20,  nCol     Say "Espécie"
	@  nLin+30,  nCol     Say "Peso Bruto (Kg)"
	@  nLin+30,  nCol+168 Say "Peso Liq. (Kg)"
	@  nLin+40,  nCol     Say "M³ ou I"
	@  nLin+40,  nCol+168 Say "Nº NF"
	@  nLin+50,  nCol     Say "Vlr. Merc."
	@  nLin+50,  nCol+168 Say "Tarifa"

	@  nLin+7,  nCol+45  Get cNatCarg  Picture "@S55"
	@  nLin+7,  nCol+210 Get nQuant    Picture "@E 999,999"
	@  nLin+20, nCol+45  Get cEspecie  Picture "@S55"
	@  nLin+30, nCol+45  Get nPBruto   Picture "@E 999,999"
	@  nLin+30, nCol+210 Get nPLiq     Picture "@E 999,999"
	@  nLin+40, nCol+45  Get nMetros   Picture "@E 999,999"
	@  nLin+40, nCol+210 Get cNF       Picture "@S27"
	@  nLin+50, nCol+45  Get nVlrMerc  Picture "@E 9999999.99"
	@  nLin+50, nCol+210 Get nTarif    Picture "@E 9999999.99"

	@ 80, 120 BmpButton Type 01 Action Close(oDlg)
	Activate Dialog oDlg Center

//______________Obtenção dos dados da composição do frete____________//
	@ 100, 100 To 300, 650 Dialog oDlg Title "Composição do Frete"
//	@  nLin+10,  nCol     Say "Peso / Vol."
//	@  nLin+10,  nCol+168 Say "Frete Valor"
	@  nLin+20,  nCol     Say "Sec / Cat"
	@  nLin+20,  nCol+168 Say "Despacho"
	@  nLin+30,  nCol     Say "Pedágio"
	@  nLin+30,  nCol+168 Say "Outros"
	@  nLin+40,  nCol     Say "Tot. Prest."
	@  nLin+40,  nCol+168 Say "Base Calc."
	@  nLin+50,  nCol     Say "Aliquota"
	@  nLin+50,  nCol+168 Say "ICMS"

//	@  nLin+10, nCol+40  Get nPesoVol  Picture "@E 999,99"
//	@  nLin+10, nCol+205 Get nFrtVlr   Picture "@E 9999999.99"
	@  nLin+20, nCol+40  Get cSecCat   Picture "@S27"
	@  nLin+20, nCol+205 Get cDespac   Picture "@S27"
	@  nLin+30, nCol+40  Get nPedag    Picture "@E 9999999.99"
	@  nLin+30, nCol+205 Get nOutros   Picture "@E 9999999.99"
	@  nLin+40, nCol+40  Get nTotPrest Picture "@E 9999999.99"
	@  nLin+40, nCol+205 Get nBaseCalc Picture "@E 9999999.99"
	@  nLin+50, nCol+40  Get nAliq     Picture "@E 99" Valid CalcICM()
	@  nLin+50, nCol+205 Get nIcms     Picture "@E 9999999.99"
	
	@ 80, 120 BmpButton Type 01 Action Close(oDlg)
	Activate Dialog oDlg Center

//_________________Obtenção dos dados da sub-contratada________________//
	@ 100, 100 To 340, 670 Dialog oDlg Title "Transportadora Sub-Contratada"
	@  nLin+10, nCol     Say "Sub-Contratado(a)"
	@  nLin+10, nCol+168 Say "CNPJ / CPF"
	@  nLin+20, nCol     Say "Município"
	@  nLin+20, nCol+168 Say "Estado"
	@  nLin+30, nCol     Say "Motorista"
	@  nLin+30, nCol+168 Say "Placa Veic."
	@  nLin+40, nCol     Say "Local Coleta"
	@  nLin+50, nCol     Say "Local Entrega"
	@  nLin+60, nCol     Say "Observações"

	@  nLin+7,  nCol+45  Get cNomSubCont  Picture "@S55"
	@  nLin+7,  nCol+210 Get cCNPJSubCont Picture "@R 99.999.999/9999-99"   Valid CGC(cCNPJSubCont)
	@  nLin+20, nCol+45  Get cMunSubCont  Picture "@S55"
	@  nLin+20, nCol+210 Get cUFSubCont   Picture '@! XX'
	@  nLin+30, nCol+45  Get cMotorista   Picture "@S55"
	@  nLin+30, nCol+210 Get cPlacaVeic   Picture "@S27"
	@  nLin+40, nCol+45  Get cLocColeta   Picture "@S55"
	@  nLin+50, nCol+45  Get cLocEntrega  Picture "@S55"
	@  nLin+60, nCol+45  Get cObs         Picture "@S100"
	@  nLin+70, nCol+45  Get cObs1        Picture "@S100"
	@  nLin+80, nCol+45  Get cObs2        Picture "@S100"
    @  nLin+90, nCol+45  Get cObsFixa     Valid ChSM4() F3 "SM4"
    @  nLin   , nCol+45  Say SM4->M4_DESCR Size(200)


	@ 100, 120 BmpButton Type 01 Action Close(oDlg)
	Activate Dialog oDlg Center

//_________________Envia o controle para função setPrint __________________//
	WnRel := SetPrint(cString, wnrel, cPerg, Titulo, cDesc1, cDesc2, cDesc3, .F.,"")

	if LastKey() == 27 .or. nLastKey == 27
		return
	endIf

	SetDefault(aReturn, cString)

	if LastKey() == 27 .OR. nLastKey == 27
		return
	endIf

//______Salva posições para o movimento da régua de processamento_________//
	TRegs     := RecCount()
	m_Mult    := 1

	if TRegs > 0
		m_Mult := 70 / TRegs
	endIf

	SF4->(DbSeek(xFilial("SF4") + SD2->D2_TES)) // Arquiv. TES p/ Cab NF campo Cfo
	@ 00    , 00  PSay Chr(27) + Chr(120) + Chr(0) //Posicionam/ da impressora
	@ 00    , 00  PSay Chr(27) + Chr(15)
//_________________Impressão do cabeçalho do conhecimento ______________//
	@ PRow()+1, 113  PSay SD2->D2_CF
	@ PRow()+1,  84  PSay "Vitorino"
	@ PRow(),   113  PSay SF2->F2_Emissao
	@ PRow(),   160  PSay SF2->F2_DOC

    nPesoVol:=SD2->D2_QUANT
	nFrtVlr :=SD2->D2_TOTAL

		
	// se tpFrete for pago imprime o remetente na primeira coluna,
	// caso contrario imprime o destinatário
//	if tpFrete=="pago"
		@ PRow()+1, 13   PSay cNomRem
		@ PRow()  ,120   PSay cNomDest// Guilherme 100
		@ PRow()+1, 13   PSay cEndRem
		@ PRow()  ,120   PSay cEndDest// Guilherme 100
		@ PRow()+1, 13   PSay cMunRem
		@ PRow()  , 80   PSay cUFRem
		@ PRow()  ,120   PSay cMunDest// Guilherme 100
		@ PRow()  ,190   PSay cUFDest // Guilherme 170
		@ PRow()+1, 13   PSay cCGCRem Picture "@R 99.999.999/9999-99"
		@ PRow()  , 53   PSay cInscRem
		@ PRow()  ,120   PSay cCGCDest Picture "@R 99.999.999/9999-99"// Guilherme 100
		@ PRow()  ,160   PSay cInscDest// Guilherme 140
//	endIf
		
/*	if tpFrete=="aPagar"
		@ PRow()+1, 13   PSay cNomDest
		@ PRow()  ,100   PSay cNomRem
		@ PRow()+1, 13   PSay cEndDest
		@ PRow()  ,100   PSay cEndRem
		@ PRow()+1, 13   PSay cMunDest
		@ PRow()  , 80   PSay cUFDest
		@ PRow()  ,100   PSay cMunRem
		@ PRow()  ,170   PSay cUFRem
		@ PRow()+1, 13   PSay cCGCDest Picture "@R 99.999.999/9999-99"
		@ PRow()  , 53   PSay cInscDest
		@ PRow()  ,100   PSay cCGCRem Picture "@R 99.999.999/9999-99"
		@ PRow()  ,140   PSay cInscRem
	endIf
*/	
		
	@ PRow()+1,  13 PSay cNomConsig
	@ PRow()+1,  13 PSay cEndConsig
	if redesp == "sim"
		@ PRow()    ,100 PSay cEmpRedesp
		if redespPago
	  	   @ PRow() ,156 PSay "X"
		endIf
		if redespaPagar
		   @ PRow() ,165 PSay "X"
		endIf
	endIf
	@ PRow()+1, 13 PSay cMunConsig
	@ PRow()  , 80 PSay cUFConsig
	@ PRow()  ,100 PSay cEndRedesp
	if tpFrete =="pago"
 	   @ PRow()+1 ,66 PSay "X"
	endIf

	if tpFrete =="aPagar"
       @ PRow()+1 ,76 PSay "X"
	endIf
	@ PRow()  ,100 PSay cMunRedesp
	@ PRow()  ,172 PSay cUFRedesp
		
	@PRow()+1, 13 PSay cLocEntrega
	if redesp == "sim"
	   @ PRow(), 100 PSay cCGCRedesp Picture "@R 99.999.999/9999-99"
	   @ PRow(), 153 PSay cNConhecto
	endIf
		
//_________________Impressão da mercadoria transportada ________________//
	@ PRow()+2,  0 PSay cNatCarg //@ PRow()+3,  0 PSay cNatCarg Guilherme
	@ PRow()  , 42 PSay nQuant    Picture "@E 999,999"
	@ PRow()  , 55 PSay cEspecie
	@ PRow()  , 70 PSay nPBruto   Picture "@E 999,999"
	@ PRow()  , 88 PSay nPLiq     Picture "@E 999,999"
	@ PRow()  ,110 PSay nMetros   Picture "@E 999,999"
	@ PRow()  ,118 PSay cNF       Picture "@E 999999"
	@ PRow()  ,135 PSay nVlrMerc  Picture "@E 9,999,999.99"
	@ PRow()  ,165 PSay nTarif    Picture "@E 99.99"
		
//_________________Impressão da composição do frete ___________________//
	@ PRow()+2,  0 PSay nPesoVol   Picture "@E 999,999"
	@ PRow()  , 18 PSay nTotPrest  Picture "@E 999,999.99"
	@ PRow()  , 45 PSay cSecCat   
	@ PRow()  , 52 PSay cDespac   
	@ PRow()  , 68 PSay nPedag     Picture "@E 999,999.99"
	@ PRow()  , 78 PSay nOutros    Picture "@E 999,999"
	@ PRow()  , 95 PSay nTotPrest  Picture "@E 999,999.99"
	@ PRow()  ,125 PSay nBaseCalc  Picture "@E 999,999.99"
	@ PRow()  ,147 PSay nAliq      Picture "@E 99.99"
//	@ PRow()  ,145 PSay "%"  
	@ PRow()  ,160 PSay nIcms      Picture "@E 999,999.00" 
//	@ PRow()  ,162 PSay "%"	
//_________________Impressão da sub-contratada ________________//
	@ PRow()+1,20  PSay cNomSubCont
	@ PRow()+1, 48 PSay cCNPJSubCont
	@ PRow()  , 86 PSay cMunSubCont
	@ PRow()  ,134 PSay cUFSubCont
	@ PRow()  ,140 PSay cPlacaVeic
	@ PRow()+2,  0 PSay cMotorista
	@ PRow()  , 48 PSay cLocColeta
	@ PRow()  , 95 PSay cLocEntrega
	@ PRow()+2 , 0 PSay cObs
	@ PRow()+1 , 0 PSay cObs1	
	@ PRow()+1 , 0 PSay cObs2
	@ PRow()+1 , 0 PSay cObsFixa
Else
	MsgInfo("Nota inexistente","Mensagem")
EndIf
Eject
SETPRC(0,0)
Set Printer To
Set Device To Screen
SetPgEject(.F.) 
Ms_Flush() //Libera fila de relatorios em spool
	
if aReturn[5] == 1
	Set Printer TO
	OurSpool(WnRel)
endIf

Static Function AtualizaRemetente()
	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1") + cCodRem + cLojRem))
	cNomRem  := SA1->A1_Nome
	cEndRem  := SA1->A1_End
	cMunRem  := SA1->A1_Mun
	cUfRem   := SA1->A1_Est
	cCgcRem  := SA1->A1_Cgc
	cInscRem := SA1->A1_Inscr
Return(.T.)
	
Static Function AtualizaDestinatario()
	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1") + cCodDest))
	cNomDest  := SA1->A1_Nome
	cEndDest  := SA1->A1_End
	cMunDest  := SA1->A1_Mun
	cUfDest   := SA1->A1_Est
	cCgcDest  := SA1->A1_Cgc
	cInscDest := SA1->A1_Inscr
Return(.T.)

Static Function CalcICM()
	nIcms := (nBaseCalc*nAliq)/100	
Return(nIcms)