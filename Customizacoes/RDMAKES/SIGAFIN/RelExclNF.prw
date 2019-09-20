/*********************************************************
 Relatório de indicados para acompanhamento de exclusões de nota.
 ******************************************************** */
 
User Function RelExclNF()
Local nLastKey  := 0
Local cPerg 		:= PadR("EXCLNF", Len(SX1->X1_GRUPO))                                                                       

Local m_pag     :=  1         // Variavel que acumula numero da pagina
Local cAliasTmp := GetNextAlias()
Local cChaveCli := ""
Local cProd     := ""
Local totgrupo  := 0
Local totgeral  := 0

Private aReturn   := {"Especial", 1,"Administracao", 1, 2, 1,"",1}
Private cString   := "SZT"  // nome do arquivo a ser impresso
Private tamanho   := "M"    // P(80c), M(132c),G(220c)
Private nLastKey  := 0
Private titulo    := "Rel de Exclusão de Documentos"
Private cDesc1    := "Este programa fará a impres- "
Private cDesc2    := "são de indicadosres de exclu-"
Private cDesc3    := "são de documentos            " 
Private cabec1    := "          Usuário                Qtde Solicitações           Tipo de Documento"
Private wnrel     := "EXCLNF"  // nome do arquivo que sera gerado em disco
Private nomeprog  := "EXCLNF"  // nome do programa que aparece no cabecalho do relatorio

SetPrvt("ALINHA,NLASTKEY,CABEC2")   
SetPrvt("M_PAG")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

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

If	MV_PAR06 == 1
	PARPAR06 := 'Entrada'
else
	PARPAR06 := 'Saida'
endif				

BeginSql Alias cAliasTmp
	select count(*) as qtdsol, zt_usuario, zt_motexcl, zt_tpnf
	from %table:SZT% SZT
	where d_e_l_e_t_ = ' '
	and zt_usuario >= %Exp:MV_PAR01%
	and zt_usuario <= %Exp:MV_PAR02%
	and zt_dtsol >= %Exp:MV_PAR03%
	and zt_dtsol <= %Exp:MV_PAR04%
	and zt_filial = %XFilial:SZT% 
	and zt_tpnf = %Exp:PARPAR06%
  	group by zt_usuario, zt_motexcl, zt_tpnf
	order by zt_motexcl
EndSql

PrCabec(cabec1)

if (cAliasTmp)->(!Eof())
	@ PRow() + 1, 97	 PSay "Filtro:  De: " + dtoc(MV_PAR03) + " Até: " + dtoc(MV_PAR04)
endIf

cChave := (cAliasTmp)->ZT_MOTEXCL

While (cAliasTmp)->(!Eof())
	if  !(upper(alltrim(MV_PAR05)) $ upper((cAliasTmp)->ZT_MOTEXCL)) .and.;
		!Empty(alltrim(MV_PAR05)) 				
		(cAliasTmp)->(dbskip())          
		cChave := ''
		Loop
	else
		cChave := (cAliasTmp)->ZT_MOTEXCL
	EndIf
	
	if (PRow() > 58)
		Eject
		SETPRC(0,0)
		PrCabec(cabec1)
	EndIf
	// avalia o filtro motivo

	@ PRow() + 1,   04 PSay "Motivo da Solicitação: " + (cAliasTmp)->ZT_MOTEXCL  
	
	while (cChave == (cAliasTmp)->ZT_MOTEXCL)		
		@ PRow() + 1,   10 PSay (cAliasTmp)->ZT_USUARIO  
		@ PRow()    ,   36 PSay (cAliasTmp)->qtdsol Picture '@E 999,999,999.99'
		@ PRow()    ,   61 PSay (cAliasTmp)->ZT_TPNF
		totgrupo := totgrupo + qtdsol                
		totgeral := totgeral + qtdsol
		if (PRow() > 58)
			Eject
			SETPRC(0,0)
			PrCabec(cabec1)
		EndIf
		(cAliasTmp)->(DbSkip())
	enddo	           
	
	if (PRow() > 58)
		Eject
		SETPRC(0,0)
		PrCabec(cabec1)
	else
		@ PRow() + 2, 00  PSay Repl('-', 132)   
		@ PRow() + 1, 10 PSay "Total por Motivo de Solicitação: " + transform(totgrupo, '@E 999,999,999.99')
		@ PRow() + 1, 10 PSay ""
		totgrupo := 0
	EndIf	
	
	If LastKey()==286 // ALT + A
		@ PRow(),00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif                            
	
	cChave := (cAliasTmp)->ZT_MOTEXCL	
EndDo   

@ PRow() + 2, 00  PSay Repl('-', 132)   
@ PRow() + 1, 04 PSay "Total Geral: " + transform(totgeral, "999,999")
//@ PRow() + 1, 00  PSay Repl('-', 132)   

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
PutSx1(cPerg,"01","Usuario Inicial ?","Usuario Inicial ?","Usuario Inicial ?", "mv_uin", "C", 15, 0, ,"G", "", "", "", "","MV_PAR01")
PutSx1(cPerg,"02","Usuario Final ?","Usuario Final ?","Usuario Final ?", "mv_ufi", "C", 15, 0, ,"G", "", "", "", "","MV_PAR02")
PutSx1(cPerg,"03","Data Inicial ?","Data Inicial ?","Data Inicial ?", "mv_din", "D", 8, 0, ,"G", "", "", "", "","MV_PAR03")
PutSx1(cPerg,"04","Data Final ?","Data Final ?","Data Final ?", "mv_dfi", "D", 8, 0, ,"G", "", "", "", "","MV_PAR04")
PutSx1(cPerg,"05","Motivo ?","Motivo ?","Motivo ?", "mv_mot", "C", 30, 0, ,"G", "", "", "", "","MV_PAR05")
PutSx1(cPerg,"06","Tipo de documento ?","Tipo de documento ?","Tipo de documento ?", "mv_tpd", "C", 15, 0, ,"C", "", "", "", "","MV_PAR06","Entrada","","",,"Saida","","",,"","")
Return Nil

Static Function PrCabec(cCabec)
Cabec("Rel de Exclusão de Documentos" + " Empresa: " + SM0->M0_NOME + " Filial: " + SM0->M0_FILIAL, cCabec, "", "RelExclNF", "M", 18)
/*@ 00, 00 PSay AvalImp(132) // seta o tamanho do relatório
@ PRow()    ,          00 PSay Repli('-', 132)
@ PRow() + 1,          00 PSay cCabec
@ PRow() + 1,          00 PSay Repli('-', 132)*/
Return NIl

