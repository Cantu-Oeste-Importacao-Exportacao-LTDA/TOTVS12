#include "rwmake.ch" 
#include "topconn.ch" 


//-- RELATORIO NOVO - PAISAGEM Dioni 03/10/11
*----------------------
User Function RCPRES()
*----------------------
Private cPerg       := "RCPRES"

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,TITULO,CABEC1,CABEC2")
SetPrvt("CCANCEL,M_PAG,WNREL")
SetPrvt("PROD,TRANSP,DATAPED,ACHOU,GRUPO,CFILIAL") 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

cString  := ""
cDesc1   := OemToAnsi("Este programa tem como objetivo a impressao do")
cDesc2   := OemToAnsi("relatorio de Crédito Presumido.")
cDesc3   := ""                             
Tamanho  := "G"
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
NomeProg := "RCPRES"  
aLinha   := {}
nLastKey := 0
Titulo   := "Crédito Presumido - Relação de Créditos Presumidos"
		//   123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
		//            10       20        30        40        50        60        70        80        90        00        10        20        30        40        50        60        70        80        90        00        10
Cabec1   := "FILIAL          SERIE/NF                COD.FISCAL        CLIENTE/LOJA            UF          EMISSAO                       CRD PRES PR                            CRD PRES PR                          SEGMENTO              
                                                                           
Cabec2   := ""
cCancel  := "***** Cancelado Pelo Operador *****"
Achou    := .F.
Grupo    := ""
m_Pag    := 1                      //Variavel que acumula numero da pagina
WnRel    := "RPRTAB"               //Nome Default do relatorio em Disco

//AjustaPerg(cPerg)
AjustaSX1()

Pergunte(cPerg,.f.)
wnrel := SetPrint(cString,NomeProg,cPerg,Titulo, cDesc1, cDesc2, cDesc3, .F., "",, Tamanho)     

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn, cString)                                                                 

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

RptStatus({|| ImpRel() }, "Relação de Crédito Presumido...")

Ms_Flush()                 //Libera fila de relatorios em spool

If aReturn[5] == 1
   Set Printer To
   OurSpool(WnRel)         //Chamada do Spool de Impressao                                  
Endif
Return

Static Function ImpRel()
Local cQuery := " "
Local nLin   := 8
Local _UltSegm := ""

Cabec(titulo, cabec1, cabec2, NomeProg, Tamanho, 18)

