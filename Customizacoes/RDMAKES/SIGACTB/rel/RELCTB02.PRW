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
±±ºPrograma  ³RELCTB02   ºAutor  ³REGIS STUCKER                15/04/2010  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³RELATORIO DE CONFERENCIA NA CONTABILIDADE	- NF SAIDA 		   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function RELCTB02()

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de Notas Fiscais de Saida que não foram contabiliza."
Local cDesc3       := "das.                                        "
Local cPict        := ""
Local titulo       := "Relatório para conferência da CONTABILIDADE."
Local nLin         := 80
Local Cabec1       := "Notas fiscais de Saida que não possuem registros na contabilidade."
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
Private nomeprog   := "RELCTB02" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cPerg      := "FCTB02    "
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "CTB02" // Coloque aqui o nome do arquivo usado para impressao em disco    

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
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dDataIni	:=	mv_par01
dDataFim	:=	mv_par02

//Filtro()

wnrel := SetPrint("SF2",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,"SF2")

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin,nCotac) },Titulo)

Return

////////////////////////////////////////////////////////////////////////////////
/**/Static Function RunReport(Cabec1,Cabec2,Titulo,nLin,nCotac)
////////////////////////////////////////////////////////////////////////////////

Local Identif   	:= ""
Local _doc      	:= ""
Local _total    	:= 0
Local _totgeral 	:= 0
Local clientecc   	:= ""
Local lojacc      	:= ""
Local clientecd   	:= ""
Local lojacd	  	:= ""
local codcc		  	:= ""
Local codcd 	  	:= ""
Local opc         	:= 1


/*
+--------------------------------------------------------------+
¦ Variaveis utilizadas para parametros                         ¦
+--------------------------------------------------------------+
| MV_PAR01             // Data de                              |
| MV_PAR02             // Data ate                             |
+--------------------------------------------------------------+
*/


cQuery := ""
cQuery += " SELECT * FROM " + RetSqlName("SF2") +  " F2 "
cQuery += "  WHERE F2_FILIAL >= '" + MV_PAR03 + "' AND F2_FILIAL <= '" + MV_PAR04 + "' "
cQuery += "    AND F2_EMISSAO BETWEEN  '" + Dtos(MV_PAR01) + "' AND '" + Dtos(MV_PAR02) + "' "
cQuery += "    AND D_E_L_E_T_ <> '*'"  
cQuery += "    AND F2_DTLANC = ' '"
cQuery += "    AND NOT EXISTS ( SELECT * FROM "  + RetSqlName("CV3") + " "
cQuery += "    					WHERE D_E_L_E_T_ <> '*' 				"
cQuery += "    						AND CV3_RECORI = F2.R_E_C_N_O_ "
cQuery += "    		 				AND CV3_TABORI='SF2' )
cQuery += "  ORDER BY F2_FILIAL,F2_EMISSAO,F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA"

TCQUERY cQuery NEW ALIAS "SF2FIL"

SF2FIL->(DbGotop())


_nCount := 0
_group  := 0
_doc    := ""

