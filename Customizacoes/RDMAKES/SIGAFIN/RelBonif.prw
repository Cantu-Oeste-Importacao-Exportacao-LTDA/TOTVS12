#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RelBonif   º Autor ³Adriano Novachaelleyº Data ³  07/07/11  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Controle de % de bonificações a clientes.                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especipecifico Cantu                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RelBonif()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2        := "de acordo com os parametros informados pelo usuario."
Private cDesc3        := "Controle e Bonificações"
Private cPict         := ""
Private titulo       	:= "Controle e Bonificações"
Private nLin         	:= 80
// Regua 			                      1         2         3         4         5         6         7         8         9        10        11        12        13
//		            	     0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
Private Cabec1      	:= "Codigo          Codigo           Nome                          Grupo                           Bonificação"
Private Cabec2       	:= "Bonific.        Cliente   Loja   Cliente                       Produto                                   %"
Private imprime      	:= .T.
Private aOrd 					:= { "Cliente","Grupo de produto/Segmento"}
Private lEnd         	:= .F.
Private lAbortPrint  	:= .F.
Private CbTxt        	:= ""
Private limite        := 132
Private tamanho       := "G"
Private nomeprog      := "RELBON" 
Private nTipo         := 18
Private aReturn       := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1} 
Private nLastKey      := 0
Private cbtxt      		:= Space(10)
Private cbcont     		:= 00
Private CONTFL     		:= 01
Private m_pag      		:= 01
Private wnrel      		:= "RELBON"
Private cPerg				 	:= "RELBON"
Private cString 			:= "SA1"     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())


ValidPerg()
Pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)
nOrdem := aReturn[8]

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

_cDtIni		:= DtoS(mv_par01) // Data inicial
_cDtFin		:= DtoS(mv_par02) // Data final
_cCliIn		:= mv_par03		  // Cliente inicial
_cCliFi		:= mv_par04       // Cliente final
_cGrpIn		:= mv_par05		  // Grupo inicial
_cGrpFi		:= mv_par06		  // Grupo final
_cLVLIn		:= mv_par07		  // Segmento inicial
_cLVLFi		:= mv_par08		  // Segmento final
_cTipIm		:= mv_par09			// Imprime dados

