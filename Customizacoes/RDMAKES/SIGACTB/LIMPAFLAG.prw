#include "PROTHEUS.CH"
#include "RWMAKE.CH"  
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LIMPAFLAG ºAutor  ³Jean                º Data ³  26/03/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Essa rotina tem como finalidade auxiliar os contadores     º±±
±±º          ³ a limpar o flag de contabilização quando o LP não 
±±º          ³ estiver correto.                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Contabilidade Gerencial                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LimpaFlag()
Local oAtualiza
Local oBanco
Local oCboRecPag
Local oCboSimNao
Local oDataFim
Local oDataIni
Local oFechar
Local oFilial
Local oGroup1
Local oLbBanco
Local oLbDataDe
Local oLbFilial
Local oMotBx
Local oSay1, oSay2, oSay3, oSay4, oSay5
Local oTipoTit
Local Nx             := 0
Static oDlgLimpa
Private oGet1              
Private lAtualiza    := .F.
Private dDataFim     := Date()  
Private dDataIni     := Date()
Private cBanco       := Space(3)
Private nCboRecPag   := "R"
Private nCboSimNao   := "N"
Private cFil         := Space(2) 
Private cTipoTit     := Space(3)       
Private cMotBx       := Space(20)
Private aHeaderEx    := {}
Private aColsEx      := {}
Private aAlterFields := {}
Private aFieldFill   := {}
Private aFields      := {"E5_FILIAL", "E5_LA", "E5_DTDISPO", "E5_TIPO", "E5_CLIFOR", "E5_LOJA",; 
												 "E5_PREFIXO", "E5_NUMERO", "E5_PARCELA", "E5_VALOR", "E5_RECPAG", "E5_BANCO", "E5_MOTBX", "R_E_C_N_O_"}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
             
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Pega as configurações de campos do SX3 e atribui para o array aHeaderEx³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea("SX3")
SX3->(DbSetOrder(2))
for Nx := 1 to len(aFields)
	if DbSeek(aFields[Nx])
		Aadd(aHeaderEx, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
	EndIf 
	if aFields[Nx] == "R_E_C_N_O_"
		Aadd(aHeaderEx, {"RecNo","R_E_C_N_O_","@E 999999",6,0})
	EndIf
Next Nx
                                                                 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ(¿
//³Inicialização de Variáveis.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ(Ù
DbSelectArea("SM0")
cMotBx   := "CMT,DAC,FAT,LIQ,DSD"
cFil     := SM0->M0_CODFIL
cTipoTit := "CH "
                 

  DEFINE MSDIALOG oDlgLimpa TITLE "Limpar Flag Contabilização E5" FROM 000, 000  TO 600, 700 COLORS 0, 16777215 PIXEL

	oGet1 := MsNewGetDados():New(100, 001, 299, 350, GD_INSERT + GD_DELETE + GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "",; 
					 aAlterFields, 0, Len(aColsEx), "AllwaysTrue",, "AllwaysTrue", oDlgLimpa, aHeaderEx, aColsEx)	
	oGet1:oBrowse:Refresh()    

    @ 041, 277 BUTTON oConsulta PROMPT "Consultar" WHEN !lAtualiza ACTION RptStatus({|lEnd| Consulta(@lEnd) },;
    									"Aguarde...","Consultando Informações...", .T.) SIZE 067, 014 OF oDlgLimpa PIXEL
    @ 061, 277 BUTTON oAtualiza PROMPT "Atualizar" WHEN lAtualiza  ACTION RptStatus({|lEnd| Atualiza(@lEnd) },;
    									"Aguarde...","Atualizando Informações...", .T.) SIZE 067, 014 OF oDlgLimpa PIXEL
    @ 081, 277 BUTTON oFechar   PROMPT "Fechar"    ACTION oDlgLimpa:End() SIZE 067, 014 OF oDlgLimpa PIXEL
    
    @ 008, 032 MSGET oFilial  VAR cFil     SIZE 020, 010 OF oDlgLimpa COLORS 0, 16777215 PIXEL ON CHANGE (lAtualiza := .F.)
    @ 023, 032 MSGET oDataIni VAR dDataIni SIZE 060, 010 OF oDlgLimpa COLORS 0, 16777215 PIXEL ON CHANGE (lAtualiza := .F.)
    @ 023, 108 MSGET oDataFim VAR dDataFim SIZE 060, 010 OF oDlgLimpa COLORS 0, 16777215 PIXEL ON CHANGE (lAtualiza := .F.)
    @ 037, 032 MSGET oTipoTit VAR cTipoTit SIZE 026, 010 OF oDlgLimpa COLORS 0, 16777215 PIXEL ON CHANGE (lAtualiza := .F.)
    @ 066, 032 MSGET oBanco   VAR cBanco   SIZE 020, 010 OF oDlgLimpa COLORS 0, 16777215 PIXEL ON CHANGE (lAtualiza := .F.)
    @ 081, 032 MSGET oMotBx   VAR cMotBx   SIZE 110, 010 OF oDlgLimpa COLORS 0, 16777215 PIXEL ON CHANGE (lAtualiza := .F.)
            
    @ 009, 017 SAY oLbFilial PROMPT "Filial:"      SIZE 014, 007 OF oDlgLimpa COLORS 0, 16777215 PIXEL
    @ 024, 007 SAY oLbDataDe PROMPT "Data De:"     SIZE 025, 007 OF oDlgLimpa COLORS 0, 16777215 PIXEL
    @ 025, 095 SAY oSay1     PROMPT "Até: "        SIZE 012, 007 OF oDlgLimpa COLORS 0, 16777215 PIXEL
    @ 039, 017 SAY oSay2     PROMPT "Tipo:"        SIZE 015, 007 OF oDlgLimpa COLORS 0, 16777215 PIXEL
    @ 053, 005 SAY oSay3     PROMPT "Rec/Pag:"     SIZE 025, 007 OF oDlgLimpa COLORS 0, 16777215 PIXEL
    @ 068, 012 SAY oLbBanco  PROMPT "Banco:"       SIZE 019, 007 OF oDlgLimpa COLORS 0, 16777215 PIXEL
    @ 083, 006 SAY oSay4     PROMPT "Descons:"     SIZE 025, 007 OF oDlgLimpa COLORS 0, 16777215 PIXEL 
    @ 024, 238 SAY oSay5     PROMPT "Marcar Como:" SIZE 033, 007 OF oDlgLimpa COLORS 0, 16777215 PIXEL
    
    @ 052, 032 MSCOMBOBOX oCboRecPag VAR nCboRecPag ITEMS {"R=Receber","P=Pagar"}                   SIZE 072, 010 OF oDlgLimpa COLORS 0,;
    											16777215 ON CHANGE (lAtualiza := .F.) PIXEL 
    @ 023, 273 MSCOMBOBOX oCboSimNao VAR nCboSimNao ITEMS {"S=Contabilizado","N=Não Contabilizado"} SIZE 072, 010 OF oDlgLimpa COLORS 0,; 
    											16777215 ON CHANGE (lAtualiza := .F.) PIXEL

  ACTIVATE MSDIALOG oDlgLimpa CENTERED

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que fará a consulta de acordo com os parâmetros informados.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
          
Static Function Consulta(lRet)
Local cSql    := ""
Local cMotTmp := ""
Local cEol    := CHR(13)+CHR(10)
Local nCount  := 0

aFieldFill := {}
cMotTmp    := MntMotTmp(cMotBx)

cSql := "SELECT E5.E5_FILIAL, E5_LA, E5.E5_DTDISPO, E5.E5_TIPO, E5_CLIFOR, E5_LOJA, E5_PREFIXO, " +cEol
cSql += "       E5_NUMERO, E5_PARCELA, E5.E5_RECPAG, E5.E5_BANCO, E5.E5_MOTBX, "                  +cEol
cSql +=	"       E5.E5_VALOR, E5.R_E_C_N_O_ FROM " +retSqlName("SE5")+ " E5 "                      +cEol
cSql += "WHERE E5.E5_DTDISPO BETWEEN '"+DtoS(dDataIni)+"' AND '"+DtoS(dDataFim)+"' "              +cEol
cSql += "  AND E5.E5_TIPO   = '"+ cTipoTit   +"' "                                                +cEol

if nCboSimNao == "S"
	cSql += "  AND E5.E5_LA     = ' ' "                                                             +cEol
else
	cSql += "  AND E5.E5_LA     = 'S' "                                                             +cEol
EndIf

cSql += "  AND E5.E5_RECPAG = '"+ nCboRecPag +"' "                                                +cEol
cSql += "  AND E5.E5_FILIAL = '"+ cFil       +"' "                                                +cEol
cSql += "  AND E5.E5_BANCO  = '"+ cBanco     +"' "                                                +cEol
cSql += "  AND E5.D_E_L_E_T_ <> '*' "                                                             +cEol
cSql += "  AND E5.E5_MOTBX NOT IN ("+ cMotTmp +") "                                               +cEol

TCQUERY cSql NEW ALIAS "SE5TMP"

DbSelectArea("SE5TMP")
SE5TMP->(DbGotop())
Count to nCount
SE5TMP->(DbGoTop())

if !(nCount > 0)
	SE5TMP->(DbCloseArea())
	Return nil
EndIf       

SetRegua(nCount)
While !SE5TMP->(EOF())
	IncRegua()
	Aadd(aFieldFill, {E5_FILIAL,;
										E5_LA,;
										E5_DTDISPO,;
										E5_TIPO,;   
										E5_CLIFOR,;
										E5_LOJA,;
										E5_PREFIXO,;
										E5_NUMERO,;
										E5_PARCELA,;
										E5_VALOR,;
										E5_RECPAG,;
										E5_BANCO,;
										E5_MOTBX,;
										R_E_C_N_O_,;
										.F.})
	SE5TMP->(DbSkip())
EndDo

SE5TMP->(DbCloseArea())
aColsEx     := aClone(aFieldFill)
oGet1:aCols := aClone(aColsEx)
oGet1:ForceRefresh()
lAtualiza := .T.

Return .T.


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que fará a atualização das informações selecionadas pela função de consulta.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function Atualiza(lEnd)
Local i := 0
Local aColsTmp   := oGet1:aCols
Local aHeaderTmp := oGet1:aHeader
Local nPosRec    := 0
Local nAlter     := 0

nPosRec := aScan(aHeaderTmp, {|x| AllTrim(x[2]) == "R_E_C_N_O_"})

SetRegua(len(aColsTmp))

for i := 1 to len(aColsTmp)
  IncRegua()
  
	DbSelectArea("SE5")
	DbGoTo(aColsTmp[i, nPosRec])
	RecLock("SE5", .F.)
	if nCboSimNao == "S"
		SE5->E5_LA := "S"
	else
		SE5->E5_LA := " "
	EndIf
	SE5->(MsUnlock())

	nAlter++
Next i

aFieldFill  := {}
aColsEx     := aClone(aFieldFill)
oGet1:aCols := aClone(aColsEx)
oGet1:ForceRefresh()

lAtualiza := .F.

MsgInfo(AllTrim(Str(nAlter))+" registros alterados...")
	
Return .T.                  



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que faz a montagem da string dos Motivos de Baixa para usar no comando SQL³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function MntMotTmp(cMotBx)
Local cMotTmp := ""
Local tmp     := ""
Local cMot    := cMotBx

for i := 1 to len(AllTrim(cMot))
  
  // Verifica se o caractere é numérico ou alfabético 
  if IsAlpha(SubStr(cMot, 1, 1)) .or. IsDigit(SubStr(cMot, 1, 1))
  	
  	tmp += SubStr(cMot, 1, 1)
  	
  	cMot := SubStr(cMot, 2, len(AllTrim(cMot)))  	
  Else

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄalor¿
		//³Se não era um caractere válido, o sistema encontrou um separador. Nessa hora, ele descarrega o valor³
		//³armazenado na variável temporária tmp.                                                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄalorÙ
    
  	if Empty(cMotTmp) 
	  	cMotTmp := "'" + tmp + "'"
  	Else
  		cMotTmp += ",'" + tmp + "'"
  	EndIf
  	tmp  := ""
  	cMot := SubStr(cMot, 2, len(AllTrim(cMot)))
  EndIf
Next   

// Grava o último valor da variável tmp depois de sair do loop.
if !Empty(tmp)
 	if Empty(cMotTmp)
  	cMotTmp := "'" + tmp + "'"
 	Else
 		cMotTmp += ",'" + tmp + "'"
 	EndIf
 	tmp := ""
EndIf                                           

Return cMotTmp