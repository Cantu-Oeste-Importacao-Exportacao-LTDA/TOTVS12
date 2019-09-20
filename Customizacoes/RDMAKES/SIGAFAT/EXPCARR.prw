#INCLUDE "rwmake.ch"                     
#INCLUDE "TopConn.ch"                                      

User Function ExpCarr()

Private oGeraTxt
Private cPerg := "EXPCARR"
ValidPerg()
Pergunte(cPerg,.F.)    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

@ 200,001 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Arquivo NFs Carrefour - Invoic")
@ 002,010 TO 080,190
@ 010,018 Say " Este programa ira gerar um arquivo texto, de acordo com layout Invoic "
@ 018,018 Say "da Neogrid."
@ 60,090 BMPBUTTON TYPE 01 ACTION OkGeraTxt()
@ 60,120 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 60,150 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oGeraTxt Centered

Return                       

Static Function OkGeraTxt
nSeqRem := 0
cSeqLin	:= StrZero(1,6)            
Private nHdl := fCreate(AllTrim(mv_par01)+"CARREFOUR"+DtoS(dDataBase)+".txt")   //DATE()

Private cEOL := "CHR(13)+CHR(10)"
If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

If nHdl == -1
    MsgAlert("O arquivo de nome "+mv_par01+"CARREFOUR"+DtoS(dDataBase)+".txt nao pode ser executado! Verifique os parametros.","Atencao!")
    Return
Endif
		/*Função da Barra de Status da Geração do Arquivo*/
Processa({|| RunCont() },"Processando...")
Return

Static Function RunCont

Local nTamLin, cLin, cCpo
nTamLin := 600
cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao 
nSeqReg	:= 1

						/* ## 01 - HEADER ## */

cSql := "SELECT F2.F2_TIPO, F2.F2_DOC, F2.F2_SERIE, F2.F2_EMISSAO, F2.F2_HORA, C5.C5_NUM, F2.F2_DUPL, F2.F2_LOJA, " 
cSql += "		C5.C5_MDCONTR, C5.C5_TABELA, A1.A1_CGC, A4.A4_CGC, A4.A4_NOME, C5.C5_TPFRETE, F2.F2_FILIAL, F2.F2_CLIENTE, "
cSql += "		F2.F2_DESCONT, F2.F2_FRETE, F2.F2_SEGURO, F2.F2_VALBRUT, F2.F2_PBRUTO, F2.F2_PLIQUI, F2.F2_VALMERC, "
cSql += "		F2.F2_BASEICM, F2.F2_VALICM, F2.F2_BRICMS, F2.F2_BASEIPI, F2.F2_VALIPI, F2.F2_TIPO, F3.F3_CFO "
cSql += "FROM "+RetSqlName("SF2")+" F2 "
cSql += "LEFT JOIN "+RetSqlName("SC5")+" C5 ON "
cSql += "		F2.F2_FILIAL  = C5.C5_FILIAL  AND "
cSql += "		F2.F2_DOC	  = C5.C5_NOTA    AND "
cSql += "		F2.F2_SERIE   = C5.C5_SERIE   AND "
cSql += "   F2.F2_CLIENTE = C5.C5_CLIENTE "
cSql += "LEFT JOIN "+RetSqlName("SF3")+" F3 ON "
cSql += "   F2.F2_FILIAL  = F3.F3_FILIAL  AND "
cSql += "   F2.F2_DOC     = F3.F3_NFISCAL AND "
cSql += "   F2.F2_SERIE   = F3.F3_SERIE   AND "
cSql += "   F2.F2_CLIENTE = F3.F3_CLIEFOR " 
cSql += "LEFT JOIN "+RetSqlName("SA1")+" A1 ON "
cSql += "		F2.F2_CLIENTE = A1.A1_COD     AND "
cSql += "		F2.F2_LOJA    = A1.A1_LOJA "
cSql += "LEFT JOIN "+RetSqlName("SA4")+" A4 ON "
cSql += "		C5.C5_TRANSP  = A4.A4_COD "
cSql += "WHERE "                      
cSql += "   F2.D_E_L_E_T_ <> '*' AND "
cSql += "   C5.D_E_L_E_T_ <> '*' AND "
			/* Seleciona Todas as NFs exceto as de Devolução e as NFs já enviadas via EDI */ 
