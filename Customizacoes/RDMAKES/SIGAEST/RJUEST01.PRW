#INCLUDE "TOPCONN.CH"
#INCLUDE "rwmake.ch"
/*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJUEST01  ºAutor  ³                    º Data ³  11/03/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gerar movimento interno com custo para agregar o mesmo     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RJUEST01()

Local oDlg
Local aCA:={OemToAnsi("Confirma"),OemToAnsi("Abandona")}
Local cCadastro := OemToAnsi("Complemento de Custos")
Local aSays:={}, aButtons:={}
Local nOpca := 0

Private aReturn  := {OemToAnsi('Zebrado'), 1,OemToAnsi('Administracao'), 2, 2, 1, '',1 }
Private nLastKey := 0
Private cPerg    := "EST001"                
Private _MV_PAR01, _MV_PAR02, _MV_PAR03 
Private	_cDbMs	 := AllTrim(UPPER(TcGetDb()))  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

SetPrvt("ACA,CCADASTRO,ASAYS,ABUTTONS,NOPCA,ARETURN")
SetPrvt("NLASTKEY,CPERG,NHEIGHT,LBOLD,LUNDERLINE,LPIXEL")

dbSelectArea("SF5")
dbSetOrder(1)
If !dbSeek(xFilial("SF5") + "180")
   MsgBox("Para esta rotina é necessario o cadastramento do TIPO MOVIMENTO 180. Entre em contato com o Administrador do Sistema.")
   Return .t.
Endif


ValidPerg()

Pergunte(cPerg,.T.)
_MV_PAR01 := MV_PAR01
_MV_PAR02 := MV_PAR02
_MV_PAR03 := MV_PAR03

AADD(aSays,OemToAnsi( "Este programa permitira lancar complemento de "))
AADD(aSays,OemToAnsi( "custos para produtos acabados.  Neste calculo "))
AADD(aSays,OemToAnsi( "leva-se em consideracao o PESO LIQUIDO."))  
AADD(aSays,OemToAnsi( "Este programa roda somente em plataforma TOP"))

AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
AADD(aButtons, { 1,.T.,{|| nOpca := 1,FechaBatch() }} )
AADD(aButtons, { 2,.T.,{|| nOpca := 0,FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )

If nOpca == 1
	Processa( { |lEnd| LancCusto() })
EndIf
	
Return .T.
	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LancCusto ºAutor  ³                    º Data ³  11/03/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Esta funcao tem o objetivo de filtrar as notas de entrada  º±±
±±º          ³ pela data de digitacao                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LancCusto()
_Filial   := xFilial("SF1")

// CARREGANDO PARAMENTROS PARA VARIAVEIS PRIVADAS

cDelFunc:= ".T." 
aRotina := {{"Gerar     ",'ExecBlock("GeraCusto")',0,1},;
            {"Parametros",'ExecBlock("Pergunta")' ,0,2}}


cCadastro := "Rateio de Custo"

#IFNDEF WINDOWS
      ScreenDraw("SMT360", 3, 0, 0, 0)
      @3,1 Say cCadastro Color "B/W"
#ENDIF

//cmarca   := getmark() 
cMarca  := GetMark(,"SF1","F1_OK")
linverte := .T.

dbSelectArea("SF1")
aIndexSF1 := {}

cChave    := "F1_FILIAL+F1_SERIE+F1_DOC" // chave de ordenacao


cFilter    := 	"F1_FILIAL = '" + _Filial + "' .AND. EMPTY(F1_SD3) .AND. DTOS(F1_DTDIGIT) = '" + DTOS(MV_PAR01) + "'"
//cFilter    := 	"F1_FILIAL = '" + _Filial + "' .AND. EMPTY(F1_SD3)"
bFiltraBrw 	:= {|| FilBrowse("SF1",@aIndexSF1,@cFilter)}
Eval(bFiltraBrw)

dbGoTop()
  
//MarkBrow("SF1","F1_OK",,,lInverte,cMarca,,,'xFilial("SF1")','xFilial("SF1")')
MarkBrow("SF1","F1_OK",,,.F.,cMarca) //browse para selecao das nfe's
Return .t.

user Function Pergunta()  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

     Pergunte(cPerg,.T. )
     _MV_PAR01 := MV_PAR01
     _MV_PAR02 := MV_PAR02
     _MV_PAR03 := MV_PAR03
Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GeraCusto ºAutor  ³                    º Data ³  11/03/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Esta funcao fara o rateio do valor a ser agregado ao custo º±±
±±º          ³ e lancara e mesmo na data de digitacao da NFE              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GeraCusto()
Local _Docs := {}    
Local _Forn := {} 
Local _Filial := xFilial("SF1")
Local _PesoTotal := 0      
Local _aCabec := {}, _aItens := {}
Local _DespTotal := 0,_Item := 0
Local aCmp    := {}         
Local aStrItens := "{"  
Local _UM,_Local,_Grupo,_DocSD3

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

For x := 1 to 999
 	     aCmd:="aItens"+Alltrim(Str(x))
         &aCmd:={}
Next x

If !MsgBox("Confirma a Geracao do custo?","ATENCAO","YESNO")
   Return .t.
Endif

// Monta um array com a serie e o numero das notas a serem feito o rateio
dbSelectArea("SF1")
Eval(bFiltraBrw)
dbSeek(xFilial("SF1"))

While !Eof() .and. xFilial("SF1") == SF1->F1_FILIAL
	IF !Marked("F1_OK",cMarca,lInverte)
		dbSelectArea("SF1")
		SF1->(dbSkip())
		Loop
	Endif
    aADD(_Docs,SF1->F1_SERIE + SF1->F1_DOC)
    aADD(_Forn,SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_TIPO)
    dbSelectArea("SF1")
    SF1->(dbSkip())
EndDo

// SQL PARA TRAZER O PESO TOTAL DAS NOTAS       
_Conta := 0           

If 	_cDbMs = "DB2"
   cQuery := "SELECT  	SUM(A.D1_QUANT * B.B1_PESO) PESOS " //db2
Else                            // MSSQL
   cQuery := "SELECT  	SUM(A.D1_QUANT * B.B1_PESO) 'PESOS' "    //sqlserver
Endif   
cQuery += " FROM " + RetSqlName("SD1")+ " A,  " + RetSqlName("SB1")+ " B "
cQuery += " WHERE 	A.D1_FILIAL = '"+_Filial+ "' AND "
If 	_cDbMs = "DB2"
   cQuery += "      	CONCAT(A.D1_SERIE,A.D1_DOC) IN ("    // DB2
Else
   cQuery += "      	A.D1_SERIE+A.D1_DOC IN ("    // SQLSERVER 
Endif   
For _Conta := 1 to Len(_Docs)
    If !Empty(_Docs[_Conta])
       cQuery += "'" + _Docs[_Conta]  + "'" 
       If _Conta < Len(_Docs)               
          cQuery += ","
       Endif                   
    Endif
Next _Conta    
cQuery +=") AND "
cQuery += "         A.D1_DTDIGIT = '" + DTOS(_MV_PAR01) + "' AND "   
cQuery += "         A.D_E_L_E_T_ <> '*' AND B.D_E_L_E_T_ <> '*' AND A.D1_COD = B.B1_COD "

TCQUERY cQuery NEW ALIAS "TMP1"
DBGOTOP()
_PesoTotal := TMP1->PESOS // resultado do peso total 
DBCLOSEAREA("TMP1")
If _PesoTotal <= 0
   MsgBox("Peso total da carga esta ZERADO.")
Endif  


// SQL QUE TRAZ OS PRODUTOS DAS NOTAS AGRUPADOS E COM OS PESOS
_Conta := 0
cQuery := "SELECT  	A.D1_FILIAL, A.D1_COD, "
If 	_cDbMs = "DB2"
   cQuery += "			SUM(A.D1_QUANT * B.B1_PESO) PESOS " //db2
Else                                                        
   cQuery += "			SUM(A.D1_QUANT * B.B1_PESO) 'PESOS' "      //sqlserver
Endif   
cQuery += " FROM " + RetSqlName("SD1")+ " A,  " + RetSqlName("SB1")+ " B "
cQuery += " WHERE 	A.D1_FILIAL = '"+_Filial+ "' AND "
If 	_cDbMs = "DB2"
   cQuery += "      	CONCAT(A.D1_SERIE,A.D1_DOC) IN ("  //db2
Else
   cQuery += "      	A.D1_SERIE+A.D1_DOC IN ("  //sql       
Endif   
For _Conta := 1 to Len(_Docs)
   If !Empty(_Docs[_Conta])
      cQuery += "'" + _Docs[_Conta]  + "'" 
      If _Conta < Len(_Docs)               
         cQuery += ","
       Endif
    Endif   
Next _Conta    
cQuery +=") AND "
cQuery += "         A.D1_DTDIGIT = '" + DTOS(_MV_PAR01) + "' AND "   
cQuery += "         A.D_E_L_E_T_ <> '*' AND B.D_E_L_E_T_ <> '*' AND A.D1_COD = B.B1_COD "
cQuery += " GROUP BY A.D1_FILIAL, A.D1_COD"

TCQUERY cQuery NEW ALIAS "TMP2"

// montagem do cabecalho do movimento interno modelo 2
_aCabec := {}
aADD(_aCabec,{"D3_TM","180"                       ,nil})
aADD(_aCabec,{"D3_EMISSAO",_MV_PAR01               ,nil})
aADD(_aCabec,{"D3_CC",_MV_PAR03                    ,NIL})
// montagem dos itens do documento do movimento interno modelo 2
_DespTotal := 0             
_Item := 0
_aItens := {}     
aCmp    := {}



//TMP2->(dbGotop())
//While !Eof("TMP2")
//    MSGBOX(TMP2->D1_COD + " - " + STR(TMP2->PESOS))
//    TMP2->(DBSKIP())
//ENDDO

_DocSD3 := "000000" 
@ 100, 100 To 200, 350 Dialog oGeraTxt TITLE OemToAnsi("Informe o código do complemento")
@  10,  10 Say "Numero do comp.:"
@  10,  60 Get _DocSD3 Picture "@!" Size 40,10 
  
@ 30, 40 BMPBUTTON TYPE 01 ACTION Close(oGeraTxt)

Activate Dialog oGeraTxt Centered
TMP2->(dbGotop())
While !TMP2->(Eof())

    If Empty(TMP2->D1_COD)
       TMP2->(dbSkip())
       Loop
    Endif
	_Perc := Round(TMP2->PESOS / _PesoTotal * 100,4)
	_Despesa := Round(_MV_PAR02 * _Perc / 100,2)
	_DespTotal := _DespTotal + _Despesa         
	_Item++       
    _aItens := {}     
    // busca dados do produto
    _UM    := "  "
    _Local := "  "
    _Grupo := "  "
    dbSelectArea("SB1")
    dbSetOrder(1)
    If dbSeek(xFilial("SB1") + TMP2->D1_COD)
       _UM    := SB1->B1_UM
       _Local := SB1->B1_LOCPAD
       _Grupo := SB1->B1_GRUPO
    Endif
    aADD(_aItens,{"D3_COD",TMP2->D1_COD      , NIL})
    aADD(_aItens,{"D3_UM",_UM                , NIL})
    aADD(_aItens,{"D3_QUANT",0               , NIL})
    aADD(_aItens,{"D3_LOCAL",_Local          , NIL})
    aADD(_aItens,{"D3_CUSTO1",_Despesa       , NIL})    
    aADD(_aItens,{"D3_GRUPO",_Grupo          , NIL})
    aADD(_aItens,{"D3_SF1","S"               , NIL})  
    aADD(_aItens,{"D3_PESOTOT",_PesoTotal    , NIL})
    aADD(_aItens,{"D3_PESOPRO",TMP2->PESOS   , NIL})
    aADD(_aItens,{"D3_DESPTOT",_MV_PAR02     , NIL})

    aCmd := "aItens"+Alltrim(Str(_Item))
    &aCmd:=_aItens
    &aCmd:=_aItens
	TMP2->(dbSkip())
EndDo   
TMP2->(DBCLOSEAREA())

  
//If _MV_PAR02 > _DespTotal  //correcao do arredondamento
//   _aItens[1,5] := _aItens[1,5] + (_MV_PAR02 - _DesTotal)
//ElseIf _MV_PAR02 < _DespTotal
//   _aItens[1,5] := _aItens[1,5] - ( _DesTotal - _MV_PAR02)
//Endif                               


For x := 1 to _Item
     If  x = _Item
         aStrItens := aStrItens+"aItens"+Alltrim(Str(x))+"}"
     Else
         aStrItens := aStrItens+"aItens"+Alltrim(Str(x))+", "
     Endif
Next

lMsErroAuto := .F.

// SIGAAUTO para rotina de movimento interno modelo2
   
MSExecAuto({|x,y,z|   MATA241(x,y,z)}, _aCabec, &aStrItens, 3)

If lMsErroAuto
  mostraerro() // se ocorrer erro no sigaauto gera mensagem de informação do erro  
  MsgBox("Complemento de Custo não foi incluído. Verifique.")
EndIF

_DocSD3 := SD3->D3_DOC // parte da customizacao original

//   @  20, 20 BmpButton Type 01 Action Close(oDlg)
//   Activate Dialog  Center
//   @ 100, 100 To 200, 350 Dialog oDlg Title "Informe o codigo do complemento"
//   @  10,  10 Say "Numero do comp.:"
//   @  10,  60 Get _DocSD3 When .f.   Size 40,10  Picture "@E 999999"   
//  
//   @  20, 20 BmpButton Type 01 Action Close(oDlg)
//   Activate Dialog oDlg Center

// Gravando numero do documento do movimento interno de custo na nota fiscal de entrada
For I := 1 to Len(_Docs)
   dbSelectArea("SF1")
   dbSetOrder(1)
   If dbSeek(xFilial("SF1") + Subst(_Docs[i],4,6) + Subst(_Docs[i],1,3) + _Forn[I])
      If SF1->F1_DTDIGIT = _MV_PAR01
         RecLock("SF1",.f.)
         SF1->F1_SD3 := _DocSD3
         SF1->(MsUnlock())
      Endif
   Endif
Next I

msginfo("Documento Interno : " + _DocSD3 + ". Custo Atualizado com Sucesso!" )

Return .t.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValidPerg  ºAutor  ³Microsiga           º Data ³  11/03/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ criar as perguntas no SX1                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ValidPerg
 
Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,len(SX1->X1_GRUPO))
	
_sAlias := Alias()
aRegs := {}
i:=0
j:=0
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,Len(SX1->X1_GRUPO))
AADD(aRegs,{cPerg,"01","Data Entrada         ?","","","mv_ch1","D", 8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Vl Total Despesas    ?","","","mv_ch2","N", 14,2,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Centro de Custo      ?","","","mv_ch3","C", 09,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
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