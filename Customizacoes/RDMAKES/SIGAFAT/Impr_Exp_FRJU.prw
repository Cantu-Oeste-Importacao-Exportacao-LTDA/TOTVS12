#include "rwmake.ch"
#include "topconn.ch" 
//TOMAR MUITO CUIDADO, quando for trocado o nome do servidor de aplicacao, deve
//ser trocado tbem aqui no codigo, nas linhas que se referenciam a ele
// ex.:    nCon1  := TCLink("DB2/TOPDB2","server_app")     
*------------------------ 
User Function IMPEXPPED()
*------------------------ 
Local   cPerg := PadR("RJUIEP", len(sx1->x1_grupo))
Local   cAmb  := ""
Private nCon1, nCon2  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
                                
cAmb := GetEnvServer()

If Alltrim(cAmb) <> "FRJU"
	MsgBox("Esta rotina deve ser executada no ambiente FRJU!")
	Return
Endif


ajustaSX1(cPerg)                           
Pergunte(cPerg,.f.)

    @ 150,01 TO 280,400 DIALOG oDlg TITLE "Importação/Exportação de Pedidos"
    @ 020,010 SAY "Programa responsável pela Importação/Exportação de Pedidos de Vendas."
    @ 040,040 BMPBUTTON TYPE 5 ACTION Pergunte(cPerg,.t.)
	@ 040,080 BMPBUTTON TYPE 1 ACTION Processa({||Importacao()})
	@ 040,120 BMPBUTTON TYPE 2 ACTION Close(oDlg)

	ACTIVATE DIALOG oDlg CENTERED

Return


*---------------------------
Static Function Importacao()                                
*---------------------------

    Local cQuery := " "

    nCon1 := ConLinux() // abrindo conexao com banco de dados com DB2
    If nCon1 < 0
       Return .t.
    EndIf            


    nCon2 := ConWindows() // abrindo conexao com banco de dados com MSSQL
    If nCon2 < 0
       Return .t.
    EndIf 
                                                          
    Processa({||ImpSC5()})

   TCUnLink(nCon1)                     
   TCUnLink(nCon2)                        
   Close(oDlg)

Return .t.


*-----------------------
Static Function ImpSC5()
*-----------------------
Local lFlag := .f.

	TCSETCONN(nCon1)    // Troca conexao para nova conexao
    BuscaSC5()         // busca lista de registro
    tcsetconn(nCon2)       // Volta conexao padrao

	// inicio da importacao para base atual    
    
    dbSelectArea("SC5")
    ProcRegua(SC5->(RecCount()))

    dbSelectArea("TMPSC5")
    dbGoTop()
    While !EOF()
    	  lFlag := .t.
          tcsetconn(nCon2)       // Volta conexao padrao

          IncProc("Importando Pedido  " + TMPSC5->C5_NUM)              
    
          dbSelectArea("TMPSC5")
          For i:= 1 to TMPSC5->(FCount())
              M->&(FieldName(i)) := TMPSC5->(FieldGet(i))
          Next i

          dbSelectArea("SC5")
          dbSetOrder(1)      
          dbGoTop()
          If dbSeek(xFilial("SC5") + TMPSC5->C5_NUM)
             RecLock("SC5",.f.)          
          Else               
             RecLock("SC5",.t.)
          Endif         
          // GRAVANDO DADOS
          For x:= 1 to SC5->(FCount())          
              SC5->(FieldPut(x,M->&(FieldName(x))))
          Next x                      
          SC5->(MsUnlock())

          // GRAVANDO do pedido em questao.
          TCSETCONN(nCon1)          
          
          BuscaSC6(TMPSC5->C5_NUM,TMPSC5->C5_FILIAL)	       // busca lista de registro 
          
          tcsetconn(nCon2)       // Volta conexao padrao

          dbSelectArea("TMPSC6")
          dbGotop()
          While !eof()                     
      
                dbSelectArea("TMPSC6")
                For i:= 1 to TMPSC6->(FCount())
                    M->&(FieldName(i)) := TMPSC6->(FieldGet(i))
                Next i

                dbSelectArea("SC6")
                dbSetOrder(1)                                                                    
                dbGoTop()
                If dbSeek(xFilial("SC6") + TMPSC6->C6_NUM + TMPSC6->C6_ITEM + TMPSC6->C6_PRODUTO)
                   RecLock("SC6",.f.)          
                Else               
                   RecLock("SC6",.t.)
                Endif         

                // GRAVANDO DADOS
                For x:= 1 to SC6->(FCount())
                    SC6->(FieldPut(x,M->&(FieldName(x))))
                Next x                      
                SC6->(MsUnlock())
          
                dbSelectArea("TMPSC6")    
                TMPSC6->(dbSkip())
          EndDo
          TMPSC6->(dbCloseArea())

          // GRAVANDO LIBERACOES DO PEDIDO
          TCSETCONN(nCon1)                   
          ApagaSC6(TMPSC5->C5_NUM,TMPSC5->C5_FILIAL)
          BuscaSC9(TMPSC5->C5_NUM,TMPSC5->C5_FILIAL)	       // busca lista de registro 

          tcsetconn(nCon2)       // Volta conexao padrao

          dbSelectArea("TMPSC9")
          dbGotop()
          While !eof()                     
     
                dbSelectArea("TMPSC9")
                For i:= 1 to TMPSC9->(FCount())
                    M->&(FieldName(i)) := TMPSC9->(FieldGet(i))
                Next i

                dbSelectArea("SC9")
                dbSetOrder(1)
                dbGoTop()
                If dbSeek(xFilial("SC9") + TMPSC9->C9_PEDIDO + TMPSC9->C9_ITEM + TMPSC9->C9_SEQUEN + TMPSC9->C9_PRODUTO)
                   RecLock("SC9",.f.)          
                Else               
                   RecLock("SC9",.t.)
                Endif         

                // GRAVANDO DADOS
                For x:= 1 to SC9->(FCount())
                    SC9->(FieldPut(x,M->&(FieldName(x))))
                Next x                      
                SC9->(MsUnlock())

                dbSelectArea("TMPSC9")    
                TMPSC9->(dbSkip())
          EndDo
          TMPSC9->(dbCloseArea())                       

          TCSETCONN(nCon1)                   
          ApagaSC9(TMPSC5->C5_NUM,TMPSC5->C5_FILIAL)                                                      
          tcsetconn(nCon2)       // Volta conexao padrao
          
          dbSelectArea("TMPSC5")    
          TMPSC5->(dbSkip())
    EndDo

