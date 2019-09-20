#INCLUDE "Protheus.CH"
/*---------------------------------------------------------------------------+
!                          FICHA TECNICA DO PROGRAMA                         !
+----------------------------------------------------------------------------+
!DADOS DO PROGRAMA                                                           !
+------------------+---------------------------------------------------------+
!Tipo              ! User Function                                           !
+------------------+---------------------------------------------------------+
!Modulo            ! FINANCEIRO 					                         !
+------------------+---------------------------------------------------------+
!Descricao         ! Transferencia de arquivos servidor/terminal  			 !
!                  ! opção inversa está desabilitada						 !
+------------------+---------------------------------------------------------+
!Autor             ! Jair Matos de Andrade                                   !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 29/08/2013                                          	 !
+------------------+---------------------------------------------------------+
!                               ATUALIZACOES                                 !
+-------------------------------------------+-----------+-----------+--------+
!   Descricao detalhada da atualizacao      !  Nome do  ! Analista  !Data da !
!                                           !Solicitante! Respons.  !Atualiz.!
+-------------------------------------------+-----------+-----------+--------+
!		                        !           !    	    !           !        !
+-------------------------------------------+-----------+-----------+-------*/


User Function FINARQ01()

Private oOk  	 := Loadbitmap(GetResources(), 'LBOK')
Private oNo   	 := Loadbitmap(GetResources(), 'LBNO')
Private aListC   := {}
Private aListD   := {}
Private nLista   := nLista2 := 1
Private cOrigem  := "C:\"
Private cDestino := "\financeiro\"

Private oDlg,oList1,oList2
Private cDirAtu  :=  Upper( Trim( CurDir() ) )    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If Right(cDirAtu,1) $ "\/"
	cDirAtu := SubStr(cDirAtu,1, Len(cDirAtu) -1 )
	If Right(cDirAtu,1) $ "\/"
		cDirAtu := SubStr(cDirAtu,1, Len(cDirAtu) -1 )
	EndIf
EndIf
// 	cDestino += cDirAtu + "\"      jair

FINARQ02( 3 )

Define MsDialog oDlg From 000,000 To 600,800 Title "Transferencia de Arquivos " Of oMainWnd Pixel

oBtn := tButton():New(010,005,'Terminal'     ,oDlg,{|| FINARQ03(1) },35,15,,,,.T.)
oBtn := tButton():New(010,100,'Selec. Todos' ,oDlg,{|| FINARQ08(1)   },35,15,,,,.F.)

oBtn := tButton():New(010,225,'Servidor'     ,oDlg,{|| FINARQ03(2) },35,15,,,,.F.)
oBtn := tButton():New(010,325,'Selec. Todos' ,oDlg,{|| FINARQ08(2)   },35,15,,,,.T.)


@030,005 Say cOrigem  Size 190,10 OF oDlg PIXEL
@030,225 Say cDestino Size 175,10 OF oDlg PIXEL

@040,005 ListBox oList1 Fields HEADERS '  ','Arquivo','Tamanho','Data','Hora' Size 170,250 Pixel Of oDlg ;
On dblClick(aListC := FINARQ10(oList1:nAt,aListC) , oList1:Refresh() )

@040,225 ListBox oList2 Fields HEADERS '  ','Arquivo','Tamanho','Data','Hora' Size 170,250 Pixel Of oDlg ;
On dblClick(aListD := FINARQ10(oList2:nAt,aListD) , oList2:Refresh() )

oList1:SetArray(aListC)
if empty(aListC)
	oList1:bLine := {|| {oOk, "", "", "",""}}
else
	oList1:bLine:={||{If(aListC[oList1:nAt,01],oOk,oNo),aListC[oList1:nAt,2],Transform(aListC[oList1:nAt,3],"999,999,999,999"),DtoC(aListC[oList1:nAt,4]), aListC[oList1:nAt,5] } }
endif
oList1:Refresh()

oList2:SetArray(aListD)
if empty(aListD)
	oList2:bLine := {|| {oOk, "", "", "",""}}
else
	oList2:bLine:={||{If(aListD[oList2:nAt,01],oOk,oNo),aListD[oList2:nAt,2],Transform(aListD[oList2:nAt,3],"999,999,999,999"),DtoC(aListD[oList2:nAt,4]), aListD[oList2:nAt,5] } }
