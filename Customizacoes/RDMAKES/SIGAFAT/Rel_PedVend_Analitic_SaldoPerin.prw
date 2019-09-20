/*/
+----------+----------+-------+-----------------------+------+----------+
|Programa  | RJU028   | Autor | Maycon / Eder Gasparin| Data | 30/10/06 |
+----------+----------+-------+-----------------------+------+----------+
|Descricao : Emite relatório de saldo (devedor ou credor) do vendedor.  |
|            A cada pedido feito no palm ou digitado no sistema, é      |
|            calculado o valor da diferença entre o valor de tabela do  |
|            produto e o valor que o mesmo foi vendido. Essa diferença  |
|            é armazenada no campo C5_SLDSFA.                           |
|            Neste relatório, é possível saber o saldo do período       |
|            por vendedor.                                              |
+----------+------------------------------------------------------------+
|Uso       | SIGAFIN - Especifico Cantu Verduras                        |
+----------+------------------------------------------------------------+
/*/

#INCLUDE "rwmake.ch"
#include "topconn.ch" 

#define PAD_LEFT            0
#define PAD_RIGHT           1
#define PAD_CENTER          2

User Function RJU030()
Local aCA:={OemToAnsi("Confirma"),OemToAnsi("Abandona")}
Local cCadastro  := OemToAnsi("Saldo por Vendedor")
Local saldo_Ped  := 0
Private aReturn  := {OemToAnsi('Zebrado'), 1,OemToAnsi('Administracao'), 2, 2, 1, '',1 }
Private nLastKey := 0
Private cPerg    := "RJU028"

SetPrvt("aCA,ARETURN")
SetPrvt("OFONT1,OFONT2,OFONT3,OFONT4,OFONT5,OFONT11,OFONT12,OFONT13,OFONT14,OFONT15")
SetPrvt("OPRN,NTPAG")                               

SetPrvt("nLM,nRM,nTM,nBM,nLH,nCW,nLine,nCol,nRP,nCP,nRD,nCD,nLineZero") //nLineZero -> Ajuste para quando a linha comecar na posicao zero.
SetPrvt("nLinha,nColuna")

SetPrvt("NTIPO,ADBF,CARQ,CARQIND,CENTREGA")
SetPrvt("cAux,TOT,TOTSLD,VendAnt, cEMP, cFILIAL, cVendedor")  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
                                  
	nLM  :=  100	//Left Margin
	nRM  := 2261	//Right Margin
	nTM  :=  100	//Top Margin
	nBM  := 3300	//Botton Margin
	nRH  :=   50	//Line Height   original:50
	nCW  :=   26	//Character Width
	nRow :=    1	//Linha atual
	nCol :=    1	//Coluna Atual
	nRP  := nTM+3	//Posicao da Primeira Linha Atual
	nCP  := nLM+3	//Posicao da Primeira Coluna Atual
	nRD  := nTM+45	//Posicao da Primeira Linha (divisao) Atual
	nCD  := nLM+0	//Posicao da Primeira Coluna (divisao) Atual
	nLinha  := 1
	nColuna := 1                                           
	
	If nLastKey == 27 .Or. nLastKey == 27
	   Return
	Endif
	Pergunte(cPerg,.T.)
	If nLastKey == 27 .Or. nLastKey == 27
	   Return
	Endif	

    dbSelectArea("SM0")
    dbSetOrder(1)
	cEmp   := SM0->M0_CODIGO
	cFilial:= SM0->M0_CODFIL

	Processa( {|lEnd| ImpRom() })	
Return
 
Static Function ImpRom()
Public oFont1 := TFont():New( "Verdana",,08,,.F.,,,,,.F. )
Public oFont2 := TFont():New( "Verdana",,10,,.F.,,,,,.F. )
Public oFont3 := TFont():New( "Verdana",,12,,.F.,,,,,.F. )
Public oFont4 := TFont():New( "Verdana",,14,,.F.,,,,,.F. )
Public oFont5 := TFont():New( "Verdana",,16,,.F.,,,,,.F. )
Public oFont11:= TFont():New( "Verdana",,08,,.T.,,,,,.F. )
Public oFont12:= TFont():New( "Verdana",,10,,.T.,,,,,.F. )
Public oFont13:= TFont():New( "Verdana",,12,,.T.,,,,,.F. )
Public oFont14:= TFont():New( "Verdana",,14,,.T.,,,,,.F. )
Public oFont15:= TFont():New( "Verdana",,16,,.T.,,,,,.F. )