If _cTipIm != 2

	Do Case
		Case nOrdem = 1 // Cliente
			_cOrder := "ORDER BY Z16.Z16_CODCLI,Z16.Z16_LOJCLI,Z16.Z16_CODIGO"
			_cChave	:= "TMPZ16->Z16_CODCLI"
		Case nOrdem = 2 // Grupo
			_cOrder := 	"ORDER BY Z17.Z17_CODGRP,Z16.Z16_CODCLI,Z16.Z16_LOJCLI "
			_cChave	:= "TMPZ16->Z17_CODGRP"
	End Case
	
	cSql := "SELECT Z16.Z16_FILIAL,Z16.Z16_CODIGO,Z16.Z16_CODCLI,Z17.Z17_DESGRP, "
	cSql += " Z16_LOJCLI, "
	cSql += "Z16.Z16_DATINI,Z16.Z16_DATFIN,Z17.Z17_ITEM, "
	cSql += "Z17.Z17_CODGRP,Z17.Z17_DESGRP,Z17.Z17_PRCBON "
	cSql += "FROM "+RetSqlName("Z16")+" Z16, "+RetSqlName("Z17")+" Z17 "
	cSql += "WHERE Z16.D_E_L_E_T_ <> '*' AND Z17.D_E_L_E_T_ <> '*' AND "
	cSql += "Z16.Z16_FILIAL = '"+xFilial("Z16")+"' AND Z17.Z17_FILIAL = '"+xFilial("Z17")+"' AND "
	cSql += "Z16.Z16_FILIAL = Z17.Z17_FILIAL AND Z16.Z16_CODIGO = Z17.Z17_CODIGO AND "
	cSql += "Z16.Z16_DATINI >= '"+_cDtIni+"' AND "
	cSql += "Z16.Z16_DATFIN <= '"+_cDtFin+"' AND "
	cSql += "Z16.Z16_CODCLI BETWEEN '"+_cCliIn+"' AND '"+_cCliFi+"' AND "
	cSql += "Z17.Z17_CODGRP BETWEEN '"+_cGrpIn+"' AND '"+_cGrpFi+"' "
	cSql += _cOrder
	cSql := ChangeQuery(cSql)
	
	
	TCQUERY cSql NEW ALIAS "TMPZ16"
	TMPZ16->(DbSelectArea("TMPZ16"))
	TMPZ16->(DbGoTop()) 
	
	_cVer	:= &_cChave
	While !TMPZ16->(EOF())
	
	
		If _cVer <> &_cChave
			nLin += 1
		Endif
		If lAbortPrint
		   @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		   Exit
		Endif
		
	
		If nLin > 60
		   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		   nLin := 9
		Endif
	  
		@nLin, 000 Psay TMPZ16->Z16_CODIGO 
		@nLin, 016 Psay TMPZ16->Z16_CODCLI
		If Empty(TMPZ16->Z16_LOJCLI)
			cLoja := GetLoja(TMPZ16->Z16_CODCLI)
			@nLin, 026 Psay '    '
			SA1->(DbSelectArea("SA1"))
			SA1->(DbSetOrder(1))                                       
			SA1->(DbSeek(xFilial("SA1")+TMPZ16->Z16_CODCLI + cLoja))
			@nLin, 031 Psay SubStr(SA1->A1_NOME,1,30)
		Else
			@nLin, 026 Psay TMPZ16->Z16_LOJCLI
			SA1->(DbSelectArea("SA1"))
			SA1->(DbSetOrder(1))
			SA1->(DbSeek(xFilial("SA1")+TMPZ16->Z16_CODCLI+TMPZ16->Z16_LOJCLI))                
			
			@nLin, 031 Psay SubStr(SA1->A1_NOME,1,30)
		Endif               
		
		@nLin, 063 Psay TMPZ16->Z17_CODGRP 
		@nLin, 068 Psay TMPZ16->Z17_DESGRP
		@nLin, 100 Psay TMPZ16->Z17_PRCBON Picture "@E 999.99"
		
		_cVer	:= &_cChave
		nLin += 1
		TMPZ16->(dbSkip())
	EndDo
	
	
	TMPZ16->(DbSelectArea("TMPZ16"))
	TMPZ16->(DbCloseArea())

EndIf

