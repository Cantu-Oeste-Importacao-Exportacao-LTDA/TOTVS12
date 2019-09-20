#include "rwmake.ch" 
#include "protheus.ch"
#include "topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

#DEFINE dDATAB2B	(Date() - 182)	///--- 6 meses

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BLQCLISCHED �Autor  �Jean              � Data �  23/11/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Chamada do Bloqueio de Clientes executado atrav�s de       ���
���          � schedule                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function BlCliSched()
	//�����������������������������������������������������
	//�Chama fun��o para monitor uso de fontes customizados�
	//�����������������������������������������������������
   //	|(ProcName(),FunName())
	
	U_BlqCliFin(.T.)
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BLQCADCLIENTE_DATA�Autor  �Jean        � Data �  07/04/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Bloqueio de Clientes inativos por mais de x dias           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Financeiro                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function BlqCliFin(lSchedule)

Local aEmpr       := {"40","01"}
Static oDlg       

Private cSql      := ""
Private cEmp      := "" 
Private cCliIni   := Space(9)
Private cCliFin   := Replicate("9",09)
Private cMsg      := ""
Private cEol      := CHR(13)+CHR(10)
Private cLbRotina := " Este programa vai bloquear os clientes que n�o compraram a partir da "+;
									   " data especificada abaixo, alterando tamb�m o risco para E."
									 
Private nQuant    := 0
									 
Private lCont     := iif(ValType(lSchedule)!="L", .F., lSchedule)
Private lCancela  := .F.
Private lJob      := iif(ValType(lSchedule)!="L", .F., lSchedule)
                                   
Private dDataBloq := (Date() - 90)
Private dDataCad  := (Date() - 90)

Private aEmp      := {}

Private oDataBloq, oDataCad, oCliIni, oCliFin
Private oSay1, oSay2, oSay3, oSay4, oSay5
Private oLbRotina 

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
//U_USORWMAKE(ProcName(),FunName())

if lJob
	RpcClearEnv()
	RPCSetType(3) 
		
	//��������������������������������������������������������������������������������������������������������������������
	//�Colocado fixo para que o sistema acesse a empresa 50, pois dentro dela ser�o selecionados dados de todas as demais.
	//��������������������������������������������������������������������������������������������������������������������
	
	PREPARE ENVIRONMENT EMPRESA aEmpr[01] FILIAL aEmpr[02] MODULO "FAT" TABLES "SA1","SA3","SE1"
	
EndIf

//��������������������������������������������������������������������
//�Se n�o for execu��o atrav�s de Job, monta interface para o usu�rio.
//��������������������������������������������������������������������

if !lJob

	DEFINE MSDIALOG oDlg TITLE "BLOQUEIO DE CLIENTES POR DATA DE COMPRA" FROM 000, 000 TO 225, 480 COLORS 0, 16777215 PIXEL
	
	@ 10,015 GET oLbRotina VAR cLbRotina WHEN .F. OF oDlg MULTILINE SIZE 210, 20 COLORS 0, 16777215 HSCROLL PIXEL
	
	@ 37,015 SAY oSay1 PROMPT "Data de ultima compra: " SIZE 062, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 35,100 MSGET oDataBloq VAR dDataBloq SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
	
	@ 52,015 SAY oSay5 PROMPT "Data de cadastramento: " SIZE 062, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 50,100 MSGET oDataCad VAR dDataCad SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL

	@ 67,015 SAY oSay2 PROMPT " Cliente de : " SIZE 062, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 65,100 MSGET oCliIni VAR cCliIni SIZE 060, 010 OF oDlg F3 "SA1" COLORS 0, 16777215 PIXEL
	
	@ 82,015 SAY oSay3 PROMPT " Cliente at�: " SIZE 062, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 80,100 MSGET oCliFin VAR cCliFin SIZE 060, 010 OF oDlg F3 "SA1" COLORS 0, 16777215 PIXEL
	
	@ 98,100 BMPBUTTON TYPE 01 ACTION (lCont := .T., Close(oDlg))
	@ 98,130 BMPBUTTON TYPE 02 ACTION (lCancela := .T., Close(oDlg))
	
	ACTIVATE DIALOG oDlg CENTERED
	
Else
	Conout("IN�CIO DA ROTINA DE BLOQUEIO DE CLIENTES POR DATA DE COMPRA")	
