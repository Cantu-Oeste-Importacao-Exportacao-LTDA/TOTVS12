#Include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"

User Function RELFER()

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "RELFER"
Local cPict          := ""
Local titulo         := "RELFER"
Local nCol	         := 0                                                    
//                                 1         2         3         4         5         6         7         8         9        10        11        12        13        14         15        16       17        18        19         20       21        22
//                       01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Local Cabec2         := ""
Local Cabec1         := ""
Local imprime        := .T.    
Local aOrd           := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private tamanho      := "M"
Private nomeprog     := "RELFER" 
Private cPerg	     := "RELFER"
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RELFER" 
Private nLin           := 65	

Private cString      := "SRA"  
Private xParFilial   :=	Space(2)
Private xParSegmDe	 :=	Space(9)
Private xParSegmAte	 :=	Space(9)
Private xParSituac   :=	Space(5)
Private xParCateg	 :=	Space(9)
Private xParCCusto   :=	Space(9)
Private lQuebra		 := .f.       
Private dDataRel     := Ctod("")
Private nDiasTot	 := 0  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//********************************************************************************
// PROCEDIMENTOS INICIAIS
//********************************************************************************

// Ajusta os parametros
cPerg := "RELFER    "
AjustaSX1(cPerg)

wnrel := SetPrint(cString,NomeProg,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.f.,aOrd,.F.,Tamanho,.f.,.f.)
   
If nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)                        

// Monta a interface padrao com o usuario...
	Pergunte(cPerg,.F.)

	xParFilial	:= mv_par01
	xParSegmDe	:= mv_par02
	xParSegmAte	:= mv_par03
	dDataRel	:= mv_par04
	nDiasTot	:= mv_par05

	xParSituac	:= mv_par06
	xParCateg 	:= mv_par07
	
	If mv_par08==1
		lQuebra := .t.                                                                                 '
	Else
		lQuebra := .f.
	EndIf	

//********************************************************************************
// PROCESSA RELATORIO
//********************************************************************************
                                     
titulo         := "Relação de Férias - Referência em "+Dtoc(dDataRel)


RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

//********************************************************************************

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)                                       

Local cCCustoAnt := ""
Local cSegmeAnt	 := ""
Local nCont      := 0     
Local cQuery	:= ""

