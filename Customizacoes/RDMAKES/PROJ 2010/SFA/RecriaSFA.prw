#INCLUDE 'ap5mail.ch'
#INCLUDE 'tbiconn.ch' 
#INCLUDE 'rwmake.ch'
#INCLUDE 'topconn.ch'

#define ENTER CHR(13)+CHR(10)

User Function RecriaSFA()
Local cArq, cArq2, cArq3
Local cTEXT  := "ATUALIZADO EM " + DtoC(DATE()) + " - " + Time() + ENTER   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//WFPREPENV("03","10","RECRIASFA") //funcao que 'loga' no sistema, baseando nos parametros passados
If Select("SX2") == 0
	RPCSetType(3)
    PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"  MODULO "CFG"
EndIf

cArq  := "\hhtrg\hgrphh.dtc"
cArq2 := "\hhtrg\hcadtbl.dtc"
cArq3 := "\hhtrg\hcadhh.dtc"
cArq4 := "\hhtrg\hcadgrp.dtc"

DbUseArea(.T.,,cArq2,"HHT",.T.)
DbSelectArea("HHT")
dbgotop()                                        

cTEXT += "[ 01 ]  ABERTO HHT" + ENTER

DbUseArea(.T.,,cArq4,"HHG",.T.)
DbSelectArea("HHG")
dbgotop()       

cTEXT += "[ 02 ]  ABERTO HHG" + ENTER

DbUseArea(.T.,,cArq3,"HHU",.T.)
DbSelectArea("HHU")
dbgotop()

cTEXT += "[ 03 ]  ABERTO HHU" + ENTER
    	
DbUseArea(.T.,,cArq,"HGU",.T.)
DbSelectArea("HGU")
dbsetorder(1)
dbgotop()                  

cTEXT += "[ 04 ]  ABERTO HGU" + ENTER

while !eof()
  nHGU := HGU->(recno())
	HHRECREATEUSER(HGU->HGU_GRUPO,HGU->HGU_SERIE,.T.,.F.)
 	sleep(120000)	 //espera 2 minutos entre um e outro
               
	DbSelectArea("HGU")     
	DbGoto(nHGU)
	DbSkip()
enddo

HHT->(DbCloseArea())
HHG->(DbCloseArea())
HHU->(DbCloseArea())
HGU->(DbCloseArea())

cTEXT += "FIM " + TIME()  + ENTER

MEMOWRIT("RECRIASFA.LOG", cTEXT)

Return nil