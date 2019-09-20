#include "rwmake.ch"
#include "topconn.ch"
#include "COLORS.ch"
#include "PROTHEUS.ch"
#INCLUDE "protdef.ch"
#include "xmlxfun.ch"
#include "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RELCTB06   ºAutor  ³Regis Stucker                  15/04/10  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³RELATORIO DE CONFERENCIA NA CONTABILIDADE - Baixass a Receberº±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/*
520	Baixas a Receber Carteira
521	Baixas a Receber Cobrança Simples
522	Baixas a Receber Cobrança Descontada
523	Baixas a Receber Cobrança Caucionada
524	Baixas a Receber Cobrança Vinculada
525	Baixas a Receber Cobrança Advogado
526	Baixas a Receber Cobrança Judicial
527	Cancelamento de Baixas a Receber
528	Baixas a Receber Cobrança Caucionada Descontada
*/

User function RELCTB06()

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de baixas de Títulos a Receber "
Local cDesc3       := "não foram contabilizados ainda.                    "
Local cPict        := ""
Local titulo       := "Conferência da Contabilidade - Baixas a Receber"
Local nLin         := 80
Local Cabec1       := "Baixas de Titulos a Receber que não possuem registros na contabilidade."
Local Cabec2       := ""
Local imprime      := .T.    //1             2                    3                 4
Local nCotac       := 0
Local _VALSF3      := 0
Local _filial      := ""
Local _valsf3      := 0 // variavel para armazenar o valor da tbela se1 com serie cup
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 80
Private tamanho    := "G"
Private nomeprog   := "RELCTB06" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cPerg      := "FCTB06    "
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "CTB06" // Coloque aqui o nome do arquivo usado para impressao em disco
//Private cPathExtras  := U_NIALLXDIR( "SIGACTB", "RELCTB06" )  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajusta grupo de perguntas                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSX1()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                             ³
//³ mv_par01             // Data Inicial  ?                          ³
//³ mv_par02             // Data Final    ?                          ³
//³ MV_PAR03             // Filial de                            	 ³
//³ MV_PAR04             // Filial ate                           	 ³
//³ MV_PAR05             // Naturezas nao consideradas           	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//dDataIni	:=	mv_par01
//dDataFim	:=	mv_par02

//Filtro()

wnrel := SetPrint("SE1",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,"SE1")

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin,nCotac) },Titulo)

Return

////////////////////////////////////////////////////////////////////////////////
/**/Static Function RunReport(Cabec1,Cabec2,Titulo,nLin,nCotac)
////////////////////////////////////////////////////////////////////////////////

Local Identif   	:= " "
Local _doc      	:= "  "
Local _total    	:= 0
Local _totgeral 	:= 0
Local clientecc   	:= " "
Local lojacc      	:= " "
Local clientecd   	:= " "
Local lojacd	  	:= " "
local codcc		  	:= " "
Local codcd 	  	:= " "
Local opc         	:= 1
Local cDescNat		:= " "           
Local hEnter	  := CHR(13)                             

aCT5p :={'518','530','531','532'} //LPs Contas a Pagar
aCT5r :={'520','521','522','523','524','525','526','527','528'}//LPs Contas a Receber


/*
+--------------------------------------------------------------+
¦ Variaveis utilizadas para parametros                         ¦
+--------------------------------------------------------------+
| MV_PAR01             // Data de                              |
| MV_PAR02             // Data ate                             |
| MV_PAR03             // Filial de                            |
| MV_PAR04             // Filial ate                           |
| MV_PAR05             // Naturezas nao consideradas           |
| MV_PAR06             // Data da baixa                        |
+--------------------------------------------------------------+
*/

// Configurar: E5_MOTBX   
cQuery := ""
cQuery += " SELECT * FROM " + RetSqlName("SE5") +  " E5 													" + hEnter
cQuery += "  WHERE E5_FILIAL >= '" + MV_PAR03 + "' AND E5_FILIAL <= '" + MV_PAR04 + "' 						" + hEnter
cQuery += "    AND E5_DTDISPO BETWEEN  '" + Dtos(MV_PAR01) + "' AND '" + Dtos(MV_PAR02) + "' 				" + hEnter
cQuery += "    AND D_E_L_E_T_ <> '*'																		" + hEnter