cSql += "   F2.F2_TIPO   <> 'D'  AND "
cSql += "   F2.F2_EXPEDI <> 'S'  AND "
cSql += "   F2.F2_FILIAL = '"+xFilial("SF2")+"' AND "
cSql += "   F2.F2_EMISSAO BETWEEN '"+DtoS(mv_par02)+"' AND '"+DtoS(mv_par03)+"' AND "      
cSql += "   F2.F2_CLIENTE BETWEEN '"+mv_par04+"' AND '"+mv_par06+"' "

TcQuery cSql NEW ALIAS "TMP1"
TMP1->(dbSelectArea("TMP1"))
TMP1->(dbGoTop())

ProcRegua(RecCount()) 
While !TMP1->(EOF())
		
	IncProc()
  cLin := ""                                        
	cLin += "01"        							  							//Código do Registro
	cLin += PadR("9",3," ")							  						//Função da Mensagem (1-Cancelamento, 2-Adição, 9-Original, 42-Confirmação)                             
	cLin += "383"								      								//Tipo da Nota (325-NF Conferência, 380-Fat.Com., 381-NF Cred., 383-NF Déb., 385-Fat.Consolid.)                                    
	cLin += StrZero(Val(TMP1->F2_DOC),9)			  			//Número da Nota Fiscal
	cLin += PadR(TMP1->F2_SERIE,3," ")  	  		  		//Série da NF  
  cLin += Space(2)								  								//Subsérie da NF
  cLin += TMP1->F2_EMISSAO+(SubStr(TMP1->F2_HORA,1,2))+(SubStr(TMP1->F2_HORA,4,2))		//Data - hora emissão da NF
  cLin += TMP1->F2_EMISSAO+(SubStr(TMP1->F2_HORA,1,2))+(SubStr(TMP1->F2_HORA,4,2))    //Data - hora despacho NF
  cLin += StrZero(0,12)    		    			  					//Data - hora entrega NF    
  cLin += PadR(TMP1->F3_CFO,5," ")				  				//Código Fiscal de Operações e Prestações (CFOP)
  cLin += Space(20)                   			  			//Nro Pedido do Comprador
  cLin += PadR(TMP1->C5_NUM,20," ") 			      		//Nro Pedido Sistema de Emissão
  cLin += PadR(TMP1->C5_MDCONTR,15," ")			  			//Código do Contrato
	cLin += PadR(TMP1->C5_TABELA,15," ")		      		//Código da Tabela de Preço
  cLin += StrZero(0,65)							  							//Códigos EAN: Comprador, Cobrança, Local Entrega, Fornecedor, Emissor Nota
  cLin += StrZero(Val(TMP1->A1_CGC),14)             //CNPJ Comprador
  cLin += StrZero(Val(TMP1->A1_CGC),14)             //CNPJ Cobrança Fatura
  cLin += StrZero(Val(TMP1->A1_CGC),14)             //CNPJ Local Entrega
  cLin += StrZero(Val(SM0->M0_CGC),14)              //CNPJ Fornecedor
	cLin += StrZero(Val(SM0->M0_CGC),14)              //CNPJ Emissor da NF
	cLin += PadR(SM0->M0_ESTCOB,2," ")				  			//Estado Emissor da NF
	cLin += PadR(SM0->M0_INSC,20," ")				  				//Inscrição Emissor da NF
	cLin += "251"						  			  								//Tipo Código Transportadora(251-CNPJ)			
	cLin += StrZero(Val(TMP1->A4_CGC),14)    			  	//Código da Transportadora(CNPJ)
	cLin += SubStr(TMP1->A4_NOME,1,30)				  			//Nome da Transportadora
	cTipoFrete := ""
	if AllTrim(TMP1->C5_TPFRETE) == "C"
		cTipoFrete := "CIF"
	elseIf AllTrim(TMP1->C5_TPFRETE) == "F"
		cTipoFrete := "FOB"
	Endif                      
	cLin += PadR(cTipoFrete,3," ")                    //Condição de Entrega (tipo de frete - CIF ou FOB)                   
	cLin += cEOL				
					
	
				/* FINAL GRAVAÇÃO REGISTRO HEADER */
	
					/* ## 02 - PAGAMENTO ## */
	
	cSqlTit := "SELECT  E1.E1_FILIAL, E1.E1_PREFIXO, E1.E1_NUM, E1.E1_PARCELA, E1.E1_CLIENTE, E1.E1_LOJA, "
	cSqlTit += "		E1.E1_VENCTO, E1.E1_VALOR "
	cSqlTit += "FROM "+RetSqlName("SE1")+" E1 "
	cSqlTit += "WHERE "
	cSqlTit += "		E1.E1_FILIAL  = '"+TMP1->F2_FILIAL+"'  AND "
	cSqlTit += "		E1.E1_PREFIXO = '"+TMP1->F2_SERIE+"'   AND "
	cSqlTit += "		E1.E1_NUM     = '"+TMP1->F2_DUPL+"'    AND "
	cSqlTit += "		E1.E1_CLIENTE = '"+TMP1->F2_CLIENTE+"' AND "
	cSqlTit += "    E1.D_E_L_E_T_ <> '*' "
	
	TcQuery cSqlTit NEW ALIAS "TMP2"
	TMP2->(dbSelectArea("TMP2"))
	TMP2->(dbGoTop())
	
	ProcRegua(RecCount()) 
	While !TMP2->(EOF())
		cLin += "02"									  									//Tipo de Registro ("02")
		cLin += PadR("1"  ,3," ") 						  					//Condição de pagamento(1-Simples)
		cLin += PadR("66" ,3," ")                         //Referência de Data(66-Data Estipulada no Campo data Vcto)
		cLin += PadR("1"  ,3," ")					 	  						//Referência de Tempo(1-Na data de referência)
		cLin += PadR("D"  ,3," ")						  						//Tipo de Período(D-Dia)
		cLin += StrZero(0,3)     						  						//Número de Períodos
		cLin += TMP2->E1_VENCTO       				      			//Data de Vencimento
		cLin += "12E"									  									//Tipo Percentual(12E-Perc. do Valor do Título ou Valor da Parcela)
		pConPag := Round((TMP2->E1_VALOR*100)/TMP1->F2_VALBRUT,2)
		cLin += StrZero(pConPag*100,5)					  				//Percentual da Cond. de Pagamento
		cLin += "262"									  									//Tipo de Valor da Condição(262-Valor a Pagar ou da Parcela)
		cLin += StrZero(TMP2->E1_VALOR*100,15)            //Valor da Condição de Pagamento
		cLin += cEOL
	
		TMP2->(DbSelectArea("TMP2"))
	    TMP2->(dbSkip())
	    
	EndDo
	TMP2->(DbCloseArea())
					
					
				/* FINAL GRAVAÇÃO REGISTRO 02 - PAGAMENTO*/
	
			  /* ## 03 - DESCONTOS E ENCARGOS DA NOTA ## */
			   		
	cLin += "03"									  //Tipo de Registro
	        
	vDescFin := TMP1->F2_DESCONT
	pDescFin := Round((vDescFin*100)/TMP1->F2_VALBRUT, 2)
	
	cLin += StrZero(pDescFin*100,5)			          //Percentual Desconto Financeiro
	cLin += StrZero(vDescFin*100,15)			      	//Valor Desconto Financeiro
	cLin += StrZero(0,5)							  					//Percentual Desconto Comercial
	cLin += StrZero(0,15)							  					//Valor Desconto Comercial
	cLin += StrZero(0,5)							  					//Percentual Desconto Promocional
	cLin += StrZero(0,15)							  					//Valor Desconto Promocional
	cLin += StrZero(0,5)							  					//Percentual Encargos Financeiros
	cLin += StrZero(0,15)							  					//Valor Encargos Financeiros
	
	vEncFret := TMP1->F2_FRETE
	pEncFret := Round((vEncFret*100)/TMP1->F2_VALBRUT, 2)
	
	cLin += StrZero(pEncFret*100,5)			          //Percentual Encargos de Frete
	cLin += StrZero(vEncFret*100,15)	    	      //Valor Encargos de Frete
	
	vEncSegu := TMP1->F2_SEGURO
	pEncSegu := Round((vEncSegu*100)/TMP1->F2_VALBRUT, 2)		
	
	cLin += StrZero(pEncSegu*100,5)			  		  	//Percentual Encargos de Seguro
	cLin += StrZero(vEncSegu*100,15)			      	//Valor Encargos de Seguro
	cLin += cEOL			
					          
			   /* FINAL GRAVAÇÃO REGISTRO 03 - DESCONTOS E ENCARGOS DA NOTA*/
	
			  				/* ## 04 - ITENS DA NOTA ## */
	
	cSqlItem := "SELECT D2.D2_COD, C6.C6_ITEM, D2.D2_UM, D2.D2_QUANT, D2.D2_TOTAL, D2.D2_PRUNIT, "
	cSqlItem += "		D2.D2_NUMLOTE, D2.D2_PESO, D2.D2_CLASFIS, D2.D2_CF, D2.D2_IPI, D2.D2_VALIPI, "
	cSqlItem +=	"		D2.D2_PICM, D2.D2_VALICM, D2.D2_DESCON "
	cSqlItem += "FROM "+RetSqlName("SD2")+" D2 "
	cSqlItem += "LEFT JOIN "+RetSqlName("SC6")+" C6 ON "
	cSqlItem += "		D2.D2_FILIAL  = C6.C6_FILIAL AND "
	cSqlItem += "		D2.D2_DOC     = C6.C6_NOTA   AND "
	cSqlItem += "		D2.D2_CLIENTE = C6.C6_CLI    AND "
	cSqlItem += "		D2.D2_COD	  = C6.C6_PRODUTO "
	cSqlItem += "WHERE "                                       
	cSqlItem += "   D2.D2_FILIAL  = '"+TMP1->F2_FILIAL+"'  AND "
	cSqlItem +=	"		D2.D2_DOC     = '"+TMP1->F2_DOC+"'     AND "
	cSqlItem += "		D2.D2_CLIENTE = '"+TMP1->F2_CLIENTE+"' "
	
	
	TcQuery cSqlItem NEW ALIAS "TMP3"
	TMP3->(dbSelectArea("TMP3"))
	TMP3->(dbGoTop())
	
	cRegLin := 1
	ProcRegua(RecCount()) 
	While !TMP3->(EOF())
		cLin += "04" 									  								//Tipo de Registro
		cLin += StrZero(cRegLin,4)						  				//Sequencial da Linha Item
		cLin += StrZero(Val(TMP3->C6_ITEM),5)						//Número do Item no Pedido
		cLin += PadR("EN",3," ")						  					//Tipo de Código do Produto
		cLin += PadR(SubStr(TMP3->D2_COD,4,4),14," ")	  //Código do Produto
		cLin += Space(20)								  							//Referência do Produto

		cUnMed := Space(3)
		cTpEmb := Space(3)		  
		If TMP3->D2_UM == "UN"
			cUnMed := "EA"
		elseIf TMP3->D2_UM == "KG"
			cUnMed := "KGM"
		elseIf TMP3->D2_UM == "L "
			cUnMed := "LTR"
		elseIf TMP3->D2_UM == "MT"
			cUnMed := "MTR"
		elseIf TMP3->D2_UM == "M2"
			cUnMed := "MTK"
		elseIf TMP3->D2_UM == "M3"
			cUnMed := "MTQ"
		elseIf TMP3->D2_UM == "ML"
			cUnMed := "MLT"
		elseIf TMP3->D2_UM == "TL"
			cUnMed := "TN2"
		else 
			cUnMed := "EA"
			if TMP3->D2_UM == "CX"
			   	cTpEmb := "BX"
			elseIf TMP3->D2_UM == "BD"
				cTpEmb := "BJ"
			elseIf TMP3->D2_UM == "BJ"
				cTpEmb := "PU"
			elseIf TMP3->D2_UM == "FD"
				cTpEmb := "BN"
			elseIf TMP3->D2_UM == "LT"
				cTpEmb := "CA"
			elseIf TMP3->D2_UM == "PC"
				cTpEmb := "PC"
			elseIf TMP3->D2_UM == "RL"
				cTpEmb := "RO"
			elseIf TMP3->D2_UM == "SC"
				cTpEmb := "BG"
			else
				cTpEmb := TMP3->D2_UM
			EndIf
		EndIf
		
		cLin += PadR(cUnMed,3," ")						  						//Unidade de Medida
		cLin += StrZero(0,5)							  								//Nro Quantidade de Consumo na Embalagem
		cLin += StrZero(TMP3->D2_QUANT*100,15)		      		//Quantidade
		cLin += PadR(cTpEmb,3," ")  					  						//Tipo de Embalagem
		cLin += StrZero(TMP3->D2_TOTAL*100,15)			  			//Valor Bruto Linha Item
		cLin += StrZero((TMP3->D2_QUANT*TMP3->D2_PRUNIT)*100,15)          //Valor Liquido Linha Item
		cLin += StrZero(Round((TMP3->D2_TOTAL/TMP3->D2_QUANT),2)*100,15)  //Preço Bruto Unitário
		cLin += StrZero(TMP3->D2_PRUNIT*100,15)			  			//Preço Líquido Unitário
		cLin += PadR(TMP3->D2_NUMLOTE,20," ")			  				//Número do Lote
		cLin += Space(20)							      								//Número do Pedido do Comprador
		cLin += StrZero(Round(TMP3->D2_PESO,2)*100,15)	  	//Peso Bruto do Item
		cLin += StrZero(0,15)							  								//Volume Bruto do Item
		cLin += PadR(TMP3->D2_CLASFIS,14," ")			  				//Classificação Fiscal
		cLin += Space(5)								  									//Código Situação Tributária
		cLin += PadR(TMP3->D2_CF,5," ")					  					//Código Fiscal de Operações e Prestações
		cLin += StrZero(0,5)							  								//Percentual Desc. Financeiro
		cLin += StrZero(0,15)							  								//Val Desc. Financeiro

		vDescCom := TMP3->D2_DESCON
    pDescCom := Round((vDescCom*100)/TMP3->D2_TOTAL,2)		  
		cLin += StrZero(pDescCom*100,5)					  					//Percentual Desconto Comercial
		cLin += StrZero(vDescCom*100,15)				  					//Valor Desconto Comercial
		cLin += StrZero(0,5)							  								//Percentual Desc. Promocional
		cLin += StrZero(0,15)							  								//Val Desc. Promocional
		cLin += StrZero(0,5)							  								//Percentual Encargos Financeiros
		cLin += StrZero(0,15)							  								//Val Encargos Financeiros
		cLin += StrZero(TMP3->D2_IPI*100,5)				  				//Alíquota IPI
		cLin += StrZero(TMP3->D2_IPI*TMP3->D2_PRUNIT,15)  	//Valor Unitário IPI
		cLin += StrZero(TMP3->D2_PICM*100,5)			  				//Alíquota ICM
		cLin += StrZero(TMP3->D2_VALICM*100,15)		      		//Valor ICM
		cLin += StrZero(0,5)							  								//Alíquota ICMS com ST
		cLin += StrZero(0,15)							  								//Valor de ICMS com ST
		cLin += StrZero(0,5)       						  						//Alíquota Redução Base ICM
		cLin += StrZero(0,15)							  								//Valor de Redução Base ICM
		cLin += StrZero(0,5)							  								//Percentual de Desconto do Repasse de ICMS
		cLin += StrZero(0,15)							  								//Valor do Desconto do Repasse de ICMS
		cLin += cEOL

	  cRegLin += 1
	    
		TMP3->(DbSelectArea("TMP3"))
	    TMP3->(dbSkip())
	
	EndDo
	TMP3->(DbCloseArea())
	
			/* FINAL GRAVAÇÃO REGISTRO 04 - ITENS DA NOTA */
	
					/* ## 09 - SUMÁRIO ## */
	

	cLin += "09"
	cLin += StrZero(0,4)								  								//Número de Linhas da NF				                  
	cLin += StrZero(0,15)								  								//Quantidade Total de Embalagens
	cLin += StrZero(TMP1->F2_PBRUTO*100,15)				  			//Peso Bruto Total
	cLin += StrZero(TMP1->F2_PLIQUI*100,15)				  			//Peso Líquido Total
	cLin += StrZero(0,15)								  								//Cubagem Total
	cLin += StrZero(TMP1->F2_VALMERC*100,15)			  			//Valor Total das Linhas da NF
	cLin += StrZero(TMP1->F2_DESCONT*100,15)			  			//Valor Total de Descontos
	cLin += StrZero(0,15)								  								//Valor Total de Encargos
	cLin += StrZero(0,15)								  								//Valor Total de Abatimentos
	cLin += StrZero(TMP1->F2_FRETE*100,15)				  			//Valor Total de Frete
	cLin += StrZero(TMP1->F2_SEGURO*100,15)			 	  			//Valor Total de Seguro
	cLin += StrZero(0,15)								  								//Valor Total Despesas Acessórias
	cLin += StrZero(TMP1->F2_BASEICM*100,15)			  			//Valor Base de Cálculo do ICMS
	cLin += StrZero(TMP1->F2_VALICM*100,15)				  			//Valor Total ICMS
	cLin += StrZero(TMP1->F2_BASEICM*100,15)			  			//Valor Base de Cálculo do ICMS com ST
	cLin += StrZero(TMP1->F2_VALICM*100,15)				  			//Valor Total ICMS com ST
	cLin += StrZero(TMP1->F2_BASEICM*100,15)			  			//Valor Base de Cálculo do ICMS com RT
	cLin += StrZero(TMP1->F2_VALICM*100,15)				  			//Valor Total ICMS com RT
	cLin += StrZero(TMP1->F2_BASEIPI*100,15)			  			//Valor Base de Cálculo do IPI
	cLin += StrZero(TMP1->F2_VALIPI*100,15)				  			//Valor Total IPI
	cLin += StrZero(TMP1->F2_VALBRUT*100,15)			  			//Valor Total da Nota
	cLin += cEOL
	
				/* FINAL GRAVAÇÃO REGISTRO 09 - SUMÁRIO */

	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	        If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
	            Exit
	        Endif
	Endif
    
    
    DbSelectArea("SF2")
    SF2->(DbSetOrder(2))
    SF2->(DbGotop())
    if SF2->(DbSeek(AllTrim(TMP1->F2_FILIAL+TMP1->F2_CLIENTE+TMP1->F2_LOJA+TMP1->F2_DOC+TMP1->F2_SERIE)))
        RecLock("SF2", .F.)
        SF2->F2_EXPEDI := "S"
        SF2->(MsUnlock())
    else
    	MsgAlert("Não Encontrei Filial: "+TMP1->F2_FILIAL+" Cliente: "+TMP1->F2_CLIENTE+" Loja: "+TMP1->F2_LOJA+" NF: "+TMP1->F2_DOC+" Série: "+TMP1->F2_SERIE)
    EndIf

    
	TMP1->(DbSelectArea("TMP1"))
    TMP1->(dbSkip())
    
