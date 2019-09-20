#INCLUDE "PROTHEUS.CH"                                          
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"

#DEFINE NQTDDIA 365                 // Apenas ser�o mostrados na tela os xmls cuja data_emissao >= (data_atual - NQTDDIA)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MANXMLCTE     �Autor �TOTVS II           Data �  21/10/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina de manuten��o dos arquivos .xml referente ao Ct-e   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�ficos Cantu                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*-------------------------*
User Function MANXMLCTE()  
*-------------------------*                                    

Static oBtnCan
Static oBtnFec
Static oBtnGer
Static oBtnImp
Static oBtnLog
Static oGrpBot
Static oGrpMan
Static oLbCon
Static oLbLeg   
Static oCboSta
Static oBtnVer 

Private oLbSta                             // Label da r�gua de processamento
Private oMtProc                            // Objeto da r�gua de processamento
Private nMtProc  := 0                      // N�mero m�ximo de movimentos da r�gua de processamento
Private oDados                             // Objeto do grid
Private aCpos    := {}                     // Vetor que vai armazenar a propriedade dos campos do grid
Private cTrab    := ""                     // Vari�vel que receber� a estrutura de campos da tab. tempor�ria
Private cIndic   := ""                     // �ndice da tab. tempor�ria
Private aCampos  := {}                     // Armazena as Pictures dos campos
Private aCores   := {}                     // Armazena o vetor de cores
Private lInverte := .F.                    // Indica se a marca��o do grid deve ser invertida 
Private cMarca   := GetMark()
Private oDlgMan
Private oMark
Private lFndXML  := .F. 
Private nCboSta  := '1' 

SetKey(VK_F7 ,{||U_MANPARCTE()})
SetKey(VK_F6 ,{||fLegenda()})
SetKey(VK_F9 ,{||fGrvChv()})
SetKey(VK_F10,{||U_SCHCLACTE(.T.)})   

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������

U_USORWMAKE(ProcName(),FunName())

//�����������������������������������������Ŀ
//�Avalia se o componente do grid j� existe.�
//�������������������������������������������

if Select("TMP_GRID") > 0
	TMP_GRID->(DbCloseArea())
EndIf

aCpos := {}

aAdd(aCpos, {"MARK"    , "C" , 04, 0})
aAdd(aCpos, {"FILIAL"  , "C" , TamSX3("F1_FILIAL" )[01], 0})
aAdd(aCpos, {"ARQUIVO" , "C" , TamSX3("ZBC_FILE"  )[01], 0})
aAdd(aCpos, {"SERIE"   , "C" , TamSX3("F1_SERIE"  )[01], 0})
aAdd(aCpos, {"DOCUMEN" , "C" , TamSX3("F1_DOC"    )[01], 0})
aAdd(aCpos, {"EMISSAO" , "D" , TamSX3("F1_EMISSAO")[01], 0})
aAdd(aCpos, {"FORNECE" , "C" , TamSX3("F1_FORNECE")[01], 0})
aAdd(aCpos, {"LOJA"    , "C" , TamSX3("F1_LOJA"   )[01], 0})
aAdd(aCpos, {"VLTOTAL" , "N" , TamSX3("F1_VALBRUT")[01], TamSX3("F1_VALBRUT")[02]})
aAdd(aCpos, {"VLFRETE" , "N" , TamSX3("F1_FRETE"  )[01], TamSX3("F1_FRETE"  )[02]})
aAdd(aCpos, {"STATUS"  , "C" , TamSX3("ZBC_PROCES")[01], 0})
aAdd(aCpos, {"PESO"    , "N" , TamSX3("ZBC_PESO"  )[01], TamSX3("ZBC_PESO"  )[02]})
aAdd(aCpos, {"VOLUME"  , "N" , TamSX3("ZBC_VOLUME")[01], TamSX3("ZBC_VOLUME")[02]})
aAdd(aCpos, {"CALC"    , "N" , TamSX3("ZBC_CALC  ")[01], TamSX3("ZBC_CALC"  )[02]})
                                                              
cTrab  := CriaTrab(aCpos)
cIndic := CriaTrab(NIL, .F.)

dbUseArea( .T.,,cTrab,"TMP_GRID",.F. )
dbSelectArea("TMP_GRID")
cChave1  := "ARQUIVO"

IndRegua("TMP_GRID",cIndic,cChave1,,,"Selecionando Registros...")
dbSelectArea("TMP_GRID")

aAdd(aCampos, {"FILIAL"  , "", "Filial"     , X3Picture("F1_FILIAL" )})
aAdd(aCampos, {"ARQUIVO" , "", "Nome XML"   , X3Picture("F1_FILE"   )})
aAdd(aCampos, {"SERIE"   , "", "Serie NF"   , X3Picture("F1_SERIE"  )})
aAdd(aCampos, {"DOCUMEN" , "", "Nro. Docum" , X3Picture("F1_DOC"    )})
aAdd(aCampos, {"EMISSAO" , "", "Dt. Emiss"  , X3Picture("F1_EMISSAO")})
aAdd(aCampos, {"FORNECE" , "", "Fornecedor" , X3Picture("F1_FORNECE")})
aAdd(aCampos, {"LOJA"    , "", "Loja"       , X3Picture("F1_LOJA"   )})
aAdd(aCampos, {"VLTOTAL" , "", "Vlr NFe Ori", X3Picture("F1_VALBRUT")})
aAdd(aCampos, {"VLFRETE" , "", "Vlr Frete " , X3Picture("F1_FRETE"  )})
aAdd(aCampos, {"STATUS"  , "", "Status"     , X3Picture("ZBC_PROCES")})
aAdd(aCampos, {"PESO"    , "", "Peso Bruto" , X3Picture("ZBC_PESO"  )})
aAdd(aCampos, {"VOLUME"  , "", "Volume"     , X3Picture("ZBC_VOLUME")})
aAdd(aCampos, {"CALC"    , "", "Frt/Vlr NFe", X3Picture("ZBC_CALC"  )})

aAdd(aCores,{"TMP_GRID->STATUS == '1'" , "BR_BRANCO"   })
aAdd(aCores,{"TMP_GRID->STATUS == '2'" , "BR_LARANJA"    })
aAdd(aCores,{"TMP_GRID->STATUS == '3'" , "BR_VERMELHO" })
aAdd(aCores,{"TMP_GRID->STATUS == '4'" , "BR_AMARELO"  })
aAdd(aCores,{"TMP_GRID->STATUS == '5'" , "BR_CINZA"    })
aAdd(aCores,{"TMP_GRID->STATUS == '6'" , "BR_AZUL"     })
aAdd(aCores,{"TMP_GRID->STATUS == '7'" , "BR_VERDE"})

  DEFINE MSDIALOG oDlgMan TITLE "Manipula��o do Ct-e" FROM 000, 000  TO 500, 1000 COLORS 0, 16777215 PIXEL

    @ 002, 002 GROUP oGrpMan TO 248, 499                                      OF oDlgMan COLOR 0, 16777215 PIXEL
    @ 004, 004 GROUP oGrpBot TO 040, 497 PROMPT "   Bot�es de Manipula��o   " OF oGrpMan COLOR 0, 16777215 PIXEL
    
    @ 235, 313 SAY oLbLeg PROMPT "F6 - Legenda"       SIZE 036, 007 OF oGrpMan COLORS 0, 16777215 PIXEL
    @ 235, 358 SAY oLbCon PROMPT "F7 - Configura��es" SIZE 055, 007 OF oGrpMan COLORS 0, 16777215 PIXEL
    @ 011, 334 SAY oLbSta PROMPT " "                  SIZE 123, 007 OF oGrpMan COLORS 0, 16777215 PIXEL    
    
    oMark := MsSelect():New("TMP_GRID", , , aCampos, @lInverte, cMarca, {042, 004, 229, 497},,,,,aCores)
 		ObjectMethod(oMark:oBrowse,"Refresh()")
 		oMark:oBrowse:bLDblClick := {|| fShowKey(Trim(TMP_GRID->ARQUIVO))}
		oMark:oBrowse:Refresh()
    
    @ 232, 450 BUTTON oBtnFec PROMPT "&Fechar"           SIZE 043, 012 ACTION oDlgMan:End() OF oGrpMan PIXEL
    @ 017, 010 BUTTON oBtnImp PROMPT "Importar XMLs"     SIZE 046, 012 ACTION fImport()     OF oGrpMan PIXEL
    @ 017, 058 BUTTON oBtnGer PROMPT "Gerar Pr�-Nota"    SIZE 045, 012 WHEN fFndXML()                  ACTION fGerPre()     OF oGrpMan PIXEL
    @ 017, 105 BUTTON oBtnCan PROMPT "Cancelar Pr�-Nota" SIZE 056, 012 WHEN (TMP_GRID->STATUS == '2')  ACTION fCanPre(TMP_GRID->FILIAL, TMP_GRID->DOCUMEN, TMP_GRID->SERIE,; 
    																																																									TMP_GRID->FORNECE, TMP_GRID->LOJA, Trim(TMP_GRID->ARQUIVO))    OF oGrpMan PIXEL
    @ 017, 164 BUTTON oBtnLog PROMPT "Detalhes "         SIZE 045, 012 WHEN (TMP_GRID->STATUS $ '3/4') ACTION fLogPro(Trim(TMP_GRID->ARQUIVO)) OF oGrpMan PIXEL
    @ 017, 211 BUTTON oBtnVer PROMPT "Ver Depois "       SIZE 045, 012 WHEN (TMP_GRID->STATUS $ '1/3/5/6') ACTION fVerDep(Trim(TMP_GRID->ARQUIVO)) OF oGrpMan PIXEL
    @ 017, 258 BUTTON oBtnPrc PROMPT "Proc Individ "     SIZE 045, 012 WHEN (TMP_GRID->STATUS $ '1/4') ACTION fPrcMan(Trim(TMP_GRID->ARQUIVO)) OF oGrpMan PIXEL
    
    @ 021, 334 METER oMtProc VAR nMtProc SIZE 151, 008 OF oGrpMan TOTAL 100 NOPERCENTAGE COLOR 0, 16777215 PIXEL 
    
    @ 232, 017 MSCOMBOBOX oCboSta VAR nCboSta ITEMS {"1=Nao Iniciado","2=Pr�-nota gerada","3=Erro Proc",; 
    																								 "4=Ver Depois", "5=Pr�-Nota Cancel","6=Evento Processado",; 
    																								 "7=Pr�-nota classificada", "8=Todos"} SIZE 071, 010 OF oGrpMan ON CHANGE fDados() COLORS 0, 16777215 PIXEL

    fDados()
    
  ACTIVATE MSDIALOG oDlgMan CENTERED

Return                                                             

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fShowKey �Autor  �TOTVS II           � Data �  07/05/15     ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o criada para retornar Chave do Ct-e                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MANXMLCTE                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

*----------------------------*
Static Function fShowKey(cFile)
*----------------------------*

Local cChvCte := ""
Local oXML         

Private cAviso := ""
Private cErro  := ""

DbSelectArea("ZBC")
ZBC->(DbSetOrder(2))
If ZBC->(DbSeek(xFilial("ZBC") + cFile))
	
	oXML := XMLParser(AnsiToOem(ZBC->ZBC_XML), "_", @cAviso, @cErro)
		
	if ValType(oXML) == "O"
		if Alltrim(Upper(XMLGetChild(oXML, 1):REALNAME)) != "PROCEVENTOCTE"
			cChvCte := oXML:_cteproc:_protcte:_infprot:_chcte:text
		Else
			MsgAlert("XML REFERENTE A UM EVENTO. SOMENTE PODERAO SER CONSULTADOS CHAVES DE XMLS DE CTE.")
		EndIf
		
	Else
		
		MsgAlert("ARQUIVO "+ Trim(aXMLs[nX][01]) +" => O XML POSSUI CARACTERES ESPECIAIS. NAO SERA POSSIVEL PROCESSA-LO!")
			
	EndIf		