endif
oList2:Refresh()

oBtn := tButton():New(070,180,' ---> ' ,oDlg,{|| FINARQ05(1)}   ,35,20,,,,.F.)
oBtn := tButton():New(100,180,' <--- ' ,oDlg,{|| FINARQ05(2)}   ,35,20,,,,.T.)
oBtn := tButton():New(190,180,'FINARQ04',oDlg,{|| FINARQ04() }    ,35,20,,,,.F.)
oBtn := tButton():New(130,180,'Refresh',oDlg,{|| FINARQ07() }    ,35,20,,,,.T.)
oBtn := tButton():New(160,180,'Sair'   ,oDlg,{|| oDlg:End()}    ,35,20,,,,.T.)

Activate MsDialog oDlg Centered

Return


Static Function FINARQ02( nTipo  )

Local nI

If nTipo == 1 .Or. nTipo == 3
	aListC := {}
	aListM := Directory(cOrigem + "*.csv")
	For nI := 1 To Len(aListM)
		aAdd( aListC , { .f. , aListM[nI,1], aListM[nI,2], aListM[nI,3], aListM[nI,4] } )
	Next
	aSort(aListC,,,{|X,Y| X[4] < Y[4] })
EndIf

If nTipo == 2 .Or. nTipo == 3
	
	aListD := {}
	aListN := Directory( cDestino + "*.csv")
	For nI := 1 To Len(aListN)
		aAdd( aListD , { .f. , aListN[nI,1], aListN[nI,2], aListN[nI,3], aListN[nI,4] } )
	Next
	aSort(aListD,,,{|X,Y| X[4] < Y[4] })
EndIf

Return


Static Function FINARQ03(nTipo)

Local lOk := .t.
Local cOrgBkp  := cOrigem
Local cDestBkp := cDestino
Local nCont    := 0
While lOk
	nCont += 1
	If nTipo == 1
		cOrigem  := cGetFile("","Selecione o Destino ...",0,"",.F.,GETF_RETDIRECTORY+GETF_LOCALHARD+GETF_OVERWRITEPROMPT)
		If SubStr(cOrigem,1,1) == '\'
			MsgAlert("Nao foi selecionado o diretorio local!")
		Else
			lOk := .f.
		EndIf
	Else
		cDestino := cGetFile("","Selecione o Destino ...",0,"",.F.,GETF_RETDIRECTORY+GETF_OVERWRITEPROMPT)
		If SubStr(cDestino,1,1) <>  '\'
			MsgAlert("Nao foi selecionado o diretorio do Servidor!")
		Else
			lOk := .f.
		EndIf
	EndIf
	If nCont > 5
		cDestino := cDestBkp
		cOrigem  := cOrgBkp
		Exit
	EndIf
EndDo

If nTipo == 1
	FINARQ02(1) //Origem
	oList1:SetArray(aListC)
	oList1:bLine:={||{If(aListC[oList1:nAt,01],oOk,oNo),aListC[oList1:nAt,2],Transform(aListC[oList1:nAt,3],"999,999,999,999"),DtoC(aListC[oList1:nAt,4]), aListC[oList1:nAt,5] } }
	oList1:Refresh()
	
Else
	FINARQ02(2) //Destino
	oList2:SetArray(aListD)
	oList2:bLine:={||{If(aListD[oList2:nAt,01],oOk,oNo),aListD[oList2:nAt,2],Transform(aListD[oList2:nAt,3],"999,999,999,999"),DtoC(aListD[oList2:nAt,4]), aListD[oList2:nAt,5] } }
	oList2:Refresh()
	
EndIf
oDlg:Refresh()

Return(.t.)


Static Function FINARQ04()

local nn,pp

local aCopia := aClone(aListC)
local cVar   := Lower(cOrigem)


if !MsgYesNo("A operacao excluira todos os arquivos selecionados. Tanto no Terminal, quanto no Servidor. CONFIRMA?")
	oDlg:Refresh()
	return
endif

pp := 0
for nn := 1 to len(aCopia)
	if aCopia[nn,1]
		FERASE(cVar + Lower(aCopia[nn,2]))
		pp++
	endif
next nn


