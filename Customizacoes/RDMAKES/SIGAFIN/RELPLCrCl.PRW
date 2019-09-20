/*********************************************************
 Relatório para verificar os limites de crédito dos clientes por faixa de percentual utilizado.
 ******************************************************** */
 
User Function RelPLCrCl()
Local nLastKey  := 0
Local cPerg 		:= PadR("PLCrCl", Len(SX1->X1_GRUPO))                                                                       

Local m_pag     :=  1         // Variavel que acumula numero da pagina
Local cAliasTmp := GetNextAlias()

Private aReturn   := {"Especial", 1,"Administracao", 1, 2, 1,"",1}
Private cString   := "SA1"  // nome do arquivo a ser impresso
Private tamanho   := "M"    // P(80c), M(132c),G(220c)
Private nLastKey  := 0
Private titulo    := "Rel de Perc. Lim. Cred. Clie "     
Private cDesc1    := "Este programa fará a impres- "
Private cDesc2    := "são de percentuais de limite "
Private cDesc3    := "de crédito utilizado.        " 
Private cabec1    := "    Cod. Cliente   Loja              Nome Cliente                                       Saldo               Limite de Credito  % Utilizado"
Private wnrel     := "PLCrCl"  // nome do arquivo que sera gerado em disco
Private nomeprog  := "PLCrCl"  // nome do programa que aparece no cabecalho do relatorio

SetPrvt("ALINHA,NLASTKEY,CABEC2")   
SetPrvt("M_PAG")

AjustaSX(cPerg)

if !Pergunte(cPerg, .T.)
	Return                                                              
	
EndIf

if nLastKey == 27
  return
endIf

wnrel := SetPrint(cString,wnrel,,titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,tamanho)

if nLastKey == 27
  return
endIf


SetDefault(aReturn,cString)
if nLastKey == 27
	return
endIf

pLimCreIn := MV_PAR04/100
pLimCreFi := MV_PAR05/100
                          	
/*cWhere := "%"
cWhere += "	(sa1.A1_LC * " + STRTRAN(TRANSFORM(MV_PAR04/100, "@E 99.99"), ",", ".") + ") <= SUM(e1_saldo) "
cWhere += " AND (sa1.A1_LC * " + STRTRAN(TRANSFORM(MV_PAR05/100, "@E 99.99"), ",", ".") + ") >= SUM(e1_saldo) "
cWhere += "%"
*/           

cWhere := "%"   

if empty(alltrim(MV_PAR01))
    cWhere +=  "se1.e1_clvlcr between '  ' AND 'ZZZZZZZZ'" 
else 
	cWhere += "se1.e1_clvlcr = MV_PAR01 "   
endif 
cWhere += "%"

BeginSql Alias cAliasTmp
	select distinct SA1.a1_cod, SA1.a1_loja, sum(se1.e1_saldo) as SALDODUP, SA1.a1_nome, sa1.a1_salpedl, sa1.a1_lc, sa3.a3_nreduz, se1.e1_vend1 as VENDEDOR   
	from %table:sa1% sa1
	inner join %table:se1% SE1 on sa1.a1_cod = se1.e1_cliente and sa1.a1_loja = se1.e1_loja    
    inner join %table:sa3% sa3 on sa3.a3_cod = se1.e1_vend1
	where %Exp:cWhere%           
    and sa3.a3_cod >=   %Exp:MV_PAR02%
    and sa3.a3_cod <=   %Exp:MV_PAR03% 
    and sa1.A1_LC <> %Exp:'0'%  
    and se1.e1_saldo <> %Exp:'0'%                              
 //	and a1_msblql <> '1' 
   	and sa1.%notdel%   
 		and	se1.%notdel%  
   	and se1.e1_tipo in %Exp:('FT', 'NF')%  
	group by SA1.a1_cod, SA1.a1_loja, SA1.a1_nome, sa1.a1_salpedl, sa1.a1_lc, sa3.a3_nreduz, se1.e1_vend1
	order by se1.e1_vend1
EndSql                                          


PrCabec(cabec1)

cChave := (cAliasTmp)->VENDEDOR
SA3->(dbSetOrder(01))

While (cAliasTmp)->(!Eof())
	if (PRow() > 58)
		Eject
		SETPRC(0,0)
		PrCabec(cabec1)
	EndIf
	// avalia o filtro motivo
	
	SA3->(dbSeek(xFilial("ZZ5") + (cAliasTmp)->VENDEDOR))
	
	@ PRow() + 1,   04 PSay "Vendedor: " + VENDEDOR
	@ PRow()    ,   25 PSay "- " + (cAliasTmp)->a3_nreduz
	
	while (cChave == (cAliasTmp)->VENDEDOR)
		pUtilizado :=((cAliasTmp)->SALDODUP  * 100) / (cAliasTmp)->A1_LC  
		@ PRow() + 1,   04 PSay (cAliasTmp)->a1_cod
		@ PRow()    ,   21 PSay (cAliasTmp)->a1_loja 
		@ PRow()    ,   37 PSay (cAliasTmp)->a1_nome   
		@ PRow()    ,   85 PSay transform((cAliasTmp)->SALDODUP, "@E 9,999,999.99")
		@ PRow()    ,   105 PSay transform((cAliasTmp)->a1_lc, "@E 9,999,999.99")
		@ PRow()    ,   125 PSay transform(pUtilizado, "@E 9999.99") + " %"  
	
		if (PRow() > 58)
			Eject
			SETPRC(0,0)
			PrCabec(cabec1)
		EndIf
		(cAliasTmp)->(DbSkip())
	enddo	
		
//total
	if (PRow() > 58)
		Eject
		SETPRC(0,0)
		PrCabec(cabec1)
	else
		@ PRow() + 1, 01 PSay ''
	EndIf
	
	cChave := (cAliasTmp)->VENDEDOR
	
	
EndDo

//    Set Device to Screen
If aReturn[5] == 1
	Set Printer To
  Commit
  ourspool(wnrel) //Chamada do Spool de Impressao
Endif
SetPrc(0,0)	
MS_FLUSH() //Libera fila de relatorios em spool
//EndIf
SetPrc(0,0)	
//RestArea(Area)
Return .T.

Static Function AjustaSX(cPerg)
PutSx1(cPerg,"01","Segmento ?","Segmento ?","Segmento ?", "mv_seg", "C", 09, 0, ,"G", "", "CTH", "", "","MV_PAR01")
PutSx1(cPerg,"02","Vendedor Inicial ?","Vendedor Inicial ?","Vendedor Inicial ?", "mv_vin", "C", 06, 0, ,"G", "", "SA3", "", "","MV_PAR02")
PutSx1(cPerg,"03","Vendedor Final ?","Vendedor Final ?","Vendedor Final ?", "mv_vfi", "C", 06, 0, ,"G", "", "SA3", "", "","MV_PAR03")
PutSx1(cPerg,"04","Percentual Inicial ?","Percentual Inicial ?","Percentual Inicial ?", "mv_pin", "N", 5, 0, ,"G", "", "", "", "","MV_PAR04")
PutSx1(cPerg,"05","Percentual Final ?","Percentual Final ?","Percentual Final ?", "mv_pfi", "N", 5, 0, ,"G", "", "", "", "","MV_PAR05")
Return Nil

Static Function PrCabec(cCabec)
Cabec("Rel de Percentual utilizado de Limite de Crédito" + " Empresa: " + SM0->M0_NOME + " Filial: " + SM0->M0_FILIAL, cCabec, "", "RelPLCRCL", "M", 18)
Return NIl

                                                                                                                     