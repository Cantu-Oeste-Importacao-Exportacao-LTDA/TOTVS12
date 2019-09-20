
#include "rwmake.ch"

/*/
+-----------------------------------------------------------------------+
|Programa  | CAIMP01  | Autor | Geraldo Franciscon® | Data |  05/02/02  |
+-----------------------------------------------------------------------+
|Descricao | IMPORTACAO DE CONTAS A RECEBER, CONTAS A PAGAR, NOTAS      |
|          | FISCAIS DE ENTRADA, E DE SAIDA                             |
+-----------------------------------------------------------------------+
|Uso       | CANTU VERDURAS                                             |
+-----------------------------------------------------------------------+
|                            Alteracoes                                 |
+-----------------------------------------------------------------------+
|  /  /    |                                                            |
+-----------------------------------------------------------------------+
/*/

User Function IMPFIN

Private cPerg   := "CIMP01"
Private oGera
Private cString := "SE2"
Private lCheck1 := .F.
Private lCheck2 := .F.

ValidPerg()
dbSelectArea("SE2")
dbSetOrder(1)                    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

@ 200,1 TO 410,510 DIALOG oGera TITLE OemToAnsi("Importacao de Arquivo")
@ 10,015 Say " Este programa ira importar os TITULOS A REC/PAGAR mudando o clie e forn p/ codificacao nova"
@ 18,015 Say " Atencao, no cadastro do AP7 o novo campo do cod deve estar preenchido. Para rodar o prog "
@ 26,015 Say " exporte do Ap7 as SE1/SE2/SA1/SA2 para \SIGAADV\IMPORTA\. Exp o SE1/SE2 em aberto. Caso "
@ 34,015 Say " o titulo importado tenha algum problema, o mesmo sera apontado no campo ??_OP. Consulte-o"


@ 50,020 CHECKBOX "Contas a Pagar"   VAR lCheck1
@ 58,020 CHECKBOX "Contas a Receber" VAR lCheck2
@ 42,015 TO 74,100 TITLE "Escolha Arquivos"
@ 02,08 TO 100,255

@ 78,100 BMPBUTTON TYPE 01 ACTION OkGera()
@ 78,130 BMPBUTTON TYPE 02 ACTION Close(oGera)
@ 78,160 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oGera Centered Valid lCheck1 .Or. lCheck2

Return



Static Function OkGera
If !(lCheck1 .Or. lCheck2)
	Return
EndIf


//Processa({|| RunImpor() })
RunImpor()
MsgAlert("Importação Concluida!","Concluido")


Return .T.



Static Function RunImpor()

Pergunte(cPerg,.F.)

If lCheck1
	///////////////////////////////////////////////////////////////////////////////////
	//// SE2
	///////////////////////////////////////////////////////////////////////////////////
	cArq  := "\IMPORTA\FRJU\SE2" + MV_PAR03 + "0.DBF"
	cArq2 := "\IMPORTA\FRJU\SA2" + MV_PAR03 + "0.DBF"
	
	If !File(cArq)
	   MsgBox("Arquivo " + cArq + " nao existe ou esta corrompido.")
	//   Return .t.
	Endif

    // TEMPORARIO PARA SA2 
    dbSelectArea("SA2")
	aStru2  := dbStruct()
	aNotasEnt:= {}
	cNomeInd2 := CriaTrab(NIL,.f.)
	dbUseArea(.t.,,cArq2,"TRB2",.t.,.f.)
	cCondicao2 := " "
	cChave2    :="A2_FILIAL+A2_COD+A2_LOJA"
	IndRegua("TRB2",cNomeInd2,cChave2,,cCondicao2,"Selecionando Registros ....")
    
    
    
    // TEMPORARIO PARA SE2	
	dbSelectArea("SE2")
	aStruE2  := dbStruct()
	aNotasEnt:= {}
	cNomeInd := CriaTrab(NIL,.f.)
	dbUseArea(.t.,,cArq,"TRB",.t.,.f.)
	cCondicao := "DtoS(E2_EMISSAO) >= '" + DtoS(mv_par01) + "'"
	cCondicao := cCondicao + " .And. DtoS(E2_EMISSAO) <= '" + DtoS(mv_par02) + "'"
	cChave    :="E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA"
	IndRegua("TRB",cNomeInd,cChave,,cCondicao,"Selecionando Registros ....")
	
	dbselectarea("TRB")
	aStruTRB:= dbStruct()
	ProcRegua(RecCount()) // Numero de registros a processar
	dbgotop()
	
	While !eof()
		IncProc("Importando Dados - SE2")
		dbSelectarea("TRB")
		If deleted()
			dbSelectarea("TRB")
			dbSkip()
			Loop
		EndIf


