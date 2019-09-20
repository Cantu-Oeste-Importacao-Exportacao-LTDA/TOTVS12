#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ENVIAXMLNOTASFISCAIS�Autor  �Microsiga � Data �  23/04/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Fun�ao para enviar o xml para o cliente via workflow para	��� 
���							casos em que o sped nao est� enviando corretamente.				���
���							Deve ser chamado juntamente com a impressao da NF, 				���
���							preferencialmente no fonte DanfII                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Faturamento                                               	���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

/*usar parametro mv_ para transportador
gravar email qdo n�o existir
acertar E maiusculo para Eletronica no workflow*/

User Function SendXml(cSerie, cNota, cCliFor, cLoja, cTipo, aXML)
Local cProtocolo := aXML[1]
Local cRetorno   := aXML[2]
Local cNome := ""
Local cEmail := ""
Local lCliente := .T.
Local cCabProt := ""
Local cFile
Local oProcess
Local oHtml
Local oDlg1
Local lEnvXml := SuperGetMV("MV_X_ENVXM", , .T.)
Local nOpcEnvMail := SuperGetMV("MV_X_XMEUS", , 2)
Local cDirAt := CurDir()  

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

if !lEnvXml
	Return
EndIf

if (cTipo == "S")
	SF2->(dbSetOrder(01))
	SF2->(dbSeek(xFilial("SF2") + cNota + cSerie))
	lCliente := !(SF2->F2_TIPO $ "BD")
Else
	SF1->(dbSetOrder(01))
	SF1->(dbSeek(xFilial("SF1") + cNota + cSerie + cCliFor + cLoja))
	lCliente := SF1->F1_TIPO $ "DB"
EndIf

if(lCliente)
	SA1->(dbSetOrder(01))
	SA1->(dbSeek(xFilial("SA1") + cCliFor + cLoja))
	cEmail := SA1->A1_X_MAILN
	cNome := SA1->A1_NOME
else
	SA2->(dbSetOrder(01))
	SA2->(dbSeek(xFilial("SA2") + cCliFor + cLoja))
	cEmail := SA2->A2_X_MAILN
	cNome := SA2->A2_NOME
EndIf

if (Empty(cEmail) .And. nOpcEnvMail == 2) .Or. (nOpcEnvMail == 3)
	cEmail := PadR(cEmail, 200)
	@ 140,100 TO 300,450 DIALOG oDlg1 TITLE "Email do Cliente / Fornecedor NF " + cSerie + " - " + cNota
	@ 005,005 TO 045,160
	@ 020,010 Say iif(lCliente, "Cliente", "Fornecedor") + ": "  + cCliFor  + " (" + cLoja + ") - " + cNome
	@ 030,010 Say "Email"
	@ 030,030 Get cEmail Size 100, 50
	@ 050,100 BMPBUTTON TYPE 1 ACTION Close(oDlg1) 
	ACTIVATE DIALOG oDlg1 CENTER

	//���������������������������Ŀ
	//�Atualiza o email do cliente�
	//�����������������������������
	
	if !Empty(cEmail) .And. (nOpcEnvMail != 3) .And. MsgBox("Gravar email no cadastro?","Gravar email","YESNO")
		if lCliente
			RecLock("SA1")
			SA1->A1_X_MAILN := cEmail
			SA1->(MsUnlock())
		Else
			RecLock("SA2")
			SA2->A2_X_MAILN := cEmail
			SA2->(MsUnlock())
		EndIf
	elseif Empty(cEmail)
	  cEmail := "xml@grupocantu.com.br"
	EndIf
EndIf


// A partir daqui faz por job, n�o executa mais
// StartJob("U_JobEnvXml", GetEnvServer(), .F., cEmpAnt, cFilAnt, cSerie, cNota, aXML, cEmail, cNome)
// StartJob("U_FUTesteJob()",,.F.,_aParametros)
// U_JobEnvXml(cEmpAnt, cFilAnt, cSerie, cNota, aXML, cEmail)
// Return

//���������������������������������������������������������Ŀ
//�Trata o sistema operacional linux                        �
//�Quando for linux, deve tratar a letra da unidade como l:\�
//�����������������������������������������������������������

lLinux := (GetRemoteType() == 2)

