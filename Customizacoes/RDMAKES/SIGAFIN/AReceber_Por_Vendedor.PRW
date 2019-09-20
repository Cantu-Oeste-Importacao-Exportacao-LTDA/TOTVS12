#include "rwmake.ch"
#include "topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ARECVEND  º Autor ³ Adriano Novachaelley Data ³  18/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de contas a receber.                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ARecVend(cVendI,cVendF,cMail,lSched, aEmps)

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de CONTAS A RECEBER de acordo com os parametros "
Local cDesc3        := "informados pelo usuario."
Local cPict         := ""
Local titulo       	:= "CONTAS A RECEBER"
Local nLin         	:= 80
Local Cabec1       	:= "cCabec1"
Local Cabec2       	:= "NOME CLIENTE                              |PRF-NUMERO     -PA|TP |NATUREZA | EMISSAO|  VENCTO |                 VALOR TITULO|   BX. PARCIAL|    DEVOLUÇÕES| SALDO DEVEDOR| HISTORICO      |CODIGO - NOME VENDEDOR"
Local imprime      	:= .T.
Local aOrd 			    := {"Vencimento","Vendedor X Vencimento"}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "ARECVEND"
Private nTipo       := 15
Private aReturn     := { "A4", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "ARECVEND" 
Private cPerg		    := "ARECVEND"
Private cString 	  := "SE1"
Private oSrv
Private cIp         := "192.168.205.32"
Private cPort       := "12090"
Private cEnv        := GetEnvServer()        
Private aEmpTmp     := aEmps
Private cReprIni    := cVendI
Private cReprFin    := cVendF
Private cEmail      := cMail


If lSched

	lWF				:= .T. 
  Conout("PROCESSAMENTO ATRAVÉS DE WORKFLOW...")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tenta fazer a conexão com o server do schedule³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	oSrv := RpcConnect(cIP, Val(cPort), cEnv, "40", "01")
	if !(valtype(oSrv) == "O")
		ConOut("NÃO FOI POSSÍVEL CONECTAR NO SERVIDOR...")
		ConOut("IP: " + cIP + " PORT: " + cPort)
		Return
	EndIf        	
	
	RpcClearEnv()
	RpcSetType(3)
	RpcSetEnv("40", "01",,,,GetEnvServer(),{ "SE1" })	
	
	RunReport(Cabec1,Cabec2,Titulo,nLin, lWf)
	
	RpcDisconnect(oSrv)
	RpcClearEnv()
	
Else
	PergunteSX1()
	Pergunte(cPerg,.F.)
	lWF	:= .F. 
	Conout("PROCESSAMENTO ATRAVÉS DE EXECUÇÃO MANUAL...")
	
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.T., , ,lWF, .T. )
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString,,lWF)
	
	If nLastKey == 27
	   Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin, lWf) },Titulo)
	
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RUNREPORT() ºAutor  ³Jean Saggin       º Data ³  06/11/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função que faz a geração do relatório ou workflow          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin, lWf)
Local aAreaSM0
Local nOrdem  
Local i := 0

If !lWf
	lSched  	:= .F.
	Cabec1  	:= "A RECEBER ATÉ O VENCIMENTO: "+DtoC(mv_par16)
	cCliIni		:= mv_par01 				// Cliente Inicial
	cCliFin		:= mv_par02 				// Cliente Final
	cLojIni		:= mv_par03 				// Loja Inicial
	cLojFin		:= mv_par04 				// Loja Final
	cPreIni		:= mv_par05 				// Prefixo Inicial
	cPreFin		:= mv_par06 				// Prefixo Final
	cNfIni		:= mv_par07 				// NF Inicial
	cNfFin		:= mv_par08 				// NF Final
	cPedIni		:= mv_par09 				// Pedido Inicial
	cPedFin		:= mv_par10 				// Pedido Final
	cBcoIni		:= mv_par11 				// Banco/Portador Inicial
	cBcoFin		:= mv_par12 				// Banco/Portador Final
	dEmiIni		:= DtoS(mv_par13) 	// Emissao Inicial
	dEmiFin		:= DtoS(mv_par14)		// Emissao Final
	dVctIni		:= DtoS(mv_par15) 	// Vencimento Inicial
	dVctFin		:= DtoS(mv_par16) 	// Vencimento Final
	cNatIni		:= mv_par17 				// Natureza Inicial
	cNatFin		:= mv_par18 				// Natureza Final
	cVenIni		:= mv_par19 				// Vendedor Inicial
	cVenFin		:= mv_par20 				// Vendedor Final
	cSitIni		:= mv_par21 				// Situação Inicial
	cSitFin		:= mv_par22 				// Situação Final

	cVendI 		:= cVenIni
	cVendF 		:= cVenFin	

	Do Case
		Case mv_par23 == 1
			_cVend 		:= "E1.E1_VEND1"
			_cAlVend	:= "TMP->E1_VEND1"
		Case mv_par23 == 2
			_cVend 		:= "E1.E1_VEND2"
			_cAlVend	:= "TMP->E1_VEND2"
		Case mv_par23 == 3
			_cVend 		:= "E1.E1_VEND3"
			_cAlVend	:= "TMP->E1_VEND3"			
		Case mv_par23 == 4
			_cVend 		:= "E1.E1_VEND4"
			_cAlVend	:= "TMP->E1_VEND4"			
		Case mv_par23 == 5
			_cVend 		:= "E1.E1_VEND5"
			_cAlVend	:= "TMP->E1_VEND5"						
	EndCase
	
	Do Case
		Case aReturn[8] == 1
			cOrdem	:= " E1.E1_VENCREA, E1.E1_CLIENTE "
			cQuebra	:= "SubStr(TMP->E1_VENCREA,1,6)"
			cSubT	:= " "
		Case aReturn[8] == 2
			cOrdem	:= _cVend+", E1.E1_VENCREA "
			cQuebra	:= _cAlVend+"+SubStr(TMP->E1_VENCREA,1,6)"
			cSubT	:= _cAlVend
	End Case                      
	
