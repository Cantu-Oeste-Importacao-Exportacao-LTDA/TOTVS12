/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ CTMAT01  ¦ Autor ¦ LINCOLN P. ROSSETTO   ¦ Data ¦ 16/04/08 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ "Retorno da liberação"                                     ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦¦          ¦---ALTERAÇÕES-----------------------------------------------¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Especifico para CANTU.                                     ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Sol. Cust.¦ 04186080415-01                                             ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
#include "rwmake.ch"
#include "tbiconn.ch"
user function CTMAT02(nOpcao,oProcess)
//LOCAL nC
LOCAL cPedido, cAprovcd  //cLoja, cFornec, cFornen, dEmissao, cAprovnm, dDtRef, nLimMin, nLimMax, nLimite
LOCAL cLibera, cObs, nTotal //,cTipoLim, nSaldo, , nSalDif, aProd, aDesc, aQtd, aUm, aPreco, aTotal, , cUsuario, cMoeda
LOCAL nRec, lRetorno
	
LOCAL cEmp := Space(2), cFil := Space(2)
	
LOCAL cAuxTp
LOCAL cProcess
LOCAL cStatus  
LOCAL lLiberou
Local lRetorno := .T.
	//
local lSAK := .T.
local lSC7 := .T.
local lSA2 := .T.
local lSAL := .T.
local lSCS := .T.
local lSCR := .T.
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//
cEmp := oProcess:oHtml:RetByName("WFEMPRESA")
cFil := oProcess:oHtml:RetByName("WFFILIAL")
	
	// Abre as tabelas que vao ser utilizadas
