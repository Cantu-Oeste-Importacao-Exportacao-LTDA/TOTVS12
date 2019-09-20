#include "rwmake.ch" 
#include "colors.ch"
#include "Topconn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPCLI001 º Autor ³ Adriano Novachaelley Data ³  26/09/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Importação de Clientes.                                    º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 		                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function IMPCLI001()    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	If SM0->M0_CODIGO <> '30'
		Alert("Empresa não configurada para utilizar esta rotina.")
		Return()
	Endif 
    @ 140,100 TO 300,430 DIALOG oDlg1 TITLE "Importação de Clientes"
    @ 005,005 TO 060,160
    @ 020,010 Say "O arquivo deve estar em "+"\PNEUS\SA1500.DTC" SIZE 300,10 COLOR CLR_BLACK
    @ 030,010 Say "O arquivo deve estar em "+"\PNEUS\SA1600.DTC" SIZE 300,10 COLOR CLR_BLACK
    @ 065,100 BMPBUTTON TYPE 1 ACTION Processa( {|| ProcArq() } ) 
    @ 065,130 BMPBUTTON TYPE 2 ACTION Finaliza()                        
    ACTIVATE DIALOG oDlg1 CENTER
Return()


Static Function ProcArq()
Local _cArq500 := "\PNEUS\SA1500.DTC" // 
Local _cArq600 := "\PNEUS\SA1600.DTC" // 
Local aEstrA1 	:= {}
Local aEstr50	:= {}
Local aEstr60	:= {}
Local nSA1500 	:= fCreate("c:\logSA1500.txt") // Local para log tabela SA1500
Local nSA1600 	:= fCreate("c:\logSA1600.txt") // Local para log tabela SA1600
Local cEOL    	:= "CHR(13)+CHR(10)"

If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

SX3->(DbSetOrder(1))
SX3->(DbSeek("SA1"),.F.)
While !SX3->(Eof()) .And. SX3->X3_ARQUIVO == "SA1"
		AADD(aEstrA1,{AllTrim(SX3->X3_CAMPO),AllTrim(SX3->X3_TIPO)} )
	SX3->(DbSkip())
EndDo

cCpoSx50 := "A1_FILIAL/A1_COD/A1_LOJA/A1_NOME/A1_PESSOA/A1_NREDUZ/A1_END/A1_TIPO/A1_MUN/A1_EST/A1_NATUREZ/A1_BAIRRO"+;
"/A1_ESTADO/A1_CEP/A1_DDI/A1_DDD/A1_TEL/A1_TELEX/A1_FAX/A1_ENDCOB/A1_PAIS/A1_ENDENT/A1_ENDREC/A1_CONTATO/A1_CGC"+;
"/A1_INSCR/A1_PFISICA/A1_INSCRM/A1_VEND/A1_COMIS/A1_REGIAO/A1_CONTA/A1_BCO1/A1_BCO2/A1_BCO3/A1_BCO4/A1_BCO5"+;
"/A1_TRANSP/A1_TPFRET/A1_COND/A1_DESC/A1_PRIOR/A1_RISCO/A1_LC/A1_VENCLC/A1_CLASSE/A1_LCFIN/A1_MOEDALC/A1_MSALDO"+;
"/A1_MCOMPRA/A1_METR/A1_PRICOM/A1_ULTCOM/A1_NROCOM/A1_FORMVIS/A1_TEMVIS/A1_ULTVIS/A1_TMPVIS/A1_TMPSTD/A1_CLASVEN"+;
"/A1_MENSAGE/A1_SALDUP/A1_RECISS/A1_NROPAG/A1_SALPEDL/A1_TRANSF/A1_SUFRAMA/A1_ATR/A1_VACUM/A1_SALPED/A1_TITPROT"+;
"/A1_DTULTIT/A1_CHQDEVO/A1_DTULCHQ/A1_MATR/A1_MAIDUPL/A1_TABELA/A1_INCISS/A1_SALDUPM/A1_PAGATR/A1_CXPOSTA"+;
"/A1_ATIVIDA/A1_CARGO1/A1_CARGO2/A1_CARGO3/A1_SUPER/A1_RTEC/A1_ALIQIR/A1_OBSERV/A1_RG/A1_CALCSUF/A1_DTNASC"+;
"/A1_SALPEDB/A1_CLIFAT/A1_GRPTRIB/A1_BAIRROC/A1_CEPC/A1_MUNC/A1_ESTC/A1_BAIRROE/A1_CEPE/A1_MUNE/A1_ESTE/A1_SATIV1"+;
"/A1_SATIV2/A1_SATIV3/A1_SATIV4/A1_SATIV5/A1_SATIV6/A1_SATIV7/A1_SATIV8/A1_CODMARC/A1_CODAGE/A1_COMAGE/A1_TIPCLI"+;
"/A1_EMAIL/A1_DEST_1/A1_DEST_2/A1_CODMUN/A1_HPAGE/A1_DEST_3/A1_CONDPAG/A1_DIASPAG/A1_OBS/A1_AGREG/A1_CODHIST"+;
"/A1_RECINSS/A1_RECCOFI/A1_RECCSLL/A1_RECPIS/A1_TIPPER/A1_COD_MUN/A1_SALFIN/A1_SALFINM/A1_B2B/A1_GRPVEN/A1_CLICNV"+;
"/A1_MSBLQL/A1_INSCRUR/A1_SITUA/A1_NUMRA/A1_SUBCOD/A1_CDRDES/A1_FILDEB/A1_CODFOR/A1_ABICS/A1_CONTAAD/A1_USERLGI"+;
"/A1_USERLGA/A1_SICREDI/A1_DESVEN/A1_DFFAT/A1_VEND2/A1_VEND3/A1_VEND4/A1_DESCFIN/A1_IDENBCO/A1_ABATIMP/A1_X_SERAS"+;
"/A1_DTCADAS/A1_CAPTSOC/A1_QTDVEIC/A1_QTDVEI1/A1_TPESSOA/A1_CODLOC/A1_SIMPNAC/A1_PABCB/A1_TPISSRS/A1_CTARE/A1_RECFET"+;
"/A1_CONTRIB/A1_VINCULO/A1_DTINIV/A1_DTFIMV/A1_COD_MUC/A1_PRSTSER/A1_ALIFIXA/A1_CODPAIS/A1_COMPLEM/A1_FOMEZER"+;
"/A1_CODSEFA/A1_CBO/A1_CNAE/A1_CONTAB/A1_BLEMAIL/A1_TIPOCLI/A1_LOCCONS/A1_PERFIL/A1_HRTRANS/A1_UNIDVEN/A1_SIMPLES"+;
"/A1_CEINSS/A1_FRETISS/A1_RECIRRF/A1_TIMEKEE/A1_BANCO/A1_AGENCIA/A1_TPCONTA/A1_NUMCONT/A1_FORMPAG/A1_OBSRJU/"