Public oPrn
Public nPag := 1
Public nLin := 0

	oPrn:=TMSPrinter():New()
	oPrn:SetPortrait() // ou SetLandscape()
	oPrn:SetPage(9)	//Folha A4
	oPrn:Setup()
    cVendedor:= AchaVendedor()  
	CabcPar()
	nLinha:=9
    
	cQuery := "SELECT C6_FILIAL, C6_NUM, C5_FILIAL, C5_NUM AS PEDIDO, C5_VEND1 AS COD_VENDEDOR, C5_CLIENTE AS COD_CLIENTE, "
	cQuery +=        "C5_LOJACLI AS LOJA_CLIENTE, C5_SLDSFA AS SLDSFA, C5_SLDPED AS SLDPED, C5_EMISSAO AS EMISSAO , "
    cQuery +=        "SA3.A3_NOME AS NOME_VENDEDOR, "
    cQuery +=        "SA1.A1_NOME AS NOME_CLIENTE "
    cQuery += "FROM SC5"+ cEmp +"0" +" AS SC5 " 
    cQuery += "INNER JOIN SA3"+ cEmp +"0" +" AS SA3 " 
    cQuery +=    "ON SC5.C5_VEND1=SA3.A3_COD "                                    
    cQuery += "INNER JOIN SA1"+ cEmp +"0" +" AS SA1 "
    cQuery +=    "ON SA1.A1_COD = SC5.C5_CLIENTE "
    cQuery +=    " AND SA1.A1_LOJA = SC5.C5_LOJACLI  "  
    cQuery += "INNER JOIN SC6"+ cEmp +"0" + " AS SC6 "
    cQuery +=    "ON SC6.C6_NUM = SC5.C5_NUM AND SC6.C6_FILIAL = SC5.C5_FILIAL "
    cQuery += "WHERE SC5.C5_EMISSAO BETWEEN '" + DtOs(MV_PAR01) + "' AND '"+DtOs(MV_PAR02)+"'"
    cQuery +=    "AND (SC5.C5_SLDSFA <> 0 OR SC5.C5_SLDPED <> 0)"   
    cQuery +=    "AND SC5.C5_VEND1 ='" + MV_PAR03 + "'
	cQuery +=    "AND SC5.D_E_L_E_T_ <> '*'"
	cQuery +=    "AND SC6.C6_LOCAL = '03' "    
	cQuery +=    "AND SA3.D_E_L_E_T_ <> '*' GROUP BY C5_FILIAL, C5_NUM, C6_FILIAL, C6_NUM, C5_VEND1, C5_CLIENTE, C5_LOJACLI, C5_SLDSFA, C5_SLDPED, C5_EMISSAO, SA3.A3_NOME, SA1.A1_NOME ORDER BY NOME_CLIENTE, LOJA_CLIENTE"

//	cQuery := "SELECT C6_FILIAL, C6_NUM, C5_FILIAL, C5_NUM AS PEDIDO, C5_VEND1 AS COD_VENDEDOR, C5_CLIENTE AS COD_CLIENTE, "
//	cQuery +=        "C5_LOJACLI AS LOJA_CLIENTE, C5_SLDSFA AS SLDSFA, C5_SLDPED AS SLDPED, C5_EMISSAO AS EMISSAO , "
//    cQuery +=        "SA3.A3_NOME AS NOME_VENDEDOR, "
//    cQuery +=        "SA1.A1_NOME AS NOME_CLIENTE "
//    cQuery += "FROM SC5"+ cEmp +"0" +" AS SC5 " 
//    cQuery += "INNER JOIN SA3"+ cEmp +"0" +" AS SA3 " 
//    cQuery +=    "ON SC5.C5_VEND1=SA3.A3_COD "
//    cQuery += "INNER JOIN SA1"+ cEmp +"0" +" AS SA1 "
//    cQuery +=    "ON SA1.A1_COD = SC5.C5_CLIENTE "
//    cQuery +=    " AND SA1.A1_LOJA = SC5.C5_LOJACLI  "  
//    cQuery += "INNER JOIN SC6"+ cEmp +"0" + " AS SC6 "
//    cQuery +=    "ON SC6.C6_NUM = SC5.C5_NUM AND SC6.C6_FILIAL = SC5.C5_FILIAL "
//    cQuery += "WHERE SC5.C5_EMISSAO BETWEEN '" + DtOs(MV_PAR01) + "' AND '"+DtOs(MV_PAR02)+"'"
//    cQuery +=    "AND (SC5.C5_SLDSFA <> 0 OR SC5.C5_SLDPED <> 0)"   
//    cQuery +=    "AND SC5.C5_VEND1 ='" + MV_PAR03 + "'
//	cQuery +=    "AND SC5.D_E_L_E_T_ <> '*'"
//	cQuery +=    "AND SC6.C6_LOCAL = '01'     
//	cQuery +=    "AND SA3.D_E_L_E_T_ <> '*' ORDER BY NOME_CLIENTE, LOJA_CLIENTE"

	TCQUERY cQuery NEW ALIAS "TMPSLD"
	MEMOWRITE("SLDVNDA.SQL",CQUERY)			
	dbSelectArea("TMPSLD")
	
	ProcRegua(TMPSLD->(LastRec()))
	dbGoTop()
	TOT    := 0
	TOTSLD := 0	
	If TMPSLD->(!Eof())
		VendAnt:="00.000"
	EndIf
	While TMPSLD->(!Eof())
      	VendAnt:=TMPSLD->COD_VENDEDOR 
		if TMPSLD->SLDPED <> 0
 			saldo_Ped:= TMPSLD->SLDPED
		else
			saldo_Ped:= TMPSLD->SLDSFA
		endIf	
		Processa({||PrintS(nLinha ,2 ,TMPSLD->PEDIDO,2 )})
		Processa({||PrintS(nLinha ,8 ,TMPSLD->COD_CLIENTE+" / " +TMPSLD->LOJA_CLIENTE + " - " + TMPSLD->NOME_CLIENTE,2 )})
		Processa({||PrintS(nLinha ,80,TRANSFORM((saldo_Ped),'@E 999,999.99'),2,PAD_RIGHT )})
		Processa({||DrawH(nLinha,1 ,84,2)})
		Processa({||DrawV(nLinha-1,8 ,nLinha,2)})
		Processa({||DrawV(nLinha-1,59,nLinha,2)})
		Processa({||DrawV(nLinha-1,72,nLinha,2)})
		TOTSLD += saldo_Ped
		nLinha += 1
		TMPSLD->(DbSkip())
		IncProc()
		if nLinha = 64 
		   nLinha:=9
           oPrn:EndPage()
           CabcPar()		   
		endIf      
   	    If lEnd
		   @PROW()+1,001 PSAY "Cancelado pelo operador"
		   Exit
	    Endif
	End
	
	Processa({||DrawV(nLinha-1,8 ,nLinha,2)})
    Processa({||PrintS(nLinha ,1 ,"TOTAL",13 )})