// Final da importacao
// fecha as areas abertas na nova conexao.  
TMPSC5->(dbCloseArea())                     

If lFlag                           
	// deleta SC5 da conexao nCon1
	TCSETCONN(nCon1)    // Troca conexao para nova conexao
	ApagaSC5()         // busca lista de registro
	MsgBox("Importação Concluida!")
Endif

Return .t.


*-------------------------
Static Function BuscaSC5()
*-------------------------

Local cQuery := " "

	cQuery := "SELECT * FROM SC5" + cEmpAnt + "0 SC5"
	cQuery += " WHERE  SC5.C5_EMISSAO >= '" + DTOS(MV_PAR01) + "' "
	cQuery += " AND    SC5.C5_EMISSAO <= '" + DTOS(MV_PAR02) + "' "	
	cQuery += " AND    SC5.C5_TRANSP  >= '" + MV_PAR03       + "' "
	cQuery += " AND    SC5.C5_TRANSP  <= '" + MV_PAR04       + "' "	
	cQuery += " AND    SUBSTR(SC5.C5_MENNOTA,1,1) = '4' "
	cQuery += " AND    SC5.D_E_L_E_T_ <> '*'"
	TCQUERY cQuery NEW ALIAS "TMPSC5"
	MemoWrite("IMPEXPPED.TXT",cQuery)
	
	dbSelectArea("TMPSC5")
	If TMPSC5->(EOF())
		MsgBox("Não existem dados a serem importados!")
	     Return 
	Endif

Return .t.                          

*-------------------------
Static Function ApagaSC5()
*-------------------------

Local cQuery := " "

	cQuery := "UPDATE SC5" + cEmpAnt + "0 SET D_E_L_E_T_ = '*' " 	
	cQuery += " WHERE  C5_EMISSAO >= '" + DTOS(MV_PAR01) + "'  "
	cQuery += " AND    C5_EMISSAO <= '" + DTOS(MV_PAR02) + "'  "	
	cQuery += " AND    SUBSTR(C5_MENNOTA,1,1) = '4' "
	cQuery += " AND    C5_TRANSP  >= '" + MV_PAR03   + "' "
	cQuery += " AND    C5_TRANSP  <= '" + MV_PAR04   + "' "	
	cQuery += " AND    D_E_L_E_T_ <> '*'"          
	MemoWrite("DELEXPPED.TXT",cQuery)	
	TCSQLEXEC(cQuery)

Return .t.


*----------------------------------------
Static Function BuscaSC6(_Numero,_Filial)
*----------------------------------------

Local cQuery := " "

	cQuery := "SELECT * FROM SC6" + cEmpAnt + "0 SC6"
	cQuery += " WHERE  SC6.C6_NUM =   '" + _Numero + "' "		
	cQuery += " AND    SC6.C6_FILIAL= '" + _Filial + "' "			
	cQuery += " AND    SC6.D_E_L_E_T_ <> '*'"
	TCQUERY cQuery NEW ALIAS "TMPSC6"
	
	dbSelectArea("TMPSC6")

