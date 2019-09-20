#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"


/*__________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    �  NGFIMOS      � Autor � Renata Calaca     � Data �27.11.13 ���
��+----------+------------------------------------------------------------���
���Descri��o � Fun��o para finalizar a ordens de servi�o atrav�s da       ���
���          � inclus�o de documento de entrdada.                         ���
��+----------+------------------------------------------------------------���
��� Uso      � Cantu - Call Center                                        ���
��+----------+------------------------------------------------------------��� 
���������������������������������������������������������������������������*/


/*__________________________________________________________________________
��+----------+------------------------------------------------------------��� 
��� Parametros   � cOS     - Numero da Ordem de Servico                   ���
���              � cPLANO  - Plano de Manutencao                          ���
���              � dINI    - Data Parada Inicio                           ���
���              � hINI    - Hora Parada Inicio.                          ���
���              � dFIM    - Data Parada Fim                              ���
���              � hFIM    - Hora Parada Fim                              ���
���              � nPOSCONT- Posicao do Contador  						  ���
���				 � nPOSCON2- Posicao do Contador 2 						  ���
���				 � cPadrao - Pelo padrao								  ���
���				 � dVDTF   - Data de finalizacao 						  ���
���				 � cHORF   - Hora de finalizacao                          ���
���				 � vDtHoF  - Vetor com as datas e Horas de finalizacao	  ���
���				                                                          ���
��+-----------------------------------------------------------------------+��
���������������������������������������������������������������������������*/  

User Function NGFIMOS()

Local aArea := GetArea() 

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

	NGFIMOS(STJ->TJ_ORDEM,STJ->TJ_PLANO,STJ->TJ_DTPRINI,STJ->TJ_HOPRINI,STJ->TJ_DTPRFIM,STJ->TJ_HOPRFIM,STJ->TJ_POSCONT,STJ->TJ_POSCON2,"NAO")

RestArea( aArea )

Return