aCopia := aClone(aListD)
cVar  := Lower(cDestino)
for nn := 1 to len(aCopia)
	if aCopia[nn,1]
		FERASE(cVar + Lower(aCopia[nn,2]))
		pp++
	endif
next nn

MsgAlert("Excluidos " + cValToChar(pp) + " arquivos.")

FINARQ02(1) //Origem

oList1:SetArray(aListC)
oList1:bLine:={||{If(aListC[oList1:nAt,01],oOk,oNo),aListC[oList1:nAt,2],Transform(aListC[oList1:nAt,3],"999,999,999,999"),DtoC(aListC[oList1:nAt,4]), aListC[oList1:nAt,5] } }
oList1:Refresh()

FINARQ02(2)// Destino

oList2:SetArray(aListD)
oList2:bLine:={||{If(aListD[oList2:nAt,01],oOk,oNo),aListD[oList2:nAt,2],Transform(aListD[oList2:nAt,3],"999,999,999,999"),DtoC(aListD[oList2:nAt,4]), aListD[oList2:nAt,5] } }
oList2:Refresh()

oDlg:Refresh()

Return


Static Function FINARQ05(nTipo)

Local cVar   := ""
Local cVar3  := ""
Local aCopia := {}

If nTipo == 1    //Terminal para o Servidor   bloqueado por jair
	/*	aCopia := aClone(aListC)
	cVar   := Lower(cOrigem)
	cVar3  := Lower(cDestino)
	*/
	msgAlert("Opção Terminal para o Servidor está desabilitada")
Else
	//Servidor para o Terminal
	aCopia := aClone(aListD)
	cVar  := Lower(cDestino)
	cVar3 := Lower(cOrigem)
EndIf

Processa({|| FINARQ06( aCopia, cVar, cVar3, nTipo ) }, 'Copiando... Aguarde...','Aguarde...')

If nTipo == 2
	
	FINARQ02(1) //Origem
	
	oList1:SetArray(aListC)
	oList1:bLine:={||{If(aListC[oList1:nAt,01],oOk,oNo),aListC[oList1:nAt,2],Transform(aListC[oList1:nAt,3],"999,999,999,999"),DtoC(aListC[oList1:nAt,4]), aListC[oList1:nAt,5] } }
	oList1:Refresh()
Else
	
	FINARQ02(2)// Destino
	
	oList2:SetArray(aListD)
	oList2:bLine:={||{If(aListD[oList2:nAt,01],oOk,oNo),aListD[oList2:nAt,2],Transform(aListD[oList2:nAt,3],"999,999,999,999"),DtoC(aListD[oList2:nAt,4]), aListD[oList2:nAt,5] } }
	oList2:Refresh()
EndIf

oDlg:Refresh()

Return(.t.)


/*---------------------------------------------------------------------------+
!DADOS DO PROGRAMA                                                           !
+------------------+---------------------------------------------------------+
!Tipo              ! static Function FINARQ06                               !
+------------------+---------------------------------------------------------+
!Descricao         ! Faz copia dos registros marcados						 !
+------------------+---------------------------------------------------------+
!Autor             ! Jair Matos de Andrade                                   !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 29/08/2013                                          	 !
+------------------+--------------------------------------------------------*/

Static Function FINARQ06(aCopia,cVar,cVar3,nTipo)

Local nI
local cMsg1					:= ""
local lSucess				:= .F.
local nAcopia				:= Len(aCopia)
local aFiles				:= {}
local nJ						:= 0
local nK						:= 0
local cRemoteip			:=	Getclientip()
local cRemoteComputer	:=	GetComputerName()
local cThread				:=	alltrim(str(ThreadId(),16,0))
local nN						:= 0
local cMsg2					:= "* GSPN060 * "

cMsg2	+= iif(nTipo <> 2,"TERMINAL => SERVIDOR","SERVIDOR => TERMINAL")
cMsg2	:= Substr(cMsg2 + " " + REPLICATE("*",80), 1, 80)

for nI:=1 to nAcopia
	if aCopia[nI,1]
		aadd(aFiles,{ ni , alltrim(upper(aCopia[nI,2])), " "} )
		nJ++
	endif