EndIf

if lCancela
	Return(nil)
EndIf 

if lCont
	if !lJob
		MsAguarde({|lEnd| AltCliFin(@lEnd) }, "Aguarde...","Analisando Informa��es de Faturamento x Cliente...", .T.)
	Else
		Conout("Analisando informa��es de Faturamento x Cliente...")
		AltCliFin()
	EndIf                                         
EndIf

if !lJob
	Aviso("Processo finalizado...",cMsg,{"Sair"},3)
Else
	Conout("Log execu��o: "+cMsg)
	Conout("Processo finalizado...")
EndIf

Return(nil)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ALTCLIFIN �Autor  �Jean                � Data �  20/11/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Busca informa��es faturamento x cliente e faz altera��es   ���
���          � no cadastro.                                               ���
�������������������������������������������������������������������������͹��
���Uso       � Financeiro                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function AltCliFin(lEnd)
Local cCliIniTmp := cCliIni
Local cCliFinTmp := cCliFin
Local cEmail     := ""

//��������������������������������������������������������������������������������������Ŀ
//�Guarda posicionamento na tabela de empresas para depois devolver no final da execu��o.�
//����������������������������������������������������������������������������������������

DbSelectArea("SM0")
aArea := GetArea("SM0")
SM0->(DbGotop())

//�����������������������������������������������������������������������������������Ŀ
//�Percorre todo o cadastro de empresas buscando pelos diferentes c�digos cadastrados.�
//�������������������������������������������������������������������������������������

While !SM0->(Eof())
  if SM0->M0_CODIGO <> cEmp
  	aAdd(aEmp,SM0->M0_CODIGO)
  EndIf
  cEmp := SM0->M0_CODIGO
  SM0->(DbSkip())
End

//�������������������������������������������������������Ŀ
//�Busca pelos e-mails cadastrados no par�metro MV_BLQCLIF�
//���������������������������������������������������������

cEmail := SuperGetMv("MV_BLQCLIF",,"suporte.microsiga@grupocantu.com.br")

lContinua := .T.

