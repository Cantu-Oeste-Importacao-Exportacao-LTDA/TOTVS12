/*********************************************************
 Relatório de indicados para acompanhamento de exclusões de nota.
 ******************************************************** */
 
User Function RelVlrSUM()
Local nLastKey  := 0
Local cPerg 		:= PadR("VLRSUM", Len(SX1->X1_GRUPO))                                                                       

Local m_pag     :=  1         // Variavel que acumula numero da pagina
Local cAliasTmp := GetNextAlias()
Local cChaveCli := ""
Local cProd     := ""
Local totgrupo  := 0
Local totgeral  := 0

Private aReturn   := {"Especial", 1,"Administracao", 1, 2, 1,"",1}
Private cString   := "SB2"  // nome do arquivo a ser impresso
Private tamanho   := "M"    // P(80c), M(132c),G(220c)
Private nLastKey  := 0
Private titulo    := "Rel de Custos Segunda UM"
Private cDesc1    := "Este programa fará a impres- "
Private cDesc2    := "são do relatório de custos p/"
Private cDesc3    := "segunda unidade de medida.   "                                                                                      
Private cabec1    := "    Cod     Grupo    Descrição                          UM       Qtde Atual         Vlr 1ª Uni        Qtde 2ª Uni       Vlr 2ª Uni"
Private wnrel     := "CUSSUM"  // nome do arquivo que sera gerado em disco
Private nomeprog  := "CUSSUM"  // nome do programa que aparece no cabecalho do relatorio

SetPrvt("ALINHA,NLASTKEY,CABEC2")   
SetPrvt("M_PAG")

AjustaSX(cPerg)   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

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

BeginSql Alias cAliasTmp
	select b2_cod, b1_desc, b1_UM, b2_qatu, b2_cm1, b2_qtsegum, b1_grupo, b1_locpad
	from %table:SB2% SB2, %table:SB1% SB1
	where sb2.d_e_l_e_t_ = ' '
	and   sb1.d_e_l_e_t_ = ' '   
	and b1_cod = b2_cod
	and b1_locpad >= %Exp:MV_PAR01%
	and B1_locpad <= %Exp:MV_PAR02%
	and b1_cod >= %Exp:MV_PAR03%
	and b1_cod <= %Exp:MV_PAR04%
	and b1_grupo >= %Exp:MV_PAR05%
	and b1_grupo <= %Exp:MV_PAR06%
	and b2_filial = %XFilial:SZT%
	order by b1_cod
EndSql

PrCabec(cabec1)

While (cAliasTmp)->(!Eof())
	if (PRow() > 58)
		Eject
		SETPRC(0,0)
		PrCabec(cabec1)
	EndIf
	// avalia o filtro motivo

	custoseg := ((cAliasTmp)->b2_qatu / (cAliasTmp)->b2_qtsegum) * (cAliasTmp)->b2_cm1
	
	@ PRow() + 1,   04 PSay (cAliasTmp)->B2_cod
	@ PRow()    ,   14 PSay (cAliasTmp)->b1_grupo 
 	@ PRow()    ,   22 PSay (cAliasTmp)->b1_desc
 	@ PRow()    ,   57 PSay (cAliasTmp)->b1_um
 	@ PRow()    ,   62 PSay (cAliasTmp)->b2_qatu Picture '@E 999,999,999.99'
 	@ PRow()    ,   81 PSay (cAliasTmp)->b2_cm1 Picture '@E 999,999,999.99'
	@ PRow()    ,   100 PSay (cAliasTmp)->b2_qtsegum Picture '@E 999,999,999.99'
	@ PRow()    ,   117 PSay custoseg Picture '@E 999,999,999.99'

	(cAliasTmp)->(DbSkip())
	
	If LastKey()==286 // ALT + A
		@ PRow(),00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif                            
	
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
  	PutSx1(cPerg,"01","Do Armazem ?","Do Armazem ?","Do Armazem ?", "mv_ari", "C", 02, 0, ,"G", "", "", "", "","MV_PAR01")
  	PutSx1(cPerg,"02","Ate o Armazem ?","Ate o Armazem ?","Ate o Armazem ?", "mv_arf", "C", 02, 0, ,"G", "", "", "", "","MV_PAR02")  
  	PutSx1(cPerg,"03","Do Produto ?","Do Produto ?","Do Produto ?", "mv_pri", "C", 15, 0, ,"G", "", "", "", "","MV_PAR03")
  	PutSx1(cPerg,"04","Ate o Produto ?","Ate o Produto ?","Ate o Produto ?", "mv_prf", "C", 15, 0, ,"G", "", "", "", "","MV_PAR04")
  	PutSx1(cPerg,"05","Do Grupo ?","Do Grupo ?","Do Grupo ?", "mv_gpi", "C", 04, 0, ,"G", "", "", "", "","MV_PAR05")
  	PutSx1(cPerg,"06","Ate o Grupo ?","Ate o Grupo ?","Ate o Grupo ?", "mv_gpf", "C", 04, 0, ,"G", "", "", "", "","MV_PAR06")
Return Nil

Static Function PrCabec(cCabec)
Cabec("Rel de Custos" + " Empresa: " + SM0->M0_NOME + " Filial: " + SM0->M0_FILIAL, cCabec, "", "RelVlrSUM", "M", 18)
Return NIl