EndDo

TMP1->(DbCloseArea())

//fWrite(nHdl,cLin,Len(cLin))
//nSeqReg += 1 // Sequencial de registros
                                        
											
fClose(nHdl)
Close(oGeraTxt)
										
Return
Static Function ValidPerg()


_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aRegs:={}


//Grupo/Ordem/Pergunta/PerSPA/PerENG/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefSPA1/DefENG1/Cnt01/Var02/Def02/DefSPA2/DefENG2/Cnt02/Var03/Def03/DefSPA3/DefENG3/Cnt03/Var04/Def04/DefSPA4/DefENG4/Cnt04/Var05/Def05/DefSPA5/DefENG5/Cnt05/F3/GRPSXG
aAdd(aRegs,{cPerg,"01","Local do arquivo        ","","","mv_ch1","C",50,0,0,"G","NaoVazio","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Emitido de:             ","","","mv_ch2","D",08,0,0,"G","        ","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
aAdd(aRegs,{cPerg,"03","Até:                    ","","","mv_ch3","D",08,0,0,"G","NaoVazio","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Cliente de:	            ","","","mv_ch4","C",09,0,0,"G","        ","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SA1",""})
aAdd(aRegs,{cPerg,"05","Loja de: 	              ","","","mv_ch5","C",04,0,0,"G","        ","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Cliente Até:            ","","","mv_ch6","C",09,0,0,"G","NaoVazio","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SA1",""})
aAdd(aRegs,{cPerg,"07","Loja Até:	              ","","","mv_ch7","C",04,0,0,"G","        ","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)
Return