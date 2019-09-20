#include "rwmake.ch" 
#include "topconn.ch" 

// -- RALATORIO DAS INFORMAÇÕES ADICIONAIS DOS FUNCIONÁRIOS - CHAMADO 440
//-- RELATORIO NOVO - PAISAGEM Dioni 15/12/11
*----------------------                  
User Function RINFFUNC()
*----------------------          
                                    
Private cPerg       := "RINFFUNC"   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,TITULO,CABEC1,CABEC2")
SetPrvt("CCANCEL,M_PAG,WNREL")
SetPrvt("PROD,TRANSP,DATAPED,ACHOU,GRUPO,CFILIAL")

cString  := ""
cDesc1   := OemToAnsi("Este programa tem como objetivo a impressao do")
cDesc2   := OemToAnsi("relatorio das informações adicionais dos Funcionários.")
cDesc3   := ""                             
Tamanho  := "P"
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
NomeProg := "RINFFUNC"  
aLinha   := {}
nLastKey := 0
Titulo   := "Funcionários - Informações Adicionais"
		//   123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
		//            10       20        30        40        50        60        70        80        90        00        10        20        30        40        50        60        70        80        90        00        10
Cabec1   :=''// "FILIAL            FUNCIONÁRIO                           INFORMAÇÕES ADICIONAIS                  
                                                                           
Cabec2   := ""
cCancel  := "***** Cancelado Pelo Operador *****"          
Achou    := .F.
Grupo    := ""
m_Pag    := 1                      //Variavel que acumula numero da pagina        
WnRel    := "RINFFUNC"               //Nome Default do relatorio em Disco

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

RptStatus({|| ImpRel() }, "Inf. Adicionais dos funcionários...")

Ms_Flush()                 //Libera fila de relatorios em spool

If aReturn[5] == 1
   Set Printer To
   OurSpool(WnRel)         //Chamada do Spool de Impressao                                  
Endif
Return
                          		
Static Function ImpRel()   
Local cQuery := " "
Local nLin   := 8 
Local oPrint   

Cabec(titulo, cabec1, cabec2, NomeProg, Tamanho, 18)
              
cQuery := "SELECT ZA2.R_E_C_N_O_ , ZA2.ZA2_FILIAL, ZA2.ZA2_FUNC, ZA2.ZA2_INFORM, SRA.RA_NOME "
cQuery += "FROM " +RetSQLName("ZA2")+" ZA2 "    
cQuery += "LEFT JOIN " +RetSQLName("SRA")+" SRA ON SRA.RA_MAT = ZA2.ZA2_FUNC "
cQuery += "WHERE SRA.RA_FILIAL BETWEEN '" + mv_par01 + "' AND '" + MV_PAR02 + "' "
cQuery += "AND ZA2.D_E_L_E_T_ <> '*' AND SRA.D_E_L_E_T_ <> '*' "     
cQuery += "ORDER BY SRA.RA_NOME "

//Memowrite("c:\rel_InfFunc.txt",cQuery)	

TCQUERY cQuery NEW ALIAS "TMP" 

TMP->(DbSelectArea("TMP")) 
TMP->(dbGoTop()) 

SetRegua( RecCount())

While !TMP->(Eof())    
   ZA2->(dbGoto( TMP->R_E_C_N_O_ )) 
      
   _cFilial	  := TMP->ZA2_FILIAL
	 _cFunc 	  := (AllTrim((TMP->ZA2_FUNC))+ (AllTrim('-')) + (AllTrim(TMP->RA_NOME)))  
   _cInfFunc  := ZA2->ZA2_INFORM  
   
   If nLin > 58
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
      nLin := 8
   Endif
   
   //Dioni 19/12/11
   //faz a quebra de linha do campo Memo para imprimir no relatório.
   // MlCount() -> conta quantas linhas com até 70 caracteres o campo memo possui.
   //Memoline() -> le e retorna a linha com ate 70 caracteres dentro do loop.
 	  @nLin, 000 Psay "Informações Adicionais do Funcionário "+_cFunc
	  nLin+=2          
		For nXi := 1 To MLCount(_cInfFunc,70)
		  If nLin > 58
         Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
         nLin := 8
      Endif
		     If ! Empty(MLCount(_cInfFunc,70))
		          If ! Empty(MemoLine(_cInfFunc,70,nXi))
		               @nLin, 00 Psay (MemoLine(_cInfFunc,70,nXi)) 
		               nLin+=1
		          EndIf
		     EndIf
		Next nXi  
	  @nLin, 000 Psay "-----------------------------------------------------------------------------"
	  nLin+=1   
	    IncRegua()
		  nLin += 1           
    TMP->(dbSkip())  
Enddo 
                      
TMP->(dbCloseArea())
Return       
                                                          
Static Function AjustaSX1()
PutSx1(cPerg,"01","Filial de ?","Filial de ?","Filial de ?", "mv_ch1", "C", 06, 0, ,"G", "", "", "", "","MV_PAR01")
PutSx1(cPerg,"02","Filial ate ?","Filial ate ?","Filial ate ?", "mv_ch2", "C", 06, 0, ,"G", "", "", "", "","MV_PAR02")    

Return