While lContinua

	//�������������������������������������������������������������������������Ŀ
	//�Inicia a montagem do workflow criando um novo objeto do tipo TWFProcess()�
	//���������������������������������������������������������������������������
		
  	oProcess := TWFProcess():New( "WFBLQCLIFIN", "BLOQUEIO DE CLIENTES DATA COMPRA")
	oProcess:NewTask( "WFBLQCLIFIN", "\workflow\wfblqclifin.html")
	oProcess:cSubject :=  "WF - BLOQUEIO DE CLIENTES DATA COMPRA" 
	oHTML := oProcess:oHTML
	oHtml:ValByName("DATABASE",   dDataBase ) 
	oHtml:ValByName("DTULTCOMP",  dDataBloq )
	oHtml:ValByName("DTCADASTRO", dDataCad  )
  
	//����������������������������������������������������������������������������������������Ŀ
	//�Faz o controle de execu��o para que o processamento seja feito de 100000000 em 100000000�
	//������������������������������������������������������������������������������������������
		
  if (Val(cCliIniTmp) + 100000000) <= Val(cCliFin)
  	
  	cCliFinTmp := StrZero(Val(cCliIniTmp) + 100000000, 09)

  	if !lJob 
			MsProcTxt("Analisando Faixa De: "+ Trim(cCliIniTmp) + Space(4) + "At�: " + Trim(cCliFinTmp))
		Else
			Conout("Analisando Faixa De: "+ Trim(cCliIniTmp) + Space(4) + "At�: " + Trim(cCliFinTmp))
		EndIf
    
		//�����������������������������������������������������������������������������������������������������Ŀ
		//�Faz a montagem do comando SQL que vai buscar os clientes que n�o tiveram compras nos �ltimos 90 dias.�
		//�������������������������������������������������������������������������������������������������������
		
    	cSql := "SELECT A1_COD, A1_LOJA FROM " + RetSqlName("SA1") + cEol
		cSql += " WHERE D_E_L_E_T_ <> '*' "                        + cEol
		cSql += " AND A1_RISCO <> 'E' "                            + cEol
		cSql += " AND A1_RISCO <> 'A' "                            + cEol
		cSql += " AND A1_COD <= '" + cCliFinTmp + "' "             + cEol
		cSql += " AND A1_COD >= '" + cCliIniTmp + "' "             + cEol
		cSql += " AND A1_DTCADAS <= '" + DtoS(dDataCad) + "' "     + cEol
		cSql += " AND ( ( A1_X_EB2B != 'S' AND A1_ULTCOM  <= '" + DtoS(dDataBloq) + "' )   "    + cEol
		cSql += " 	OR  ( A1_X_EB2B =  'S' AND A1_ULTCOM  <= '" + DtoS(dDATAB2B)  + "' ) ) "    + cEol
		
		
		/*
		cSql += " AND A1_COD || A1_LOJA NOT IN ( "                 + cEol 
		
		//����������������������������������������������������������������������Ŀ
		//�Monta sql buscando dinamicamente as notas faturas de todas as empresas�
		//������������������������������������������������������������������������
		
		for i := 1 to len(aEmp)
			
			cSql += " SELECT DISTINCT F2_CLIENTE || F2_LOJA AS CLIENTE FROM " + "SF2" + AllTrim(aEmp[i]) + "0" + " F2 "   + cEol   
			cSql += " WHERE F2_TIPO = 'N' "                                                                               + cEol
			cSql += "   AND F2_EMISSAO >= '" + DtoS(dDataBloq) + "' "                                                     + cEol
			cSql += "   AND F2_CLIENTE >= '" +cCliIniTmp+ "' "                                                            + cEol
			cSql += "   AND F2_CLIENTE <= '" +cCliFinTmp+ "' "                                                            + cEol
			cSql += "   AND F2.D_E_L_E_T_ <> '*' "                                                                        + cEol
			
			if i != len(aEmp)
				cSql += " UNION ALL "                                                                                       + cEol  
			Else
				cSql += " )"                                                                                                + cEol
			EndIf
		Next i
		*/
		
		Conout(cSql)
		
		TCQUERY cSql NEW ALIAS "SA1TMP"
		
		DbSelectArea("SA1TMP")
		SA1TMP->(DbGoTop())
		
		count to nQuant 
		
		SA1TMP->(DbGoTop())
		
		//�����������������������������������������������������������������������������������������������������������Ŀ
		//�Se a tabela tempor�ria retornar vazia, adiciona mais uma faixa de clientes e d� sequ�ncia no processamento.�
		//�������������������������������������������������������������������������������������������������������������
		
		if !nQuant > 0
			SA1TMP->(DbCloseArea())

			//���������������������������������������������������������
			//�Chama o m�todo Free() para liberar mem�ria do processo.�
			//���������������������������������������������������������
	
			oProcess:Finish() 
			oProcess:Free()
			
			cCliIniTmp := StrZero(Val(cCliIniTmp) + 100000000, 09)
			Loop
		EndIf
		
		if Empty(cMsg)
			cMsg := " ### Clientes Alterados ### " + cEol
		EndIf
		
		//�������������������������������������������������������������������������Ŀ
		//�Percorre a tabela tempor�ria alterando os clientes que n�o tiveram compra�
		//���������������������������������������������������������������������������
		
		While !SA1TMP->(EOF())
			
			DbSelectArea("SA1")
			SA1->(DbSetOrder(1))
		
			//�����������������������������������������������������������Ŀ
			//�Posiciona na tabela de clientes para altera��o do cadastro.�
			//�������������������������������������������������������������
			
			if SA1->(DbSeek(xFilial("SA1") + SA1TMP->A1_COD + SA1TMP->A1_LOJA))
				RecLock("SA1", .F.)
				SA1->A1_MSBLQL := "1"
				SA1->A1_RISCO  := "E"
				SA1->A1_OBSERV := "Bloqueado por data de compra"
				SA1->A1_LC     := 0
				
				//�������������������������������������������������������la��
				//�Adiciona o cliente no workflow de clientes bloqueados.�
				//�������������������������������������������������������la��
				
				AAdd((oHtml:ValByName("IT.CODCLI" ))  , Trim(SA1TMP->A1_COD))     
				AAdd((oHtml:ValByName("IT.CODLOJA" ))	, Trim(SA1TMP->A1_LOJA)) 
				AAdd((oHtml:ValByName("IT.RAZAO" ))	  , Trim(SA1->A1_NOME))     
				
				SA1->(MsUnlock()) 
		    
				//����������������������������������������������������������������������������Ŀ
				//�Adiciona na vari�vel cMsg c�digo do cliente e loja que est� sendo bloqueado.�
				//������������������������������������������������������������������������������
				
				cMsg += "C�digo: " + Trim(SA1TMP->A1_COD) + Space(4) + "Loja: " + Trim(SA1TMP->A1_LOJA) + cEol

			EndIf
			
			//�������������������������������������������������������������������������������������������Ŀ
			//�Caso n�o for execu��o via Job, atualiza janela de processamento com cod. do cliente e loja.�
			//���������������������������������������������������������������������������������������������
			
			if !lJob 
				MsProcTxt("Cliente: "+ Trim(SA1TMP->A1_COD) + Space(4) + "Loja: " + Trim(SA1TMP->A1_LOJA)) 
			Else
				Conout("Cliente: "+ Trim(SA1TMP->A1_COD) + Space(4) + "Loja: " + Trim(SA1TMP->A1_LOJA))
			EndIf
			
			SA1TMP->(DbSkip())
		EndDo
			
		SA1TMP->(DbCloseArea()) 
    		
  		cCliIniTmp := StrZero(Val(cCliIniTmp)+100000000,09)
  	
		//�������������������������������������������Ŀ
		//�Adiciona os endere�os para envio de e-mail.�
		//���������������������������������������������
		
  		oProcess:cTo  := cEmail
		ConOut("Enviando Workflow de Bloqueio de Clientes Para: " + oProcess:cTo)
		
		oProcess:Start()	
		oProcess:Finish() 
		
		//���������������������������������������������������������
		//�Chama o m�todo Free() para liberar mem�ria do processo.�
		//���������������������������������������������������������
		
		oProcess:Free()
		
  Else
  
  	cCliFinTmp := cCliFin
    
  	if !lJob 
			MsProcTxt("Analisando Faixa De "+ Trim(cCliIniTmp) + Space(4) + "At�: " + Trim(cCliFinTmp))
		Else
			Conout("Analisando Faixa De "+ Trim(cCliIniTmp) + Space(4) + "At�: " + Trim(cCliFinTmp))
		EndIf
  
		//�������������������������������������������������������������������������������������Ŀ
		//�Montagem do comando SQL que faz a busca dos clientes sem compra nos �ltimos 90 dias.�
		//���������������������������������������������������������������������������������������
		
  		cSql := "SELECT A1_COD, A1_LOJA FROM " + RetSqlName("SA1") + cEol
		cSql += " WHERE D_E_L_E_T_ <> '*' "                        + cEol
		cSql += " AND A1_RISCO <> 'E' "                            + cEol
		cSql += " AND A1_RISCO <> 'A' "                            + cEol
		cSql += " AND A1_COD <= '" + cCliFinTmp + "' "             + cEol
		cSql += " AND A1_COD >= '" + cCliIniTmp + "' "             + cEol
		cSql += " AND A1_DTCADAS <= '" + DtoS(dDataCad) + "' "     + cEol
		cSql += " AND ( ( A1_X_EB2B != 'S' AND A1_ULTCOM  <= '" + DtoS(dDataBloq) + "' )   "    + cEol
		cSql += " 	OR  ( A1_X_EB2B =  'S' AND A1_ULTCOM  <= '" + DtoS(dDATAB2B)  + "' ) ) "    + cEol


