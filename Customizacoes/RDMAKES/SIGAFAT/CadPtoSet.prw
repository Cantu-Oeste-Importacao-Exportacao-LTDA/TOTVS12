#Include "Protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"
                         
User Function OM090MNU()
aadd(aRotina,{'Gerar por Mun.','U_CadPtoSet()' , 0 , 3,0,NIL}) 

Return Nil

// Cadastro de pontos por setor (clientes que se enquadram em determinado setor)
User Function CadPtoSet()
Local oDlg
Local oGet
Local caTela := ""
Local cConsEst := ""
Local cDescSet := ""

Private cZona := Space(6)
Private cSetor := Space(6)
Private cCodMun := Space(6)
Private cUF := Space(2)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

@ 100, 100 To 340, 630 Dialog oDlg Title "Gerar Pontos por Setor por Muncípio"
@ 20, 10 SAY "Zona"
@ 20, 60 GET cZona Size 40, 10 F3 "DA6" Valid GetDescZona(@cDescSet)
@ 35, 10 SAY "Setor"
@ 35, 60 Get cSetor Size 40, 10
@ 35,100 Get cDescSet Size 100, 10 when .F.
@ 50, 10 SAY "Estado"
@ 50, 60 GET cUF PICTURE "@!" SIZE 40, 10 
@ 65, 10 Say "Muncipio" 
@ 65, 60 Get cCodMun Size 40, 10 Valid !Empty(cCodMun) F3 "CC2GER"

ACTIVATE DIALOG oDlg CENTER ON INIT ;
EnchoiceBar(oDlg,{|| GeraPtoSet(), Nil }, {|| oDlg:End() })
Return

Static Function GetDescZona(cDescSet)
Local lOk := .F.
DA6->(dbSetOrder(01))
lOk := DA6->(dbSeek(xFilial("DA6") + cZona + cSetor))
if (lOk)
  cDescSet := DA6->DA6_REF
else
	cDescSet := ""
EndIf
Return

// Função que inclui os clientes
Static Function GeraPtoSet()
Local cUltSeq

// Valida se existe a zona e o setor
DA6->(dbSetOrder(01))
if !DA6->(dbSeek(xFilial("DA6") + cZona + cSetor))
  Alert("Setor e Zona não encontrados")
  Return
EndIf

BeginSql Alias "PTOSET"
  SELECT A1_COD, A1_LOJA, A1_NREDUZ 
  FROM %TABLE:SA1% SA1
  WHERE SA1.%NOTDEL%
  	AND A1_COD_MUN = %Exp:cCodMun%
  ORDER BY A1_COD, A1_LOJA
EndSql

// AND NOT EXISTS (SELECT DA7_CLIENT FROM %TABLE:DA7% DA7 WHERE DA7_CLIENT = A1_COD AND DA7_LOJA = A1_LOJA AND DA7.%NOTDEL%)
cUltSeq := UltSeqDA7()
DA7->(dbSetOrder(02))
While PTOSET->(!Eof())
  if !DA7->(dbSeek(xFilial("DA7") + PTOSET->A1_COD + PTOSET->A1_LOJA + cZona + cSetor))
  	cUltSeq := StrZero(val(cUltSeq) + 5, 6)
  	RecLock("DA7", .T.)
  	DA7->DA7_FILIAL := xFilial("DA7")
  	DA7->DA7_PERCUR := cZona
  	DA7->DA7_ROTA := cSetor
  	DA7->DA7_SEQUEN := cUltSeq
  	DA7->DA7_CLIENT := PTOSET->A1_COD
  	DA7->DA7_LOJA := PTOSET->A1_LOJA
//  	DA7->DA7_NOME := PTOSET->A1_NREDUZ
  	DA7->(MsUnlock())
  EndIf
	PTOSET->(dbSkip())
EndDo
PTOSET->(dbCloseArea())
MsgInfo("Gerados os pontos por setor para o setor " + cSetor)
Return Nil

// Retorna  a ultima sequencia incluida em pontos por setor para determinada zona e setor
Static Function UltSeqDA7()
Local cUltSeq := "000000"
BeginSql Alias "SEQDA7"
  SELECT MAX(DA7_SEQUEN) AS DA7_SEQUEN
  FROM %TABLE:DA7% DA7
  WHERE DA7.%NOTDEL%
  	AND DA7_PERCUR = %Exp:cZona%
  	AND DA7_ROTA = %Exp:cSetor%
  ORDER BY 1
EndSql

if SEQDA7->(!Eof())
  cUltSeq := SEQDA7->DA7_SEQUEN
EndIf
SEQDA7->(dbCloseArea())
Return cUltSeq