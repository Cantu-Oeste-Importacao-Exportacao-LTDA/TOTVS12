#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRVendcli  บ Autor ณ AP6 IDE            บ Data ณ  10/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ Vendedores X Cliente                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Cantu                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RVendcli()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         	:= "Relatorio de Vendedores X Clientes."
Local cDesc2         	:= ""
Local cDesc3         	:= ""
Local cPict           := ""
Local titulo       		:= "Vendedores X Clientes"
Local nLin        		:= 80

Local Cabec1       		:= "Vend   Nome                       Segmento                                     "                          
Local Cabec2       		:= "    Cod/ Loja       Nome                                       Tabela Lim. Cred"
//    						"0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789"
                          //           1         2         3         4         5         6         7         8         9        10        11        12       14
Local imprime      		:= .T.
Local aOrd 				:= {}
Private lEnd         	:= .F.
Private lAbortPrint  	:= .F.
Private CbTxt        	:= ""
Private limite        := 80
Private tamanho       := "P"
Private nomeprog      := "RVENDCLI" 
Private nTipo         := 18
Private aReturn       := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey      := 0
Private cbtxt      		:= Space(10)    
Private cbcont     		:= 00
Private CONTFL     		:= 01
Private m_pag      		:= 01
Private wnrel      		:= "RELCAN"
Private cPerg			    := "RVENDCLI00"
Private cString			  := " "    

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

AjustaSX1() 
Pergunte(cPerg,.T.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return


Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local cVendSeg := ""

//Cabec1	:= "DATA INICIAL: "+DtoC(mv_par01)+" DATA FINAL: "+DtoC(mv_par02)

cSql := "SELECT ZZ5.* "
cSql += "FROM "+RetSqlName("ZZ5")+" ZZ5 "
cSql += "WHERE ZZ5.D_E_L_E_T_ <> '*' "
cSql += "AND ZZ5_FILIAL = '"+xFilial("ZZ5")+"' "
cSql += "AND ZZ5.ZZ5_VEND BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
cSql += "AND ZZ5.ZZ5_FILIAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cSql += "ORDER BY ZZ5.ZZ5_VEND, ZZ5.ZZ5_SEGMEN, ZZ5.ZZ5_CLIENT "
TCQUERY cSql NEW ALIAS "TMPZZ5"

DbSelectArea("TMPZZ5")
SetRegua(RecCount())


TMPZZ5->(DbGoTop())

cVendSeg := ""
// TMPZZ5->ZZ5_VEND + TMPZZ5->ZZ5_SEGMEN

While !TMPZZ5->(EOF())
	Incproc()
  If lAbortPrint
  	@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
  	Exit
  Endif

	If nLin > 60
    Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)    
    @008, 000 PSay "" // para marcar o inicio da impressใo
    nLin := 9
  Endif
  
  if cVendSeg != TMPZZ5->ZZ5_VEND + TMPZZ5->ZZ5_SEGMEN
  	if (nLin > 9)
  		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)    
    	@008, 000 PSay "" // para marcar o inicio da impressใo
    	nLin := 9
    EndIf
  	//@nLin, 000 PSay Replicate("-", 80)
  	//nLin += 1
  	SA3->(dbSetOrder(01))
  	SA3->(dbSeek(xFilial("SA3") + TMPZZ5->ZZ5_VEND))
  	@nLin, 000 PSay TMPZZ5->ZZ5_VEND
  	@nLin, 008 PSay SA3->A3_NREDUZ
  	
  	CTH->(dbSetOrder(01))
  	CTH->(dbSeek(xFilial("CTH") + TMPZZ5->ZZ5_SEGMEN))
  	
  	@nLin, 035 PSay SubStr(TMPZZ5->ZZ5_SEGMEN + " - " + CTH->CTH_DESC01, 1, 45)
  	nLin += 1
  	@nLin, 000 PSay Replicate("-", 80)
  	nLin += 1
	EndIf
  
  cVendSeg := TMPZZ5->ZZ5_VEND + TMPZZ5->ZZ5_SEGMEN

	@nLin, 005 Psay TMPZZ5->ZZ5_CLIENT + "/" + TMPZZ5->ZZ5_LOJA
  SA1->(dbSetOrder(01))
  SA1->(dbSeek(xFilial("SA1") + TMPZZ5->ZZ5_CLIENT))
  
	@nLin, 020 Psay SubStr(SA1->A1_NOME, 1, 42)
	@nLin, 064 Psay TMPZZ5->ZZ5_TABELA	
	@nLin, 071 Psay SA1->A1_LC PICTURE "@E 9,999,999"
  nLin += 1

	TMPZZ5->(dbSkip())
EndDo
TMPZZ5->(DbSelectArea("TMPZZ5"))
TMPZZ5->(DbCloseArea())

SET DEVICE TO SCREEN

If aReturn[5]==1
  dbCommitAll()
  SET PRINTER TO
  OurSpool(wnrel)
Endif

MS_FLUSH()

Return

Static Function AjustaSX1()
cPerg := PADR(cPerg,Len(SX1->X1_GRUPO))
PutSx1(cPerg,"01","Vendedor Inicial ?","Vendedor Inicial ?","Vendedor Inicial ?", "mv_vin", "C", 6, 0, ,"G", "", "SA3", "", "","MV_PAR01")
PutSx1(cPerg,"02","Vendedor Final ?","Vendedor Final ?","Vendedor Final ?", "mv_vfi", "C", 6, 0, ,"G", "", "SA3", "", "","MV_PAR02")
PutSx1(cPerg,"03","Filial de ?","Filial de ?","Filial de ?", "mv_fin", "C", 2, 0, ,"G", "", "", "", "","MV_PAR03")
PutSx1(cPerg,"04","Filial ate ?","Filial ate ?","Filial ate ?", "mv_ffi", "C", 2, 0, ,"G", "", "", "", "","MV_PAR04")
Return