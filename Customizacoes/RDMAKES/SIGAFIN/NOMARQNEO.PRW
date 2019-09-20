#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOMARQNEO     ºAutor  ³Jean           º Data ³  09/03/12    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina com a finalidade de criar uma nomenclatura padrão   º±±
±±º          ³ para arquivos transm. e receb. através do client da Neogridº±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*----------------------------*
User Function NomArqNeo()
*----------------------------*
Local oGet01                                                    
Local oGet02 
Local oGet03
Local oGet04
Local oGet05
Local oGet06
Local oGetExt
Local oAdicionar
Local oCombo01
Local oComboBox1
Local oExemplo
Local oGetQtde
Local oGrp01
Local oGrpMont
Local oGrpPesq
Local oSayAge
Local oSayBco
Local oSayCta
Local oSaySubCta
Local oRemover 

Static oDlgNomArq                                                         

Private cGet01    	:= Space(03)
Private cGet02    	:= Space(05)
Private cGet03  		:= Space(01)
Private cGet04    	:= Space(20)
Private cGet05  		:= Space(01)
Private cGet06 			:= Space(03)
Private nComboBox1 	:= "1"
Private nCombo01   	:= "1"
Private nGetQtde   	:= 0
Private aCboTpData 	:= {"1=ddmmaa","2=mmddaa","3=aammdd","4=ddmmaaaa","5=aaaammdd","6=mmddaaaa"}
Private aCboTpPart 	:= {"1=Empresa","2=Filial","3=Cod. Banco","4=Agência","5=Dv Agência","6=Conta","7=Dv Conta",;
												"8=SubConta","9=Data","10=Raiz CNPJ","11=Separador","12=Prefixo","13=Sequencial"}
