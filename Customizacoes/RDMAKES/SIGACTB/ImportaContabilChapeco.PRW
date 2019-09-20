#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/06/02
#INCLUDE "TOPCONN.CH"

User Function CONTABIL()  

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿎hama fun豫o para monitor uso de fontes customizados�
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
U_USORWMAKE(ProcName(),FunName())

SetPrvt("cCodCME,NSEQ")

//-----------------------------------------------------------------------------
//Descricao -  Programa para importacao do arquivo TXT                        |
//----------------------------------------------------------------------------|
//Uso       -  Interpretador xBase                                            |
//-----------------------------------------------------------------------------

//Abre Area                                                   �
SET DEVICE TO SCREEN

_NomeArq  := "\contaoeste"
MV_PAR01  := DDATABASE  //"01/01/2002"
MV_PAR02  := DDATABASE  //"05/01/2002"
MV_PAR03  := "   "
MV_PAR04  := "ZZZ"


@ 96,42 TO 323,555 DIALOG oDlg5 TITLE "Assistente de Importacao"
@ 08,10 TO 84,254
@ 99,168 BMPBUTTON TYPE 1 ACTION OkProc()       //Execute(OkProc)
@ 99,200 BMPBUTTON TYPE 2 ACTION Close(oDlg5)
@ 13,14  SAY "Este programa tem como objetivo:"
@ 23,14  SAY "Criar um arquivo texto para o ponto conforme padrao Microsiga"
@ 33,14  SAY "Arquivo Destino......: "
@ 33,80  GET _NomeArq
@ 43,14  SAY "Data Inicio..........: "
@ 43,80  GET MV_PAR01
@ 53,14  SAY "Data Final...........: "
@ 53,80  GET MV_PAR02
@ 63,14  SAY "Prefixo Inicio.......: "
@ 63,80  GET MV_PAR03
@ 73,14  SAY "Prefixo Final........: "
@ 73,80  GET MV_PAR04
ACTIVATE DIALOG oDlg5

Return(nil)

Static Function OkProc()
Close(oDlg5)

Processa( {|| GeraTmp() }, "Arquivo de Trabalho")
Processa( {|| RunProc() }, "Processando")

//DbCloseArea("TRB")

Return

//---------------------------------------------------------------------------
//Funcao    - GeraTmp                                    | Data  28.11.98   |
//--------------------------------------------------------------------------|
//Descricao - Gera Arquivo de Trabalho Temporario                           |
//---------------------------------------------------------------------------

Static Function GeraTmp()

aDbf  := {}
Aadd(aDbf,{"SEQ"     , "C", 08, 0})
Aadd(aDbf,{"COD"     , "C", 06, 0})
Aadd(aDbf,{"Cliente" , "C", 30, 0})
Aadd(aDbf,{"Mun"     , "C", 30, 0})
Aadd(aDbf,{"Est"     , "C", 02, 0})
Aadd(aDbf,{"CEP"     , "C", 08, 0})
Aadd(aDbf,{"INSCR"   , "C", 18, 0})
Aadd(aDbf,{"TIPO"    , "C", 02, 0})
Aadd(aDbf,{"ORIGEM"  , "C", 02, 0})
Aadd(aDbf,{"COND"    , "C", 04, 0})
Aadd(aDbf,{"SERIE"   , "C", 03, 0})
Aadd(aDbf,{"DOC"     , "C", 06, 0})
Aadd(aDbf,{"CFO"     , "C", 05, 0})
Aadd(aDbf,{"CME"     , "C", 04, 0})
Aadd(aDbf,{"Valor"   , "N", 13, 2})
Aadd(aDbf,{"ValICM"  , "N", 13, 2})
Aadd(aDbf,{"Emissao" , "D", 08, 0})
Aadd(aDbf,{"ALIQ"    , "N", 05, 2})
Aadd(aDbf,{"BASEICM" , "N", 13, 2})
Aadd(aDbf,{"OBSERV"  , "C", 40, 0})

cArq    := CriaTrab(aDbf, .T.)