//	Processa({||PrintS(nLinha ,62,TRANSFORM(TOT,'@E 999,999.99'),3 )}) 
	Processa({||PrintS(nLinha ,80,TRANSFORM(TOTSLD,'@E 999,999.99'),2,PAD_RIGHT)})
   	Processa({||DrawV(nLinha-1,59,nLinha,2)})
   	Processa({||DrawV(nLinha-1,72,nLinha,2)})	
   	Processa({||DrawH(nLinha,1 ,84,2)})
	
	TMPSLD->(dbCloseArea())
	TMPVEND->(dbCloseArea())
	oPrn:EndPage()
	Set Device To Screen
	If aReturn[5] == 1
   		Set Printer To
   		OurSpool(WnRel)
	Endif
	FT_PFlush()	
	oPrn:Preview()
	//oPrn:Print() // descomentar esta linha para imprimir direto
	MS_FLUSH()
Return 

/*
+-----------+------------------------------------------+------+----------+
| Funcao    | CabCPar                                  | Data | 26.06.06 |
+-----------+------------------------------------------+------+----------+
| Descricao | Cabecalho Padrao Cantu. Especifico p/ Romaneio             |
+-----------+----------+-------------------------------------------------+
+-----------+----------+-------------------------------------------------+
| Alterado  | Nome     | Motivo                                          |
+-----------+----------+-------------------------------------------------+
|           |          |                                                 |
+-----------+----------+-------------------------------------------------+
*/
Static Function CabCPar() 
Private cQuery1 :=''
	oPrn:Say(0,0," ",oFont1)							//Inicio
	oPrn:Box(nTM,nLM,nBM,nRM)							//Box q ocupa todo espaco da folha
	oPrn:Box(nTM+1,nLM+1,nBM-1,nRM-1)					//Box adicional p/ aumentar a largura do box acima
 	oPrn:Box(nTM+2,nLM+2,nBM-2,nRM-2)					//Idem
	oPrn:SayBitmap(nRP+15,nCP+15,"lgrl50.bmp",196,94)	//Logo Cantu
	Processa({||PrintS(2 ,30,"Rel. de Saldo por Vendedor",15)})			//Titulo
	Processa({||DrawH(3,1,84,3)})						//Div abaixo do logo
	Processa({||DrawV(0,10,3,3)})						//div ao lado do logo
	TOT    := 0
	TOTSLD := 0	

	Processa({||DrawH(3,65,5,2)})	
	Processa({||PrintS(4 ,1 ,"Filial:",2)})
	Processa({||PrintS(5 ,1 ,"Vendedor:",2)})
	Processa({||PrintS(6 ,1 ,"Periodo:",2)})
	Processa({||PrintS(4 ,10,SM0->M0_Filial,2)})
	Processa({||PrintS(5 ,10,cVendedor,2)})
	Processa({||PrintS(6 ,10,"de "+DTOC(MV_Par01)+" ate "+DTOC(MV_Par02),2)})
	
	Processa({||PrintS(4 ,64,"Folha:"  ,2)})
	Processa({||PrintS(5 ,64,"Emissao:",2)})
	Processa({||PrintS(6 ,64,"Hora:"   ,2)})
	Processa({||PrintS(4 ,81,TRANSFORM(nPag,'@E 999'),2)})
	Processa({||PrintS(5 ,77,Dtoc(dDatabase),2)})
	Processa({||PrintS(6 ,77,Time(),2)})
