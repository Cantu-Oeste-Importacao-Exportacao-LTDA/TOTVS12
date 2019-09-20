/*********************************************************
 Relatório de pedidos com data de emissão maior que a data da NF.
 ******************************************************** */
 
User Function RelPedEmi()
Local nLastKey  := 0
Local cPerg 		:= PadR("PedDTEM", Len(SX1->X1_GRUPO))                                                                       

Local m_pag     :=  1         // Variavel que acumula numero da pagina
Local cAliasTmp := GetNextAlias()
Local cArq
Local cArqInd

Private aReturn   := {"Especial", 1,"Administracao", 1, 2, 1,"",1}
Private cString   := "SC7"  // nome do arquivo a ser impresso
Private tamanho   := "P"    // P(80c), M(132c),G(220c)
Private nLastKey  := 0
Private titulo    := "Rel de Ped. Dt Emi Menor Dig "
Private cDesc1    := "Este pgma fara impressao de  "
Private cDesc2    := "pedidos com data emissao mai-"
Private cDesc3    := "or que data digitacao, gpo..." 
Private cabec1    := " Cod.Pedido  Nota Serie Ped. Emissao Nota Emissao Nota Digitacao    Valor Pedido"
Private wnrel     := "RelPedD"  // nome do arquivo que sera gerado em disco
Private nomeprog  := "RelPedD"  // nome do programa que aparece no cabecalho do relatorio
Private cOrder := ""     
Private cChave := ""  
Private cWhere := ""
Private cTotal := 0
Private cTotalVlr := 0       

Private cPedAnt:= "" // Guilherme 23/04/11 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

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

If 	mv_par07 == 1          	
	cOrder := " c7_user, c7_num"
	cIndex := "c7_user+c7_num"
else
	cOrder := " b1_grupo, c7_num"
	cIndex := "b1_grupo+c7_num"
endIf         

if  mv_par08 == 1
		cWhere := "%"
		cWhere += " c7_emissao > d1_emissao and "  	
		cWhere += "%"		
else
		cWhere := "%"
		cWhere += "" 
		cWhere += "%"		
endIf		

BeginSql Alias "TMPSC7"
	select c7_num, c7_user, c7_grupcom, c7_emissao, d1_dtdigit, d1_doc, d1_serie, d1_emissao, b1_grupo, sum(c7_total) as valor
	from %table:SC7% SC7
		inner join %table:SB1% SB1 on (b1_cod = c7_produto and sb1.d_e_l_e_t_ <> '*')
		left join %table:SD1% SD1 
		on (d1_filial = c7_filial
				and d1_pedido = c7_num
				and d1_fornece = c7_fornece
				and d1_loja = c7_loja
				and d1_item = c7_item
				and d1_grupo >= %Exp:MV_PAR03%
				and d1_grupo <= %Exp:MV_PAR04%
				and sd1.d_e_l_e_t_ <> '*')
	where %Exp:cWhere%
		c7_emissao >= %Exp:MV_PAR01%
		and c7_emissao <= %Exp:MV_PAR02%
		and c7_user >= %Exp:MV_PAR05%
		and c7_user <= %Exp:MV_PAR06%
		and c7_filial = %XFilial:SC7%
		and b1_grupo >= %Exp:MV_PAR03%
		and b1_grupo <= %Exp:MV_PAR04%
		and sc7.d_e_l_e_t_ <> '*'

	group by c7_num, C7_user, c7_grupcom, c7_emissao, d1_dtdigit, d1_doc, d1_serie, d1_emissao, b1_grupo
	ORDER by %Exp:cOrder% 
EndSql

// grava as informacoes em um aquivo temporário

aStruct := TMPSC7->(dbStruct())
cArq    := CriaTrab(aStruct, .T.)
Use (cArq) Alias TMPPED Shared New                                                                             
TMPSC7->(DbGotop())
dbSelectArea("TMPPED")
While TMPSC7->(!Eof())
	RecLock("TMPPED", .T.)
	For i:= 1 to TMPSC7->(Fcount())
		// seta no aliastmp o valor obtido do alias tmpsc7, para todos os campos
		TMPPED->(FieldPut(i, TMPSC7->(FieldGet(i))))
	Next
	TMPPED->(MsUnlock())
	TMPSC7->(DbSkip())
EndDo

TMPSC7->(dbCloseArea())

cArqInd := CriaTrab(NIL, .F.)
//controla o indice da tabela temporaria
IndRegua("TMPPED", cArqInd, cIndex,,, "Selecionando Registros...")
TMPPED->(dbGoTop())


PrCabec(cabec1)