cSituacao  	:= fSqlIN( xParSituac, 1 )	// Situacao do Funcionario
cCategoria 	:= fSqlIN( xParCateg, 1 ) 	// Categoria do Funcionario

	cQuery := " SELECT RA_FILIAL, RA_CC, RA_MAT, RA_NOME, RA_CODFUNC,RA_ADMISSA, RA_X_SEGME"
	cQuery += " FROM " + RetSQLName("SRA") + " SRA "
  	cQuery += " WHERE SRA.D_E_L_E_T_ <> '*' "
 	cQuery += "   AND SRA.RA_FILIAL  = '"+xParFilial+"' " 
 	cQuery += "   AND SRA.RA_X_SEGME BETWEEN '"+xParSegmDe+"' AND '"+xParSegmAte+"' " 
 	cQuery += "   AND SRA.RA_SITFOLH IN("+cSituacao+")"
 	cQuery += "   AND SRA.RA_CATFUNC IN("+cCategoria+")"
   	cQuery += " ORDER BY RA_FILIAL, RA_X_SEGME, RA_CC "      
    
	TcQuery cQuery new Alias "QRY"   

	DbSelectArea("QRY")
	DbGoTop()
	While !Eof()

		DbSelectArea("SRF")
		DbSetOrder(1)
		DbGoTop()
		DbSeek(QRY->RA_FILIAL+QRY->RA_MAT,.f.)
		If SRF->RF_FILIAL+SRF->RF_MAT==QRY->RA_FILIAL+QRY->RA_MAT
		Else
			DbSelectArea("QRY")
			DbSkip()
			Loop			
		EndIf
		
		nDiasVenc := nDiasProp := nDiasAbono := 0
	 	dDtBaseFer := SRF->RF_DATABAS
       	Calc_Fer(@dDtBaseFer,dDataRel,@nDiasVenc,@nDiasProp,,,,,)
       	If nDiasVenc > 0 .and. SRF->RF_DFERANT > 0   
       		nDiasVenc := Max(nDiasVenc - SRF->RF_DFERANT,0)
       	Else
       		If nDiasVenc == 0 .and. nDiasProp > 0 .and. SRF->RF_DFERANT > 0   
	       		nDiasProp := Max(nDiasProp - SRF->RF_DFERANT,0)
	       	EndIf
       	EndIf                        
       	
       	If (nDiasVenc + nDiasProp) > nDiasTot

       	Else
			DbSelectArea("QRY")
			DbSkip()
			Loop			
       	EndIf

    	If QRY->RA_X_SEGME <> cSegmeAnt
			If !Empty(cSegmeAnt)
				@nLin,001 PSay "==================================================================================================================================="
				nLin++
				@nLin,001 PSay "Funcionários : "+Transform(nCont,"999")
				nLin++
				@nLin,001 PSay "==================================================================================================================================="
				nLin++   
			EndIf
			nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			@nLin,001 PSay "Filial  : "+Posicione("SM0",1,cEmpAnt+QRY->RA_FILIAL,"M0_FILIAL")
			nLin++
 			@nLin,001 PSay "Segmento: "+AllTrim(QRY->RA_X_SEGME)+" - "+Posicione("CTH",1,xFilial("CTH")+QRY->RA_X_SEGME,"CTH_DESC01")
			nLin++	
			@nLin,001 PSay "==================================================================================================================================="
			nLin++                                                                                                                    
			@nLin,001 PSay "C. Custo: "+AllTrim(QRY->RA_CC)+" - "+Posicione("CTT",1,xFilial("CTT")+QRY->RA_CC,"CTT_DESC01")
			nLin++	
			@nLin,001 PSay "==================================================================================================================================="
			nLin++                                                                                                                    
			@nLin,001 PSay "MATRIC. NOME                                       FUNÇÃO                           ADMISSAO     DT BASE     VENC.    PROP.   TOTAL"	
			nLin++  	
			nLin++
			cSegmeAnt := QRY->RA_X_SEGME
			cCCustoAnt:= QRY->RA_CC
    		nCont := 0
    	EndIf     
    		
 	  	If QRY->RA_CC <> cCCustoAnt
			If !Empty(cCCustoAnt)
 				@nLin,001 PSay "==================================================================================================================================="
				nLin++
				@nLin,001 PSay "Funcionários : "+Transform(nCont,"999")
				nLin++
				@nLin,001 PSay "==================================================================================================================================="
				nLin++   
			EndIf
			nLin++   
		 	If lQuebra  
				nLin := 65
			Endif         
			If nLin > 63
				nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				@nLin,001 PSay "Filial  : "+Posicione("SM0",1,cEmpAnt+QRY->RA_FILIAL,"M0_FILIAL")
				nLin++
 				@nLin,001 PSay "Segmento: "+AllTrim(QRY->RA_X_SEGME)+" - "+Posicione("CTH",1,xFilial("CTH")+QRY->RA_X_SEGME,"CTH_DESC01")
				nLin++	
				@nLin,001 PSay "==================================================================================================================================="
				nLin++                                                                                                                    
				@nLin,001 PSay "C. Custo: "+AllTrim(QRY->RA_CC)+" - "+Posicione("CTT",1,xFilial("CTT")+QRY->RA_CC,"CTT_DESC01")
				nLin++	
				@nLin,001 PSay "==================================================================================================================================="
				nLin++                                                                                                                    
				@nLin,001 PSay "MATRIC. NOME                                       FUNÇÃO                           ADMISSAO     DT BASE     VENC.    PROP.   TOTAL"	
	   			nLin++  	
	 			nLin++    
			Else
				nLin++                                                                                                                    
				nLin++                                                                                                                    
				@nLin,001 PSay "C. Custo: "+AllTrim(QRY->RA_CC)+" - "+Posicione("CTT",1,xFilial("CTT")+QRY->RA_CC,"CTT_DESC01")
				nLin++	
				@nLin,001 PSay "==================================================================================================================================="
				nLin++                                                                                                                    
			EndIf
			cSegmeAnt := QRY->RA_X_SEGME
			cCCustoAnt:= QRY->RA_CC
    		nCont := 0
    	EndIf
		nCont++
		If nLin > 63
			nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			@nLin,001 PSay "Filial  : "+Posicione("SM0",1,cEmpAnt+QRY->RA_FILIAL,"M0_FILIAL")
			nLin++
 			@nLin,001 PSay "Segmento: "+AllTrim(QRY->RA_X_SEGME)+" - "+Posicione("CTH",1,xFilial("CTH")+QRY->RA_X_SEGME,"CTH_DESC01")
			nLin++	
			@nLin,001 PSay "==================================================================================================================================="
			nLin++                                                                                                                    
			@nLin,001 PSay "C. Custo: "+AllTrim(QRY->RA_CC)+" - "+Posicione("CTT",1,xFilial("CTT")+QRY->RA_CC,"CTT_DESC01")
			nLin++	
			@nLin,001 PSay "==================================================================================================================================="
			nLin++                                                                                                                    
			@nLin,001 PSay "MATRIC. NOME                                       FUNÇÃO                           ADMISSAO     DT BASE     VENC.    PROP.   TOTAL"	