If _cTipIm != 1

	// Regua 	           1         2         3         4         5         6         7         8         9        10        11        12        13
	//		     0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
	
	titulo := "Contratos de Redes"
	Cabec1 := "Número    Seq.  Tipo Codigo           Nome                          Segmento            Verba               Valor         Percentual"
	Cabec2 := "Contrato             Cliente   Loja   Cliente                                                               Desconto      Desconto  "
	nLin := 60

	Do Case
		Case nOrdem = 1 // Cliente
			_cOrder := "ORDER BY Z54.Z54_CLIENT,Z54.Z54_LOJACL,Z54.Z54_NUMERO,Z54.Z54_SEQUEN "
			_cChave	:= "TMPZ54->(Z54_CLIENT+Z54_LOJACL+Z54_NUMERO+Z54_SEQUEN)"
		Case nOrdem = 2 // Grupo
			_cOrder := 	"ORDER BY Z55_CCLVL,Z54.Z54_CLIENT,Z54.Z54_LOJACL,Z54.Z54_NUMERO,Z54.Z54_SEQUEN"
			_cChave	:= "TMPZ54->(Z55_CCLVL+Z54_CLIENT+Z54_LOJACL+Z54_NUMERO+Z54_SEQUEN)"
	End Case
	
	cSql := "SELECT Z54.Z54_FILIAL,Z54.Z54_CLIENT,Z54.Z54_LOJACL,Z54.Z54_NUMERO,Z54.Z54_SEQUEN,Z54.Z54_NOMECL, "
	cSql += "Z55.Z55_CCLVL,Z55.Z55_DCLVL,Z55.Z55_CVERBA,Z55.Z55_DVERBA,Z55.Z55_PRCDES,Z55.Z55_VLRDES, "
	cSql += "Z54.Z54_DATADE,Z54.Z54_DATATE,Z54.Z54_ATIVO,Z54.Z54_VALOR,Z55.Z55_TIPOCT "
	cSql += "FROM "+RetSqlName("Z55")+" Z55, "+RetSqlName("Z54")+" Z54 "
	cSql += "WHERE Z55.D_E_L_E_T_ <> '*' AND Z54.D_E_L_E_T_ <> '*' AND "
	cSql += "Z55.Z55_FILIAL = Z54.Z54_FILIAL AND Z55.Z55_NUMERO = Z54.Z54_NUMERO AND "
	cSql += "Z55.Z55_SEQUEN = Z54.Z54_SEQUEN AND Z55.Z55_CLIENT = Z54.Z54_CLIENT AND "
	cSql += "Z55.Z55_LOJACL = Z54.Z54_LOJACL AND Z54.Z54_ATIVO  = 'S' AND "	
	cSql += "Z54.Z54_CLIENT BETWEEN '"+_cCliIn+"' AND '"+_cCliFi+"' AND "
	cSql += "( ( Z55.Z55_TIPOCT = 'C' AND Z55.Z55_CCLVL BETWEEN '"+_cLVLIn+"' AND '"+_cLVLFi+"' AND "
	cSql += "Z54.Z54_DATADE >= '"+_cDtIni+"' AND Z54.Z54_DATATE <= '"+_cDtFin+"' ) OR "
	cSql += "( Z55.Z55_TIPOCT != 'C' AND Z54.Z54_DATATE <= '"+_cDtFin+"' ) ) "
	cSql += _cOrder
	cSql := ChangeQuery(cSql)
	
	
	TCQUERY cSql NEW ALIAS "TMPZ54"
	TMPZ54->(DbSelectArea("TMPZ54"))
	TMPZ54->(DbGoTop()) 
	
	_cVer	:= &_cChave
	While !TMPZ54->(EOF())
	
	
		If _cVer <> &_cChave
			nLin += 1
		Endif
		If lAbortPrint
		   @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		   Exit
		Endif
		
		If nLin > 60
		   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		   nLin := 9
		Endif

	// Regua 	           1         2         3         4         5         6         7         8         9        10        11        12        13
	//		     0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
	/*	
	Cabec1 := "Número    Seq.  Tipo Codigo           Nome                          Segmento            Verba               Valor         Percentual"
	Cabec2 := "Contrato             Cliente   Loja   Cliente                                                               Desconto      Desconto  "
	*/

	  
		@nLin, 000 Psay TMPZ54->Z54_NUMERO 
		@nLin, 010 Psay TMPZ54->Z54_SEQUEN
		@nLin, 016 Psay TMPZ54->Z55_TIPOCT
		@nLin, 021 Psay TMPZ54->Z54_CLIENT
		If Empty(TMPZ54->Z54_LOJACL)
			cLoja := GetLoja(TMPZ54->Z54_CLIENT)
			@nLin, 031 Psay '    '
			SA1->(DbSelectArea("SA1"))
			SA1->(DbSetOrder(1))                                       
			SA1->(DbSeek(xFilial("SA1")+TMPZ54->Z54_CLIENT + cLoja))
			@nLin, 038 Psay SubStr(SA1->A1_NOME,1,28)
		Else
			@nLin, 031 Psay TMPZ54->Z54_LOJACL
			SA1->(DbSelectArea("SA1"))
			SA1->(DbSetOrder(1))
			SA1->(DbSeek(xFilial("SA1")+TMPZ54->Z54_CLIENT+TMPZ54->Z54_LOJACL))                			
			@nLin, 038 Psay SubStr(SA1->A1_NOME,1,28)
		Endif               
		
		
		@nLin, 068 Psay SubStr(TMPZ54->Z55_DCLVL,1,18)
		@nLin, 088 Psay SubStr(TMPZ54->Z55_DVERBA,1,18)
		If TMPZ54->Z55_TIPOCT == "C"
			@nLin, 108 Psay TMPZ54->Z55_VLRDES Picture "@E 999,999.99"
			@nLin, 125 Psay TMPZ54->Z55_PRCDES Picture "@E 999.99"
		Else
			@nLin, 108 Psay TMPZ54->Z54_VALOR Picture "@E 999,999.99"
			@nLin, 125 Psay 0 Picture "@E 999.99"
		EndIf
			
		_cVer	:= &_cChave
		nLin += 1
		TMPZ54->(dbSkip())
	EndDo
	
	
	TMPZ54->(DbSelectArea("TMPZ54"))
	TMPZ54->(DbCloseArea())
	

