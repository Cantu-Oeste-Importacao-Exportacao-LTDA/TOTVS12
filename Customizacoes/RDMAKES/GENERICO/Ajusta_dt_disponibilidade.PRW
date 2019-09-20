#INCLUDE "rwmake.ch"                     
#INCLUDE "TopConn.ch" 
#include "PROTHEUS.CH"

/********************************************
*Autor : Guilherme poyer - 06/01/2014       |
*Função: Alterar a data de disponibilidada  |
* dos títulos que são reconciliados e que   |
* possuem juros ou descontos e esses titulos|
* não são atualizados                       |
********************************************/

User Function AtuReconc() //A
Private cPerg     := 'ATURECO  '
Private oAtualiza	
ValidPerg()
Pergunte(cPerg,.F.)                                               

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

@ 200,001 TO 380,380 DIALOG oAtualiza TITLE OemToAnsi("Atualizacao Titulos!")
@ 002,002 Say " Este programa irá atualizar o capo E5_DTDISPO dos titulos. "
@ 60,070 BMPBUTTON TYPE 01 ACTION OkAtualiza()
@ 60,100 BMPBUTTON TYPE 02 ACTION Close(oAtualiza)    
@ 60,130 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oAtualiza Centered

Return   //A
  
//Atualização dos registros
Static Function OkAtualiza() //B

//Inicia a atulizalção  
Processa({|| RunCont() },"Processando...")

Return //B

Static Function RunCont() //C
cCampo  := "SE5->E5_DTDISPO"

//Seleciona titulos	
cSql := "SELECT E5.E5_FILIAL,E5.E5_DATA,E5.E5_TIPO,E5.E5_VALOR,E5.E5_NUMERO,E5.E5_BANCO,E5.E5_AGENCIA,E5.E5_CONTA,E5.E5_TIPODOC,E5.E5_PREFIXO, "
cSql += " E5.E5_PARCELA, E5.E5_CLIFOR, E5.E5_LOJA,E5.E5_RECONC,E5.E5_DTDISPO,E5.E5_ARQCNAB FROM "+RetSqlName("SE5")+" E5 "
cSql += "WHERE E5.D_E_L_E_T_ <> '*' "                   
cSql += "  AND E5.E5_FILIAL = '"+xFilial("SE5")+"' "
cSql += "  AND E5.E5_DATA BETWEEN '"+DtoS(mv_par01)+"' AND '"+DtoS(mv_par02)+"' "
cSql += "  AND E5.E5_TIPO = 'NF' "          
cSql += "  AND E5.E5_ARQCNAB <> ' ' "
cSql += "  AND E5.E5_TIPODOC <> 'VL' "
cSql += "ORDER BY E5.E5_FILIAL,E5.E5_NUMERO,E5.E5_PREFIXO "
TcQuery cSql NEW ALIAS "TMPE5"
TMPE5->(dbSelectArea("TMPE5"))
TMPE5->(dbGoTop())

ProcRegua(RecCount()) 

// verifica os titulos originais (E5_TIPODOC = VL) dos registros referentes a Juros, taxas, descontos.
While !TMPE5->(EOF())		
	IncProc()
		
	cFil	 := TMPE5->E5_FILIAL
	cNum	 := TMPE5->E5_NUMERO
	cPrf 	 := TMPE5->E5_PREFIXO
	cCli	 := TMPE5->E5_CLIFOR
	cLja	 := TMPE5->E5_LOJA
	
   	cSql := "SELECT B.E5_FILIAL,B.E5_DATA,B.E5_TIPO,B.E5_VALOR,B.E5_NUMERO,B.E5_BANCO,B.E5_AGENCIA,B.E5_CONTA,B.E5_TIPODOC,B.E5_PREFIXO, "
    cSql += "B.E5_PARCELA, B.E5_CLIFOR, B.E5_LOJA,B.E5_RECONC,B.E5_DTDISPO,B.E5_ARQCNAB FROM "+RetSqlName("SE5")+" B "
    cSql += "WHERE B.D_E_L_E_T_ <> '*' "
    cSql += "  AND B.E5_FILIAL = '"+cFil+"' "
    cSql += "  AND B.E5_NUMERO = '"+cNum+"' "                
    cSql += "  AND B.E5_PREFIXO = '"+cPrf+"' "
    cSql += "  AND B.E5_CLIENTE = '"+cCli+"' "
    cSql += "  AND B.E5_LOJA = '"+cLja+"' "
    cSql += "  AND B.E5_ARQCNAB  <> ' ' "
    cSql += "  AND B.E5_TIPODOC  = 'VL' "
    cSql += "  AND B.E5_RECONC <> ' '  " 
    cSql += "  AND B.E5_DATA = '"+TMPE5->E5_DATA+"' "                 
    cSql += "  AND B.E5_DTDISPO <> '"+TMPE5->E5_DTDISPO+"' "
    TcQuery cSql NEW ALIAS "TMPB"
	TMPB->(dbSelectArea("TMPB"))
	TMPB->(dbGoTop())    
    
    If !TMPB->(Eof())	 	 	
	 	dDtDispo := TMPB->E5_DTDISPO
    	TMPB->(DbCloseArea())			
    	//TMPE5->(DbSelectArea("TMPE5"))
		DbSelectArea("SE5")
    	SE5->(DbSetOrder(2))
    	SE5->(DbGotop())
    	If DbSeek(TMPE5->E5_FILIAL+TMPE5->E5_TIPODOC+TMPE5->E5_PREFIXO+TMPE5->E5_NUMERO+TMPE5->E5_PARCELA+TMPE5->E5_TIPO+TMPE5->E5_DATA+TMPE5->E5_CLIFOR+TMPE5->E5_LOJA)
    		recLock("SE5",.F.)
	 			&cCampo := StoD(dDtDispo)
			MsUnlock("SE5")               		
    	EndIf 	
    Else
    	TMPB->(DbCloseArea())	
		TMPE5->(DbSelectArea("TMPE5"))
    EndIf                               
    
    TMPE5->(dbSkip())
EndDo
TMPE5->(DbSelectArea("TMPE5"))
TMPE5->(DbCloseArea())


MsgBox("Processo Finalizado com sucesso!")
	
Return //C

Static Function ValidPerg() //D
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aRegs:={}

//Grupo/Ordem/Pergunta/PerSPA/PerENG/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefSPA1/DefENG1/Cnt01/Var02/Def02/DefSPA2/DefENG2/Cnt02/Var03/Def03/DefSPA3/DefENG3/Cnt03/Var04/Def04/DefSPA4/DefENG4/Cnt04/Var05/Def05/DefSPA5/DefENG5/Cnt05/F3/GRPSXG
aAdd(aRegs,{cPerg,"01","Emissao inicial     ","","","mv_ch1","D",08,0,0,"G","        ","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
aAdd(aRegs,{cPerg,"02","Emissao final       ","","","mv_ch2","D",08,0,0,"G","NaoVazio","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
Return    //D