if (lLinux)
	if !ExistDir("l:\xmlnfe")
		MakeDir("l:\xmlnfe")
	EndIf
	
	CurDir("l:\xmlnfe")
	if !ExistDir("l:\xmlnfe\" + cEmpAnt + cFilAnt)
		MakeDir("l:\xmlnfe\" + cEmpAnt + cFilAnt)
	EndIf

	cFileName := AllTrim(cSerie) + " - " + cNota + ".xml"

	cFile := "l:\xmlnfe\" + cEmpAnt + cFilAnt + "\" + cFileName
	
Else

	if !ExistDir("C:\xmlnfe")
		MakeDir("C:\xmlnfe")
	EndIf
	
	CurDir("C:\xmlnfe")
	if !ExistDir("C:\xmlnfe\" + cEmpAnt + cFilAnt)
		MakeDir("C:\xmlnfe\" + cEmpAnt + cFilAnt)
	EndIf

	cFileName := AllTrim(cSerie) + " - " + cNota + ".xml"

	cFile := "C:\xmlnfe\" + cEmpAnt + cFilAnt + "\" + cFileName
EndIf

//�������������������������������������������������������?
//�Adiciona o layout do protocolo antes da tag xml da nfe�
//�������������������������������������������������������?

cCabProt := '<?xml version="1.0" encoding="UTF-8"?>' + chr(13) + chr(10)

//����������������������������������������������������������������Ĭ
//�se a versao for 2.0 tem que mudar a tag, atualmente deixada fixa�
//����������������������������������������������������������������Ĭ

cCabProt += '<nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.portalfiscal.inf.br/nfe procNFe_v2.00.xsd" versao="2.00">' + chr(13) + chr(10)

cXmlProt := GetXmlCLi(cSerie, cNota) + chr(13) + chr(10)

cFinProt := "</nfeProc>"

cRetorno := cRetorno + chr(13) + chr(10)

//���������������������������������������������������������������������������������������������������Ŀ
//�monta o xml com o cabecalho e finalizacao do protocolo de envio, mesmo sem o protocolo da nfe ainda�
//�����������������������������������������������������������������������������������������������������

cXmlEnv := cCabProt + cRetorno + cXmlProt + cFinProt

//����������������������������������������������������������������Ŀ
//�cria o arquivo no cliente, para deixar uma copia com quem enviou�
//������������������������������������������������������������������

nHdl := FCreate(cFile)
fWrite(nHdl,cXmlEnv,Len(cXmlEnv))
FClose(nHdl)

//�������������������������������Ŀ
//�copia o arquivo para o servidor�
//���������������������������������

cDirServer := "\xmlnfe\" + cEmpAnt + cFilAnt

//�����������������������������(�
//�Cria diretorio por diretorio�
//�����������������������������(�

CurDir("\")
if !ExistDir("\xmlnfe")
	MakeDir("\xmlnfe")
EndIf

CurDir("\xmlnfe")
if !ExistDir(cEmpAnt + cFilAnt)
	MakeDir(cEmpAnt + cFilAnt)
EndIf

if !ExistDir(cDirServer)
	MakeDir(cDirServer)
EndIf

__CopyFile(cFile, cDirServer + "\" + cFileName)

//��������������������������������������������������������������������
//�copia o arquivo para determinada pasta a fim de gerar o xml da NFE�
//��������������������������������������������������������������������

cDirSrv := "\xml_emp50\xml\"
cIdNF := SubStr(NfeIdSPED(cRetorno,"Id"),4)
cFilePdf := cDirSrv + cIdNF + ".xml"
nHdl := FCreate(cFilePdf)
fWrite(nHdl,cXmlEnv,Len(cXmlEnv))
FClose(nHdl)
           
//�����������������������������������������Ŀ
//�aguarda meio segundo at� ser gerado o pdf�
//�������������������������������������������

sleep(1000)

cFilePdf := '\xml_emp50\pdf\' + cIdNF + '.pdf'

if (lLinux)
	cFileLoc := "l:\xmlnfe\" + cEmpAnt + cFilAnt + "\" + AllTrim(cSerie) + " - " + cNota + ".pdf"
else
	cFileLoc := "C:\xmlnfe\" + cEmpAnt + cFilAnt + "\" + AllTrim(cSerie) + " - " + cNota + ".pdf"
EndIf

//���������������������������������,�
//�Copia o PDF para a m�quina local�
//���������������������������������,�

if File(cFilePdf)
	__CopyFile(cFilePdf, cFileLoc)
Else
	Alert("PDF n�o foi gerado. Verifique.")
EndIf 

//������������������������������
//�volta para o antigo diret�rio
//������������������������������

CurDir(cDirAt)

if !Empty(cEmail)
	
	//�������������������������������������0�
	//�Tenta fazer o envio com o uso de SSL�
	//�������������������������������������0�

	cSubject := "Xml referente NF " + AllTrim(cSerie) + " - " + cNota
	
	nHdl := fOpen("\workflow\wfxmlnfe_ssl.htm")
	cBody := FReadStr(nHdl, 999999)
	FClose(nHdl)
	
	cBody := StrTran(cBody, "%DATA%", DTOC(dDataBase))
	cBody := StrTran(cBody, "%EMP%", ALLTRIM(SM0->M0_NOMECOM) + " - " + SM0->M0_FILIAL)
	cBody := StrTran(cBody, "%CLIFORN%", ALLTRIM(cNome))
	cBody := StrTran(cBody, "%NOTA%", AllTrim(cSerie) + " - " + cNota)
	
	aAttach := {}
	aAdd(aAttach,cDirServer + "\" + cFileName)
	
	if File(cFilePdf)
		aAdd(aAttach,cFilePdf)
	EndIf
	
	//������������������Ŀ
	//�Numero do Processo�
	//��������������������
	
	cProcess := OemToAnsi("001010") 
	cStatus  := OemToAnsi("001011")
	
	oProcess := TWFProcess():New(cProcess,OemToAnsi("Envio de XML para Cliente / Fornecedor"))
	oProcess:NewTask(cStatus,"\workflow\wfxmlnfe.htm")
	oProcess:cSubject := OemToAnsi(cSubject)
	oProcess:cTo := ALLTRIM(cEmail)
	
	oProcess:AttachFile (cDirServer + "\" + cFileName)

	//������������������������������
	//�adiciona tamb�m o arquivo pdf�
	//������������������������������
	
	oProcess:AttachFile (cFilePdf)
	
	//�����������������������������������������Ŀ
	//�Preenchimento do cabe�alho da solicita��o�
	//�������������������������������������������
	
	oHTML:= oProcess:oHTML
	
	oHtml:ValByName("DATA"   ,DTOC(dDataBase))
	oHtml:ValByName("EMP"    ,ALLTRIM(SM0->M0_NOMECOM) + " - " + SM0->M0_FILIAL)
	oHtml:ValByName("CLIFORN",ALLTRIM(cNome))
	oHtml:ValByName("NOTA"   ,AllTrim(cSerie) + " - " + cNota)
	oProcess:Start()
	oProcess:Finish()
EndIf

Return

//�������������������������������������������������������������������������������������Ŀ
//�Fun��o para buscar o xlm do protolo do banco sped no email que � destinado ao cliente�
//���������������������������������������������������������������������������������������

Static Function GetXmlCLi(cSerie, cNF)
Local nConSped := 0
Local cXmlCli := ""

//����������������������������������������������������������������������
//�Guilherme 13/08/12 adicionado a porta do Topconnect e IP do servidor �
//����������������������������������������������������������������������

Local cConSped := SuperGetMV("MV_X_SCON", , '{"ORACLE/NFE","192.168.220.5", 7891}')     
Local aConSped := &cConSped
Local cSql := ""
Local cNfSerie := PadL(cSerie, TAMSX3("F2_SERIE")[1]) + cNF
Local aArea := GetArea()
Local cTabela := "SPED054"
Local cAlias := "TMP"

cSql := "SELECT R_E_C_N_O_ RNO FROM SPED054 LEFT JOIN SPED001 ON SPED054.ID_ENT = SPED001.ID_ENT "
cSql += "WHERE SPED001.CNPJ = '" + SM0->M0_CGC + "' AND NFE_ID = '" + cNfSerie +"' AND CSTAT_SEFR = '100' "
cSql += "ORDER BY LOTE DESC FETCH FIRST 1 ROWS ONLY "

TCConType("TCPIP")

nConSped  := TCLink(aConSped[1],aConSped[2],aConSped[3])

If nConSped < 0
	Alert("Falha na conex�o TOPCONN para buscar o xml. Erro " + Alltrim(Str(nCon1)))
	TCUnLink(nConSped)
	RestArea(aArea)
	Return ""
Endif

TCSetConn(nConSped)

BeginSql Alias "TMP054"
  SELECT SPED054.R_E_C_N_O_ RNO FROM SPED054 LEFT JOIN SPED001 ON SPED054.ID_ENT = SPED001.ID_ENT 
  WHERE SPED001.CNPJ = %EXP:SM0->M0_CGC% AND NFE_ID = %EXP:cNfSerie% AND CSTAT_SEFR = '100' 
  ORDER BY LOTE DESC
EndSql

dbSelectArea("TMP054")

nRec := TMP054->RNO

TMP054->(dbCloseArea())

Use &(cTabela) ALIAS &(cAlias) SHARED NEW VIA "TOPCONN"

if Select(cAlias) > 0

	dbSelectArea("TMP")

	TMP->(dbGoTo(nRec))

	cXmlCli := TMP->XML_PROT

	TMP->(dbCloseArea())
EndIf

TCUnLink(nConSped)

RestArea(aArea)

Return cXmlCli