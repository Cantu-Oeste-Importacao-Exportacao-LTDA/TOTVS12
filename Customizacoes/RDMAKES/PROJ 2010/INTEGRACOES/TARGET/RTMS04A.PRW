#Include "Rwmake.ch"
#Include "Protheus.CH"

//-----------------------------------------------------------------------
/*/{Protheus.doc} RTMS04A
Efetua Impresssao do RPA  Especifico para CANTU

@author Davis Magalhães
@since  24/03/2014
@version 1.0

@param  N/H

@return Logico (.T. ou .F.)
/*/


User Function RTMS04A()
  
Local nOpc       	:= 0
Local aContMot 		:= {}
Local aContVei 		:= {}       
Local cAliasMot 	:= ""                                                                   
Local oDlg
Local cAliasVei 	:= ""
Local aSize       	:= MsAdvSize( .F. ) 
Local aObjects    	:= {}                                                  
Local bLine      	:= { || .T. }
Local cLine      	:= ""
Local nLoop      	:= 0
Local oPanel
Local aButtons		:= {}
Local oOk        	:= LoadBitMap(GetResources(), "LBOK")
Local oNo        	:= LoadBitMap(GetResources(), "LBNO")
Local lGspInUseM 	:= If(Type('lGspInUse')=='L', lGspInUse, .F.)

Private cDoc       := SF1->F1_DOC
Private cSerie	   := SF1->F1_SERIE
Private cPrefixo   := SF1->F1_PREFIXO
Private cFornece   := SF1->F1_FORNECE
Private cLoja      := SF1->F1_LOJA   
Private aF4Mot     := {}                                      
Private aF4Vei     := {}
Private aTitMot    := {}
Private aTitVei	   := {} 	 
Private oMark1, oMark2

Private aSizes     := {5,60,60,60,60}

If Alltrim(SF1->F1_ESPECIE) <> "FRETE"
	Aviso("DVM - Target","Favor acessar Registro que sejam de especio 'FRETE'",{"Voltar"},2,"RPA - Contrato")     
	Return
EndIf


 

cAliasMot := GetNextAlias()

cQryMot := "SELECT * FROM "+RetSqlName("DA4")
cQryMot += " WHERE D_E_L_E_T_ <> '*' AND DA4_FILIAL = '"+xFilial("DA4")+"'"
cQryMot += " AND DA4_FORNEC = '"+cFornece+"'"
cQryMot += " AND DA4_LOJA = '"+cLoja+"'"
cQryMot += " ORDER BY DA4_NOME "

cQryMot := ChangeQuery(cQryMot)
DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQryMot),cAliasMot,.T.,.T.)

                                                     


cAliasVei := GetNextAlias()

cQryVei := "SELECT * FROM "+RetSqlName("DA3")
cQryVei += " WHERE D_E_L_E_T_ <> '*' AND DA3_FILIAL = '"+xFilial("DA3")+"'"
cQryVei += " AND DA3_CODFOR = '"+cFornece+"'"
cQryVei += " AND DA3_LOJFOR = '"+cLoja+"'"
cQryVei += " ORDER BY DA3_PLACA"

cQryVei := ChangeQuery(cQryVei)
DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQryVei),cAliasVei,.T.,.T.)


                                                     

                    

// --                            

dbSelectArea(cAliasMot)
(cAliasMot)->( dbGoTop() )

While ! (cAliasMot)->( Eof() )

   		dbSelectArea(cAliasMot)        
   		      
   		aContMot  :=  {.F.,(cAliasMot)->DA4_COD,(cAliasMot)->DA4_NOME,(cAliasMot)->DA4_NUMCNH,(cAliasMot)->DA4_REGCNH,(cAliasMOT)->DA4_CATCNH }
		aAdd(aF4Mot , aContMot )
		
		(cAliasMot)->( dbSkip() )
		
End
        

dbSelectArea(cAliasMot)
(cAliasMot)->( dbCloseArea() )





           


If ( !Empty(aF4Mot) )
	
	
	aTitMot := {" ",RetTitle("DA4_COD"),RetTitle("DA4_NOME"),RetTitle("DA4_NUMCNH"),RetTitle("DA4_REGCNH"),RetTitle("DA4_CATCNH")} //"Medicao"###"Contrato"###"Planilha"###"Loja"###"Pedido"###"Emissao"###"Origem"
	//	cLine := "{If(aF4For[oListBox:nAt,1],oOk,oNo),aF4For[oListBox:nAT][2],aF4For[oListBox:nAT][3],aF4For[oListBox:nAT][4],aF4For[oListBox:nAT][5],aF4For[oListBox:nAT][6],aF4For[oListBox:nAT][7],aF4For[oListBox:nAT][8]"
	
EndIF


dbSelectArea(cAliasVei)
(cAliasVei)->( dbGoTop() )

While ! (cAliasVei)->( Eof() )

   		dbSelectArea(cAliasVei)        
   		      
   		aContVei  :=  {.F.,(cAliasVei)->DA3_COD,(cAliasVei)->DA3_PLACA,(cAliasVei)->DA3_DESC,(cAliasVei)->DA3_MUNPLA,(cAliasVei)->DA3_ESTPLA }
		aAdd(aF4Vei , aContVei )
		
		(cAliasVei)->( dbSkip() )
		
End
        