/*
		cSql += " AND A1_COD || A1_LOJA NOT IN ( "                 + cEol 
		
		//���������������������������������������������������������������������������������������Ŀ
		//�Busca dinamicamente em todas as empresas cadastradas, cliente e loja que tiveram compra�
		//�����������������������������������������������������������������������������������������
		
		for i := 1 to len(aEmp)
			
			cSql += " SELECT DISTINCT F2_CLIENTE || F2_LOJA AS CLIENTE FROM " + "SF2" + AllTrim(aEmp[i]) + "0" + " F2 "   + cEol   
			cSql += " WHERE F2_TIPO = 'N' "                                                                               + cEol
			cSql += "   AND F2_EMISSAO >= '" + DtoS(dDataBloq) + "' "                                                     + cEol
			cSql += "   AND F2_CLIENTE >= '" +cCliIniTmp+ "' "                                                            + cEol
			cSql += "   AND F2_CLIENTE <= '" +cCliFinTmp+ "' "                                                            + cEol
			cSql += "   AND F2.D_E_L_E_T_ <> '*' "                                                                        + cEol
			
			if i != len(aEmp)
				cSql += " UNION ALL "                                                                                       + cEol  
			Else
				cSql += " )"                                                                                                + cEol
			EndIf
		Next i
*/
    
		Conout(cSql)
		
		TCQUERY cSql NEW ALIAS "SA1TMP"
		
		DbSelectArea("SA1TMP")
		SA1TMP->(DbGoTop())
		
		count to nQuant 
		
		SA1TMP->(DbGoTop())
		
		//�������������������������������������������������������������H�
		//�Caso n�o retornou cliente para bloqueio, finaliza o processo�
		//�������������������������������������������������������������H�
		
		if !nQuant > 0
			SA1TMP->(DbCloseArea())
		
			//���������������������������������������������������������
			//�Chama o m�todo Free() para liberar mem�ria do processo.�
			//���������������������������������������������������������
	
			oProcess:Finish() 
			oProcess:Free()
				
			lContinua := .F.
			Loop
			
		EndIf
		
		cMsg := ""
		if Empty(cMsg)
			cMsg := " ### Clientes Alterados ### " + cEol
		EndIf
		                
		While !SA1TMP->(EOF())
			
			DbSelectArea("SA1")
			SA1->(DbSetOrder(1))
			
			//�������������������������������������������������T�
			//�Posiciona no cliente para altera��o do cadastro.�
			//�������������������������������������������������T�
			
			if SA1->(DbSeek(xFilial("SA1") + SA1TMP->A1_COD + SA1TMP->A1_LOJA))
				RecLock("SA1", .F.)
				SA1->A1_MSBLQL := "1"
				SA1->A1_RISCO  := "E"
				SA1->A1_OBSERV := "Bloqueado por data de compra"
				SA1->A1_LC     := 0

				//�������������������������������������������������������la��
				//�Adiciona o cliente no workflow de clientes bloqueados.�
				//�������������������������������������������������������la��
				
				AAdd((oHtml:ValByName("IT.CODCLI" ))  , Trim(SA1TMP->A1_COD))     
				AAdd((oHtml:ValByName("IT.CODLOJA" ))	, Trim(SA1TMP->A1_LOJA)) 
				AAdd((oHtml:ValByName("IT.RAZAO" ))	  , Trim(SA1->A1_NOME))     

				SA1->(MsUnlock()) 
		    
				//������������������������������������������������������������������Ŀ
				//�Adiciona na vari�vel cMsg cliente e loja que est� sendo bloqueado.�
				//��������������������������������������������������������������������
				
		    cMsg += "C�digo: " + Trim(SA1TMP->A1_COD) + Space(4) + "Loja: " + Trim(SA1TMP->A1_LOJA) + cEol
		
			EndIf
			
			if !lJob 
				MsProcTxt("Cliente: "+ Trim(SA1TMP->A1_COD) + Space(4) + "Loja: " + Trim(SA1TMP->A1_LOJA))
			Else
				Conout("Cliente: "+ Trim(SA1TMP->A1_COD) + Space(4) + "Loja: " + Trim(SA1TMP->A1_LOJA))
			EndIf
			
			SA1TMP->(DbSkip())
		EndDo
		
		SA1TMP->(DbCloseArea())
  	
	  	//�������������������������������������������Ŀ
		//�Adiciona os endere�os para envio de e-mail.�
		//���������������������������������������������
		
  		oProcess:cTo  := cEmail
		ConOut("Enviando Workflow de Bloqueio de Clientes Para: " + oProcess:cTo)
		
		//����������������������������������������������������������������Ŀ
		//�Inicia o envio do workflow para a faixa de clientes em execu��o.�
		//������������������������������������������������������������������
		
		oProcess:Start()	
		oProcess:Finish() 
		
		//���������������������������������������������������������
		//�Chama o m�todo Free() para liberar mem�ria do processo.�
		//���������������������������������������������������������
		
		oProcess:Free()
  	
  	lContinua := .F.
  EndIf
EndDo

SM0->(RestArea(aArea))

if lJob
	RpcClearEnv()
EndIf

Return .T.