EndIf

if !Empty(cChvCte)
	Aviso("Chave do Ct-e", cChvCte, {"Ok"}, 3)
EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fPrcMan �Autor  �TOTVS II           � Data �  25/02/15      ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para processar individualmente cada XML             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MANXMLCTE                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*------------------------------*
Static Function fPrcMan(cFile)
*------------------------------*

Local aArea  := GetArea()
Local nCtrl  := 0
Local aXMLs  := {}
Local lOk    := .F.
Local cAviso := ""
Local cErro  := ""
Local oXML   

Private aCabec := {}          	// vetor com cabe�alho da pr�-nota
Private aItens := {}          	// vetor de itens da pr�-nota
Private aLinha := {}        	// vetor da linha do item 
Private lOk    := {}				// indica se o processo de inclus�o de pr�-nota foi completado com sucesso
Private aErros := {}          	// vari�vel que armazena as inconsist�ncias encontradas durante os processos
Private aXMLs  := {}          	// vetor com os xmls a serem processados
Private aResErr  := {}        	// vetor com o resumo das inconsist�ncias
Private aResAce  := {}        	// Vetor com o resumo das opera��es que conclu�ram

If MsgYesNo("Deseja processar manualmente arquivo "+ cFile +" ?", "Aten��o!")
	
	//���������������������������������������������������������������������������Ŀ
	//�Valida exist�ncia de par�metros da rotina antes de iniciar o processamento.�
	//�����������������������������������������������������������������������������
	
	DbSelectArea("ZBA")
	ZBA->(DbSetOrder(1))
	If !ZBA->(DbSeek(xFilial("ZBA") + cEmpAnt + cFilAnt))
		MsgInfo("A aplica��o encontrou um problema: n�o foi poss�vel encontrar os par�metros da rotina!" + CHR(13)+CHR(10) +;
						"Solu��o: Antes de iniciar, cadastre os par�metros necess�rios atrav�s do bot�o F7.")
		Return          
	EndIf 

	DbSelectArea("ZBC")
	ZBC->(DbSetOrder(2))
	If ZBC->(DbSeek(xFilial("ZBC") + cFile))
		
		aAdd(aXMLs, {ZBC->ZBC_FILE, ZBC->ZBC_XML, ZBC->(Recno())})	
		oMtProc:SetTotal(Len(aXMLs))     // Seta o tamanho da r�gua
		
		nCtrl++
		oMtProc:Set(nCtrl)
		oLbSta:SetText("Processando XML final ..."+ SubStr(Trim(aXMLs[01][01]), Len(Trim(aXMLs[01][01])) - 15, 16))
		oDlgMan:CommitControls()
		
		//fClear(aXMLs[01][02])
		aXMLs[01][02] := fClear(aXMLs[01][02])
		
		oXML := XMLParser(AnsiToOem(aXMLs[01][02]), "_", @cAviso, @cErro)
		
		if ValType(oXML) == "O"
    	
    	lEveCan := .F.
			lCancel := .F.
		
			//�������������������������������������������������������Ŀ
			//�Valida se o XML � referente a um evento de cancelamento�
			//���������������������������������������������������������
			
			if Alltrim(Upper(XMLGetChild(oXML, 1):REALNAME)) == "PROCEVENTOCTE"
				lEveCan := oXML:_procEventoCte:_eventoCte:_infEvento:_tpEvento:TEXT == '110111'    // 110111 - Evento de cancelamento (Manual Ct-e 2.0)
			EndIf
			
			oLbSta:SetText(iif(lEveCan, "Cancelando", "Gerando") +" pr�-nota XML final ..."+ SubStr(Trim(aXMLs[01][01]), Len(Trim(aXMLs[01][01])) - 15, 16))
			oDlgMan:CommitControls()		
		
			//�������������������������������������������Ŀ
			//�Chama a fun��o de importa��o do arquivo XML�
			//���������������������������������������������
			
			If lEveCan
				
				cChvCte := oXML:_procEventoCte:_eventoCte:_infEvento:_chCte:text
	
				if !Empty(cChvCte)
				  DBSelectArea("ZBC")
				  ZBC->(DbSetOrder(4))
				  If DbSeek(xFilial("ZBC") + cChvCte)
				  	If ZBC->ZBC_PROCES == '2'
				  		lCancel := fCanPre(ZBC->ZBC_CODFIL, ZBC->ZBC_DOC, ZBC->ZBC_SERIE, ZBC->ZBC_FORNECE, ZBC->ZBC_LOJA, Trim(ZBC->ZBC_FILE))	
				  	Else
				  		lCancel := .T.
				  	EndIf
				  	ZBC->(Recno())
				  Else
				  	Aviso("Ct-e n�o encontrado", "O Ct-e de origem contendo a chave "+ Trim(cChvCte) +" n�o foi encontrado! ", {"Ok"}, 3)
				  EndIf
				EndIf
				
			Else
				lOk := fExecXML(oXML, Trim(aXMLs[01][01]))
			EndIf
			
			if lOk
				DbSelectArea("ZBC")
				ZBC->(DbGoTo(aXMLs[01][03]))
	
				RecLock("ZBC", .F.)
				ZBC->ZBC_PROCES := '2'	
				ZBC->(MsUnlock())
			
			ElseIf lCancel
				
				DbSelectArea("ZBC")
				ZBC->(DbGoTo(aXMLs[nX][03]))
	
				RecLock("ZBC", .F.)
				ZBC->ZBC_PROCES := '6'	
				ZBC->(MsUnlock())
				
				ZBC->(DbGoTo(nRecCte))
				RecLock("ZBC", .F.)
				ZBC->ZBC_PROCES := '5'	
				ZBC->(MsUnlock())
					
			EndIf
			
  	Else
  		MsgAlert("ARQUIVO "+ Trim(aXMLs[01][01]) +" => O XML POSSUI CARACTERES ESPECIAIS. NAO SERA POSSIVEL PROCESSA-LO!")
		EndIf
			
	EndIf		
EndIf

fDados()

oMtProc:Set(0)
oLbSta:SetText(" ")
oDlgMan:CommitControls()

cResAce := ""                                                   
cResErr := ""

If Len(aResErr) > 0
	For i := 1 to Len(aResErr)
		cResErr += aResErr[i] + CHR(13)+CHR(10) + Replicate("-", 100) + CHR(13)+CHR(10)
	Next i	
	Aviso("Resumo de Inconsist�ncias", cResErr, {"Ok"}, 3)
	cResErr := ""
	aResErr := {}
EndIf

//��������������������������������Ŀ
//�Mensagem para resumo dos acertos�
//����������������������������������

If Len(aResAce) > 0
	For j := 1 to Len(aResAce)
		cResAce += aResAce[j] + CHR(13)+CHR(10)
	Next j                                  
	Aviso("Resumo de XMLs processados com sucesso", cResAce, {"Ok"}, 3)
	cResAce := ""
	aResAce := {}
EndIf

RestArea(aArea)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fVerDep �Autor  �TOTVS II           � Data �  25/02/15      ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o criada para mudar status do registro para '4'       ���
���          � (Ver Depois)                                               ���
�������������������������������������������������������������������������͹��
���Uso       � MANXMLCTE                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function fVerDep(cFile)

Local aArea := GetArea()

DbSelectArea("ZBC")
ZBC->(DbSetOrder(2))
If ZBC->(DbSeek(xFilial("ZBC") + cFile)) 
	RecLock("ZBC", .F.)
	ZBC->ZBC_PROCES := '4'
	ZBC->(MsUnlock())
EndIf

fDados()

oMtProc:Set(0)
oLbSta:SetText(" ")
oDlgMan:CommitControls()

RestArea(aArea)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fFndXML �Autor  �TOTVS II              � Data �  06/01/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o criada para retornar se existem XMLs a serem        ���
���          � processados na tabela ZBC                                  ���
�������������������������������������������������������������������������͹��
���Uso       � MANXMLCTE                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function fFndXML()

Local lRet := .F.

DbSelectArea("ZBC")                    	
ZBC->(DbSetOrder(3))
lRet := ZBC->(DbSeek(xFilial("ZBC") + cEmpAnt + cFilAnt + '1'))

Return lRet

//���������������������������������������������������Ŀ
//�Fun��o respons�vel por fazer a exclus�o da pr�-nota�
//�����������������������������������������������������
*------------------------*
Static Function fCanPre(cFilXML, cDoc, cSerie, cFornece, cLoja, cFile)
*------------------------*

Local cChave  := cFilXML + cDoc + cSerie + cFornece + cLoja
Local nRecSF1 := 0
Local aRecSD1 := {}
Local lExclui := .T.
Local lRet    := .F.
Local nX      := 0

DbSelectArea("SF1")
SF1->(DbSetOrder(1))
If SF1->(DbSeek(cChave))
	nRecSF1 := SF1->(Recno())
	
	If !MsgYesNo("Deseja realmente excluir a pr�-nota?","Aten��o!")
		Return
	EndIf
	
	DbSelectArea("SD1")
	SD1->(DbSetOrder(1))
	if SD1->(DbSeek( cChave )) 
		While !SD1->(EOF()) .and. SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == cChave .and. lExclui
      If Empty(SD1->D1_TES)
      	aAdd(aRecSD1, SD1->(Recno()))
      Else
      	Alert("Imposs�vel excluir a pr�-nota! O documento j� se encontra classificado.")
      	lExclui :=.F.
      EndIf
			SD1->(DbSkip())
		EndDo
	EndIf
	
	If lExclui
	
		//����������������������������Ŀ
		//�Exclui os itens da pr�-nota.�
		//������������������������������
	
		For nX := 1 to Len(aRecSD1) 
			SD1->(DbGoTo(aRecSD1[nX]))
			RecLock("SD1", .F.)
			SD1->(DbDelete())
			SD1->(MsUnlock())
		Next nX           
	
		//����������������������������������������H
		//�Deleta cabe�alho da pr�-nota de entrada�
		//�����������������������������������������
		
		DbSelectArea("SF1")
		SF1->(DbGoTo(nRecSF1))
		RecLock("SF1", .F.)
		SF1->(DbDelete())
		SF1->(MsUnlock())
		
		//���������������������������������Ŀ
		//�Volta status do XML na tabela ZBC�
		//�����������������������������������
		
		DbSelectArea("ZBC")
		ZBC->(DbSetOrder(2))
		If ZBC->(DbSeek(xFilial("ZBC") +cFile))
			RecLock("ZBC", .F.)
			ZBC->ZBC_PROCES := '1'
			ZBC->(MsUnlock())
		EndIf
		
		lRet := .T.
		                                      
		Aviso("Documento exclu�do!","Exclus�o de pr�-nota efetuada com sucesso!" +CHR(13)+CHR(10)+;
																PADR("Filial"    , 20, ".")+": "+ cFilXML    +CHR(13)+CHR(10)+;
																PADR("Documento" , 20, ".")+": "+ cDoc       +CHR(13)+CHR(10)+;
																PADR("Serie"     , 20, ".")+": "+ cSerie     +CHR(13)+CHR(10)+;
																PADR("Fornecedor", 20, ".")+": "+ cFornece   +CHR(13)+CHR(10)+;
																PADR("Loja"      , 20, ".")+": "+ cLoja      , {"Ok"}, 3)
		
	EndIf
	