//Pega o movimento bancario da baixa manual do RA/NCC
cQuery += "    AND ((E5_RECPAG = 'R' AND E5_TIPO <>'RA ') OR (E5_RECPAG='P' AND (E5_TIPO IN ('RA','NCC'))))	" + hEnter

If !Empty(MV_PAR05)
	cQuery += "    AND E5_NATUREZ NOT IN " + FormatIn(MV_PAR05,"/")											
EndIf

cQuery += "	   AND  E5_TIPODOC NOT IN ('DC','D2','JR','J2','TL','MT','M2','CM','C2','TR','TE','CP','LJ')	" + hEnter
cQuery += "    AND  E5_SITUACA NOT IN ('C','E','X')  														" + hEnter

//NAO CONSIDERA MOVIMENTACAO FINANCEIRA
cQuery += " AND E5_TIPODOC <> ' '																			" + hEnter
cQuery += " AND E5_NUMERO  <> ' '																			" + hEnter
cQuery += " AND E5_TIPODOC <> 'CH'																			" + hEnter
cQuery += " AND E5_MOTBX NOT IN ('FAT','LIQ')																" + hEnter

//NAO CONSIDERA BAIXA POR RECEBIMENTO DIVERSOS
cQuery += " AND E5_ORDREC = ' '																				" + hEnter

//Especifico Cliente - exclui do filtro os registros Tipo=NCC que tiveram Motivo de Baixa = CMP
cQuery += " AND  E5_FILIAL || E5_PREFIXO || E5_NUMERO || E5_PARCELA || E5_TIPO || E5_CLIFOR ||E5_LOJA || E5_SEQ || E5_RECPAG NOT IN	" + hEnter
cQuery += " 	(SELECT   E5_FILIAL || E5_PREFIXO || E5_NUMERO || E5_PARCELA || E5_TIPO || E5_CLIFOR ||E5_LOJA || E5_SEQ || E5_RECPAG FROM " + RetSqlName("SE5") +  " SE5 													" + hEnter
cQuery += "  		WHERE E5_FILIAL >= '" + MV_PAR03 + "' AND E5_FILIAL <= '" + MV_PAR04 + "' 					" + hEnter
cQuery += "    		AND E5_DTDISPO BETWEEN  '" + Dtos(MV_PAR01) + "' AND '" + Dtos(MV_PAR02) + "' 				" + hEnter
cQuery += "    		AND D_E_L_E_T_ <> '*'																		" + hEnter
cQuery += "    		AND (E5_MOTBX IN ('CMP') AND  E5_TIPO='NCC'))												" + hEnter

If MV_PAR06 = 2 //1= Conferencia 2= Nao contabilizados
	cQuery += " AND NOT EXISTS ( SELECT * FROM "  + RetSqlName("CV3") + " CV3 								" + hEnter
	cQuery += "    					WHERE D_E_L_E_T_ <> '*' 												" + hEnter
	cQuery += "    						AND CV3_RECORI = E5.R_E_C_N_O_ 										" + hEnter
	cQuery += "    						AND CV3_TABORI = 'SE5')												" + hEnter
EndIf

cQuery += "  ORDER BY E5_FILIAL,E5_DTDISPO,E5_NUMERO,E5_PREFIXO												" + hEnter

//MemoWrite( cPathExtras + procname() + ".SQL", cQuery )

TCQUERY cQuery NEW ALIAS "SE5FIL"

SE5FIL->(DbGotop())  

If MV_PAR06 = 2 //1= Conferencia 2= Nao contabilizados/*
	Cabec1       := "Baixas a Receber que não possuem registros na contabilidade."
Else
	Cabec1       := "Baixas a Receber para conferencia contábil."
EndIf

_nCount := 0
_group  := 0
_doc    := "  "   
lAchou  := .F.

