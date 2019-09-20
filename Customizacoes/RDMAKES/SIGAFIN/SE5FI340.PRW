/*
+----------------------------------------------------------------------------+
!                       FICHA TECNICA DO PROGRAMA                            !
+----------------------------------------------------------------------------+
!                          DADOS DO PROGRAMA                                 !
+------------------+---------------------------------------------------------+
!Autor             ! Carlos Eduardo                                          !
+------------------+---------------------------------------------------------+
!Descricao         ! Ponto de entrada para gravação de dados complementares  !
!				   				 ! na compensação dos titulos a pagar.                     !
+------------------+---------------------------------------------------------+
!Nome              ! SE5FI340                                                !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 20/04/2012                                              !
+------------------+---------------------------------------------------------+
*/

// Gravação dos campos na SE5 conforme SE2
User Function SE5FI340 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

RecLock("SE5",.F.)
	
	SE5->E5_CLVLDB 	= SE2->E2_CLVLDB
	SE5->E5_CLVLCR	= SE2->E2_CLVLCR
	SE5->E5_CCD			= SE2->E2_CCD
	SE5->E5_CCC			= SE2->E2_CCC
	SE5->E5_ITEMD		= SE2->E2_ITEMD
	SE5->E5_ITEMC		= SE2->E2_ITEMC
	
MsUnLock()     


Return