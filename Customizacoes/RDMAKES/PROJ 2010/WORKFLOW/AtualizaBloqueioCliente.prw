#include "rwmake.ch"
#include "topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ATUALIZABLOQUEIOCLIENTEºAutor ³Microsiga Data ³  25/02/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Função que faz o bloqueio de cliente automaticamente pelo º±±
±± workflow, rodando o mesmo para todas as empresas e filiais.			  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Bloqueio para Agroindustrial³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  

User Function WFBlCl01()
Local aEmpr := {"01","01"}
Local lAuto := .T.

StartJob("U_AtuBlCli",GetEnvServer(), .T.,aEmpr, lAuto)

Return Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Bloqueio para Agroindustrial³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  

User Function WFBlCl02()
Local aEmpr := {"02","01"}
Local lAuto := .T.

StartJob("U_AtuBlCli",GetEnvServer(), .T.,aEmpr, lAuto)

Return Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Bloqueio para Importadora³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function WFBlCl03()
Local aEmpr := {"03","01"}
Local lAuto := .T.

StartJob("U_AtuBlCli",GetEnvServer(), .T.,aEmpr, lAuto)

Return Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Bloqueio para Agroindustrial³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  

User Function WFBlCl04()
Local aEmpr := {"04","01"}
Local lAuto := .T.

StartJob("U_AtuBlCli",GetEnvServer(), .T.,aEmpr, lAuto)

Return Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³   Bloqueio para Granja      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  

User Function WFBlCl06()
Local aEmpr := {"06","01"}
Local lAuto := .T.

StartJob("U_AtuBlCli",GetEnvServer(), .T.,aEmpr, lAuto)

Return Nil

/////////////////////////////////////

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Bloqueio para Perterson cantu³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  

User Function WFBlCl07()
Local aEmpr := {"07","02"}
Local lAuto := .T.

StartJob("U_AtuBlCli",GetEnvServer(), .T.,aEmpr, lAuto)

Return Nil


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Bloqueio para Chapecó³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User Function WFBlCl10()
Local aEmpr := {"10","01"}
Local lAuto := .T.

StartJob("U_AtuBlCli",GetEnvServer(), .T.,aEmpr, lAuto)

Return Nil


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Bloqueio para Cantu Oeste³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

User Function WFBlCl40()
Local aEmpr := {"40","01"}
Local lAuto := .T.

StartJob("U_AtuBlCli",GetEnvServer(), .T.,aEmpr, lAuto)

Return Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Bloqueio para Cantu Oeste³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

User Function WFBlCl41()
Local aEmpr := {"41","01"}
Local lAuto := .T.

StartJob("U_AtuBlCli",GetEnvServer(), .T.,aEmpr, lAuto)

Return Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Bloqueio para Cantu Oeste³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

User Function WFBlCl42()
Local aEmpr := {"42","01"}
Local lAuto := .T.

StartJob("U_AtuBlCli",GetEnvServer(), .T.,aEmpr, lAuto)

Return Nil
 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Bloqueio para Cantu Oeste³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

User Function WFBlCl43()
Local aEmpr := {"43","01"}
Local lAuto := .T.

StartJob("U_AtuBlCli",GetEnvServer(), .T.,aEmpr, lAuto)

Return Nil 
 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que desbloqueia todos os clientes e                                                           ³
//³ também vare todas as duplicatas em atraso e bloqueia os clientes que estiverem com títulos em atraso³
//³ em função de ser compartilhado entre as filiais                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User function AtuBlCli(aEmpr, lAuto)
Local lBloq := .F.
Local cQuery
Local cAliasSE1 := GetNextAlias()
Local cFil := ""
Local cCliente := ""
Local cLoja := ""
Local oProcess
Local oHtml
Local cPerg := "BLQCLI"


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³se for U é porque não foi passado parâmetro³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

if ValType(lAuto) == "U"
  lAuto := .F.
EndIf

if ValType(aEmpr) == "U"
	aEmpr := {"40","01"}
EndIf

if (lAuto)
	
	RpcClearEnv()
	RPCSetType(3) 
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Colocado fixo para que o sistema acesse a empresa 40, pois dentro dela serão selecionados dados de todas as demais.
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	
	PREPARE ENVIRONMENT EMPRESA aEmpr[01] FILIAL aEmpr[02] MODULO "FIN" TABLES "SA1","SE1"
	
	//--Criação de arquivo temporário sobre a execução da rotina, devido a execução N vezes pelo schedule decorrente das threads
	nLock := 0
	While !LockByName("ATUBLCLI",.T.,.F.,.T.)
		nLock += 1
		Sleep(1000)                                    	
		If nLock > 200                                 
			ConOut("CONTROLE DE SEMÁFORO - Rotina finalizada pois já esta sendo executada!")
			Return
		EndIf		
	EndDo
	
	ConOut("EMPRESA: " + cEmpAnt)
	
	MV_PAR01 := "01"
	MV_PAR02 := "98" 
	MV_PAR03 := 1