EndIf
	
SET DEVICE TO SCREEN

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

Static Function ValidPerg
Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)

cPerg := PADR(cPerg,10)
// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DEFSP1/DFENG1/Cnt01/Var02/Def02/DEFSP1/DFENG1/Cnt02/Var03/Def03/DEFSP1/DFENG1/Cnt03/Var04/Def04/DEFSP1/DFENG1/Cnt04/Var05/Def05/DEFSP1/DFENG1/Cnt05
aAdd(aRegs,{cPerg,"01","Data inicial     ","","","mv_ch1","D",08,0,0,"G","        ","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
aAdd(aRegs,{cPerg,"02","Data final       ","","","mv_ch2","D",08,0,0,"G","NaoVazio","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Cliente inicial  ","","","mv_ch3","C",09,0,0,"G","        ","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA1",""})
aAdd(aRegs,{cPerg,"04","Cliente final    ","","","mv_ch4","C",09,0,0,"G","NaoVazio","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SA1",""})
aAdd(aRegs,{cPerg,"05","Grupo inicial    ","","","mv_ch5","C",04,0,0,"G","        ","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SBM",""})
aAdd(aRegs,{cPerg,"06","Grupo Final      ","","","mv_ch6","C",04,0,0,"G","NaoVazio","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SBM",""})
aAdd(aRegs,{cPerg,"07","Segmento inicial ","","","mv_ch7","C",09,0,0,"G","        ","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
aAdd(aRegs,{cPerg,"08","Segmento Final   ","","","mv_ch8","C",09,0,0,"G","NaoVazio","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
aAdd(aRegs,{cPerg,"09","Imprimir Dados   ","","","mv_ch9","N",01,0,1,"C","        ","mv_par09","R. Bonificação","R. Bonificação","R. Bonificação","","","Contrato Redes","Contrato Redes","Contrato Redes","","","Ambos","Ambos","Ambos","","","","","","","","","","","", "","","",""})

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
dbSelectArea(_sAlias)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Comando executado para buscar a primeira loja do cliente.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function GetLoja(cCodigo)
Local cLoja := "" 
Local cSql  := ""

cSql := "SELECT MIN(A1.A1_LOJA) AS LOJA FROM "+ RetSqlName("SA1") +" A1 "
cSql += "WHERE A1.D_E_L_E_T_ <> '*' "
cSql += "  AND A1.A1_COD = '"+ cCodigo +"' "

TCQUERY cSql NEW ALIAS "SA1LOJA"

DbSelectArea("SA1LOJA")
SA1LOJA->(DbGoTop())

if !SA1LOJA->(EOF())
	cLoja := SA1LOJA->LOJA
EndIf

SA1LOJA->(DbCloseArea())

Return cLoja