Private cGetExt    	:= Space(03)
Private cFormato  	:= "..."
Private aFormato    := {}                                    
Private lBloqBco    := .T.          
Private cGetPref		:= Space(06)
Private cGetSep			:= Space(01)
Private oFntTahoma 	:= TFont():New("Tahoma",,014,,.F.,,,,,.F.,.F.)
Private oFntGrande  := TFont():New("Calibri",,024,,.F.,,,,,.F.,.F.) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

  DEFINE MSDIALOG oDlgNomArq TITLE "NOMENCLATURAS DE ARQUIVOS BANCÁRIOS" FROM 000, 000  TO 400, 700 COLORS 0, 16777215 PIXEL

    @ 015, 004 GROUP oGrpPesq TO 055, 349 OF oDlgNomArq COLOR 0, 16777215 PIXEL
    @ 013, 002 GROUP oGrp01   TO 199, 351 OF oDlgNomArq COLOR 0, 16777215 PIXEL
    @ 057, 004 GROUP oGrpMont TO 130, 349 OF oDlgNomArq COLOR 0, 16777215 PIXEL
    @ 132, 004 GROUP oGrpLeg 	TO 197, 349 OF oDlgNomArq COLOR 0, 16777215 PIXEL

    @ 075, 013 MSCOMBOBOX oCombo01		VAR nCombo01		ITEMS aCboTpPart WHEN (ProcRegSEE()) SIZE 080, 010 OF oDlgNomArq COLORS 0, 16777215 FONT oFntTahoma PIXEL
    @ 075, 133 MSCOMBOBOX oComboBox1 	VAR nComboBox1	ITEMS aCboTpData WHEN (nCombo01 == "9" .and. ProcRegSEE()) 	SIZE 072, 010 OF oDlgNomArq COLORS 0, 16777215 FONT oFntTahoma PIXEL    

    @ 074, 215 MSGET oGetQtde 	VAR nGetQtde 	SIZE 023, 010 WHEN ValOpcao(nCombo01, nComboBox1) 							OF oDlgNomArq PICTURE "@E 999" COLORS 0, 16777215 FONT oFntTahoma PIXEL
    @ 074, 098 MSGET oGetPref		VAR cGetPref	SIZE 030, 010 VALID (!Empty(cGetPref)) 	WHEN (nCombo01 == "12") OF oDlgNomArq PICTURE "@!" COLORS 0, 16777215 		FONT oFntTahoma PIXEL
    @ 026, 010 MSGET oGet01 		VAR	cGet01	 	SIZE 019, 010 VALID GetFormato() 				WHEN lBloqBco 					OF oDlgNomArq COLORS 0, 16777215 		FONT oFntTahoma F3 "SEEEXT" PIXEL
    @ 026, 045 MSGET oGet02 		VAR cGet02 		SIZE 027, 010 WHEN .F. OF oDlgNomArq COLORS 0, 16777215 		FONT oFntTahoma PIXEL
    @ 026, 075 MSGET oGet03 		VAR cGet03 		SIZE 011, 010 WHEN .F. OF oDlgNomArq COLORS 0, 16777215 		FONT oFntTahoma PIXEL
    @ 026, 097 MSGET oGet04 		VAR cGet04 		SIZE 060, 010 WHEN .F. OF oDlgNomArq COLORS 0, 16777215 		FONT oFntTahoma PIXEL
    @ 026, 159 MSGET oGet05 		VAR cGet05		SIZE 012, 010 WHEN .F. OF oDlgNomArq COLORS 0, 16777215 		FONT oFntTahoma PIXEL
    @ 026, 182 MSGET oGet06 		VAR cGet06		SIZE 023, 010 WHEN .F. OF oDlgNomArq COLORS 0, 16777215 		FONT oFntTahoma PIXEL
    @ 026, 248 MSGET oGetExt 		VAR cGetExt		SIZE 026, 010 WHEN .F. OF oDlgNomArq COLORS 0, 16777215  		FONT oFntTahoma PIXEL
    @ 074, 248 MSGET oGetSep 		VAR cGetSep		SIZE 026, 010 VALID (cGetSep $ ",-.") WHEN (nCombo01 == "11") OF oDlgNomArq COLORS 0, 16777215  	FONT oFntTahoma PIXEL

    @ 074, 285 BUTTON oAdicionar 	PROMPT "Adic."	SIZE 025, 012 WHEN (ProcRegSEE()) ACTION AddFormato() OF oDlgNomArq FONT oFntTahoma PIXEL
		@ 074, 315 BUTTON oRemover  	PROMPT "Rem."		SIZE 025, 012 WHEN (cFormato != "...") ACTION RemFormato() OF oDlgNomArq FONT oFntTahoma PIXEL
                                                                      									
    @ 097, 011 SAY oExemplo 	PROMPT cFormato			SIZE 284, 013 OF oDlgNomArq FONT oFntGrande COLORS 0, 16777215 PIXEL
    @ 019, 011 SAY oSayBco 		PROMPT "Banco" 			SIZE 019, 007 OF oDlgNomArq FONT oFntTahoma COLORS 0, 16777215 PIXEL
    @ 019, 047 SAY oSayAge 		PROMPT "Agencia" 		SIZE 025, 007 OF oDlgNomArq FONT oFntTahoma COLORS 0, 16777215 PIXEL
    @ 019, 097 SAY oSayCta 		PROMPT "Conta" 			SIZE 025, 007 OF oDlgNomArq FONT oFntTahoma COLORS 0, 16777215 PIXEL
    @ 019, 183 SAY oSaySubCta PROMPT "SubConta" 	SIZE 026, 007 OF oDlgNomArq FONT oFntTahoma COLORS 0, 16777215 PIXEL
    @ 019, 247 SAY oSayExten 	PROMPT "Extensão" 	SIZE 026, 007 OF oDlgNomArq FONT oFntTahoma COLORS 0, 16777215 PIXEL
    @ 067, 014 SAY oSayTpInf	PROMPT "Tp.Infor" 	SIZE 026, 007 OF oDlgNomArq FONT oFntTahoma COLORS 0, 16777215 PIXEL
    @ 067, 099 SAY oSayPref		PROMPT "Prefixo"		SIZE 026, 007 OF oDlgNomArq FONT oFntTahoma COLORS 0, 16777215 PIXEL
    @ 067, 134 SAY oSayTpDt		PROMPT "Tp.Data"		SIZE 026, 007 OF oDlgNomArq FONT oFntTahoma COLORS 0, 16777215 PIXEL
    @ 067, 216 SAY oSayQtde		PROMPT "Tamanho"		SIZE 026, 007 OF oDlgNomArq FONT oFntTahoma COLORS 0, 16777215 PIXEL
    @ 067, 249 SAY oSaySep		PROMPT "Separador" 	SIZE 026, 007 OF oDlgNomArq FONT oFntTahoma COLORS 0, 16777215 PIXEL
       
		//ÚÄÄÄÄÄÄÄ¿
		//³Legenda³
		//ÀÄÄÄÄÄÄÄÙ
		
		@ 140, 013 SAY oLeg01			PROMPT "E = CODIGO DA EMPRESA"		SIZE 080, 007 OF oDlgNomArq FONT oFntTahoma COLORS 0, 16777215 PIXEL
		@ 150, 013 SAY oLeg02			PROMPT "F = CODIGO DA FILIAL"			SIZE 080, 007 OF oDlgNomArq FONT oFntTahoma COLORS 0, 16777215 PIXEL
		@ 160, 013 SAY oLeg03			PROMPT "B = CODIGO DO BANCO"			SIZE 080, 007 OF oDlgNomArq FONT oFntTahoma COLORS 0, 16777215 PIXEL
		@ 170, 013 SAY oLeg04			PROMPT "A = CODIGO DA AGENCIA"		SIZE 080, 007 OF oDlgNomArq FONT oFntTahoma COLORS 0, 16777215 PIXEL
		@ 180, 013 SAY oLeg05			PROMPT "D = DG. VERIF. AG/CONTA"	SIZE 080, 007 OF oDlgNomArq FONT oFntTahoma COLORS 0, 16777215 PIXEL
		@ 140, 100 SAY oLeg06			PROMPT "C = CODIGO DA CONTA"			SIZE 080, 007 OF oDlgNomArq FONT oFntTahoma COLORS 0, 16777215 PIXEL		
		@ 150, 100 SAY oLeg07			PROMPT "S = CODIGO DA SUBCONTA"		SIZE 080, 007 OF oDlgNomArq FONT oFntTahoma COLORS 0, 16777215 PIXEL
		@ 160, 100 SAY oLeg08			PROMPT "G = RAIZ DO CNPJ"					SIZE 080, 007 OF oDlgNomArq FONT oFntTahoma COLORS 0, 16777215 PIXEL
		@ 170, 100 SAY oLeg09 		PROMPT "Q = CODIGO SEQUENCIAL"		SIZE 080, 007 OF oDlgNomArq FONT oFntTahoma COLORS 0, 16777215 PIXEL
				
  ACTIVATE MSDIALOG oDlgNomArq CENTER ON INIT EnchoiceBar(oDlgNomArq,{|| AtuaSEE(), oDlgNomArq:End()}, {|| oDlgNomArq:End() })

