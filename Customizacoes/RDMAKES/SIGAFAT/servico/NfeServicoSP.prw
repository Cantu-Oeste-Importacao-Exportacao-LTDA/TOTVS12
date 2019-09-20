//+--------------------------------------------------------------------+
//| Rotina | NfeSP    | Autor | Flavio Dias        | Data | 03.03.2010 |
//+--------------------------------------------------------------------+
//| Descr. | Controle para impressao dos servicos da NFe               |
//+--------------------------------------------------------------------+
//| Uso    | Espec�fico Cantu                                          |
//+--------------------------------------------------------------------+

#Include "Protheus.ch"
User Function MTDescrNFE(aParam)
Local cDescServ := ""
Local cNF := Paramixb[01] //  N�mero do RPS gerado (F3_NFISCAL) 
Local cSerie := Paramixb[02] //  S�rie do RPS gerado 
Local cCli := Paramixb[03] //  C�digo do cliente 
Local cLoja := Paramixb[04] //  Loja do cliente 
Local aArea := GetArea()
Local cStr := ""
// busca no sd2 os servicos
dbSelectArea("SD2")
dbSetOrder(03)  // Doc+ serie+cliente+loja
dbSeek(xFilial("SD2") + cNF + cSerie)    

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

While (xFilial("SD2") + cNF + cSerie == D2_FILIAL + D2_DOC + D2_SERIE)	
	cStr = Posicione("SC6", 01, xFilial("SC6") + D2_PEDIDO + D2_ITEMPV, "C6_DESCRI")
	cDescServ += AllTrim(cStr) + "  ->  " + Transform(D2_TOTAL, "@E 9,999,999.99") + "|"
	SD2->(dbSkip())
Enddo
RestArea(aArea)
Return cDescServ