
User Function MT103DEV()
Local cQuery    := " "
Local dData_De  := PARAMIXB[1]
Local dData_Ate := PARAMIXB[2]
Local nDiasDev  := SuperGetMv("MV_DIASDEV",,60) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

cquery := "SELECT * "
cquery += "FROM " + RetSqlName("SF2") + " "
cquery += "WHERE F2_FILIAL  = '" + xFilial("SF2") + "' "
cquery += "AND F2_TIPO <> 'D' "
cquery += "AND F2_CLIENTE = '" + cCliente + "' "
cquery += "AND F2_LOJA    = '" + cLoja    + "' "
cQuery += "AND F2_EMISSAO BETWEEN '" + DtoS(dData_De) + "' AND '" + DtoS(dData_Ate) + "' "
cQuery += "AND F2_EMISSAO >= '" + DtoS(dDataBase - nDiasDev) + "' "
cquery += "AND D_E_L_E_T_ = ' ' "
cquery += " AND F2_FRETE > 0 "
 
Return (cQuery)