cQuery := "SELECT F3.F3_FILIAL,F3.F3_SERIE,F3.F3_NFISCAL,F3.F3_CFO, "
cQuery += "F3.F3_CLIEFOR,F3.F3_LOJA,F3.F3_ESTADO,F3.F3_CRPREPR,F3.F3_CRDPRES, " 
cQuery += "F3.F3_CRPREPE,F3.F3_CPRESPR,F3.F3_CRPRESP, "
cQuery += "F3.F3_CRPREPE,F3.F3_CRDPRES, F3.F3_EMISSAO, " 
cQuery += "D2.D2_DOC,D2.D2_SERIE,D2.D2_CLVL, "
cQuery += "SUM(F3.F3_CRPREPR+F3.F3_CPRESPR) AS TOTAL "
cQuery += "FROM " +RetSQLName("SF3")+" F3 "
cQuery += "LEFT JOIN " +RetSQLName("SD2")+" D2 ON D2.D2_DOC = F3.F3_NFISCAL AND D2.D2_SERIE = F3.F3_SERIE "
cQuery += "WHERE F3.F3_CFO >= '5' AND "
cQuery += "F3_FILIAL BETWEEN '" + mv_par01 + "' AND '" + MV_PAR02 + "' AND D2.D2_CLVL BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' AND "
cQuery += "F3_EMISSAO BETWEEN '" + dToS(mv_par05) + "' AND '" + dToS(mv_par06) + "'
cQuery += "AND D2.D_E_L_E_T_ <> '*' AND F3.D_E_L_E_T_ <> '*' " 
cQuery += "GROUP BY F3.F3_FILIAL,F3.F3_SERIE,F3.F3_NFISCAL,F3.F3_CFO, F3.F3_CLIEFOR,F3.F3_LOJA,F3.F3_ESTADO,F3.F3_CRPREPR,F3.F3_CRDPRES, "
cQuery += "F3.F3_CRPREPE,F3.F3_CPRESPR,F3.F3_CRPRESP, F3.F3_CRPREPE,F3.F3_CRDPRES, F3.F3_EMISSAO, D2.D2_DOC,D2.D2_SERIE,D2.D2_CLVL "
cQuery += "UNION "
cQuery += "SELECT F3.F3_FILIAL,F3.F3_SERIE,F3.F3_NFISCAL,F3.F3_CFO, "
cQuery += "F3.F3_CLIEFOR,F3.F3_LOJA,F3.F3_ESTADO,F3.F3_CRPREPR,F3.F3_CRDPRES, "
cQuery += "F3.F3_CRPREPE,F3.F3_CPRESPR,F3.F3_CRPRESP, "
cQuery += "F3.F3_CRPREPE,F3.F3_CRDPRES, F3.F3_EMISSAO, "               
cQuery += "D1.D1_DOC,D1.D1_SERIE,D1.D1_CLVL, "
cQuery += "SUM(F3.F3_CRPREPR+F3.F3_CPRESPR) AS TOTAL "
cQuery += "FROM " +RetSQLName("SF3")+" F3 "
cQuery += "LEFT JOIN " +RetSQLName("SD1")+" D1 ON D1.D1_DOC = F3.F3_NFISCAL AND D1.D1_SERIE = F3.F3_SERIE "
cQuery += "WHERE F3.F3_CFO < '5' AND "
cQuery += "F3_FILIAL BETWEEN '" + mv_par01 + "' AND '" + MV_PAR02 + "' AND D1.D1_CLVL BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' AND "
cQuery += "F3_EMISSAO BETWEEN '" + dToS(mv_par05) + "' AND '" + dToS(mv_par06) + "' 
cQuery += "AND D1.D_E_L_E_T_ <> '*' AND F3.D_E_L_E_T_ <> '*' " 
cQuery += "GROUP BY F3.F3_FILIAL,F3.F3_SERIE,F3.F3_NFISCAL,F3.F3_CFO, F3.F3_CLIEFOR,F3.F3_LOJA,F3.F3_ESTADO,F3.F3_CRPREPR,F3.F3_CRDPRES, "
cQuery += "F3.F3_CRPREPE,F3.F3_CPRESPR,F3.F3_CRPRESP, F3.F3_CRPREPE,F3.F3_CRDPRES, F3.F3_EMISSAO, D1.D1_DOC,D1.D1_SERIE,D1.D1_CLVL "
cQuery += "ORDER BY 18 "  //ordena por segmento que está na posiçao 18
                              
//Memowrite("c:\rel_CreditoPresumido.txt",cQuery)	
TCQUERY cQuery NEW ALIAS "TMP" // "TMPCPRES"

//aStruc := dbStruct()
//cArqTemp := CriaTrab(aStruc)
//dbUseArea( .T. ,, cArqTemp , "TMP" ) 
//APPEND FROM TMPCPRES
//DbSelectArea("TMP")  
//TMPCPRES->(DbCloseArea())

TMP->(DbSelectArea("TMP")) 
//TMP->(DbGotop())
SetRegua( RecCount())

TotPr1    := 0
TotPr2    := 0
TotCred   := 0
TotDeb    := 0
TotCrdPre := 0 

While !TMP->(Eof())
  if TMP->TOTAL <> 0       
      
     _cFilial	  := TMP->F3_FILIAL
	   _cSerie	  := TMP->F3_SERIE
	   _cNFiscal	:= TMP->F3_NFISCAL
	   _cCfo     	:= TMP->F3_CFO 
	   _cCliFor 	:= TMP->F3_CLIEFOR 
     _cLoja   	:= TMP->F3_LOJA 
	   _cEst   	  := TMP->F3_ESTADO 
	   _cEmissao 	:= dToc(sTod(TMP->F3_EMISSAO))
	   _cCrepr  	:= TMP->F3_CRPREPR	
	   _cCrpe     := TMP->F3_CRPREPE
	   _cCespr    := TMP->F3_CPRESPR
	   _cCrpsp    := TMP->F3_CRPRESP
	   _cClvl     := TMP->D2_CLVL
	  
   If nLin > 60
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
      nLin := 8
   Endif 
     //Gera o total ao mudar o nro do segmento 
   if ((_UltSegm <> "") .and. (_UltSegm <> TMP->D2_CLVL)) 
     
       @nLin, 0 Psay;                
