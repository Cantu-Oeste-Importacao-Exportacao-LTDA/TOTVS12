#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RELCNTGEXC�Autor  �Roberto Rosin       � Data �  09/05/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Imprime o relat�rio de Conting�ncias no formato CSVs, que   ���
���          �pode ser aberto com o programa Excel ou com OpenOficce      ���
�������������������������������������������������������������������������͹��
���Uso       � Planejamento e Controle Or�ament�rio                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RelCntgExc()
Static oDlg
Static oBtnArqu
Static oButton1
Static oButton2
Static oButton3
Static oGetCaminho
Static cGetCaminho := space(200)
Static oSay10

Local cPerg     := "RELCTGX"   

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

	AjustaSX(cPerg)
	
	//monta uma tela para que possam ser escolhidos os par�metros do relat�rio e o local onde o arquivo ser� salvo
  DEFINE MSDIALOG oDlg TITLE "Relat�rio de Conting�ncias" FROM 000, 000  TO 090, 370 COLORS 0, 16777215 PIXEL

    @ 007, 004 SAY oSay10 PROMPT "Caminho do Arquivo: " SIZE 053, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 006, 066 MSGET oGetCaminho VAR cGetCaminho SIZE 103, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 007, 172 BUTTON oBtnArqu PROMPT "?" SIZE 009, 012 OF oDlg PIXEL ACTION (u_btnArqui())
    @ 026, 061 BUTTON oButton2 PROMPT "Ok" SIZE 037, 012 OF oDlg PIXEL ACTION (u_btnOk())
    @ 026, 104 BUTTON oButton3 PROMPT "Cancelar" SIZE 037, 012 OF oDlg PIXEL ACTION (oDlg:end())
    @ 026, 018 BUTTON oButton1 PROMPT "Par�metros" SIZE 037, 012 OF oDlg PIXEL ACTION (u_btnParam(cPerg))
  ACTIVATE MSDIALOG oDlg

Return

//seta o caminho do arquivo atravez de uma Dialog de escolha de arquivo.
user function btnArqui()

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

	cGetCaminho := cGetFile( "Arquivos CSV | *.csv" , 'Arquivos', 1, 'C:\', .F., nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY ),.F., .T. )
return

//verifica se foi informado um caminho prar o arquivo e chama a fun��o que gera o relat�rio.
user function btnOk()
	Local titulo    := "Relat�rio de Conting�ncias"
	
//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

	if allTrim(cGetCaminho) != ""
		RptStatus({|lEnd| GeraRel()}, titulo) 
	else
		msgInfo("Caminho de arquivo inv�lido!")
	endIf
return

//chama a tela da par�metros
user function btnParam(cPerg)
	Pergunte(cPerg, .T., "Par�metros", .T.)

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())	

return

//fun��o que monta o arquivo
Static Function GeraRel()
  
Local cabec1
Local nCntImpr
Local nTipo
                  
Local aTamCpo := {}
Local cCabec1 := ""
Local cCabecGroup := "" //tem 11 letras... n�o declarar outra vari�vel com nome cCabecGrou pois VAI dar problema
Local cSql    := ""
Local cEol    := CHR(13)+CHR(10)
Local nQuant  := 0
Local cString := ""
Local cOldAgrupador := "" //vari�vel com mais de 10 letras identificada internamente por cOldAgrupa
Local cAgrupador := ""

// Vari�veis totalizadoras
Local nTotal   := 0
Local aTotal   := {}
Local nTotQtde := 0
local nTotParc := 0
local nTotQtdePa := 0

//controle
//controla se � a primeira execu��o para imprimir ou n�o os totalizadores do relat�rio
local lTotaliza := .F.

Local aCampos := {}

//monta o array aCampos de acordo com o par�metro de agrupador
if MV_PAR12 == 1
	//agrupa por Segmento
	aCampos := {"ALI_CDCNTG","ALI_DTSOLI","AK5_DESCRI","CTT_DESC01","ALJ_VALOR1","AK2_VALOR","ALJ_HIST","ALI_X_OBS","ALI_NOME"}
	cCabecGroup := "Segmento............: "
elseIf MV_PAR12 == 2
	//agrupa por Centro de Custos
	aCampos := {"ALI_CDCNTG","ALI_DTSOLI","AK5_DESCRI","CTH_DESC01","ALJ_VALOR1","AK2_VALOR","ALJ_HIST","ALI_X_OBS","ALI_NOME"}
	cCabecGroup := "Centro de Custos....: "
