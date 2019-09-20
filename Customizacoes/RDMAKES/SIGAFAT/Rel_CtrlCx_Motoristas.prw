#INCLUDE "rwmake.ch" 
#INCLUDE "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³REL_CTRLCX_MOTORISTASºAutor  ³Microsiga  Data ³  10/02/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função utilizada para gerar relatório de saldo de mov. de  º±±
±±º          ³ caixas x motorista.		         						  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ OMS - Gestão de Distribuição			                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//modificado por Gustavo em 20/01/14 para fazer o controle de bins e palet

User Function RELSLDCXS()

Local cDesc1         	:= "Este programa tem como objetivo imprimir um relatorio "
Local cDesc2         	:= "de saldos de caixas por motorista."
Local cDesc3        	:= ""
Local cPict          	:= ""
Local titulo        	:= "SALDO CAIXAS X MOTORISTA"
Local nLin         		:= 80
Local Cabec1       		:= "cCabec1"
Local Cabec2       		:= "Codigo  Nome Motorista                                  Saldo"
Local imprime      		:= .T.
Local aOrd 				:= {}  
Private lEnd         	:= .F.
Private lAbortPrint  	:= .F.
Private CbTxt        	:= ""
Private limite      	:= 80
Private tamanho       	:= "P"
Private nomeprog      	:= "RJU00005" 
Private nTipo         	:= 18
Private aReturn       	:= { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey      	:= 0
Private cbtxt      		:= Space(10)
Private cbcont     		:= 00
Private CONTFL     		:= 01
Private m_pag      		:= 01
Private wnrel     		:= "RJU00005" 
Private cPerg			:= "RJU0000500"
Private cString			:= ""     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

AjustaSX1()

Pergunte(cPerg,.F.)
                        
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return


Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local nOrdem 
Local cEol    := CHR(13)+CHR(10)

Private cMotIni	:= mv_par01
Private cMotFin := mv_par02
Private dDtIni	:= DtoS(mv_par03)
Private dDtFin	:= DtoS(mv_par04)
Private nTipoRel:= mv_par05
Private nSaldo	:= 0
Private nSEntr	:= 0 // SubTotal Entradas
Private nSSaid	:= 0 // SubTotal Saidas
Private nTEntr	:= 0 // Total Entradas
Private nTSaid	:= 0 // Total Saidas
Private nValCxPlas := 0.05 // Valor pago por caixa de plástico
Private nValCxMad  := 0.20 // Valor pago por caixa de madeira
Private nValCxPap  := 0.30 // Valor pago por caixa de papelão   
Private nValCxSac  := 0.30 // Valor pago por saco de batata
//nValCx	:= mv_par06 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se o tipo do relatório for sintético...³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If nTipoRel = 1
	Cabec1	:= "PERIODO DE "+DtoC(mv_par03)+" A "+DtoC(mv_par04)
	Cabec2  := "CODIGO| NOME MOTORISTA                               |  SALDO | " 

	cSql := "SELECT ZR.ZR_MOTORIS, ZR.ZR_TPMOV, ZR.ZR_TPCAIXA, ZR.ZR_QUANT, ZR.ZR_DATA "    +Eol
	cSql += "FROM "+RetSqlName("SZR")+" ZR "                                                +Eol
	cSql += "WHERE ZR.D_E_L_E_T_ <> '*' AND ZR.ZR_FILIAL = '"+xFilial("SZR")+"' "           +Eol
	cSql += "AND ZR.ZR_DATA BETWEEN '"+dDtIni+"' AND '"+dDtFin+"' "                         +Eol
	cSql += "AND ZR.ZR_MOTORIS BETWEEN '"+cMotIni+"' AND '"+cMotFin+"' "                    +Eol
	cSql += "ORDER BY ZR.ZR_MOTORIS, ZR.ZR_TPMOV, ZR.ZR_TPCAIXA "                           +Eol
	
	TCQUERY cSql NEW ALIAS "TMPSZR"
	   
	DbSelectArea("TMPSZR")
	TMPSZR->(DbGotop())
	SetRegua(RecCount())
	
	cMotAtu := TMPSZR->ZR_MOTORIS
	While !TMPSZR->(EOF())
		IncRegua()
		If cMotAtu <> TMPSZR->ZR_MOTORIS
		    If nLin > 60
		       Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		       nLin := 9
		    Endif
		    @nLin, 000 Psay cMotAtu
		    @nLin, 008 Psay POSICIONE("DA4",1,xFilial("DA4")+cMotAtu,"DA4_NOME")
		    @nLin, 052 Psay nSaldo Picture "@E 9,999,999"
		    nSaldo := 0
			nLin += 1
		Endif
		nSaldo += Iif(TMPSZR->ZR_TPMOV $ '2',TMPSZR->ZR_QUANT,-TMPSZR->ZR_QUANT)
		cMotAtu := TMPSZR->ZR_MOTORIS
		
		TMPSZR->(dbSkip())
	EndDo
	If !Empty(cMotAtu)
		If nLin > 60
		   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		   nLin := 9
		Endif
		@nLin, 000 Psay cMotAtu
		@nLin, 006 Psay "|"
		@nLin, 008 Psay POSICIONE("DA4",1,xFilial("DA4")+cMotAtu,"DA4_NOME")	
    @nLin, 037 Psay "|"
		@nLin, 052 Psay nSaldo Picture "@E 9,999,999"   
	Endif
	DbSelectArea("TMPSZR")
	TMPSZR->(DbCloseArea())              
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso o usuário escolha a opção de relatório analítico...³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Else
	Cabec1	:= "PERIODO DE "+DtoC(mv_par03)+" A "+DtoC(mv_par04)+"                                         "
	Cabec2  := "CODIGO|NOME MOTORISTA                |ENTRADA |  SAÍDA|   CRÉDITO|R$ SALDO|"

	cSql := "SELECT ZR.ZR_MOTORIS, ZR.ZR_TPMOV, ZR.ZR_TPCAIXA, ZR.ZR_QUANT, ZR.ZR_DATA "            +cEol
	cSql += "FROM "+RetSqlName("SZR")+" ZR "	                                                      +cEol
	cSql += "WHERE ZR.D_E_L_E_T_ <> '*' AND ZR.ZR_FILIAL = '"+xFilial("SZR")+"' "                   +cEol
	cSql += "AND ZR.ZR_DATA BETWEEN '"+dDtIni+"' AND '"+dDtFin+"' "                                 +cEol
	cSql += "AND ZR.ZR_MOTORIS BETWEEN '"+cMotIni+"' AND '"+cMotFin+"' "                            +cEol
	cSql += "ORDER BY ZR.ZR_MOTORIS, ZR.ZR_TPMOV, ZR.ZR_TPCAIXA "                                   +cEol
	
	TCQUERY cSql NEW ALIAS "TMPSZR"
	

	   
	DbSelectArea("TMPSZR")
	TMPSZR->(DbGotop())
	SetRegua(RecCount())
	cMotAtu := TMPSZR->ZR_MOTORIS
	nCxPapEnt  := 0
	nCxMadEnt  := 0
	nCxPlaEnt  := 0
	nCxPapSai  := 0
	nCxMadSai  := 0
	nCxPlaSai  := 0
	nCxPalEnt  := 0
	nCxPalSai  := 0	 
	nCxBinEnt  := 0
	nCxBinSai  := 0					
	nCxSacEnt  := 0
	nCxSacSai  := 0
	
	While !TMPSZR->(EOF())
		IncRegua()
    
    If nLin > 60
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 9
    Endif		
		
		If cMotAtu <> TMPSZR->ZR_MOTORIS
	    @nLin, 000 Psay iif(Empty(cMotAtu),"XXXXXX",cMotAtu)
	    @nLin, 006 Psay "|"
	    @nLin, 007 Psay iif(Empty(POSICIONE("DA4",1,xFilial("DA4")+cMotAtu,"DA4_NOME")),"MOVTOS SEM CÓDIGO DE MOTORISTA",;
	    								POSICIONE("DA4",1,xFilial("DA4")+cMotAtu,"DA4_NOME"))
			nLin += 1 
			
			if nCxPlaEnt > 0 .or. nCxPlaSai > 0
				@nLin, 016 pSay EscPont("PLÁSTICA",15)
				@nLin, 037 pSay "|"
				@nLin, 039 pSay nCxPlaEnt Picture "@E 999,999"
				@nLin, 046 Psay "|"
				@nLin, 047 pSay nCxPlaSai Picture "@E 999,999"
				@nLin, 054 pSay "|"
				@nLin, 055 pSay (nCxPlaEnt - nCxPlaSai) Picture "@E 999,999"
				@nLin, 065 pSay "|"
				@nLin, 066 pSay ((nCxPlaEnt - nCxPlaSai)* nValCxPlas) Picture "@E 999,999.99"
				@nLin, 076 pSay "|"
				nLin += 1                          
			EndIf

      if nCxMadEnt > 0 .or. nCxMadSai > 0
				@nLin, 016 pSay EscPont("MADEIRA",15)
				@nLin, 037 pSay "|"
				@nLin, 039 pSay nCxMadEnt Picture "@E 999,999"
				@nLin, 046 Psay "|"
				@nLin, 047 pSay nCxMadSai Picture "@E 999,999"
				@nLin, 054 pSay "|"
				@nLin, 055 pSay (nCxMadEnt - nCxMadSai) Picture "@E 999,999"
				@nLin, 065 pSay "|"
				@nLin, 066 pSay ((nCxMadEnt - nCxMadSai)* nValCxMad) Picture "@E 999,999.99"
				@nLin, 076 pSay "|"
				nLin += 1
			EndIf

			if nCxPapEnt > 0 .or. nCxPapSai > 0
				@nLin, 016 pSay EscPont("PAPELÃO",15)
				@nLin, 037 pSay "|"
				@nLin, 039 pSay nCxPapEnt Picture "@E 999,999"
				@nLin, 046 Psay "|"
				@nLin, 047 pSay nCxPapSai Picture "@E 999,999"
				@nLin, 054 pSay "|"
				@nLin, 055 pSay (nCxPapEnt - nCxPapSai) Picture "@E 999,999"
				@nLin, 065 pSay "|"
				@nLin, 066 pSay ((nCxPapEnt - nCxPapSai)* nValCxPap) Picture "@E 999,999.99"
				@nLin, 076 pSay "|"
				nLin += 1
			EndIf 
			
			if nCxPalEnt > 0 .or. nCxPalSai > 0
				@nLin, 016 pSay EscPont("PALET",15)
				@nLin, 037 pSay "|"
				@nLin, 039 pSay nCxPalEnt Picture "@E 999,999"
				@nLin, 046 Psay "|"
				@nLin, 047 pSay nCxPalSai Picture "@E 999,999"
				@nLin, 054 pSay "|"
				@nLin, 055 pSay (nCxPalEnt - nCxPalSai) Picture "@E 999,999"
				@nLin, 065 pSay "|" 
 				@nLin, 074 pSay "-"
				@nLin, 076 pSay "|"
				nLin += 1
			EndIf

			if nCxBinEnt > 0 .or. nCxBinSai > 0
				@nLin, 016 pSay EscPont("BINS",15)
				@nLin, 037 pSay "|"
				@nLin, 039 pSay nCxBinEnt Picture "@E 999,999"
				@nLin, 046 Psay "|"
				@nLin, 047 pSay nCxBinSai Picture "@E 999,999"
				@nLin, 054 pSay "|"
				@nLin, 055 pSay (nCxBinEnt - nCxBinSai) Picture "@E 999,999"
				@nLin, 065 pSay "|"
 				@nLin, 074 pSay "-"
				@nLin, 076 pSay "|"
				nLin += 1
			EndIf	
			
			if nCxSacEnt > 0 .or. nCxSacSai > 0
				@nLin, 016 pSay EscPont("SACO BATATA",15)
				@nLin, 037 pSay "|"
				@nLin, 039 pSay nCxSacEnt Picture "@E 999,999"
				@nLin, 046 Psay "|"
				@nLin, 047 pSay nCxSacSai Picture "@E 999,999"
				@nLin, 054 pSay "|"
				@nLin, 055 pSay (nCxSacEnt - nCxSacSai) Picture "@E 999,999"
				@nLin, 065 pSay "|"
 				@nLin, 066 pSay ((nCxSacEnt - nCxSacSai) * nValCxSac) Picture "@E 999,999.99"
				@nLin, 076 pSay "|"
				nLin += 1
			EndIf		
	 
			/*      
			@nLin, 016 pSay EscPont("TOTAL MOT",15)
	    @nLin, 037 Psay "|"
	    @nLin, 039 Psay nSEntr Picture "@E 999,999"
    	@nLin, 046 Psay "|"
    	@nLin, 047 Psay nSSaid Picture "@E 999,999"
    	@nLin, 054 Psay "|"
    	@nLin, 055 Psay (nSEntr * nValCx) Picture "@E 999,999.99"
    	@nlin, 065 Psay "|"
    	@nLin, 066 Psay ((nSEntr-nSSaid) * nValCx) Picture "@E 999,999.99"
    	@nLin, 076 Psay "|"     
   		*/
   		
   		nLin += 1           
						
			nSEntr	:= 0
			nSSaid	:= 0 	
			nCxPapEnt  := 0
			nCxMadEnt  := 0
			nCxPlaEnt  := 0
			nCxPalEnt  := 0
			nCxBinEnt  := 0
			nCxSacEnt  := 0		
			nCxPapSai  := 0
			nCxMadSai  := 0
			nCxPlaSai  := 0	 
			nCxPalSai  := 0
			nCxBinSai  := 0
			nCxSacSai  := 0						
		Endif
			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se o tipo de movimento for Entrada...³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	 	If TMPSZR->ZR_TPMOV == '2' 
	 		nSEntr 	+= TMPSZR->ZR_QUANT
	 		nTEntr 	+= TMPSZR->ZR_QUANT
	 		
	 		Do Case
		 		Case TMPSZR->ZR_TPCAIXA == '1'
		 			nCxPlaEnt += TMPSZR->ZR_QUANT
		 		Case TMPSZR->ZR_TPCAIXA == '2'
		 			nCxMadEnt += TMPSZR->ZR_QUANT
		 		Case TMPSZR->ZR_TPCAIXA == '3'
		 			nCxPapEnt += TMPSZR->ZR_QUANT
		 		Case TMPSZR->ZR_TPCAIXA == '4'
		 			nCxPalEnt += TMPSZR->ZR_QUANT
		 		Case TMPSZR->ZR_TPCAIXA == '5'
		 			nCxBinEnt += TMPSZR->ZR_QUANT  
		 		Case TMPSZR->ZR_TPCAIXA == '6'
		 			nCxSacEnt += TMPSZR->ZR_QUANT
		 	EndCase
	 			
	 	Else
	 		nSSaid 	+= TMPSZR->ZR_QUANT
	 		nTSaid 	+= TMPSZR->ZR_QUANT
	 		
	 		Do Case
		 		Case TMPSZR->ZR_TPCAIXA == '1'
		 			nCxPlaSai += TMPSZR->ZR_QUANT
		 		Case TMPSZR->ZR_TPCAIXA == '2'
		 			nCxMadSai += TMPSZR->ZR_QUANT
		 		Case TMPSZR->ZR_TPCAIXA == '3'
		 			nCxPapSai += TMPSZR->ZR_QUANT  
		 		Case TMPSZR->ZR_TPCAIXA == '4'	
		 			nCxPalSai += TMPSZR->ZR_QUANT    
		 		Case TMPSZR->ZR_TPCAIXA == '5'	
		 			nCxBinSai += TMPSZR->ZR_QUANT 
		 		Case TMPSZR->ZR_TPCAIXA == '6'	
		 			nCxSacSai += TMPSZR->ZR_QUANT
		 	EndCase
	 		
	 	Endif
		
		cMotAtu := TMPSZR->ZR_MOTORIS
		
		TMPSZR->(dbSkip())
	EndDo

  @nLin, 000 Psay iif(Empty(cMotAtu),"XXXXXX",cMotAtu)
  @nLin, 006 Psay "|"
  @nLin, 007 Psay iif(Empty(POSICIONE("DA4",1,xFilial("DA4")+cMotAtu,"DA4_NOME")),"MOVTOS SEM CÓDIGO DE MOTORISTA",;
  								POSICIONE("DA4",1,xFilial("DA4")+cMotAtu,"DA4_NOME"))
	nLin += 1                             
	
	if nCxPlaEnt > 0 .or. nCxPlaSai > 0
		@nLin, 016 pSay EscPont("PLÁSTICA",15)
		@nLin, 037 pSay "|"
		@nLin, 039 pSay nCxPlaEnt Picture "@E 999,999"
		@nLin, 046 Psay "|"
		@nLin, 047 pSay nCxPlaSai Picture "@E 999,999"
		@nLin, 054 pSay "|"
		@nLin, 055 pSay (nCxPlaEnt - nCxPlaEnt) Picture "@E 999,999"
		@nLin, 065 pSay "|"
		@nLin, 066 pSay ((nCxPlaEnt - nCxPlaSai)* nValCxPlas) Picture "@E 999,999.99"
		@nLin, 076 pSay "|"
		nLin += 1
	EndIf
    
	if nCxMadEnt > 0 .or. nCxMadSai > 0
		@nLin, 016 pSay EscPont("MADEIRA",15)
		@nLin, 037 pSay "|"
		@nLin, 039 pSay nCxMadEnt Picture "@E 999,999"
		@nLin, 046 Psay "|"
		@nLin, 047 pSay nCxMadSai Picture "@E 999,999"
		@nLin, 054 pSay "|"
		@nLin, 055 pSay (nCxMadEnt - nCxMadSai) Picture "@E 999,999"
		@nLin, 065 pSay "|"
		@nLin, 066 pSay ((nCxMadEnt - nCxMadSai)* nValCxMad) Picture "@E 999,999.99"
		@nLin, 076 pSay "|"
		nLin += 1
	EndIf
    
	if nCxPapEnt > 0 .or. nCxPapSai > 0
		@nLin, 016 pSay EscPont("PAPELÃO",15)
		@nLin, 037 pSay "|"
		@nLin, 039 pSay nCxPapEnt Picture "@E 999,999"
		@nLin, 046 Psay "|"
		@nLin, 047 pSay nCxPapSai Picture "@E 999,999"
		@nLin, 054 pSay "|"
		@nLin, 055 pSay (nCxPapEnt - nCxPapSai) Picture "@E 999,999"
		@nLin, 065 pSay "|"
		@nLin, 066 pSay ((nCxPapEnt - nCxPapSai)* nValCxPap) Picture "@E 999,999.99"
		@nLin, 076 pSay "|"
		nLin += 1
  EndIf  
  
  if nCxPalEnt > 0 .or. nCxPalSai > 0
		@nLin, 016 pSay EscPont("PALET",15)
		@nLin, 037 pSay "|"
		@nLin, 039 pSay nCxPalEnt Picture "@E 999,999"
		@nLin, 046 Psay "|"
		@nLin, 047 pSay nCxPalSai Picture "@E 999,999"
		@nLin, 054 pSay "|"
		@nLin, 055 pSay (nCxPalEnt - nCxPalSai) Picture "@E 999,999"
		@nLin, 065 pSay "|"
		@nLin, 074 pSay "-"
		@nLin, 076 pSay "|"
		nLin += 1
  EndIf 

  if nCxBinEnt > 0 .or. nCxBinSai > 0
		@nLin, 016 pSay EscPont("BINS",15)
		@nLin, 037 pSay "|"
		@nLin, 039 pSay nCxBinEnt Picture "@E 999,999"
		@nLin, 046 Psay "|"
		@nLin, 047 pSay nCxBinSai Picture "@E 999,999"
		@nLin, 054 pSay "|"
		@nLin, 055 pSay (nCxBinEnt - nCxBinSai) Picture "@E 999,999.99"
		@nLin, 065 pSay "|"
		@nLin, 074 pSay "-"
		@nLin, 076 pSay "|"
		nLin += 1
  EndIf 
  
    if nCxSacEnt > 0 .or. nCxSacSai > 0
		@nLin, 016 pSay EscPont("SACO BATATA",15)
		@nLin, 037 pSay "|"
		@nLin, 039 pSay nCxSacEnt Picture "@E 999,999"
		@nLin, 046 Psay "|"
		@nLin, 047 pSay nCxSacSai Picture "@E 999,999"
		@nLin, 054 pSay "|"
		@nLin, 055 pSay (nCxSacEnt - nCxSacSai) Picture "@E 999,999"
		@nLin, 065 pSay "|"
		@nLin, 066 pSay ((nCxSacEnt - nCxSacSai) * nValCxSac) Picture "@E 999,999.99"
		@nLin, 076 pSay "|"
		nLin += 1
  EndIf
  /*
	@nLin, 016 pSay EscPont("TOTAL MOT",15)
  @nLin, 037 Psay "|"
  @nLin, 039 Psay nSEntr Picture "@E 999,999"
 	@nLin, 046 Psay "|"
 	@nLin, 047 Psay nSSaid Picture "@E 999,999"
 	@nLin, 054 Psay "|"
 	@nLin, 055 Psay (nSEntr * nValCx) Picture "@E 999,999.99"
 	@nlin, 065 Psay "|"
 	@nLin, 066 Psay ((nSEntr-nSSaid) * nValCx) Picture "@E 999,999.99"
 	@nLin, 076 Psay "|"  
  */
  
  nLin += 1 
  
  /*
	@nLin, 00 Psay Replicate("-",80)
	nLin += 1
	
	@nLin, 006 Psay "|"
	@nLin, 007 Psay "TOTAL GERAL"
	@nLin, 037 Psay "|"
  @nLin, 039 Psay nTEntr Picture "@E 999,999"
 	@nLin, 046 Psay "|"
 	@nLin, 047 Psay nTSaid Picture "@E 999,999"
 	@nLin, 054 Psay "|"
 	@nLin, 055 Psay (nTEntr * nValCx) Picture "@E 999,999.99"
 	@nlin, 065 Psay "|"
 	@nLin, 066 Psay ((nTEntr-nTSaid) * nValCx) Picture "@E 999,999.99"
 	@nLin, 076 Psay "|"
	*/
	
	DbSelectArea("TMPSZR")
	TMPSZR->(DbCloseArea())

Endif

SET DEVICE TO SCREEN

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função para completar a string com pontilhado.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function EscPont(cString, nTam)
Local cRet := ""

cRet := AllTrim(cString)
if Len(cString) < nTam
	for i := Len(cString) to nTam-1
		cRet += "."	
	Next i
Else
	cRet := SubStr(cString, 01, nTam-1)
EndIf

cRet += ":"

Return cRet

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função criada para gravar os parâmetros.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function AjustaSX1()
Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)