Else
	nDias		:= 0
	nDias		:= SuperGetMV("MV_DIAVENC",,1)   	// Dias para considerar titulos vencidos no relatorio
	titulo 		:= AllTrim(titulo)+" - "+"EM ATRASO"
	Cabec1 		:= "A RECEBER ATÉ O VENCIMENTO: "+DtoC(Date()-nDias)
	cCliIni		:= "      " 										// Cliente Inicial
	cCliFin		:= "ZZZZZZ" 										// Cliente Final
	cLojIni		:= "  " 												// Loja Inicial
	cLojFin		:= "ZZ" 												// Loja Final
	cPreIni		:= "   " 												// Prefixo Inicial
	cPreFin		:= "ZZ" 												// Prefixo Final
	cNfIni		:= "      " 										// NF Inicial
	cNfFin		:= "ZZZZZZ" 										// NF Final
	cPedIni		:= "      " 										// Pedido Inicial
	cPedFin		:= "ZZZZZZ" 										// Pedido Final
	cBcoIni		:= "   " 												// Banco/Portador Inicial
	cBcoFin		:= "ZZZ" 												// Banco/Portador Final
	dEmiIni		:= "20000101" 									// Emissao Inicial
	dEmiFin		:= DtoS(Date())   							// Emissao Final
	dVctIni		:= "20000101" 									// Vencimento Inicial
	dVctFin		:= DtoS(Date()-nDias) 				  // Vencimento Final
	cNatIni		:= "       " 										// Natureza Inicial
	cNatFin		:= "ZZZZZZZ" 										// Natureza Final
	cVenIni		:= cReprIni 											// Vendedor Inicial
	cVenFin		:= cReprFin 											// Vendedor Final
	cSitIni		:= " " 													// Situação Inicial
	cSitFin		:= "Z" 													// Situação Final
	_cVend 		:= "E1.E1_VEND1"
	_cAlVend	:= "TMP->E1_VEND1"

	If cReprIni == cReprFin
		cOrdem	:= " E1_CLIENTE, E1_VENCREA, E1_FILIAL "
		cQuebra	:= " TMP->E1_CLIENTE "
		cSubT	:= " "
	Else
		cOrdem	:= " E1_VENCREA, E1_CLIENTE, E1_FILIAL "
		cQuebra	:= "SubStr(TMP->E1_VENCREA,1,6)"
		cSubT	:= " "	
	Endif

Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Seleciona todos os títulos que estão em aberto dos clientes do vendedor³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cSql := "SELECT * FROM ( "    