//		If !AllTrim(TRB->E2_PREFIXO) $ "XXX/YYY/YFT/***/*/*FT/*CH/*IM/YTF"
//			dbSelectarea("TRB")
//			dbSkip()
//			Loop
//		EndIf

		For I:= 1 to TRB->(FCount())
			M->&(FieldName(I)) := TRB->(FieldGet(I))
		Next                       
	
		aADD(aNotasEnt,{TRB->E2_NUM,TRB->E2_PREFIXO})
	
		dbselectarea("SE2")
		dbsetorder(1) //E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
		If !dbSeek(xFilial("SE2")+TRB->E2_PREFIXO+TRB->E2_NUM+TRB->E2_PARCELA+TRB->E2_TIPO+TRB->E2_FORNECE+TRB->E2_LOJA)
			RecLock("SE2",.T.)
			For I:= 1 to TRB->(FCount())
				npElemE2 := aScan(aStruE2,{|x| x[1] == M->(FieldName(I)) })
				npElemTR := aScan(aStruTRB,{|x| x[1] == M->(FieldName(I)) })
				If npElemE2 <> 0 .AND. npElemTR <> 0
					SE2->(FieldPut(I,M->&(FieldName(I))))
				EndIf
			Next
			SE2->(MsUnlock())
		    _Fornec := SE2->E2_FORNECE
		    _LojaF  := SE2->E2_LOJA  
		    _Grava  := .f.
		    dbSelectArea("TRB2")
		    dbSetOrder(1)
		    If dbSeek(xFilial("TRB2") + _Fornec + _LojaF)
		       _NFornec := TRB2->A2_CODNOVO
		       _NLojaF  := TRB2->A2_LOJANOV  
		       _Grava  := .t.
		    Endif
		    If _Grava
		       If Empty(_NFornec)   
		          RecLock("SE2",.F.)
		          SE2->E2_OP := "cod novo vazio"
		          SE2->(Msunlock())
		       Else
		          RecLock("SE2",.F.)
		          SE2->E2_FORNECE := _NFornec
		          SE2->E2_LOJA    := _NLojaF
		          SE2->(Msunlock())
		       Endif   
		    Else 
		          RecLock("SE2",.F.)
		          SE2->E2_OP := "for nao cadas"
		          SE2->(Msunlock())
		    Endif   

		EndIf
		dbselectarea("TRB")
		dbskip()
	End
	
	dbSelectArea("TRB")
	dbCloseArea()
	