dbSelectArea(cAliasVei)
(cAliasVei)->( dbCloseArea() )



If ( !Empty(aF4Vei) )
	
	
	aTitVei := {" ",RetTitle("DA3_COD"),RetTitle("DA3_PLACA"),RetTitle("DA3_DESC"),RetTitle("DA3_MUNPLA"),RetTitle("DA3_ESTPLA")} //"Medicao"###"Contrato"###"Planilha"###"Loja"###"Pedido"###"Emissao"###"Origem"
	//	cLine := "{If(aF4For[oListBox:nAt,1],oOk,oNo),aF4For[oListBox:nAT][2],aF4For[oListBox:nAT][3],aF4For[oListBox:nAT][4],aF4For[oListBox:nAT][5],aF4For[oListBox:nAT][6],aF4For[oListBox:nAT][7],aF4For[oListBox:nAT][8]"
	
EndIF



// -- Inicio Davis 
                                  
        
aObjects := {} 
AAdd( aObjects, { 100, 100, .T., .T. } )
AAdd( aObjects, { 130, 100, .F., .T., .T. } )  

aInfo    := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 } 
aPosObj  := MsObjSize( aInfo, aObjects, .T., .T. )

cNomeFor := Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_NOME")
                                      
//DEFINE MSDIALOG oDlg FROM  120,78  TO 336,657 TITLE OemToAnsi(STR0034) PIXEL	//"Seleccion del Lote y Ubicacion"
DEFINE MSDIALOG oDlg FROM	 60,48  TO 386,707 TITLE OemToAnsi("Selecionar Motorista / Veiculo") OF oMainWnd PIXEL ///"Consulta Correlativos"
  
 //	oDlg:lMaximized := .F.
 //	oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,20,20)
 //	oPanel:Align := CONTROL_ALIGN_ALLCLIENT        
		
	@ 6  ,4   SAY OemToAnsi("Fornecedor") Of oPanel PIXEL SIZE 47 ,9 //"Fornecedor"
	@ 4  ,35  MSGET cNomeFor PICTURE PesqPict('SA2','A2_NOME') When .F. Of oPanel PIXEL SIZE 120,9

	
    @ 20,05 Say "Selecione Motorista"  Of oPanel PIXEL SIZE 47 ,9 //"Fornecedor"
                                                                                
	oMark1 := TWBrowse():New( 30,05,158,90,,aTitMot,aSizes,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oMark1:SetArray(aF4Mot)
	oMark1:bLDblClick 	:= { || F04Inv(@aF4Mot,@oMark1,oMark1:nAt ) }
	oMark1:bLine 	  	:= { || {If(aF4Mot[oMark1:nAt][1],oOk,oNo),aF4Mot[oMark1:nAT][2],aF4Mot[oMark1:nAT][3],aF4Mot[oMark1:nAT][4],aF4Mot[oMark1:nAT][5],aF4Mot[oMark1:nAT][6]} }
//	oMark1:Align 		:= CONTROL_ALIGN_ALLCLIENT

                                                                    
    @ 20,175 Say "Selecione Veiculo"  Of oPanel PIXEL SIZE 47 ,9 //"Fornecedor"
                                                                                
	oMark2 := TWBrowse():New( 30,170,158,90,,aTitVei,aSizes,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oMark2:SetArray(aF4Vei)
	oMark2:bLDblClick 	:= { || F04Inv(@aF4Vei,@oMark2,oMark2:nAt ) }//{ || aF4Vei[oMark2:nAt][1] := !aF4Vei[oMark2:nAt][1] }
	oMark2:bLine 	  	:= { || {If(aF4Vei[oMark2:nAt][1],oOk,oNo),aF4Vei[oMark2:nAT][2],aF4Vei[oMark2:nAT][3],aF4Vei[oMark2:nAT][4],aF4Vei[oMark2:nAT][5],aF4Vei[oMArk2:nAT][6]} }
  //	oMark2:Align 		:= CONTROL_ALIGN_ALLCLIENT

//	ACTIVATE MSDIALOG oDlg VALID (nOpca == 1 .And. A457VldOk(aDadosLote,aDadosLoca,nQtdLib))


//ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||(nOpc := 1,nF4Mot := oMark1:nAt,oDlg:End())},{||(nOpc := 0,nF4Mot := oMark1:nAt,oDlg:End())},,aButtons)
    
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||nOpc:=1,IIf(VTudOk(@aF4Mot, @aF4Vei, @oMark1, @oMark2,),oDlg:End(),nOpc := 0),.F.},{|| nOpc:=2,oDlg:End()},,aButtons)
// -- Final






   If nOpc == 1

      For nXm := 1 To Len(aF4Mot)
      
          If aF4Mot[nXm][1]
          	 cCodMot := aF4Mot[nXm][2] 
          	 Exit
          EndIf
      Next nXm
      
      For nXv := 1 To Len(aF4Vei)
      
          If aF4Vei[nXv][1]
          	 cCodVei := aF4Vei[nXv][2] 
          	 Exit
          EndIf
      Next nXv
      
//
		Processa({||FImpRel(cCodMot,cCodVei)},"Aguarde...","Processando Recibo/Contrato de transporte Rodoviario...")

EndIf


Return( Nil )



Static Function FImpRel(cMotorista,cVeiculo)
/****************************************************************************************
** Imprime Relatório
**
***************************/

