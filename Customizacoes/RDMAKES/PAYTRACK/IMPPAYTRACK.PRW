#INCLUDE "parmtype.ch""
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"   
#INCLUDE "tbiconn.ch" 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPPAYTRACK  ºAutor  ³Gustavo Lattmann   Data ³  01/08/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Realizado o download dos arquivos da Paytrack do FTP e     º±±
±±º          ³ grava dentro da protheus_data                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IMPPAYTRACK()

Local cFTP := "ftp.cantu.tecnologia.ws"
Local nPORTA := 21
Local cUSUARIO := "cantu1"
Local cSENHA := "C@ntu6"

Local cPATH := "/paytrack/"

Local aRetDir := {}

If !FTPCONNECT( cFTP , nPORTA , cUSUARIO, cSENHA )
	Conout("Não foi possível conectar ao ftp!")
	Return
EndIf


if !FTPDIRCHANGE( "Paytrack" )		
	conout( "Nao foi possível modificar diretório!!" )		 	
EndIf   
		
//Retorna apenas os arquivos contidos no local   	
aRetDir := FTPDIRECTORY( "prc*.txt" , )    //-- tratado para não importar adiantamento
   

if !ExistDir(cPATH)
	Conout("Diretorio " + cPATH + " não existe")
EndIf
    	
	
//Verifica se o array está vazio   	
If Empty( aRetDir )   		
	Conout( "Não foram encontrados arquivos" )   		
	Return    	
EndIf   	    	

For nI := 1 To Len(aRetDir)
 
	//Tenta realizar o download de um item qualquer no array   	
	//Armazena no local indicado pela constante PATH	
	If !FTPDOWNLOAD( cPATH + aRetDir[nI][1], aRetDir[nI][1])   		
		Conout( "Nao foi possível realizar o download!!" )   		
		Return
	Else
		//Ao efetuar o download renomeia o arquivo para não ser importado duas vezes
	    if !FTPRENAMEFILE( aRetDir[nI][1] , aRetDir[nI][1]+".imp" )		
	    	Conout( "Nao foi possível renomear o arquivo!!" )   		
	    	Return 
	    EndIf
	EndIf  

Next nI

FTPDISCONNECT()
   
Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³INCPAYTRACK  ºAutor  ³Gustavo Lattmann   Data ³  01/08/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Realizado a inclusão da pré-nota baseado no arquivo txt    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function INCPAYTRACK()

Local cPathArq := "/paytrack/"

Local nLinha := 0
Local cLinha := ""
Local aLinArq := {}
Local aLinha := {}

//-- Cria diretorio para gravar arquivos importados
MakeDir(cPathArq + "imp/")   

//-- Cria diretorio para gravar arquivos com erros
MakeDir(cPathArq + "erro/")

//-- Busca arquivos txt dentro do diretório do servidor
aFiles := Directory(cPathArq +"*.txt")

If Empty(aFiles)
	Conout("PAYTRCK - SEM ARQUIVOS A IMPORTAR")
	Return
EndIf

For nFileImp := 1 to Len(aFiles)
	cFileImp := cPathArq + aFiles[nFileImp,1]
	cFileMov := cPathArq + "imp/" + aFiles[nFileImp,1]
	cFileErr := cPathArq + "erro/" + aFiles[nFileImp,1]
	
	//-- Abre o arquivo posicionado
	FT_FUSE(cFileImp)
	nLinha := FT_FLASTREC()
	FT_FGOTOP()
	//-- Percorre todas as linhas do arquivo
	For nX := 1 To nLinha
		cLinha := FT_FREADLN()
		//-- Converte a linha do arquivo para um array	
		aLinArq := StrTokArr(cLinha,";")
		
		//-- Trativa para caso o arquivo venha diferente do layout
      	If Len(aLinArq) != 9
      		Conout("PAYTRACK - Linha do arquivo fora do padrão")
      		FRename(cFileImp,cFileErr)
      		Return
      	EndIf
      	
		aAdd(aLinha,aLinArq)
		FT_FSKIP()
		aLinArq := {}
	Next nX
	
	//-- Antes de passar para o próximo arquivo deve fazer a inclusão da pré-nota
	lRet := U_EXECPAYTR(aLinha)
	//-- Caso a inclusão da pre-nota tenha sido realizada move para a pasta imp, senão para a pasta erro
	If lRet
		FRename(cFileImp,cFileMov)
	Else
		FRename(cFileImp,cFileErr)
	End
	aLinha := {}
	