Return                                                                                

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que retorna o formato já cadastrado no sistema³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function GetFormato()
Local cTmpNom, cTmp := ""
Local i    		:= 0 
Local nQtd 		:= 0
Local cNom 		:= ""
Local cTpData := ""
Local cConteu := ""

aFormato := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Busca nas configurações de banco a nomenclatura já existente.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cTmpNom := Posicione("SEE",01,xFilial("SEE") + cGet01 + cGet02 + cGet04 + cGet06, "EE_X_NOM")

if !Empty(cTmpNom)
	for i := 1 to len(cTmpNom)
		if Empty(cTmpNom)
			Exit
		EndIf
		nQtd 		:= SubStr(cTmpNom, 1, At(",",cTmpNom)-1)
		cTmpNom := SubStr(cTmpNom, At(",",cTmpNom)+1)
		cNom 		:= SubStr(cTmpNom, 1, At(",",cTmpNom)-1)
		cTmpNom := SubStr(cTmpNom, At(",",cTmpNom)+1)
		cTpData := SubStr(cTmpNom, 1, At(",",cTmpNom)-1)	
		cTmpNom := SubStr(cTmpNom, At(",",cTmpNom)+1)
		cConteu := SubStr(cTmpNom, 1, iif(At("|",cTmpNom)-1 == -1, 1,At("|",cTmpNom)-1))
		cTmpNom := SubStr(cTmpNom, iif(At("|",cTmpNom)-1 == -1, 2, At("|",cTmpNom)+1))
    Aadd(aFormato, {Val(nQtd), cNom, cTpData, cConteu})
	Next i
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ@¿
//³Função para atualizar o formato que aparece na tela.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ@Ù

