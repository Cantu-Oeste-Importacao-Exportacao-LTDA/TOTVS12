#INCLUDE "rwmake.ch"
#INCLUDE "vkey.ch"
#include "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BolVer   บ Autor ณ Adriano Novachaelley Data ณ  23/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Programa utilizado para modificar automaticamente as       บฑฑ
ฑฑบ          ณ prioridades para a impressaใo dos boletos bancarios.       บฑฑ
ฑฑบ          ณ Quando um banco atinge sua garantia ele ้ alterado         บฑฑ
ฑฑบ          ณ automaticamente para prioridade '9'                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Dpto Financeiro Cantu                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function BolVer()
_aBanco	:= {}
cEmps := GetMV("MV_X_EMGAR")
aEmps := &cEmps  // Transforma a string em array multidimensional
cSql := "("                   

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

For nR := 1 To Len(aEmps)
	// Busco os codigos das empresas que estใo vinculadas a um romaneio de carga.
	cSql += "SELECT '"+AllTrim(aEmps[nR,1])+"' A6_EMP,A6.A6_COD,A6.A6_AGENCIA,A6.A6_NREDUZ,A6.A6_NUMCON,Sum(A6.A6_X_VLGAR) A6_X_VLGAR, "
	cSql += "Coalesce((SELECT Sum(E1.E1_SALDO) FROM "+"SE1"+AllTrim(aEmps[nR,1])+"0"+" E1 "
	cSql += "WHERE E1.E1_FILIAL BETWEEN '  ' AND 'ZZ' AND E1.D_E_L_E_T_ <> '*' AND "
	cSql += "E1.E1_SALDO > 0 AND E1.E1_NUMBCO <> ' ' AND "
	cSql += "E1.E1_NUMBOR = ' ' AND E1.E1_PORTADO = A6.A6_COD AND "
	cSql += "E1.E1_AGEDEP = A6.A6_AGENCIA AND E1.E1_CONTA = A6.A6_NUMCON AND "
	cSql += "E1.E1_EMISSAO > '20110101'),0) E1_SALDO "
	cSql += "FROM "+"SA6"+AllTrim(aEmps[nR,1])+"0"+" A6 "
	cSql += "WHERE A6.D_E_L_E_T_ <> '*' AND A6.A6_X_VLGAR > 0 " 
	cSql += "GROUP BY A6.A6_COD, A6.A6_AGENCIA, A6.A6_NREDUZ, A6.A6_NUMCON "
	if nR != len(aEmps)
		cSql += " UNION ALL "
	Else
		cSql += " ) "
	EndIf	
Next nR
//	MemoWrite("c:\boletos.txt",cSql)	
TCQUERY cSql NEW ALIAS "TMPSA6"
TMPSA6->(dbSelectArea("TMPSA6"))
TMPSA6->(dbGoTop())
//	{ {"01", "01", "98"}, {"02", "01", "98"}}
If !TMPSA6->(Eof())
	While !TMPSA6->(Eof())
		If TMPSA6->E1_SALDO > TMPSA6->A6_X_VLGAR
			_cEmpAtu	:= SM0->(GetArea())
			SM0->(DbSelectArea("SM0"))
			SM0->(DbSetOrder(1))
			SM0->(DbGotop())
			If SM0->(DbSeek(TMPSA6->A6_EMP))
				aAdd(_aBanco,{TMPSA6->A6_EMP,SM0->M0_CODFIL,TMPSA6->A6_COD,TMPSA6->A6_AGENCIA,TMPSA6->A6_NUMCON})
			Endif
			SM0->(RestArea(_cEmpAtu))
		Endif
		TMPSA6->(DbSelectArea("TMPSA6"))							
		TMPSA6->(DbSkip())
	End
	If Len(_aBanco) > 0
//		U_BolVerB(_aBanco)
		StartJob("U_BolVerB",GetEnvServer(),.T.,_aBanco)
	Endif
	TMPSA6->(DbCloseArea("TMPSA6"))
Else
	If Select("TMPSA6") <> 0
		TMPSA6->(DbCloseArea("TMPSA6"))
	Endif
Endif

Return


User Function BolVerB(_aBanco)
Local nX 			:= 1
Local _nItem		:= "1"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

RPCSetType(3)
RpcSetEnv(_aBanco[nX, 1], _aBanco[nX, 2],,,"FAT")
If Len(_aBanco) > 0

	// Ordena o aCols para que seja rแpida a troca de environment por empresa e filal e seja trocado somente uma vez para cada
	aCols := aSort(_aBanco,,, {|X,Y| (X[1]+X[2]) < (Y[1]+Y[2])})
	
	// Faz a grava็ใo dos dados
	// alimenta a variavel com os dados da filial atual
	cEmpFil := cEmpAnt + cFilAnt //aCols[1, 1] + aCols[1, 2]
	For nX := 1 to len(_aBanco)
	  	// posiciona na empresa correta antes de iniciar a altera็ใo
		If (cEmpFil != (AllTrim(_aBanco[nX, 1]) + AllTrim(_aBanco[nX, 2])))
			RpcClearEnv()
			RPCSetType(3)
		
			RpcSetEnv(_aBanco[nX, 1], _aBanco[nX, 2],,,,GetEnvServer())
		EndIf
		
		cEmpFil := AllTrim(_aBanco[nX, 1]) + AllTrim(_aBanco[nX, 2]) // Grava a posi็ใo atual
		
		ZZN->(DbSelectArea("ZZN"))
		ZZN->(DbSetOrder(1))
		ZZN->(DbGotop())
		If ZZN->(DbSeek(xFilial("ZZN")+_aBanco[nX,3]+_aBanco[nX,4]+_aBanco[nX,5]))
			ZZN->(RecLock("ZZN", .F.))
		  		ZZN->ZZN_PRIORI := '9'
			ZZN->(MsUnlock())
		Endif
	
	
	Next nX
Endif

RpcClearEnv()

Return