Use (cArq) Alias TRB Shared New
DbSelectArea("SF3")
SF3->(DbSetOrder(1))                   //Emissao + Nome Cliente + Prefixo + Num

DbSelectArea("SA1")
SA1->(DbSetOrder(1))                   //

DbSelectArea("SB1")
SB1->(DbSetOrder(1))                   //

SF3->(DbGoTop())

SF3->(DbSeek(xFilial("SF3") + DTOS(MV_PAR01), .T.))

NSEQ:=0
While SF3->(!Eof()) .And. SF3->F3_ENTRADA >= MV_PAR01 .And. SF3->F3_ENTRADA <= MV_PAR02 
   IF SF3->F3_SERIE >= MV_PAR03 .And. SF3->F3_SERIE <= MV_PAR04
      nSEQ:=nSeq+1
      IF SF3->F3_VALICM>0
         DO Case
            Case val(SF3->F3_CFO)=5102 .OR. val(SF3->F3_CFO)=6102
               cCodCME := "2110"
            Case val(SF3->F3_CFO)=5202 .OR. val(SF3->F3_CFO)=6202
    	       cCodCME := "2140"
            Case val(SF3->F3_CFO)=1102 .OR. val(SF3->F3_CFO)=2102
        	   IF SF3->F3_SERIE = "4  "
        	      cCodCME := "1108"
        	   ELSE
        	      cCodCME := "1110"
        	   ENDIF
   		    Case val(SF3->F3_CFO)=1202 .OR. val(SF3->F3_CFO)=2202
           	   cCodCME := "1140"                
   		    Case val(SF3->F3_CFO)=5910 .OR. val(SF3->F3_CFO)=6910
           	   cCodCME := "2102"                
   		    Case val(SF3->F3_CFO)=5927
           	   cCodCME := "2172"                
   		    Case val(SF3->F3_CFO)=5949
           	   cCodCME := "2335"                
   		    Case val(SF3->F3_CFO)=5405
           	   cCodCME := "2339"                
   		    Case val(SF3->F3_CFO)=1556 .OR. val(SF3->F3_CFO)=2556
           	   cCodCME := "1181"                
   		    Case val(SF3->F3_CFO)=1653 .OR. val(SF3->F3_CFO)=2653
           	   cCodCME := "1380"                
   		    Case val(SF3->F3_CFO)=1181
           	   cCodCME := "1556"                
   		    Case val(SF3->F3_CFO)=1933 .OR. val(SF3->F3_CFO)=2933
           	   cCodCME := "1381"                
   		    Case val(SF3->F3_CFO)=1949 .OR. val(SF3->F3_CFO)=2949
           	   cCodCME := "1281"                
   		    Case val(SF3->F3_CFO)=1933 .OR. val(SF3->F3_CFO)=2933
           	   cCodCME := "1381"                
	     	OTHERWISE
        	   cCodCME := "0000"                
         EndCase
      Else
         DO Case
            Case val(SF3->F3_CFO)=5102 .OR. val(SF3->F3_CFO)=6102
               cCodCME := "2111"
  	        Case val(SF3->F3_CFO)=5202 .OR. val(SF3->F3_CFO)=6202
    	       cCodCME := "2141"
            Case val(SF3->F3_CFO)=1102 .OR. val(SF3->F3_CFO)=2102
        	   IF SF3->F3_SERIE = "4  "
        	      cCodCME := "1108"
        	   ELSE
        	      cCodCME := "1110"
        	   ENDIF
		    Case val(SF3->F3_CFO)=1202 .OR. val(SF3->F3_CFO)=2202
        	   cCodCME := "1141"                
		    OTHERWISE
        	   cCodCME := "0000"                
          EndCase
      EndIf 

      dbSelectArea(iif(val(SF3->F3_CFO)<5000.and.SF3->F3_TIPO<>"D","SA2","SA1"))
      dbSetOrder(1)
      dbSeek(xFilial(iif(val(SF3->F3_CFO)<5000.and.SF3->F3_TIPO<>"D","SA2","SA1"))+SF3->F3_CLIEFOR+SF3->F3_LOJA)
      IF SF3->F3_DTCANC = CTOD("  /  /  ")
      RecLock("TRB", .T.)
         TRB->SEQ        := STRZERO(NSEQ)
         TRB->COD        := SUBSTR(SF3->F3_CLIEFOR,1,6)
         TRB->CLIENTE    := iif(val(SF3->F3_CFO)<5000.and.SF3->F3_TIPO<>"D",SUBSTR(SA2->A2_NOME,1,30),SUBSTR(SA1->A1_NOME,1,30))
         TRB->MUN        := SA1->A1_MUN
         TRB->INSCR      := iif(val(SF3->F3_CFO)<5000.and.SF3->F3_TIPO<>"D",SUBSTR(SA2->A2_INSCR,1,18),SUBSTR(SA1->A1_INSCR,1,18))  // SA1->A1_INSCR   //iif(val(SF3->F3_CFO)<500,SA2->A2_INSCR,SA1->A1_INSCR)
         TRB->EST        := SF3->F3_ESTADO
         TRB->CEP        := iif(val(SF3->F3_CFO)<5000.and.SF3->F3_TIPO<>"D",SUBSTR(SA2->A2_CEP,1,8),SUBSTR(SA1->A1_CEP,1,8))
         TRB->TIPO       := "NF"       //SF3->F3_ESPECIE  //SF3->F3_TIPO
         TRB->ORIGEM     := IIF(SF3->F3_VALICM>0,"00","40")
         TRB->COND       := iif(val(SF3->F3_CFO)<5000.and.SF3->F3_TIPO<>"D",IIF(SA2->A2_COND=="001","0","1"),IIF(SA1->A1_COND=="001","0","1"))
         TRB->SERIE      := SF3->F3_SERIE
         TRB->DOC        := SUBSTR(SF3->F3_NFISCAL,1,6)
         TRB->CFO        := SF3->F3_CFO    
         TRB->CME        := cCodCME        
         TRB->VALOR      := SF3->F3_VALCONT
         TRB->EMISSAO    := SF3->F3_ENTRADA
         TRB->ALIQ       := SF3->F3_ALIQICM 
         TRB->BASEICM    := SF3->F3_BASEICM
         TRB->VALICM     := SF3->F3_VALICM 
         TRB->OBSERV     := SF3->F3_OBSERV 
      MsUnLock("TRB")
      ENDIF
      
      SF3->(DbSkip())