AtuFormato()

lBloqBco := .F.

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄD¿
//³Função utilizada para atualizar informação na tabela SEE³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄDÙ

Static Function AtuaSEE()
Local cTmp := ""

if len(aFormato) > 0
	for l := 1 to len(aFormato)
		
		if !Empty(cTmp) 
			cTmp += "|"
		EndIf
		
		cTmp += AllTrim(Str(aFormato[l, 01],0)) + ","
		cTmp += aFormato[l, 02] + "," 
		cTmp += aFormato[l, 03] + ","
		cTmp += aFormato[l, 04]
		
	Next l
EndIf

if ProcRegSEE()
	if MsgYesNo("Deseja gravar o formato "+Trim(cFormato)+" nos parâmetros do banco?")
		RecLock("SEE")
		SEE->EE_X_NOM := cTmp
		SEE->(MsUnlock())   
	EndIf
EndIf

Return 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ@¿
//³Função que valida se existe o registro na tabela SEE³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ@Ù

Static Function ProcRegSEE()
Local lRet := .F.

DbSelectArea("SEE")
SEE->(DbSetOrder(01))
lRet := SEE->(DbSeek(xFilial("SEE") + cGet01 + cGet02 + cGet04 + cGet06))

Return lRet

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Remove Último Registro do Array³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                    
Static Function RemFormato()

if Len(aFormato) > 0
	aDel(aFormato, Len(aFormato))
	aSize(aFormato, Len(aFormato)-1)
EndIf

AtuFormato()

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ‡¿
//³Função que faz atualização do formato que é mostrado em tela.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ‡Ù

Static Function AtuFormato()

cFormato := ""

if Len(aFormato) <= 0 
	cFormato := "..."
