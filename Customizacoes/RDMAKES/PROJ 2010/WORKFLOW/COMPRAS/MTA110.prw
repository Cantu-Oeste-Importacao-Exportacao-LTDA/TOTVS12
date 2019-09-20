/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA110OK  �Autor  �Flavio Dias         � Data �  06/13/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada ap�s a inclus�o de uma solicita��o de      ���
���          �Compra                                                      ���
�����������������������������������������������������������������������������                               
�����������������������������������������������������������������������������
*/

User Function MTA110OK()
// chama fun��o para enviar email para o comprador  

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

MailComp()
Return .T.

/************************************************************
 Envia email para o comprador no momento de efetuar a 
 solicita��o de compra
 ************************************************************/
Static Function MailComp()
LOCAL aSeg 	   := GetArea()
Local cNumSC   := PARAMIXB[1]
Local nColIt, nColCod, nColDesc, nColQtd, nColUM, nColComp
Local lOk := .T.
LOCAL cProcess := Space(6), cStatus := Space(6), cEmail := ""
LOCAL cUser    := PARAMIXB[2]

//  busca as colunas necess�rias
nColIt   := aScan(aHeader,{|x| AllTrim(x[2])=="C1_ITEM"})    // para obter qual a posi��o do campo no acols.
nColCod  := aScan(aHeader,{|x| AllTrim(x[2])=="C1_PRODUTO"}) // para obter qual a posi��o do campo no acols.
nColDesc := aScan(aHeader,{|x| AllTrim(x[2])=="C1_DESCRI"})  // para obter qual a posi��o do campo no acols. 
nColQtd  := aScan(aHeader,{|x| AllTrim(x[2])=="C1_QUANT"})   // para obter qual a posi��o do campo no acols. 
nColUM   := aScan(aHeader,{|x| AllTrim(x[2])=="C1_UM"})      // para obter qual a posi��o do campo no acols.
nColObs  := aScan(aHeader,{|x| AllTrim(x[2])=="C1_OBS"})     // para obter qual a posi��o do campo no acols.
nColSeg  := aScan(aHeader,{|x| AllTrim(x[2])=="C1_CLVL"})    // para obter qual a posi��o do campo no acols.
nColCc   := aScan(aHeader,{|x| AllTrim(x[2])=="C1_CC"})      // para obter qual a posi��o do campo no acols.
nColItCta:= aScan(aHeader,{|x| AllTrim(x[2])=="C1_ITEMCTA"}) // para obter qual a posi��o do campo no acols.
nColComp := aScan(aHeader,{|x| AllTrim(x[2])=="C1_CODCOMP"}) // para obter qual a posi��o do campo no acols.

// Inicia processo de envio do e-mail
cProcess := OemToAnsi("001010") // Numero do Processo
cStatus  := OemToAnsi("001011")

oProcess := TWFProcess():New(cProcess,OemToAnsi("Solicita��o de Compra"))
oProcess:NewTask(cStatus,"\workflow\wfsolicitacao.htm")
oProcess:cSubject := OemToAnsi("Solicita��o de Compra no " + cNumSC + " - Emp./ Filial: " + cEmpAnt + "/" + cFilAnt)

cEmail := Posicione("SY1", 1, xFilial("SY1") + cCodCompr, "Y1_EMAIL")

oProcess:cTo := ALLTRIM(cEmail) 
//oprocess:cCc := SuperGetMv("MV_X_MSOLI",,"compras01@cantu.com.br") //E-mail do respons�vel que deve receber, o que esta hoje � o compras01@cantu.com.br Guilherme 22/01/13
                                    
// Preenchimento do cabe�alho da solicita��o
oHTML:= oProcess:oHTML		
oHtml:ValByName("DATA"   ,DTOC(dDataBase))
oHtml:ValByName("NSOLIC" ,cNumSC)
oHtml:ValByName("USER"   ,cUser)
	
For i:= 1 to len(aCols)
	AAdd(oHtml:ValByName("IT.ITEM")    ,aCols[i, nColIt])
	AAdd(oHtml:ValByName("IT.CODPRO")  ,aCols[i, nColCod])
	AAdd(oHtml:ValByName("IT.DESCPRO") ,aCols[i, nColDesc])
	AAdd(oHtml:ValByName("IT.QTD")     ,aCols[i, nColQtd])
	AAdd(oHtml:ValByName("IT.UM")      ,aCols[i, nColUM])		
	AAdd(oHtml:ValByName("IT.OBS")     ,aCols[i, nColObs])
	
	dColSeg   := Posicione("CTH", 1, xFilial("CTH") + aCols[i, nColSeg],    "CTH_DESC01")
	dColCc    := Posicione("CTT", 1, xFilial("CTT") + aCols[i, nColCc],     "CTT_DESC01")
	dColItCta := Posicione("CTD", 1, xFilial("CTD") + aCols[i, nColItCta], "CTD_DESC01")
	
	AAdd(oHtml:ValByName("IT.CLVL")    ,dColSeg)
  AAdd(oHtml:ValByName("IT.CC")      ,dColCc)
	AAdd(oHtml:ValByName("IT.ITEMCTA") ,dColItCta)	
Next
	
oProcess:Start()

RestArea(aSeg)
Return Nil