EndIf

Private nRiscoB
Private nRiscoC
Private nRiscoD
Private nTipoCH 

nRiscoB := GetMV("MV_RISCOB")
nRiscoC := GetMV("MV_RISCOC")
nRiscoD := GetMV("MV_RISCOD")    

nTipoCH := 2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ajusta os SX1³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

AjustaPerg()
if !lAuto
	if !Pergunte(cPerg)
		Return
	EndIf
EndIf

ConOut("INÍCIO DO PROCESSO DE BLOQUEIO/LIBERAÇÃO DE CLIENTES.")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Libera todos os clientes que estão bloqueados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ConOut("Tabela SA1: " + RetSqlName("SA1"))
cQuery := "Update " + RetSqlName("SA1") + " SET A1_MSBLQL = '2', a1_msblqd =' ', A1_X_DTALT = '"
cQuery += dToS(dDataBase) + "' WHERE A1_MSBLQL = '1' and d_e_l_e_t_ = ' ' and a1_risco in ('B', 'D') and "
cQuery += " a1_msblqd < '" + DtoS(dDataBase) + "' "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valida se libera todos os clientes³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

if ((MV_PAR03 == 1) .Or. lAuto)
	TCSQLExec(cQuery)
	ConOut("LIBERADO TODOS OS CLIENTES.")
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³varre as duplicatas para bloquear os clientes em atraso³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SA1->(DbSetOrder(01))

ConOut("BUSCANDO CLIENTES COM DUPLICATA EM ATRASO...")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³faz a consulta buscando os clientes e as duplicatas que estão em atraso³
//³alterado para fazer a manutencao apenas nos clientes do risco B e D    ³ 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


  BeginSql Alias cAliasSE1 
  	select a1_filial, e1_cliente, e1_loja, e1_emissao, e1_vencrea, e1_valor, e1_saldo, a1_risco, e1_filial,; 
		e1_prefixo, e1_parcela, e1_num, e1_tipo
			from %table:SE1% se1	
			inner join %table:SA1% sa1 on e1_cliente = a1_cod and a1_loja = e1_loja
			where e1_saldo > 0
			and e1_vencrea < %Exp:DToS(Date())%
			and sa1.d_e_l_e_t_ = ' '
			and se1.d_e_l_e_t_ = ' '
			and a1_risco in ("B", "D")
			and e1_tipo in ("FT", "NF", "DP", "CH", "FI") 
			and e1_filial >= %Exp:mv_par01%
			and e1_filial <= %Exp:mv_par02%
			order by e1_cliente, e1_loja, e1_filial, e1_vencrea 
		   
EndSql	             


ConOut("INICIANDO BLOQUEIO...")

oProcess := TWFProcess():New( "ATUBLCLI", "Bloqueio de Clientes")
oProcess:NewTask( "ATUBLCLI", "\workflow\atublcli.html" )
oProcess:cSubject := "Lista de cliente bloqueados em " + DTOC(DDATABASE) + " - Empresa - " + SM0->M0_NOME
								
oHTML := oProcess:oHTML