Next nFileImp

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EXECPAYTR    ºAutor  ³Gustavo Lattmann   Data ³  01/08/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Realizado a inclusão da pré-nota baseado no arquivo txt    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function EXECPAYTR(aDados)
 
Local nOpc := 3 
//-- Posição dos campos dentro do arquivo Paytrack
Local nPosId  := 1 //Id Paytrack
Local nPosEmp := 2 //Empresa
Local nPosFil := 3 //Filial
Local nPosPro := 4 //Produto
Local nPosFor := 5 //Fornecedor
Local nPosVal := 6 //Valor
Local nPosSeg := 7 //Segmento
Local nPosCC  := 8 //Centro de Custo
Local nPosDat := 9 //DATA

Local lSucesso := .F.

Private aCabec      := {}
Private aItens      := {}
Private aLinha      := {}
Private lMsErroAuto := .F.
Private cItemNovo := "0000"
    
 
    PREPARE ENVIRONMENT EMPRESA StrZero(Val(aDados[1][nPosEmp]),2) FILIAL aDados[1][nPosFil] MODULO "COM" TABLES "SF1","SD1","SA1","SA2","SB1","SB2","SF4"
         
     
    dbSelectArea("SA2")
    SA2->(dbSetOrder(3)) //FILIAL + CGC
    SA2->(dbGoTop())
    If !SA2->(dbSeek(xFilial("SA2")+aDados[1][nPosFor]))
    	Conout("PAYTRACK - Fornecedor não encontrado")
    	lSucesso := .F.
    	Return lSucesso
    EndIf
    
    
    aAdd(aCabec,{'F1_FILIAL',aDados[1][nPosFil],NIL})
    aAdd(aCabec,{'F1_TIPO','N',NIL})
    aAdd(aCabec,{'F1_FORMUL','N',NIL})
    aAdd(aCabec,{"F1_EST", SA2->A2_EST, nil})    
    aAdd(aCabec,{'F1_DOC',StrZero(Val(aDados[1][nPosId]),9),NIL})
    aAdd(aCabec,{"F1_SERIE","PAY",NIL})
    aAdd(aCabec,{"F1_EMISSAO",dDataBase,NIL})
    aAdd(aCabec,{'F1_FORNECE',SA2->A2_COD,NIL})
    aAdd(aCabec,{'F1_LOJA',SA2->A2_LOJA,NIL})
    aAdd(aCabec,{"F1_ESPECIE","NF",NIL})
    aAdd(aCabec,{"F1_COND",'001',NIL})
    aAdd(aCabec,{"F1_STATUS",'',NIL})
    
    For nI := 1 To Len(aDados)
      	
        cItemNovo := "000"+Alltrim(Str(nI))
        aAdd(aItens,{"D1_ITEM",cItemNovo,NIL})
	    aAdd(aItens,{"D1_COD",aDados[nI][nPosPro],NIL})
	    aAdd(aItens,{"D1_QUANT",1,Nil})
	    aAdd(aItens,{"D1_VUNIT",Val(aDados[nI][nPosVal]),Nil})
	    aAdd(aItens,{"D1_TOTAL",Val(aDados[nI][nPosVal]),Nil})
	    aAdd(aItens,{"D1_CLVL",aDados[nI][nPosSeg],Nil})
	    aAdd(aItens,{"D1_CC",aDados[nI][nPosCc],Nil})
	    //aAdd(aItens,{"D1_TES",'',NIL})
	      
	    aAdd(aLinha,aItens) 
	    aItens := {}
	Next nI
      
    MSExecAuto({|x,y,z,a,b| MATA140(x,y,z,a,b)}, aCabec, aLinha, nOpc,,)
      
    If lMsErroAuto 
        mostraerro()
        lSucesso := .F.
    Else 
        Conout("PAYTRACK - Execauto MATA140 executado com sucesso!") 
        lSucesso := .T.
    EndIf 
     
    RESET ENVIRONMENT
  
Return lSucesso