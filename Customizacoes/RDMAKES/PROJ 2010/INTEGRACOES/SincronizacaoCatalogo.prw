#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SINCRONIZACAOCATALOGO�Autor  �Flavio   � Data �   	      ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o respons�vel pela integra��o das informa��es do ERP  ���
���          � com o cat�logo do vinho.                                   ���
�������������������������������������������������������������������������͹��
���Uso       � T.I.                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*--------------------------*
User Function CatalSinc()   
*--------------------------*

Local cConMob := ""
Local aConMob := {}
Local cSql 		:= ''
Local aProd 	:= {}
Local nPos 		:= 0 

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

// Se foi chamado via schedule seta a empresa e a filial a utilizar
If Select("SX6") == 0
	RPCSetType(3)
	PREPARE ENVIRONMENT EMPRESA "40" FILIAL "01"
EndIf

cConMob := SuperGetMV("MV_X_CATC", , '{"MYSQL/CANTU11","192.168.220.5",7892}')
aConMob := &cConMob

ConOut("CATALOGO - BUSCANDO DADOS PARA SINCRONIZA��O...")

//���������������������������������
//�Busca dos dados para integra��o.�
//���������������������������������

BEGINSQL ALIAS 'TMPCAT'
	SELECT DISTINCT
		Z06_PRODUT, B1_DESC,Z37_TABELA, CASE WHEN Z04_NOMCAT = ' ' THEN Z06_DESDET ELSE Z04_NOMCAT END AS NOME_CATALOGO,
		Z06_CARACT AS CHAVE_CARACT,
		Z06_DETALH AS CHAVE_DET
	FROM Z04CMP Z04, Z05CMP Z05, Z37CMP Z37, Z06CMP Z06, SB1CMP SB1
	WHERE Z05.D_E_L_E_T_ <> '*'
		AND Z06.D_E_L_E_T_ <> '*'
		AND SB1.D_E_L_E_T_ <> '*'
		AND Z37.D_E_L_E_T_ <> '*'
		AND Z04_CODIGO = Z05_CARAC
		AND Z04_DETALH = Z06_DETALH
		AND Z05_CARAC = Z06_CARACT
		AND Z05_TABELA = Z37_TABELA
		AND Z37_SEGTO = '01'
		AND Z06_PRODUT = B1_COD
		AND Z05_GRUPO = B1_GRUPO
		AND Z05_GRUPO IN ('0601','0602','0603','0604','0605','0606','0607','0609')
		AND Z06_CARACT = Z05_CARAC
		AND B1_MSBLQL <> '1'
	ORDER BY 1,3,4
ENDSQL

While TMPCAT->(!Eof())
  nPos := aScan(aProd, {|x| x[1] == AllTrim(TMPCAT->Z06_PRODUT)})
  if (nPos == 0)
  	aAdd(aProd, {AllTrim(TMPCAT->Z06_PRODUT), AllTrim(TMPCAT->B1_DESC), {}})
  	nPos := Len(aProd)
  endIf
  aAdd(aProd[nPos, 3], {AllTrim(TMPCAT->Z37_TABELA), AllTrim(TMPCAT->NOME_CATALOGO)})
	TMPCAT->(dbSkip())
EndDo
TMPCAT->(dbCloseArea())

ConOut("CATALOGO - CONECTANDO AO BANCO MYSQL")

TCConType("TCPIP")
nConMob := TCLink(aConMob[1],aConMob[2],aConMob[3])
lLogInc := .F. 

if (nConMob < 0)
	ConOut("CATALOGO - ERRO AO CONECTAR NO BANCO MYSQL")
	Return
EndIf

ConOut("CATALOGO - INICIANDO ATUALIZACAO DE REGISTROS")

For nX:= 1 to Len(aProd)
	
	//���������������������������������������������Ŀ
	//�Localiza o produto e se n�o existir, insere..�
	//�����������������������������������������������
	
	cSql := "select vinho.* "
	cSql += "from vinho "
	cSql += "where chave = '" + aProd[nX, 1] + "' "
	
	TcQuery cSql new Alias "TMPVIN"
	if TMPVIN->(Eof())
		TMPVIN->(dbCloseArea())
		cSql := "insert into vinho (chave, descricao, situacao) values ('" + StrTran(aProd[nX,1], "'", "") + "', '" + StrTran(aProd[nX,2], "'", "") + "', '1') "
		TcSqlExec(csql)
		lLogInc := .T.
		
		//����������������������������������
		//�grava o log de inclus�o do vinho�
		//����������������������������������
		
		cLog := "O Vinho " + StrTran(aProd[nX,2], "'", "") + " foi inclu�do"
		TcSqlExec("insert into log (usuario, data, mensagem) values (1,'" + DToS(dDataBase) + StrTran(Time(), ":", "") +  "', '" + cLog + "') ")
		
		//�����������������������Ŀ
		//�busca o c�digo do vinho�
		//�������������������������
		
		cSql := "select vinho.codigo, vinho.uva, vinho.linha, vinicola, pais, vinho.unidade as unidade, categoria "
		cSql += "from vinho "
		cSql += "where chave =  '" + aProd[nX, 1] + "' "
		TcQuery cSql new Alias "TMPVIN"
		nCodVinho := TMPVIN->CODIGO

	else
		nCodVinho := TMPVIN->CODIGO
	EndIf
	
	lUpdLog := .F.
	if (nCodVinho > 0)
		
		//�������������������������Ŀ
		//�processa a caracter�stica�
		//���������������������������
		
		For nCar := 1 to len(aProd[nX, 3])
			
			//���������������������������������������������������������������������������������������
			//�A fun��o abaixo faz o processamento das informa��es e insere no banco caso necess�rio.�
			//���������������������������������������������������������������������������������������			
			nCodTab := GravaTab(aProd[nX, 3, nCar, 1], aProd[nX, 3, nCar, 2])
			if (nCodTab > 0)
				cTab := aProd[nX, 3, nCar, 1]
				if (TMPVIN->&cTab != nCodTab)
					cSql := "update vinho set " + cTab + " = " + Str(nCodTab) + " where chave = '" + aProd[nX, 1] + "' "
					TcSqlExec(cSql)
					lUpdLog := .T.
				EndIf
			EndIf
		Next nCar
		
		if (lUpdLog .And. !lLogInc)
			cLog := "O Vinho " + StrTran(aProd[nX,2], "'", "") + " foi atualizado"
			TcSqlExec("insert into log (usuario, data, mensagem) values (1,'" + DToS(dDataBase) + StrTran(Time(), ":", "") +  "', '" + cLog + "') ")
		EndIf
		
	EndIf
	
	TMPVIN->(dbCloseArea())
	