Local oPrint
Local nLin 	   		:= 0
Local nNumLin  		:= 2000
Local nTamLin		:= 2370
Local nCol			:= 050                                                                                 
Local aBmp:= "logorpa.bmp"                                                                                 
Local cAliasSE2 := GetNextAlias()




//OBJETOS PARA TAMANHO E TIPO DE FONTES.
/*
Local oFont11 		:= TFont():New("Arial",,11,,.T.,,,,,.F.)
Local oFont11n 		:= TFont():New("Arial",,11,,.F.,,,,,.F.)
Local oFont0 		:= TFont():New("Arial",,12,,.T.,,,,,.F.)
Local oFont1 		:= TFont():New("Arial",,12,,.F.,,,,,.F.)
Local oFont12n		:= TFont():New('Arial',12,12,,.T.,,,,.T.,.F.)
Local oFont2 		:= TFont():New("Arial",,13,,.T.,,,,,.F.)
Local oFont3 		:= TFont():New("Arial",,16,,.T.,,,,,.F.)
Local oFont4 		:= TFont():New("Arial",,09,,.F.,,,,,.F.)
Local oFont5 		:= TFont():New("Arial",,12,,.F.,,,,,.F.)
Local oFont07		:= TFont():New('Arial',07,07,,.F.,,,,.T.,.F.)
Local oFont07n		:= TFont():New('Arial',07,07,,.T.,,,,.T.,.F.)
Local oFont08		:= TFont():New('Arial',08,08,,.F.,,,,.T.,.F.)
Local oFont08n 		:= TFont():New('Arial',08,08,,.T.,,,,.T.,.F.)
Local oFont09		:= TFont():New('Arial',09,09,,.F.,,,,.T.,.F.)
Local oFont09n 		:= TFont():New('Arial',09,09,,.T.,,,,.T.,.F.)
Local oFont10		:= TFont():New('Arial',10,10,,.F.,,,,.T.,.F.)
Local oFont10n 		:= TFont():New('Arial',10,10,,.T.,,,,.T.,.F.)
Local oFont12		:= TFont():New('Arial',12,12,,.F.,,,,.T.,.F.)
*/
Local oFont11 		:= TFont():New("Arial",,08,,.T.,,,,,.F.)
Local oFont11n 		:= TFont():New("Arial",,08,,.F.,,,,,.F.)
Local oFont0 		:= TFont():New("Arial",,09,,.T.,,,,,.F.)
Local oFont1 		:= TFont():New("Arial",,09,,.F.,,,,,.F.)
Local oFont12n		:= TFont():New('Arial',09,09,,.T.,,,,.T.,.F.)
Local oFont2 		:= TFont():New("Arial",,10,,.T.,,,,,.F.)
Local oFont3 		:= TFont():New("Arial",,13,,.T.,,,,,.F.)
Local oFont4 		:= TFont():New("Arial",,06,,.F.,,,,,.F.)
Local oFont5 		:= TFont():New("Arial",,09,,.F.,,,,,.F.)
Local oFont07		:= TFont():New('Arial',04,04,,.F.,,,,.T.,.F.)
Local oFont07n		:= TFont():New('Arial',04,04,,.T.,,,,.T.,.F.)
Local oFont08		:= TFont():New('Arial',05,05,,.F.,,,,.T.,.F.)
Local oFont08n 		:= TFont():New('Arial',05,05,,.T.,,,,.T.,.F.)
Local oFont09		:= TFont():New('Arial',06,06,,.F.,,,,.T.,.F.)
Local oFont09n 		:= TFont():New('Arial',06,06,,.T.,,,,.T.,.F.)
Local oFont10		:= TFont():New('Arial',07,07,,.F.,,,,.T.,.F.)
Local oFont10n 		:= TFont():New('Arial',07,07,,.T.,,,,.T.,.F.)
Local oFont12		:= TFont():New('Arial',09,09,,.F.,,,,.T.,.F.)

Local aSaveArea:=GetArea()
Local cAliasDTA := ""

cQuery := "SELECT * FROM "+RetSqlName("SE2")
cQuery += " WHERE E2_FILIAL = '"+xFilial("SE2")+"' AND D_E_L_E_T_ <> '*' "
cQuery += " AND E2_FORNECE = '"+cFornece+"'"
cQuery += " AND E2_LOJA = '"+cLoja+"'"
cQuery += " AND E2_NUM  = '"+cDoc+"'"
cQuery += " AND E2_PREFIXO = '"+cPrefixo+"'"
cQuery += " ORDER BY E2_NUM, E2_PARCELA , E2_VENCTO"


cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAliasSE2,.T.,.T.)

dbSelectArea(cAliasSE2)
(cAliasSE2)->( dbGoTop() )

If (cAliasSE2)->( Eof() )
	Aviso("DVM - TOTVS","Nao existem parcelas para Impressao..",{"Voltar"},2,"Target - Vectio")
	dbSelectArea(cAliasSE2)
	(cAliasSE2)->( dbCloseArea() )
	Return
EndIF




//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa Objeto TMSPrinter									        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrint	:= TMSPrinter():New(OemToAnsi("Contrato de Carreteiro"))
oPrint	:SetPortrait()  //SetLandscape(.T.)	//Paisagem... -- Retrato
oPrint:SetPaperSize(9)		//Papel A4
oPrint	:Setup()