Else
	for i := 1 to len(aFormato)

		Do Case
			
			//ÚÄÄÄÄÄÄÄÄÄ¿
			//³1=Empresa³
			//ÀÄÄÄÄÄÄÄÄÄÙ
			
			Case aFormato[i, 02] == "1"
				cFormato += Replicate("E",aFormato[i, 01])

			//ÚÄÄÄÄÄÄÄÄ
			//³2=Filial³
			//ÀÄÄÄÄÄÄÄÄ

			Case aFormato[i, 02] == "2"
				cFormato += Replicate("F",aFormato[i, 01])

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³3=Cod. Banco³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			Case aFormato[i, 02] == "3"
				cFormato += Replicate("B",aFormato[i, 01])

			//ÚÄÄÄÄÄÄÄÄÄ¿
			//³4=Agência³
			//ÀÄÄÄÄÄÄÄÄÄÙ
			
			Case aFormato[i, 02] == "4"
				cFormato += Replicate("A",aFormato[i, 01])

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³5=Dv. Agência³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			Case aFormato[i, 02] == "5"
				cFormato += Replicate("D",aFormato[i, 01])

			//ÚÄÄÄÄÄÄÄ¿
			//³6=Conta³
			//ÀÄÄÄÄÄÄÄÙ
			
			Case aFormato[i, 02] == "6"
				cFormato += Replicate("C",aFormato[i, 01])

			//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
			//³7=Dv. Conta³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
			
			Case aFormato[i, 02] == "7"
				cFormato += Replicate("D",aFormato[i, 01])

			//ÚÄÄÄÄÄÄÄÄÄÄ¿
			//³8=SubConta³
			//ÀÄÄÄÄÄÄÄÄÄÄÙ
			
			Case aFormato[i, 02] == "8"
				cFormato += Replicate("S",aFormato[i, 01])

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄ
			//³10=Raiz CNPJ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄ
			
			Case aFormato[i, 02] == "10"
				cFormato += Replicate("G",aFormato[i, 01])

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄ
			//³11=Separador³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄ

			Case aFormato[i, 02] == "11"
				cFormato += PADR(aFormato[i, 04],aFormato[i, 01])  
				
			//ÚÄÄÄÄÄÄÄÄÄÄ¿
			//³12=Prefixo³
			//ÀÄÄÄÄÄÄÄÄÄÄÙ
			
			Case aFormato[i, 02] == "12"
				cFormato += PADR(aFormato[i, 04],aFormato[i, 01]," ")
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³13=Sequencial³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
			Case aFormato[i, 02] == "13"
				cFormato += Replicate("Q",aFormato[i, 01])

			//ÚÄÄÄÄÄÄ¿
			//³9=Data³
			//ÀÄÄÄÄÄÄÙ
			
			OtherWise
				cFormato += Upper(SubStr(aCboTpData[Val(aFormato[i, 03])],3))
		EndCase

	Next i
EndIf

if Len(aFormato) > 0
	if !Empty(cGetExt)
		cFormato += "." + cGetExt
	EndIf
EndIf

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Adiciona as opções de nomenclatura³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function AddFormato()
Local lAchou := .F.

if Len(aFormato) > 0
	for j := 1 to len(aFormato)
		if aFormato[j, 2] == nCombo01
			lAchou := .T.
		EndIf
	Next j
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Validação de Separador e Prefixo³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Do Case
	Case nCombo01 == "11"
		if !cGetSep	$ ",-."
			MsgAlert("Utilize como separador Vírgola(,) Traço(-) ou Ponto(.)")
			Return
		EndIf                                                              
	Case nCombo01 == "12"
		If Empty(cGetPref)
			MsgAlert("Não é possível utilizar prefixo em branco!")
		EndIF
EndCase

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Avisa usuário, caso a opção selecionada já foi escolhida anteriormente³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

if !lAchou 
	Aadd(aFormato, {nGetQtde, nCombo01, iif(nCombo01 == "9", nComboBox1, ""),;
									iif(nCombo01 == "11", cGetSep, iif(nCombo01 == "12", cGetPref, " "))})
Else
	if(MsgYesNo("Essa opção já foi adicionada, deseja adicionar novamente?") == .T.)
		Aadd(aFormato, {nGetQtde, nCombo01, iif(nCombo01 == "9", nComboBox1, ""),;
										iif(nCombo01 == "11", cGetSep, iif(nCombo01 == "12", cGetPref, " "))})
	EndIf
EndIf

AtuFormato()

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função utilizada para preencher automaticamente o campo "Tamanho"³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function ValOpcao(nCombo01, nComboBox1)
Local nQuant := 0

