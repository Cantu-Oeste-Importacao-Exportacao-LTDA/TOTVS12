/*------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                         !
+-------------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                           !
+------------------+------------------------------------------------------------+
!Modulo            ! Gest�o de Pessoal                                          !
+------------------+------------------------------------------------------------+
!Autor             ! Silvio - SMS                                               !
+------------------+------------------------------------------------------------+
!Descricao         ! Programa para limitar Adicional Tempo Servi�o Filial 01 
!				   ! alterado para filial 05 
+------------------+------------------------------------------------------------+
!Nome              ! xAdtL131                                                   !
+------------------+------------------------------------------------------------+
!Data de Criacao   ! 20/11/2014                                                 !
+------------------------------------------------------------------------------*/

#INCLUDE "protheus.ch"

User function xAdtL131() // u_xAdtL131()     

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

// nAdtServ Vari�vel que recebe o valor integral do adicional por tempo de servi�o 

// Programa ser� utilizado no roteiro de c�lculo 131 - Primeira Parcela do D�cimo Terceiro

IF SRA->RA_FILIAL = "05"
	IF nAdtServ > SRA->RA_SALARIO * 0.20
		nAdtServ := SRA->RA_SALARIO * 0.20
	ENDIF
ENDIF

Return