elseIf MV_PAR12 == 3
	//agrupa por Conta Or�ament�ria
	aCampos := {"ALI_CDCNTG","ALI_DTSOLI","CTH_DESC01","CTT_DESC01","ALJ_VALOR1","AK2_VALOR","ALJ_HIST","ALI_X_OBS","ALI_NOME"}
	cCabecGroup := "Conta Or�ament�ria..: "
endIf

// Cria o cabe�alho do relat�rio com o nome padr�o dos campos de acordo com o SX3
DbSelectArea("SX3")
DbSetOrder(2)
for i := 1 to len(aCampos)
	if DbSeek(aCampos[i]) .and. aCampos[i] <> "AK5_DESCRI" .and. aCampos[i] <> "CTT_DESC01" .and. aCampos[i] <> "CTH_DESC01" .and. aCampos[i] <> "ALI_X_OBS" .and. aCampos[i] <> "AK2_VALOR"
		if(aCampos[i] == "ALJ_HIST")
			cCabec1 += PadC(AllTrim(X3Titulo()),50) + ";"
			// Grava num array (aTamCpo) o tamanho dos campos do relat�rio
			Aadd(aTamCpo, 50)
		else
			cCabec1 += PadC(AllTrim(X3Titulo()),iif(Len(X3Titulo()) > SX3->X3_TAMANHO, Len(X3Titulo()), SX3->X3_TAMANHO)) + ";"
			// Grava num array (aTamCpo) o tamanho dos campos do relat�rio
			Aadd(aTamCpo, iif(Len(X3Titulo()) > SX3->X3_TAMANHO, Len(X3Titulo()), SX3->X3_TAMANHO))
		end if
	EndIf

	//campos com descri��o ou tamanho personalizados
	if aCampos[i] == "ALI_X_OBS"
		cCabec1 += PadC("Justificativa",50) + ";"
		// Grava num array (aTamCpo) o tamanho dos campos do relat�rio
		Aadd(aTamCpo, 50)
	elseIf(aCampos[i] == "AK5_DESCRI")
		cCabec1 += PadC("Conta Or�ament�ria",30) + ";"
		// Grava num array (aTamCpo) o tamanho dos campos do relat�rio
		Aadd(aTamCpo, 30)
	elseIf(aCampos[i] == "CTT_DESC01")
		cCabec1 += PadC("Centro de Custos",25) + ";"
		// Grava num array (aTamCpo) o tamanho dos campos do relat�rio
		Aadd(aTamCpo, 25)
	elseIf(aCampos[i] == "CTH_DESC01")
		cCabec1 += PadC("Segmento",30) + ";"
		// Grava num array (aTamCpo) o tamanho dos campos do relat�rio
		Aadd(aTamCpo, 30)
	elseIf(acampos[i] == "AK2_VALOR")
		cCabec1 += PadC("Valor Or�ado", 15) + ";"
		// Grava num array (aTamCpo) o tamanho dos campos do relat�rio
		aAdd(aTamCpo, 15)
	endIf    
Next i

nCntImpr := 0
li     := 80
m_pag  := 1
nTipo  := 15
cOpcao := Transform(MV_PAR04, "@!")