Else
	Alert("N�o foi poss�vel localizar pr�-nota com os dados abaixo: "  +CHR(13)+CHR(10)+;
												PADR("Filial"    , 20, ".")+": "+ cFilXML    +CHR(13)+CHR(10)+;
												PADR("Documento" , 20, ".")+": "+ cDoc       +CHR(13)+CHR(10)+;
												PADR("Serie"     , 20, ".")+": "+ cSerie     +CHR(13)+CHR(10)+;
												PADR("Fornecedor", 20, ".")+": "+ cFornece   +CHR(13)+CHR(10)+;
												PADR("Loja"      , 20, ".")+": "+ cLoja) 
EndIf

fDados()

oMtProc:Set(0)
oLbSta:SetText(" ")
oDlgMan:CommitControls()
	
Return lRet  

//������������������������������������������������������������Ŀ
//�Fun��o respons�vel por mostrar o log de processamento do XML�
//��������������������������������������������������������������
*----------------------*
Static Function fLogPro(cFile)
*----------------------*

Default cFile := "" 

Static oMemo            
Static oBtnClose
Static oDlgXML

Private cErro := ""

If Empty(cFile)

	MsgAlert("Clique em uma linha para depois visualizar os logs!")
	Return

Else
	
	DbSelectArea("ZBC")
	DbSetOrder(2)
	DbSeek(xFilial("ZBC") + cFile)
	cErro := AnsiToOem(ZBC->ZBC_LOG)                   
	
EndIf
  
	DEFINE MSDIALOG oDlgXML TITLE "Erros de integra��o do Ct-e " FROM 000,000 TO 500,900 COLORS 0,16777215 PIXEL
	@ 015,015 GET oMemo VAR cErro MEMO SIZE 420,200 OF oDlgXML PIXEL READONLY
	@ 220,380 BUTTON oBtnClose PROMPT "&Fechar"  SIZE 056, 013 OF oDlgXML ACTION Close(oDlgXML) PIXEL
	
	ACTIVATE MSDIALOG oDlgXML CENTERED
	
Return

//��������������������������������������������������������������
//�Fun��o respons�vel por mostrar o Browse das legendas de cores
//�������������������������������������������������������������� 

*--------------------------*
Static Function fLegenda()
*--------------------------*

Local cTitulo := OemtoAnsi("Legenda")
Local aCores	:= {	{ 'BR_BRANCO' 	, "Processo n�o iniciado"  		},;
										{ 'BR_LARANJA'  , "Pr�-nota gerada"	          },;
										{ 'BR_VERMELHO'	, "Erro de processamento"  		},;
										{ 'BR_AMARELO'  , "Verificar depois"          },;
										{ 'BR_CINZA'    , "Ct-e Cancelado"            },;
										{ 'BR_AZUL'     , "Evento Executado"          },;
										{ 'BR_VERDE'    , "Pr�-nota classificada"     }}											
												
BrwLegenda(cTitulo, "Legenda", aCores)

Return

//���������������������������������������������������������������������Ŀ
//�Fun��o respons�vel por abrir o XML e realizar a gera��o das pr�-notas�
//�����������������������������������������������������������������������
*------------------------*
Static Function fGerPre()
*------------------------*

Local oXml 
local cErro  := ""
local cAviso := ""                                            
local lOK    := .F.
Local cTemp  := ""
Local cQuery := ""
Local nQuant := 0
Local nCtrl  := 0                                                     
Local nX     := 0
Local i      := 0

Private aCabec := {}          // vetor com cabe�alho da pr�-nota
Private aItens := {}          // vetor de itens da pr�-nota
Private aLinha := {}          // vetor da linha do item 
Private lOk    := {}					// indica se o processo de inclus�o de pr�-nota foi completado com sucesso
Private aErros := {}          // vari�vel que armazena as inconsist�ncias encontradas durante os processos
Private aXMLs  := {}          // vetor com os xmls a serem processados
Private aResErr  := {}        // vetor com o resumo das inconsist�ncias
Private aResAce  := {}        // Vetor com o resumo das opera��es que conclu�ram

//���������������������������������������������������������������������������Ŀ
//�Valida exist�ncia de par�metros da rotina antes de iniciar o processamento.�
//�����������������������������������������������������������������������������

DbSelectArea("ZBA")
ZBA->(DbSetOrder(1))
If !ZBA->(DbSeek(xFilial("ZBA") + cEmpAnt + cFilAnt))
	MsgInfo("A aplica��o encontrou um problema: n�o foi poss�vel encontrar os par�metros da rotina!" + CHR(13)+CHR(10) +;
					"Solu��o: Antes de iniciar, cadastre os par�metros necess�rios atrav�s do bot�o F7.")
	Return          
EndIf

DbSelectArea("ZBC")
ZBC->(DBGoTop())
ZBC->(DbSetOrder(3))
If ZBC->(DbSeek(xFilial("ZBC") + cEmpAnt + cFilAnt + '1'))
	
	While !ZBC->(EOF()) .and. (ZBC->ZBC_FILIAL + ZBC->ZBC_CODEMP + ZBC->ZBC_CODFIL + ZBC->ZBC_PROCES == xFilial("ZBC") + cEmpAnt + cFilAnt + '1' )
	
		aAdd(aXMLs, {ZBC->ZBC_FILE, ZBC->ZBC_XML, ZBC->(Recno())})
 		ZBC->(DbSkip())

	EndDo
	
	oMtProc:SetTotal(Len(aXMLs))     // Seta o tamanho da r�gua
	
	For nX := 1 to Len(aXMLs)
		
		nCtrl++
		oMtProc:Set(nCtrl)
		oLbSta:SetText("Processando XML final ..."+ SubStr(Trim(aXMLs[nX][01]), Len(Trim(aXMLs[nX][01])) - 15, 16))
		oDlgMan:CommitControls()
		
		aXMLs[nX][02] := fClear(aXMLs[nX][02])
		
		oXML := XMLParser(AnsiToOem(aXMLs[nX][02]), "_", @cAviso, @cErro)
		
		if ValType(oXML) == "O"		
		  
			lEveCan := .F.
			lCancel := .F.
			nRecCte := 0
		
			//�������������������������������������������������������Ŀ
			//�Valida se o XML � referente a um evento de cancelamento�
			//���������������������������������������������������������
			
			if Alltrim(Upper(XMLGetChild(oXML, 1):REALNAME)) == "PROCEVENTOCTE"
				lEveCan := oXML:_procEventoCte:_eventoCte:_infEvento:_tpEvento:TEXT == '110111'    // 110111 - Evento de cancelamento (Manual Ct-e 2.0)
			EndIf
			
    	oLbSta:SetText(iif(lEveCan, "Cancelando", "Gerando") +" pr�-nota XML final ..."+ SubStr(Trim(aXMLs[nX][01]), Len(Trim(aXMLs[nX][01])) - 15, 16))
			oDlgMan:CommitControls()
		
			//�������������������������������������������Ŀ
			//�Chama a fun��o de importa��o do arquivo XML�
			//���������������������������������������������
			
			If lEveCan
				
				cChvCte := oXML:_procEventoCte:_eventoCte:_infEvento:_chCte:text
	
				if !Empty(cChvCte)
				  DBSelectArea("ZBC")
				  ZBC->(DbSetOrder(4))
				  If DbSeek(xFilial("ZBC") + cChvCte)
				  	If ZBC->ZBC_PROCES == '2'
				  		lCancel := fCanPre(ZBC->ZBC_CODFIL, ZBC->ZBC_DOC, ZBC->ZBC_SERIE, ZBC->ZBC_FORNECE, ZBC->ZBC_LOJA, Trim(ZBC->ZBC_FILE))	
				  	Else
				  		lCancel := .T.
				  	EndIf
				  	nRecCte := ZBC->(Recno())
				  Else
				  	Aviso("Ct-e n�o encontrado", "O Ct-e de origem contendo a chave "+ Trim(cChvCte) +" n�o foi encontrado! ", {"Ok"}, 3)
				  EndIf
				EndIf
				
			Else
				lOk := fExecXML(oXML, Trim(aXMLs[nX][01]))
			EndIf
			
			if lOk
			
				DbSelectArea("ZBC")
				ZBC->(DbGoTo(aXMLs[nX][03]))
	
				RecLock("ZBC", .F.)
				ZBC->ZBC_PROCES := '2'	
				ZBC->(MsUnlock())
			
			ElseIf lCancel
				
				DbSelectArea("ZBC")
				ZBC->(DbGoTo(aXMLs[nX][03]))
	
				RecLock("ZBC", .F.)
				ZBC->ZBC_PROCES := '6'	
				ZBC->(MsUnlock()) 
				
				ZBC->(DbGoTo(nRecCte))
				RecLock("ZBC", .F.)
				ZBC->ZBC_PROCES := '5'	
				ZBC->(MsUnlock())
					
			EndIf
			
  	Else
  		MsgAlert("ARQUIVO "+ Trim(aXMLs[nX][01]) +" => O XML POSSUI CARACTERES ESPECIAIS. NAO SERA POSSIVEL PROCESSA-LO!")
		EndIf
			
	Next nX 

Else
	MsgInfo("N�o h� XMLs a serem processados!")			
EndIf

fDados()

oMtProc:Set(0)
oLbSta:SetText(" ")
oDlgMan:CommitControls()

cResAce := ""                                                   
cResErr := ""

If Len(aResErr) > 0
	For i := 1 to Len(aResErr)
		cResErr += aResErr[i] + CHR(13)+CHR(10)
	Next i	
	Aviso("Resumo de Inconsist�ncias", cResErr, {"Ok"}, 3)
	cResErr := ""
	aResErr := {}
EndIf

//��������������������������������Ŀ
//�Mensagem para resumo dos acertos�
//����������������������������������

If Len(aResAce) > 0
	For j := 1 to Len(aResAce)
		cResAce += aResAce[j] + CHR(13)+CHR(10)
	Next j                                  
	Aviso("Resumo de XMLs processados com sucesso", cResAce, {"Ok"}, 3)
	cResAce := ""
	aResAce := {}
EndIf

Return

//����������������������������������������������������Ŀ
//�Fun��o que executa o processo de importa��o dos XMLs�
//������������������������������������������������������

*------------------------*
Static Function fImport()
*------------------------*

local aFiles  := {}       // arquivos encontrados no diret�rio
Local aSize   := {}       // vari�vel com os tamanhos de arquivos
Local cDiret  := ""       // diret�rio onde est�o os XMLs
Local nTaman  := 0        // tamanho do arquivo em bytes
Local cBuffer := ""       // conte�do do XML
Local nImport := 0        // n�mero de arquivos importados
Local nAtual  := 0        // n�mero de arquivos atualizados  

Private oXML
Private cAviso := ""
Private cErro  := ""
Private lAuto  := .F.

//���������������������������������������������������������������������������Ŀ
//�Valida exist�ncia de par�metros da rotina antes de iniciar o processamento.�
//�����������������������������������������������������������������������������

DbSelectArea("ZBA")
ZBA->(DbSetOrder(1))
If ZBA->(DbSeek(xFilial("ZBA") + cEmpAnt + cFilAnt))
	lAuto := ZBA->ZBA_GERPRE == '1'
Else
	MsgInfo("A aplica��o encontrou um problema: n�o foi poss�vel encontrar os par�metros da rotina!" + CHR(13)+CHR(10) +;
					"Solu��o: Antes de iniciar, cadastre os par�metros necess�rios atrav�s do bot�o F7.")
	Return          
EndIf

//����������������������������������������������������������������������eri�t�
//�Valida a exist�ncia do diret�rio especificado no par�metro da rotina �
//����������������������������������������������������������������������eri�t�

if !ExistDir(Trim(ZBA->ZBA_DIRORI))
	MsgInfo("A pasta "+ Trim(ZBA->ZBA_DIRORI) +" configurada nos par�metros da rotina n�o existe. Verifique a configura��o atrav�s do bot�o F7.")
	Return
