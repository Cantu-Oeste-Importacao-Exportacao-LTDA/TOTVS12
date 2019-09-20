#include "rwmake.ch"
#INCLUDE "topconn.ch"  
#INCLUDE "TBICONN.CH"
#include "colors.ch"

/* Funçao responsável por criar o parametro no SX6 ou atualizar ele, conforme parametros passados*/
User function CriaParam(cFil, cNome, cTipo, cDescri, cConteudo)
Local cDesc1 := ""
Local cDesc2 := ""
Local cDesc3 := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

dbSelectArea("SX6")
dbSetOrder(01)

cDesc1 := Substr(cDescri, 1, 50)

if (Len(cDescri)) > 50
	cDesc2 := Substr(cDescri, 51, 50)
EndIf

if (Len(cDescri)) > 100
	cDesc3 := Substr(cDescri, 101, 50)
EndIf

if !dbSeek(cFil + cNome)
	RecLock("SX6", .T.)
	SX6->X6_FIL := cFil
	SX6->X6_VAR := cNome
	SX6->X6_TIPO := cTipo
	SX6->X6_DESCRIC := cDesc1
	SX6->X6_DSCSPA  := cDesc1
	SX6->X6_DSCENG  := cDesc1
	SX6->X6_DESC1   := cDesc2
	SX6->X6_DSCSPA1 := cDesc2
	SX6->X6_DSCENG1 := cDesc2
	SX6->X6_DESC2   := cDesc3
	SX6->X6_DSCSPA2 := cDesc3
	SX6->X6_DSCENG2 := cDesc3
	SX6->X6_CONTEUD := cConteudo
	SX6->X6_PROPRI  := "S"
	SX6->X6_PYME    := "S"
	MsUnLock()
else // só altera o conteúdo
	RecLock("SX6", .F.)
	SX6->X6_CONTEUD := cConteudo
	MsUnLock()
EndIf

Return

User Function ParamCusto()       

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

u_CriaParam("  ","MV_X_ATRTP",	"C",	"Informe S ou N (Sim/Nao) para ativar a opcao de modulo faturamento.", "S")
u_CriaParam("  ","MV_X_QCAGR",	"N",	"Quantidade de caracteres após o código do grupo para compor o tamanho do código de produtos quando gerado de forma seqüencial", "4")
u_CriaParam("  ","MV_X_ATCFC",	"C",	"Informe S ou N (Sim/Não) para ativar os controle no processo de classificação dos documentos de entrada", "S")
u_CriaParam("  ","MV_X_APRGB",	"C",	"Informe S ou N (Sim/Não) para ativar os controles nos pedidos de compras através das validações com base na tabela de fluxo de caixa para compras.", "S")
u_CriaParam("  ","MV_X_NDFCC",	"N",	"Informe o número de dias para o processamento para a inclusão de registros na tabela de fluxo de caixa do compras.", "120")
u_CriaParam("  ","MV_X_USPDC",	"C",	"Informe o login dos supervisores que podem autorizar a inclusão do pedido de compras em data(s) bloqueada(s).", "joaovto")
u_CriaParam("  ","MV_X_CNWFC",	"C",	"Informe o nome do contato para envio de workflow da ficha cadastral do motorista / veiculo nas rotinas de cotacao de frete / solicitacao de  coleta", "aley@cantutransportadora.com.br")
u_CriaParam("  ","MV_X_ATWFC",	"C",	"Informe S ou N (Sim/Nao) para ativar o envio de workflow da ficha cadastral do motorista / veic nas rotinas de cotacao de frete / solicitacao de coleta.", "S")
u_CriaParam("  ","MV_X_ATCCV",	"C",	"Informe S ou N (Sim/Nao) para ativar o calculo de comissoes utilizando as regras de contratos de    vendedores no pedido de venda.                    ", "S")
u_CriaParam("  ","MV_X_ATCDC",	"C",	"Informe S ou N (Sim/Nao) para ativar o calculo de desconto de comissoes utilizando as regras de     desconto de comissoes no pedido de venda.         ", "S")
u_CriaParam("  ","MV_X_APRBN",	"C",	"Informe S ou N (Sim/Nao) para ativar o calculo de regras de bonificações financeiras sobre o faturamento de pedidos.", "S")
u_CriaParam("  ","MV_X_CPPCA",	"C",	"Codigo do produto referente a 1/12 do valor de    comissoes para inclusao de pedido de compras de   pagamento de comissoes do vendedor.               ", " ")
u_CriaParam("  ","MV_X_CPPCV",	"C",	"Codigo do produto referente ao valor das comissoes para inclusao de pedido de compras de pagamento   de comissoes do vendedor.                         ", " ")
u_CriaParam("  ","MV_X_CFPCV",	"C",	"Código da forma de pagamento para inclusão do pedido de compras de pagamento de comissões do vendedor.", "S")
u_CriaParam("  ","MV_X_ACPAD",	"C",	"Informe S ou N (Sim/Não) para ativar a compensação automática do título a pagar referente ao documento de entrada na inclusão da nota fiscal de devolução.", "S")
u_CriaParam("  ","MV_X_AWCFC",	"C",	"Informe S ou N (Sim/Não) para ativar o envio de workflow atraves da rotina de retorno de carga    quando da nao conferencia fiscal.                 ", "S")
u_CriaParam("  ","MV_X_ATPCA",	"C",	"Informe S ou N (Sim/Não) para ativar a inclusão do registro de comissão ao agenciador de frete no calculo de frete.", "S")
u_CriaParam("  ","MV_X_ATIDP",	"C",	"Informe S ou N (Sim/Não) para ativar a chamada da rotina de impressão de duplicatas após a efetivação do faturamento.", "S")
// Adriano	
u_CriaParam("  ","MV_X_CODCP",	"C",	"Informe o código da condição de pagamento à vista. Utilizado no relatório de acerto do motorista seção de conhecimentos recebidos.", " ")
u_CriaParam("  ","MV_X_NTTPR",	"C",	"Informe o codigo da natureza referente ao titulo contas a pagar do pedido de compras. ", " ") 
u_CriaParam("  ","MV_X_PRTPR",	"C",	"Informe o prefixo referente ao titulo provisorio contas a pagar do pedido de compras.", " ") 
u_CriaParam("  ","MV_X_ARXCV",	"C",	"Informar o código do armazém e código classe de valor relacionado, utilizado nas operações de transferências. Ex: ARM01=00100/ARM02=00200/...", " ") 
u_CriaParam("  ","MV_X_LIBRES",	"C",	"Informar os usuarios autorizados para efetuar a liberacao do calculo da rescisao para funciona rios com férias vencidas", " ") 
u_CriaParam("  ","MV_X_CTRAC",	"C",	"Informe S ou N (Sim/Não) para ativar o controle de alcadas por família de produtos no compras.", "S") 
u_CriaParam("  ","MV_X_ATCDF",	"C",	"Informe S ou N (Sim/Não) para ativar o controle de desconto de contrato de fornecedores na inclusão documento de entrada do compras.", "S") 