IncProc()
   Else

   SF3->(DbSkip())

   IncProc()

   EndIf

EndDo

Return



//*********************************************************************//

Static Function RunProc()


   aStruct := { {"LINHA","C",150,0} }
   dbCreate(_NomeArq,aStruct)

   lImport := .f.

   y:=0
   aux:={"","","","","","","","","","","","","",""}
   a:="";b:="";w:=""

   nOutfile := FCreate("c:\cantuCha.txt",0)  // cria o arquivo

TRB->(DbGotop())
ProcRegua(TRB->(RECCOUNT())) //Ajusta numero de elementos da regua de relatorios
Do While !TRB->(EOF())
   Incproc()
   FWrite(nOutFile,CHR(13)+CHR(10)+"#"+;
                   ","+"0578"+;                                        //EMP
                   ","+"000001"+;                                      //LTE
                   ","+TRB->CME+;                                      //CME
                   ","+TRB->DOC+;                                      //CDI
                   ","+"      "+;                                      //CDF
                   ","+CHR(34)+ALLTRIM(TRB->SERIE)+CHR(34)+;                    //SER
                   ","+CHR(34)+SUBSTR(DTOS(TRB->EMISSAO),7,2)+;        //DTD
                   SUBSTR(DTOS(TRB->EMISSAO),5,2)+;                    //DTD
                   SUBSTR(DTOS(TRB->EMISSAO),1,4)+CHR(34)+;            //DTD
                   ","+CHR(34)+SUBSTR(DTOS(TRB->EMISSAO),7,2)+;        //DTR
                   SUBSTR(DTOS(TRB->EMISSAO),5,2)+;                    //DTR
                   SUBSTR(DTOS(TRB->EMISSAO),1,4)+CHR(34)+;            //DTR
                   ","+CHR(34)+TRB->COD+CHR(34)+;                                      //EMI
                   ","+CHR(34)+ALLTRIM(TRB->CLIENTE)+CHR(34)+;                                  //DEE
                   ","+CHR(34)+TRB->EST+CHR(34)+;                                      //EST
                   ","+ALLTRIM(TRB->MUN))                                       //MUN
   FWrite(nOutFile,","+CHR(34)+ALLTRIM(TRB->INSCR)+CHR(34)+;                                    //INS
                   ","+TRB->CEP+;                                      //CEP
                   ","+CHR(34)+ALLTRIM(TRB->TIPO)+CHR(34)+","+" "+;                     //TIP   //SIT
                   ","+TRB->ORIGEM+;                                   //ORV
                   ","+ALLTRIM(TRB->COND)+;                                     //CPG
                   ","+"0"+;                               //DAC
                   ","+"0"+;                               //FRT
                   ","+ALLTRIM(STR(TRB->VALOR))+;                      //BIP
                   ","+ALLTRIM(STR(TRB->VALOR))+;                      //VLC
                   ","+"0"+;                               //VMO
                   ","+"0"+;                               //SVT
                   ","+"0"+;                               //ADS
                   ","+"0"+;                               //ADV
                   ","+"000000"+;                                      //CTB
                   ","+"000000"+;                                      //CPT
                   ","+"0000"+;                                        //HST
                   ","+" "+ALLTRIM(TRB->CFO)+".00"+;                            //NOP
                   ","+TRB->SEQ+;                                      //CHA
                   ","+SUBSTR(TRB->CLIENTE,1,15),174)   // chr(13)+chr(10) indica <enter>