next
nN:= LEN(aFiles)
cMsg1	:= (" ")
cMsg1	+= chr(13)+chr(10)
cMsg1	+= cMsg2
cMsg1	+= chr(13)+chr(10)
cMsg1	+= (" Usuario=[" + cUsername + "] Computador=[" + cRemoteComputer + "]")
cMsg1	+= (" IP=[" + cRemoteip + "]")
cMsg1	+= (" Thread=[" + cThread + "]")
cMsg1	+= chr(13)+chr(10)
cMsg1	+= (" Origem =[" + alltrim(cVar) + "]")
cMsg1	+= chr(13)+chr(10)
cMsg1	+= (" Destino=[" + alltrim(cVar3) + "]")
cMsg1	+= chr(13)+chr(10)
cMsg1	+= (" Inicio da Copia em [" + dtoc(date()) + " " + time() + "].")
if nJ >= 1
	cMsg1	+= ( " Copiar " + alltrim(str(nj,10,0)) + iif(nJ <= 1, " arquivo FINARQ08ionado"," arquivos FINARQ08ionados") +".")
else
	cMsg1	+= (" ? ")
Endif
cMsg1	+= chr(13)+chr(10)
cMsg1	+= (" Arquivos:")
for nI:=1 to nN
	cMsg1	+= IIF(nI==1," "," ; ") + ALLTRIM(aFiles[nI,2])
next
cMsg1	+= chr(13)+chr(10)
cMsg1	+= ("******************************************************************************")
cMsg1	+= chr(13)+chr(10)
cMsg1	+= (" ")
cMsg1	+= chr(13)+chr(10)
Conout(cMsg1)

ProcRegua( naCopia )

For nI := 1 To naCopia
	
	cVar2 := Lower(aCopia[nI,2])   //Nome do Arquivo a ser copiado.
	
	cIncProc := If( aCopia[nI,1] , 'Copiando arquivo: ' + Trim(cVar2) , "" )
	IncProc( cIncProc )
	
	If aCopia[nI,1] //Esta marcado, entao copia
		
		If nTipo == 2  //  Servidor para Remote
			lSucess := CpyS2T( cVar + cVar2 , cVar3 , .T. )
		Else   //  Remote para Sevidor
			lSucess := CpyT2S( cVar + cVar2 , cVar3 , .T. )
		EndIf
		if lSucess
			nN	:= ascan(aFiles,{|aVal| aVal[1] == nI})
			aFiles[nN,3] := "*"
			nK++
		Endif
	EndIf
Next

cMsg1	:= (" ")
cMsg1	+= chr(13)+chr(10)
cMsg1	+= cMsg2
cMsg1	+= chr(13)+chr(10)
cMsg1	+= (" Usuario=[" + cUsername + "] Computador=[" + cRemoteComputer + "]")
cMsg1	+= (" IP=[" + cRemoteip + "]")
cMsg1	+= (" Thread=[" + cThread + "]")
cMsg1	+= chr(13)+chr(10)
cMsg1	+= (" Origem=[" + alltrim(cVar) + "]")
cMsg1	+= chr(13)+chr(10)
cMsg1	+= (" Destino=[" + alltrim(cVar3) + "]")
cMsg1	+= chr(13)+chr(10)
cMsg1	+= (" Termino da Copia em [" + dtoc(date()) + " " + time() + " Hr].")
cMsg1	+= chr(13)+chr(10)
if nK == 1
	cMsg1	+= (" Foi copiado 1 arquivo")
Elseif nK > 1
	cMsg1	+= (" Foram copiados " + alltrim(str(nK,10,0) ) + " arquivos " )
Else
	cMsg1	+= (" Nenhum arquivo foi copiado")
Endif

if nJ == 1
	cMsg1	+= (" de 1 arquivo FINARQ08ionado." )
Elseif nJ > 1
	cMsg1	+= (" de " + alltrim( str(nj,10,0) )  + " arquivos FINARQ08ionados")
Else
	cMsg1	+= (".")
Endif

cMsg1	+= chr(13)+chr(10)

if nK == 1
	cMsg1	+= (" Arquivo copiado:")
Elseif nK > 1
	cMsg1	+= (" Arquivos copiados:")
else
	cMsg1	+= ("?")
	cMsg1	+= chr(13)+chr(10)
Endif

if nK >= 1
	for nI:=1 to nJ
		if aFiles[nI,3] <> " "
			cMsg1	+= ( iif(nI=1," "," ; ") + upper(alltrim(aFiles[nI,2])) )
		endif
	next
	cMsg1	+= chr(13)+chr(10)