While TMPPED->(!Eof())
	if (PRow() > 58)
		Eject
		SETPRC(0,0)
		PrCabec(cabec1)                                                               
	EndIf                                                                           

	if mv_par07 == 1
		cChave := TMPPED->c7_USER
		cCabGrupo := "Comprador: " + POSICIONE("SY1",03,XFilial("SY1")+TMPPED->c7_USER,"y1_nome")
	else
		cChave := TMPPED->b1_grupo                                                               
		cCabGrupo := "Grupo: " + cChave
	endIf

	@ PRow() +1,  04 PSay cCabGrupo	
	
	while (cChave == iIf(mv_par07 == 1,TMPPED->C7_user,TMPPED->b1_grupo))
			@ PRow() + 1,   05 PSay TMPPED->c7_num
			@ PRow()    ,   12 PSay TMPPED->d1_doc
			@ PRow()    ,   22 PSay Trim(TMPPED->d1_serie)
			@ PRow()    ,   26 PSay dToc(sTod(TMPPED->c7_emissao))
			@ PRow()    ,   39 PSay dToc(sTod(TMPPED->d1_emissao))
			@ PRow()    ,   53 PSay dToc(sTod(TMPPED->d1_dtdigit))
			@ PRow()    ,   68 PSay transform(TMPPED->Valor, "@E 9,999,999.99")
		    If cPedAnt != TMPPED->c7_num 
		    	cTotal = cTotal + 1
			EndIf
			cTotalVlr = cTotalVlr + TMPPED->Valor 
			if (PRow() > 58)
				Eject
				SETPRC(0,0)
			PrCabec(cabec1)
			EndIf
			cPedAnt := TMPPED->c7_num    			  
			TMPPED->(DbSkip())                               
	enddo

	if (PRow() > 58)
		Eject
		SETPRC(0,0)
		PrCabec(cabec1)
	else
		@ PRow() + 2, 00  PSay Repl('-', 80)   
		@ PRow() + 1, 10 PSay "Total: "
		@ PRow()    , 25 PSay transform(cTotal, '@E 999,999,999.99')
		@ PRow()    , 65 PSay transform(cTotalVlr, '@E 999,999,999.99')
		@ PRow() + 1, 10 PSay ""
		cTotal := 0
		cTotalVlr := 0	
	EndIF
	
//	cChave := iIf(mv_par07 == 1,TMPPED->C7_user,TMPPED->d1_GRUPO)

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

// apaga os arquivos temporários
TMPPED->(dbCloseArea())

if File(cArqInd+OrdBagExt())
	Ferase(cArqInd+OrdBagExt()) // arquivo de indice
EndIF

If File(cArq+GetDBExtension())                              
	FErase(cArq+GetDBExtension())    //arquivo de trabalho
Endif

//RestArea(Area)
Return .T.

Static Function AjustaSX(cPerg)
PutSx1(cPerg,"01","Data Emissao Inicial ?","Data Emissao Inicial ?","Data Emissao Inicial ?", "mv_dti", "D", 10, 0, ,"G", "", "", "", "","MV_PAR01")
PutSx1(cPerg,"02","Data Emissao Final ?","Data Emissao Final ?","Data Emissao Final ?", "mv_dtf", "D", 10, 0, ,"G", "", "", "", "","MV_PAR02")
PutSx1(cPerg,"03","Grupo Inicial ?","Grupo Final ?","Grupo Final ?", "mv_gpi", "C", 06, 0, ,"G", "", "", "", "","MV_PAR03")
PutSx1(cPerg,"04","Grupo Final ?","Grupo Final ?","Grupo Final ?", "mv_gpf", "C", 06, 0, ,"G", "", "", "", "","MV_PAR04")
PutSx1(cPerg,"05","Comprador Inicial ?","Comprador Final ?","Comprador Final ?", "mv_gpi", "C", 06, 0, ,"G", "", "USR", "", "","MV_PAR05")
PutSx1(cPerg,"06","Comprador Final ?","Comprador Final ?","Comprador Final ?", "mv_gpf", "C", 06, 0, ,"G", "", "USR", "", "","MV_PAR06")
PutSx1(cPerg,"07","Agrupar por ?","Agrupar por ?","Agrupar por ?", "mv_agr", "N", 1, 0, 0,"C", "", "", "", "","MV_PAR07","Comprador","Comprador","Comprador", "","Grupo","Grupo","Grupo")
PutSx1(cPerg,"08","Data Ped Maior NF ?","Data Ped Maior NF ?","Data Ped Maior NF ?", "mv_dtp", "N", 1, 0, 0,"C", "", "", "", "","MV_PAR08","Sim","Sim","Sim", "","Nao","Nao","Nao")
Return Nil
                                                            	
Static Function PrCabec(cCabec)
	Cabec("Rel de Pedidos Data de Emissao Maior que Data Digitacao" + " Empresa: " + SM0->M0_NOME + " Filial: " + SM0->M0_FILIAL, cCabec, "", "RelPedEmi", "P", 18)
	Return NIl
	
                                                                                                                     