If SF2FIL->(!EOF())
	
	Do While SF2FIL->(!EOF())
		
		If nLin > 59
			
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
			@nLin, 01 PSAY "REGISTROS DAS NFE"
			nLin +=1
			nLin +=1
			@nLin, 01 PSAY "|FL  |EMISSÃO |NUMERO       |SERIE |CLIENTE  |LOJA |DTLANC  |NATUREZA                                   |VALOR         |"
			nLin +=1
			@nLin, 01 PSAY "+----+--------+-------------+------+---------+-----+--------+-------------------------------------------+--------------+"
			
                         // 1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567
						//           1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21
			
			nLin +=1
			
		EndIf
		
		If (_doc == SF2FIL->F2_FILIAL .or. _doc == "") .and. _nCount = 0
			
			@nLin, 001 PSAY "|"
			@nLin, 002 PSAY SF2FIL->F2_FILIAL
			@nLin, 006 PSAY "|"
			@nLin, 007 PSAY STOD(SF2FIL->F2_EMISSAO)  		PICTURE "@D 99/99/99"
			@nLin, 017 PSAY "|"
			@nLin, 018 PSAY SF2FIL->F2_DOC
			@nLin, 029 PSAY "|"
			@nLin, 030 PSAY SF2FIL->F2_SERIE
			@nLin, 036 PSAY "|"
			@nLin, 037 PSAY SF2FIL->F2_CLIENTE
			@nLin, 046 PSAY "|"
			@nLin, 047 PSAY SF2FIL->F2_LOJA
			@nLin, 052 PSAY "|"
			@nLin, 053 PSAY STOD(SF2FIL->F2_DTLANC)  		PICTURE "@D 99/99/99"
			@nLin, 061 PSAY "|"
			
			
			DbSelectArea("SE1")
			DbSetOrder(2)
			If	DbSeek(SF2FIL->F2_FILIAL + SF2FIL->F2_CLIENTE + SF2FIL->F2_LOJA + SF2FIL->F2_SERIE + SF2FIL->F2_DOC   )
				
				cNaturez := SE1->E1_NATUREZ
				DbSelectArea("SED")
				If DbSeek(SF2FIL->F2_FILIAL + cNaturez)
					
					cDescNat := Substr(ED_DESCRIC,1,30)
					@nLin, 062 PSAY TRIM(cNaturez) + " - " + cDescNat
					@nLin, 105 PSAY "|"
					
				EndIf
			Else
				@nLin, 062 PSAY space(40)
				@nLin, 105 PSAY "|"
			EndIf
			
			@nLin, 106 PSAY SF2FIL->F2_VALBRUT     	Picture "@E 99,999,999.99"
			@nLin, 120 PSAY "|"
			
			nLin +=1
			
			_TOTAL := _TOTAL + SF2FIL->F2_VALBRUT
			_totgeral :=  _totgeral + SF2FIL->F2_VALBRUT
			
			_doc   := SF2FIL->F2_FILIAL
			
			SF2FIL->(DBSKIP())
			
			if SF2FIL->(EOF())
				_nCount := 1
			endif
			
			
			
		ELSE
			@nLin, 01 PSAY  "+-------+--------+----------+------+---------+-----+--------+-------------------------------------------+--------------+"
			nLin +=1
			@nLin, 001 PSAY "TOTAL "
			@nLin, 105 PSAY _TOTAL  PICTURE "@E 99,999,999.99"
			nLin +=1
			nLin +=1
			@nLin, 01 PSAY "+-------+--------+----------+------+---------+-----+--------+-------------------------------------------+--------------+"
			nLin +=1
			_doc   :=  ""
			_total := 0
			
		ENDIF
		
		If SF2FIL->(EOF())
			_nCount := 0
		endif
		
	Enddo
	@nLin, 01 PSAY "+-------+--------+----------+------+---------+-----+--------+-------------------------------------------+--------------+"
	nLin +=1
	@nLin, 001 PSAY "TOTAL "
	@nLin, 105 PSAY _TOTAL  PICTURE "@E 99,999,999.99"
	nLin +=1
	nLin +=1
	@nLin, 001 PSAY "TOTAL GERAL.:"
	@nLin, 015 PSAY _TOTGERAL  PICTURE "@E 99,999,999.99"
	
	
	
	DBCloseArea("SF2FIL")
	
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


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Definição dos itens do grupo de perguntas a ser criado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

AADD(aRegs,{cPerg,"01","Data digitação de     ?","Data digitação de  ?","Data digitação de  ?","mv_ch1" ,"D",08					   ,0,0,"G","","mv_par01",	  "",	  "",	  "","","",		  "",		"",		  "","","","","","","","","","","","","","","","","",   "","",   "","","@!"})
AADD(aRegs,{cPerg,"02","Data Digitação ate    ?","Data Digitação ate ?","Data Digitação ate ?","mv_ch2" ,"D",08					   ,0,0,"G","","mv_par02",	  "",	  "",	  "","","",		  "",		"",		  "","","","","","","","","","","","","","","","","",   "","",   "","","@!"})
AADD(aRegs,{cPerg,"03","Filial De             ?","Filial De          ?","Filial De          ?","mv_ch3" ,"C",TAMSX3("F1_FILIAL")[1],0,0,"G","","mv_par03",	  "",	  "",	  "","","",		  "",		"",		  "","","","","","","","","","","","","","","","","","SM0","","001","","@!"})
AADD(aRegs,{cPerg,"04","Filial Até            ?","Filial Até         ?","Filial Até         ?","mv_ch4" ,"C",TAMSX3("F1_FILIAL")[1],0,0,"G","","mv_par04",	  "",	  "",	  "","","",		  "",		"",		  "","","","","","","","","","","","","","","","","","SM0","","001","","@!"})

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


Return
