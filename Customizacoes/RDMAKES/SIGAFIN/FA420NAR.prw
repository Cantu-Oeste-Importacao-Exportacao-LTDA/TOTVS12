#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA420NAR  �Autor  �Edison G. Barbieri  � Data �  03/03/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada executado na gera��o do arquivo CNAB      ���
���          � que altera o caminho, nome e extens�o                      ���
�������������������������������������������������������������������������͹��
���Uso       � Financeiro                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*-------------------------*
User Function FA420NAR()    
*-------------------------*

Local cTeste    := PARAMIXB 
Local aArea		:= GetArea()    

Public cArqAux	:= "" //Edison para que esse caminho seja validado ap�s a gera��o do arquivo.   
Public cArqTemp	:= "" //Edison para que esse arquivo seja validado ap�s a gera��o do arquivo.
Public cTipo		:= "" //Edison para que esse arquivo seja validado ap�s a gera��o do arquivo. 

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������

U_USORWMAKE(ProcName(),FunName())

//����������������������������������������������������������������������
//�Caso o usu�rio queira usar a transmiss�o autom�tica, chama a fun��o �
//�para montagem do caminho, nome e extens�o do arquivo.               �
//����������������������������������������������������������������������

if MsgYesNo("Deseja gerar o border� para transmiss�o autom�tica do arquivo?")
	cTeste := U_GETARQFIN(MV_PAR05, MV_PAR06, MV_PAR07, MV_PAR08)  
	if Empty(cTeste)
		//��������������������������������������������������������������������������������
		//�Se na montagem da nomenclatura o retorno veio vazio, gera pelo processo normal�
		//��������������������������������������������������������������������������������
		MsgAlert("N�o h� nomenclatura padr�o cadastrada para o Banco/Agencia/Conta.")
		cTeste := PARAMIXB
	Else
EndIf

//�����������������������������������������������Ŀ
//�Chamada da fun��o para gravar log na tabela Z49�
//�������������������������������������������������
U_GravaZ49(cTeste,{MV_PAR05, MV_PAR06, MV_PAR07, MV_PAR08},"NEXXERA")
MsgInfo("Arquivo salvo em "+ AllTrim(cTeste) +".")
	
EndIf

RestArea(aArea)
                         
Return cTeste          