nLin := nLin + 100

oPrint:Line(nLin,nCol,nLin,nTamLin) //Borda superior
oPrint:Line(nLin,nCol,nNumLin,nCol) //Borda esquerda
oPrint:Line(nLin,nTamLin,nNumLin,nTamLin) //Borda direita
oPrint:Line(nNumLin,nCol,nNumLin,nTamLin) //Borda inferior

//Inserir o logotipo
oPrint:SayBitmap(nLin+50,nCol+050,aBmp,500,200)//0175,0100

oPrint:Say(nLin+250,nCol+650,"cantu@cantu.com.br ",oFont11n )

//Recibo contratante de transporte rodoviario.
oPrint:Say(nLin+50,nCol+1290,"RECIBO/CONTRATO DE TANSPORTE",oFont12n )
oPrint:Say(nLin+100,nCol+1290,"RODOVIARIO DE BENS",oFont12n )

//Box com o Numero ex:004697
oPrint:Line(nLin,nCol+2050,nLin+200,nCol+2050) //Box para numeração da via
oPrint:Line(nLin+200,nCol+2050,nLin+200,nTamLin) //Fechamento do box da numeração da via
oPrint:Say(nLin+050,nCol+2100,"NUMERO",oFont12n )
oPrint:Say(nLin+100,nCol+2060,cDoc+"/"+cPrefixo,oFont1 ) //Variavel

oPrint:Say(nLin+200,nCol+650,"Site:www.cantu.com.br",oFont11n )
oPrint:Line(nLin,nCol+1100,nNumLin,nCol+1100) //Linha divisoria central.Vertical

oPrint:Say(nLin+50,nCol+650,Alltrim(SM0->M0_ENDCOB),oFont11n )
oPrint:Say(nLin+100,nCol+650,"Bairro: "+Alltrim(SM0->M0_BAIRCOB),oFont11n )
oPrint:Say(nLin+150,nCol+650,ALLTRIM(SM0->M0_CIDCOB)+"/"+SM0->M0_ESTCOB+"   CEP: "+Transform(SM0->M0_CEPCOB,"99999-999"),oFont11n )

//Box com o numero da via
oPrint:Line(nLin+150,nCol+1200,nLin+150,nCol+1550)//Borda superior
oPrint:Line(nLin+150,nCol+1200,nLin+200,nCol+1200)//Borda esquerda
oPrint:Line(nLin+150,nCol+1550,nLin+200,nCol+1550) //Borda direita
oPrint:Line(nLin+200,nCol+1200,nLin+200,nCol+1550) //Borda inferior
oPrint:Say(nLin+155,nCol+1270,"1º VIA - CAIXA",oFont12n )

//Dados do recebedor
oPrint:Say(nLin+250,nCol+1150,"Resp:",oFont11n )
oPrint:Say(nLin+250,nCol+1260,cUserName,oFont11n )//Variavel

oPrint:Say(nLin+250,nCol+1700,"Data:",oFont1 )
oPrint:Say(nLin+250,nCol+1780,Substr(dtos(dDataBase),7,2)+"/"+Substr(dtos(dDataBase),5,2)+"/"+Substr(dtos(dDataBase),1,4),oFont11n )//Variavel

oPrint:Line(nLin+300,nCol,nLin+300,nTamLin) //Linha divisoria horizontal

//Dados do contratante.
oPrint:Line(nLin+800,nCol,nLin+800,nTamLin) //Linha divisoria horizontal

oPrint:Say(nLin+350,nCol+30,"CONTRATANTE:",oFont12n )
oPrint:Say(nLin+350,nCol+280,Substr(SM0->M0_NOMECOM,1,40),oFont12) //vairal SM0
nLin:=nLin+50                
                                                            


oPrint:Say(nLin+400,nCol+30," Endereco: "+Alltrim(SM0->M0_ENDCOB),oFont11n )
oPrint:Say(nLin+450,nCol+30,"   Bairro: "+Alltrim(SM0->M0_BAIRCOB),oFont11n )
oPrint:Say(nLin+500,nCol+30,ALLTRIM(SM0->M0_CIDCOB)+"/"+SM0->M0_ESTCOB+"   CEP: "+Transform(SM0->M0_CEPCOB,"99999-999"),oFont11n )
oPrint:Say(nLin+550,nCol+30,"     CNPJ: "+Transform(SM0->M0_CGC,"99.999.999/9999-99"),oFont11n )
oPrint:Say(nLin+600,nCol+30,"Insc.Est.: "+ALLTRIM(SM0->M0_INSC),oFont11n)

/*
oPrint:Say(nLin+500,nCol+50,"FILIAIS:",oFont12n )
oPrint:Say(nLin+550,nCol+50,"OURO BRANCO:",oFont12n )//SM0  RUA+NUMERO+BAIRRO+TELEFONE
oPrint:Say(nLin+600,nCol+50,"BETIM:",oFont12n )//SM0  RUA+NUMERO+BAIRRO+TELEFONE+CEP
oPrint:Say(nLin+650,nCol+50,"SÃO JOSE DOS CAMPO:",oFont12n )//SM0  RUA+NUMERO+BAIRRO+TELEFONE+
oPrint:Say(nLin+700,nCol+50,"INCONHA:",oFont12n )//SM0  RUA+NUMERO+BAIRRO+TELEFONE+CEP+CIDADE+MUNICIPIO+ESTADO
*/