cPerg := PADR(cPerg,10)
// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DEFSP1/DFENG1/Cnt01/Var02/Def02/DEFSP1/DFENG1/Cnt02/Var03/Def03/DEFSP1/DFENG1/Cnt03/Var04/Def04/DEFSP1/DFENG1/Cnt04/Var05/Def05/DEFSP1/DFENG1/Cnt05
aAdd(aRegs,{cperg,"01","Motorista Inicial  ?","","","mv_ch1","C",06,0,0,"G",""        ,"mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","DA4",""})
aAdd(aRegs,{cperg,"02","Motorista Final    ?","","","mv_ch2","C",06,0,0,"G","naovazio","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","DA4",""})
aAdd(aRegs,{cPerg,"03","Data Inicial       ?","","","mv_ch3","D",08,0,0,"G",""        ,"mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Data Final         ?","","","mv_ch4","D",08,0,0,"G","naovazio","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Tipo Relatorio     ?","","","mv_ch5","N",01,0,1,"C","        ","mv_par05","Sintetico","Sintetico","Sintetico","","","Analitico","Analitico","Analitico","","","","","","","","","","","","","","","","","","",""})
//aAdd(aRegs,{cPerg,"06","Valor Caixas  	   ?","","","mv_ch6","N",06,2,0,"G","        ","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
    If !dbSeek(cPerg+aRegs[i,2])
        RecLock("SX1",.T.)
        For j:=1 to FCount()
            If j <= Len(aRegs[i])
                FieldPut(j,aRegs[i,j])
            Endif
        Next
        MsUnlock()
    Endif
Next
dbSelectArea(_sAlias)

Return