Return .t.             

*----------------------------------------
Static Function ApagaSC6(_Numero,_Filial)
*----------------------------------------

Local cQuery := " "

	cQuery := " UPDATE SC6" + cEmpAnt + "0 SET D_E_L_E_T_ = '*' WHERE       " 	
	cQuery += " C6_NUM = '" + _Numero + "' AND C6_FILIAL= '" + _Filial + "' "			
	TCSQLEXEC(cQuery)	

Return .t.             



*----------------------------------------
Static Function BuscaSC9(_Numero,_Filial)
*----------------------------------------

Local cQuery := " "

	cQuery := "SELECT * FROM SC9" + cEmpAnt + "0 SC9"
	cQuery += " WHERE  SC9.C9_PEDIDO = '" + _Numero + "' "		
	cQuery += " AND    SC9.C9_FILIAL= '"  + _Filial + "' "			
	cQuery += " AND    SC9.D_E_L_E_T_ <> '*'"
	TCQUERY cQuery NEW ALIAS "TMPSC9"
	
	dbSelectArea("TMPSC9")

Return .t.


*----------------------------------------
Static Function ApagaSC9(_Numero,_Filial)
*----------------------------------------

Local cQuery := " "

	cQuery := " UPDATE SC9" + cEmpAnt + "0 SET D_E_L_E_T_ = '*' WHERE  " 	
	cQuery += " C9_PEDIDO = '" + _Numero + "' AND C9_FILIAL= '"  + _Filial + "' "
	TCSQLEXEC(cQuery)	

Return .t.


*-------------------------
Static Function ConLinux()
*-------------------------

	TCConType("NPIPE")
//    nCon1  := TCLink("DB2/TOPDB2","server_slave")     
    nCon1  := TCLink("DB2/TOPDB2","192.168.0.2")     

	If nCon1 < 0
//		Alert("Falha na conexão TOPCONN (DB2/TOPDB2 / server_slave) - Erro: " + Alltrim(Str(nCon1)) +;
		Alert("Falha na conexão TOPCONN (DB2/TOPDB2 / 192.168.0.2) - Erro: " + Alltrim(Str(nCon1)) +;
			chr(13)+chr(10)+"Importação Cancelada")  
			
			
        MostraErro(nCon1)			
		TCUnLink(nCon1)
	Endif
	

Return(nCon1)


*---------------------------
Static Function ConWindows()
*---------------------------

	TCConType("NPIPE")
    nCon2  := TCLink("MSSQL/DADOSMP8","192.168.0.50")     
	If nCon2 < 0
		Alert("Falha na conexão TOPCONN (MSSQL/DADOSMP8 / 192.168.0.50) - Erro: " + Alltrim(Str(nCon2)) +;
			chr(13)+chr(10)+"Importação Cancelada")  
			
			
        MostraErro(nCon2)			
		TCUnLink(nCon2)
	Endif
	
	
Return(nCon2)



*-------------------------------
Static Function MostraErro(nConX)
*-------------------------------
Local _Erro := " "
Local _Correcao := " "

If nConX == -1
   _Erro     := "Voce esta tentando executar a funcao TC_Connect sem ter uma camada de comunicacao"
   _Correcao := "Voce necessita de um APPC ou TCPIP router disponivel"
Endif
If nConX == -2
   _Erro     := "Voce esta tentando executar a funcao sem estabelecer conexao previa"
   _Correcao := "Execute a funcao TC_Connect"
Endif
If nConX == -6
   _Erro     := "Nao a mais conexoes disponiveis"
   _Correcao := "Feche a conexao e tente novamente"
Endif
If nConX == -34
   _Erro     := "O numero maximo de usuarios ja foi alcancado"
   _Correcao := "Desconecte alguns usuarios ou atualize o numero de licensas"
Endif
If nConX == -35
   _Erro     := "DataBase nao pode ser acessado"
   _Correcao := "verifique rede"
Endif

Alert("Erro :" + _Erro + chr(13)+chr(10) + "Acao :" + _Correcao)

Return .t.


*-------------------------------
Static Function ajustaSX1(cPerg)
*-------------------------------

_sAlias := Alias()
aRegs  := {}

dbSelectArea("SX1")
dbSetOrder(1)

aAdd(aRegs,{cPerg,"01","Emis.Inicial Pedido?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Emis.Final   Pedido?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Da Transportadora  ?","","","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA3","",""})
aAdd(aRegs,{cPerg,"04","Ate Transportadora ?","","","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SA3","",""})

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
