/*---------------------------------------------------------------------------+
!                       FICHA TECNICA DO PROGRAMA                            !
+----------------------------------------------------------------------------+
!                          DADOS DO PROGRAMA                                 !
+------------------+---------------------------------------------------------+
!Autor             ! Silvio Rodrigues Lima                                   !
+------------------+---------------------------------------------------------+
!Descricao         ! Limite pgto Bienio Empresa 10 com base no Sal. Categoria!
+------------------+---------------------------------------------------------+
!Nome              ! BIENIO10 e BIENIO11                                     !
+------------------+---------------------------------------------------------+
!Data de Criação   ! 17/02/2014                                              !
+------------------+--------------------------------------------------------*/

#Include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"
                         

User Function BIENIO10()  // Roteiro da Folha
      
nSalCategoria := POSICIONE("SRJ", 1, xFilial("SRJ")+SRA->RA_CODFUNC, "RJ_X_SACAT")  

nLimite      := GETMV("MV_LIM10TM") 
nDiasCalc    := FBUSCAPD("101","H")
nValLimite   := (nSalCategoria / 30 * nDiasCalc )  * nLimite
nVal116      := FBUSCAPD("116","V")
nVal101      := FBUSCAPD("101","V")
nPerc        := nVal116 / nVal101
nValAdc      := (nSalCategoria / 30 * nDiasCalc ) * nPerc

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

IF SRA->RA_SINDICA = "02" .AND. !empty(nVal116) .AND. !empty(nSalCategoria) 
                                                                                                    
fDelPd("116")

	IF (nValAdc > nValLimite)
	FGERAVERBA("116",nValLimite, nLimite*100, " ", , "V", , , , dData_Pgto, .T.)
	ENDIF
		 
	IF (nValAdc <= nValLimite)
	FGERAVERBA("116",nValAdc, nPerc*100, " ", , "V", , , , dData_Pgto, .T.)
	ENDIF
     
ENDIF
	
Return  



User Function BIENIO11() // Roteiro de Férias
      
nSalCategoria := POSICIONE("SRJ", 1, xFilial("SRJ")+SRA->RA_CODFUNC, "RJ_X_SACAT")  

nLimite      := GETMV("MV_LIM10TM")
nDiasCalc    := FBUSCAPD("177","H")
nValLimite   := (nSalCategoria / 30 * nDiasCalc )  * nLimite
nVal116      := FBUSCAPD("116","V")
nVal177      := FBUSCAPD("177","V")
nPerc        := nVal116 / nVal177
nValAdc      := (nSalCategoria / 30 * nDiasCalc ) * nPerc

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

IF SRA->RA_SINDICA = "02" .AND. !empty(nVal116) .AND. !empty(nSalCategoria) 
                                                                                                    
fDelPd("116")

	IF (nValAdc > nValLimite)
	FGERAVERBA("116",nValLimite, nLimite*100, " ", , "V", , , , dData_Pgto, .T.)
	ENDIF
		 
	IF (nValAdc <= nValLimite)
	FGERAVERBA("116",nValAdc, nPerc*100, " ", , "V", , , , dData_Pgto, .T.)
	ENDIF
     
ENDIF
	
Return


