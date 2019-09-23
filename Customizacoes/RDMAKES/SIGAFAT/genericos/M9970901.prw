#include "totvs.ch"
#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"
#include "fwbrowse.ch"
#include "dbinfo.ch"
#include "xmlxfun.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ M9970901    ºAutor  ³Totvs Cascavel     ºData ³ 27/02/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Efetua a leitura de arquivos .xml referente CFe            º±±
±±º          ³ Efetuando a inclusão de Pedidos de Vendas, e seu           º±±
±±º          ³ Faturamento.    	                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FSW                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function M9970901()

local oProcess
local cFunction		:= "M9970901"
local cPerg			:= "M9970901"+SPACE(2)
local cTitle		:= " Importação XML CFe "
local bProcess		:= { |oSelf| M99709P(oSelf) }
local cDescription	:= "  Este programa tem como objetivo efetuar a importação de arquivos .xml CFe. " +;
					   "  De acordo com os parâmetros informados serão gerados Pedidos de Vendas e seu respectivo Faturamento."
local lRet 			:= .T. 

private aStsProc	:= {}	
private aStsErro 	:= {}
private cSepara		:= iif(("LINUX" $ Upper(GetSrvInfo()[2])),"/","\")
private cPathErro	:= ""	// Pasta abaixo da Protheus_Data para gravar os LOGS de ERRO
private cPathLOG	:= ""	// Pasta abaixo da Protheus_Data para gravar os LOGS
private cDirAProc 	:= "" 	// Pasta abaixo da Protheus_Data para arquivos .xml a processar
private cDirProc  	:= "" 	// Pasta abaixo da Protheus_Data para arquivos .xml já processados
private cVend 		:= ""
private cCLVL 		:= ""
private cSerieNF	:= ""
private cLog		:= ""
private cArq  		:= ""


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³ Ajusta perguntas.       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ		
AjustaSX1(cPerg)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³ Efetua o Processamento 								 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ		
if lRet 
	oProcess := tNewProcess():New( cFunction, cTitle, bProcess, cDescription, cPerg, , , , ,.t.,.f. )
endif


return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M99709P  ºAutor  ³FSW TOTVS CASCAVEL    º Data ³ 27/02/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processamento da Rotina de Importação .xml Saída           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FSW                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function M99709P(oProcess)

local oXml
local aFiles 	:= {}
local i			:= 0
local nCount	:= 0 
local cError 	:= ""
local cWarning  := ""
local cDest 	:= "" 
local cCNPJ  	:= ""
local lRet 		:= .T.
local lDel 		:= .T.
local nSPEDEXC	:= GETMV("MV_SPEDEXC")

private lCanc 	:= .F.
private lNf 	:= .F.
private lMsErroAuto := .F. 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³ Definição das Pastas e variáveis   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ		
cDirLocAProc:= alltrim(mv_par01)
cDirLocProc := alltrim(mv_par02)
cDirLocErro := alltrim(mv_par01)+cSepara+"erros"
cDirLocLog  := alltrim(mv_par01)+cSepara+"log"

cPathErro	:= cSepara+"system"+cSepara+"imp_xml"+cSepara+"erros"+cSepara
cPathLOG	:= cSepara+"system"+cSepara+"imp_xml"+cSepara+"log" +cSepara
cDirAProc 	:= alltrim(GetSrvProfString("ROOTPATH",""))+cSepara+"system"+cSepara+"imp_xml"
cDirProc  	:= alltrim(GetSrvProfString("ROOTPATH",""))+cSepara+"system"+cSepara+"imp_xml"+cSepara+"processados"
cPatchProc  := "imp_xml"
cVend 		:= alltrim(mv_par03)
cCLVL 		:= alltrim(mv_par04)
cSerieNF 	:= alltrim(mv_par05)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³ Verifica se existem ou cria os diretórios informados ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ		
if !ExistDir( alltrim(cDirAProc) )
	nPath := MakeDir( alltrim(cDirAProc) )
	if nPath != 0
		ShowHelpDlg("Atenção", {"Não foi possível criar o diretório "+alltrim(cDirAProc)}, 5, {"Favor incluir o diretório "+alltrim(mv_par01)+" abaixo de protheus_data. Exemplo: protheus_data/"+alltrim(mv_par01)}, 5)	
		lRet := .F. 
	endif
endif

if lRet .and. !ExistDir( alltrim(cDirProc) )
	nPath := MakeDir( alltrim(cDirProc) )
	if nPath != 0
		ShowHelpDlg("Atenção", {"Não foi possível criar o diretório "+alltrim(cDirProc)}, 5, {"Favor incluir o diretório "+alltrim(mv_par02)+" abaixo de protheus_data. Exemplo: protheus_data/"+alltrim(mv_par02)}, 5)	
		lRet := .F.
	endif
endif

if lRet .and. !ExistDir( cPathErro )
	nPath := MakeDir( cPathErro )
	if nPath != 0
		ShowHelpDlg("Atenção", {"Não foi possível criar o diretório "+cPathErro}, 5, {"Favor incluir o diretório "+cPathErro+" abaixo de protheus_data. Exemplo: protheus_data/"+alltrim(mv_par01)+"erros/"}, 5)	
		lRet := .F.
	endif
endif

if lRet .and. !ExistDir( cPathLOG )
	nPath := MakeDir( cPathLOG )
	if nPath != 0
		ShowHelpDlg("Atenção", {"Não foi possível criar o diretório "+cPathLOG}, 5, {"Favor incluir o diretório "+cPathLOG+" abaixo de protheus_data. Exemplo: protheus_data/"+alltrim(mv_par01)+"log/"}, 5)	
		lRet := .F.
	endif
endif

if !lRet
	return()
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³ Faz o carregamento dos arquivos para o Array aFiles ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ		
//aFiles := Directory(cDirAProc+"\*.xml")
aFiles := Directory(cDirLocAProc+"\*.xml")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³ Contagem dos arquivos para processamento.           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ		
nCount := Len( aFiles )
oProcess:SetRegua1(nCount+1) 
oProcess:SetRegua2(nCount*4) 

oProcess:IncRegua1("Iniciando Importação:")
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³ Leitura e processamento dos arquivos                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ		
for i := 1 to len(aFiles)
	//copia o arquivo para o server
	CpyT2S( cDirLocAProc+cSepara+aFiles[i][1], cPatchProc , .f.)
	
	lRet := .T. 
	cError 	:= ""
	cWarning:= ""
	cArq := cSepara+"system"+cSepara+cPatchProc+"\"+aFiles[i][1] 
	oXml := xmlparserfile(cArq, "_", @cError, @cWarning)
	oProcess:IncRegua1("Arquivo:" + cArq) 
	
	if cError # "" .or. cWarning # ""
		CONOUT("Erro: " + cError + "  -  Aviso: " + cWarning )
		aadd( aStsErro,{"Arquivo não encontrado.", "ERRO", cLog, cArq} )
	else
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³ Verfica se é um NF ou CANCELAMENTO de NF   		    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ					
		lNf 	:= XmlChildEx(oXml, "_CFE") <> nil
		lCanc 	:= XmlChildEx(oXml, "_CFECANC") <> nil
		
		
		if lNf		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³ CNJP do Emitente.          			    		    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ					
			cCNPJ  := alltrim(oXml:_CFe:_infCFe:_emit:_CNPJ:Text)
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³ Número e Série da Nota Fiscal.   	    		    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ					
			cNF  := alltrim(oXml:_CFe:_infCFe:_ide:_nCFE:Text)
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³ Processa apenas a filial atual.					    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ			
			if cCNPJ == SM0->M0_CGC
				
				dbselectarea("SF2")
				SF2->(dbsetorder(1))
				SF2->(dbgotop())
				if !dbseek(xFilial("SF2")+PADR(cNF,TamSX3("F2_DOC")[1])+cSerieNF)	
							
					begin transaction
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Data de emissao                            ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						ddatabase := stod(oXml:_CFe:_infCFe:_ide:_dEmi:Text)

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Gravação dos Pedidos de Venda              ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						if lRet
							lRet := M99709PP(oXml)
							oProcess:IncRegua2("Pedido de Venda")
						endif
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Liberação do Pedidos de Venda              ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						if lRet
							lRet := M99709L(SC5->C5_NUM, oXml)
						endif
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Faturamento do Pedido                      ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						if lRet 
							lRet := M99709PF(SC5->C5_NUM, oXml)
							oProcess:IncRegua2("Faturamento")
						endif
		
						if lRet					
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³ Marca arquivo para apagar						    ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ				
							lDel := .T. 
						endif
						
						if !lRet 
							disarmtransaction()
						endif
					
					end transaction
				else
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³ NF já existe, grava log de erro para Relatório.     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ				
					aadd( aStsErro,{"Nota Fiscal", "ERRO", "Nota Fiscal:"+cNF+" Serie: "+cSerieNF+" já existe.", cArq} )
	
				endif		
			endif	
		elseif lCanc
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³ Altera parâmetro MV_SPECEXC para permitir excluir a NF. ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ					
			dbselectarea("SX6")
			sx6->(dbsetorder(retordem("x6_filial+x6_var")))
			if SX6->(dbseek(xfilial("SX6")+"MV_SPEDEXC"))
				Reclock("SX6",.F.)
				SX6->X6_CONTEUD := '99999'
				SX6->X6_CONTSPA := '99999'
				SX6->X6_CONTENG := '99999'
				SX6->(Msunlock())
			endif
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³ CNJP do Emitente.          			    		    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ					
			cCNPJ  := alltrim(oXml:_CFeCanc:_infCFe:_emit:_CNPJ:Text)
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³ Número e Série da Nota Fiscal.   	    		    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ					
			cNF  := alltrim(oXml:_CFeCanc:_infCFe:_ide:_nCFE:Text)
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³ Processa apenas a filial atual.					    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ			
			if cCNPJ == SM0->M0_CGC
				
				dbselectarea("SF2")
				SF2->(dbsetorder(1))
				SF2->(dbgotop())
				if dbseek(xFilial("SF2")+PADR(cNF,TamSX3("F2_DOC")[1])+cSerieNF)	
					aMata520Cab	:= {{"F2_DOC"	,PADR(cNF,TamSX3("F2_DOC")[1])    	,Nil},;
                      				{"F2_SERIE" ,cSerieNF   ,Nil}}
    				Mata520(aMata520Cab)

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Checa erro de rotina automatica   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					if lMsErroAuto  
						cFile := "M99709_erro_" + DTOS(DDATABASE)+SUBSTR(ALLTRIM(TIME()),0,2)+SUBSTR(ALLTRIM(TIME()),4,2)+".log"
						MostraErro(cPathErro,cFile)
						cLog := MemoRead(cPathErro + cFile)
						aadd( aStsErro,{"Cancelamento de Nota Fiscal", "ERRO", cLog, cArq} )
						lRet := .F. 
					else    
						aadd( aStsProc,{"Cancelamento de Nota Fiscal", "OK", "Número: "+SF2->F2_DOC, cArq} )		
						lRet := .T.              
					endif 		
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³ Marca arquivo para mover na pasta processados. 	    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ				
					lDel := .T. 
				else
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³ NF já existe, grava log de erro para Relatório.     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ				
					aadd( aStsErro,{"Cancelamento de Nota Fiscal", "ERRO", "Nota Fiscal:"+cNF+" Serie: "+cSerieNF+" não existe, portanto não foi cancelada.", cArq} )
					lRet := .F.
					lDel := .F. 
				endif
			endif
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³ Retorna parâmetro MV_SPECEXC para permitir excluir a NF.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ					
			dbselectarea("SX6")
			sx6->(dbsetorder(retordem("x6_filial+x6_var")))
			if SX6->(dbseek(xfilial("SX6")+"MV_SPEDEXC"))
				Reclock("SX6",.F.)
				SX6->X6_CONTEUD := alltrim(str(nSPEDEXC))
				SX6->X6_CONTSPA := alltrim(str(nSPEDEXC))
				SX6->X6_CONTENG := alltrim(str(nSPEDEXC))
				SX6->(Msunlock())
			endif
		endif
	endif
	
	if lDel				
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³ Efetua a cópia do arquivo processado Server         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ		
		__CopyFile( cDirAProc+cSepara+aFiles[i][1], cDirProc+cSepara+aFiles[i][1] )	
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³ Efetua a cópia do arquivo processado Local          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ		
		CpyS2T( "system"+cSepara+cPatchProc+cSepara+aFiles[i][1], cDirLocProc+cSepara, .f. )
	endif
	
	if !lRet
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³ Efetua a cópia do arquivo processado para Erro Server³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ		
		__CopyFile( cDirAProc+cSepara+aFiles[i][1], cDirAProc+cSepara+"erros"+cSepara+aFiles[i][1] )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³ Efetua a cópia do arquivo processado para Erro Local³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ		
		CpyS2T( "system"+cSepara+cPatchProc+cSepara+aFiles[i][1], cDirLocAProc+cSepara+"erros", .f. )
	endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³ Apaga o arquivo processado da pasta principal Server³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ		
	FERASE(alltrim(cDirAProc+cSepara+aFiles[i][1]))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³ Apaga o arquivo processado da pasta principal Local ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ		
	FERASE(alltrim(cDirLocAProc+cSepara+aFiles[i][1]))
next i


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Log do Processamento em arquivo .txt       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cLine := ""
if len(aStsProc) > 0 .or. len(aStsErro) > 0 
	cLine := "INICIO Processamento Importação .XML CFe/SP" + CRLF 
	for i := 1 to len(aStsErro)
		cLine += aStsErro[i][1]+" "+aStsErro[i][2]+" "+aStsErro[i][3] + CRLF
	next i 
	cLine +=  + CRLF + CRLF
	for i := 1 to len(aStsProc)
		cLine += aStsProc[i][1]+" "+aStsProc[i][2]+" "+aStsProc[i][3] + CRLF
	next i 
	cLine +=  + CRLF + CRLF
	cLine += "FIM Processamento Importação .XML CFe/SP" + CRLF 
 
 	MemoWrite( cPathLOG+dtos(ddatabase)+"_log_imp_xml_"+substr(time(),1,2)+substr(time(),4,2)+substr(time(),7,2)+".txt", cLine )
 	MemoWrite( cDirLocLog+cSepara+dtos(ddatabase)+"_log_imp_xml_"+substr(time(),1,2)+substr(time(),4,2)+substr(time(),7,2)+".txt", cLine )
endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressão Relatório de LOG.                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if len(aStsProc) > 0 .or. len(aStsErro) > 0 
	M99709R()
endif



return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³X9970901  ºAutor  ³Marcelo Joner        º Data ³ 11/01/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela atualização do dicionário de help deº±±
±±º          ³campos\perguntas à partir de utilização de função padrão.   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FSW                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function X9970901(cCpoPer, aHlpPor, aHlpEng, aHlpSpa)

local aArea			:= GetArea()
local aRpoRel		:= StrToKarr(GetRPORelease(),".")
local cRpoRel		:= aRpoRel[2] + alltrim(str(val(aRpoRel[3])))
local bUpdHelp		:= &("{|w,x,y,z| EngHLP" + cRpoRel + "(w,x,y,z)}")

default cCpoPer		:= ""
default aHlpPor 	:= {}
default aHlpEng		:= aHlpPor
default aHlpSpa		:= aHlpPor

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa regras de compatibilização das informações presentes nos arrays³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
aHlpPor := X9970901D(aHlpPor)
aHlpEng := X9970901D(aHlpEng)
aHlpSpa := X9970901D(aHlpSpa)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Caso seja Release 12.1.7 ou acima, utiliza ENGHLP³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
if aRpoRel[3] > "007" .AND. FindFunction("EngHLP" + cRpoRel)
	Eval(bUpdHelp, cCpoPer, aHlpPor, aHlpEng, aHlpSpa)
else
	PutSX1Help(cCpoPer, aHlpPor, aHlpEng, aHlpSpa, .T.,, .T.)
endif

RestArea(aArea)

return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³X9970901D ºAutor  ³Marcelo Joner        º Data ³ 11/01/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função utilizada para ajuste na string de dados do array comº±±
±±º          ³as definições de help.                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FSW                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function X9970901D(xDet)

local nI		:= 0
local aDet		:= {}
local cDet		:= ""
local cTexto	:= ""

default xDet	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Considera regras caso existam informações de help³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
if !EMPTY(xDet)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Caso tenha sido repassado array, compõe variavel única com todo o help³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	if valtype(xDet) == "A"
		for nI := 1 to len(xDet)
			cDet += iif(empty(cDet), "", " ") + alltrim(xDet[nI])
		next nI
	else
		cDet := xDet
	endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Compõe array com as palavras que compõe o help³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	aItens := StrToKarr(cDet, " ")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Compõe um novo array de forma de cada item possua palavras que não ultrapassem 40 caracteres³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	for nI := 1 to len(aItens)
		if len(cTexto + iif(!EMPTY(cTexto), " ", "") + aItens[nI]) >= 40
			aadd(aDet, cTexto)
			cTexto := aItens[nI]
		else
			cTexto += iif(!EMPTY(cTexto), " ", "") + aItens[nI]
		endif
	next nI
	
	aadd(aDet, cTexto)
endif

return aDet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M99709PP  ºAutor  ³FSW TOTVS CASCAVEL   º Data ³28/02/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gravação dos Pedidos de Venda.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function M99709PP(oXml)

local lRet 		:= .T.
local cCNPJD	:= ""
local cCodBar 	:= ""
local cLog		:= ""
local cFile		:= ""
local cOper		:= ""   //Tipo de Operação para TES Inteligente
local nQtdVen 	:= 0
local nPrcVen 	:= 0
local nPrcTot 	:= 0
local nVlrDesc  := 0
local ix		:= 1
local nItem		:= 1
local nQtde 	:= 1
local aCabSC5   := {}
local aItSC6	:= {}
local aLinha	:= {}
local cCodCli 	:= SUPERGETMV("MV_CLIPAD" ,.F.,strzero( 1, TamSX3("A1_COD")[1]  ) )
local cLJCli 	:= SUPERGETMV("MV_LOJAPAD",.F.,strzero( 1, TamSX3("A1_LOJA")[1] ) ) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no Cliente 					   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if Type( oXml:_CFe:_infCFe:_ide:_CNPJ:Text ) <> "U"
	cCNPJD  := alltrim(oXml:_CFe:_infCFe:_ide:_CNPJ:Text)
	dbselectarea("SA1")
	SA1->(dbsetorder(3))
	SA1->(dbgotop())
	if ! dbseek(xFilial("SA1")+cCNPJD)
		dbselectarea("SA1")
		SA1->(dbsetorder(1))
		SA1->(dbgotop())
		dbseek(xFilial("SA1")+PADR(cCodCli,TamSX3("A1_COD")[1]) + cLJCli)	
	endif
else
	dbselectarea("SA1")
	SA1->(dbsetorder(1))
	SA1->(dbgotop())
	dbseek(xFilial("SA1")+PADR(cCodCli,TamSX3("A1_COD")[1])+cLJCli)	
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verificação do Tipo de Operação.           ³
//³01 - Venda PJ - contribuinte com IE		   ³
//³03 - Venda não contribuinte (PF ou Juridica)³
//³04- Bonificação							   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
do case

	case SA1->A1_PESSOA == 'J' .and. !empty(SA1->A1_INSCR) .and. alltrim(SA1->A1_INSCR) <> 'ISENTO'
		cOper := '01'
	
	case empty(SA1->A1_INSCR) .OR. alltrim(SA1->A1_INSCR) == 'ISENTO'
		cOper := '03'
		
//	case BONIFICAÇÃO ?????

end case



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inclusão do Pedido de Vendas			   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aadd( aCabSC5, { "C5_TIPO"	    , "N"	  				, nil } )
aadd( aCabSC5, { "C5_CLIENTE"	, SA1->A1_COD 			, nil } )
aadd( aCabSC5, { "C5_LOJACLI"	, SA1->A1_LOJA 			, nil } )
aadd( aCabSC5, { "C5_TABELA"	, "   "					, nil } )
aadd( aCabSC5, { "C5_VEND1"		, cVend					, nil } )   //Vendedor
aadd( aCabSC5, { "C5_X_CLVL"  	, cCLVL  				, nil } )   //Segmento

aCabSC5 := FWVetByDic( aCabSC5, 'SC5' )


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a quantidade de itens da venda    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nQtde := iif(valtype(oXml:_CFe:_infCFe:_Det)=="A",len(oXml:_CFe:_infCFe:_Det),1)

for ix := 1 to nQtde		
	if nQtde == 1
		cCodBar := oXml:_CFe:_infCFe:_Det:_Prod:_CProd:Text
		nQtdVen := val(oXml:_CFe:_infCFe:_Det:_Prod:_qCom:Text)
		nPrcVen := val(oXml:_CFe:_infCFe:_Det:_Prod:_vUnCom:Text)	
		nPrcTot := val(oXml:_CFe:_infCFe:_Det:_Prod:_vProd:Text)
		if type("oXml:_CFe:_infCFe:_Det:_Prod:_vDesc:Text") # 'U'
			nVlrDesc := val(oXml:_CFe:_infCFe:_Det:_Prod:_vDesc:Text)
		endif
	else
		cCodBar := oXml:_CFe:_infCFe:_Det[ix]:_Prod:_CProd:Text
		nQtdVen := val(oXml:_CFe:_infCFe:_Det[ix]:_Prod:_qCom:Text)
		nPrcVen := val(oXml:_CFe:_infCFe:_Det[ix]:_Prod:_vUnCom:Text)	
		nPrcTot := val(oXml:_CFe:_infCFe:_Det[ix]:_Prod:_vProd:Text)
		if type("oXml:_CFe:_infCFe:_Det[ix]:_Prod:_vDesc:Text") # 'U'
			nVlrDesc := val(oXml:_CFe:_infCFe:_Det[ix]:_Prod:_vDesc:Text)
		endif
	endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona no Produto pelo Código de Barras.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbselectarea("SB1")
	SB1->(dbsetorder(5))
	SB1->(dbgotop())
	if dbseek(xFilial("SB1")+cCodBar)	
		aLinha := {}
		aadd( aLinha, {"C6_ITEM"   	, strzero( nItem, TamSX3( "C6_ITEM" )[1] ),	nil} )
		aadd( aLinha, {"C6_PRODUTO"	, SB1->B1_COD,	 							nil} )
		aadd( aLinha, {"C6_QTDVEN"	, nQtdVen, 									nil} )
		aadd( aLinha, {"C6_PRCVEN"	, nPrcVen,									nil} )
		aadd( aLinha, {"C6_VALOR"	, nPrcTot,									nil} )
		aadd( aLinha, {"C6_OPER"	, cOper,									nil} )
		//aadd( aLinha, {"C6_TES"	, '503',									nil} )

		aadd( aLinha, {"C6_VALDESC"	, nVlrDesc,									nil} )
		aLinha := FWVetByDic( aLinha, 'SC6' )
		aadd( aItSC6, aLinha )
		nItem ++
	else
		lRet := .F. 
		Exit
	endif
next ix

if lRet
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Rotina Automatica Pedido de Vendas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MSExecAuto( { |x,y,z|Mata410( x, y, z ) }, aCabSC5, aItSC6, 3 )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Checa erro de rotina automatica   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if lMsErroAuto  
		cFile := "M99709_erro_" + DTOS(DDATABASE)+SUBSTR(ALLTRIM(TIME()),0,2)+SUBSTR(ALLTRIM(TIME()),4,2)+".log"
		MostraErro(cPathErro,cFile)
		cLog := MemoRead(cPathErro + cFile)
		aadd( aStsErro,{"Pedido de Vendas", "ERRO", cLog, cArq} )
		lRet := .F. 		
	else    
		aadd( aStsProc,{"Pedido de Vendas", "OK", "Número: "+SC5->C5_NUM, cArq} )		
		lRet := .T.              
	endif 		
else
	aadd( aStsErro,{"Pedido de Vendas", "ERRO", "Produto: "+cCodBar+" não encontrado na SB1.", cArq } )		
endif

return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M99709L  ºAutor   ³TOTVS CASCAVEL       º Data ³ 01/03/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Liberação do Pedido de Vendas.                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function M99709L(cPedido, oXml)

Local cPedido

dbselectarea("SC6")
SC6->(dbgotop())
SC6->(dbsetorder(1))
if dbseek( xFilial("SC6") + cPedido )

	while SC6->(!eof()) .and. SC6->C6_NUM == cPedido .and. SC6->C6_FILIAL == xFilial("SC6")
		nQtdLib := SC6->C6_QTDVEN
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Executa função de estorno do item atual da SC9³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ	
		dbselectarea("SC9")
		SC9->(dbgotop())
		SC9->(dbsetorder(1))
		if dbseek( xFilial("SC9") + SC6->C6_NUM + SC6->C6_ITEM )
			a460Estorna(.T., .T.)
		endif
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Executa função de reavaliação do item do pedido³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		dbSelectArea("SC6")
		MaLibDoFat(SC6->(RecNo()),@nQtdLib,.T.,.T.,.F.,.F.,.F.,.F.)
		dbselectarea("SC6")
		SC6->(dbskip())
	enddo

endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Atualiza flag do pedido de venda³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
dbselectarea("SC5")
SC5->(dbsetorder(1))
SC5->(dbgotop())
if SC5->(dbseek(xfilial("SC5") + cPedido))
	reclock("SC5")
		SC5->C5_LIBEROK := "S"
	SC5->(msunlock())
endif

SC6->(dbclosearea())

return(.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M99709PF  º Autor  ³FSW TOTVS CASCAVEL   º Data ³28/02/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Faturamento do Pedido de Venda.                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function M99709PF(cPedido, oXml)

local lRet 		:= .T.
local cPedido
local aPvlNfs	:= {}
local aBloqueio	:= {}
local aNotas 	:= {}
local ni		:= 0 
																
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Inicia os procedimentos de liberação do pedido ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
DbSelectArea("SC5")
SC5->(DbSetOrder(1))
SC5->(DbGoTop())
if SC5->(DbSeek(xFilial("SC5") + cPedido))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Executa liberação de Regras    			       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MaAvalSC5("SC5",9)
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Executa/confirma a liberaçao dos itens do pedido³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Ma410LbNfs(2,@aPvlNfs,@aBloqueio)
	Ma410LbNfs(1,@aPvlNfs,@aBloqueio)     
					
	if empty(aBloqueio) .And. !empty(aPvlNfs)				
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Chama rotina para faturamento do pedido de venda gerado³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 		   
		Pergunte("MT460A", .F.)	  
		aParam460 := ARRAY(30)
		for ni := 1 to 30
			aParam460[ni] := &("MV_PAR" + STRZERO(ni, 2))
		next ni
			
		nitemNF	:= A460NUMIT(cSerieNf)
		aadd(aNotas, {})
				
		for ni := 1 to len(aPvlNfs)
			if len(aNotas[len(aNotas)]) >= nitemNF
				aadd(aNotas, {})
			endif
			aadd(aNotas[len(aNotas)], aClone(aPvlNfs[ni]))
		next ni
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Gera documentos fiscais de saída							   ³
		//³Deve-e utilizar o PE M460NUM para manipular o numero da NF. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		for ni := 1 to len(aNotas)
			MAPVLNFS(aNotas[ni], cSerieNf, aParam460[1]==1, aParam460[2]==1, aParam460[3]==1, aParam460[4]==1, aParam460[5]==1, aParam460[7], aParam460[8], aParam460[16]==1, aParam460[16]==2)
		next ni
	else			
		aadd( aStsErro,{"Faturamento", "ERRO", "Faturamento não efetuado P.V.: "+cPedido, cArq} )	
	endif
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Verifica se o pedido foi faturado.                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
dbselectarea("SC5")
SC5->(dbsetorder(1))
SC5->(dbgotop())  
SC5->(dbseek(xFilial("SC5") + cPedido))
if !empty(SC5->C5_NOTA) 
	aadd( aStsProc,{"Faturamento", "OK", "(" + cFilAnt + ") Nota Fiscal: "+SC5->C5_NOTA+" Ref. Pedido de Vendas: "+cPedido, cArq} )	
	lRet := .T. 		

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³ Gravação de campos específicos tabelas fiscais.         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	dbselectarea("SF2")
	reclock("SF2",.F.)
		SF2->F2_CHVNFE := substr(oXml:_CFe:_infCFe:_id:text,4,44)
		SF2->F2_ESPECIE:= "SATCE"
		SF2->F2_ESPECI1:= "SATCE"
		SF2->F2_SERSAT := oXml:_CFe:_infCFe:_ide:_nserieSAT:text
	SF2->(msunlock())
	
	cNF 		:= SF2->F2_DOC
	cSerie 		:= SF2->F2_SERIE
	cCliente 	:= SF2->F2_CLIENTE
	cLoja		:= SF2->F2_LOJA
	
	dbselectarea("SD2")
	SD2->(dbsetorder(3))
	SD2->(dbgotop())  
	if SFT->(dbseek(xFilial("SD2") +  cNF + cSerie + cCliente + cLoja))
		while SD2->(!eof()) .and. SD2->D2_FILIAL == xFilial("SD2") .and. SD2->D2_DOC == cNF .and. SD2->D2_SERIE == cSerie .and. ; 
		      SD2->D2_CLIENTE == cCliente .and. SD2->D2_LOJA == cLoja 
			reclock("SD2",.F.)
			SD2->D2_ESPECIE := "SATCE"
			SD2->(msunlock())
			SD2->(dbskip())
		end do
	endif

	dbselectarea("SFT")
	SFT->(dbsetorder(1))
	SFT->(dbgotop())  
	if SFT->(dbseek(xFilial("SFT") + "S" + cSerie + cNF + cCliente + cLoja))
		while SFT->(!eof()) .and. SFT->FT_FILIAL == xFilial("SFT") .and. SFT->FT_TIPOMOV == 'S' .and. SFT->FT_SERIE == cSerie .and. ; 
		      SFT->FT_NFISCAL == cNF .and.  SFT->FT_CLIEFOR == cCliente .and. SFT->FT_LOJA == cLoja 
			reclock("SFT",.F.)
			SFT->FT_CHVNFE := substr(oXml:_CFe:_infCFe:_id:text,4,44)
			SFT->FT_ESPECIE:= "SATCE"
			SFT->FT_SERSAT := oXml:_CFe:_infCFe:_ide:_nserieSAT:text
			SFT->(msunlock())
			SFT->(dbskip())
		end do
	endif
	
	dbselectarea("SF3")
	SF3->(dbsetorder(5))
	SF3->(dbgotop())  
	if SF3->(dbseek(xFilial("SF3") + cSerie + cNF + cCliente + cLoja ))
		reclock("SFT",.F.)
		SF3->F3_CHVNFE := substr(oXml:_CFe:_infCFe:_id:text,4,44)
		SF3->F3_ESPECIE:= "SATCE"
		SF3->F3_SERSAT := oXml:_CFe:_infCFe:_ide:_nserieSAT:text
		SF3->(msunlock())
	endif
	
	
else    
	aadd( aStsErro,{"Faturamento", "ERRO", "Faturamento não efetuado P.V.:: "+cPedido, cArq} )				
endif                     


return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M99709R   ºAutor  ³FSW TOTVS CASCAVEL    º Data ³01/03/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório referente aos logs do processamento.             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function M99709R()

local oReport 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Interface de impressao                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:= ReportDef()
oReport:PrintDialog()
oReport := nil

return


**-------------------------**
Static Function ReportDef()
**-------------------------**
local cNomeRel := "M99709R"
local cTitulo  := "LOG Importação .xml"
local cDescri  := "Este relatório emite LOG referente processo de Importação de arquivos .xml "
local oSection1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:= TReport():New(cNomeRel, cTitulo, , {|oReport| ReportPrint(oReport)}, cDescri )
oReport:SetPortrait()

oReport:SetTotalInLine(.T.)		//Define se os totalizadores serão impressos em linha ou coluna
oReport:bTotalPrint := {|| }	//Desativa a impressão dos totalizadores gerais
oReport:lParamPage  := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Cria a sessão principal do relatório  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
oSection1 := TRSection():New(oReport, "Apurações", {"ZCS"},,,,,,.F.,.F.,.T.,,,,,.F.)
oSection1:SetPageBreak(.F.)			// Define se salta a página na quebra de seção
oSection1:SetHeaderSection(.T.)		// Define se imprime cabeçalho das células na seção

TRCell():New(oSection1, "Tipo"	,,"Descricao"		,,020,,)
TRCell():New(oSection1, "Status",,"Status"			,,010,,)
TRCell():New(oSection1, "Log"   ,,"LOG/Observacoes",/*cPicture*/,200,/*lPixel*/,/*bBlock*/,/*cAlign*/,.T. /*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,.T./*lAutoSize*/,/*nClrBack*/,/*nClrfore*/,/*lBold*/)

return(oReport)


**--------------------------------------**
Static Function ReportPrint(oReport)
**--------------------------------------**
local oSection1	:= oReport:Section(1)
local i 		:= 1
local nErro 	:= 0
local nOK 		:= 0 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³ Ajusta régua de processamento         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
nQtReg := len(aStsProc)+len(aStsErro)

oReport:SetMeter(nQtReg)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³ Executa a impressão do relatório  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
if nQtReg > 0
	cContAnt := ""
	for i := 1 to len(aStsProc)
	
		if oReport:Cancel()
			Exit
		endif

		//Inicializo a seção
		oSection1:Init()
		
		//Incrementa Régua
		oReport:IncMeter()

		oSection1:Cell("Tipo"		):SetValue(aStsProc[i][1])		
		oSection1:Cell("Status"		):SetValue(aStsProc[i][2])
		oSection1:Cell("Log"		):SetValue(aStsProc[i][3])
		oSection1:Printline()
		nOK ++ 
	next i
	

	for i := 1 to len(aStsErro)
	
		if oReport:Cancel()
			Exit
		endif

		//Inicializo a seção
		oSection1:Init()
		
		//Incrementa Régua
		oReport:IncMeter()

		oSection1:Cell("Tipo"		):SetValue(aStsErro[i][1])		
		oSection1:Cell("Status"		):SetValue(aStsErro[i][2])
		oSection1:Cell("Log"		):SetValue(aStsErro[i][3])
		oSection1:Printline()
		nErro ++ 
	next i
	
	oReport:SkipLine()
	oReport:SkipLine()
	oReport:SkipLine()
	oReport:Say(oReport:Row(), oReport:Col(), "RESUMO ")
	oReport:SkipLine()
	oReport:ThinLine()
	oReport:Say(oReport:Row(), oReport:Col(), "Total processados: "+Alltrim(Transform(nErro+nOK,"@E 999,999,999")))
	oReport:SkipLine()
	oReport:Say(oReport:Row(), oReport:Col(), "Total incluídos  : "+Alltrim(Transform(nOK,"@E 999,999,999")))
	oReport:SkipLine()
	oReport:Say(oReport:Row(), oReport:Col(), "Total com erros  : "+Alltrim(Transform(nErro,"@E 999,999,999")))

	oSection1:Finish()
endif

return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AJUSTASX1   ºAutor  ³Totvs Cascavel    º Data ³  27/02/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina responsavel pela verificação\criação do grupo de per-º±±
±±º          ³guntas utilizado como parâmetros.			                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³FSW                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function AjustaSX1(cPerg)

local ni	:= 0
local nj	:= 0

private aRegs	:= {}  
private aHelps	:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Definição dos itens do grupo de perguntas a ser criado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ    
aadd(aRegs, {cPerg, "01", "Local arquivos entrada    ", "Local arquivos entrada    ", "Local arquivos entrada    ", "mv_ch1","C",40,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})
aadd(aRegs, {cPerg, "02", "Local arquivos processados", "Local arquivos processados", "Local arquivos processados", "mv_ch2","C",40,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})
aadd(aRegs, {cPerg, "03", "Vendedor                  ", "Vendedor                  ", "Vendedor                  ", "mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA3","","","",""})
aadd(aRegs, {cPerg, "04", "Segmento                  ", "Segmento                  ", "Segmento                  ", "mv_ch4","C",09,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","CTH","","","",""})
aadd(aRegs, {cPerg, "05", "Serie NF                  ", "Serie NF                  ", "Serie NF                  ", "mv_ch5","C",03,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""})



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Montagem do Help de cada item do Grupo de Perguntas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
aadd(aHelps, "Informe o local para leitura dos arquivos que serao processados (.xml). Dever estar abaixo do rootpath (/protheus_data/)")       
aadd(aHelps, "Informe o local onde serão armazenados os arquivos .xml já processados. Dever estar abaixo do rootpath (/protheus_data/)")       
aadd(aHelps, "Informe o Vendedor. ")
aadd(aHelps, "Informe o Segmento. ")
aadd(aHelps, "Informe a serie das Notas Fiscais ")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Insere os itens do grupo de perguntas no dicionário de perguntas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
dbselectarea("SX1")
SX1->(dbsetorder(1))
for nI := 1 to len(aRegs)
	SX1->(dbgotop())
	if !SX1->(dbSeek(cPerg + aRegs[nI,2]))
		reclock("SX1", .T.)
			for nJ := 1 to fcount()
				if nJ <= len(aRegs[nI])
					FieldPut(nJ, aRegs[nI,nJ])
				endIf
			next nJ
		SX1->(msunlock())
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Atualiza o Help do item do grupo de perguntas que foi inserido no SX1³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		X9970901("P." + alltrim(cPerg) + strzero(nI, 2) + ".", &("aHelps["+alltrim(str(nI))+"]"))
	endIf
next nI


return