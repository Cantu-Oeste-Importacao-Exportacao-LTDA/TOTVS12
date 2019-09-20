#INCLUDE "rwmake.ch"
#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONTROLEXP    º Autor ³ Mailson        º Data ³  17/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Controle de expedição de NFS                               º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CONTROLEXP()
//---------------------
Local _oDlg     := Nil
Local cTitulo  := "Controle de Expedição"
Local cVar     := Nil
Local oOk      := LoadBitmap( GetResources(), "LBOK" )
Local oNo      := LoadBitmap( GetResources(), "LBNO" )
Local oChk     := Nil
Local lChk    := .F.
Local lMark   := .F.

Private oLbx := Nil   
Private aCabec := {}
Private aVetor := {}
Private cCliAnt := ""
Private aCabProd := {}
Private aQtdProd := {}
Private cPedidos:= ""
Private _cArq := ""
Private _cDir := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

PutSx1("CTRLEXP", '01','Data de'    		 , 'Data de'	   			, 'Data de' 		  		, 'mv_cha', 'D'	, 08, 0, , 'G','',''   ,'','', 'mv_par1', '', '', '',Dtos(dDataBase), '', '', '','','','','','','','','','', {}, {}, {})
PutSx1("CTRLEXP", '02','Data ate'   		 , 'Data ate'   			, 'Data ate'				, 'mv_chb', 'D'	, 08, 0, , 'G','',''   ,'','', 'mv_par2', '', '', '',DtoS(dDataBase), '', '', '','','','','','','','','','', {}, {}, {})
PutSx1("CTRLEXP", '03','Filtra ja Expedidos?', 'Filtra ja Expedidos?' 	, 'Filtra ja Expedidos?'	, 'mv_chc', 'C' , 01, 0, , 'C','',''   ,'','', 'mv_par3', 'Sim', 'Sim', 'Sim','1', 'Nao', 'Nao', 'Nao','','','','','','','','','', {}, {}, {})
PutSx1("CTRLEXP", '04','Trazer marcado?'	 , 'Trazer marcado?'		, 'Trazer marcado?', 'mv_chd', 'C' , 01, 0, , 'C','',''   ,'','', 'mv_par4', 'Sim', 'Sim', 'Sim','1', 'Nao', 'Nao', 'Nao','','','','','','','','','', {}, {}, {})

If !Pergunte("CTRLEXP",.T.)
	return
endif

lChk    := (MV_PAR04 == 1)
lMark   := lChk

dbSelectArea("SF2")
SF2->(dbSetOrder(1))

SET FILTER TO SF2->F2_EMISSAO >= MV_PAR01 .AND. SF2->F2_EMISSAO <= MV_PAR02 //.AND. SF2->SF2_STATUS <> '1' 

SF2->(dbSeek(xFilial("SF2")))

While SF2->(!EOF()) 

	dbSelectArea("SA1")
	SA1->(dbSetOrder(1))
	SA1->(dbGoTop())
	SA1->(dbSeek(xFilial("SA1")+SF2->F2_CLIENT+SF2->F2_LOJA))	
	
	dbSelectArea("SA4")
	SA4->(dbSetOrder(1))
	SA4->(dbGoTop())	
	SA4->(dbSeek(xFilial("SA4")+SF2->F2_TRANSP))	

	aAdd( aVetor, { lMark, SF2->F2_DOC, SF2->F2_SERIE, SF2->F2_CLIENT, SF2->F2_LOJA, ALLTRIM(SA1->A1_NREDUZ), SF2->F2_EST, SF2->F2_TRANSP, ALLTRIM(SA4->A4_NREDUZ), SF2->F2_XDTREXP, SF2->F2_XHREXP, SF2->(Recno())})
	
	dbSelectArea("SF2")
	SF2->(dbSkip())	
End

dbSelectArea("SF2")
SET FILTER TO
SF2->(dbSeek(xFilial("SF2")))

If Len( aVetor ) == 0
	Aviso( cTitulo, "Não existem notas que atendam os filtros.", {"Ok"} )
	Return
Endif

DEFINE MSDIALOG _oDlg TITLE cTitulo FROM 0,0 TO 440,1020 PIXEL