Else
	cDiret := Trim(ZBA->ZBA_DIRORI)
EndIf

aFiles := {}

ADir(cDiret + "*.xml", aFiles, aSize )

//���������������������������������������A�
//�Avalia se existe arquivos no diret�rio�
//���������������������������������������A�

If Len(aFiles) > 0
	
	oMtProc:SetTotal(Len(aFiles))  

	For nX := 1 to Len(aFiles)
	  oMtProc:Set(nX)
		oLbSta:SetText("Processando arquivo "+ aFiles[nX])
		oDlgMan:CommitControls()
	  
		//�������������������������������������������������������������Ŀ
		//�Testa a abertura do arquivo XML antes de iniciar a importa��o�
		//���������������������������������������������������������������
		
	  nHdl := fOpen(cDiret + Trim(aFiles[nX]), 0)
	  if nHdl == -1
	  	MsgAlert("N�o foi poss�vel fazer a leitura do arquivo "+ aFiles[nX] +" :( " )
	  	fClose(nHdl)
	  	Loop
	  Else 
	  
	    cBuffer := ""
	  	nTaman  := fSeek(nHdl,0,FS_END)
	  	fseek(nHdl,0,FS_SET)
	  	fRead(nHdl,@cBuffer,nTaman)
	  	
	  	oXML := XMLParser(cBuffer, "_", @cAviso, @cErro)
      
			aRetEmp := {}
	  
			//���������������������������������������������8�
			//�Valida se o XML � de um Ct-e ou de um evento�
			//���������������������������������������������8�
			
	  	if AllTrim(Upper(XMLGetChild(oXML, 1):REALNAME)) == "CTEPROC" 
	    	lEvento := .F.
	    	aRetEmp := fGetRem(lEvento)
		  	If Len(aRetEmp) > 0
			  	cEmpDes := aRetEmp[01]
			  	cFilDes := aRetEmp[02]
			  Else
			  	MsgAlert( Trim(aFiles[nX])+ " => ERRO! REMETENTE DO FRETE NAO E NENHUMA FILIAL DA CANTU.")
		  		Loop	
			  EndIf
	  	
	  	ElseIf Alltrim(Upper(XMLGetChild(oXML, 1):REALNAME)) == "PROCEVENTOCTE"
      	
      	lEvento := .T.
    
				//�������������������������������������0�
				//�Valida se o evento � de cancelamento�
				//�������������������������������������0�
				
      	If oXML:_procEventoCte:_eventoCte:_infEvento:_tpEvento:TEXT == '110111'    // 110111 - Evento de cancelamento (Manual Ct-e 2.0)
      	
	      	aRetEmp := fGetRem(lEvento)
	      	If Len(aRetEmp) > 0
				  	cEmpDes := aRetEmp[01]
				  	cFilDes := aRetEmp[02]
				  Else
			  		Loop	
				  EndIf
				  
				EndIf
			EndIf
	  	
	  	DbSelectArea("ZBC")
	  	DbSetOrder(2)
	  	If DbSeek(xFilial("ZBC") + Trim(aFiles[nX]))
	  		if MsgYesNo("O arquivo "+ Trim(aFiles[nX]) +" j� foi importado. Deseja import�-lo novamente?", "Registro encontrado!")
		  		RecLock("ZBC", .F.)
		  		ZBC->ZBC_FILIAL := xFilial("ZBC")
		  		ZBC->ZBC_CODEMP := cEmpDes
		  		ZBC->ZBC_CODFIL := cFilDes
		  		ZBC->ZBC_FILE   := Trim(aFiles[nX])
		  		ZBC->ZBC_LOCAL  := cDiret
		  		ZBC->ZBC_XML    := OemToAnsi(Iif(SubStr(cBuffer, 01, 03) == '﻿', SubStr(cBuffer, 04), cBuffer))
		  		ZBC->ZBC_PROCES := '1'
		  		ZBC->(MsUnlock())
		  		nAtual++
	  		EndIf
	  	Else
	  		RecLock("ZBC", .T.)
		  		ZBC->ZBC_FILIAL := xFilial("ZBC")
		  		ZBC->ZBC_CODEMP := cEmpDes
		  		ZBC->ZBC_CODFIL := cFilDes
		  		ZBC->ZBC_FILE   := Trim(aFiles[nX])
		  		ZBC->ZBC_LOCAL  := cDiret
		  		ZBC->ZBC_XML    := OemToAnsi(Iif(SubStr(cBuffer, 01, 03) == '﻿', SubStr(cBuffer, 04), cBuffer))
		  		ZBC->ZBC_PROCES := '1'
	  		ZBC->(MsUnlock())  
	      nImport++
	  	EndIf
	  	
	  	fClose(nHdl)                      // Fecha XML ap�s importa��o
	  	fErase(cDiret + Trim(aFiles[nX])) // Deleta XML ap�s importa��o
	  	
	  EndIf
	  
	Next Nx
	
	Aviso("Resumo", AllTrim(cValToChar(nAtual))  +" arquivos atualizados."+ CHR(13)+CHR(10) +;
									AllTrim(cValToChar(nImport)) +" arquivos inclu�dos. ", {"Ok"}, 2)
	
Else
	MsgInfo("Nenhum arquivo encontrado no diret�rio "+ cDiret +" com extens�o .xml " )
	Return
EndIf                                                                                   

//����������������������������������������������������������������������o
//�Caso o par�metro esteja habilitado, processa automaticamente os xmls.�
//����������������������������������������������������������������������o

If lAuto
	If MsgYesNo("Deseja fazer o processamento dos XMLs pendentes? ", "Aten��o!")
		fGerPre()
	EndIf
EndIf

fDados()

oMtProc:Set(0)
oLbSta:SetText(" ")
oDlgMan:CommitControls()
                                                                                                                  
Return 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fGetDes �Autor  �TOTVS II              � Data �  22/01/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para buscar Empresa e Filial Emitente.              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function fGetRem(lEvento)

Local aRet    := {}
Local aArea   := SM0->(GetArea())
Local cCgcRem := ""
Local cSql    := ""
Local cChvCte := ""

//�����������������������������������������������������������������L�
//�Avalia se o xml � um evento para saber de onde deve pegar o xml.�
//�����������������������������������������������������������������L�

if lEvento
	
	cChvCte := oXML:_procEventoCte:_eventoCte:_infEvento:_chCte:text
	
	if !Empty(cChvCte)
	  DBSelectArea("ZBC")
	  ZBC->(DbSetOrder(4))
	  
	  If DbSeek(xFilial("ZBC") + cChvCte)
	  	aRet := {ZBC->ZBC_CODEMP, ZBC->ZBC_CODFIL}
	  	
	  	RestArea(aArea)
	  	Return aRet
	  Else
	  	Aviso("Origem n�o encontrada","O CT-e de chave "+ cChvCte +" n�o foi importado atrav�s dessa rotina! "+; 
	  	      "A exclus�o da pr�-nota dever� ser feita manualmente.", {"Ok"}, 3)
	  	RestArea(aArea)
	  	Return aRet	
	  EndIf
	  
	EndIf
Else
	cCgcRem := oXML:_cteproc:_cte:_infcte:_rem:_cnpj:text
EndIf

DbSelectArea("SM0")
SM0->(DbSetOrder(1))
SM0->(DbGoTop())
While !SM0->(EOF())
	If Trim(SM0->M0_CGC) == AllTrim(cCgcRem)
		aRet := {SM0->M0_CODIGO, SM0->M0_CODFIL}
		Exit
	EndIf
	SM0->(DbSkip())	
EndDo

RestArea(aArea)

Return aRet

//�������������������������������������
//�Fun��o de montagem dos dados do grid�
//�������������������������������������

*------------------------*
Static Function fDados(nExec)
*------------------------*

Local cSql    := ""
Local aArea   := GetArea()

Default nExec := 2

//��������������������������������������������������������������������������Ŀ
//�Elimina todo o conte�do do grid antes de buscar as informa��es atualizadas�
//����������������������������������������������������������������������������

DbSelectArea("TMP_GRID")
TMP_GRID->(DbGoTop())
Do While !TMP_GRID->(Eof())
	RecLock("TMP_GRID",.F.)
	DbDelete()
	MsUnlock() 
	TMP_GRID->(DbSkip())
Enddo

//������������������������������������������������������������Ŀ
//�Buscando os xmls cujos processos ainda n�o foram finalizados�
//��������������������������������������������������������������

cSql := "select zbc.zbc_codfil, zbc.zbc_file, zbc.zbc_proces, zbc.zbc_serie, zbc.zbc_doc, zbc.zbc_emissa, "
cSql += "       zbc.zbc_fornec, zbc.zbc_loja, zbc.zbc_vltot, zbc.zbc_vlfre, zbc.zbc_peso, zbc.zbc_volume, "
cSql += "       zbc.zbc_calc from "+ RetSqlName("ZBC") +" zbc "
cSql += "where zbc.zbc_filial = '"+ xFilial("ZBC") +"' "
cSql += "  and zbc.zbc_codemp = '"+ cEmpAnt +"' "
cSql += "  and zbc.zbc_codfil = '"+ cFilAnt +"' "
cSql += "  and (zbc.zbc_emissa = '        ' or zbc.zbc_emissa >= '"+ DtoS(Date() - NQTDDIA) +"') "

If nCboSta != '8'
	cSql += "   and zbc.zbc_proces = '"+ nCboSta +"' "
EndIf

cSql += "  and zbc.d_e_l_e_t_ = ' ' "

TcQuery cSql New Alias "tmpctes"

DbSelectArea("tmpctes")
tmpctes->(DbGoTop())

//��������������������������������������Ŀ
//�Avalia se o retorno da busca for vazia�
//����������������������������������������

If tmpctes->(eof())

	If nExec == 2
		TMP_GRID->(DbGoTop())
		ObjectMethod(oMark:oBrowse,"Refresh()")
		oDlgMan:Refresh()
	EndIf
  RestArea(aArea)
	tmpctes->(DbCloseArea())
	Return
EndIf

While !tmpctes->(EOF())
	
	DbSelectArea("TMP_GRID")
	
	RecLock("TMP_GRID", .T.)                 

	TMP_GRID->MARK     := "  "
	TMP_GRID->FILIAL   := tmpctes->zbc_codfil
	TMP_GRID->ARQUIVO  := tmpctes->zbc_file
	TMP_GRID->SERIE    := tmpctes->zbc_serie
	TMP_GRID->DOCUMEN  := tmpctes->zbc_doc
	TMP_GRID->EMISSAO  := StoD(tmpctes->zbc_emissa)
	TMP_GRID->FORNECE  := tmpctes->zbc_fornec
	TMP_GRID->LOJA     := tmpctes->zbc_loja
	TMP_GRID->VLTOTAL  := tmpctes->zbc_vltot
	TMP_GRID->VLFRETE  := tmpctes->zbc_vlfre
	TMP_GRID->STATUS   := tmpctes->zbc_proces
	TMP_GRID->PESO     := tmpctes->zbc_peso
	TMP_GRID->VOLUME   := tmpctes->zbc_volume
	TMP_GRID->CALC     := tmpctes->zbc_calc

	TMP_GRID->(MsUnlock())
	
	tmpctes->(DbSkip())
EndDo

tmpctes->(DbCloseArea())

TMP_GRID->(DbGoTop())
                     
ObjectMethod(oMark:oBrowse,"Refresh()")
oDlgMan:Refresh()

RestArea(aArea)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fExecXML �Autor  �TOTVS II             � Data �  27/11/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o respons�vel por efetuar a importa��o do arquivo XML ���
���          � do Ct-e                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � MANXMLCTE                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*----------------------------------*
Static Function fExecXML(oXML, cFile)
*----------------------------------*