//    Processa({||DrawV (3 ,72,6 ,2)})
    Processa({||DrawH (6 ,1 ,84,3)})

	Processa({||DrawH (7 ,1 ,84,3)})
	Processa({||DrawH (8 ,1 ,84,3)})
	Processa({||PrintS(8 ,2 ,"Pedido",12)})
	Processa({||DrawV (7 ,8 ,8 ,2)})
    Processa({||PrintS(8 ,8 ,"Cliente - Loja",12)})
	Processa({||DrawV (7 ,72,8 ,2)})
    Processa({||PrintS(8 ,76,"Saldo",12)})
	
    Processa({||DrawH (60,1 ,84,3)})
    
	nPag += 1
Return    

Static Function PrintS(pfRow,pfCol,pfText,pfFont,alinhamento)
	oFont1 := TFont():New( "Verdana",,08,,.F.,,,,,.F. )
	oFont2 := TFont():New( "Verdana",,10,,.F.,,,,,.F. )
	oFont3 := TFont():New( "Verdana",,12,,.F.,,,,,.F. )
	oFont4 := TFont():New( "Verdana",,14,,.F.,,,,,.F. )
	oFont5 := TFont():New( "Verdana",,16,,.F.,,,,,.F. )
	oFont11:= TFont():New( "Verdana",,08,,.T.,,,,,.F. )
	oFont12:= TFont():New( "Verdana",,10,,.T.,,,,,.F. )
	oFont13:= TFont():New( "Verdana",,12,,.T.,,,,,.F. )
	oFont14:= TFont():New( "Verdana",,14,,.T.,,,,,.F. ) 
	oFont15:= TFont():New( "Verdana",,16,,.T.,,,,,.F. )
	Do Case 
		Case pfFont == 1
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText, oFont1)
		Case pfFont == 2
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText, oFont2,,,,alinhamento)
		Case pfFont == 3				
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText, oFont3)
		Case pfFont == 4
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText, oFont4)
		Case pfFont == 5
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText, oFont5)		
		Case pfFont == 11
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText,oFont11)
		Case pfFont == 12
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText,oFont12)
		Case pfFont == 13				
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText,oFont13)
		Case pfFont == 14		
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText,oFont14)
		Case pfFont == 15
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText,oFont15)		
	EndCase	
Return

Static Function DrawH(dhRow,dhCol,dhWidth,dhPen)
	While dhPen >= 1
		oPrn:Line (nRD+(nRH*(dhRow-1))+(dhPen-1),nCD+(nCW*(dhCol-1)),nRD+(nRH*(dhRow-1))+(dhPen-1),nCD+(nCW*(dhWidth-1)) )
		dhPen:=dhPen-1
	EndDo
Return

Static Function DrawV(dvRow,dvCol,dvHeight,dvPen) 
	If dvRow==0 	//Ajuste para quando a linha comecar na posicao zero.
		nLineZero:=10
	Else
		nLineZero:=0
	EndIf
	While dvPen >= 1
		oPrn:Line (nRD+(nRH*(dvRow-1))+nLineZero,nCD+(nCW*(dvCol-1))+(dvPen-1),nRD+(nRH*(dvHeight-1)),nCD+(nCW*(dvCol-1))+(dvPen-1) )
		dvPen:=dvPen-1
	EndDo
Return

Static Function AchaVendedor()
	//SELECIONA O NOME DO VENDEDOR E O CODIGO
  	  cQuery1 := "SELECT A3_COD AS COD_VENDEDOR, A3_NOME AS NOME_VENDEDOR "
      cQuery1 += "FROM SA3"+ cEmp +"0" +" AS SA3 " 
      cQuery1 += "WHERE SA3.A3_COD = '" + MV_PAR03 +"'"
	  cQuery1 +=    " AND SA3.D_E_L_E_T_ <> '*'"
	  TCQUERY cQuery1 NEW ALIAS "TMPVEND"
	  MEMOWRITE("SLDVEND.SQL",CQUERY1)			
	  dbSelectArea("TMPVEND")
  	  ProcRegua(TMPVEND->(LastRec()))
	  dbGoTop()
	  cVendedor:= TMPVEND->Cod_Vendedor + " - " + TMPVEND->Nome_Vendedor
Return cVendedor