cCpoSx60 := "A1_FILIAL/A1_COD/A1_LOJA/A1_NOME/A1_PESSOA/A1_NREDUZ/A1_END/A1_TIPO/A1_EST/A1_NATUREZ/A1_COD_MUN"+;
"/A1_MUN/A1_BAIRRO/A1_ESTADO/A1_CEP/A1_DDI/A1_DDD/A1_TEL/A1_TELEX/A1_FAX/A1_ENDCOB/A1_PAIS/A1_ENDENT/A1_ENDREC"+;
"/A1_CONTATO/A1_CGC/A1_INSCR/A1_PFISICA/A1_INSCRM/A1_VEND/A1_COMIS/A1_REGIAO/A1_CONTA/A1_BCO1/A1_BCO2/A1_BCO3"+;
"/A1_BCO4/A1_BCO5/A1_TRANSP/A1_TPFRET/A1_COND/A1_DESC/A1_PRIOR/A1_RISCO/A1_LC/A1_VENCLC/A1_CLASSE/A1_LCFIN/A1_MOEDALC"+;
"/A1_MSALDO/A1_MCOMPRA/A1_METR/A1_PRICOM/A1_ULTCOM/A1_NROCOM/A1_FORMVIS/A1_TEMVIS/A1_ULTVIS/A1_TMPVIS/A1_TMPSTD"+;
"/A1_CLASVEN/A1_MENSAGE/A1_SALDUP/A1_RECISS/A1_NROPAG/A1_SALPEDL/A1_TRANSF/A1_SUFRAMA/A1_ATR/A1_VACUM/A1_SALPED"+;
"/A1_TITPROT/A1_DTULTIT/A1_CHQDEVO/A1_DTULCHQ/A1_MATR/A1_MAIDUPL/A1_TABELA/A1_INCISS/A1_SALDUPM/A1_PAGATR/A1_CXPOSTA"+;
"/A1_ATIVIDA/A1_CARGO1/A1_CARGO2/A1_CARGO3/A1_SUPER/A1_RTEC/A1_ALIQIR/A1_OBSERV/A1_RG/A1_CALCSUF/A1_DTNASC/A1_SALPEDB"+;
"/A1_CLIFAT/A1_GRPTRIB/A1_BAIRROC/A1_CEPC/A1_MUNC/A1_ESTC/A1_BAIRROE/A1_CEPE/A1_MUNE/A1_ESTE/A1_SATIV1/A1_SATIV2"+;
"/A1_SATIV3/A1_SATIV4/A1_SATIV5/A1_SATIV6/A1_SATIV7/A1_SATIV8/A1_CODMARC/A1_CODAGE/A1_COMAGE/A1_TIPCLI/A1_EMAIL"+;
"/A1_DEST_1/A1_DEST_2/A1_CODMUN/A1_HPAGE/A1_DEST_3/A1_CONDPAG/A1_DIASPAG/A1_OBS/A1_AGREG/A1_CODHIST/A1_RECINSS"+;
"/A1_RECCOFI/A1_RECCSLL/A1_RECPIS/A1_TIPPER/A1_SALFIN/A1_SALFINM/A1_B2B/A1_GRPVEN/A1_CLICNV/A1_MSBLQL/A1_INSCRUR"+;
"/A1_SITUA/A1_NUMRA/A1_SUBCOD/A1_CDRDES/A1_FILDEB/A1_CODFOR/A1_ABICS/A1_CONTAAD/A1_USERLGI/A1_USERLGA/A1_SICREDI"+;
"/A1_DESVEN/A1_DFFAT/A1_VEND2/A1_VEND3/A1_VEND4/A1_DESCFIN/A1_IDENBCO/A1_ABATIMP/A1_X_SERAS/A1_DTCADAS/A1_CAPTSOC"+;
"/A1_QTDVEIC/A1_QTDVEI1/A1_TPESSOA/A1_CODLOC/A1_SIMPNAC/A1_PABCB/A1_TPISSRS/A1_CTARE/A1_RECFET/A1_CONTRIB/A1_VINCULO"+;
"/A1_DTINIV/A1_DTFIMV/A1_PRSTSER/A1_ALIFIXA/A1_CODPAIS/A1_COMPLEM/A1_FOMEZER/A1_CBO/A1_CNAE/A1_CONTAB/A1_BLEMAIL"+;
"/A1_TIPOCLI/A1_LOCCONS/A1_PERFIL/A1_HRTRANS/A1_UNIDVEN/A1_SIMPLES/A1_CEINSS/A1_FRETISS/A1_RECIRRF/A1_TIMEKEE"+;
"/A1_QTDVEI/A1_FORMPAG/A1_OBSRJU/"