dbSelectArea(cAliasSE1)
(cAliasSE1)->(DbGoTop())
While .T. 
	
	if (cAliasSE1)->E1_Cliente != cCliente .Or. (cAliasSE1)->E1_Loja != cLoja .Or. cFil != (cAliasSE1)->E1_Filial	  
    
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³atualiza após calcular os dados para o cliente³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
    if ((cAliasSE1)->E1_Cliente != cCliente .Or. (cAliasSE1)->E1_Loja != cLoja) ;
    		.And. !Empty(cCliente) 
    
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄŒ
			//³Localiza cliente anterior³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄŒ
			
	    if lBloq .And. SA1->(DbSeek(xFilial("SA1") + cCliente))   
	      While (SA1->A1_Filial = xFilial("SA1") .And. SA1->A1_COD = cCliente)
		      RecLock("SA1")
		      SA1->A1_MsBlQl := "1"  
		      SA1->A1_MSBLQD := dDataBase
		      SA1->A1_X_DTALT := dDataBase
		      SA1->(MsUnlock())
		      ConOut("BLOQUEANDO CADASTRO " + cCliente + "/" + SA1->A1_Loja)
		      SA1->(DbSkip())
	      EndDo
	    EndIf
	    lBloq := .F.
    EndIf
    
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³valida o bloqueio do cliente        ³
		//se já está bloqueado, nao avalia mais³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		
    if !(cAliassE1)->(Eof()) .And. !lBloq 
	    lBloq := lBloq .Or. CalcDiasAtr(Date() - SToD((cAliasSE1)->E1_VencRea), (cAliasSE1)->A1_Risco, (cAliasSE1)->e1_tipo, (cAliasSE1)->E1_Filial)
	    
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ&da¿
			//³Se bloqueou, adiciona no email o título que bloqueou³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ&daÙ
			
	    if (lBloq) 
	      AAdd((oHtml:ValByName( "IT.CODIGO" )), (cAliasSE1)->E1_Cliente + "/" +  (cAliasSE1)->E1_Loja)
	      AAdd((oHtml:ValByName( "IT.CLIENTE" )), Posicione("SA1", 01, (cAliasSE1)->A1_Filial + (cAliasSE1)->E1_Cliente, "A1_NOME"))
	      AAdd((oHtml:ValByName( "IT.FILIAL" )), (cAliasSE1)->E1_Filial)
	      AAdd((oHtml:ValByName( "IT.TITULO" )), (cAliasSE1)->E1_PREFIXO + "-" +  ;
              (cAliasSE1)->E1_Num + iif(!Empty((cAliasSE1)->E1_Parcela), "/" + (cAliasSE1)->E1_Parcela, ""))
	      AAdd((oHtml:ValByName( "IT.EMISSAO" )), DToC(SToD((cAliasSE1)->E1_Emissao)))
	      AAdd((oHtml:ValByName( "IT.VENCTO" )), DToC(SToD((cAliasSE1)->E1_VencRea)))	      
	      AAdd((oHtml:ValByName( "IT.VALOR" )), AllTrim(Transform((cAliasSE1)->E1_Valor, "@E 999,999.99")))
	      AAdd((oHtml:ValByName( "IT.SALDO" )), AllTrim(Transform((cAliasSE1)->E1_Saldo, "@E 999,999.99")))
	    EndIf
	  EndIf
  EndIf
  
	cCliente := (cAliasSE1)->E1_Cliente
	cLoja := (cAliasSE1)->E1_Loja
	cFil := (cAliasSE1)->E1_Filial
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³se chegou ao final sai do laço³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	
	if (cAliassE1)->(Eof())
	  Exit
	EndIf
	
	(cAliasSE1)->(DbSkip())
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³envia o email com a lista de clientes bloqueados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

oProcess:cTo  := AllTrim(SuperGetMV("MV_MAILCLI", .F., , '01'))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Recebe uma cópia do e-mail para acompanhamento³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

oProcess:cCC  := "suporte.microsiga@cantu.com.br" 
oProcess:cBCC := ""
oProcess:Start()
oProcess:Finish()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³fecha o arquivo de dados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

(cAliasSE1)->(DbCloseArea())
ConOut("FIM DO PROCESSO DE BLOQUEIO/LIBERAÇÃO.")

Return Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calcula os dias em atraso conforme o atraso e risco passados por parametro³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function CalcDiasAtr(nAtraso, cRisco, cTipo, cFil)
Local lBloq := .F.
Local cNomeVar

if Empty(cRisco)
  cRisco := "E"
EndIf

cNomeVar := "nRisco" + cRisco

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³altera o conteúdo da variável que será utilizada    ³
//³para os riscos A e E nao existe parametro cadastrado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

if !(cRisco $ "A/E")
  
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄT¿
	//³tem que obeter o valor de acordo com a filial,                          ³
	//³  devido a ser tratado de forma diferente o risco do cliente, por filial³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄTÙ
	
  &cNomeVar := SuperGetMV("MV_RISCO" + cRisco, .F., , cFil)
  
EndIf

Do Case
  Case (nAtraso > nTipoCH) .and. Trim(cTipo) == "CH"
  	lBloq := .T.
  Case cRisco == "B"
    lBloq := (nAtraso > nRiscoB) .and. Trim(cTipo) != "CH"
  Case cRisco == "C"
    lBloq := (nAtraso > nRiscoC) .and. Trim(cTipo) != "CH"
  Case cRisco == "D"
    lBloq := (nAtraso > nRiscoD) .and. Trim(cTipo) != "CH"
  Case cRisco == "E"
    lBloq := (nAtraso >= 1) .and. Trim(cTipo) != "CH"
  Otherwise 
    lBloq := .F.
EndCase        

Return lBloq 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Função que faz o ajuste das perguntas do SX1³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Static Function AjustaPerg()
cPerg := PadR("BLQCLI", Len(SX1->X1_GRUPO))
PutSx1(cPerg,"01","Da filial?"           ,"Da filial?"           ,"Da filial?"           , "mv_fin", "C", 2, 0, , "G", "", "", "", "","MV_PAR01")
PutSx1(cPerg,"02","Até filial?"          ,"Até filial?"          ,"Até filial?"          , "mv_fin", "C", 2, 0, , "G", "", "", "", "","MV_PAR02")
PutSx1(cPerg,"03","Desbloquear Clientes?","Desbloquear Clientes?","Desbloquear Clientes?", "mv_dcl", "N", 1, 0, 0,"C", "", "", "", "","MV_PAR03","Sim","Si","Yes", "","Nao","No","No", "", "", "", "", "", "", "", "", "", "", "", "", "")
Return Nil