//Discriminação dos serivços prestados


	dbSelectArea("SA2")
	SA2->( dbSetOrder(1) )
	SA2->( dbSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA) )
	
	
	nPesoCarg   := SF1->F1_PBRUTO           
	cDocFiscal  := ""
	cNumCtr     := ""
	nValorMerc  := 0
	cMercadoria := ""
	cOrigem     := ""
	cDestino    := ""


oPrint:Say(nLin+350,nCol+1150,"DISCRIMINAÇÃO DOS SERVIÇOS CONTRADOS:",oFont12n )

//oPrint:Say(nLin+450,nCol+1150,"Nº Doc Fiscal:",oFont11n )
//oPrint:Say(nLin+450,nCol+1450,cDocFiscal,oFont11n )

oPrint:Say(nLin+450,nCol+1800,"Mercadoria:",oFont11n )
oPrint:Say(nLin+450,nCol+2000,"",oFont11n)

oPrint:Say(nLin+500,nCol+1150,"Valor da carga:",oFont11n )
oPrint:Say(nLin+500,nCol+1350,Transform(SF1->F1_VALBRUT,"@E 999,999,999.99"),oFont11n )

oPrint:Say(nLin+500,nCol+1800,"Peso:",oFont11n )
oPrint:Say(nLin+500,nCol+1900,Transform(nPesoCarg,"@E 9,999,999.999"),oFont11n )

oPrint:Say(nLin+600,nCol+1150,"Local do carregamento:",oFont11n)
oPrint:Say(nLin+600,nCol+1600," ",oFont11n )

oPrint:Say(nLin+650,nCol+1150,"Local do Descarregamento:",oFont11n)
oPrint:Say(nLin+650,nCol+1600,ALLTRIM(SM0->M0_CIDCOB)+"/"+SM0->M0_ESTCOB,oFont11n)

//Contratado.
oPrint:Line(nLin+1200,nCol,nLin+1200,nCol+1100) //Linha central contratado.
nLin:=nLin-50
oPrint:Say(nLin+850,nCol+50,"CONTRATADO:",oFont12n)

oPrint:Say(nLin+900,nCol+50,"Nome:",oFont11n)
oPrint:Say(nLin+900,nCol+200,Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_NOME"),oFont11n)

oPrint:Say(nLin+950,nCol+50,"End:",oFont11n)
oPrint:Say(nLin+950,nCol+200,Alltrim(Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_END"))+" - "+Alltrim(Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_BAIRRO")),oFont11n)

oPrint:Say(nLin+1000,nCol+50,"Tel:",oFont11n)
oPrint:Say(nLin+1000,nCol+200,"("+Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_DDD")+") "+Alltrim(Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_TEL")),oFont11n)