//   		                         1         2         3         4         5         6         7         8         9        10        11        12        13  
//          		        12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
//                          XXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   XXXXXXXXXXXXXXXXXXXX             XX/XX/XX    XX/XX/XX    XXX.X    XXX.X    XXX.X    
			nLin++  	
			nLin++
		Endif  
		@nLin,001 PSay QRY->RA_MAT
		@nLin,009 PSay SubStr(QRY->RA_NOME,1,40)
		@nLin,052 PSay Posicione("SRJ",1,xFilial("SRJ")+QRY->RA_CODFUNC,"RJ_DESC")
		@nLin,085 PSay Dtoc(Stod(QRY->RA_ADMISSA))   
		@nLin,097 PSay Dtoc(SRF->RF_DATABAS)
		@nLin,109 PSay Transform(nDiasVenc,"999.9")
		@nLin,118 PSay Transform(nDiasProp,"999.9")
		@nLin,127 PSay Transform((nDiasVenc + nDiasProp),"999.9")
		nLin++
		DbSelectArea("QRY")
		DbSkip()
	End           
 
	DbSelectArea("QRY")
	DbCloseArea()
       
	@nLin,001 PSay "==================================================================================================================================="
	nLin++
	nLin++
	@nLin,001 PSay "Funcionários : "+Transform(nCont,"999")
	nLin++
	@nLin,001 PSay "==================================================================================================================================="
	nLin++   
	@nLin,001 PSay " "
	

//********************************************************************************

If aReturn[5]==1
   DbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return  

Static Function AjustaSX1(cPerg)

dbSelectArea("SX1")

SX1->(dbSetOrder(1))

If !dbSeek(cPerg+"01")
 RecLock("SX1",.T.)
Else
 RecLock("SX1",.F.)
EndIf

sx1->x1_grupo  := cPerg
sx1->x1_ordem  := '01'
sx1->x1_pergunt:= 'Filial                     '
sx1->x1_variavl:= 'mv_ch1'
sx1->x1_tipo   := 'C'
sx1->x1_tamanho:= 2
sx1->x1_decimal:= 0
sx1->x1_gsc    := 'G'
sx1->x1_f3     := 'XM0'
sx1->x1_pyme   := 'S' 
sx1->x1_var01  := 'mv_par01'                                                   
sx1->x1_valid  := 'naovazio()'  
sx1->(MsUnlock())       


If !dbSeek(cPerg+"02")
 RecLock("SX1",.T.)
Else
 RecLock("SX1",.F.)
EndIf

sx1->x1_grupo  := cPerg
sx1->x1_ordem  := '02'
sx1->x1_pergunt:= 'Segmento De    '
sx1->x1_variavl:= 'mv_ch2'
sx1->x1_tipo   := 'C'
sx1->x1_tamanho:= 9
sx1->x1_decimal:= 0
sx1->x1_gsc    := 'G'
sx1->x1_f3     := 'CTH'
sx1->x1_pyme   := 'S' 
sx1->x1_var01  := 'mv_par02'                                                   
sx1->(MsUnlock())       


If !dbSeek(cPerg+"03")
 RecLock("SX1",.T.)
