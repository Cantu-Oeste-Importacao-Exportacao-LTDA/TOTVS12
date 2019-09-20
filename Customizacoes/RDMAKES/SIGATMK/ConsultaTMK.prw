#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TopConn.ch"
/*
+-------------------------------------------------------------------------------------------------------+
!                             FICHA TÉCNICA DO PROGRAMA                                                 !
+-------------------------------------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                                                   !
+------------------+------------------------------------------------------------------------------------+
!Tipo              ! Consulta especifica                                                                !
+------------------+------------------------------------------------------------------------------------+
!Módulo            ! Call Center                                                                        !
+------------------+------------------------------------------------------------------------------------+
!Nome              ! ConsTMK                                                                    				!
+------------------+------------------------------------------------------------------------------------+
!Descrição         ! Consulta de numeros de contato/entidade para discagem com senha de operador.       !
!                  ! 			                                                                              !
+------------------+------------------------------------------------------------------------------------+
!Autor             ! Carlos Eduardo                                                                     !
+------------------+------------------------------------------------------------------------------------+
!Data de Criação   ! 17/05/12                                                                           !
+------------------+------------------------------------------------------------------------------------+
!   ATUALIZACÕES                                                                                        !
+-------------------------------------------------------------------------------------------------------+
!   Descrição detalhada da atualização      			         !Nome do         ! Analista     !Data da     !
!                                                          !Solicitante     ! Respons.     !Atualiz.    !
+----------------------------------------------------------+----------------+--------------+------------+
*/

User Function ConsTMK()

Local aAreaZZ:= getarea() 
Local oButton1
Local oButton2
Local oButton3
Local oButton4
Local oGet1
Local cGet1		:= space(40)
Local oGroup1
Local oGroup2
Local oRadMenu1
Local nRadMenu1 := 4
Local cCampoSU5 := "U5_DDD#U5_FONE"
Local aContra	:= {}
Local _nLinIni  := 15
Local oSayCodOb

Local nSuperior := 030
Local nEsquerda := 000
Local nInferior := 118
Local nDireita	:= 253

Local nPosNBkp := n

Local nOpc  := 2
Local nOpca := 0
Local Abuttons := {}
Local cEntidade := M->UC_ENTIDAD

Private aHeader		:= {}
Private aCols		:= {}
Private _nOpc1 := nOpc
Private cTelDisk
Private xRet	:= .f.

Private aTelCont := {}
Private aTelEnt  := {} 


Static oDlg

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

lContato:= IIF(Empty(M->UC_CODCONT),.F.,.T.)
lChave  := IIF(Empty(M->UC_CHAVE),.F.,.T.)

If lContato
	aTelCont := SGReadTel("SU5",M->UC_CODCONT)
Else
	MsgInfo("Por favor selecione um contato.","SEM CONTATO")
	return .F.
Endif

If lChave
	aTelEnt	 := SGReadTel(cEntidade,M->UC_CHAVE)
Else
	MsgInfo("Por favor selecione uma entidade.","SEM ENTIDADE")
	return .F.
Endif




// Preenche aHeader
dbSelectArea("SX3")
DbSetOrder(1)
DbSeek("SU5")
aHeader:={}
While !Eof().And.(x3_arquivo=="SU5")
	if alltrim(X3_CAMPO) $ cCampoSU5
		Aadd(aHeader,{  IF(x3_campo = "U5_FONE", "Fone",TRIM(x3_titulo)) , x3_campo, "@!",;
		IF(x3_campo = "U5_FONE", 20, x3_tamanho), x3_decimal,"AllwaysTrue()",;
		x3_usado, x3_tipo, x3_arquivo, x3_context } )
	Endif
	dbSkip()
End



// Preenche aCols
		
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega telefones do contato                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 


For i:=1 to Len(aTelCont)
	AADD(aCols,Array(Len(aHeader)+1))
	For nX:=1 to Len(aHeader)
		_cNomCpo := AllTrim(aHeader[nX,2])
		if _cNomCpo = "U5_FONE"
			aCols[Len(aCols),nX] := aTelCont[i]
		Elseif _cNomCpo = "U5_DDD" 
			aCols[Len(aCols),nX] := Posicione("SU5",1,xFilial("SU5")+M->UC_CODCONT,"U5_DDD")
		Endif
		aCols[Len(aCols),Len(aHeader)+1]:=.F.
	Next
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega telefones da entidade                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 

For i:=1 to Len(aTelEnt)
	AADD(aCols,Array(Len(aHeader)+1))
	For nX:=1 to Len(aHeader)
		_cNomCpo := AllTrim(aHeader[nX,2]) 
		
		if _cNomCpo = "U5_FONE"
			aCols[Len(aCols),nX] := aTelEnt[i]
		Elseif _cNomCpo = "U5_DDD" 
			aCols[Len(aCols),nX] := Posicione(cEntidade,1,xFilial("SU5")+M->UC_CHAVE,SubStr(cEntidade,2,2)+"_DDD")
		Endif
		aCols[Len(aCols),Len(aHeader)+1]:=.F.
	Next
Next
	



if len(Acols) = 0
	MsgInfo("Não existem numeros cadastrados para contato.")
	Return .F.
Endif




DEFINE MSDIALOG oDlg TITLE "Contato" FROM 000, 000  TO 235, 500 PIXEL

//Cabeçalho

//Aadd( aButtons, {"S4WB011N", {|| GCT4Pesq()}, "Pesquisar...", "Pesquisar" , {|| .T.}} )

@ _nLinIni, 010 SAY oSayCodOb PROMPT "Selecione um numero para discar:" SIZE 100, 007 OF oDlg  PIXEL

oGetDad := MSGetDados():New(nSuperior ,nEsquerda ,nInferior ,nDireita ,nOpc ,,.T.,"",.T.)


oGetDad:OBROWSE:BLDBLCLICK :=  {||(nOpca:=1 ,.T., oDlg:End())}

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg ,{||(nOpca:=1 ,.T., oDlg:End())} ,{||nOpca:=2 ,oDlg:End()},,@aButtons) VALID nOpca != 0



If nOpca == 1

		If !Empty(aCols[n][1]+aCols[n][2])
			cTelDisk := Alltrim(aCols[n][1])+AllTrim(aCols[n][2])
			xRet := .T.
		Endif
		
		Discagem() // Tela para discar
		
Endif


RestArea(aAreaZZ)
n := nPosNBkp // Restaura a posição da linha na acols do atendimento.

Return xRet




Static Function Discagem()

Local cSenhaOp := ''
Local cExterna := Alltrim(TkPosto(TkOperador(),"U0_EXTERNA"))
Local cTel := ''

	// Posiciona na senha do operador
	cSenhaOp := AllTrim(Posicione("SU7", 1, xFilial("SU7")+TkOperador(), "U7_SENHALG")) //"U7_SENHALG"
	
	
	cTel := SgLimpaTel(cExterna+cSenhaOp+cTelDisk)
	SGMnuAtivo(cTel)   // Colocar o campo para de senha do operador
Return