Next nX

//���������������������������������������������8�
//�processa as atualiza��es de linha e vin�cola�
//���������������������������������������������8�

cSql := "select distinct vinho.linha, linha.descricao as desclinha, vinho.vinicola, vinicola.descricao as descvinicola, vinho.pais, pais.nome as descpais " 
cSql +=  " from vinho "
cSql +=  "left join linha on vinho.linha = linha.codigo "
cSql +=  "left join vinicola on vinho.vinicola = vinicola.codigo "
cSql +=  "left join pais on vinho.pais = pais.codigo "
cSql +=  "where vinho.linha is not null "
cSql +=  "  and vinho.vinicola is not null "
cSql +=  "  and vinho.pais is not null "
cSql +=  "order by linha, vinicola, pais "

TcQuery cSql new Alias 'TMPATU'

//����������������������������������������������������������������������������Ŀ
//�Faz a atualiza��o das linhas e vin�colas conforme as informa��es cadastradas�
//������������������������������������������������������������������������������

While TMPATU->(!Eof())
	nLinha := TMPATU->LINHA
	nVinicola := TMPATU->VINICOLA
	nPais := TMPATU->PAIS
	TMPATU->(dbSkip())
	if (nLinha == TMPATU->LINHA)
		While (nLinha == TMPATU->LINHA)
			TMPATU->(dbSkip())
		EndDo
	else
	  cSql := 'update linha set vinicola = ' + Str(nVinicola) + ' where codigo = ' + Str(nLinha)
	  if (TcSqlExec(cSql) < 0)
	  	ConOut("Erro Sql " + cSql)
	  EndIf
	  
		//���������������������������Ŀ
		//�atualiza o pa�s da vin�cola�
		//�����������������������������
		
	  cSql := 'update vinicola set pais = ' + Str(nPais) + ' where codigo = ' + Str(nVinicola)	  
	  if (TcSqlExec(cSql) < 0)
	  	ConOut("Erro Sql " + cSql)
	  EndIf
	EndIf
EndDo


TMPATU->(dbCloseArea())
TcUnlink(nConMob)

MsgInfo("Atualizado com sucesso")
ConOut("CATALOGO - SINCRONIZACAO FINALIZADA.")

Return Nil

*---------------------------------------*
Static function GravaTab(cTab, cChave)   
*---------------------------------------*
Local nCodigo := 0
Local cSql
cTab := Lower(cTab)
cChave := StrTran(cChave, "'", "")
cSql := "select codigo from " + Lower(cTab) + " where chave_erp = '" + cChave + "' "
TcQuery cSql new Alias "TMPTBL"
if TMPTBL->(!Eof())	
	nCodigo := TMPTBL->CODIGO
	TMPTBL->(dbCloseArea())
else               
	TMPTBL->(dbCloseArea())
	
	//��������������Ŀ
	//�faz a inser��o�
	//����������������
	
	if (Upper(cTab) $ "LINHA/VINICOLA")
		cSql := "insert into " + cTab + "(descricao, situacao, chave_erp) values ('" + cChave + "', 'A', '" + cChave + "' )"
	ElseIf(Upper(cTab) $ "UNIDADE/CATEGORIA/UVA")
		cSql := "insert into " + cTab + "(descricao, chave_erp) values ('" + cChave + "', '" + cChave + "' )"
	ElseIf(Upper(cTab) $ "PAIS")
		cSql := "insert into " + cTab + "(nome, situacao, chave_erp) values ('" + cChave + "', 'A', '" + cChave + "' )"
	EndIf
	TcSqlExec(cSql)
	cSql = "select codigo from " + cTab + " where chave_erp = '" + cChave + "' "
	TcQuery cSql new Alias "TMPTBL"
	nCodigo := TMPTBL->CODIGO	
	TMPTBL->(dbCloseArea())
EndIf

Return nCodigo