for i := 1 to len(aEmpTmp)

	cSql += "SELECT E1.E1_PREFIXO, E1.E1_PARCELA, E1.E1_SITUACA, E1.E1_NUM, "+_cVend+", "
	cSql += "				E1.E1_TIPO,E1.E1_NATUREZ, E1.E1_EMISSAO,E1.E1_VENCTO,E1.E1_VENCREA,E1.E1_PORTADO,E1.E1_AGEDEP, E1.E1_NUMBCO, "
	cSql += "				E1.E1_CLIENTE, E1.E1_LOJA, E1.E1_VALOR, E1.E1_SALDO, E1.E1_HIST,E1.E1_SDACRES,E1.E1_ACRESC, E1.E1_FILIAL "
	cSql += "FROM SE1" + aEmpTmp[i] + "0 E1 "
	cSql += "WHERE E1.D_E_L_E_T_ <> '*' " 
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se for execução por workflow, pega títulos de todas as filiais, caso contrário, pega apenas os títulos da filial posicionada.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If !lWf
		cSql += "AND E1.E1_FILIAL = '"+xFilial("SE1")+"' "
	Else
		cSql += "AND E1.E1_FILIAL BETWEEN '  ' AND 'ZZ' "
	Endif
	
	cSql += "AND E1.E1_CLIENTE between '"+cCliIni+"' AND '"+cCliFin+"' "
	cSql += "AND E1.E1_LOJA between    '"+cLojIni+"' AND '"+cLojFin+"' "
	cSql += "AND E1.E1_PREFIXO between '"+cPreIni+"' AND '"+cPreFin+"' "
	cSql += "AND E1.E1_NUM between     '"+cNfIni+"'  AND '"+cNfFin+"' "
	cSql += "AND E1.E1_PEDIDO between  '"+cPedIni+"' AND '"+cPedFin+"' "
	cSql += "AND E1.E1_NUMBCO between  '"+cBcoIni+"' AND '"+cBcoFin+"' "
	cSql += "AND E1.E1_EMISSAO between '"+dEmiIni+"' AND '"+dEmiFin+"' "
	cSql += "AND E1.E1_VENCREA between  '"+dVctIni+"' AND '"+dVctFin+"' "
	cSql += "AND E1.E1_NATUREZ between '"+cNatIni+"' AND '"+cNatFin+"' "
	cSql += "AND "+_cVend+" between   '"+cVenIni+"' AND '"+cVenFin+"' "
	cSql += "AND E1.E1_SITUACA between '"+cSitIni+"' AND '"+cSitFin+"' "
  	cSql += "AND E1.E1_TIPO NOT IN ('NCC','RA') "    //Gustavo 23/06/14 - Ignorar pagamentos antecipados pois não são pendencias.
	cSql += "AND E1.E1_SALDO <> 0 "
  
  if i != Len(aEmpTmp)
  	cSql += " UNION ALL "	
  Else
    cSql += ") "
  EndIf

Next i

cSql += "ORDER BY E1_CLIENTE, E1_VENCREA "
cSql := ChangeQuery(cSql)

TcQuery cSql NEW ALIAS "TMP"
DbSelectArea("TMP")            
TMP->(DbGotop())   

nQuant := 0
count to nQuant

