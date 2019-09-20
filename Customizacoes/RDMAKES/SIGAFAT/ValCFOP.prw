#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VALCFOP   �Autor  �Flavio Dias         � Data �  02/17/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o de CFOP nas notas de entrada para impedir        ���
���          � que um cfop com inicial 1 seja usado para uma  	    			���
���          � compra interestadual        																���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ValCFOP()
Local aArea := GetArea()
Local lOk := ParamIXB[1]
Local lCfopOk := .T.
Local i
Local cCod := CA100FOR
//Local cTipo := C100Tipo
Local nPosCfo := aScan(aHeader, { |x| x[2] = "D1_CF"})
Local cUF := MAFISRET(, "NF_UFORIGEM")
Local cCfo
Local cUFEmp := SM0->M0_ESTENT
							// verifica se o arquivo existe  
							
//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())							
							
if (lOk)
	for i:= 1 to len(aCols)
  	cCfo := SubStr(aCols[i, nPosCfo], 1, 1)
  	lCfopOK := lCfopOk .And. ((cCfo == "1" .And. cUF == cUFEmp);
  								    .Or. (cCfo == "2" .And. cUf != cUFEmp);
  								    .Or. (cUF == "EX"))
  Next
EndIf

if (!lCfopOK)
  lOk := .F.
  Alert("Verifique o CFOP informado pois est� incompat�vel com a UF de destino.", "Valida��o de CFOP(U_ValCFOP)")
EndIf
RestArea(aArea)
Return lOk