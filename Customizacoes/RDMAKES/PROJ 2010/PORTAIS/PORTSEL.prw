


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PORTSEL   � Autor � Adriano Novachaelley Data �  23/11/2010 ���
�������������������������������������������������������������������������͹��
���Descricao �                                                             ��
�������������������������������������������������������������������������͹��
���Uso       �  RJU                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

// Este ponto de entrada foi criado para configurar quais portais dever�o aparecer no campo Tipo (combo) da tela de 
// Login dos Portais
// O retorno deste P.E. deve ter um dos seguintes valores (em caracter):

// 0 � Para exibir todos os portais
// 1 � Para exibir somente o primeiro Portal (RH)
// 2 � Para exibir somente o segundo Portal (PMS)
// 3 � Para exibir somente o terceiro Portal (PLS)
// 4 � Para exibir somente o quarto Portal (Portal Protheus)


User Function PORTSEL()
Local cRet := "0"     

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())
 
                                                                     	
Return(cRet)