TMP->(DbGoTop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se tem títulos em aberto para o representante, caso não tiver aborta a execução da função.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

if TMP->(EOF())
	Conout("NÃO HÁ TÍTULOS PENDENTES PARA O REPRESENTANTE " + Trim(cVenIni))
	TMP->(DbCloseArea())
	Return Nil    
Else
	Conout("PROCESSANDO " +AllTrim(Str(nQuant))+ " TÍTULOS DO REPRESENTANTE...")
EndIf

_cVer	:= " "
_cVer	:= &cQuebra
_cSub	:= &cSubT
nSValor	:= 0
nSBParc	:= 0
nSBDev	:= 0
nSSldo	:= 0

nVValor	:= 0
nVBParc	:= 0
nVBDev	:= 0
nVSldo	:= 0 

nTValor	:= 0
nTBParc	:= 0
nTBDev	:= 0
nTSldo	:= 0 
nPass	  := 0
_cNVend	:= ""

If !lWf
  Conout("PROCESSANDO RELATÓRIO.")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ‡¿
	//³Caso execução não for através de workflow³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ‡Ù
	
	While !TMP->(Eof())
		If nLin > 60
		   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		   nLin := 9
		Endif
		If &cQuebra <> _cVer
			If aReturn[8] == 1 .Or. lSched
				@nLin, 076 Psay "TOTAL MÊS"
				@nLin, 087 Psay SubStr(_cVer,5,2)+"/"+SubStr(_cVer,1,4)
				@nLin, 110 Psay nSValor Picture "@E 999,999,999.99"
				@nLin, 125 Psay nSBParc Picture "@E 999,999,999.99"
				@nLin, 140 psay nSBDev Picture "@E 999,999,999.99"
				@nLin, 155 Psay nSSldo Picture "@E 999,999,999.99"
			Else 
				@nLin, 076 Psay "TOTAL MÊS"
				@nLin, 087 Psay SubStr(_cVer,11,2)+"/"+SubStr(_cVer,7,4)
				@nLin, 110 Psay nSValor Picture "@E 999,999,999.99"
				@nLin, 125 Psay nSBParc Picture "@E 999,999,999.99"
				@nLin, 140 psay nSBDev Picture "@E 999,999,999.99"
				@nLin, 155 Psay nSSldo Picture "@E 999,999,999.99"
			Endif
			nLin += 1
			If nLin > 60
			   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			   nLin := 9
			Endif		
			If (_cSub <> &cSubT) .And. (aReturn[8] == 2)
				@nLin, 076 Psay "TOTAL VENDEDOR "
				@nLin, 110 Psay nVValor Picture "@E 999,999,999.99"
				@nLin, 125 Psay nVBParc Picture "@E 999,999,999.99"
				@nLin, 140 psay nVBDev Picture "@E 999,999,999.99"
				@nLin, 155 Psay nVSldo Picture "@E 999,999,999.99"			
				
				nVValor	:= 0
				nVBParc	:= 0
				nVBDev	:= 0
				nVSldo	:= 0
				nLin += 2
			Endif
			@nLin,  0 Psay __PrtThinLine()
			nLin += 1		
			nSValor	:= 0
			nSBParc	:= 0
			nSBDev	:= 0
			nSSldo	:= 0
			If nLin > 60
			   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			   nLin := 9
			Endif		
		Endif
		nPass += 1  
		@nLin, 000 Psay TMP->A1_NOME
		@nLin, 043 Psay TMP->E1_PREFIXO
		@nLin, 046 Psay "-"
		@nLin, 047 Psay TMP->E1_NUM
		@nLin, 058 Psay "-"
		@nLin, 059 Psay TMP->E1_PARCELA
		@nLin, 062 Psay TMP->E1_TIPO
		@nLin, 066 Psay TMP->E1_NATUREZ
		@nLin, 076 Psay StoD(TMP->E1_EMISSAO)
		@nLin, 086 Psay StoD(TMP->E1_VENCREA)

		cSql := "SELECT E5_VALOR, E5_RECPAG FROM "+	RetSqlName("SE5") + " 
		cSql += "WHERE D_E_L_E_T_ <> '*' "
		cSql += "AND E5_FILIAL = '"+TMP->E1_FILIAL+"' "
		cSql += "AND E5_TIPODOC = 'CP' "
		cSql += "AND E5_NUMERO = '"+TMP->E1_NUM+"' "
		cSql += "AND E5_PARCELA = '"+TMP->E1_PARCELA+"' "
		cSql += "AND E5_PREFIXO = '"+TMP->E1_PREFIXO+"' "	
		cSql += "AND E5_CLIFOR = '"+TMP->E1_CLIENTE+"' "	
		cSql += "ORDER BY E5_FILIAL, E5_DOCUMEN "
		cSql := ChangeQuery(cSql)
		TcQuery cSql NEW ALIAS "TMA"

		nSaldoNcc := 0
		dbSelectArea("TMA")
	    DbGotop()
	    While !TMA->(Eof())
	    	IF TMA->E5_RECPAG = 'R'
				nSaldoNCC += TMA->E5_VALOR
			Else
				nSaldoNCC += -TMA->E5_VALOR
			Endif
			TMA->(DbSkip())
		Enddo
		DbSelectArea("TMA")
		TMA->(dbCloseArea())
		
		DbSelectArea("TMP")
		@nLin, 110 Psay (TMP->E1_VALOR+TMP->E1_SDACRES) Picture "@E 999,999,999.99"
		nSValor	+= (TMP->E1_VALOR+TMP->E1_SDACRES)
		nVValor	+= (TMP->E1_VALOR+TMP->E1_SDACRES)
		nTValor	+= (TMP->E1_VALOR+TMP->E1_SDACRES)	
		
		nDesc      := 0
		If TMP->E1_SALDO <> TMP->E1_VALOR
			If (TMP->E1_VALOR +TMP->E1_ACRESC - TMP->E1_SALDO - TMP->E1_SDACRES) <> 0 .And. nSaldoNCC <> 0
				nDesc := nSaldoNCC
			Else
				nDesc := 0
			EndIf
			@nLin, 125 PSAY (TMP->E1_VALOR +TMP->E1_ACRESC - TMP->E1_SALDO - TMP->E1_SDACRES) - nSaldoNCC Picture "@E 999,999,999.99"
			nSBParc	+= (TMP->E1_VALOR +TMP->E1_ACRESC - TMP->E1_SALDO - TMP->E1_SDACRES) - nSaldoNCC
			nVBParc	+= (TMP->E1_VALOR +TMP->E1_ACRESC - TMP->E1_SALDO - TMP->E1_SDACRES) - nSaldoNCC		
			nTBParc	+= (TMP->E1_VALOR +TMP->E1_ACRESC - TMP->E1_SALDO - TMP->E1_SDACRES) - nSaldoNCC				
		Else
			nVal := 0
			@nLin, 125 PSAY nVal Picture "@E 999,999,999.99"
		EndIf
		@nLin, 140 Psay nSaldoNcc Picture "@E 999,999,999.99"
		nSBDev	+= nSaldoNcc	
		nVBDev	+= nSaldoNcc			
		nTBDev	+= nSaldoNcc				
	
		@nLin, 155 Psay (TMP->E1_SALDO+TMP->E1_SDACRES) Picture "@E 999,999,999.99"	
		nSSldo += (TMP->E1_SALDO+TMP->E1_SDACRES)
		nVSldo += (TMP->E1_SALDO+TMP->E1_SDACRES)	
		nTSldo += (TMP->E1_SALDO+TMP->E1_SDACRES)	
			
		@nLin, 171 Psay SubStr(TMP->E1_HIST,1,15)
		
		@nLin, 187 Psay &_cAlVend
		@nLin, 194 Psay "-"
		@nLin, 196 Psay SubStr(TMP->A3_NOME,1,25)
		_cNVend	:= TMP->A3_NOME
		
		nLin += 1
		_cVer	:= &cQuebra	
		_cSub	:= &cSubT
		TMP->(DbSkip())
	End
	
	If &cQuebra <> _cVer
		If aReturn[8] == 1 
			@nLin, 076 Psay "TOTAL MÊS"
			@nLin, 087 Psay SubStr(_cVer,5,2)+"/"+SubStr(_cVer,1,4)
			@nLin, 110 Psay nSValor Picture "@E 999,999,999.99"
			@nLin, 125 Psay nSBParc Picture "@E 999,999,999.99"
			@nLin, 140 psay nSBDev Picture "@E 999,999,999.99"
			@nLin, 155 Psay nSSldo Picture "@E 999,999,999.99"
		Else 
			@nLin, 076 Psay "TOTAL MÊS"
			@nLin, 087 Psay SubStr(_cVer,11,2)+"/"+SubStr(_cVer,7,4)
			@nLin, 110 Psay nSValor Picture "@E 999,999,999.99"
			@nLin, 125 Psay nSBParc Picture "@E 999,999,999.99"
			@nLin, 140 psay nSBDev Picture "@E 999,999,999.99"
			@nLin, 155 Psay nSSldo Picture "@E 999,999,999.99"
		Endif
		nLin += 1
		If nLin > 60
		   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		   nLin := 9
		Endif		
		If (_cSub <> &cSubT) .And. (aReturn[8] == 2) .Or. lSched
			If cVendI == cVendF
				@nLin, 076 Psay "TOTAL VENDEDOR "
				@nLin, 110 Psay nVValor Picture "@E 999,999,999.99"
				@nLin, 125 Psay nVBParc Picture "@E 999,999,999.99"
				@nLin, 140 psay nVBDev Picture "@E 999,999,999.99"
				@nLin, 155 Psay nVSldo Picture "@E 999,999,999.99"			
			Endif
			If (_cSub <> &cSubT) .And. (aReturn[8] == 2) .AND. ! lSched
				@nLin, 076 Psay "TOTAL VENDEDOR "
				@nLin, 110 Psay nVValor Picture "@E 999,999,999.99"
				@nLin, 125 Psay nVBParc Picture "@E 999,999,999.99"
				@nLin, 140 psay nVBDev Picture "@E 999,999,999.99"
				@nLin, 155 Psay nVSldo Picture "@E 999,999,999.99"			
				
				nVValor	:= 0
				nVBParc	:= 0
				nVBDev	:= 0
				nVSldo	:= 0
				nLin += 2
			Endif		
			
			nVValor	:= 0
			nVBParc	:= 0
			nVBDev	:= 0
			nVSldo	:= 0
			nLin += 2
		Endif
		@nLin,  0 Psay __PrtThinLine()
		nLin += 1		
		nSValor	:= 0
		nSBParc	:= 0
		nSBDev	:= 0
		nSSldo	:= 0
		If nLin > 60
		   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		   nLin := 9
		Endif
		@nLin, 076 Psay "TOTAL GERAL "
		@nLin, 110 Psay nTValor Picture "@E 999,999,999.99"
		@nLin, 125 Psay nTBParc Picture "@E 999,999,999.99"
		@nLin, 140 psay nTBDev Picture "@E 999,999,999.99"
		@nLin, 155 Psay nTSldo Picture "@E 999,999,999.99"			
	Endif  
  
	If Select("SX6") == 0 
		If aReturn[5]==1
		   dbCommitAll()
		   SET PRINTER TO
		Endif
	Else
		SET DEVICE TO SCREEN
		If aReturn[5]==1
		  dbCommitAll()
		  SET PRINTER TO
		  OurSpool(wnrel)
		Endif
	Endif
	MS_FLUSH()

Else 
	Conout("PREPARANDO WORKFLOW..")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Caso for execução através de Workflow³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cVndNome := Posicione("SA3",1,xFilial("SA3") + TMP->E1_VEND1,"A3_NOME")
	nControle := 0
	
	While !TMP->(Eof())
    
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se for primeira execução, monta cabeçalho do workflow³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If nControle == 0
		
			oProcess := TWFProcess():New( "wffin001", "Contas a Receber" )
			oProcess:NewTask("wffin001","\workflow\wfareceber.htm")	
			oHTML := oProcess:oHTML
			oHtml:ValByName( "cVEND"		   ,TMP->E1_VEND1)
			oHtml:ValByName( "cEMISSAO"		 ,Date())	
			oHtml:ValByName( "cNVen"		   ,cVndNome)
			oHtml:ValByName( "cVencimento" ,StoD(dVctFin))
			
			cCliNome := Posicione("SA1",1,xFilial("SA1") + TMP->E1_CLIENTE + TMP->E1_LOJA, "A1_NOME")
			oProcess:cSubject := "A RECEBER EM ATRASO - CLIENTE "+SubStr(cCliNome,01,30)
		EndIf
	  
		If &cQuebra <> _cVer
			AAdd( oHtml:ValByName( "IT.CLIFOR"), "----------> TOTAL DO CLIENTE ")
			AAdd( oHtml:ValByName( "IT.NUM" ),   "")
			AAdd( oHtml:ValByName( "IT.PARCELA"),"")		  				
			AAdd( oHtml:ValByName( "IT.EMISSAO"),"")
			AAdd( oHtml:ValByName( "IT.VENCREA"),"")
			AAdd( oHtml:ValByname( "IT.VALOR"),  Transform(nVValor,PesqPict("SE1","E1_VALOR")))
			AAdd( oHtml:ValByname( "IT.SALDO"),  Transform(nVSldo,PesqPict("SE1","E1_SALDO")))		
			AAdd( oHtml:ValByname( "IT.HIST"),   "")
			AAdd( oHtml:ValByname( "IT.FILIAL"), "")			
						
			AAdd( oHtml:ValByName( "IT.CLIFOR" )	,"-")
			AAdd( oHtml:ValByName( "IT.NUM" )		,"")		   		
			AAdd( oHtml:ValByName( "IT.PARCELA" )	,"")		  				
			AAdd( oHtml:ValByName( "IT.EMISSAO" )	,"")
			AAdd( oHtml:ValByName( "IT.VENCREA" )	,"")
			AAdd( oHtml:ValByname( "IT.VALOR")		,"")
			AAdd( oHtml:ValByname( "IT.SALDO")		,"")		
			AAdd( oHtml:ValByname( "IT.HIST")		,"")			
			AAdd( oHtml:ValByname( "IT.FILIAL")		,"")			
			nVValor	:= 0
			nVBParc	:= 0
			nVBDev	:= 0
			nVSldo	:= 0

			nSValor	:= 0
			nSBParc	:= 0
			nSBDev	:= 0
			nSSldo	:= 0
			
			nControle := 0                 
			
			oProcess:cTo := cEmail
			oProcess:Start()
			oProcess:Finish()
			oProcess:Free()
			
		Endif         
		
		if nControle == 0
			oProcess := TWFProcess():New( "wffin001", "Contas a Receber" )
			oProcess:NewTask("wffin001","\workflow\wfareceber.htm")	
			oHTML := oProcess:oHTML
			oHtml:ValByName( "cVEND"		   ,TMP->E1_VEND1)
			oHtml:ValByName( "cEMISSAO"		 ,Date())	
			oHtml:ValByName( "cNVen"		   ,cVndNome)
			oHtml:ValByName( "cVencimento" ,StoD(dVctFin))
			
			cCliNome := Posicione("SA1",1,xFilial("SA1") + TMP->E1_CLIENTE + TMP->E1_LOJA, "A1_NOME")
			oProcess:cSubject := "A RECEBER EM ATRASO - CLIENTE "+SubStr(cCliNome,01,30)
			nControle++
		EndIf                                           
		
		AAdd( oHtml:ValByName( "IT.CLIFOR" )	,cCliNome)
		AAdd( oHtml:ValByName( "IT.NUM" )		,TMP->E1_NUM+" - "+TMP->E1_PREFIXO)		  
		AAdd( oHtml:ValByName( "IT.PARCELA" )	,TMP->E1_PARCELA)		  				
		AAdd( oHtml:ValByName( "IT.EMISSAO" )	,StoD(TMP->E1_EMISSAO))
		AAdd( oHtml:ValByName( "IT.VENCREA" )	,StoD(TMP->E1_VENCREA))
		AAdd( oHtml:ValByname( "IT.VALOR")		,Transform(TMP->E1_VALOR+TMP->E1_SDACRES,PesqPict("SE1","E1_VALOR")))
		AAdd( oHtml:ValByname( "IT.SALDO")		,Transform((TMP->E1_SALDO+TMP->E1_SDACRES),PesqPict("SE1","E1_SALDO")))		
		AAdd( oHtml:ValByname( "IT.HIST")		,TMP->E1_HIST)				
		AAdd( oHtml:ValByname( "IT.FILIAL")		,TMP->E1_FILIAL)					
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Resumo de Valores³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		nSValor	+= (TMP->E1_VALOR+TMP->E1_SDACRES)
		nVValor	+= (TMP->E1_VALOR+TMP->E1_SDACRES)
		nTValor	+= (TMP->E1_VALOR+TMP->E1_SDACRES)	

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Resumo do Saldo
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		
		nSSldo += (TMP->E1_SALDO+TMP->E1_SDACRES)
		nVSldo += (TMP->E1_SALDO+TMP->E1_SDACRES)	
		nTSldo += (TMP->E1_SALDO+TMP->E1_SDACRES)	
		
		nLin += 1
		_cVer	:= &cQuebra	
		_cSub	:= &cSubT
		
		nControle++
		
		TMP->(DbSkip()) 
		                                      
	End
	
	If &cQuebra <> _cVer
		AAdd( oHtml:ValByName( "IT.CLIFOR" )	,"----------> TOTAL DO CLIENTE ")
		AAdd( oHtml:ValByName( "IT.NUM" )		,"")
		AAdd( oHtml:ValByName( "IT.PARCELA" )	,"")		  				
		AAdd( oHtml:ValByName( "IT.EMISSAO" )	,"")
		AAdd( oHtml:ValByName( "IT.VENCREA" )	,"")
		AAdd( oHtml:ValByname( "IT.VALOR")		,Transform(nVValor,PesqPict("SE1","E1_VALOR")))
		AAdd( oHtml:ValByname( "IT.SALDO")		,Transform(nVSldo,PesqPict("SE1","E1_SALDO")))		
		AAdd( oHtml:ValByname( "IT.HIST")		,"")
    AAdd( oHtml:ValByname( "IT.FILIAL")		,"")
							
	Endif 
Endif      

DbSelectArea("TMP")
TMP->(DbCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o processo está sendo executado por workflow e vê se foram inclusos títulos³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If lWF 
	oProcess:cSubject := "A RECEBER EM ATRASO - CLIENTE "+SubStr(cCliNome,01,30)
	oProcess:cTo := cEmail
		
	oProcess:Start()
	oProcess:Finish()
	oProcess:Free()

Endif

Return

Static Function PergunteSX1()
xAlias := Alias()                                     		

dbSelectArea("SX1")
dbSetOrder(1)
aRegs :={}
cPerg := PADR(cPerg,10)
aAdd(aRegs,{cPerg,"01","Do Cliente         ?","","","mv_ch1","C",10,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA1","",""})
aAdd(aRegs,{cPerg,"02","Ate o Cliente      ?","","","mv_ch2","C",10,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA1","",""})
aAdd(aRegs,{cPerg,"03","Da Loja            ?","","","mv_ch3","C",02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Ate a Loja         ?","","","mv_ch4","C",02,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Do Prefixo         ?","","","mv_ch5","C",03,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Ate o Prefixo      ?","","","mv_ch6","C",03,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Da NF              ?","","","mv_ch7","C",10,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","Ate a NF           ?","","","mv_ch8","C",10,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"09","Do Pedido          ?","","","mv_ch9","C",10,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"10","Ate o Pedido       ?","","","mv_ch10","C",10,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"11","Do Banco           ?","","","mv_ch11","C",10,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","SA6","",""})
aAdd(aRegs,{cPerg,"12","Ate o Banco        ?","","","mv_ch12","C",10,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","SA6","",""})
aAdd(aRegs,{cPerg,"13","Da Emissao         ?","","","mv_ch13","D",10,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"14","Ate a Emissao      ?","","","mv_ch14","D",10,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"15","Do Vencimento      ?","","","mv_ch15","D",10,0,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"16","Ate o Vencimento   ?","","","mv_ch16","D",10,0,0,"G","","mv_par16","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"17","Da Natureza        ?","","","mv_ch17","C",10,0,0,"G","","mv_par17","","","","","","","","","","","","","","","","","","","","","","","","","SED","",""})
aAdd(aRegs,{cPerg,"18","Ate a Natureza     ?","","","mv_ch18","C",10,0,0,"G","","mv_par18","","","","","","","","","","","","","","","","","","","","","","","","","SED","",""})
aAdd(aRegs,{cPerg,"19","Do Vendedor        ?","","","mv_ch19","C",10,0,0,"G","","mv_par19","","","","","","","","","","","","","","","","","","","","","","","","","SA3","",""})
aAdd(aRegs,{cPerg,"20","Ate o Vendedor     ?","","","mv_ch20","C",10,0,0,"G","","mv_par20","","","","","","","","","","","","","","","","","","","","","","","","","SA3","",""})
aAdd(aRegs,{cPerg,"21","Situacao De        ?","","","mv_ch21","C",01,0,0,"G","","mv_par21","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"22","Situacao Ate       ?","","","mv_ch22","C",01,0,0,"G","","mv_par22","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"23","Considerar         ?","","","mv_ch23","N",01,0,1,"C","","mv_par23","Vendedor 1","Vendedor 1","Vendedor 1","","","Vendedor 2","Vendedor 2","Vendedor 2","","","Vendedor 3","Vendedor 3","Vendedor 3","","","Vendedor 4","Vendedor 4","Vendedor 4","","","Vendedor 5","Vendedor 5","Vendedor 5"," ","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
dbSelectArea(xAlias)
            
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍ192.168.220.40
rootÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ARECVB  ºAutor  ³Jean Saggin  		     º Data ³  11/05/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina cadastrada no schedule que faz o envio de e-mails   º±±
±±º          ³ de inadimplência para todos os vendedores.                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ARecVB(cEmpPar, cFilPar)

Local cEol 		:= CHR(13)+CHR(10)
Local aEmp    := {"40","01"}
Local nRECSM0 := 0
Public cVendI := " "
Public cVendF := " "
Public cMail 	:= " "
Public lSched := .T.

RpcClearEnv()
RPCSetType(3) 
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Colocado fixo para que o sistema acesse a empresa 40, pois dentro dela serão selecionados dados de todas as demais.
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

PREPARE ENVIRONMENT EMPRESA aEmp[01] FILIAL aEmp[02] MODULO "FAT" TABLES "SA1","SA3","SE1"

Conout("*** INICIANDO WORKFLOW DE INADIMPLÊNCIA ***")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Loop no cadastro de empresas pra pegar os diferentes códigos³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aAreaSM0 := SM0->(GetArea())
DbSelectArea("SM0")
SM0->(DbGoTop())
cTmp    := ""
aEmps   := {}

While !SM0->(EOF())
	if cTmp != SM0->M0_CODIGO
		Aadd(aEmps, SM0->M0_CODIGO)
	EndIf
	cTmp := SM0->M0_CODIGO
	SM0->(DbSkip())
EndDo

RestArea(aAreaSM0)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Busca código e e-mail dos representantes e gerentes para fazer o envio dos workflows.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cSql := "SELECT A3.A3_COD, A3.A3_EMAIL AS MAILVEND, A3.A3_MSBLQL, A3.A3_GERASE2, " + cEol
cSql += "(SELECT B.A3_EMAIL FROM "+RetSqlname("SA3")+" B "                         + cEol
cSql += "WHERE B.D_E_L_E_T_ <> '*' "                                               + cEol
cSql += "AND B.A3_FILIAL = A3.A3_FILIAL "                                          + cEol
cSql += "AND B.A3_COD = A3.A3_GEREN "                                              + cEol
cSql += "AND B.A3_X_WORK = '1') AS MAILGER "                                       + cEol
cSql += "FROM "+RetSqlName("SA3")+" A3 "                                           + cEol
cSql += "WHERE A3.D_E_L_E_T_ <> '*' "                                              + cEol
cSql += "AND A3.A3_MSBLQL <> '1' AND A3.A3_EMAIL <> ' '  "                         + cEol
cSql += "AND A3.A3_X_WORK = '1' "                                                  + cEol
cSql += "ORDER BY A3.A3_COD "                                                      + cEol

TcQuery cSql NEW ALIAS "TMPA3"
DbSelectArea("TMPA3")            
TMPA3->(DbGotop())            

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Percorre toda a tabela de vendedores buscando pelos títulos em aberto pra cada um³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

While !TMPA3->(Eof())
	cVendI 	:= TMPA3->A3_COD
	cVendF	:= TMPA3->A3_COD
  
	Conout("VERIFICANDO PENDÊNCIAS DO VENDEDOR " + Trim(cVendI))
	
	If !Empty(TMPA3->MAILVEND) .OR. !EMPTY(TMPA3->MAILGER)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se o cadastro do vendedor estiver bloqueado, envia e-mail apenas para seu gerente.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If AllTrim(TMPA3->A3_MSBLQL) <> '1'
			If EMPTY(TMPA3->MAILVEND)
				Conout("NÃO EXISTE E-MAIL CADASTRADO PARA O VENDEDOR " + Trim(cVendI))
				cMail := AllTrim(TMPA3->MAILGER)
			Elseif Empty(TMPA3->MAILGER)
				Conout("NÃO EXISTE E-MAIL CADASTRADO PARA O GERENTE DO VENDEDOR " + Trim(cVendI))
				cMail := AllTrim(TMPA3->MAILVEND)
			Else                  
				cMail := AllTrim(TMPA3->MAILVEND)+";"+AllTrim(TMPA3->MAILGER)
			Endif 
			
		Else
			cMail := AllTrim(TMPA3->MAILGER)
		Endif 
		
		Conout("DESTINO DO WORKFLOW: " + AllTrim(cMail))
		
		lSched 	:= .T.
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Chamada thread que faz a busca e envio das informações para os representantes³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		StartJob("U_ARECVEND", GetEnvServer(), .F., cVendI,cVendF,cMail,lSched, aEmps)
		//U_ARecVend(cVendI,cVendF,cMail,lSched, aEmps)                              
		
		Sleep(10000)
		
	Endif
	
	TMPA3->(DbSkip())	
End

DbSelectArea("TMPA3")            
TMPA3->(DbCloseArea())

Conout("FIM DO PROCESSO DE ENVIO DE WORKFLOW DE COBRANÇA")

RpcClearEnv()

Return(.T.)