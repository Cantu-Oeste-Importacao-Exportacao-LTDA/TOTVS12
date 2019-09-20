#INCLUDE "PROTHEUS.CH" 
#INCLUDE "RWMAKE.CH"

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄM¿
//³Guilherme Poyer - 15-05-12 - Registro C120 SPED PIS COFINS             ³
//³Ponto de entrada para incluir as informações das notas de importação   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

User Function SPDIMP()

Local	cDoc			:=	PARAMIXB[1] //FT_NFISCAL
Local	cSerie		:=	PARAMIXB[2] //FT_SERIE
Local	cFornec		:=	PARAMIXB[3] //FT_CLIEFOR
Local	cLoja			:=	PARAMIXB[4] //FT_LOJA
Local	dEntr			:=	PARAMIXB[5] //FT_ENTRADA	 
Local	cChave		:=	""      
Local	lTipoEx		:=	.F.
Local	aRetorno	:=	{}
Local	aAreaSFT	:=	SFT->(GetArea())
Local	aAreaSA2	:=	SA2->(GetArea()) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If SA2->(DbSeek(xFilial("SA2")+cFornec+cLoja))
	lTipoEx	:=	(SA2->A2_TIPO == "X")
Endif
  
If lTipoEx
	
	cChave	:=	xFilial("SFT")+"E"+DTOS(dEntr)+cSerie+cDoc+cFornec+cLoja
	
	If SFT->(DbSeek(cChave))
	 //	While SFT->FT_FILIAL+SFT->FT_TIPOMOV+DTOS(SFT->FT_ENTRADA)+SFT->FT_SERIE+SFT->FT_NFISCAL+SFT->FT_CLIEFOR+SFT->FT_LOJA == cCha
		 	If SF1->(DbSeek(xFilial("SF1")+cDoc+cSerie+cFornec+cLoja))  
													aAdd(aRetorno,{ "0",;				        //02 - COD_DOC_IMP
													                SF1->F1_X_NUMDI,;   //03 - NUM_DOC_IMP
													                SF1->F1_VALIMP6,;		//04 - PIS_IMP
									 				                SF1->F1_VALIMP5,;		//05 - COF_IMP
																				})	//06 - NUM_ACDRAW
			EndIf			
		 //	SFT->(DbSkip())
	 //	End
	Endif
Endif

RestArea(aAreaSFT)
RestArea(aAreaSA2)

Return aRetorno