//����������������������������
//�Monta a consulta dos dados�
//����������������������������
cSql := "SELECT ALI.ALI_FILIAL      AS FILIAL,"       + cEol
cSql += "ALI.ALI_DTSOLI             AS DTSOLI,"       + cEol
cSql += "ALJ.ALJ_CO                 AS CO,"           + cEol
cSql += "AK5.AK5_DESCRI             AS CONTA_ORCA,"   + cEol
cSql += "ALJ.ALJ_CLVLR              AS CLVLR,"        + cEol
cSql += "CTH.CTH_DESC01             AS SEGMENTO,"     + cEol
cSql += "ALJ.ALJ_CC                 AS CC,"           + cEol
cSql += "CTT.CTT_DESC01             AS C_CUSTO,"      + cEol
cSql += "ALI.ALI_CDCNTG             AS CDCNTG,"       + cEol
cSql += "ALJ.ALJ_VALOR1             AS VALOR1,"       + cEol
cSql += "SUBSTR(ALJ.ALJ_HIST,1,50)  AS HISTORICO,"    + cEol
cSql += "SUBSTR(ALI.ALI_X_OBS,1,50) AS X_OBS,"        + cEol
cSql += "ALI.ALI_USER               AS USUARIO,"      + cEol
cSql += "ALI.ALI_NOME               AS NOME,"         + cEol
cSql += "ALJ.ALJ_CODPLA             AS CODPLA,"       + cEol
cSql += "ALJ.ALJ_VERSAO             AS VERSAO"        + cEol
cSql += "FROM " + RetSqlName("ALI") + " ALI"     + cEol
cSql += "INNER JOIN " + RetSqlName("ALJ") + " ALJ ON ALI.ALI_FILIAL = ALJ.ALJ_FILIAL AND ALI.ALI_CDCNTG = ALJ.ALJ_CDCNTG AND ALJ.D_E_L_E_T_ <> '*'" + cEol
cSql += "INNER JOIN " + RetSqlName("CTH") + " CTH ON CTH.CTH_CLVL = ALJ.ALJ_CLVLR" + cEol
cSql += "INNER JOIN " + RetSqlName("CTT") + " CTT ON CTT.CTT_CUSTO  = ALJ.ALJ_CC"  + cEol
cSql += "INNER JOIN " + RetSqlName("AK5") + " AK5 ON AK5.AK5_CODIGO = ALJ.ALJ_CO"  + cEol
cSql += "WHERE ALI.D_E_L_E_T_ <> '*'"      + cEol
cSql += "AND ALI.ALI_FILIAL = '"  + xFilial("ALI") + "'" + cEol
cSql += "AND ALJ.ALJ_CLVLR BETWEEN '"   + MV_PAR01 + "' AND '" + MV_PAR02 + "'" + cEol
cSql += "AND ALJ.ALJ_CC BETWEEN '"      + MV_PAR03 + "' AND '" + MV_PAR04 + "'" + cEol
cSql += "AND ALJ.ALJ_CO BETWEEN '"      + MV_PAR05 + "' AND '" + MV_PAR06 + "'" + cEol

//����������������������
//�Datas Inicio e Final�
//����������������������
cSql += "AND ALI.ALI_DTSOLI BETWEEN '" + Dtos(MV_PAR08) + "' AND '" +Dtos(MV_PAR09) + "'" + cEol

if !empty(MV_PAR10) .or. upper(MV_PAR10) == 'ZZZ'//se o par�metro de Hist�rico estiver em branco ou for igual a "zzz"
  cSql += "AND UPPER(ALJ.ALJ_HIST) LIKE '%"  + UPPER(trim(MV_PAR07)) + "%'" + cEol
endIf

if !empty(MV_PAR11) .or. upper(MV_PAR11) == 'ZZZ'//se o par�metro de Observa��o estiver em branco ou for igual a "zzz"
  cSql += "AND UPPER(ALI.ALI_X_OBS) LIKE '%" + UPPER(trim(MV_PAR08)) + "%'" + cEol
endIf

//verifica qual o par�metro de Status e adiciona o filtro de status selecinado
if cOpcao == "1" 
	cSql += "AND ALI.ALI_STATUS = 2 "  +cEol
ElseIf cOpcao == "2"
	cSql += "AND ALI.ALI_STATUS = 3 "  +cEol
ElseIf cOpcao == "3"
	cSql += "AND ALI.ALI_STATUS = 4 "  +cEol
ElseIf cOpcao == "4"
	cSql += "AND ALI.ALI_STATUS = 5 "  +cEol
EndIf

//monta o ORDER BY de acordo com o par�metro de agrupamento
if MV_PAR12 == 1
	cSql += "ORDER BY ALI.ALI_FILIAL, ALJ.ALJ_CLVLR, ALJ.ALJ_CO, ALJ.ALJ_CC"
elseIf MV_PAR12 == 2
	cSql += "ORDER BY ALI.ALI_FILIAL, ALJ.ALJ_CC, ALJ.ALJ_CO, ALJ.ALJ_CLVLR"
elseIf MV_PAR12 == 3
	cSql += "ORDER BY ALI.ALI_FILIAL, ALJ.ALJ_CO, ALJ.ALJ_CLVLR, ALJ.ALJ_CC"
endIf

TCQUERY cSql NEW ALIAS "ALITMP"

DbSelectArea("ALITMP")
ALITMP->(DbGoTop())

// Se a tabela estiver vazia, retorna mensagem que n�o h� dados para o usu�rio.
if ALITMP->(EOF())
	Aviso("Tabela Vazia", "N�o h� dados a serem exibidos.",{"Ok"})
	ALITMP->(DbCloseArea())
	Return nil	
EndIf