Local cCodCte := PADL(AllTrim(oXML:_cteproc:_cte:_infcte:_ide:_nct:text),09,"0")
Local cChvCte := ""
Local cChvNfe := ""
Local cSerCte := oXML:_cteproc:_cte:_infcte:_ide:_serie:text
Local dDatEmi := StoD(SubStr(oXML:_cteproc:_cte:_infcte:_ide:_dhemi:text, 01, 04) +; 
								      SubStr(oXML:_cteproc:_cte:_infcte:_ide:_dhemi:text, 06, 02) +;
								      SubStr(oXML:_cteproc:_cte:_infcte:_ide:_dhemi:text, 09, 02))
Local cCgcEmi := oXML:_cteproc:_cte:_infcte:_emit:_cnpj:text 
Local cRazEmi := oXML:_cteproc:_cte:_infcte:_emit:_xnome:text

Local cCodFor := Posicione("SA2", 3, xFilial("SA2") + AllTrim(cCgcEmi), "A2_COD")
Local cLojFor := Posicione("SA2", 3, xFilial("SA2") + AllTrim(cCgcEmi), "A2_LOJA")
Local cConPag := Posicione("ZBA", 1, xFilial("ZBA") + cEmpAnt + cFilAnt, "ZBA_CONPAG")
Local cCodPro := Posicione("ZBA", 1, xFilial("ZBA") + cEmpAnt + cFilAnt, "ZBA_CODPRO")
Local cDesPro := Posicione("SB1", 1, xFilial("SB1") + cCodPro, "B1_DESC")
Local cCodNat := Posicione("ZBA", 1, xFilial("ZBA") + cEmpAnt + cFilAnt, "ZBA_NATURE")
Local cCodSeg := Posicione("ZBA", 1, xFilial("ZBA") + cEmpAnt + cFilAnt, "ZBA_CLVL")
Local cCodCC  := Posicione("ZBA", 1, xFilial("ZBA") + cEmpAnt + cFilAnt, "ZBA_CC")
Local cCodTes := ""
Local nValTot := Val(oXML:_cteproc:_cte:_infcte:_vprest:_vtprest:text)
Local nAliIcm := 0

Local aNfOri  := {}
Local nPsoBrt := 0         // Vari�vel para armazenar peso bruto da carga
Local nQtdVol := 0         // Vari�vel para armazenar quantidade de volumes da carga

Local lRet    := .T.        
Local lFound  := .F. 
Local nX      := 0
Local cSerTmp := ""
Local cDocTmp := ""
Local cCST    := ""
Local lSimpNa := .F.			// Vari�vel que indica se o fornecedor � do Simples Nacional

Private lMsErroAuto  := .F.
Private lMsHelpAuto  := .F.
Private cStatus      := '1'

//���������������������Ŀ
//�Busca chave do Ct-e. �
//�����������������������

If Trim(Upper(XMLGetChild(oXML:_cteproc, 2):REALNAME)) == "PROTCTE"
	cChvCte := oXML:_cteproc:_protcte:_infprot:_chcte:text
Else
  cChvCte := SubStr(oXML:_cteproc:_cte:_signature:_signedinfo:_reference:_uri:text, 05, 44)
EndIf

//���������������������Ŀ
//�Valida o tipo do Ct-e�
//�����������������������

Do Case
	
	Case AllTrim(oXML:_cteproc:_cte:_infcte:_ide:_tpCTe:text) == '1'   // Ct-e de complemento
		cStatus := '4'
		aAdd(aErros, cFile + " => CT-E DE COMPLEMENTO. O DOCUMENTO FOI SINALIZADO COM STATUS 4 PARA VERIFICACAO POSTERIOR.")
	
	Case AllTrim(oXML:_cteproc:_cte:_infcte:_ide:_tpCTe:text) == '2'   // Ct-e de Anula��o
		cStatus := '4'
		aAdd(aErros, cFile + " => CT-E DE ANULACAO. O DOCUMENTO FOI SINALIZADO COM STATUS 4 PARA VERIFICACAO POSTERIOR.") 	
	
	Case AllTrim(oXML:_cteproc:_cte:_infcte:_ide:_tpCTe:text) == '3'   // Ct-e de Substitui��o
		cStatus := '4'
		aAdd(aErros, cFile + " => CT-E DE SUBSTITUICAO. O DOCUMENTO FOI SINALIZADO COM STATUS 4 PARA VERIFICACAO POSTERIOR.") 	
		
EndCase

