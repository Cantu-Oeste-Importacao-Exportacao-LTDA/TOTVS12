#include "rwmake.ch" 
#include "topconn.ch"
#include "protheus.ch"

User Function AtuSE1()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama função para monitor uso de fontes customizados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())
    
	MsAguarde({|| AtuSEA() },"Aguarde! Atualizando a Conta dos Registros no Contas a Receber...") 
	
Return

Static Function AtuSEA() 

Local cEA_NUMBOR	:= ""
Local cEA_PREFIXO	:= ""        	
Local cEA_NUM		:= ""
Local cEA_PARCELA	:= ""
Local cEA_TIPO		:= ""
Local cPORTADOR		:= ""
Local cAgencia		:= ""
Local cConta		:= ""

Local cAliasTMP    := GetNextAlias()

	cQuery := "	SELECT											" + CHR(13)+CHR(10)
	cQuery += "		SEA.EA_FILIAL,								" + CHR(13)+CHR(10)
	cQuery += "		SEA.EA_NUMBOR,								" + CHR(13)+CHR(10)
	cQuery += "		SEA.EA_PREFIXO,								" + CHR(13)+CHR(10)
	cQuery += "		SEA.EA_NUM	,								" + CHR(13)+CHR(10)
	cQuery += "		SEA.EA_PARCELA,								" + CHR(13)+CHR(10)
	cQuery += "		SEA.EA_TIPO,								" + CHR(13)+CHR(10)
	cQuery += "		SEA.EA_PORTADO,								" + CHR(13)+CHR(10)		                 
	cQuery += "		SEA.EA_AGEDEP,								" + CHR(13)+CHR(10)
	cQuery += "		SEA.EA_NUMCON								" + CHR(13)+CHR(10)
	cQuery += "	FROM " + RetSQLName("SEA") + "_OLD SEA			" + CHR(13)+CHR(10)
	cQuery += "	WHERE											" + CHR(13)+CHR(10)
	cQuery += "		SEA.D_E_L_E_T_ != '*'						" + CHR(13)+CHR(10)
	cQuery += "	ORDER BY										" + CHR(13)+CHR(10)
	cQuery += "		SEA.EA_FILIAL,								" + CHR(13)+CHR(10)
	cQuery += "		SEA.EA_NUMBOR,								" + CHR(13)+CHR(10)
	cQuery += "		SEA.EA_PREFIXO,								" + CHR(13)+CHR(10)
	cQuery += "		SEA.EA_NUM	,								" + CHR(13)+CHR(10)		                 
	cQuery += "		SEA.EA_PARCELA,								" + CHR(13)+CHR(10)
	cQuery += "		SEA.EA_TIPO,								" + CHR(13)+CHR(10)
	                                                             
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Armezena no array produtos e detalhes dos pedidos                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	While (cAliasTMP)->(!EOF())

		cEA_NUMBOR	:= (cAliasTMP)->EA_NUMBOR
		cEA_PREFIXO	:= (cAliasTMP)->EA_PREFIXO
		cEA_NUM		:= (cAliasTMP)->EA_NUM
		cEA_PARCELA	:= (cAliasTMP)->EA_PARCELA
		cEA_TIPO	:= (cAliasTMP)->EA_TIPO
		cEA_PORTADO	:= (cAliasTMP)->EA_PORTADO
		cEA_AGEDEP	:= (cAliasTMP)->EA_AGEDEP
		cEA_NUMCON	:= (cAliasTMP)->EA_NUMCON
	
		// Posiciono na SE1 para pegar a Agencia e Conta do banco
		dbSelectArea("SE1")
		SE1->( dBSetOrder( 1 ) )
		SE1->( dBGotop( ) ) 
		IF SE1->(dbSeek( (cAliasTMP)->EA_FILIAL + (cAliasTMP)->EA_PREFIXO + (cAliasTMP)->EA_NUM + (cAliasTMP)->EA_PARCELA + (cAliasTMP)->EA_TIPO )) //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	
	   		If SE1->E1_PORTADO == (cAliasTMP)->EA_PORTADO .AND. SE1->E1_NUMBOR == (cAliasTMP)->EA_NUMBOR .AND. EMPTY(SE1->E1_CONTA) .and. !EMPTY(SE1->E1_NUMBCO)
		 		 RecLock( "SE1", .F. )
	
		         	SE1->E1_AGEDEP	:= (cAliasTMP)->EA_AGEDEP
		         	SE1->E1_CONTA	:= (cAliasTMP)->EA_NUMCON 
		         
			     SE1->( MsUnlock( ) )
			EndIf
	    Endif
	    
    	(cAliasTMP)->(dBSkip()) 
	Enddo
	(cAliasTMP)->(dbCloseArea())

	Aviso( "Processo Concluído !", "Atualização da Agência e Conta Finalizado na SE1. ", { "Ok" }, 3 )

Return