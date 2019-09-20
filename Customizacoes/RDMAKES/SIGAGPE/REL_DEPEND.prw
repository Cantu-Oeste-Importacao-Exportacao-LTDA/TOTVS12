#include "rwmake.ch" 
#include "topconn.ch" 

// -- RALATORIO DE DEPENDENTES - CHAMADO 371
//-- RELATORIO NOVO - PAISAGEM Dioni 10/12/11
*----------------------                  
User Function RDEPEND()
*----------------------          
                                    
Private cPerg       := "RDEPEND"

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
cDesc2   := OemToAnsi("relatorio de Dependentes.")
cDesc3   := ""                             
Tamanho  := "P"
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
NomeProg := "RDEPEND"  
aLinha   := {}
nLastKey := 0
Titulo   := "Dependentes - Relação de Dependendes"
		//   123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
		//            10       20        30        40        50        60        70        80        90        00        10        20        30        40        50        60        70        80        90        00        10
Cabec1   := "FILIAL            DEPENDENTE                           GRAU PARENT.        IDADE                  
                                                                           
Cabec2   := ""
cCancel  := "***** Cancelado Pelo Operador *****"          
Achou    := .F.
Grupo    := ""
m_Pag    := 1                      //Variavel que acumula numero da pagina
WnRel    := "RDEPEND"               //Nome Default do relatorio em Disco

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

RptStatus({|| ImpRel() }, "Relação de Dependentes...")

Ms_Flush()                 //Libera fila de relatorios em spool

If aReturn[5] == 1
   Set Printer To
   OurSpool(WnRel)         //Chamada do Spool de Impressao                                  
Endif
Return
                          		
Static Function ImpRel()
Local cQuery := " "
Local nLin   := 8 
Local cData := DtoS(Date())
Local nDtnas    
Local nIdade
Local _UltFunc := ""

Cabec(titulo, cabec1, cabec2, NomeProg, Tamanho, 18)
              
cQuery := "SELECT SRA.RA_NOME, SRA.RA_CC, SRB.RB_NOME, SRB.RB_DTNASC, SRB.RB_FILIAL, SRB.RB_GRAUPAR "
cQuery += "FROM " +RetSQLName("SRB")+" SRB "
cQuery += "LEFT JOIN " +RetSQLName("SRA")+" SRA ON SRA.RA_MAT = SRB.RB_MAT AND "
cQuery += "SRB.RB_FILIAL = SRA.RA_FILIAL "
cQuery += "WHERE SRA.D_E_L_E_T_ <> '*' AND "
cQuery += "SRB.RB_FILIAL BETWEEN '" + mv_par01 + "' AND '" + MV_PAR02 + "' AND SRA.RA_CC BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "
cQuery += "AND SRB.D_E_L_E_T_ <> '*' AND SRA.RA_DEMISSA = ' ' "     
cQuery += "ORDER BY SRA.RA_NOME "

//Memowrite("c:\rel_Dependentes.txt",cQuery)	

TCQUERY cQuery NEW ALIAS "TMP" 


TMP->(DbSelectArea("TMP")) 
SetRegua( RecCount())
                                  
nDtnas := (Val(SubStr(TMP->RB_DTNASC,1,4)))
nIdade := (Val(SubStr(cData,1,4))-nDtnas)  //calcula a idade do dependente

//iniciando com o mestre
_UltFunc := TMP->RA_NOME
if (_UltFunc <> "")
   @nLin, 0 Psay ""
   nLin := nLin + 1
   @nLin, 0 Psay "Dependentes do Funcionário: "+_UltFunc 
   nLin := nLin + 1 
endif    
     

While !TMP->(Eof())    
     
     nDtnas := ""
     nIdade := ""
               
     nDtnas := (Val(SubStr(TMP->RB_DTNASC,1,4)))
     nIdade := (Val(SubStr(cData,1,4))-nDtnas)  //calcula a idade do dependente  
     
     //tranformar o grau de parentesco
     if TMP->RB_GRAUPAR = "C"
        _cGrauPa := "Cônjuge/Companheiro"
     elseif TMP->RB_GRAUPAR = "F"
        _cGrauPa := "Filho"
     elseif TMP->RB_GRAUPAR = "E"
        _cGrauPa := "Enteado"
     elseif TMP->RB_GRAUPAR = "P"
        _cGrauPa := "Pai/Mãe"
     elseif TMP->RB_GRAUPAR = "O"
        _cGrauPa := "Agregado/Outros"                        
     endif 
     
     _cFilial	  := TMP->RB_FILIAL
	   _cFunc 	  := TMP->RA_NOME
	   _cDepend 	:= TMP->RB_NOME 
	  // _cGrauPa   := //TMP->RB_GRAUPAR
	   _cIdade    := nIdade 
	   
   If nLin > 58
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
      nLin := 8
   Endif 
     //Gera o total ao mudar o nro do segmento 
   if ((_UltFunc <> "") .and. (_UltFunc <> TMP->RA_NOME)) 
       @nLin, 0 Psay ""
       nLin := nLin + 1
       @nLin, 0 Psay "Dependentes do Funcionário: "+_cFunc 
       nLin := nLin + 1
   endif    
                      
 	  	@nLin, 000 Psay _cFilial
	  	@nLin, 017 Psay _cDepend
	  	@nLin, 055 Psay _cGrauPa
	  	@nLin, 075 Psay _cIdade 
       
      _UltFunc := TMP->RA_NOME         
	    IncRegua()
		  nLin += 1           
    TMP->(dbSkip())  
Enddo 
                      
TMP->(dbCloseArea())
Return   
    
                                                          
Static Function AjustaSX1()
PutSx1(cPerg,"01","Filial de ?","Filial de ?","Filial de ?", "mv_ch1", "C", 06, 0, ,"G", "", "", "", "","MV_PAR01")
PutSx1(cPerg,"02","Filial ate ?","Filial ate ?","Filial ate ?", "mv_ch2", "C", 06, 0, ,"G", "", "", "", "","MV_PAR02")
PutSx1(cPerg,"03","C.Custo de ?","C.Custo de ?","C.Custo de ?","mv_ch3","C",09,0, ,"G","","", "", "","mv_par03")
PutSx1(cPerg,"04","C.Custo ate ?","C.Custo ate ?","C.Custo ate ?","mv_ch4","C",09,0, ,"G","","", "", "","mv_par04")

Return