"----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
       @nLin := nLin + 1
       @nLin, 0 Psay "Total do Segmento: "+_UltSegm 
       @nLin, 123 Psay TotPr1 Picture "@E 9,999,999.99"
       @nLin, 162 Psay TotPr2 Picture "@E 9,999,999.99"    
       //Total do Crédito 
       @nLin := nLin + 1
       @nLin, 0 Psay "Total Crédito: "
       @nLin, 16 Psay TotCred Picture "@E 9,999,999.99"    
       //Total do Débito
       @nLin := nLin + 1  
       @nLin, 0 Psay "Total Débito: "
       @nLin, 16 Psay TotDeb Picture "@E 9,999,999.99"
              
       TotCrdPre := TotCrdPre + TotDeb
       
       //zerar variáveis antes de começar novo segmento
       TotPr1  := 0
       TotPr2  := 0 
       TotCred := 0
       TotDeb  := 0
      
       nLin := nLin + 2
       
   endif    
                      
 	  	@nLin, 000 Psay _cFilial
	  	@nLin, 016 Psay _cSerie+"/"+_cNFiscal
	  	@nLin, 040 Psay _cCfo 
	  	@nLin, 058 Psay _cCliFor+"/"+_cLoja
		  @nLin, 082 Psay _cEst     
		  @nLin, 094 Psay _cEmissao	
		  @nLin, 123 Psay _cCrepr Picture "@E 9,999,999.99"	     									
   	  @nLin, 162 Psay _cCespr Picture "@E 9,999,999.99"
  		@nLin, 199 Psay _cClvl  

      TotPr1 := TotPr1 + TMP->F3_CRPREPR 
      TotPr2 := TotPr2 + TMP->F3_CPRESPR
      _UltSegm := TMP->D2_CLVL
                                    
      //Total do Crédito
      if TMP->F3_CFO < '5' 
        TotCred := TotCred + (TMP->F3_CRPREPR + TMP->F3_CPRESPR)  
      endif 
      //Total do Débito
      if TMP->F3_CFO >= '5'
        TotDeb := TotDeb + (TMP->F3_CRPREPR + TMP->F3_CPRESPR)  
      endif    

	    IncRegua()
		  nLin += 1           
 	endif
    TMP->(dbSkip())  
Enddo 
       
     //Total Credido presumido, q é a soma de todos os débitos
       TotCrdPre := TotCrdPre + TotDeb 
      
     //Gera o Total no final do segmento relatório
       @nLin, 0 Psay;
"----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
       @nLin := nLin + 1
       @nLin, 0 Psay "Total do Segmento: "+_UltSegm 
       @nLin, 123 Psay TotPr1 Picture "@E 9,999,999.99"
       @nLin, 162 Psay TotPr2 Picture "@E 9,999,999.99"  
     //Total do Crédito 
       @nLin := nLin + 1
       @nLin, 0 Psay "Total Crédito: "
       @nLin, 16 Psay TotCred Picture "@E 9,999,999.99"    
     //Total do Débito
       @nLin := nLin + 1  
       @nLin, 0 Psay "Total Débito: "
       @nLin, 16 Psay TotDeb Picture "@E 9,999,999.99"
     //Total do Crédito Presumido
       @nLin := nLin + 2
       @nLin, 0 Psay "Total Crédito Presumido: "
       @nLin, 20 Psay TotCrdPre Picture "@E 9,999,999.99"
               
TMP->(dbCloseArea())
Return   
                                                          
Static Function AjustaSX1()
PutSx1(cPerg,"01","Filial de ?","Filial de ?","Filial de ?", "mv_ch1", "C", 06, 0, ,"G", "", "", "", "","MV_PAR01")
PutSx1(cPerg,"02","Filial ate ?","Filial ate ?","Filial ate ?", "mv_ch2", "C", 06, 0, ,"G", "", "", "", "","MV_PAR02")
PutSx1(cPerg,"03","Segmento de ?","Segmento de ?","Segmento de ?","mv_ch3","C",09,0, ,"G","","", "", "","mv_par03")
PutSx1(cPerg,"04","Segmento ate ?","Segmento ate ?","Segmento ate ?","mv_ch4","C",09,0, ,"G","","", "", "","mv_par04")
PutSx1(cPerg,"05","Emissao De ?","Emissao De ?","Emissao De ?","mv_ch5","D",10,0, ,"G", "", "", "", "","MV_PAR05")
PutSx1(cPerg,"06","Emissao Ate ?","Emissao Ate ?","Emissao Ate ?","mv_ch6","D",10,0, ,"G", "", "", "", "","MV_PAR06")

Return