#include "rwmake.ch"
#include "tbiconn.ch"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TOPCONN.CH" 
#include "colors.ch"
             

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPTICKT  ºAutor  ³Ricardo Catelli Filho Data ³  20/10/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Importaçao de abastecimento                                º±±
±±º          ³ Ticket Car										          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                


User Function DIRIMPTK()

Local oDlg1 
local cRet
Private cArqOri := Space(60)             

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para buscar o arquivo de importação³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

@ 140,100 TO 300,430 DIALOG oDlg1 TITLE "Selecionar arquivo TXT TICKET"                        	
@ 005,005 TO 060,160
@ 010,010 Say "Arquivo:"
@ 010,050 Get cArqOri Size 92, 30
@ 010,140 BUTTON "..." SIZE 10, 10 ACTION (cArqOri := cGetFile( "* | *.*" , "Selecione o Arquivo", 0,"",.T.))
@ 055,100 BMPBUTTON TYPE 1 ACTION Processa( {|| U_IMPTICKT() } )
@ 055,130 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 CENTER
Return()

USER FUNCTION IMPTICKT()       


	Local aCabec  	:= {}  
	Local aItens  	:= {}
	Local aCliente	:= {}
	Local aFornece	:= {}
	Local nCont   	:= 0	
	LOCAL nHdl		:= 0
	Local nX 		:= 0
	Local cNome 	:= "ticketcar.txt"  
	Local cDirCopy 	:= "\ticket\"  
	Local cBuffer	:= SPACE(10)    
	Local nTamFile, nTamLin, nBtLidos
	Local lExiste 	:= .T.
	Local lHabil  	:= .F.
	Private nHdl  	:= 0
	Private cEOL  	:= "CHR(8)"
	Private nImp  	:= 0
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
	
	/*
	If Empty(cEOL)
		cEOL := CHR(8)
	Else
		cEOL := Trim(cEOL)
		cEOL := &cEOL
	Endif
	*/	                      
	      
	if !ExistDir(cDirCopy)
		MakeDir(cDirCopy)
	EndIf
    
    if CPYT2S(cArqOri, cDirCopy, .F.)
		conout("Arquivo Copiado")
	else
		conout("Erro ao copiar o arquivo")
	EndIf
	                             
	
	//+---------------------------------------------------------------------+
	//| Abertura do arquivo texto                                           |
	//+---------------------------------------------------------------------+
	
	cArqTxt := 	cDirCopy+cNome

	nHdl := fOpen(cArqTxt)
		IF nHdl == -1
		IF FERROR()== 161
			ALERT("Arquivo não foi encontrado. Contate o departamento de T.I.")
		EndIF
	EndIf
	

	FSEEK(nHdl,0,0 )
	nTamArq:=FSEEK(nHdl,0,2 )
	FSEEK(nHdl,0,0 )
	fClose(nHdl)

	FT_FUse(cArqTxt )  //abre o arquivo
	FT_FGoTop()         //posiciona na primeira linha do arquivo
	
	//nTamLinha := AT(cEOL,cBuffer )
   	nTamLinha := Len(FT_FREADLN() ) //Ve o tamanho da linha   	
   	
   	
	FT_FGOTOP()
    
   	fOpen (cArqTxt)
	While !FT_FEOF()=.T.	

		DbSelectArea("TR6")
   			TR6->(DbSetOrder(1))
   	 		RecLock("TR6", .T.)
	 
		TR6->TR6_FILIAL := xFilial("TR6")
		TR6->TR6_NUMABA := GETSXeNUM("TR6","TR6_NUMABA")   
		
		cBuffer  := FT_FReadLn()
		        
		TR6->TR6_PLACA 		:= 		Substr(cBuffer,16,8)  
		TR6->TR6_CNPJ	  	:= 		Substr(cBuffer,24,14)                 	
		TR6->TR6_TIPCOM		:= 		Substr(cBuffer,38,3)
		TR6->TR6_CPFMOT		:= 		Substr(cBuffer,48,11)
		TR6->TR6_KMABAS		:= 		Val(Substr(cBuffer,62,7))     
		                             
		                             IF Val(Substr(cBuffer,73,7)) == 0
		                             	TR6->TR6_QTDCOM	:= 0
		                             Else
										TR6->TR6_QTDCOM	:= (Val(Substr(cBuffer,73,7)))   
									 Endif
									 
									 IF Val(Substr(cBuffer,90,4)) == 0
									 	TR6->TR6_VLCOMB	:= 0
									 Else
									 	TR6->TR6_VLCOMB	:= (Val(Substr(cBuffer,89,4)))
									 Endif	
		
		TR6->TR6_VLTOT		:= 		Val(Substr(cBuffer,103,6))
		TR6->TR6_DTABAS		:= 		CTOD(Substr(cBuffer,109,8))
		TR6->TR6_HRABAS		:= 		Substr(cBuffer,117,5)
	  //	TR6->TR6_DTPROC		:= 		CTOD(Substr(cBuffer,122,8))  
   		TR6->TR6_TANQUE		:= 		Substr(cBuffer,130,2) 
		TR6->TR6_BOMBA		:= 		Substr(cBuffer,132,3)
		
		FT_FSKIP() 
			
		TR6->(MsUnlock())  
	
	  
		
	EndDo		
	FT_FUSE()
	fClose(nHdl)
    
    MsgInfo ("Importação realizada com sucesso.")

Return()