Return()   


/* Funçao responsável por APENAS CRIAR o parametro no SX6 conforme parametros passados*/
User function AltPar(cFil, cNome, cTipo, cDescri, cConteudo)
Local cDesc1 := ""
Local cDesc2 := ""
Local cDesc3 := ""               

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

dbSelectArea("SX6")
dbSetOrder(01)

cDesc1 := Substr(cDescri, 1, 50)

if (Len(cDescri)) > 50
	cDesc2 := Substr(cDescri, 51, 50)
EndIf

if (Len(cDescri)) > 100
	cDesc3 := Substr(cDescri, 101, 50)
EndIf

if !dbSeek(cFil + cNome)
	RecLock("SX6", .T.)
	SX6->X6_FIL := cFil
	SX6->X6_VAR := cNome
	SX6->X6_TIPO := cTipo
	SX6->X6_DESCRIC := cDesc1
	SX6->X6_DSCSPA  := cDesc1
	SX6->X6_DSCENG  := cDesc1
	SX6->X6_DESC1   := cDesc2
	SX6->X6_DSCSPA1 := cDesc2
	SX6->X6_DSCENG1 := cDesc2
	SX6->X6_DESC2   := cDesc3
	SX6->X6_DSCSPA2 := cDesc3
	SX6->X6_DSCENG2 := cDesc3
	SX6->X6_CONTEUD := cConteudo
	SX6->X6_PROPRI  := "S"
	SX6->X6_PYME    := "S"
	MsUnLock()
else // só altera o conteúdo
	MsgInfo("Conteudo alterado.")
	RecLock("SX6", .F.)
	SX6->X6_CONTEUD := cConteudo
	SX6->X6_CONTSPA := cConteudo
	SX6->X6_CONTENG := cConteudo	
	MsUnLock()
EndIf


Return