Endif

if nJ >= 1 .and. nJ <> nK
	if (nJ - nk) == 1
		cMsg1	+= (" 1 Arquivo nao copiado:")
	else
		cMsg1	+= (" " + alltrim(str((nJ - nk),10,0)) + " Arquivos nao copiados:")
	endif
	for nI:=1 to nJ
		if aFiles[nI,3] == " "
			cMsg1	+= ( iif(nI=1," "," ; ") + upper(alltrim(aFiles[nI,2])) )
		endif
	next
	cMsg1	+= chr(13)+chr(10)
	
Endif
cMsg1	+= ("******************************************************************************")
cMsg1	+= chr(13)+chr(10)
cMsg1	+= (" ")
cMsg1	+= chr(13)+chr(10)

//Conout(cMsg1)



Return

/*---------------------------------------------------------------------------+
!DADOS DO PROGRAMA                                                           !
+------------------+---------------------------------------------------------+
!Tipo              ! static Function  FINARQ07                                !
+------------------+---------------------------------------------------------+
!Descricao         ! Chama a função de refresh da tela						 !
+------------------+---------------------------------------------------------+
!Autor             ! Jair Matos de Andrade                                   !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 29/08/2013                                          	 !
+------------------+--------------------------------------------------------*/
Static Function FINARQ07()

FINARQ02(1) //Origem

oList1:SetArray(aListC)
oList1:bLine:={||{If(aListC[oList1:nAt,01],oOk,oNo),aListC[oList1:nAt,2],Transform(aListC[oList1:nAt,3],"999,999,999,999"),DtoC(aListC[oList1:nAt,4]), aListC[oList1:nAt,5] } }
oList1:Refresh()

FINARQ02(2) //Destino
oList2:SetArray(aListD)
oList2:bLine:={||{If(aListD[oList2:nAt,01],oOk,oNo),aListD[oList2:nAt,2],Transform(aListD[oList2:nAt,3],"999,999,999,999"),DtoC(aListD[oList2:nAt,4]), aListD[oList2:nAt,5] } }
oList2:Refresh()

oDlg:Refresh()

Return()

/*---------------------------------------------------------------------------+
!DADOS DO PROGRAMA                                                           !
+------------------+---------------------------------------------------------+
!Tipo              ! static Function  FINARQ08                                !
+------------------+---------------------------------------------------------+
!Descricao         ! Chama a função que atualiza e marca os registros		 !
+------------------+---------------------------------------------------------+
!Autor             ! Jair Matos de Andrade                                   !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 29/08/2013                                          	 !
+------------------+--------------------------------------------------------*/
Static Function FINARQ08(nTipo)

If nTipo == 1
	aListC := FINARQ09(aListC)
	oList1:Refresh()
Else
	aListD := FINARQ09(aListD)
	oList2:Refresh()
EndIf
oDlg:Refresh()

Return


/*---------------------------------------------------------------------------+
!DADOS DO PROGRAMA                                                           !
+------------------+---------------------------------------------------------+
!Tipo              ! static Function  FINARQ09                                !
+------------------+---------------------------------------------------------+
!Descricao         ! Troca o flag de marcacao do browse do registro posicion.!
+------------------+---------------------------------------------------------+
!Autor             ! Jair Matos de Andrade                                   !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 29/08/2013                                          	 !
+------------------+--------------------------------------------------------*/
Static Function FINARQ09(aVetor)

Local nI
For nI := 1 To Len(aVetor)
	aVetor[nI,1] := !aVetor[nI,1]
Next

Return(aVetor)

/*---------------------------------------------------------------------------+
!DADOS DO PROGRAMA                                                           !
+------------------+---------------------------------------------------------+
!Tipo              ! static Function  FINARQ09                               !
+------------------+---------------------------------------------------------+
!Descricao         ! Troca o flag de marcacao do browse do registro posicion.!
+------------------+---------------------------------------------------------+
!Autor             ! Jair Matos de Andrade                                   !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 29/08/2013                                          	 !
+------------------+--------------------------------------------------------*/
Static Function FINARQ10(nIt,aVetor)

aVetor[nIt,1] := !aVetor[nIt,1]

Return(aVetor)
