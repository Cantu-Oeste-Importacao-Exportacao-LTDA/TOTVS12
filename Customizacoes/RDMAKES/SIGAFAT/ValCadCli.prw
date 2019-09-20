#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

User Function ValCadCli(cCnpjCpf, cIE, cUF)
Local oWSCfg    := WSSPEDADM():New()
Local oWSNFe    := WSNFESBRA():New()
Local oItens    := NFESBRA_ARRAYOFNFECONSULTACONTRIBUINTE():New()
Local oResult   := {"", "", "", "", ""} // IE, Cod. Municipio, Endereço, Bairro, Cep
Local cCnpj := ""
Local cCpf := ""
Local cUserToken := "TOTVS"
Local cIdent := "000001"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

if (Len(AllTrim(cCnpjCpf)) = 14)
	cCnpj := cCnpjCpf
else
	cCpf := cCnpjCpf
EndIf
// obtém o id da empresa
oWSCfg:Reset()
// chama o webservice e recebe o retorno
If oWSCfg:GETADMEMPRESASID(cUSERTOKEN, SM0->M0_CGC,"", SM0->M0_INSC, SM0->M0_ESTCOB)
	cIdent := oWSCfg:cGETADMEMPRESASIDRESULT
EndIf

if !Empty(cIdent)
	oWSNFe:Reset()
	if oWSNFe:CONSULTACONTRIBUINTE(cUSERTOKEN,cIdent,cUF,cCnpj,cCpf,cIE) 
		oItens := oWsNFe:oWSCONSULTACONTRIBUINTERESULT
	EndIf
	if !Empty(oItens)
		oResult := oItens[1]
	EndIf
EndIf

Return oResult