if TRB->BASEICM > 0                                     
   FWrite(nOutFile,CHR(13)+CHR(10)+"##"+;
                   ","+"0578"+;                                        //EMP
                   ","+TRB->SEQ+;                                      //CHA
                   ","+"ICMS"+;                                        //IMP
                   ","+ALLTRIM(STR(TRB->ALIQ))+;                       //ALQ
                   ","+ALLTRIM(STR(TRB->BASEICM))+;                    //BAS
                   ","+ALLTRIM(STR(TRB->VALICM))+;                     //VLR
                   ","+ALLTRIM(STR(TRB->VALOR)),71)   // chr(13)+chr(10) indica <enter> //VLC
else 
   FWrite(nOutFile,CHR(13)+CHR(10)+"##"+;
                   ","+"0578"+;                                        //EMP
                   ","+TRB->SEQ+;                                      //CHA
                   ","+"ICMS"+;                                        //IMP
                   ","+"99"+;                                          //ALQ
                   ","+"0"+;                                           //BAS
                   ","+ALLTRIM(STR(TRB->VALOR))+;                      //VLR
                   ","+"0",71)   // chr(13)+chr(10) indica <enter>     //VLC
endif
IF TRB->SERIE ="4  "       
   IF (TRB->CME <> "2110" .AND. TRB->CME <> "2111")
   	  nFunRural := TRB->VALOR * 0.023
	  FWrite(nOutFile,CHR(13)+CHR(10)+"##"+;
      					              ","+"0578"+;                                        //EMP
					                  ","+TRB->SEQ+;                                      //CHA
				                      ","+"FNR"+;                                         //IMP
					                  ","+"2.30"+;                                        //ALQ
					                  ","+ALLTRIM(STR(TRB->VALOR))+;                      //BAS
					                  ","+ALLTRIM(STR(nFunRural))+;                       //VLR
					                  ","+"0",71)   // chr(13)+chr(10) indica <enter>     //VLC
	ENDIF
ENDIF    
TRB->(DbSkip())
Enddo
FClose(nOutFile)                // fecha o arquivo
TRB->(dbCloseArea())
Return