Else
 RecLock("SX1",.F.)
EndIf

sx1->x1_grupo  := cPerg
sx1->x1_ordem  := '03'
sx1->x1_pergunt:= 'Segmento Ate    '
sx1->x1_variavl:= 'mv_ch3'
sx1->x1_tipo   := 'C'
sx1->x1_tamanho:= 9
sx1->x1_decimal:= 0
sx1->x1_gsc    := 'G'
sx1->x1_f3     := 'CTH'
sx1->x1_pyme   := 'S' 
sx1->x1_var01  := 'mv_par03'                                                   
sx1->(MsUnlock())       


If !dbSeek(cPerg+"04")
 RecLock("SX1",.T.)
Else
 RecLock("SX1",.F.)
EndIf

sx1->x1_grupo  := cPerg
sx1->x1_ordem  := '04'
sx1->x1_pergunt:= 'Data Base                '
sx1->x1_variavl:= 'mv_ch4'
sx1->x1_tipo   := 'D'
sx1->x1_tamanho:= 8
sx1->x1_decimal:= 0
sx1->x1_gsc    := 'G'
sx1->x1_var01  := 'mv_par04'
sx1->x1_valid  := 'naovazio()'                                                                                                      
sx1->(MsUnlock())


If !dbSeek(cPerg+"05")
 RecLock("SX1",.T.)
Else
 RecLock("SX1",.F.)
EndIf

sx1->x1_grupo  := cPerg
sx1->x1_ordem  := '05'
sx1->x1_pergunt:= 'Dias Ferias                  '
sx1->x1_variavl:= 'mv_ch5'
sx1->x1_tipo   := 'N'
sx1->x1_tamanho:= 3
sx1->x1_decimal:= 0
sx1->x1_gsc    := 'C'
sx1->x1_f3     := ''
sx1->x1_pyme   := 'S' 
sx1->x1_var01  := 'mv_par05'                                                   
sx1->x1_valid  := 'naovazio()'  
sx1->(MsUnlock())       
 
If !dbSeek(cPerg+"06")
 RecLock("SX1",.T.)
Else
 RecLock("SX1",.F.)
EndIf

sx1->x1_grupo  := cPerg
sx1->x1_ordem  := '06'
sx1->x1_pergunt:= 'Situações  '
sx1->x1_variavl:= 'mv_ch6'
sx1->x1_tipo   := 'C'
sx1->x1_tamanho:= 5
sx1->x1_decimal:= 0
sx1->x1_gsc    := 'G'
sx1->x1_f3     := ''
sx1->x1_pyme   := 'S' 
sx1->x1_var01  := 'mv_par06'                                                   
sx1->x1_valid  := 'fSituacao'  
sx1->(MsUnlock())       
 
If !dbSeek(cPerg+"07")
 RecLock("SX1",.T.)
Else
 RecLock("SX1",.F.)
EndIf

sx1->x1_grupo  := cPerg
sx1->x1_ordem  := '07'
sx1->x1_pergunt:= 'Categorias '
sx1->x1_variavl:= 'mv_ch7'
sx1->x1_tipo   := 'C'
sx1->x1_tamanho:= 15
sx1->x1_decimal:= 0
sx1->x1_gsc    := 'G'
sx1->x1_f3     := ''
sx1->x1_pyme   := 'S' 
sx1->x1_var01  := 'mv_par07'                                                   
sx1->x1_valid  := 'fCategoria'  
sx1->(MsUnlock())       
 
If !dbSeek(cPerg+"08")
 RecLock("SX1",.T.)
Else
 RecLock("SX1",.F.)
EndIf

sx1->x1_grupo   :=cPerg
sx1->x1_ordem   :='08'
sx1->x1_pergunt :='C.Custo em Outra Pg?               '
sx1->x1_variavl :='mv_ch8'
sx1->x1_tipo    :='N'
sx1->x1_tamanho :=1
sx1->x1_decimal :=0
sx1->x1_gsc     :='C'
sx1->x1_var01   :='mv_par08'
sx1->x1_f3      :=''
sx1->x1_def01   :='Sim' // 1
sx1->x1_def02   :='Nao' // 2
MsUnlock("SX1")
                    
Return