count to nQuant 
ALITMP->(DbGoTop())
SetRegua(nQuant)
	///////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////
	//imprime em .CSV, formato que pode ser lido pelo EXCEL e pelo OpenOffice//
	///////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////
	
	cCaminho := cGetCaminho
	
	if At(".",cCaminho) > 0
		cCaminho := SubStr(cCaminho,1,At(".",cCaminho)-1)
	EndIf

	nHandle := MsfCreate(AllTrim(cCaminho) + ".CSV",0)
	
	While !ALITMP->(EOF())
		IncRegua()
		
		//define o conte�do da vari�vel agrupador segundo o par�metro de agrupamento.
		//essa vari�vel � utilizada para definir quando alterou o agrupador.
		if MV_PAR12 == 1		
			cAgrupador := ALITMP->SEGMENTO
		elseIf MV_PAR12 == 2
			cAgrupador := ALITMP->C_CUSTO
		elseIf MV_PAR12 == 3
			cAgrupador := ALITMP->CONTA_ORCA
		endIf
		
		//se alterou o agrupador, finaliza o grupo e imprime os totalizadores de grupo
		if cAgrupador <> cOldAgrupador
		  //se n�o for a primeira vez que est� executando o relat�rio
			if lTotaliza
				//fWrite(nHandle, cEol ) // Quebra linha
				//imprime os totalizadores
				fWrite(nHandle, "Contig�ncias..:; " + Transform(nTotQtdePa, "@E 9999") + ";")
				fWrite(nHandle, cEol ) // Quebra linha
				fWrite(nHandle, "Total.........:;" + Transform(nTotParc, "@E 999,999,999.99") + ";")
				fWrite(nHandle, cEol ) // Quebra linha
				fWrite(nHandle, cEol ) // Quebra linha 
			end if
			
			//define qual � o ultimo agrupador
			if MV_PAR12 == 1		
				fWrite(nHandle, cCabecGroup + ";" + ALITMP->SEGMENTO + ";" + Transform(ALITMP->CLVLR, "@E 9999999999") + ";")
				cOldAgrupador := ALITMP->SEGMENTO
			elseIf MV_PAR12 == 2
				fWrite(nHandle, cCabecGroup + ";" + ALITMP->C_CUSTO + ";" + Transform(ALITMP->CC,    "@E 9999999999") + ";")
				cOldAgrupador := ALITMP->C_CUSTO
			elseIf MV_PAR12 == 3
				fWrite(nHandle, cCabecGroup + ";" + ALITMP->CONTA_ORCA + ";" + Transform(ALITMP->CO,    "@E 9999999999") + ";")
				cOldAgrupador := ALITMP->CONTA_ORCA
			endIf
			fWrite(nHandle, cEoL ) // Quebra linha
			fWrite(nHandle, cCabec1)
			fWrite(nHandle, cEoL ) // Quebra linha
			
			//zera os totalizadores de grupo
			nTotParc := 0
			nTotQtdePa := 0
			
			//utilizada para n�o totalizar quando � a primeira vez que est� executando.		
			lTotaliza := .T.
		endif
		nCntImpr++
		li++      
		
		//ajusta as mascaras dos campos nescess�rios
		cDataSoli := subStr(ALITMP->DTSOLI,7,2) + "/" + subStr(ALITMP->DTSOLI,5,2) + "/" + subStr(ALITMP->DTSOLI,1,4)
		cValor    := Transform(ALITMP->VALOR1, "@E 9,999,999.99")
		
		nTotal := nTotal + ALITMP->VALOR1
		nTotQtde++
		nTotParc := nTotParc + ALITMP->VALOR1
		nTotQtdePa ++
		
		//�����������������������������������������������������������������
		//�Define o per�odo sempre como primeiro dia do mes da solicita��o�
		//�����������������������������������������������������������������
		cPeriodo := subStr(ALITMP->DTSOLI,1,6) + '01'
		 
		//������������������������������������������������
		//�Posiciona na tabela para buscar o valor or�ado�
		//������������������������������������������������
		cSqlAK2 := "SELECT AK2_VALOR"                                + cEol
		cSqlAK2 += "FROM AK2500 AK2"                                 + cEol
		cSqlAK2 += "WHERE AK2.AK2_FILIAL = '" + xFilial("ALI") + "'" + cEol
		cSqlAK2 += "AND AK2.AK2_CC =       '" + ALITMP->CC     + "'" + cEol
		cSqlAK2 += "AND AK2.AK2_CO =       '" + ALITMP->CO     + "'" + cEol
		cSqlAK2 += "AND AK2.AK2_CLVLR =    '" + ALITMP->CLVLR  + "'" + cEol
		//cSqlAK2 += "AND AK2.AK2_PERIOD =   '" + cPeriodo       + "'" + cEol
		cSqlAK2 += "AND '" + ALITMP->DTSOLI + "' BETWEEN AK2.AK2_DATAI AND AK2.AK2_DATAF" + cEol
		cSqlAK2 += "AND AK2.D_E_L_E_T_ <>  '*'"                      + cEol
		
		TCQUERY cSqlAK2 NEW ALIAS "AK2TMP"

		DbSelectArea("AK2TMP")
		AK2TMP->(DbGoTop())
		
		if !AK2TMP->(EOF())
			cValorOrcado := transform(AK2TMP->AK2_VALOR, "@E 99,999,999.99")
		else
			cValorOrcado := "N/E"
		EndIf
		
		AK2TMP->(DbCloseArea())
		
		// Monta a String da linha do relat�rio conforme o par�metro MV_PAR12 que define o agrupamento do relat�rio.	
		if MV_PAR12 == 1
			//agrupa por Segmento
			cString := ALITMP->CDCNTG      + ";"
			cString += cDataSoli           + ";"
			cString += ALITMP->CONTA_ORCA  + ";"
			cString += ALITMP->C_CUSTO     + ";"
			cString += cValor              + ";"
			cString += cValorOrcado        + ";"
			cString += ALITMP->HISTORICO   + ";"
			cString += ALITMP->X_OBS       + ";"
			cString += ALITMP->NOME
		elseIf MV_PAR12 == 2
			//agrupa por Centro de Custos
			cString := ALITMP->CDCNTG      + ";"
			cString += cDataSoli           + ";"
			cString += ALITMP->CONTA_ORCA  + ";"
			cString += ALITMP->SEGMENTO    + ";"
			cString += cValor              + ";"
			cString += cValorOrcado        + ";"
			cString += ALITMP->HISTORICO   + ";"
			cString += ALITMP->X_OBS       + ";"
			cString += ALITMP->NOME
		elseIf MV_PAR12 == 3
			//agrupa por Conta Or�ament�ria
			cString := ALITMP->CDCNTG      + ";"
			cString += cDataSoli           + ";"
			cString += ALITMP->SEGMENTO    + ";"
			cString += ALITMP->C_CUSTO     + ";"
			cString += cValor              + ";"
			cString += cValorOrcado        + ";"
			cString += ALITMP->HISTORICO   + ";"
			cString += ALITMP->X_OBS       + ";"
			cString += ALITMP->NOME
		endIf
																	
		fWrite(nHandle, cString)
		fWrite(nHandle, cEoL ) // Quebra linha
		
		// Imprime totaliza��o dos registros.
		ALITMP->(DbSkip())
		
		//monta rodap�
		if ALITMP->(EOF())
			fWrite(nHandle, "Contig�ncias..: ;" + Transform(nTotQtdePa, "@E 9999") + ";")
			fWrite(nHandle, cEol ) // Quebra linha
			fWrite(nHandle, "Total.........:;" + Transform(nTotParc, "@E 999,999,999.99") + ";")
			fWrite(nHandle, cEol ) // Quebra linha
			fWrite(nHandle, cEol ) // Quebra linha
		
		fWrite(nHandle,"Contig�ncias.:;" + Transform(nTotQtde, "@E 99,999,999,999") + ";")
		fWrite(nHandle, cEol ) // Quebra linha
		fWrite(nHandle,"Total........:;" + Transform(nTotal,   "@E 999,999,999.99") + ";")
		EndIf
		  
	EndDo
	
	ALITMP->(DbCloseArea())

	fClose(nHandle)
	CpyS2T(SubStr(cCaminho,3,len(AllTrim(cCaminho))) + ".CSV", SubStr(cCaminho,1,2), .T.)
	
	If ! ApOleClient( 'MsExcel' )
		MsgAlert( 'MsExcel nao instalado')
		Return
	EndIf
	
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(AllTrim(cCaminho) + ".CSV") // Abre uma planilha
	oExcelApp:SetVisible(.T.)
	
	oDlg:end()