// INICIO PROCESSAMENTO SA1500
_cTmp := ""
For nR := 1 To Len(cCpoSx50)
	If SubStr(cCpoSx50,nR,1) == "/"
		AADD(aEstr50,{_cTmp} )
		_cTmp := ""
	Else
		_cTmp += SubStr(cCpoSx50,nR,1)
	Endif
Next nR

MsOpEndbf(.T.,"CTREECDX",_cArq500,"TMPA1",.F.,.F.,.F.,.F.)
       
TMPA1->(DbSelectArea("TMPA1"))
TMPA1->(DbGotop())
ProcRegua(LastRec())

nCont	:= 0
While !TMPA1->(Eof())
	IncProc("Processados "+_cArq500+" ("+Str(nCont)+")")
    If TMPA1->A1_PESSOA = 'J'
   	    DbSelectArea("SA1")
	    DbSetOrder(3)
		DbGoTop()
	    If !DbSeek(xFilial("SA1")+TMPA1->A1_CGC)
	    	_nLoja := 0
	   	    DbSelectArea("SA1")
		    DbSetOrder(3)
			DbGoTop()	    	
		    If DbSeek(xFilial("SA1")+Substr(TMPA1->A1_CGC,1,8) )
	    		_cCod	:= SA1->A1_COD	    	
		    	While !SA1->(EOF()) .and. Substr(SA1->A1_CGC,1,8) == Substr(TMPA1->A1_CGC,1,8)
					If _nLoja < Val(SA1->A1_LOJA)
			           _nLoja := Val(SA1->A1_LOJA)
			  		Endif
			        SA1->(DbSkip())
		       	End                	
		    
		       _nLoja++
		    Else
		       _cCOD  := GetSXENum("SA1","A1_COD")
		       _nLoja := 1
		    EndIf
		    SA1->(RecLock("SA1",.T.))
	    		_cCampo := ""					
		    	For nR := 1 To Len(aEstr50)
		    		_cCampo := aEstr50[nR,1]
		    		If _cCampo	$ "A1_COD/A1_LOJA"
		    			SA1->A1_COD 	:= _cCOD
		    			SA1->A1_LOJA	:= StrZero(_nLoja,2)
		    		Else
						nPosicao  := ascan(aEstrA1,{|_x| _cCampo == _x[1]})
						If nPosicao > 0
				    		SA1->&_cCampo := Iif(aEstrA1[nPosicao,2]== "D",StoD(TMPA1->&_cCampo),TMPA1->&_cCampo)
						Endif
					Endif
		    	Next nR
		    SA1->(MsUnLock())
	    	cLin := "CLIENTE: "+TMPA1->A1_NOME+" COM O CNPJ: "+TMPA1->A1_CGC+" IMPORTADO COM SUCESSO."+;
	    			" NOVO CODIGO E LOJA SÃO: "+_cCOD+"/"+StrZero(_nLoja,2)
			cLin += cEOL 
			fWrite(nSA1500,cLin,Len(cLin))
		    ConfirmSX8()
	    Else
	    	cLin := "CLIENTE: "+TMPA1->A1_NOME+" COM O CNPJ: "+TMPA1->A1_CGC+;
	    	" JÁ EXISTE NO CADASTRO DE CLIENTES E NÃO FOI IMPORTADO."
			cLin += cEOL 
			fWrite(nSA1500,cLin,Len(cLin))	    	
	    Endif
    Else
   	    DbSelectArea("SA1")
	    DbSetOrder(3)
	    DbGoTop()
	    If !DbSeek(xFilial("SA1")+TMPA1->A1_CGC)
	       _cCOD  := GetSXENum("SA1","A1_COD")
	       _nLoja := 1
		    SA1->(RecLock("SA1",.T.))
	    		_cCampo := ""					
		    	For nR := 1 To Len(aEstr50)
		    		_cCampo := aEstr50[nR,1]
		    		If _cCampo	$ "A1_COD/A1_LOJA"
		    			SA1->A1_COD 	:= _cCOD
		    			SA1->A1_LOJA	:= StrZero(_nLoja,2)
		    		Else
						nPosicao  := ascan(aEstrA1,{|_x| _cCampo == _x[1]})
						If nPosicao > 0 
				    		SA1->&_cCampo := Iif(aEstrA1[nPosicao,2]== "D",StoD(TMPA1->&_cCampo),TMPA1->&_cCampo)
						Endif
					Endif
		    	Next nR
		    SA1->(MsUnLock())
	    	cLin := "CLIENTE: "+TMPA1->A1_NOME+" COM O  CPF: "+TMPA1->A1_CGC+" IMPORTADO COM SUCESSO."+;
	    			" NOVO CODIGO E LOJA SÃO: "+_cCOD+"/"+StrZero(_nLoja,2)
			cLin += cEOL 
			fWrite(nSA1500,cLin,Len(cLin))		    
		    ConfirmSX8()			
	    Else    
	    	cLin := "CLIENTE: "+TMPA1->A1_NOME+" COM O CPF:  "+TMPA1->A1_CGC+;
	    	" JÁ EXISTE NO CADASTRO DE CLIENTES E NÃO FOI IMPORTADO."
			cLin += cEOL 
			fWrite(nSA1500,cLin,Len(cLin))	    	

		Endif
    Endif
    nCont += 1
    TMPA1->(DbSelectArea("TMPA1"))
	TMPA1->(DbSkip())