EndIf
If lCheck2
	///////////////////////////////////////////////////////////////////////////////////
	//// SE1
	///////////////////////////////////////////////////////////////////////////////////
	
	cArq  := "\IMPORTA\FRJU\SE1LIQ.DBF" // + MV_PAR03 + "0.DBF"
	cArq1 := "\IMPORTA\FRJU\SA1" + MV_PAR03 + "0.DBF"
		
	If !File(cArq)
	   MsgBox("Arquivo " + cArq + " nao existe ou esta corrompido.")
	   Return .t.
	Endif

    // TEMPORARIO PARA SA1 
    dbSelectArea("SA1")
	aStru1  := dbStruct()
	aNotasEnt:= {}
	cNomeInd1 := CriaTrab(NIL,.f.)
	dbUseArea(.t.,,cArq1,"TRB1",.t.,.f.)
	cCondicao1 := " "
	cChave1    :="A1_FILIAL+A1_COD+A1_LOJA"
	IndRegua("TRB1",cNomeInd1,cChave1,,cCondicao1,"Selecionando Registros ....")
    
    
    
    // TEMPORARIO PARA SE1	
	dbSelectArea("SE1")
	aStruE1  := dbStruct()
	aNotasSai:= {}
	cNomeInd := CriaTrab(NIL,.f.)
	dbUseArea(.t.,,cArq,"TRB",.t.,.f.)
	cCondicao := "DtoS(E1_EMISSAO) >= '" + DtoS(mv_par01) + "'"
	cCondicao := cCondicao + " .And. DtoS(E1_EMISSAO) <= '" + DtoS(mv_par02) + "'"
	cChave    := "E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
	IndRegua("TRB",cNomeInd,cChave,,cCondicao,"Selecionando Registros ....")
		
	dbselectarea("TRB")
	aStruTRB:= dbStruct()
	ProcRegua(RecCount()) // Numero de registros a processar
	dbgotop()
		
	While !eof()
		IncProc("Importando Dados - SE1")
		If deleted()
			dbSelectarea("TRB")
			dbSkip()
			Loop
		EndIf
        /*
		If !AllTrim(TRB->E1_PREFIXO) $ "XXX/YYY/YFT/***/*/*FT/*CH/*IM/YTF" ;
		.and. !AllTrim(TRB->E1_PREFIXO) == "001" ;
		.and. !AllTrim(TRB->E1_PREFIXO) == "008" ;
		.and. !AllTrim(TRB->E1_PREFIXO) == "027" ;
		.and. !AllTrim(TRB->E1_PREFIXO) == "033" ;		
		.and. !AllTrim(TRB->E1_PREFIXO) == "041" ;
		.and. !AllTrim(TRB->E1_PREFIXO) == "104" ;		
		.and. !AllTrim(TRB->E1_PREFIXO) == "151" ;		
		.and. !AllTrim(TRB->E1_PREFIXO) == "237" ;		
		.and. !AllTrim(TRB->E1_PREFIXO) == "341" ;
		.and. !AllTrim(TRB->E1_PREFIXO) == "353" ;
		.and. !AllTrim(TRB->E1_PREFIXO) == "356" ;
		.and. !AllTrim(TRB->E1_PREFIXO) == "369" ;								
		.and. !AllTrim(TRB->E1_PREFIXO) == "389" ;
		.and. !AllTrim(TRB->E1_PREFIXO) == "399" ;
		.and. !AllTrim(TRB->E1_PREFIXO) == "409" ;
		.and. !AllTrim(TRB->E1_PREFIXO) == "748" ;
		.and. !AllTrim(TRB->E1_PREFIXO) == "756" 		 
			dbSelectarea("TRB")
			dbSkip()
			Loop
		EndIf
        */
			
		dbSelectarea("TRB")
		For I:= 1 to TRB->(FCount())
			M->&(FieldName(I)) := TRB->(FieldGet(I))
		Next                       
		aADD(aNotasSai,{TRB->E1_NUM,TRB->E1_PREFIXO})
		dbselectarea("SE1")
		dbsetorder(8) //E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_STATUS+DTOS(E1_VENCREA) 
		If !dbSeek(TRB->E1_FILIAL+TRB->E1_PREFIXO+TRB->E1_NUM+TRB->E1_PARCELA+TRB->E1_TIPO)    //+cSerie+cNumNota+cParcela+"DEV")
			RecLock("SE1",.T.)
			For I:= 1 to TRB->(FCount())
				npElemE1 := aScan(aStruE1,{|x| x[1] == M->(FieldName(I)) })
				npElemTR := aScan(aStruTRB,{|x| x[1] == M->(FieldName(I)) })
				If npElemE1 <> 0 .AND. npElemTR <> 0
						SE1->(FieldPut(I,M->&(FieldName(I))))
				EndIf
			Next
			SE1->(MsUnlock())
		    _CLIENTE := SE1->E1_CLIENTE
		    _LojaC   := SE1->E1_LOJA  
		    _Grava  := .f.
		    dbSelectArea("TRB1")
		    dbSetOrder(1)
		    If dbSeek(xFilial("TRB1") + _CLIENTE + _LojaC)
		       _NCLIENTE := TRB1->A1_CODNOVO		    
		       _NLojaC   := TRB1->A1_LOJANOV  
		       _Grava  := .t.
		    Endif
		    If _Grava
		       If Empty(_NCLIENTE)   
		          RecLock("SE1",.F.)
		          SE1->E1_OP := "cod novo vazio"
		          SE1->(Msunlock())
		       Else
		          RecLock("SE1",.F.)
		          SE1->E1_CLIENTE := _NCLIENTE
		          SE1->E1_LOJA    := _NLojaC
		          SE1->(Msunlock())
		       Endif   
		    Else 
		          RecLock("SE1",.F.)
		          SE1->E1_OP := "cli nao cadas"
		          SE1->(Msunlock())
		    Endif   
		Else
			MsgBox(TRB->E1_NUM+"/"+TRB->E1_PREFIXO)	
		EndIf
		
		dbselectarea("TRB")
		dbskip()
	EndDo
		
	dbSelectArea("TRB")
	dbCloseArea()
	
	
EndIf
Return



Static Function ValidPerg()
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg, Len(SX1->X1_GRUPO))
aRegs:={}
//Grupo/Ordem/Pergunta/PerSPA/PerENG/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefSPA1/DefENG1/Cnt01/Var02/Def02/DefSPA2/DefENG2/Cnt02/Var03/Def03/DefSPA3/DefENG3/Cnt03/Var04/Def04/DefSPA4/DefENG4/Cnt04/Var05/Def05/DefSPA5/DefENG5/Cnt05/F3/GRPSXG
aAdd(aRegs,{cPerg,"01","Data Inicial   ","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Data Final     ","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Empresa Origem ","","","mv_ch3","C",02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
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