#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*

+----------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                      !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Modulo            !  Callcenter - Televendas                                !
+------------------+---------------------------------------------------------+
!Nome              !                                                         !
+------------------+---------------------------------------------------------+
!Descricao         ! Ponto de entrada para preencher o  campo SEGMENTO no    !
!                  ! Pedido de Venda com o valor informado no pedido incluido!
!                  !  no Televendas.                                         !
+------------------+---------------------------------------------------------+
!Autor             ! Renata Cristina Cala�a                                  !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 20/07/2012                                              !
+------------------+---------------------------------------------------------+

*/


User Function TMKVFIM   

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

If nFolder == 2
	
	Reclock("SC5",.F.)
	SC5->C5_X_CLVL := SUA->UA_X_CLVL
	SC5->(MsUnlock())
	
	
Endif

Return
