#INCLUDE "rwmake.ch"                     
#INCLUDE "TopConn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � M410PCDV � Autor � Adriano Novachaelley Data �  22/11/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada utilizado para filtrar notas fiscais de   ���
���          � origem. Quando tipo da nota fiscal for DEVOLUCAO           ���
�������������������������������������������������������������������������͹��
���Uso       � PEDIDO DE VENDA (MATA410) -> BOTAO RETORNAR                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                
User Function M410PCDV()
Local cRet			:= "" 
Local nPNfOri   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_NFORI"}) 		// Posi��o C6_NFORI
Local nPSerOri  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_SERIORI"})   // Posi��o C6_SERIORI
Local nPIteOri  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEMORI"})		// Posi��o C6_ITEMORI     
Local nPclasfi  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_CLASFIS"})		// Posi��o C6_CLASFIS      
Local nDiaDev	:= SuperGetMv("MV_DIASDEV",,60)                       // Dias considerados para filtro. 
Local aColsBKP	:= aCols   
Local aArea  	:= GetArea()
aCols := {}    

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())


For nR := 1 To Len(aColsBKP)
	cSql := "SELECT D1.D1_FILIAL, D1.D1_DOC, D1.D1_SERIE, D1.D1_FORNECE, D1.D1_LOJA, D1.D1_CLASFIS "
	cSql += "FROM "+RetSqlName("SD1")+" D1 "
	cSql += "WHERE D1.D_E_L_E_T_ <> '*' "
	cSql += "AND D1.D1_FILIAL = '"+xFilial("SD1")+"' "
	cSql += "AND D1.D1_FORNECE = '"+cFornece+"' AND D1.D1_LOJA = '"+cLoja+"' "
	cSql += "AND D1.D1_DOC = '"+aColsBKP[nR,nPNfOri]+"' AND D1.D1_SERIE = '"+aColsBKP[nR,nPSerOri]+"' "
	cSql += "AND D1.D1_ITEM = '"+aColsBKP[nR,nPIteOri]+"' "
	cSql += "AND D1.D1_DTDIGIT >= '"+DtoS(Date()-nDiaDev)+"'" "
	TcQuery cSql NEW ALIAS "TMPD1"
	TMPD1->(dbSelectArea("TMPD1"))
	TMPD1->(dbGoTop())	
	If !TMPD1->(Eof())   
		aColsbkp[nR,nPclasfi] := TMPD1->D1_CLASFIS
		AADD(aCols,aColsBKP[nR])
	Else
		Alert("Nota fiscal "+aColsBKP[nR,nPNfOri]+" n�o pode ser devolvida, verificar o parametro MV_DIASDEV!")
	Endif
	TMPD1->(dbSelectArea("TMPD1"))
	TMPD1->(DbCloseArea())

Next nR             

RestArea(aArea)

Return()