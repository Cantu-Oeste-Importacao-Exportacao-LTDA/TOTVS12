#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/***************************************************
 Função que envia dados de carga para o rastreador da inlog.
 Monta a estrutura através do webservice e envia os dados.
 ***************************************************/
User Function CargaInlog() 
Local oDlg1
Local cCadastro := "Enviar Carga "
Local oTPanel2
Local oGet
Local cCarga := CriaVar("DAK_COD")
Local lCont := .F.
Local oGet2
Local cMemo

Private cResult := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

DEFINE MSDIALOG oDlg1 TITLE cCadastro From 8,0 To 250, 400 OF oMainWnd COLORS 0, 16777215 PIXEL

		oTPanel2 := TPanel():New(0,0,"",oDlg1,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
		oTPanel2:Align := CONTROL_ALIGN_ALLCLIENT
		                     
		@15, 05 Say "Carga: " size 40, 10  OF oTPanel2 COLORS 0, 16777215 PIXEL
		
		@14, 60 MSGET oGet Var cCarga Valid (!Empty(cCarga)) F3 "DAK" Size 40, 10  OF oTPanel2 COLORS 0, 16777215 PIXEL
		
		@30, 05 Say "Erros: " OF oTPanel2 COLORS 0, 16777215 PIXEL
		
		@38, 05 Get oGet2 var cResult MULTILINE Size 150, 70  OF oTPanel2 COLORS 0, 16777215 PIXEL
		
/*	@40, 200 BUTTON "Vigencia"
		@60, 200 BUTTON "Controle"
		@80, 200 BUTTON "Controle"*/
				
	ACTIVATE MSDIALOG oDlg1 CENTER ON INIT ;
	EnchoiceBar(oDlg1,{|| SendCarga(cCarga)}, {|| oDlg1:End() })
Return Nil

Static Function SendCarga(cCarga)
Local oWS := WSWSColetor():New()
Local lEnviado
Local cSql := ""

//Verifica se existe os mesmo dados na tabela - Dioni 19/10
 DbSelectArea("ZZX") 
 DBSetOrder(1) 
 lEnviado:= dbSeek(xFilial("ZZX") + cCarga)
 if lEnviado 
	 Alert("Esses Dados já foram enviados.")
	 Return nil
 EndIf     

cSql := " SELECT DAK_CAMINH, DAK_MOTORI, DAI_SEQUEN, DAI_CLIENT, DAI_LOJA, A1.R_E_C_N_O_ AS A1RNO, A1_NOME,  DAI_DTCHEG, DAI_CHEGAD "
cSql += " FROM " + RetSqlName("DAK")+ " DAK "
cSql += " LEFT JOIN " + RetSqlName("DAI")+ " DAI ON DAK_COD = DAI_COD AND DAK_FILIAL = DAI_FILIAL "
cSql += " LEFT JOIN " + RetSqlName("SA1")+ " A1 ON A1_COD = DAI_CLIENT AND A1_LOJA = DAI_LOJA "
cSql += " WHERE DAK_FEZNF = '1' "
cSql += " AND DAK_FILIAL = '"+xFilial("DAK")+"' "   
cSql += " AND DAK_COD = '" + cCarga + "'"
cSql += " AND A1.D_E_L_E_T_ <> '*' AND DAK.D_E_L_E_T_ <> '*' AND DAI.D_E_L_E_T_ <> '*' "
cSql += " ORDER BY DAI_SEQUEN "

//MemoWrite("c:\sql_rec.txt",cSql)

tcQuery cSql Alias "TMPCRG"
If TMPCRG->(Eof())  
   TMPCRG->(dbCloseArea())
	Return .F.
EndIf

cSql := ""
cSql := "SELECT MAX(ZZX_SEQUEN) as ZZX_SEQUEN FROM " + RetSqlName("ZZX")
TCQUERY cSql NEW ALIAS "TMPXSEQUEN" 

oLote := oWS:oWSLote // Lote de Envio
oLote:oWSTabelas := WSColetor_ListaTabelas():New() // Lista de tabelas

// Controles do lote
oLote:cVigenciaDe := dDataBase
oLote:cVigenciaAte := dDataBase + 2
oLote:nLote := TMPXSEQUEN->ZZX_SEQUEN +1  //Pega o ultimo no banco e soma mais um
oLote:cstatus:= "I"

oTables := oLote:oWSTabelas
// Cria as tabelas a enviar
// Cria a tabela de MAPA_CARGA
oTabela := WSColetor_ipTabela():New()
oTabela:nidentificador := 100 //  Mapa Carga
oTabela:nidentificadorOperacao := 461
oTabela:oWScampos := WSColetor_ListaCampos():New()
oACampos := oTabela:oWScampos:oWSipCampo // array de campos
oCampo := WSColetor_ipCampo():New()

//Campo Carga
oCampo:nsequencia := 1 
oCampo:cvalor := cCarga
aAdd(oACampos, oCampo:Clone()) //oCampo)
	
// Campo Veiculo
oCampo:nsequencia := 2 
oCampo:cvalor := TMPCRG->DAK_CAMINH                                     
aAdd(oACampos, oCampo:Clone()) //oCampo)

// Campo Motorista
oCampo:nsequencia := 3  
oCampo:cvalor := TMPCRG->DAK_MOTORI
aAdd(oACampos, oCampo:Clone())

// Adiciona a tabela
aAdd(oTables:oWSipTabela, oTabela:clone())

//Dioni - Grava na tabela ZZX
 DbSelectArea("ZZX") 
 	 RecLock("ZZX", .T.)
   ZZX->ZZX_FILIAL := xFilial("ZZX")
   ZZX->ZZX_IDENTI := 100 
   ZZX->ZZX_IDEOPE := 461
   ZZX->ZZX_SEQUEN := TMPXSEQUEN->ZZX_SEQUEN +1
   ZZX->ZZX_CARGA  := cCarga  
   ZZX->ZZX_VEICUL := TMPCRG->DAK_CAMINH
   ZZX->ZZX_MOTORI := TMPCRG->DAK_MOTORI
   ZZX->ZZX_STATUS := "I"
   
   ZZX->(MsUnlock())    
                      
while TMPCRG->(!Eof())

cSql := ""
cSql := "SELECT MAX(ZA3_SEQUEN) as ZA3_SEQUEN FROM " + RetSqlName("ZA3")
TCQUERY cSql NEW ALIAS "TMPZSEQUEN" 

	// Cria a tabela de MAPA_CARGA_CLIENTES
	oTabela := WSColetor_ipTabela():New()
	oTabela:nidentificador := 101 //  Mapa Carga Clientes
	oTabela:nidentificadorOperacao := 461

	oTabela:oWScampos := WSColetor_ListaCampos():New()
	oACampos := oTabela:oWScampos:oWSipCampo // array de campos
	oCampo := WSColetor_ipCampo():New()

	// Campo Carga
	oCampo:nsequencia := 1 
	oCampo:cvalor := cCarga
	aAdd(oACampos, oCampo:Clone())
	
	// Campo Sequencia
	oCampo:nsequencia := 2 
	oCampo:cvalor :=  cValToChar(TMPZSEQUEN->ZA3_SEQUEN +1)
	aAdd(oACampos, oCampo:Clone())
	
	// Campo CLIENTE_CHAVE
	oCampo:nsequencia := 3 
	oCampo:cvalor := Str(TMPCRG->A1RNO)
	aAdd(oACampos, oCampo:Clone())
	
	// Campo CLIENTE_DESC
	oCampo:nsequencia := 4 
	oCampo:cvalor := TMPCRG->A1_NOME
	aAdd(oACampos, oCampo:Clone())
	
	// Campo DATAHORA_ENTREGA
	oCampo:nsequencia := 5 
	oCampo:cvalor := DtoC(StoD(TMPCRG->DAI_DTCHEG)) + " " + TMPCRG->DAI_CHEGAD
	aAdd(oACampos, oCampo:Clone()) 
	
	// Campo latitude
	oCampo:nsequencia := 6 
	oCampo:cvalor := ''    //enviado 'vazio' pq tm q passar algo para o integrador
	aAdd(oACampos, oCampo:Clone())
	
	// Campo Longitude
	oCampo:nsequencia := 7 
	oCampo:cvalor := ''   //enviado 'vazio' pq tm q passar algo para o integrador
	aAdd(oACampos, oCampo:Clone())
	
	// Adiciona a tabela
	aAdd(oTables:oWSipTabela, oTabela:clone())
	
 //Dioni - Grava na tabela ZA3
  DbSelectArea("ZA3") 
 	 RecLock("ZA3", .T.)
 	 ZA3->ZA3_FILIAL := xFilial("ZA3")
   ZA3->ZA3_IDENTI := 101
   ZA3->ZA3_IDENOP := 461
   ZA3->ZA3_CARGA  := cCarga  
   ZA3->ZA3_SEQUEN := TMPZSEQUEN->ZA3_SEQUEN +1
   ZA3->ZA3_CLICHA := cValToChar(TMPCRG->A1RNO)
   ZA3->ZA3_CLIDES := TMPCRG->A1_NOME 
   ZA3->ZA3_DATENT := DtoC(StoD(TMPCRG->DAI_DTCHEG)) + " " + TMPCRG->DAI_CHEGAD   

   ZA3->(MsUnlock()) 

  TMPZSEQUEN->(dbCloseArea()) 
  
	TMPCRG->(dbSkip())
EndDo
	TMPCRG->(dbCloseArea())
	TMPXSEQUEN->(dbCloseArea())
cResul := "" 

//alert(oLote:SoapSend())
if (oWS:EnviarDados(oLote)) 
    oResult := oWS:oWSResult  
    For nX := 1 to len(oResult:cstring)
        cResul += oResult:cstring[nx] + chr(13) + chr(10)
    Next nX
    if len(oResult:cstring) > 0
        Return .F.
    else 
       Aviso("Conectando...","Dados enviados com sucesso!",{"OK"},2)   
       Return .T.  
    EndIf 
Else 
    Aviso("Mensagem",GetWscError(),{"Ok"},3) // acrescentado, caso algum erro aconteça, informa na tela.
Endif
 
Return    
                     

//////////////////////////////////////////////////////////////////////////////////////////////////////
// Dioni - funçao para exclusão
/***********************************************
 Função que exclui dados da carga  do rastreador da inlog.
 Monta a estrutura através do webservice e exclui os dados.
 ***********************************************/   
////////////////////////////////////////////////////////////////////////////////////////////////////// 
User Function DelCargaInlog()
Local oDlg1
Local cCadastro := "Exclui Carga - Teste"
Local oTPanel2
Local oGet
Local cCarga := CriaVar("ZA3_CARGA")
Local lCont := .F.
Local oGet2
Local cMemo 

Private cResult := ""            

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

DEFINE MSDIALOG oDlg1 TITLE cCadastro From 8,0 To 250, 400 OF oMainWnd COLORS 0, 16777215 PIXEL

		oTPanel2 := TPanel():New(0,0,"",oDlg1,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
		oTPanel2:Align := CONTROL_ALIGN_ALLCLIENT
		                     
		@15, 05 Say "Carga: " size 40, 10  OF oTPanel2 COLORS 0, 16777215 PIXEL
		
		@14, 60 MSGET oGet Var cCarga Valid (!Empty(cCarga)) F3 "ZZX" Size 40, 10  OF oTPanel2 COLORS 0, 16777215 PIXEL
		
		@30, 05 Say "Erros: " OF oTPanel2 COLORS 0, 16777215 PIXEL
		
		@38, 05 Get oGet2 var cResult MULTILINE Size 150, 70  OF oTPanel2 COLORS 0, 16777215 PIXEL
		
/*	@40, 200 BUTTON "Vigencia"
		@60, 200 BUTTON "Controle"
		@80, 200 BUTTON "Controle"*/
				
	ACTIVATE MSDIALOG oDlg1 CENTER ON INIT ;
	EnchoiceBar(oDlg1,{|| SendCarga2(cCarga)}, {|| oDlg1:End() })
Return Nil

Static Function SendCarga2(cCarga)
Local oWS := WSWSColetor():New() 
Local cSql := ""

cSql := ""
cSql := " SELECT X.ZZX_SEQUEN FROM " + RetSqlName("ZZX")+ " X"
cSql += " WHERE X.ZZX_FILIAL = '"+xFilial("ZZX")+"' "
cSql += " AND X.ZZX_CARGA = '" + cCarga + "'"
cSql += " AND D_E_L_E_T_ <> '*' "  

//MemoWrite("c:\sql_DelZA3.txt",cSql)
tcQuery cSql Alias "TMPZZX"
If TMPZZX->(Eof())
	Return .F.
EndIf 
 
if (oWS:ExcluirRegistro(TMPZZX->ZZX_SEQUEN,'100',"",''))
	oResult := oWS:lResult 
	For nX := 1 to len(oResult:cstring)
		cResul += 	oResult:cstring[nx] + chr(13) + chr(10)
	Next nX
	if len(oResult:cstring) > 0
		Return .F.
	else
		Return .T.
	EndIf
EndIf 
 
cSql := ""
cSql := " SELECT Z.ZA3_SEQUEN,Z.ZA3_IDENTI,Z.ZA3_IDENOP,Z.ZA3_CLIDES FROM " + RetSqlName("ZA3")+ " Z"
cSql += " WHERE Z.ZA3_FILIAL = '"+xFilial("ZA3")+"' "
cSql += " AND Z.ZA3_CARGA = '" + cCarga + "'"
cSql += " AND D_E_L_E_T_ <> '*' "  

//MemoWrite("c:\sql_DelZA3.txt",cSql)
tcQuery cSql Alias "TMPZA3"
If TMPZA3->(Eof())
	Return .F.
EndIf   

while TMPZA3->(!Eof())
	
//Dioni 21/10/11
if (oWS:ExcluirRegistro(TMPZA3->ZA3_SEQUEN,'101','',''))
	oResult := oWS:lResult 
	For nX := 1 to len(oResult:cstring)
		cResul += 	oResult:cstring[nx] + chr(13) + chr(10)
	Next nX
	if len(oResult:cstring) > 0
		Return .F.
	else
		Return .T.
	EndIf
EndIf 
  
	//Deleta campos da tabela ZA3
	dbSelectArea("ZA3")
  ZA3->(DbSetOrder(1))
  If ZA3->(dbSeek(xFilial("ZA3") + cCarga))
     RecLock("ZA3",.F.)
     ZA3->(dbDelete())
     ZA3->(MsUnLock())
  Endif
	
 TMPZA3->(dbSkip())
EndDo
          
//Deleta Registro da Nossa tabela ZZX
dbSelectArea("ZZX")
  ZZX->(DbSetOrder(1))
  If ZZX->(dbSeek(xFilial("ZZX") + cCarga))
     RecLock("ZZX",.F.)
     ZZX->(dbDelete())
     ZZX->(MsUnLock())
  Endif
                 		
cResul := "" 

Return   


//funçao de para fazer busca dos registros jah existentes
////////////////////////////////////////////////////////////////////////
// Dioni - funçao para buscar valores dos campos no WebService
/***********************************************
 Função que busca dados do rastreador da inlog.
 Monta a estrutura através do webservice e busca os dados já existentes.
 ***********************************************/                       
///////////////////////////////////////////////////////////////////////
#INCLUDE 'PROTHEUS.CH'
 
User Function BuscaWs()
 
Local oWs := NIL
 
oWs := WSWSColetor():New()       

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If oWs:buscaValoresCampoTabela()
   alert(oWs:oWSResult)

 Else 
   alert('Erro de Execução : '+GetWSCError())
 
Endif  
 
Return
                        
//Busca de lote de envio
User Function BusLotContWs()
oWs := nil 
oWs := WSWSColetor():New()
oLote := oWs:nLote               

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If oWs:BuscarLoteControle(oLote)
  // alert(oLote:SoapSend())
   alert(oWs:oWSResult)
    
Else 
  alert('Erro de Execução : '+GetWSCError())
 
Endif  
  
Return