cProcess := OemToAnsi("001020") // Numero do Processo
cStatus  := OemToAnsi("001022")
// ocultado este item porque vem tudo via email	
//If (nOpcao == 1)                               
cPedido    := oProcess:oHtml:RetByName("NPED")
cAprovcd   := oProcess:oHtml:RetByName("CDAPRV")
cLibera    := oProcess:oHtml:RetByName("LIBERA")
cObs       := iif(oProcess:oHtml:RetByName("OBS")=='digite aqui a sua observação',"",oProcess:oHtml:RetByName("OBS"))
nTotal     := val(StrTran(StrTran(oProcess:oHtml:RetByName("TOTDOC"),".",""),",","."))
//    
if cLibera == 'LIBERAR'
  // Verifica o cadastro de aprovadores
  dbSelectArea("SAK")
	dbSetOrder(1)
	SAK->(dbgotop())
	if dbSeek(xFilial()+cAprovcd)
	   conout("1/6)---------------> Ok! Cadastro de Aprovadores.")
	else
	   conout("1/6)---------------> Nao Ok! Cadastro de Aprovadores.")
	   lSAK := .F.
	endif

	// Verifica o pedido de compra
	dbSelectArea("SC7")
	dbSetOrder(1)   
	SC7->(dbgotop())
	if dbSeek(xFilial()+cPedido)
	   conout("2/6)---------------> Ok! Pedido de Compra." )`
	else
	   conout("2/6)---------------> Nao Ok! Pedido de compra.")
	   lSC7 := .F.
	endif
	
	// verifica o fornecedor
	dbSelectArea("SA2")
	dbSetOrder(1)
	SA2->(dbgotop())
	if dbSeek(xFilial()+SC7->C7_FORNECE+SC7->C7_LOJA)
	   conout("3/6)---------------> Ok! Fornecedor.")
	else
	   conout("3/6)---------------> Nao Ok! Fornecedor.")
	   lSA2 := .F.
	endif
	                        
	// Verifica o grupo de aprovacao
	dbSelectArea("SAL")
	dbSetorder(3)
	SAL->(dbgotop()) 
	// Flavio - 21/06/08 - Alterado para buscar por filial + grupo + cod. aprovador ao invés de filial + grupo + cod. Superior
	if dbSeek(xFilial()+SC7->C7_APROV+SAK->AK_COD) //SAK->AK_APROSUP
	   conout("4/6)---------------> Ok! Aprovacao.")
	else
	   conout("4/6)---------------> Nao Ok! Aprovacao.")
	   lSAL := .F.
	endif
	
	// Verifica o Pedido de Compra a ser liberado
	dbSelectArea("SCR")
	dbSetOrder(2)                                  
	SCR->(dbgotop())               
	if dbSeek(xFilial()+'PC'+SC7->C7_NUM+space(TamSX3( "CR_NUM" )[1]-len(SC7->C7_NUM))+SAK->AK_USER)
	   conout("5/6)---------------> Ok! Iniciado Processo de Liberacao")
	   nRec := RecNo()
	else
	   conout("5/6)---------------> Nao Ok! Falha no inicio do Processo de Liberacao")
	   lSCR := .F.
	endif                                     

	if lSAK .AND. lSC7 .AND. lSA2 .AND. lSAL .AND. lSCR 
	  lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,nTotal,cAprovcd,,SAL->AL_COD,,,,,cObs},dDataBase,4)
	  if lLiberou
	    dbSelectArea("SC7")
	    dbSetOrder(1)   
	    SC7->(dbgotop())
	      
	    dbSeek(xFilial()+cPedido)
	    while SC7->C7_FILIAL == xFilial() .AND. SC7->C7_NUM == cPedido
        RecLock("SC7",.F.)
        SC7->C7_CONAPRO := 'L'
        SC7->( MsUnLock ( ) )
				SC7->(DBSkip())
	    Enddo                                                            
	      
	    conout("¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦")
	    conout("¦¦           LIBERAÇÃO REALIZADA COM SUCESSO!                 ¦¦")
	    conout("¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦")
	    /* Rafael - 04/01/2011
	    SndMAprov(xFilial("SC7"), cPedido)
	    */
	  else
	    conout("¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦")
	    conout("¦¦           FALHA NA LIBERAÇÃO - PASSO 2 !                   ¦¦")
	    conout("¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦")
	  endif
	else
	  conout("¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦")
	  conout("¦¦           FALHA NA LIBERAÇÃO - PASSO 1 !                   ¦¦")
	  conout("¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦")
	endif
else
   conout("¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦")
   conout("¦¦                LIBERAÇÃO NÃO AUTORIZADA!                   ¦¦")
   conout("¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦")
   conout("Libera = " + cLibera)
endif                               

conout("Finalizado o processo de liberação do pedido de compra.")
oProcess:Finish()
Return lRetorno

/*********************************************************/
// Função responsável por enviar email informando da aprovação do pedido para o usuario que o fez
/*********************************************************/
static function SndMAprov(cFil, cPed)
Local aArea := GetArea()
Local cUsuario, cEmail
Local oProcess, oHtml, cProcess, cStatus

SC7->(DBSetOrder(1))
SC7->(DBSeek(cFil + cPed))
cUsuario := SC7->C7_USER
cEmail := getEmail(cUsuario)

if (AllTrim(cEmail) <> "")
	//Inicia processo de envio do e-mail
	cProcess := OemToAnsi("001010") // Numero do Processo
	cStatus  := OemToAnsi("001011")
	
	oProcess := TWFProcess():New(cProcess,OemToAnsi("Retorno de aprovação de Pedido"))
	oProcess:NewTask(cStatus,"\workflow\wfRetAprovPed.html")
	oProcess:cSubject := OemToAnsi("Aprovação do Pedido " + cPed)

	oProcess:cTo := ALLTRIM(cEmail)
		
	oProcess:oHTML:ValByName("NUMPED", cPed)
	
	oProcess:Start()
EndIf	

RestArea(aArea)

Return Nil

//////////
static function getEmail(pcUser)
	local cArea := getArea()
	local cRet  := ''
	PswOrder(1)
	//
	if PswSeek(pcUser,.t.)
		cRet := PswRet(1)[1,14]
	endif
	restarea(cArea)
return(cRet)
//