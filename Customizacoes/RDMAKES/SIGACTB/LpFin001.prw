#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LPFIN001  ºAutor  ³Guilherme Poyer     º Data ³  12/03/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Pega o valor de Juros e multas do título                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Cantu                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LpFin001()
nTot = 0

DbSelectArea("SE2")
SE2->(DbSetOrder(1))
//If SE2->(DbSeek(cFil+cPrf+cNum+cPcl+cTip+cCli+cLoj))
If SE2->(DbSeek(xFilial("SE2")+SEZ->EZ_PREFIXO+SEZ->EZ_NUM+SEZ->EZ_PARCELA+SEZ->EZ_TIPO+SEZ->EZ_CLIFOR+SEZ->EZ_LOJA))
  
	if SEZ->EZ_IDENT == "2"
		nTot := ((SE2->E2_MULTA + SE2->E2_JUROS)*SEZ->EZ_PERC)
	EndIf

EndIf

Return(nTot)       
                         
           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LPFIN003  ºAutor  ³Edison G. Barbieri  º Data ³  22/12/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Pega o valor de Juros e multas do título GPE                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Cantu                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LpFin005()
nTtl = 0

DbSelectArea("SE2")
SE2->(DbSetOrder(1))
//If SE2->(DbSeek(cFil+cPrf+cNum+cPcl+cTip+cCli+cLoj))
If SE2->(DbSeek(xFilial("SE2")+SEZ->EZ_PREFIXO+SEZ->EZ_NUM+SEZ->EZ_PARCELA+SEZ->EZ_TIPO+SEZ->EZ_CLIFOR+SEZ->EZ_LOJA))
  
	if SEZ->EZ_IDENT == "1"
		nTtl := SE2->E2_MULTA + SE2->E2_JUROS
	EndIf

EndIf

Return(nTtl)     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LPFIN003  ºAutor  ³Edison G. Barbieri  º Data ³  22/12/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Pega o valor de Juros e multas do título GPE                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Cantu                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LpFin006()

Local nVlr 		:= CVALTOCHAR(SEZ->EZ_VALOR)
Local hEnter	:= CHR(10) + CHR(13) 
Local cAlias 	:= GetNextAlias()
  

cQuery := ""
cQuery += "SELECT EZ_VALOR FROM " + RetSqlName("SEZ") 				         + hEnter  
cQuery += "WHERE EZ_FILIAL = '" +xFilial("SEZ")  +"'                        "+ hEnter
cQuery += "  AND EZ_IDENT  = '1'                                            "+ hEnter
cQuery += "  AND EZ_SEQ  = ' '                                              "+ hEnter
cQuery += "  AND EZ_NUM  =     '"+SE5->E5_NUMERO+"' "			    		 + hEnter
cQuery += "  AND EZ_PARCELA  = '"+SE5->E5_PARCELA+"' "                       + hEnter
cQuery += "  AND EZ_PREFIXO  = '"+SE5->E5_PREFIXO+"' "                       + hEnter
cQuery += "  AND EZ_TIPO  =    '"+SE5->E5_TIPO+"' "                          + hEnter
cQuery += "  AND EZ_CLIFOR  =  '"+SE5->E5_CLIFOR+"' "                        + hEnter
cQuery += "  AND EZ_LOJA  =    '"+SE5->E5_LOJA+"' "                          + hEnter
cQuery += "  AND EZ_CCUSTO  =  '"+SEZ->EZ_CCUSTO+"' "                        + hEnter
cQuery += "  AND EZ_CLVL  =    '"+SEZ->EZ_CLVL+"' "                          + hEnter
cQuery += "  AND D_E_L_E_T_  = ' '       


TCQUERY cQuery NEW ALIAS (cAlias)


    nVlr := (cAlias)->EZ_VALOR
 
 
Return (nVlr)  



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LPFIN003  ºAutor  ³Edison G. Barbieri  º Data ³  22/12/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Pega o valor de Juros e multas do título GPE                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Cantu                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LpFin007()

Local nVl 		:= CVALTOCHAR(SE5->E5_VLDESCO)
Local hEnter	:= CHR(10) + CHR(13) 
Local cAlias 	:= GetNextAlias()
  

cQuery := ""
cQuery += "SELECT E5_VLDESCO FROM " + RetSqlName("SE5") 				     + hEnter  
cQuery += "WHERE E5_FILIAL = '" +xFilial("SE5")  +"'                        "+ hEnter
cQuery += "  AND E5_NUMERO  =  '"+SE2->E2_NUM+"' "  			    		 + hEnter
cQuery += "  AND E5_PARCELA  = '"+SE2->E2_PARCELA+"' "                       + hEnter
cQuery += "  AND E5_PREFIXO  = '"+SE2->E2_PREFIXO+"' "                       + hEnter
cQuery += "  AND E5_TIPO  =    '"+SE2->E2_TIPO+"' "                          + hEnter
cQuery += "  AND E5_CLIFOR  =  '"+SE2->E2_FORNECE+"' "                       + hEnter
cQuery += "  AND E5_LOJA  =    '"+SE2->E2_LOJA+"' "                          + hEnter
cQuery += "  AND D_E_L_E_T_  = ' '       


TCQUERY cQuery NEW ALIAS (cAlias)


    nVl := (cAlias)->E5_VLDESCO
 
 
Return (nVl)  




