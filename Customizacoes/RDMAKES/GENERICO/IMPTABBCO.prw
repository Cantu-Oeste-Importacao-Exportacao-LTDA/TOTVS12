#include "rwmake.ch"
#include "topconn.ch"
// Funçao para fazer a importação de uma base em um local para outra base em outro lugar,
// de uma tabela a ser selecionada
// ser trocado tbem aqui no codigo, nas linhas que se referenciam a ele
// ex.:    nCon1  := TCLink("DB2/TOPDB2","server_app")
*------------------------ 
User Function IMPTABBCO()
*------------------------ 
Local   cAmb  := ""
Private nCon1, nCon2
Private cTabela := Space(15)
Private cConSrv := Space(15)
Private cConBco := Space(20)      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

cAmb := GetEnvServer()

@ 150,01 TO 380,400 DIALOG oDlg TITLE "Importação de tabelas para o banco atual"
@ 020,010 SAY "Importação de tabelas de um banco para o banco de dados atual."
@ 030,010 SAY "Conexao"
@ 030,060 GET cConSrv Size 30, 100
@ 030,120 GET cConBco Size 30, 100
@ 030,010 SAY "Tabela"
@ 030,100 GET cTabela Size 30, 100
@ 040,060 BMPBUTTON TYPE 1 ACTION Processa({||Importacao()})
@ 040,100 BMPBUTTON TYPE 2 ACTION Close(oDlg)

ACTIVATE DIALOG oDlg CENTERED

Return


*---------------------------
Static Function Importacao()                                
*---------------------------

    Local cQuery := " "

    nCon1 := ConOrigem() // abrindo conexao com banco de dados com DB2
    If nCon1 < 0
       Return .t.
    EndIf            


    nCon2 := ConOracle() // abrindo conexao com banco de dados com ORACLE
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
	BuscaTab()         // busca lista de registro
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


Static Function BuscaTab()
Local cQuery := " "

cQuery := "SELECT * FROM " + cTabela
cQuery += " WHERE  D_E_L_E_T_ <> '*'"
TCQUERY cQuery NEW ALIAS "TMPTAB"
dbSelectArea("TMPTAB")

Return .T.

*-------------------------
Static Function ConOrigem()
*-------------------------

	TCConType("NPIPE")
	nCon1  := TCLink("DB2/ADVMIGRA","192.168.210.5")     

	If nCon1 < 0
		Alert("Falha na conexão TOPCONN (DB2/ADVMIGRA / 192.168.210.5) - Erro: " + Alltrim(Str(nCon1)) +;
			chr(13)+chr(10)+"Importação Cancelada")  
			
			
        MostraErro(nCon1)			
		TCUnLink(nCon1)
	Endif
	

Return(nCon1)


*---------------------------
Static Function ConOracle()
*---------------------------

	TCConType("NPIPE")
    nCon2  := TCLink("ORACLE/TOTOVS","192.168.0.8")     
	If nCon2 < 0
		Alert("Falha na conexão TOPCONN (ORACLE/TOTOVS / 192.168.0.8) - Erro: " + Alltrim(Str(nCon2)) +;
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