If SE5FIL->(!EOF())
	
	Do While SE5FIL->(!EOF())

		lAchou  := .F.		
		
		If nLin > 59
			
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
			@nLin, 01 PSAY "REGISTROS DAS BAIXAS DOS TITULOS DO CONTAS A RECEBER"
			nLin +=1
			nLin +=1
 			@nLin, 01 PSAY "|FIL |DT.BAIXA   |DT.DISPON  |NUMERO   |PREF |PARC |CLIENTE   |LOJA |FLAG |NATUREZA                                   |VALOR         |MT BX|R/P|TIPO|LP |HISTORICO MOVIMENTO                     |"
			nLin +=1
			@nLin, 01 PSAY "+----+-----------+-----------+---------+-----+-----+----------+-----+-----+-------------------------------------------+--------------+-----+---+----+---+----------------------------------------+"
			
						 // 1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567
						 //          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19
			nLin +=1
			
		EndIf
		
		DbSelectArea("SE5")
		DbSetOrder(7)
		DbSeek(SE5FIL->E5_FILIAL + SE5FIL->E5_PREFIXO + SE5FIL->E5_NUMERO + SE5FIL->E5_PARCELA + SE5FIL->E5_TIPO + SE5FIL->E5_CLIENTE + SE5FIL->E5_LOJA)
		
		
    //Verifica se é PA/NDC, pois a baixa desses tipos gera A PAGAR
	If ALLTRIM(SE5FIL->E5_TIPO)$("PA/NDC")
    
		DbSelectArea("SE2")
		DbSetOrder(1)
		DbSeek(SE5FIL->E5_FILIAL + SE5FIL->E5_PREFIXO + SE5FIL->E5_NUMERO + SE5FIL->E5_PARCELA + SE5FIL->E5_TIPO +  SE5FIL->E5_CLIFOR + SE5FIL->E5_LOJA)
		
		While !Eof() .and.((SE2->E2_FILIAL + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA) == (SE5FIL->E5_FILIAL + SE5FIL->E5_PREFIXO + SE5FIL->E5_NUMERO + SE5FIL->E5_PARCELA + SE5FIL->E5_TIPO + SE5FIL->E5_CLIFOR + SE5FIL->E5_LOJA))
		
			lAchou := .F.
			DbSelectArea("CT5")
			DbSetOrder(1)
			
			For i:=1 to Len(aCT5p[i])
			
				DbSeek (xFilial("CT5") + aCT5p[i])
				While !Eof() .and. CT5_LANPAD == aCT5p[i]
				
					If &(CT5_VLR01)> 0 .and. CT5_STATUS <> '2'
						lAchou := .T.
					Exit
					EndIf
				
				DBSKIP()
				EndDo
			
			Next
			
			DbSelectArea("SE2")
			DBSKIP()
		
		EndDo
	
	Else

		DbSelectArea("SE1")
		DbSetOrder(2)
		DbSeek(SE5FIL->E5_FILIAL + SE5FIL->E5_CLIFOR + SE5FIL->E5_LOJA + SE5FIL->E5_PREFIXO + SE5FIL->E5_NUMERO + SE5FIL->E5_PARCELA + SE5FIL->E5_TIPO)
		
		While !Eof() .and.((SE1->E1_FILIAL + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_TIPO + SE1->E1_CLIENTE + SE1->E1_LOJA) == (SE5FIL->E5_FILIAL + SE5FIL->E5_PREFIXO + SE5FIL->E5_NUMERO + SE5FIL->E5_PARCELA + SE5FIL->E5_TIPO + SE5FIL->E5_CLIENTE + SE5FIL->E5_LOJA))
		
			lAchou := .F.
			DbSelectArea("CT5")
			DbSetOrder(1)
			
			For i:=1 to Len(aCT5r[i])

				DbSeek (xFilial("CT5") + aCT5r[i])
				While !Eof() .and. CT5_LANPAD == aCT5r[i]
				
					If &(CT5_VLR01)> 0 .and. CT5_STATUS <> '2'
						lAchou := .T.
						Exit
					EndIf
					DBSKIP()
				EndDo
			
			Next
			
			DbSelectArea("SE1")
			DBSKIP()
		EndDo

	EndIf
		If (_doc == SE5FIL->E5_FILIAL .or. _doc == "  ") .and. _nCount = 0 //.and. !(SE5FIL->E5_TIPO = 'NCC' .and. SE5FIL->E5_MOTBX='CMP')
			
		  //	If lAchou

				@nLin, 001 PSAY "|"
				@nLin, 002 PSAY SE5FIL->E5_FILIAL
				@nLin, 006 PSAY "|"
				@nLin, 007 PSAY STOD(SE5FIL->E5_DATA)  		PICTURE "@D 99/99/99"
				@nLin, 018 PSAY "|"
				@nLin, 019 PSAY STOD(SE5FIL->E5_DTDISPO)	PICTURE "@D 99/99/99"
				@nLin, 030 PSAY "|"
				@nLin, 031 PSAY SE5FIL->E5_NUMERO
				@nLin, 040 PSAY "|"
				@nLin, 041 PSAY SE5FIL->E5_PREFIXO
				@nLin, 046 PSAY "|"
				@nLin, 047 PSAY SE5FIL->E5_PARCELA
				@nLin, 052 PSAY "|"
				@nLin, 053 PSAY SE5FIL->E5_CLIFOR
				@nLin, 063 PSAY "|"
				@nLin, 064 PSAY SE5FIL->E5_LOJA
				@nLin, 069 PSAY "|"
				@nLin, 070 PSAY SE5FIL->E5_LA
				@nLin, 075 PSAY "|"
				
				If !Empty(SE5FIL->E5_NATUREZ)
					
					DbSelectArea("SED")
					DbSeek(xFilial("SED") + SE5FIL->E5_NATUREZ)
					
					cDescNat := Substr(ED_DESCRIC,1,30)
					@nLin, 076 PSAY TRIM(SE5FIL->E5_NATUREZ) + " - " + cDescNat
				
				EndIf

				@nLin, 119 PSAY "|"				
				@nLin, 120 PSAY SE5FIL->E5_VALOR     	Picture "@E 99,999,999.99"
				@nLin, 134 PSAY "|"
				@nLin, 135 PSAY SE5FIL->E5_MOTBX
				@nLin, 140 PSAY "|"
				@nLin, 141 PSAY SE5FIL->E5_RECPAG
				@nLin, 144 PSAY "|"				
				@nLin, 145 PSAY SE5FIL->E5_TIPO
				@nLin, 149 PSAY "|"								

				If lAchou
					@nLin, 150 PSAY "S"
					@nLin, 153 PSAY "|"																
				Else
					@nLin, 150 PSAY "N"
					@nLin, 153 PSAY "|"												
				EndIf
                
				@nLin, 154 PSAY SUBSTR(SE5FIL->E5_HISTOR,1,40)
				@nLin, 195 PSAY "|"			


				nLin +=1
				
				_TOTAL := _TOTAL + SE5FIL->E5_VALOR
				_totgeral :=  _totgeral + SE5FIL->E5_VALOR
				
				_doc   := SE5FIL->E5_FILIAL
				
			//EndIf
			
			SE5FIL->(DBSKIP())
			
			if SE5FIL->(EOF())
				_nCount := 1
			endif
			
			
			
		ELSE
			@nLin, 01 PSAY "+----+-----------+-----------+---------+-----+-----+----------+-----+-----+-------------------------------------------+--------------+-----+---+----+---+----------------------------------------+"
			nLin +=1
			@nLin, 001 PSAY "TOTAL "
			@nLin, 119 PSAY _TOTAL  PICTURE "@E 99,999,999.99"
			nLin +=1
			nLin +=1
			@nLin, 01 PSAY "+----+-----------+-----------+---------+-----+-----+----------+-----+-----+-------------------------------------------+--------------+-----+---+----+---+----------------------------------------+"
			nLin +=1
			_doc   :=  "  "
			_total := 0
			
		ENDIF
		
		If SE5FIL->(EOF())
			_nCount := 0
		endif
		
	Enddo
	@nLin, 01 PSAY "+----+-----------+-----------+---------+-----+-----+----------+-----+-----+-------------------------------------------+--------------+-----+---+----+---+----------------------------------------+"
	nLin +=1
	@nLin, 001 PSAY "TOTAL "
	@nLin, 119 PSAY _TOTAL  PICTURE "@E 99,999,999.99"
	nLin +=1
	nLin +=1
	@nLin, 001 PSAY "TOTAL GERAL.:"
	@nLin, 119 PSAY _TOTGERAL  PICTURE "@E 99,999,999.99"
	
	DBCloseArea("SE5FIL")
	