If cStatus == '1'

	//��������������������������������������������
	//�Valida exist�ncia da chave da NF-e no Ct-e.
	//��������������������������������������������
	
	Do Case
		Case ValType(XMLGetChild(oXML:_cteproc:_cte:_infcte:_infctenorm:_infdoc, 1)) == "A"
			If Trim(Upper(XMLGetChild(oXML:_cteproc:_cte:_infcte:_infctenorm:_infdoc, 1)[01]:REALNAME)) == "INFNF"
		
				If ValType(oXML:_cteproc:_cte:_infcte:_infctenorm:_infdoc:_infnf[01]) == "O"
					cSerTmp := PADR(AllTrim(oXML:_cteproc:_cte:_infcte:_infctenorm:_infdoc:_infNF[01]:_serie:text),03," ")
					cDocTmp := PADL(AllTrim(oXML:_cteproc:_cte:_infcte:_infctenorm:_infdoc:_infNF[01]:_ndoc:text),09,"0")
				  
	  			//��������������������������������������������������������������������������������Ŀ
					//�Cover Your Ass 01                                                               �
					//�Segundo defini��o do Sr Alexandre Dekker, a situa��o onde mais que um documento �
					//�� vinculado ao mesmo Ct-e n�o precisa ser tratado porque s�o casos muito raros. �
					//����������������������������������������������������������������������������������
					
					MsgInfo("O Ct-e serie "+ AllTrim(cSerCte) +" n�mero "+ AllTrim(cCodCte) +" possui mais que uma NF vinculada a ele, por�m, devido a uma defini��o no desenvolvimento da rotina,"+; 
									" apenas uma delas ser� considerada para lan�amento da pr�-nota.","Aten��o!")
											
					aNfOri  := fGetNfOri(2, cSerTmp + cDocTmp)
				  
				EndIf
			
			ElseIf Trim(Upper(XMLGetChild(oXML:_cteproc:_cte:_infcte:_infctenorm:_infdoc, 1)[01]:REALNAME)) == "INFNFE"
				If ValType(oXML:_cteproc:_cte:_infcte:_infctenorm:_infdoc:_infnfe[01]) == "O"
					cChvNfe := oXML:_cteproc:_cte:_infcte:_infctenorm:_infdoc:_infnfe[01]:_chave:text
				  
	  			//��������������������������������������������������������������������������������Ŀ
					//�Cover Your Ass 02                                                               �
					//�Segundo defini��o do Sr Alexandre Dekker, a situa��o onde mais que um documento �
					//�� vinculado ao mesmo Ct-e n�o precisa ser tratado porque s�o casos muito raros. �
					//����������������������������������������������������������������������������������
					
					MsgInfo("O Ct-e serie "+ AllTrim(cSerCte) +" n�mero "+ AllTrim(cCodCte) +" possui mais que uma NF vinculada a ele, por�m, devido a uma defini��o no desenvolvimento da rotina,"+; 
									" apenas uma delas ser� considerada para lan�amento da pr�-nota.","Aten��o!")
											
					aNfOri  := fGetNfOri(1, cChvNfe)
				  
				EndIf
			EndIf
		
		Case ValType(XMLGetChild(oXML:_cteproc:_cte:_infcte:_infctenorm:_infdoc, 1)) == "O"
			If Trim(Upper(XMLGetChild(oXML:_cteproc:_cte:_infcte:_infctenorm:_infdoc, 1):REALNAME)) == "INFNF"
	
				If ValType(oXML:_cteproc:_cte:_infcte:_infctenorm:_infdoc:_infnf) == "O"
					cSerTmp := PADR(AllTrim(oXML:_cteproc:_cte:_infcte:_infctenorm:_infdoc:_infNF:_serie:text),03," ")
					cDocTmp := PADL(AllTrim(oXML:_cteproc:_cte:_infcte:_infctenorm:_infdoc:_infNF:_ndoc:text),09,"0")
				  aNfOri  := fGetNfOri(2, cSerTmp + cDocTmp) 
		  	EndIf
		  
		  ElseIf Trim(Upper(XMLGetChild(oXML:_cteproc:_cte:_infcte:_infctenorm:_infdoc, 1):REALNAME)) == "INFNFE"
		  	
		  	If ValType(oXML:_cteproc:_cte:_infcte:_infctenorm:_infdoc:_infnfe) == "O"
		  		cChvNfe := oXML:_cteproc:_cte:_infcte:_infctenorm:_infdoc:_infnfe:_chave:text
					aNfOri  := fGetNfOri(1, cChvNfe)	
		  		
		  	EndIf
		  	
		  EndIf
			
	EndCase
  
	//������������������������������6
	//�Busca al�quota de ICMS do XML�
	//������������������������������6
	
	Do Case
		
		Case Trim(Upper(XMLGetChild(oXML:_cteproc:_cte:_infcte:_imp:_icms, 1):REALNAME)) == "ICMS00"
			nAliIcm := Val(oXML:_cteproc:_cte:_infcte:_imp:_icms:_icms00:_picms:text)
			cCST    := oXML:_cteproc:_cte:_infcte:_imp:_icms:_icms00:_cst:text
			
		Case Trim(Upper(XMLGetChild(oXML:_cteproc:_cte:_infcte:_imp:_icms, 1):REALNAME)) == "ICMS20"
			nAliIcm := Val(oXML:_cteproc:_cte:_infcte:_imp:_icms:_icms20:_picms:text)
			cCST    := oXML:_cteproc:_cte:_infcte:_imp:_icms:_icms20:_cst:text
			
		Case Trim(Upper(XMLGetChild(oXML:_cteproc:_cte:_infcte:_imp:_icms, 1):REALNAME)) == "ICMS60"
			nAliIcm := Val(oXML:_cteproc:_cte:_infcte:_imp:_icms:_icms60:_picmsstret:text)
			cCST    := oXML:_cteproc:_cte:_infcte:_imp:_icms:_icms60:_cst:text
			
		Case Trim(Upper(XMLGetChild(oXML:_cteproc:_cte:_infcte:_imp:_icms, 1):REALNAME)) == "ICMS90"
			nAliIcm := Val(oXML:_cteproc:_cte:_infcte:_imp:_icms:_icms90:_picms:text)
      		cCST    := oXML:_cteproc:_cte:_infcte:_imp:_icms:_icms90:_cst:text
			
		Case Trim(Upper(XMLGetChild(oXML:_cteproc:_cte:_infcte:_imp:_icms, 1):REALNAME)) == "ICMSOUTRAUF"
			nAliIcm := Val(oXML:_cteproc:_cte:_infcte:_imp:_icms:_ICMSOutraUF:_pICMSOutraUF:text)
			cCST    := oXML:_cteproc:_cte:_infcte:_imp:_icms:_ICMSOutraUF:_cst:text
		
		Case Trim(Upper(XMLGetChild(oXML:_cteproc:_cte:_infcte:_imp:_icms, 1):REALNAME)) == "ICMSSN"
			nAliIcm := 0    
			cCST    := "SN" // Simples Nacional (Utilizado posteriormente para setar a TES)
			
	EndCase 
	
	//����������������������������������Ŀ
	//�Busca informa��es de VOLUME do XML�
	//������������������������������������
	
	If ValType(oXML:_cteproc:_cte:_infcte:_infctenorm:_infcarga:_infq) == "O"
	
		If oXML:_cteproc:_cte:_infcte:_infctenorm:_infcarga:_infq:_cUnid:text == "01"         // 01 KG
			nPsoBrt := Val(oXML:_cteproc:_cte:_infcte:_infctenorm:_infcarga:_infq:_qcarga:text)
		ElseIf oXML:_cteproc:_cte:_infcte:_infctenorm:_infcarga:_infq:_cUnid:text == "02"     // 02 TON
			nPsoBrt := Val(oXML:_cteproc:_cte:_infcte:_infctenorm:_infcarga:_infq:_qcarga:text) * 1000
		ElseIf oXML:_cteproc:_cte:_infcte:_infctenorm:_infcarga:_infq:_cUnid:text == "03"     // 03 UNIDADE
			nQtdVol := Val(oXML:_cteproc:_cte:_infcte:_infctenorm:_infcarga:_infq:_qcarga:text)
		EndIf			
	
	ElseIf ValType(oXML:_cteproc:_cte:_infcte:_infctenorm:_infcarga:_infq) == "A"
	
			For nX := 1 to Len(oXML:_cteproc:_cte:_infcte:_infctenorm:_infcarga:_infq)
				If oXML:_cteproc:_cte:_infcte:_infctenorm:_infcarga:_infq[nX]:_cUnid:text == "01"         // 01 KG
					nPsoBrt := Val(oXML:_cteproc:_cte:_infcte:_infctenorm:_infcarga:_infq[nX]:_qcarga:text)
				ElseIf oXML:_cteproc:_cte:_infcte:_infctenorm:_infcarga:_infq[nX]:_cUnid:text == "02"     // 02 TON
					nPsoBrt := Val(oXML:_cteproc:_cte:_infcte:_infctenorm:_infcarga:_infq[nX]:_qcarga:text) * 1000
				ElseIf oXML:_cteproc:_cte:_infcte:_infctenorm:_infcarga:_infq[nX]:_cUnid:text == "03"     // 03 UNIDADE
					nQtdVol := Val(oXML:_cteproc:_cte:_infcte:_infctenorm:_infcarga:_infq[nX]:_qcarga:text)
				EndIf
			Next nX	
			
	EndIf
	
	//���������������������������Ŀ
	//�Regra para setar TES padr�o�                	
	//�����������������������������
	
	If Posicione("ZBA", 1, xFilial("ZBA") + cEmpAnt + cFilAnt, "ZBA_TOMADO") == 'N'       // Valida se a empresa/filial � tomadora S/N
		DbSelectArea("ZBD")
		ZBD->(DbSetOrder(3))
		If DbSeek(xFilial("ZBD") + cEmpAnt + cFilAnt + cCST)     		                        // Busca a TES configurada para o grupo tribut�rio do fornecedor
			cCodTes := ZBD->ZBD_TES
		ElseIf DbSeek(xFilial("ZBD") + cEmpAnt + cFilAnt + "GE")                            // Busca uma TES gen�rica para os grupos que n�o est�o com TES configurada
			cCodTes := ZBD->ZBD_TES
		EndIf
	Else
	  cCodTes := Posicione("ZBA", 1, xFilial("ZBA") + cEmpAnt + cFilAnt, "ZBA_TES")       // Se ela for tomadora, pega direto a TES da ZBA
	EndIf  
	
	If Empty(cCodTes)
		MsgInfo("N�o encontrei regra v�lida para setar TES :( Procure corrigir os par�metros dessa filial!")
	EndIf
 
  //�����������������������������
	//� In�cio das valida��es�
	//�����������������������������
	
	if Empty(cCodFor)
		cStatus := '3'
		aAdd(aErros, cFile + " => FORNECEDOR: "+ Trim(cRazEmi) +" CGC: "+ cCgcEmi +" -> NAO ESTA CADASTRADO.")
	EndIf
	
	If Empty(cConPag)
		cStatus := '3'
		aAdd(aErros,  cFile + " =>CONDICAO DE PAGAMENTO INDICADA NO CADASTRO DE PAR�METROS DA ROTINA � INV�LIDA. ")
	EndIf
	
	lFound := fFindDoc(cChvCte)
	
	if lFound
		cStatus := '3'
		aAdd(aErros, cFile + " => ENCONTREI UM CTE SERIE "+ AllTrim(cSerCte) +" NRO "+ AllTrim(cCodCte) +;
								 " JA LANCADO PARA O FORNECEDOR "+ Trim(cCodFor) +" LOJA "+ Trim(cLojFor))
	EndIf  
	
	//�������������������������Ŀ
	//� Fim das valida��es�
	//���������������������������
	
	aCabec := {} 
	aItens := {}
	aAdd(aCabec,{"F1_FILIAL" , xFilial("SF1"), Nil, Nil}) 
	aadd(aCabec,{"F1_TIPO"   , "N"           , Nil, Nil})         																				// Complemento de Frete
	aadd(aCabec,{"F1_FORMUL" , "N"           , Nil, Nil})                                                 // Formul�rio pr�prio = N�o
	aadd(aCabec,{"F1_DOC"    , cCodCte       , Nil, Nil})                                                 // Nro do Cte
	aadd(aCabec,{"F1_CHVNFE" , cChvCte       , Nil, Nil})                                                 // Chave do Ct-e
	aadd(aCabec,{"F1_SERIE"  , cSerCte       , Nil, Nil})                                                 // S�rie Ct-e
	aadd(aCabec,{"F1_EMISSAO", dDatEmi       , Nil, Nil})                                                 // Emissao
	aadd(aCabec,{"F1_FORNECE", cCodFor       , Nil, Nil})                                                 // C�digo Fornecedor
	aadd(aCabec,{"F1_LOJA"   , cLojFor       , Nil, Nil})                                                 // Loja Fornecedor
	aadd(aCabec,{"F1_ESPECIE", "CTE"         , Nil, Nil})                                                 // Esp�cie do Documento
	aAdd(aCabec,{"F1_NATUREZ", cCodNat       , Nil, Nil})                                                 // Natureza de Opera��o
	aadd(aCabec,{"F1_COND"   , cConPag       , Nil, Nil})                                                 // Condi��o de pagamento
	aAdd(aCabec,{"F1_VOLUME1", nQtdVol       , Nil, Nil})
	aAdd(aCabec,{"F1_X_PESOB", nPsoBrt       , Nil, Nil})
	                                
	aLinha := {}
	
	//�����������������������������������������������������������������������������������Ŀ
	//�Se for sempre uma nota para cada Ct-e, n�o ser� necess�rio loop para linha de itens�
	//�������������������������������������������������������������������������������������
	
	aAdd(aLinha,{"D1_FILIAL", xFilial("SD1") , Nil, Nil})
	aadd(aLinha,{"D1_COD"   , cCodPro        , Nil, Nil})
	aAdd(aLinha,{"D1_DESCRI", cDesPro        , Nil, Nil}) 
	aadd(aLinha,{"D1_QUANT" , 1              , Nil, Nil}) 
	aadd(aLinha,{"D1_VUNIT" , nValTot        , Nil, Nil}) 
	aadd(aLinha,{"D1_TOTAL" , nValTot        , Nil, Nil})
	aAdd(aLinha,{"D1_X_TES" , cCodTes        , Nil, Nil})
	aAdd(aLinha,{"D1_CC"    , cCodCC         , Nil, Nil})
	
	If nAliIcm > 0
		aAdd(aLinha,{"D1_PICM"  , nAliIcm      , Nil, Nil}) 
	EndIf
	
	If Len(aNfOri) > 0
		
		aadd(aLinha,{"D1_NFORI" , aNfOri[aScan(aNfOri, {|x| AllTrim(x[01]) == "F2_DOC"  })][02], Nil, Nil})
		aAdd(aLinha,{"D1_SERORI", aNfOri[aScan(aNfOri, {|x| AllTrim(x[01]) == "F2_SERIE"})][02], Nil, Nil})	
	
		//����������������������������������������������������������������������������������Ŀ
		//�Campo que armazena o c�lculo do valor do frete dividido pelo valor da NF de origem�
		//������������������������������������������������������������������������������������
	
		aAdd(aCabec,{"F1_X_CALC" , Round( (aLinha[aScan(aLinha, {|x| AllTrim(x[01]) == "D1_TOTAL"})][02] / aNfOri[aScan(aNfOri, {|x| AllTrim(x[01]) == "F2_VALBRUT"})][02]) * 100, TamSX3("F1_X_CALC")[02]) , Nil, Nil})
		
		//���������������������������������������������������������������������������Ŀ
		//�Se estiver vazio na nota de origem, busca segmento dos par�metros da rotina�
		//�����������������������������������������������������������������������������
		
		if Empty(aNfOri[aScan(aNfOri, {|x| AllTrim(x[01]) == "D2_CLVL"})][02])
			aAdd(aLinha,{"D1_CLVL"  , cCodSeg , Nil, Nil})
		Else
			aAdd(aLinha,{"D1_CLVL"  , aNfOri[aScan(aNfOri, {|x| AllTrim(x[01]) == "D2_CLVL"})][02], Nil, Nil})
		EndIf
	 	  
	  aadd(aItens,aLinha) 
	 	
	 	//�����������������������������������������������������������������Ŀ
		//�Chamada da fun��o para atualizar informa��es do XML na tabela ZBC�
		//�������������������������������������������������������������������
		
		fGrvInfXml(aCabec, aItens, cFile, aNfOri, nPsoBrt, nQtdVol, cChvCte)
	
	Else
		cStatus := '3'
		aAdd(aErros, cFile + " => NAO CONSEGUI ENCONTRAR A NOTA QUE ORIGINOU O CT-E!" + CHR(13)+CHR(10) +;
								 iif(Empty(cChvNfe), "SERIE DA NF ENCONTRADA NO CT-E..: "+ cSerTmp + CHR(13)+CHR(10) +; 
								 "NRO DA NF ENCONTRADA NO CT-E....: "+ cDocTmp, "CHAVE DA NF-E ENCONTRADA NO CT-E..: "+ cChvNfe) )		
	EndIf

EndIf

//�����������������������������������������������������������������
//�Bloco de c�digo para validar dados antes da execu��o do ExecAuto�
//�����������������������������������������������������������������

If Len(aErros) > 0
	
	cTmp := "" // Vari�vel tempor�ria para mostar mensagens de erro em tela
	
	For nX := 1 to Len(aErros)
		cTmp += aErros[nX] + CHR(13)+CHR(10)
		aAdd(aResErr, aErros[nX])
	Next nX
	
	fGrvLog(cTmp, cFile, cStatus) 
	
	aErros  := {}
	cStatus := '1'
	
	Return .F.
EndIf

MsgRun("Aguarde gerando Pr�-Nota de Entrada...",,{|| MSExecAuto ( {|x,y,z| MATA140(x,y,z) }, aCabec, aItens, 3)})   

If lMsErroAuto 
	lRet := .F.
	cTmp := MostraErro()
	aAdd(aResErr, cFile + " => ERRO NA INCLUSAO DO DOCUMENTO DE ENTRADA. VERIFIQUE OS DETALHES!")
	
	//����������������������������������������������������������������������Ŀ
	//�Grava��o do log de processamento, caso tenha ocorrido erro na execu��o�
	//������������������������������������������������������������������������
	cStatus := '3' 
	
	fGrvLog(cTmp, cFile, cStatus) 

Else
	aAdd(aResAce, cFile + " => OK ")
	
	// 12/03/15 - REMOVIDA POR SOLICITACAO DA EQUIPE OPERACIONAL. SEGUNDO ELES, NAO TEM NECESSIDADE DE MOSTRAR ESSA INFORMACAO.
	//Aviso("Pr�-Nota Inclu�da", "Documento "+ cCodCte +" s�rie "+ cSerCte +" inclu�do com sucesso!", {"Ok"}, 3)
	
