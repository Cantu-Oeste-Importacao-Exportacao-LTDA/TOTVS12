User Function MT103LDV()
aDADOS	 := ParamIxb[1]   
nPosDoc  := aScan( aDADOS,{|x| ALLTRIM(x[1]) == "D1_NFORI" } )
nPosSeri := aScan( aDADOS,{|x| ALLTRIM(x[1]) == "D1_SERIORI" } )
nPosItem := aScan( aDADOS,{|x| ALLTRIM(x[1]) == "D1_ITEMORI" } )
nPosProd := aScan( aDADOS,{|x| ALLTRIM(x[1]) == "D1_COD" } )
cDoc     := aDADOS[nPosDoc, 2]   
cSerie 	 := aDADOS[nPosSeri, 2]
cItem	 := aDADOS[nPosItem, 2]
cProd	 := aDADOS[nPosProd, 2]
cClvl  	 := ""
cCusto	 := ""  

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())
 
If Len(aDADOS) > 0
  SF2->(dbSelectArea("SF2"))
	SF2->(DbSetOrder(1))
	SF2->(DbGoTop())
	If SF2->(DbSeek(xFilial("SF2")+cDoc+cSerie))
		cFornece := SF2->F2_CLIENTE
		cLoja    := SF2->F2_LOJA
	Endif
	
	// Seta a esp�cie da NF de Entrada de acordo com a sa�da
	cEspecie := SF2->F2_ESPECIE
	
	SD2->(dbSelectArea("SD2"))
  	SD2->(DbSetOrder(3))
	SD2->(DbGoTop())                                                                                                             
	If SD2->(DbSeek(xFilial("SD2")+cDoc+cSerie+cFornece+cLoja+cProd+cItem))
  		cClvl  := SD2->D2_CLVL 
  		cConta := SD2->D2_CONTA 
  		cCusto := SD2->D2_CCUSTO                                   
  	EndIf
  	
  	nPOS := aScan( aDADOS, {|x| ALLTRIM(x[1]) == "D1_CLVL" } )
  	If nPOS == 0                          
  		aAdd(aDADOS, {"D1_CLVL", cClvl, Nil})   
  	EndIf
  	
   	nPOS := aScan( aDADOS, {|x| ALLTRIM(x[1]) == "D1_CC" } )                                                     
  	If nPOS == 0                        
   		aAdd(aDADOS, {"D1_CC", cCusto, Nil})  
  	EndIf
  	
  	nPOS := aScan( aDADOS, {|x| ALLTRIM(x[1]) == "D1_CONTA" } )                                                     
  	If nPOS == 0                        
   		aAdd(aDADOS, {"D1_CONTA", cConta, Nil})  
  	EndIf    
  	
  	nPOS := aScan( aDADOS, {|x| ALLTRIM(x[1]) == "D1_RATEIO" } )                                                     
  	If nPOS == 0                        
   		aAdd(aDADOS, {"D1_RATEIO", "2", Nil})  
  	EndIf    
    
EndIf           

Return (aDADOS) 

// Flavio - 29/09/2011
// Retorna a esp�cie da nota fiscal quando devolu��o e formul�rio pr�prio
User Function MT103ESP()
Local cEsp := cEspecie

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

if cFormul == 'S' .And. cTipo == 'D'
	cEsp := "SPED"
EndIf
Return cEsp