oPrint:Say(nLin+1000,nCol+600,"Cid:",oFont11n)
oPrint:Say(nLin+1000,nCol+700,Alltrim(Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_MUN")),oFont11n)

oPrint:Say(nLin+1050,nCol+050,"Cep:",oFont11n)
oPrint:Say(nLin+1050,nCol+200,Transform(Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_CEP"),"@R 99999-999"),oFont11n)

oPrint:Say(nLin+1050,nCol+400,"UF",oFont11n)
oPrint:Say(nLin+1050,nCol+450,Alltrim(Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_EST")),oFont11n)

oPrint:Say(nLin+1050,nCol+600,"Insc. INSS:",oFont11n)
oPrint:Say(nLin+1050,nCol+800,Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_CODINSS"),oFont11n)

oPrint:Say(nLin+1100,nCol+50,"CNPJ/CPF:",oFont11n)

If Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_TIPO") == "J"
	oPrint:Say(nLin+1100,nCol+200,Transform(Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_CGC"),"@R 99.999.999/9999-99"),oFont11n)
Else
	oPrint:Say(nLin+1100,nCol+200,Transform(Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_CGC"),"@R 999.999.999-99"),oFont11n)
EndIf


//Observações:
oPrint:Say(nLin+850,nCol+1150,"Observações:",oFont12n )
//Disoria Observações
oPrint:Line(nLin+900,nCol+1100,nLin+900,nTamLin) //Linha divisoria observações.

oPrint:Line(nLin+1600,nCol,nLin+1600,nTamLin) //Linha central Motorista
                                           
dbSelectArea("DA4")
DA4->( dbSetOrder(1) )
DA4->( dbSeek(xFilial("DA4")+cMotorista) )
oPrint:Say(nLin+1250,nCol+50,"MOTORISTA:",oFont12n)

oPrint:Say(nLin+1300,nCol+50,"Nome:",oFont11n)
oPrint:Say(nLin+1300,nCol+200,DA4->DA4_NOME,oFont11n)

oPrint:Say(nLin+1350,nCol+50,"Endereco:",oFont11n)
oPrint:Say(nLin+1350,nCol+200,Alltrim(DA4->DA4_END)+" - "+Alltrim(DA4->DA4_BAIRRO),oFont11n)

oPrint:Say(nLin+1400,nCol+50,"Tel:",oFont11n)
oPrint:Say(nLin+1400,nCol+200,"("+Alltrim(DA4->DA4_DDD)+") "+ALLTRIM(DA4->DA4_TEL),oFont11n)

oPrint:Say(nLin+1400,nCol+500,"Cidade:",oFont11n)
oPrint:Say(nLin+1400,nCol+600,Alltrim(DA4->DA4_MUN),oFont11n)

oPrint:Say(nLin+1450,nCol+50,"Cep:",oFont11n)
oPrint:Say(nLin+1450,nCol+200,Transform(DA4->DA4_CEP,"@R 99999-999"),oFont11n)

oPrint:Say(nLin+1450,nCol+500,"UF:",oFont11n)
oPrint:Say(nLin+1450,nCol+600,DA4->DA4_EST,oFont11n)

oPrint:Say(nLin+1450,nCol+800,"CNH:",oFont11n)
oPrint:Say(nLin+1450,nCol+900,DA4->DA4_NUMCNH,oFont11n)

oPrint:Say(nLin+1500,nCol+50,"Ident nº:",oFont11n)
oPrint:Say(nLin+1500,nCol+200,Alltrim(DA4->DA4_RG),oFont11n)

oPrint:Say(nLin+1500,nCol+500,"Orgao Exp:",oFont11n)
oPrint:Say(nLin+1500,nCol+700,DA4->DA4_RGORG,oFont11n)

oPrint:Say(nLin+1550,nCol+50,"CPF:",oFont11n)
oPrint:Say(nLin+1550,nCol+200,Transform(DA4->DA4_CGC,"@R 999.999.999-99"),oFont11n)

//Valores dos serviços contratados
oPrint:Say(nLin+910,nCol+1150,"Valor dos serviços contratados:",oFont12n)

//Clausulas do contrato
oPrint:Say(nLin+950,nCol+1950,"Cláusulas do",oFont12n)
oPrint:Say(nLin+1000,nCol+1950,"Contrato abaixo.",oFont12n)

oPrint:Say(nLin+1150,nCol+1950," De acordo.",oFont12n)
oPrint:Say(nLin+1250,nCol+1930,"__________________",oFont1)
oPrint:Say(nLin+1300,nCol+1950,"Ass.do Contratado.",oFont12n)

oPrint:Say(nLin+1500,nCol+1930,"__________________",oFont1)
oPrint:Say(nLin+1550,nCol+1950,"Ass.do Contratante.",oFont12n)



oPrint:Say(nLin+950,nCol+1400,"Valor",oFont12n)
oPrint:Say(nLin+950,nCol+1700,"Data/Doct",oFont12n)

oPrint:Say(nLin+1000,nCol+1150,"Transportes",oFont1)
oPrint:Say(nLin+1000,nCol+1450,Transform(SF1->F1_VALBRUT,"@E 999,999.99"),oFont1)

oPrint:Say(nLin+1050,nCol+1150,"Pedagio",oFont1)
oPrint:Say(nLin+1050,nCol+1450,Transform(0,"@E 999,999.99"),oFont1)

oPrint:Say(nLin+1100,nCol+1150,"Diarias",oFont1)
oPrint:Say(nLin+1100,nCol+1450,Transform(0,"@E 999,999.99"),oFont1)

nTotalCr := SF1->F1_vALBRUT
oPrint:Say(nLin+1150,nCol+1150,"Total",oFont1)
oPrint:Say(nLin+1150,nCol+1450,Transform(nTotalCr,"@E 999,999.99"),oFont1)

//	oPrint:Say(nLin+1200,nCol+1150,"Adiantamento",oFont1)
//	oPrint:Say(nLin+1200,nCol+1400,"XXXXX:",oFont1)

oPrint:Say(nLin+1250,nCol+1150,"Adiantamento: ",oFont1)
oPrint:Say(nLin+1250,nCol+1450,Transform(0,"@E 999,999.99"),oFont1)

oPrint:Say(nLin+1300,nCol+1150,"Sest/Senat:",oFont1)
oPrint:Say(nLin+1300,nCol+1450,Transform((cAliasSE2)->E2_SEST,"@E 999,999.99"),oFont1)

oPrint:Say(nLin+1350,nCol+1150,"INSS:",oFont1)
oPrint:Say(nLin+1350,nCol+1450,Transform((cAliasSE2)->E2_INSS,"@E 999,999.99"),oFont1)

oPrint:Say(nLin+1400,nCol+1150,"Imposto de Renda",oFont1)
oPrint:Say(nLin+1400,nCol+1450,Transform((cAliasSE2)->E2_IRRF,"@E 999,999.99"),oFont1)

oPrint:Say(nLin+1450,nCol+1150,"Outros",oFont1)
oPrint:Say(nLin+1450,nCol+1450,Transform(0,"@E 999,999.99"),oFont1)

//nSaldoFre := nTotalCr - (DTY->DTY_ADIFRE +DTY->DTY_SEST + DTY->DTY_INSS + DTY->DTY_IRRF+DTY->DTY_OUTROS)
oPrint:Say(nLin+1500,nCol+1150,"Saldo de frete",oFont1)
oPrint:Say(nLin+1500,nCol+1450,Transform((cAliasSE2)->E2_VALOR,"@E 999,999.99"),oFont1)

oPrint:Line(nLin+960,nCol+1650,nLin+1600,nCol+1650) //linha vertical apos o valor do serviço contratado.
oPrint:Line(nLin+900,nCol+1900,nLin+1600,nCol+1900) //Linha vertical apo da data do docto

oPrint:Say(nLin+1650,nCol+50,"VEÍCULO:",oFont12n)

dbSelectArea("DA3")                                           

DA3->( dbSetORder(1) )
DA3->( dbSeek(xFilial("DA3")+cVeiculo) )
  
oPrint:Say(nLin+1700,nCol+50,"Marca:",oFont11n)
oPrint:Say(nLin+1700,nCol+250,Posicione("SX5",1,xFilial("SX5")+"M6"+DA3->DA3_MARVEI,"X5_DESCRI"),oFont11n)

oPrint:Say(nLin+1700,nCol+600,"Modelo:",oFont11n)
oPrint:Say(nLin+1700,nCol+750,Alltrim(DA3->DA3_DESC),oFont11n)

oPrint:Say(nLin+1750,nCol+50,"Chassi:",oFont11n)
oPrint:Say(nLin+1750,nCol+250,DA3->DA3_CHASSI,oFont11n)

oPrint:Say(nLin+1750,nCol+600,"Cor:",oFont11n)
oPrint:Say(nLin+1750,nCol+750,Posicione("SX5",1,xFilial("SX5")+"M7"+DA3->DA3_CORVEI,"X5_DESCRI"),oFont11n)

oPrint:Say(nLin+1800,nCol+50,"Placa",oFont11n)
oPrint:Say(nLin+1800,nCol+250,DA3->DA3_PLACA,oFont11n)

oPrint:Say(nLin+1800,nCol+600,"Ano Fab:",oFont11n)
oPrint:Say(nLin+1800,nCol+750,DA3->DA3_ANOFAB,oFont11n)

oPrint:Say(nLin+1850,nCol+50,"Renavam:",oFont11n)
oPrint:Say(nLin+1850,nCol+250,DA3->DA3_RENAVA,oFont11n)
             
cExtUm	:=	Alltrim(Extenso((cAliasSE2)->E2_VALOR))


cExt01 := Substr(cExtUM,1,80)
cExt02 := Substr(cExtUM,81,80)

oPrint:Say(nLin+1650,nCol+1150,"Recebi(emos)de "+alltrim(SM0->M0_NOMECOM)+",",oFont11n)
oPrint:Say(nLin+1700,nCol+1150,"  a importancia supra acima descriminada",oFont11n)
oPrint:Say(nLin+1750,nCol+1150,"( "+cExt01+Iif(Empty(cExt02)," )",""),oFont10n)
oPrint:Say(nLin+1800,nCol+1150,cExt02+Iif(! Empty(cExt02)," )",""),oFont10n)

oPrint:Say(nLin+1850,nCol+1150,"Ass.do recebedor:______________________________________",oFont10n)


//				CONTRATO DE TRANSPORTE RODOVIÁRIO DE BENS
nLin:=nLin-110
oPrint:Say(nLin+2050,nCol+750,"CONTRATO DE TRANSPORTE RODOVIÁRIO DE BENS",oFont12n)
oPrint:Say(nLin+2100,nCol+1000,"Condições Gerais",oFont12n)
nLin:=nLin-30
oPrint:Say(nLin+2200,nCol+50,"CONTRATO PARTICULAR DE TRANSPORTE RODOVIÁRIO DE BENS (CARGAS) QUE ENTRE SI FAZEM A CONTRATANTE, "+aLLTRIM(SM0->M0_NOMECOM),oFont11n)
oPrint:Say(nLin+2250,nCol+50,"E O CONTRATADO IDENTIFICADO ACIMA DESTE, SOB AS CLAUSULAS E CONDIÇÕES:",oFont11n)
nLin:=nLin-60
oPrint:Line(nLin+2390,nCol+1200,nLin+4000,nCol+1200) //linha vertical para dividir as clausulas do contrato.

oPrint:Say(nLin+2400,nCol+50,"1° - O objetivo do presente contrato e a realização de prestação dos",oFont10)
oPrint:Say(nLin+2450,nCol+50,"serviços de transporte rodoviário de bens (cargas) dos materiais ",oFont10)
oPrint:Say(nLin+2500,nCol+50,"entregues pela contratante ao contratado ambos identificados ",oFont10)
oPrint:Say(nLin+2550,nCol+50,"acima do presente contrato.",oFont10)

oPrint:Say(nLin+2650,nCol+50,"2° - DAS OBRIGAÇÕES E RESPONSABILIDADES DO CONTRATANTE",oFont11n)
oPrint:Say(nLin+2750,nCol+50,"2.1 - Fornecer ao contratado toda a documentação da mercadoria a ",oFont10)
oPrint:Say(nLin+2800,nCol+50,"ser transportada, bem como a documentação relativa ao transporte, ",oFont10)
oPrint:Say(nLin+2850,nCol+50,"tudo de conformidade com a legislação pertinente em vigor. ",oFont10)
nLin:=nLin-50

oPrint:Say(nLin+3000,nCol+50,"2.2 - Assumir o ônus e a responsabilidade do seguro obrigatório das",oFont10)
oPrint:Say(nLin+3050,nCol+50,"cargas",oFont1)
oPrint:Say(nLin+3150,nCol+50,"2.3 - Efetuar o pagamento contra a apresentação das vias exigidas,",oFont10)
oPrint:Say(nLin+3200,nCol+50,"do valor liquido constante acima deste, no recibo da quitação ",oFont10)
oPrint:Say(nLin+3250,nCol+50,"referente a prestação dos serviços contratados.",oFont10)

oPrint:Say(nLin+3350,nCol+50,"3° - DAS OBRIGAÇÕES E RESPONSABILIDADES DO CONTRATADO (A)",oFont10n)
oPrint:Say(nLin+3450,nCol+50,"3.1 - Conservar matérias que lhe são confiados para o transporte nas ",oFont10)
oPrint:Say(nLin+3500,nCol+50,"mesmas condições que recebeu.",oFont10)
nLin:=nLin+50
oPrint:Say(nLin+2400,nCol+1250,"3.2 - Comunicar imediatamente à contratante quaisquer anormalidades  ",oFont10)
oPrint:Say(nLin+2450,nCol+1250,"ocorridas durante o transporte usando para isto os telefones constantes .",oFont10)
oPrint:Say(nLin+2500,nCol+1250,"acima deste.",oFont10)

oPrint:Say(nLin+2600,nCol+1250,"3.3 - Sujeitar-se a concordar com os descontos decorrentes de quebras   ",oFont10)
oPrint:Say(nLin+2650,nCol+1250,"ou avarias com as mercadorias transportadas, bem como com diferença    ",oFont10)
oPrint:Say(nLin+2700,nCol+1250,"de peso faltante na entrega, que exceder aos limites legais,cujos",oFont10)
oPrint:Say(nLin+2750,nCol+1250,"valores serão deduzidos a titulo de redução do frete a pagar.",oFont10)

oPrint:Say(nLin+2850,nCol+1250,"3.4 - Compromisso de receber o saldo constate neste contrato junto a   ",oFont10)
oPrint:Say(nLin+2900,nCol+1250,"matriz, filiais ou postos de abastecimento credenciados, após a   ",oFont10)
oPrint:Say(nLin+2950,nCol+1250,"entrega da mercadoria ao destinatário, apresentando a via  ",oFont10)
oPrint:Say(nLin+3000,nCol+1250,"comprovante de entrega do conhecimento de transporte.",oFont10)

oPrint:Say(nLin+3100,nCol+1250,"3.5 - Todas as despesas decorrentes dos serviços ora contratos, serão   ",oFont10)
oPrint:Say(nLin+3150,nCol+1250,"por conta e responsabilidade do CONTRATADO, inclusive encargos     ",oFont10)
oPrint:Say(nLin+3200,nCol+1250,"sociais,previdenciários, manutenção, reparos.",oFont10)

oPrint:Say(nLin+3300,nCol+1250,"4° - Seguir as instruções do plano de viagem, parar somente nos   ",oFont10)
oPrint:Say(nLin+3350,nCol+1250,"locais previstos. ",oFont10)
oPrint:Say(nLin+3450,nCol+1250,"5° - E assim, por estarem justos e contratados, firma o presente contrato,    ",oFont10)
oPrint:Say(nLin+3500,nCol+1250,"acima deste,elegendo o foro de Ouro Preto, Estado de Minas Gerais, ",oFont10)
oPrint:Say(nLin+3550,nCol+1250,"para dirimir as duvidas do mesmo.",oFont10)

oPrint:EndPage()
oPrint:Preview()

dbSelectArea(cAliasSE2)
(cAliasSE2)->( dbCloseArea() )

Return()


//-----------------------------------------------------------------------
/*/{Protheus.doc} F04INV             

Efetua Reversao da Marcacao do Browse de Motorista

@author Davis Magalhães
@since  30/01/2013
@version 1.0

@param  1 - Objeto
		2 - Array
		3 - Linha

@return Logico (.T. ou .F.)
/*/

  
                         
Static Function F04Inv(aDados, oObj, nLinha )

Local nXy 	:= 0
Local oOk   := LoadBitMap(GetResources(), "LBOK")
Local oNo   := LoadBitMap(GetResources(), "LBNO")                         

For nXy := 1 To Len(aDados)
	
	If nXy <> nLinha	
	   aDados[Nxy][1] := .F. //oNo	         
	Else                                                      
	   If aDados[Nxy][1]
	      
	      aDados[Nxy][1] := .F.
	   Else
	                       
	   	  aDados[Nxy][1] := .T. 	
	   	  
	   EndIf	
	EndIf                                              
    
Next nXy

oObj:Refresh()
     

Return( Nil )      

Static Function VTudOk(aDados1, aDados2, oObj1, oObj2 )

Local nXy1 	:= 0
Local nXy2 	:= 0
Local lRet	:= .F.



For nXy1 := 1 To Len(aDados1)
	    
	If aDados1[Nxy1][1]
	   lRet := .T.
	   Exit
	EndIf
Next Nxy

If LRet

   For nXy2 := 1 To Len(aDados2)
	    
	If aDados2[Nxy2][1]
	   lRet := .T.
	   Exit  
	Else
	   lRet := .F.
	EndIf
Next Nxy2             


EndIf

If ! lRet
   Aviso("TOTVS x TARGET","Voce deve marcar um Motorista e um Veiculo para Impressao do RPA.",{"Voltar"},2,"Impressao RPA")
EndIf

Return(lRet)