Else
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	@020, 050 PSAY "Nao ha dados a serem exibidos."
EndIf

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()
DBCloseArea("SE5FIL")
RETURN

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³AjustaSX1 ³ Autor ³Edstron E. Correia     ³ Data ³06/08/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Acerta o arquivo de perguntas                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AJUSTASX1()

aRegs  	:= {}  
aHelp1  := {}
aHelp2  := {}
aHelp3  := {}                                         
aHelp4	:= {}
aHelp5	:= {}
aHelp6	:= {}


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Definição dos itens do grupo de perguntas a ser criado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

AADD(aRegs,{cPerg,"01","Data digitação de     ?","Data digitação de  ?","Data digitação de  ?","mv_ch1" ,"D",08					   ,0,0,"G","","mv_par01",	  "",	  "",	  "","","",		  "",		"",		  "","","","","","","","","","","","","","","","","",   "","",   "","","@!"})
AADD(aRegs,{cPerg,"02","Data Digitação ate    ?","Data Digitação ate ?","Data Digitação ate ?","mv_ch2" ,"D",08					   ,0,0,"G","","mv_par02",	  "",	  "",	  "","","",		  "",		"",		  "","","","","","","","","","","","","","","","","",   "","",   "","","@!"})
AADD(aRegs,{cPerg,"03","Filial De             ?","Filial De          ?","Filial De          ?","mv_ch3" ,"C",TAMSX3("F1_FILIAL")[1],0,0,"G","","mv_par03",	  "",	  "",	  "","","",		  "",		"",		  "","","","","","","","","","","","","","","","","","SM0","","001","","@!"})
AADD(aRegs,{cPerg,"04","Filial Até            ?","Filial Até         ?","Filial Até         ?","mv_ch4" ,"C",TAMSX3("F1_FILIAL")[1],0,0,"G","","mv_par04",	  "",	  "",	  "","","",		  "",		"",		  "","","","","","","","","","","","","","","","","","SM0","","001","","@!"})
AADD(aRegs,{cPerg,"05","Naturezas nao consideradas","Naturezas nao consideradas","Naturezas n","mv_ch5" ,"C",99                    ,0,0,"G","","mv_par05",    		 "",           "",           "","",              "",              "",              "","","","","","","","","","","","","","","","","","",   "","",   "","","@!"})
AADD(aRegs,{cPerg,"06","Tipo do Relatório  ","Tipo do Relatório  ","Tipo do Relatório  "      ,"mv_ch6" ,"N",1                     ,0,2,"C","","mv_par06","Conferencia","Conferencia","Conferencia","","S/Contabilizar","S/Contabilizar","S/Contabilizar","","","","","","","","","","","","","","","","","",   "","",   "","","@!"})
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Montagem do Help de cada item do Grupo de Perguntas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
AADD(aHelp1 , "Data inicial considerada para filtro de    ") 
AADD(aHelp1 , "busca das movimentações no ambiente.       ") 
AADD(aHelp2 , "Data final considerada para filtro de      ") 
AADD(aHelp2 , "busca das movimentações no ambiente.       ") 
AADD(aHelp3 , "Informe a filial inicial que será          ") 
AADD(aHelp3 , "considerada na busca dos documentos.       ")             
AADD(aHelp4 , "Informe a filial final que será            ") 
AADD(aHelp4 , "considerada na busca dos documentos.       ")  
Aadd(aHelp5 , "Informe as naturezas que nao devem 		  ")
Aadd(aHelp5 , "serem consideradas. Utilize / caso 		  ")
Aadd(aHelp5 , "queira informar mais de uma natureza.	  ")
Aadd(aHelp5 , "Ex: 0000000278/0000000430 			      ")           
Aadd(aHelp6 , "Selecione (Para conferencia) para emissao  ")
Aadd(aHelp6 , "de dados para conciliar os lançamentos     ")
Aadd(aHelp6 , "contabeis. (Nao contabilizado) para verifi ")
Aadd(aHelp6 , "car o que ainda não foi contabilizado.     ")


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Cria o grupo de perguntas no SX1 conforme as definições efetuadas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
dbSelectArea("SX1")
dbSetOrder(1)
For i := 1 To Len(aRegs)
	If !dbSeek(cPerg + aRegs[i,2])
		RecLock("SX1", .T.)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j, aRegs[i,j])	 
			Endif
		Next
		MsUnlock()
	Endif
Next  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Atualiza o Help dos campos no arquivo de Help³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
PutSX1Help("P." + cPerg + "01.", aHelp1, aHelp1, aHelp1)
PutSX1Help("P." + cPerg + "02.", aHelp2, aHelp2, aHelp2)
PutSX1Help("P." + cPerg + "03.", aHelp3, aHelp3, aHelp3)
PutSX1Help("P." + cPerg + "04.", aHelp4, aHelp4, aHelp4)
PutSX1Help("P." + cPerg + "05.", aHelp5, aHelp5, aHelp5)
PutSX1Help("P." + cPerg + "06.", aHelp6, aHelp6, aHelp6)

Return	
