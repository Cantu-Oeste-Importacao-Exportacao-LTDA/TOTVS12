#include "protheus.ch"
#include "TOTVS.CH"                             
#include "TOPCONN.CH"
#Define ENTER CHR(13)+CHR(10)

User Function IMPTRANS()
Local   lGet		:= .F.
Local   cMask   	:= 'Arquivos CSV (*.csv) |*.csv|'
Local 	lRet		:= .T.
Local 	nOpcao 		:= 0
Private odlgt                   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

DEFINE MsDIALOG odlgt TITLE "Importação de Locais x Transportadora" FROM 180,180 TO 400,600 PIXEL

@ 010, 01 SAY 'Arquivo' Of odlgt PIXEL
cTGet1 := ""
oTGet1 := TGet():New( 10,50,{||cTget1 },odlgt,096,009,"",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cTGet1,,,, )

Define SButton From 95, 160 Type  1 Action (nOpcao:=1,odlgt:End(),ProcRot(nOpcao)) Enable Of odlgt Pixel // Apaga
Define SButton From 010, 160 Type 14 Action (cTGet1:=cGetFile( cMask ,'', 1,'V:\',.F.,(GETF_LOCALHARD),.F., .F. )) Enable Of odlgt Pixel

ACTIVATE MsDIALOG odlgt CENTER

Return

Static Function ImpPlan(cTget1)

Local cQry		:= ""
Local _aDados   := ""
Local _nLin     := 0 
Local _cArqAdm 		:= cTget1

If LastKey() == 27 //.or. nLastKey == 27
	Return()
Endif

If Empty(cTget1)
	ApMsgStop(OemtoAnsi("Por favor Especificar Local do Arquivo!"))
	Return()
EndIf

If !File(_cArqAdm)
	ApMsgInfo("Arquivo não encontrado","Importacao")
	Return
Endif

FT_FUSE(_cArqAdm)
nLinhas := FT_FLastRec()

ProcRegua(nLinhas)

FT_FGOTOP()  

Begin Transaction

If nLinhas > 0
	cQry := "DELETE FROM " + RetSqlName("ZX3") 
	
	TCSQLEXEC(cQry)

	TcSqlExec( "COMMIT" )	
Endif

While !FT_FEOF()
	
	IncProc("Lendo Arquivo, Linha :  "+STR( _nLin++) +" de "+ STR(nLinhas))
	
	_aDados := StrTokArr(FT_FREADLN(),";",.T.)

	If Len(_aDados) > 0 .and. UPPER(_aDados[1]) <> 'LOCAL' //Nao processa o cabecalho
		RecLock("ZX3",.T.)   	
		ZX3->ZX3_LOCAL 	:= ALLTRIM(_aDados[1])
		ZX3->ZX3_UF		:= ALLTRIM(_aDados[2])	 
		//Municipio	
		If ALLTRIM(_aDados[3]) == "TODOS"
			ZX3->ZX3_MUNICI := "TODOS"
			ZX3->ZX3_DMUN   := "TODOS"
		ELSE
			dbSelectArea("CC2")
	   		dbSetOrder(3)
	  		//If dbSeek(xFilial("CC2")+UPPER(NOACENTO(ALLTRIM(_aDados[3]))))
	  		If dbSeek(xFilial("CC2")+ALLTRIM(_aDados[3]))
		   		ZX3->ZX3_MUNICI := ALLTRIM(CC2->CC2_CODMUN) 
				ZX3->ZX3_DMUN   := ALLTRIM(CC2_MUN)
			Else                    
				ApMsgInfo("Municipio não encontrado." + CRLF + Alltrim(_aDados[3]) + CRLF + "Corrija o cadastro e importe novamente.","Importacao")
				DisarmTransaction()						
				Return				
	  		Endif		
		ENDIF           
		//transportadora               
		_aDados[6] := StrTran(_aDados[6],".","")
		_aDados[6] := StrTran(_aDados[6],"/","")
		_aDados[6] := StrTran(_aDados[6],"-","")

		dbSelectArea("SA4")
   		dbSetOrder(3)
  		If dbSeek(xFilial("SA4")+ALLTRIM(_aDados[6]))
			ZX3->ZX3_TRANSP	:= SA4->A4_COD 
			ZX3->ZX3_DESCRI	:= SA4->A4_NREDUZ 			
		Else                                   
			ApMsgInfo("Transportadora não encontrada." + CRLF + Alltrim(_aDados[5]) + "Linha: " + Str(_nLin) + CRLF + ;
						"Corrija o cadastro e importe novamente.","Importacao")  
			
			DisarmTransaction()						
			Return		
		EndIf                             
		MsUnlock()
	EndIf
	
	_aDados:={}      
	
	FT_FSKIP()
EndDo

FT_FUSE()

End Transaction    

ApMsgInfo("Importação Finalizada","OK")
		
Return

Static Function ProcRot(nOpcao)

If nOpcao == 1
	Processa({|| ImpPlan(ctGet1)},"Importando Arquivo", OemToAnsi("Processando registros... Aguarde!!!"))
EndIf

Return