/*------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                         !
+-------------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                           !
+------------------+------------------------------------------------------------+
!Modulo            ! Gestão de Pessoal                                          !
+------------------+------------------------------------------------------------+
!Autor             ! Silvio - SMS                                               !
+------------------+------------------------------------------------------------+
!Descricao         ! Programa para limitar Adicional Tempo Serviço Filial 01 
!				   ! alterado para filial 05 
+------------------+------------------------------------------------------------+
!Nome              ! xAdtL131                                                   !
+------------------+------------------------------------------------------------+
!Data de Criacao   ! 20/11/2014                                                 !
+------------------------------------------------------------------------------*/

#INCLUDE "protheus.ch"

User function xAdtL131() // u_xAdtL131()     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// nAdtServ Variável que recebe o valor integral do adicional por tempo de serviço 

// Programa será utilizado no roteiro de cálculo 131 - Primeira Parcela do Décimo Terceiro

IF SRA->RA_FILIAL = "05"
	IF nAdtServ > SRA->RA_SALARIO * 0.20
		nAdtServ := SRA->RA_SALARIO * 0.20
	ENDIF
ENDIF

Return