EndIf

fDados()

ObjectMethod(oMark:oBrowse,"Refresh()")
oDlgMan:Refresh()

Return lRet         

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fFindDoc �Autor  �TOTVS II             � Data �  05/01/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para validar se o Ct-e j� foi incluso.              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MANXMLCTE                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function fFindDoc(cChvCte)

Local lRet := .F.
Local cSql := ""                	

cSql := "select count(*) as quant from "+ RetSqlName("SF1") +" f1 "
cSql += "where f1.d_e_l_e_t_ = ' ' "
cSql += "  and f1.f1_chvnfe = '"+ AllTrim(cChvCte) +"' "

TCQUERY cSql NEW ALIAS "tmpf1" 

DbSelectArea("tmpf1")
tmpf1->(DbGoTop())

lRet := tmpf1->quant > 0

tmpf1->(DbCloseArea())

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fGrvLog �Autor  �TOTVS II              � Data �  06/01/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para grava��o de log de importa��o do XML           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MANXMLCTE                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function fGrvLog(cTmp, cFile, cStatus)

Local aArea := GetArea()

DbSelectArea("ZBC")
DbSetOrder(2)

If DbSeek(xFilial("ZBC") + cFile)
	RecLock("ZBC", .F.)
	ZBC->ZBC_PROCESS := cStatus                // Erro de processamento
	ZBC->ZBC_LOG     := OemToAnsi(cTmp)        // Grava log para an�lise posterior
	ZBC->(MsUnlock())
EndIf

RestArea(aArea)

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fGrvInfXML �Autor  �TOTVS II           � Data �  06/01/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para gravar dados do XML na tabela ZBC              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MANXMLCTE                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function fGrvInfXml(aCabec, aItens, cFile, aNfOri, nPeso, nVolume, cChvCte)

Local nPosSer := aScan(aCabec, {|x| AllTrim(x[01]) == "F1_SERIE"})
Local nPosDoc := aScan(aCabec, {|x| AlLTrim(x[01]) == "F1_DOC"})
local nPosEmi := aScan(aCabec, {|x| AllTrim(x[01]) == "F1_EMISSAO"})
local nPosFor := aScan(aCabec, {|x| AllTrim(x[01]) == "F1_FORNECE"})
Local nPosLoj := aScan(aCabec, {|x| AllTrim(x[01]) == "F1_LOJA"})
Local nPosFre := aScan(aItens[01], {|x| AllTrim(x[01]) == "D1_TOTAL"})
Local nPosVlr := aScan(aNfOri, {|x| AllTrim(x[01]) == "F2_VALBRUT"})


DbSelectArea("ZBC")
DbSetOrder(2)
if DbSeek(xFilial("ZBC") + cFile)
	RecLock("ZBC", .F.)                                                
	ZBC->ZBC_SERIE  := aCabec[nPosSer][02]
	ZBC->ZBC_DOC    := aCabec[nPosDoc][02]
	ZBC->ZBC_EMISSA := aCabec[nPosEmi][02]
	ZBC->ZBC_FORNEC := aCabec[nPosFor][02]
	ZBC->ZBC_LOJA   := aCabec[nPosLoj][02]
	ZBC->ZBC_VLTOT  := aNfOri[nPosVlr][02]
	ZBC->ZBC_VLFRE  := aItens[01][nPosFre][02]
	ZBC->ZBC_PESO   := Round(nPeso,   TamSX3("ZBC_PESO"  )[02])
	ZBC->ZBC_VOLUME := Round(nVolume, TamSX3("ZBC_VOLUME")[02])
	ZBC->ZBC_CALC   := iif( nPosVlr > 0, Round((aItens[01][nPosFre][02] / aNfOri[nPosVlr][02]) * 100, TamSX3("ZBC_CALC")[02]), 0 )
	ZBC->ZBC_CHVCTE := cChvCte
	ZBC->(MsUnlock())
EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fGrvTes �Autor  � TOTVS II             � Data �  12/01/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para buscar gravar a TES na pr�-nota                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MANXMLCTE                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function fGrvTes(aCabec, aItens)

Local nPosSer := aScan(aCabec, {|x| AllTrim(x[01]) == "F1_SERIE"})
Local nPosDoc := aScan(aCabec, {|x| AlLTrim(x[01]) == "F1_DOC"})
local nPosFor := aScan(aCabec, {|x| AllTrim(x[01]) == "F1_FORNECE"})
Local nPosLoj := aScan(aCabec, {|x| AllTrim(x[01]) == "F1_LOJA"})
Local nPosCod := aScan(aItens[01], {|x| AllTrim(x[01]) == "D1_COD"})
Local nPosTes := aScan(aItens[01], {|x| AllTrim(x[01]) == "D1_TES"})
Local cCFOP   := Posicione("SF4", 1, xFilial("SF4") + aItens[01][nPosTes][02], "F4_CF")
Local aArea   := GetArea()

DbSelectArea("SD1")
SD1->(DbSetOrder(2))

If DbSeek(xFilial("SD1") + aItens[01][nPosCod][02] + aCabec[nPosDoc][02] + aCabec[nPosSer][02] + aCabec[nPosFor][02] + aCabec[nPosLoj][02])
	RecLock("SD1", .F.)
	SD1->D1_TES := aItens[01][nPosTes][02]
	SD1->D1_CF  := cCFOP
	SD1->(MsUnlock())
EndIf

RestArea(aArea)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fGetNfOri �Autor  �TOTVS II            � Data �  12/01/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o que retorna dados da NF que originou o Ct-e         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MANXMLCTE                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function fGetNfOri(nOpc, cChvNfe)

Local aArea := GetArea()
Local aRet  := {}
Local cSql  := ""

cSql := "select f2.f2_filial, f2.f2_serie, f2.f2_doc, f2.f2_cliente, f2.f2_loja, f2.f2_valbrut from "+ RetSqlName("SF2") +" f2 "
cSql += "where f2.d_e_l_e_t_ = ' ' "

If nOpc == 1      		// Pesquisa pela chave da NF-e
	cSql += "  and f2.f2_chvnfe = '"+ AllTrim(cChvNfe) +"' "   
	
ElseIf nOpc == 2      // Pesquisa por Filial + Serie + N�mero NF
	cSql += "  and f2.f2_filial = '"+ xFilial("SF2") +"' " 
	cSql += "  and f2.f2_serie  = '"+ SubStr(cChvNfe, 01, 03) +"' "
	cSql += "  and f2.f2_doc    = '"+ SubStr(cChvNfe, 04, 09) +"' " 
	
EndIf

TcQuery cSql New Alias "notaori"

DbSelectArea("notaori")
notaori->(DbGoTop())

If !notaori->(EOF())
	aAdd(aRet, {"F2_FILIAL",  notaori->f2_filial})
	aAdd(aRet, {"F2_SERIE",   notaori->f2_serie})
	aAdd(aRet, {"F2_DOC",     notaori->f2_doc})
	aAdd(aRet, {"F2_CLIENTE", notaori->f2_cliente})
	aAdd(aRet, {"F2_LOJA",    notaori->f2_loja})
	aAdd(aRet, {"F2_VALBRUT", notaori->f2_valbrut})
Else                    	
	notaori->(DbCloseArea())
	Return aRet
EndIf

notaori->(DbCloseArea())

DbSelectArea("SD2")
SD2->(DbSetOrder(3))
If DbSeek(aRet[01][02] + aRet[03][02] + aRet[02][02] + aRet[04][02] + aRet[05][02])
	aAdd(aRet, {"D2_CLVL",   SD2->D2_CLVL})
	aAdd(aRet, {"D2_CCUSTO", SD2->D2_CCUSTO})
EndIf

RestArea(aArea)

Return aRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fGrvChv �Autor  �TOTVS II           � Data �  21/05/15      ���
�������������������������������������������������������������������������͹��
���Desc.     � Essa fun��o tem como objetivo reprocessar toda a tabela    ���
���          � de Ct-es para gravar a chave do mesmo no campo ZBC_CHVCTE  ���
�������������������������������������������������������������������������͹��
���Uso       � MANXMLCTE                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*--------------------------*
Static Function fGrvChv()
*--------------------------*

Local cSql    := ""
Local aRec    := {}
Local nX      := 0
Local oXML 
Local cAviso  := ""
Local cErro   := ""
Local cChvCte := ""
Local lTransf := .F.

If Aviso("Cuidado!", "Essa rotina tem por objetivo reprocessar toda a tabela de Ct-es (ZBC) gravando no campo ZBC_CHVCTE a chave do documento." +;
										 "Devido � quantidade de registros, essa tarefa pode demorar para ser conclu�da. Deseja continuar assim mesmo?", {"Sim","Nao"}, 2) != 1
	Return	
EndIf

oLbSta:SetText("Buscando dados... ")
oDlgMan:CommitControls()

cSql := "select zbc.r_e_c_n_o_ as reczbc from "+ RetSqlName("ZBC") +" zbc "
cSql += "where zbc.zbc_chvcte = ' ' "
cSql += "  and zbc.d_e_l_e_t_ = ' ' "

TcQuery cSql New Alias "zbcrep"

DbSelectArea("zbcrep")
zbcrep->(DbGoTop())

If !zbcrep->(EOF())

	While !zbcrep->(EOF())
		aAdd(aRec, zbcrep->reczbc)
		zbcrep->(DbSkip())
	EndDo

Else
	
	MsgInfo("N�o h� xmls a serem processados! Processo conclu�do!")
	
	zbcrep->(DbCloseArea())
	oLbSta:SetText(" ")
	oDlgMan:CommitControls()
	
	Return
	
EndIf

zbcrep->(DbCloseArea())

oMtProc:SetTotal(Len(aRec))
oDlgMan:CommitControls()

For nX := 1 to Len(aRec)
	
	oMtProc:Set(nX)
	oLbSta:SetText("Corrigindo registro "+ AllTrim(Str(aRec[nX])) +"...")
	oDlgMan:CommitControls()	

	DbSelectArea("ZBC")
	ZBC->(DbGoTo(aRec[nX]))
	
	oXML := XMLParser( AnsiToOem(ZBC->ZBC_XML) , "_", @cAviso, @cErro)
	
	if ValType(oXML) == "O"		
	
		//������������������������������������Ŀ
		//�Valida se o XML n�o � evento do Ct-e�
		//��������������������������������������
		
		cChvCte := ""
		
		if Alltrim(Upper(XMLGetChild(oXML, 1):REALNAME)) != "PROCEVENTOCTE"
				If XmlChildEx(oXML:_CTEPROC, "_PROTCTE") != NIL
					cChvCte := oXML:_cteproc:_protcte:_infprot:_chcte:text		
				EndIf
		EndIf
	
		If !Empty(cChvCte)
			RecLock("ZBC", .F.)
			ZBC->ZBC_CHVCTE := cChvCte
			ZBC->(MsUnlock())
		EndIf
	
	EndIf
	
Next nX

MsgInfo("Processo conclu�do!")

oMtProc:Set(0)
oLbSta:SetText(" ")
oDlgMan:CommitControls()

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SCHCLACTE �Autor  �TOTVS II           � Data �   01/06/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Schedule executado para classificar pr�-notas de Ct-e      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � ESPECIFICOS CANTU                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

/*
@dinamizar - conte�do fixo, precisa ser dinalizado
*/

*--------------------------*
User Function SCHCLACTE(lManual, cEmpPar, cFilPar)
*--------------------------*

Local cSql      := ""
Local aRecZbc   := {}
Local nX        := 0
Local lOk       := .F.  