Do Case
	Case nCombo01 == "1"
		nQuant := 2
	Case nCombo01 == "2"
		nQuant := 2
	Case nCombo01 == "3
		nQuant := Len(AllTrim(cGet01))
	Case nCombo01 == "4"
		nQuant := iif(nGetQtde != Len(AllTrim(Str(Val(cGet02),0))), nGetQtde, Len(AllTrim(Str(Val(cGet02),0))))
	Case nCombo01 == "5"
		nQuant := Len(AllTrim(cGet03))
	Case nCombo01 == "6"
		nQuant := iif(nGetQtde != Len(AllTrim(Str(Val(cGet04),0))), nGetQtde, Len(AllTrim(Str(Val(cGet04),0))))
	Case nCombo01 == "7"
		nQuant := Len(AllTrim(cGet05))
	Case nCombo01 == "8"
		nQuant := Len(AllTrim(cGet06)) 
	Case nCombo01 == "10"
		nQuant := 8
	Case nCombo01 == "11"
		nQuant := 1  
	Case nCombo01 == "12"
		nQuant := iif(Empty(cGetPref), 06, Len(AllTrim(cGetPref)))
	Case nCombo01 == "13"
		nQuant := iif(nGetQtde != 3, nGetQtde, 3)  
	OtherWise
		Do Case
			Case nComboBox1 == "1" .or. nComboBox1 == "2" .or. nComboBox1 == "3"
				nQuant := 6
			Case nComboBox1 == "4" .or. nComboBox1 == "5" .or. nComboBox1 == "6"
				nQuant := 8
		EndCase
EndCase