Return .T.


Static Function AjustaSX(cPerg) 
	/*explica��o dos par�metros do PutSx1...
	PutSx1(cPerg,;  //Nome do grupo de pergunta
	"01",;          //Ordem de apresenta��o das perguntas na tela
	"Segmento ?",;  //Texto da pergunta a ser apresentado na tela.
	"Segmento ?",;  //Texto em espanhol a ser apresentado na tela.
	"Segmento ?",;  //Texto em ingles a ser apresentado na tela.
	"mv_ch1",;      //Variavel do item.
	"C",;           //Tipo do conte�do de resposta da pergunta.
	08,;            //Tamanho do campo para a resposta da pergunta.
	0,;             //N�mero de casas decimais da resposta, se houver.
	0,;             //Valor que define qual o item do combo estar� selecionado na apresenta��o da tela. Este campo somente poder� ser preenchido quando o par�metro cGSC for preenchido com "C"
	"G",;           //Estilo de apresenta��o da pergunta na tela: - "G" - formato que permite editar o conte�do do campo. - "S" - formato de texto que n�o permite altera��o. - "C" - formato que permite a op��o de sele��o de dados para o campo.
	"",;            //Valida��o do item de pergunta.
	"   ",;         //Nome da consulta F3 que poder� ser acionada pela pergunta.
	"",;            //C�digo do grupo de campos relacionado a pergunta.
	"",;            
	"MV_PAR01")     //Nome do MV_PAR para a utiliza��o nos programas 
	                //Op��es da combo... 
	*/
	
	PutSx1(cPerg,"01","Segmento De ?",           "Segmento De ?",           "Segmento De ?",          "mv_ch1"  ,"C",10,0,0,"G","","CTH","","","MV_PAR01")
	PutSx1(cPerg,"02","Segmento At� ?",          "Segmento At� ?",          "Segmento At� ?",         "mv_ch2"  ,"C",10,0,0,"G","","CTH","","","MV_PAR02")
	PutSx1(cPerg,"03","Centro de Custos De ?",   "Centro de Custos De ?",   "Centro de Custos De ?",  "mv_ch3"  ,"C",10,0,0,"G","","CTT","","","MV_PAR03")
	PutSx1(cPerg,"04","Centro de Custos At� ?",  "Centro de Custos At� ?",  "Centro de Custos At�?",  "mv_ch4"  ,"C",10,0,0,"G","","CTT","","","MV_PAR04")
	PutSx1(cPerg,"05","Conta Orcament�ia De ?",  "Conta Orcament�ia De ?",  "Conta Orcament�ia De?",  "mv_ch5"  ,"C",10,0,0,"G","","AK5","","","MV_PAR05") 
	PutSx1(cPerg,"06","Conta Orcament�ia At� ?", "Conta Orcament�ia At�?",  "Conta Orcament�ia At�?", "mv_ch6"  ,"C",10,0,0,"G","","AK5","","","MV_PAR06")
	PutSx1(cPerg,"07","Status ?",                "Status ?",                "Status ?",               "mv_ch7"  ,"N",02,0,0,"C","","   ","","","MV_PAR07","Aguardando Lib.","Aguardando Lib.","Aguardando Lib.","Liberado","Liberado","Liberado","Cancelado","Cancelado","Cancelado","Lib out usu�rio","Lib out usu�rio","Lib out usu�rio","Todos","Todos","Todos")
	PutSx1(cPerg,"08","Data Inicio ?",           "Data Inicio ?",           "Data Inicio ?",          "mv_ch8"  ,"D",10,0,0,"G","","   ","","","MV_PAR08") 
	PutSx1(cPerg,"09","Data Final ?",            "Data Final ?",            "Data Final ?",           "mv_ch9"  ,"D",08,0,0,"G","","   ","","","MV_PAR09")
	PutSx1(cPerg,"10","Hist�rico contendo ?",    "Hist�rico contendo ?",    "Hist�rico contendo ?",   "mv_ch10" ,"C",50,0,0,"G","","   ","","","MV_PAR10")
	PutSx1(cPerg,"11","Observa��es contendo ?",  "Observa��es contendo ?",  "Observa��es contendo ?", "mv_ch11" ,"C",50,0,0,"G","","   ","","","MV_PAR11")
	PutSx1(cPerg,"12","Totaliza por ?",          "Totaliza por ?",          "Totaliza por ?",         "mv_ch12" ,"C",50,0,0,"C","","   ","","","MV_PAR12","Segmento","Segmento","Segmento","Centro de Custos","Centro de Custos","Centro de Custos","C. Or�ament�ria","C. Or�ament�ria","C. Or�ament�ria")
Return Nil