#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"


/*__________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçäo    ¦  NGFIMOS      ¦ Autor ¦ Renata Calaca     ¦ Data ¦27.11.13 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Função para finalizar a ordens de serviço através da       ¦¦¦
¦¦¦          ¦ inclusão de documento de entrdada.                         ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ Cantu - Call Center                                        ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦ 
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/


/*__________________________________________________________________________
¦¦+----------+------------------------------------------------------------¦¦¦ 
¦¦¦ Parametros   ³ cOS     - Numero da Ordem de Servico                   ¦¦¦
¦¦¦              ³ cPLANO  - Plano de Manutencao                          ¦¦¦
¦¦¦              ³ dINI    - Data Parada Inicio                           ¦¦¦
¦¦¦              ³ hINI    - Hora Parada Inicio.                          ¦¦¦
¦¦¦              ³ dFIM    - Data Parada Fim                              ¦¦¦
¦¦¦              ³ hFIM    - Hora Parada Fim                              ¦¦¦
¦¦¦              ³ nPOSCONT- Posicao do Contador  						  ¦¦¦
¦¦¦				 ³ nPOSCON2- Posicao do Contador 2 						  ¦¦¦
¦¦¦				 ³ cPadrao - Pelo padrao								  ¦¦¦
¦¦¦				 ³ dVDTF   - Data de finalizacao 						  ¦¦¦
¦¦¦				 ³ cHORF   - Hora de finalizacao                          ¦¦¦
¦¦¦				 ³ vDtHoF  - Vetor com as datas e Horas de finalizacao	  ¦¦¦
¦¦¦				                                                          ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/  

User Function NGFIMOS()

Local aArea := GetArea() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	NGFIMOS(STJ->TJ_ORDEM,STJ->TJ_PLANO,STJ->TJ_DTPRINI,STJ->TJ_HOPRINI,STJ->TJ_DTPRFIM,STJ->TJ_HOPRFIM,STJ->TJ_POSCONT,STJ->TJ_POSCON2,"NAO")

RestArea( aArea )

Return