End

TMPA1->(DbSelectArea("TMPA1"))
TMPA1->(DbCloseArea())


// INICIO PROCESSAMENTO SA1600
_cTmp := ""
For nR := 1 To Len(cCpoSx60)
	If SubStr(cCpoSx60,nR,1) == "/"
		AADD(aEstr60,{_cTmp} )
		_cTmp := ""
	Else
		_cTmp += SubStr(cCpoSx60,nR,1)
	Endif
Next nR

MsOpEndbf(.T.,"CTREECDX",_cArq600,"TMPA1",.F.,.F.,.F.,.F.)
       
TMPA1->(DbSelectArea("TMPA1"))
TMPA1->(DbGotop())
ProcRegua(LastRec())

nCont	:= 0
While !TMPA1->(Eof())
	IncProc("Processados "+_cArq600+" ("+Str(nCont)+")")
    If TMPA1->A1_PESSOA = 'J'
   	    DbSelectArea("SA1")
	    DbSetOrder(3)
		DbGoTop()
	    If !DbSeek(xFilial("SA1")+TMPA1->A1_CGC)
	    	_nLoja := 0
	   	    DbSelectArea("SA1")
		    DbSetOrder(3)
			DbGoTop()	    	
		    If DbSeek(xFilial("SA1")+Substr(TMPA1->A1_CGC,1,8) )
				_cCod	:= SA1->A1_COD		    
		    	While !SA1->(EOF()) .and. Substr(SA1->A1_CGC,1,8) == Substr(TMPA1->A1_CGC,1,8)
					If _nLoja < Val(SA1->A1_LOJA)
			           _nLoja := Val(SA1->A1_LOJA)
			  		Endif
			        SA1->(DbSkip())
		       	End          
		       _nLoja++
		    Else
		       _cCOD  := GetSXENum("SA1","A1_COD")
		       _nLoja := 1
		    EndIf
		    SA1->(RecLock("SA1",.T.))
	    		_cCampo := ""					
		    	For nR := 1 To Len(aEstr60)
		    		_cCampo := aEstr60[nR,1]
		    		If _cCampo	$ "A1_COD/A1_LOJA"
		    			SA1->A1_COD 	:= _cCOD
		    			SA1->A1_LOJA	:= StrZero(_nLoja,2)
		    		Else
						nPosicao  := ascan(aEstrA1,{|_x| _cCampo == _x[1]})
						If nPosicao > 0 
				    		SA1->&_cCampo := Iif(aEstrA1[nPosicao,2]== "D",TMPA1->&_cCampo,TMPA1->&_cCampo)
						Endif
					Endif
		    	Next nR
		    SA1->(MsUnLock())
	    	cLin := "CLIENTE: "+TMPA1->A1_NOME+" COM O CNPJ: "+TMPA1->A1_CGC+" IMPORTADO COM SUCESSO."+;
	    			" NOVO CODIGO E LOJA SÃO: "+_cCOD+"/"+StrZero(_nLoja,2)
			cLin += cEOL 
			fWrite(nSA1600,cLin,Len(cLin))
		    ConfirmSX8()
	    Else
	    	cLin := "CLIENTE: "+TMPA1->A1_NOME+" COM O CNPJ: "+TMPA1->A1_CGC+;
	    	" JÁ EXISTE NO CADASTRO DE CLIENTES E NÃO FOI IMPORTADO."
			cLin += cEOL 
			fWrite(nSA1600,cLin,Len(cLin))	    	
	    Endif
    Else
   	    DbSelectArea("SA1")
	    DbSetOrder(3)
	    DbGoTop()
	    If !DbSeek(xFilial("SA1")+TMPA1->A1_CGC)
	       _cCOD  := GetSXENum("SA1","A1_COD")
	       _nLoja := 1
		    SA1->(RecLock("SA1",.T.))
	    		_cCampo := ""					
		    	For nR := 1 To Len(aEstr60)
		    		_cCampo := aEstr60[nR,1]
		    		If _cCampo	$ "A1_COD/A1_LOJA"
		    			SA1->A1_COD 	:= _cCOD
		    			SA1->A1_LOJA	:= StrZero(_nLoja,2)
		    		Else
						nPosicao  := ascan(aEstrA1,{|_x| _cCampo == _x[1]})
						If nPosicao > 0 
				    		SA1->&_cCampo := Iif(aEstrA1[nPosicao,2]== "D",TMPA1->&_cCampo,TMPA1->&_cCampo)
						Endif
					Endif
		    	Next nR
		    SA1->(MsUnLock())
	    	cLin := "CLIENTE: "+TMPA1->A1_NOME+" COM O  CPF: "+TMPA1->A1_CGC+" IMPORTADO COM SUCESSO."+;
	    			" NOVO CODIGO E LOJA SÃO: "+_cCOD+"/"+StrZero(_nLoja,2)
			cLin += cEOL 
			fWrite(nSA1600,cLin,Len(cLin))		    
		    ConfirmSX8()			
	    Else    
	    	cLin := "CLIENTE: "+TMPA1->A1_NOME+" COM O CPF:  "+TMPA1->A1_CGC+;
	    	" JÁ EXISTE NO CADASTRO DE CLIENTES E NÃO FOI IMPORTADO."
			cLin += cEOL 
			fWrite(nSA1600,cLin,Len(cLin))	    	

		Endif
    Endif
    nCont += 1
    TMPA1->(DbSelectArea("TMPA1"))
	TMPA1->(DbSkip())
End
FT_FUSE() 
fClose(nSA1600) 
fClose(nSA1500)
TMPA1->(DbSelectArea("TMPA1"))
TMPA1->(DbCloseArea())  

Close(oDlg1)
Return(.T.)
   
// Caso cancelamento.
Static Function Finaliza()
   Close(oDlg1)
Return