User Function ParamVer()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//u_AltPar("  ","MV_X_ATRTP",	"C",	"Informe S ou N (Sim/Nao) para ativar a opcao de modulo faturamento.", "S")
//u_AltPar("  ","MV_X_QCAGR",	"N",	"Quantidade de caracteres após o código do grupo para compor o tamanho do código de produtos quando gerado de forma seqüencial", "4")
//u_AltPar("  ","MV_X_ATCFC",	"C",	"Informe S ou N (Sim/Não) para ativar os controle no processo de classificação dos documentos de entrada", "S")
//u_AltPar("  ","MV_X_APRGB",	"C",	"Informe S ou N (Sim/Não) para ativar os controles nos pedidos de compras através das validações com base na tabela de fluxo de caixa para compras.", "S")
//u_AltPar("  ","MV_X_NDFCC",	"N",	"Informe o número de dias para o processamento para a inclusão de registros na tabela de fluxo de caixa do compras.", "120")
//u_AltPar("  ","MV_X_USPDC",	"C",	"Informe o login dos supervisores que podem autorizar a inclusão do pedido de compras em data(s) bloqueada(s).", "joaovto")
//u_AltPar("  ","MV_X_CNWFC",	"C",	"Informe o nome do contato para envio de workflow da ficha cadastral do motorista / veiculo nas rotinas de cotacao de frete / solicitacao de  coleta", "aley@cantutransportadora.com.br")
//u_AltPar("  ","MV_X_ATWFC",	"C",	"Informe S ou N (Sim/Nao) para ativar o envio de workflow da ficha cadastral do motorista / veic nas rotinas de cotacao de frete / solicitacao de coleta.", "S")
//u_AltPar("  ","MV_X_ATCCV",	"C",	"Informe S ou N (Sim/Nao) para ativar o calculo de comissoes utilizando as regras de contratos de    vendedores no pedido de venda.                    ", "S")
//u_AltPar("  ","MV_X_ATCDC",	"C",	"Informe S ou N (Sim/Nao) para ativar o calculo de desconto de comissoes utilizando as regras de     desconto de comissoes no pedido de venda.         ", "S")
//u_AltPar("  ","MV_X_APRBN",	"C",	"Informe S ou N (Sim/Nao) para ativar o calculo de regras de bonificações financeiras sobre o faturamento de pedidos.", "S")
//u_AltPar("  ","MV_X_CPPCA",	"C",	"Codigo do produto referente a 1/12 do valor de    comissoes para inclusao de pedido de compras de   pagamento de comissoes do vendedor.               ", " ")
//u_AltPar("  ","MV_X_CPPCV",	"C",	"Codigo do produto referente ao valor das comissoes para inclusao de pedido de compras de pagamento   de comissoes do vendedor.                         ", " ")
//u_AltPar("  ","MV_X_CFPCV",	"C",	"Código da forma de pagamento para inclusão do pedido de compras de pagamento de comissões do vendedor.", "S")
//u_AltPar("  ","MV_X_ACPAD",	"C",	"Informe S ou N (Sim/Não) para ativar a compensação automática do título a pagar referente ao documento de entrada na inclusão da nota fiscal de devolução.", "S")
//u_AltPar("  ","MV_X_AWCFC",	"C",	"Informe S ou N (Sim/Não) para ativar o envio de workflow atraves da rotina de retorno de carga    quando da nao conferencia fiscal.                 ", "S")
//u_AltPar("  ","MV_X_ATPCA",	"C",	"Informe S ou N (Sim/Não) para ativar a inclusão do registro de comissão ao agenciador de frete no calculo de frete.", "S")
//u_AltPar("  ","MV_X_ATIDP",	"C",	"Informe S ou N (Sim/Não) para ativar a chamada da rotina de impressão de duplicatas após a efetivação do faturamento.", "S")
// Adriano	
//u_AltPar("  ","MV_X_CODCP",	"C",	"Informe o código da condição de pagamento à vista. Utilizado no relatório de acerto do motorista seção de conhecimentos recebidos.", " ")
//u_AltPar("  ","MV_X_NTTPR",	"C",	"Informe o codigo da natureza referente ao titulo contas a pagar do pedido de compras. ", " ") 
//u_AltPar("  ","MV_X_PRTPR",	"C",	"Informe o prefixo referente ao titulo provisorio contas a pagar do pedido de compras.", " ") 
//u_AltPar("  ","MV_X_ARXCV",	"C",	"Informar o código do armazém e código classe de valor relacionado, utilizado nas operações de transferências. Ex: ARM01=00100/ARM02=00200/...", " ") 
//u_AltPar("  ","MV_X_LIBRES","C",	"Informar os usuarios autorizados para efetuar a liberacao do calculo da rescisao para funciona rios com férias vencidas", " ") 
//u_AltPar("  ","MV_X_CTRAC",	"C",	"Informe S ou N (Sim/Não) para ativar o controle de alcadas por família de produtos no compras.", "S") 
//u_AltPar("  ","MV_X_ATCDF",	"C",	"Informe S ou N (Sim/Não) para ativar o controle de desconto de contrato de fornecedores na inclusão documento de entrada do compras.", "S") 
u_AltPar("  ","MV_CTBAPLA",	"C",	"Indica se o SigaCTB ira limpar os flags de contabilizacao (_LA/_DTLANC) ao excluir lancamentos. 1=Nao;2=Perguntar;3=Sim c/alertas;4=Sim s/ alertas", "2") 
u_AltPar("  ","MV_CTBFLAG",	"C",	"Indica se a marcacao dos flags de contabilizacao das rotinas Off-Line sera feita na transacao do lancamento contabil - SIGACTB.", "T") 