nGetQtde := nQuant
	
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GETARQFIN ºAutor  ³Microsiga           º Data ³  03/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função responsável pela interpretação das nomenclaturas.   º±±
±±º          ³ Retorno: Endereço + Nome do Arquivo + Extensão             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*------------------------------------------------------------*
User Function GETARQFIN(cBanco, cAgencia, cConta, cSubCta)    
*------------------------------------------------------------*
Local nX 		 	:= 0
Local aArea		:= GetArea() 
Private cArquivo 	:= ""
Private cCaminho 	:= ""
Private cCamTemp    := iif(cSubCta == "001","\CNABS\RECEBER\TEMPREM\",iif(cSubCta == "003", "\CNABS\PAGAR\TEMPREM\",""))
Private cNomenc  	:= ""                         
Private aFormato    := {}
  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

U_USORWMAKE(ProcName(),FunName())

Do Case
	Case cSubCta == "001" 
		cCaminho := "\CNABS\RECEBER\OUTBOX\"
	Case cSubCta == "002"
		cCaminho := "\CNABS\RECEBER\INBOX\"
	Case cSubCta == "003"
		cCaminho := "\CNABS\PAGAR\OUTBOX\"
	Case cSubCta == "004"
		cCaminho := "\CNABS\PAGAR\INBOX\"
	OtherWise
		cCaminho := "\"
EndCase

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Busca a nomenclatura existente no cadastro de parâmetro de bancos³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

DbSelectArea("SEE")
SEE->(DbSetOrder(1))         
If SEE->(DbSeek(xFilial("SEE") + cBanco + cAgencia + cConta + cSubCta))
	if !Empty(SEE->EE_X_NOM)
		cNomenc := SEE->EE_X_NOM
	Else
		Return cArquivo
	EndIf	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se existir nomenclatura, inicia interpretação.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

if !Empty(cNomenc)
	nQtd 		:= 0
	cNom 		:= ""
	cTpData := ""
	cConteu := ""
	
	for nX := 1 to Len(cNomenc)
		nQtd 		:= SubStr(cNomenc, 1, At(",",cNomenc)-1)
		cNomenc := SubStr(cNomenc, At(",",cNomenc)+1)
		cNom 		:= SubStr(cNomenc, 1, At(",",cNomenc)-1)
		cNomenc := SubStr(cNomenc, At(",",cNomenc)+1)
		cTpData := SubStr(cNomenc, 1, At(",",cNomenc)-1)	
		cNomenc := SubStr(cNomenc, At(",",cNomenc)+1)
		cConteu := SubStr(cNomenc, 1, iif(At("|",cNomenc)-1 == -1, 1,At("|",cNomenc)-1))
		cNomenc := SubStr(cNomenc, iif(At("|",cNomenc)-1 == -1, 2, At("|",cNomenc)+1))
    
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Adiciona no Array aFormato cada parte da nomenclatura.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
    Aadd(aFormato, {Val(nQtd), cNom, cTpData, cConteu})	
	Next nX
EndIf

If !Empty(aFormato)
	For nX := 1 to len(aFormato)
		Do Case
			
			Case aFormato[nX, 02] == "1"
				cArquivo += cEmpAnt

			Case aFormato[nX, 02] == "2"
				cArquivo += cFilAnt

			Case aFormato[nX, 02] == "3"
				cArquivo += PADR(cBanco,aFormato[nX, 01]," ")
			
			Case aFormato[nX, 02] == "4"
				cArquivo += PADR(AllTrim(Str(Val(cAgencia),0)),aFormato[nX, 01],"0")
			
			Case aFormato[nX, 02] == "5"
				cArquivo += PADR(AllTrim(SEE->EE_DVAGE),aFormato[nX, 01]," ")

			Case aFormato[nX, 02] == "6"
				cArquivo += PADR(AllTrim(Str(Val(cConta),0)),aFormato[nX, 01],"0")

			Case aFormato[nX, 02] == "7"
				cArquivo += PADR(AllTrim(SEE->EE_DVCTA),aFormato[nX, 01]," ")

			Case aFormato[nX, 02] == "8"
				cArquivo += PADR(cSubCta,aFormato[nX, 01]," ")

			Case aFormato[nX, 02] == "10"
				cArquivo += PADR(AllTrim(SubStr(SM0->M0_CGC,01,08)),aFormato[nX, 01]," ")

			Case aFormato[nX, 02] == "11"
				cArquivo += PADR(aFormato[nX, 04],aFormato[nX, 01])  
				
			Case aFormato[nX, 02] == "12"
				cArquivo += PADR(aFormato[nX, 04],aFormato[nX, 01]," ")
			
			Case aFormato[nX, 02] == "13"
				cArquivo += iif(cSubCta ==  "001" .or. cSubCta == "003", PADL(BuscaSeq(cBanco,cAgencia,cConta,cSubCta),aFormato[nX, 01],"0"),"*")
			
			OtherWise
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Caso for Data, adequa para gravar de acordo com o padrão do sistema³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				Do Case
					Case aFormato[nX, 03] == "1"
						cArquivo += GravaData(dDataBase,.F.,1)
					Case aFormato[nX, 03] == "2"
						cArquivo += GravaData(dDataBase,.F.,2)
					Case aFormato[nX, 03] == "3"
						cArquivo += GravaData(dDataBase,.F.,4)
					Case aFormato[nX, 03] == "4"
						cArquivo += GravaData(dDataBase,.F.,5)
					Case aFormato[nX, 03] == "5"
						cArquivo += GravaData(dDataBase,.F.,8)
					Case aFormato[nX, 03] == "6"
						cArquivo += GravaData(dDataBase,.F.,6)
				EndCase
				
		EndCase
	Next nX
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄe
//³Busca extensão do arquivo do cadastro de parâmetros de bancos³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄe

DbSelectArea("SEE")
cArquivo += "." + AllTrim(SEE->EE_EXTEN)

if !ExistDir("\CNABS\")
	MakeDir("\CNABS\")
EndIf

if !ExistDir("\CNABS\RECEBER\")
	MakeDir("\CNABS\RECEBER")
EndIf

if !ExistDir("\CNABS\PAGAR\")
	MakeDir("\CNABS\PAGAR")
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄØ
//³Avalia se é remessa ou retorno para apontar para o diretório correto³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄØ

If cSubCta == "001"   // Contas a receber - Remessa          
	
	if !ExistDir("\CNABS\RECEBER\OUTBOX\")
		MakeDir("\CNABS\RECEBER\OUTBOX")
	EndIf      
	              
	if !ExistDir("\CNABS\RECEBER\TEMPREM\")
		MakeDir("\CNABS\RECEBER\TEMPREM")
	EndIf                    	
	
ElseIf cSubCta == "003" // Contas a pagar - Remessa

	if !ExistDir("\CNABS\PAGAR\OUTBOX\")
		MakeDir("\CNABS\PAGAR\OUTBOX")
	EndIf      
	               
	if !ExistDir("\CNABS\PAGAR\TEMPREM\")
		MakeDir("\CNABS\PAGAR\TEMPREM")
	EndIf
	
ElseIf cSubCta == "002" // Contas a receber - Retorno
	
	if !ExistDir("\CNABS\RECEBER\INBOX\")
		MakeDir("\CNABS\RECEBER\INBOX")
	EndIf
	
ElseIf cSubCta == "004" // Contas a pagar - Retorno

	if !ExistDir("\CNABS\PAGAR\INBOX\")
		MakeDir("\CNABS\PAGAR\INBOX")
	EndIf                   
		
EndIf

If cSubCta $ "001/003" 
	cArqTemp := cArquivo //variavel publica para valorizar o ponto de entrada FIN150_3 - Guilherme 
	cArqAux	 := cCamTemp //variavel publica para valorizar o ponto de entrada FIN150_3 - Guilherme 
	cTipo	 := cSubCta  //variavel publica para valorizar o ponto de entrada FIN150_3 - Guilherme 
	cArquivo := cCamTemp + cArquivo //GUilherme 19-12-14 - Aqui ira gravar em um temporario pra garantir que sera copiado inteiro.
Else                 
	cArqTemp := cArquivo 
	cArqAux	 := cCaminho
	cTipo	 := cSubCta                                                                                               
	cArquivo := cCaminho + cArquivo		
EndIf

RestArea(aArea)
                                                             	
Return cArquivo //Retorna o temporario para processar o registro - Guilherme 19-12-14

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Função responsável por buscar o sequencial de arquivos enviados para o determinado banco³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Static Function BuscaSeq(cBanco,cAgencia,cConta,cSubCta)
Local nRet := 0

DbSelectArea("SEE")
SEE->(DbSetOrder(1))
if SEE->(DbSeek(xFilial("SEE") + cBanco + cAgencia + cConta + cSubCta))
	nRet := Val(SEE->EE_X_SEQ)+1
EndIf

Return nRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GRAVAZ49 ºAutor  ³Microsiga           º Data ³  12/03/13    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função responsável pela gravação de um registro na tabela  º±±
±±º          ³ de Arq. Cnabs Trafegados (Z49)                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*---------------------------------------------*
User Function GravaZ49(cArquivo,aEmp,cDestino)
*---------------------------------------------*  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

U_USORWMAKE(ProcName(),FunName())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄP
//³Gravação de registro de tráfego de arquivo³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄP   

DbSelectArea("Z49")
Z49->(DbSetOrder(1))
RecLock("Z49",.T.)
Z49->Z49_FILIAL := xFilial("Z49")
Z49->Z49_ARQUIV := cArquivo
Z49->Z49_BANCO 	:= aEmp[01]
Z49->Z49_AGENCI := aEmp[02]
Z49->Z49_CONTA	:= aEmp[03]
Z49->Z49_SUBCTA	:= aEmp[04]
Z49->Z49_DATA		:= dDataBase
Z49->Z49_DESTIN := cDestino
Z49->(MsUnLock())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gravação de sequencial de controle nos parâmetros de bancos.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea("SEE")
SEE->(DbSetOrder(1))
if SEE->(DbSeek(xFilial("SEE") + aEmp[01] + aEmp[02] + aEmp[03] + aEmp[04])) 
	RecLock("SEE",.F.)
	SEE->EE_X_SEQ := StrZero(Val(SEE->EE_X_SEQ)+1,TamSX3("EE_X_SEQ")[01])
	SEE->(MsUnlock())
EndIf

Return