//@ 10,10 LISTBOX oLbx VAR cVar FIELDS HEADER ;
aCabec := {space(02),"Documento", "Serie", "Cliente", "Loja", "Nome Cliente", "Estado", "Transp.", "Nome Transp.", "Data Exp.", "Hora Exp."}
//SIZE 490,195 OF _oDlg PIXEL ON dblClick(; 
//     Iif(oLbx:ColPos==8 .or. oLbx:ColPos==10 .or. oLbx:ColPos==11,lEditCell( aVetor, oLbx, "@!", oLbx:ColPos ),aVetor[oLbx:nAt,1] := !aVetor[oLbx:nAt,1]	),;
//     oLbx:Refresh() ) 

oLbx := TWBrowse():New(0,0,490,195,, aCabec,,_oDlg,,,,,,,,,,,,.F. )
oLbx:SetArray( aVetor )
oLbx:bLine := {|| {Iif(aVetor[oLbx:nAt,1],oOk,oNo),;
				aVetor[oLbx:nAt,2],;
				aVetor[oLbx:nAt,3],;
				aVetor[oLbx:nAt,4],;
				aVetor[oLbx:nAt,5],;
				aVetor[oLbx:nAt,6],;
				aVetor[oLbx:nAt,7],;
				aVetor[oLbx:nAt,8],;
				aVetor[oLbx:nAt,9],;
				aVetor[oLbx:nAt,10],;
				Transform(aVetor[oLbx:nAt,11],"@R 99:99:99")}} 
				
//oLbx:bLDblClick := {|| Iif(oLbx:ColPos==8 .or. oLbx:ColPos==10 .or. oLbx:ColPos==11,lEditCell( aVetor, oLbx, "@!", oLbx:ColPos )) }  
oLbx:bLDblClick     := {|| Edita() }

@ 210,10 CHECKBOX oChk VAR lChk PROMPT "Marca/Desmarca" SIZE 60,007 PIXEL OF _oDlg;
ON CLICK(Iif(lChk,Marca(lChk),Marca(lChk)),oLbx:Refresh())

//@ 207,210 BUTTON "Visualizar" 	SIZE 40, 11 PIXEL OF _oDlg ACTION	(Processa({||CTRLEXPV(Alltrim(aVetor[oLbx:nAT,8]))})) //visualiza
//@ 207,260 BUTTON "Importar" 	SIZE 40, 11 PIXEL OF _oDlg ACTION	(Processa({||CTRLEXPI()}),oLbx:Refresh()) //importa
@ 207,310 BUTTON "Salvar" 		SIZE 40, 11 PIXEL OF _oDlg ACTION	(Processa({||CTRLEXPC()}),_oDlg:End()) 
@ 207,360 BUTTON "Sair"  		SIZE 40, 11 PIXEL OF _oDlg ACTION	_oDlg:End()	//SAIR

ACTIVATE MSDIALOG _oDlg CENTER

Return .T.
//---------------------
Static Function edita()
//---------------------       

If oLbx:ColPos==8 .or. oLbx:ColPos==10 .or. oLbx:ColPos==11
	lEditCell( aVetor, oLbx, "", oLbx:ColPos )
EndIf
	     
aVetor[oLbx:nAt][1] := !aVetor[oLbx:nAt][1] 

Return .T.
//---------------------
Static Function CTRLEXPC()
//---------------------
For i := 1 To Len(aVetor)
	If aVetor[i,1]   
		dbSelectArea("SF2")
		dbGoTo(aVetor[i,12])
		
		RecLock("SF2",.F.)
		SF2->F2_TRANSP := aVetor[i,8]
		SF2->F2_XDTREXP:= aVetor[i,10]		
		SF2->F2_XHREXP:= aVetor[i,11]
		MsUnlock()	
	Endif
Next 

Aviso( cTitulo, "Atualizações finalizadas.", {"Ok"} )
	
RETURN

//---------------------
Static Function Marca(lMarca)
//---------------------
Local i := 0
For i := 1 To Len(aVetor)
	aVetor[i][1] := lMarca
Next i
Return