Alert("Parametros verificados.")

Return()
/*
User Function ParamSel()

Local _cFilOri	:= cFilAnt  
Local _cEmpAnt	:= cEmpAnt
Local _aArea	:= GetArea() 
Local cDlgTitle  := "Empresas/Filiais DESTINO"
Local aCampos    := {}
Local cMarca
Local lInverte   := .f.     
Local aArea		:= GetArea()
LOCAL nOpca		:= 2

_aCampos := {}

AADD(_aCampos,{ "M0_OK"   		, "C" ,02,0 } )
AADD(_aCampos,{ "M0_EMP"		, "C" ,02,0 } )  	
AADD(_aCampos,{ "M0_CODFIL" 	, "C" ,02,0 } )  
AADD(_aCampos,{ "M0_FILIAL" 	, "C" ,45,0 } )  
_cArqTrb1  := CriaTrab(_aCampos)
_cArqInd1  := CriaTrab(NIL,.F.)

dbUseArea( .T.,,_cArqTrb1,"TRBM0",.F. )
dbSelectArea("TRBM0")
_cChave1  := "M0_EMP+M0_CODFIL"
IndRegua("TRBM0",_cArqInd1,_cChave1,,,"Selecionando Registros...")
dbSelectArea("TRBM0")
cMarca     := GetMark()
aCampos := {}
AADD(aCampos,{"M0_OK"				,"" ,"Ok"      		," " })
AADD(aCampos,{"M0_EMP"				,"" ,"Empresa"     	," " })
AADD(aCampos,{"M0_CODFIL"			,"" ,"Filial"     	," " })
AADD(aCampos,{"M0_FILIAL"			,"" ,"Descrição"    ," " })

SM0->(DbSelectArea("SM0"))
SM0->(DbGotop())
_cEmpr	:= "" 
While !SM0->(Eof())
	TRBM0->(DbSelectArea("TRBM0"))
	If !SM0->M0_CODIGO $ _cEmpr
		TRBM0->(RecLock("TRBM0", .T.))
			TRBM0->M0_EMP		:= SM0->M0_CODIGO
			TRBM0->M0_CODFIL	:= SM0->M0_CODFIL
			TRBM0->M0_FILIAL	:= SM0->M0_FILIAL		
		TRBM0->(MsUnlock("TRBM0")) 
		_cEmpr += SM0->M0_CODIGO+"/"
	Endif
	SM0->(DbSkip())
End
cFilAnt := _cFilOri
cEmpAnt := _cEmpAnt
TRBM0->(DbGoTop())
DEFINE MSDIALOG oDlg TITLE cDlgTitle From 3,1 To 450,700 OF oMainWnd PIXEL
    
@ 013,001 TO 74,350

oMark := MsSelect():New("TRBM0","M0_OK",,aCampos,@lInverte,@cMarca,{022,1,220,350})
ObjectMethod(oMark:oBrowse,"Refresh()")
oMark:oBrowse:lhasMark = .T.
oMark:oBrowse:lCanAllmark := .F.
oMark:oBrowse:Refresh()           

ACTIVATE MSDIALOG oDlg ON INIT EnChoiceBar(oDlg,{||nOpca:=1,if(TudoOk(),oDlg:End(),.f.) } , {||nOpca:=2,oDlg:End()})  CENTER
// Gravo os dados das empresas/filiais destino.
aEmpr	:= {}
If nOpca == 1
	TRBM0->(DbSelectArea("TRBM0"))
	TRBM0->(DbGotop())
	While !TRBM0->(Eof())
		If TRBM0->(Marked("M0_OK"))
			nPosicao  := ascan(aEmpr,{|_x| TRBM0->M0_EMP == _x[1]})
			If nPosicao = 0
				AADD(aEmpr,{TRBM0->M0_EMP,TRBM0->M0_CODFIL})
			Endif
		Endif                                               
		TRBM0->(DbSkip())	
	End     	
Endif
TRBM0->(DbSelectArea("TRBM0"))
TRBM0->(DbCloseArea())
Prepare Environment Empresa _cEmpAnt Filial _cFilOri MODULO "FAT" TABLES "SB1"
For nR := 1 To Len(aEmpr)
	RpcClearEnv()       
	RPCSetType(3)		
	Prepare Environment Empresa aEmpr[nR,1] Filial aEmpr[nR,2] MODULO "FAT" 
	u_ParamVer()
Next nR
Alert("Parametros verificados.")
Prepare Environment Empresa _cEmpAnt Filial _cFilOri MODULO "FAT" TABLES "SX6"

Return Nil
*/