Private aRotina     := MontaMenu()
Private lMsHelpAuto := .T.
PRIVATE lMsErroAuto := .F.

Default lManual := .F.
Default cEmpPar := "31"
Default cFilPar := "01"

fMsgAlert("Iniciando rotina de classificacao de pre-notas", .F.)

If !lManual
	RPCCLEARENV()
	RPCSETTYPE(3)
	PREPARE ENVIRONMENT EMPRESA cEmpPar FILIAL cFilPar MODULO "COM" TABLES "SF1","ZBC" 
EndIf 

//�������������������������������������Ŀ
//�Muda status da r�gua de processamento�
//���������������������������������������

If lManual
	oMtProc:Set(0)
	oLbSta:SetText("Buscando pr�-notas...")
	oDlgMan:CommitControls()
EndIf

//�����������������������������������������������������������������������������X�
//�Busca as pr�-notas com status 'pr�-nota inclu�da' para iniciar classifica��o�
//�����������������������������������������������������������������������������X�

cSql := "select r_e_c_n_o_ as reczbc from "+ RetSqlName("ZBC") +" zbc "
cSql += "where zbc_codemp = '"+ cEmpAnt +"' "
cSql += "  and zbc_codfil = '"+ cFilAnt +"' "
cSql += "  and zbc_proces = '2' "
cSql += "  and zbc_emissa < '"+ DtoS(Date() - 07) +"' "      // @dinamizar
cSql += "  and d_e_l_e_t_ = ' ' "

TCQUERY cSql NEW ALIAS "ZBCTMP"

DbSelectArea("zbctmp")
zbctmp->(DbGoTop())

If zbctmp->(EOF())
	zbctmp->(DbCloseArea())
	fMsgAlert("Nao ha pre-notas a serem classificadas!")
	
	If lManual
  	oMtProc:Set(0)
		oLbSta:SetText(" " )
		oDlgMan:CommitControls()
  EndIf
	
	Return
EndIf

While !zbctmp->(EOF())
	aAdd(aRecZbc, zbctmp->reczbc)
	zbctmp->(DbSkip())
EndDo

zbctmp->(DbCloseArea())

oMtProc:SetTotal(Len(aRecZbc))     // Seta o tamanho da r�gua

For nX := 1 to Len(aRecZbc)
  
  If lManual
  	oMtProc:Set(nX)
		oLbSta:SetText("Lendo registro ("+ AllTrim(Str(aRecZBC[nX])) +")" )
		oDlgMan:CommitControls()
  EndIf
  
	nRecSF1 := 0
	cChvSF1 := ""
	lOk := .F.
	
	//�����������������������������������������������������������9
	//�Posiciona na ZBC pra buscar o n�mero, s�rie e filial da NF�
	//�����������������������������������������������������������9
	
	DbSelectArea("ZBC")
	ZBC->(DbGoTo(aRecZbc[nX]))
	//F1_FILIAL + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA + F1_TIPO
	cChvSF1 := ZBC->ZBC_CODFIL + ZBC->ZBC_DOC + ZBC->ZBC_SERIE + ZBC->ZBC_FORNEC + ZBC->ZBC_LOJA
	
	//����������������������������������������������������������������������������������������������Ŀ
	//�Posiciona na F1 pra retornar o R_E_C_N_O_ pra passar como par�metro na rotina de classifica��o�
	//������������������������������������������������������������������������������������������������
		
  DbSelectArea("SF1")
  SF1->(DbSetOrder(1))
  
  If SF1->(DbSeek(cChvSF1))
  
			//���������������������������������������������������������Ŀ
			//�Posiciona na SD1 pra validar se a NF n�o foi classificada�
			//�����������������������������������������������������������
			  		
  		DbSelectArea("SD1")
  		SD1->(DbSetOrder(1))
  		SD1->(DbSeek(cChvSF1))
  		
  		If Empty(SD1->D1_TES)
  			nRecSF1 := SF1->(Recno())
  		Else
  			fMsgAlert("A nota chave "+ AllTrim(cChvSF1) +" ja esta classificada!", .F.)
  			
  			DbSelectArea("ZBC")
  			ZBC->(DbGoTo(aRecZBC[nX]))
  			RecLock("ZBC", .F.) 
  			ZBC->ZBC_PROCES := '7'     // Pr�-nota classificada
  			ZBC->(MsUnlock()) 
  			
  			Loop
  		EndIf
  Else
  	fMsgAlert("Nao foi possivel localizar a pre-nota chave "+ AllTrim(cChvSF1))
  	Loop
  EndIf
  
	aPreNta  := fGetPre(cChvSF1)              // Monta dados para MsExecAuto
	
	If nRecSF1 != 0
		if lManual
      
			oLbSta:SetText("Classificando... ("+ cChvSF1 +")" )
			oDlgMan:CommitControls()

			fMsgAlert("Processando pre-nota chave "+ AllTrim(cChvSF1), .F.)
			MsExecAuto({|x,y,z| MATA103(x,y,z)},aPreNta[01],aPreNta[02], 4, .F.) 
			
			If lMsErroAuto
				MostraErro()
			EndIf

		Else
			fMsgAlert("Processando pre-nota chave "+ AllTrim(cChvSF1), .F.)
			MsExecAuto({|x,y,z| MATA103(x,y,z)},aPreNta[01],aPreNta[02], 4, .F.)
		EndIf
	
		//�������������������������������������������������Ŀ
		//�02/06/15 - Valida se o documento foi classificado�
		//���������������������������������������������������
		
		lOk := fAvalCla(cChvSF1)
 			
		If lOk
			DbSelectArea("ZBC")
			ZBC->(DbGoTo(aRecZBC[nX]))
	 			
			RecLock("ZBC", .F.)
			ZBC->ZBC_PROCES := '7'     // Pr�-nota classificada
			ZBC->(MsUnlock()) 	
		EndIf
		
	EndIf
	
Next nX

If !lManual
	RESET ENVIRONMENT
EndIf              

If lManual
	
	fDados()
	
	oMtProc:Set(0)
	oLbSta:SetText(" ")
	oDlgMan:CommitControls()
EndIf

fMsgAlert("Fim da rotina de classificacao de pre-notas", .F.)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fMsgAlert �Autor  �TOTVS II           �  Data �  01/06/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para processar mensagens de acordo com a forma que  ���
���          � a rotina est� sendo executada.                             ���
�������������������������������������������������������������������������͹��
���Uso       � MANXMLCTE                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*-------------------------------------------*
Static Function fMsgAlert(cMensagem, lManual)
*-------------------------------------------*

Default lManual := .F.

If lManual
	MsgAlert(cMensagem)
Else
	ConOut("SCHCLACTE - "+ UPPER(cMensagem))
EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MontaMenu �Autor  �TOTVS II           �  Data �  02/06/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Montagem de inicializa��o do menu da rotina de classifica��o��
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MANXMLCTE                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

*---------------------------*
Static Function MontaMenu()
*---------------------------*

Local aRotina := {}

//��������������������������������������������������������������Ŀ
//� Inicializa aRotina para ERP/CRM ou SIGAGSP                   �
//����������������������������������������������������������������

aAdd(aRotina,{OemToAnsi("Pesquisar")  , "AxPesqui"   , 0 , 1, 0, .F.}) 		//"Pesquisar"
aAdd(aRotina,{OemToAnsi("Visualizar") , "A103NFiscal", 0 , 2, 0, nil}) 		//"Visualizar"
aAdd(aRotina,{OemToAnsi("Incluir")    , "A103NFiscal", 0 , 3, 0, nil}) 		//"Incluir"
aAdd(aRotina,{OemToAnsi("Classificar"), "A103NFiscal", 0 , 4, 0, nil}) 		//"Classificar"
aAdd(aRotina,{OemToAnsi("Excluir")    , "A103NFiscal", 3 , 5, 0, nil})		//"Excluir"
aAdd(aRotina,{OemToAnsi("Legenda")    , "A103Legenda", 0 , 2, 0, .F.})		//"Legenda"

Return(aRotina)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fAvalCla  �Autor  �TOTVS II           �  Data �  02/06/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o que faz valida��o se o documento foi classificado.  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MANXMLCTE                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

*--------------------------------*
Static Function fAvalCla(cChave)
*--------------------------------*

Local lRet  := .F.
Local aArea := GetArea()
	
DbSelectArea("SF1")
SF1->(DbSetOrder(1))
  
If SF1->(DbSeek(cChave))
  
//���������������������������������������������������������Ŀ
//�Posiciona na SD1 pra validar se a NF n�o foi classificada�
//�����������������������������������������������������������
  		
	DbSelectArea("SD1")
	SD1->(DbSetOrder(1))
	SD1->(DbSeek(cChave))
  		
	If !Empty(SD1->D1_TES)
		lRet := .T.
	EndIf
	
EndIf

RestArea(aArea)

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fGetPre �Autor  �TOTVS II           � Data �  07/06/15      ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o que retorna dados da pr�-nota para montagem dos     ���
���          � vetores para MsExecAuto                                    ���
�������������������������������������������������������������������������͹��
���Uso       � MANXMLCTE                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

*-------------------------------------*
Static Function fGetPre(cChave)
*-------------------------------------*

Local aRetorno:= {}
Local aFldCab := {"F1_FILIAL","F1_TIPO","F1_FORMUL","F1_DOC","F1_CHVNFE","F1_SERIE","F1_EMISSAO","F1_FORNECE","F1_LOJA",;
									"F1_ESPECIE","F1_NATUREZ","F1_COND","F1_VOLUME1","F1_X_PESOB", "F1_X_CALC"}
Local aFldIte := {"D1_FILIAL","D1_COD","D1_DESCRI","D1_QUANT","D1_VUNIT","D1_TOTAL","D1_X_TES","D1_TES","D1_CC","D1_PICM",;
									"D1_NFORI","D1_SERIORI","D1_CLVL"}
Local aCab    := {}
Local aIte    := {}
Local aItens  := {}

DbSelectArea("SF1")
SF1->(DbSetOrder(1))
If DbSeek(cChave)
	For nCtrl := 1 to Len(aFldCab)
		aAdd(aCab, {aFldCab[nCtrl], &("SF1->"+aFldCab[nCtrl]), Nil})
	Next nCtrl
	
	aItens := {}
	
	DbSelectArea("SD1")
	SD1->(DbSetOrder(1))
	if SD1->(DBSeek(cChave))
		While !SD1->(EOF()) .and. (SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA == cChave) 
			
			For nCtrl:= 1 to Len(aFldIte)
				If aFldIte[nCtrl] == "D1_TES"
					aAdd(aIte, {aFldIte[nCtrl], SD1->D1_X_TES, Nil})            // Atribui ao campo TES o Tipo de Entrada sugerido na inclus�o da pr�-nota
				Else
					aAdd(aIte, {aFldIte[nCtrl], &("SD1->"+aFldIte[nCtrl]), Nil})
				EndIf
			Next nCtrl
			
			aAdd(aItens, aIte)
			aIte := {}
			
			SD1->(DbSkip())
		EndDo
	EndIf
	
	aAdd(aRetorno, aCab)
	aAdd(aRetorno, aItens)
		
EndIf

Return aRetorno


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fClear    �Autor  �TOTVS II            � Data �  10/06/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para limpar caracteres especiais dos arquivos xmls. ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MANXMLCTE                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*-------------------------------*
Static Function fClear(cBuffer)
*-------------------------------*

Local cRet := ""
Local nX   := 0    
Local cCar := ""

For nX := 1 to Len(cBuffer)
	cCar := SubStr(cBuffer,nX,01)
	If IsAlpha(cCar) .or. isDigit(cCar) .or. cCar$(' ()><#.-:=$?+"/')
		cRet += cCar
	EndIf
Next nX

Return cRet 