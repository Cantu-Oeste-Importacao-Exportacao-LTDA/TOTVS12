#Include "PROTHEUS.CH"
#Include "RWMAKE.CH" 
#Include "TOPCONN.CH" 

/*__________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçäo    ¦  CANR001    ¦ Autor ¦ Lucilene Mendes     ¦ Data ¦12.10.12 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Acordo de Renegociação  -  TeleCobrança - Call Center      ¦¦¦
¦¦¦          ¦ Alterado para exibir dados da esposa e sócios por Renata C ¦¦¦
¦¦¦          ¦ Calaça em 08.03.13.                                        ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

User Function CANRW001() 
                 
Private aDados 		:= {} 
Private aSocios		:= {} 
Private cTitulo		:= ''
Private nPar  	  := 0
Private cNumTit 	:= ''
Private cContrato := ''
Private cArqOrg		:= "\samples\renegociacao1.dot"  
Private cArqOrg2  := "\samples\renegociacao2.dot"  
Private cPerg     := 'CANR001  '
Private lRet      := .T.
CriaSx1(cPerg)
Pergunte(cPerg,.T.)
 
//Alimenta as variáveis com os dados dos parametros
cRepres := mv_par01
cCPF    := mv_par02
cNacion := mv_par03 
cProfis := mv_par04   
cCasado := mv_par05
cBco    := Alltrim(mv_par06) 
cAgenc  := Alltrim(mv_par07) 
cConta  := Alltrim(mv_par08) 
cIdent  := Alltrim(mv_par09)
cIdesp  := Alltrim(mv_par10) 
cCPFesp := Alltrim(mv_par11) 
cNacesp := Alltrim(mv_par12) 
cProfes := Alltrim(mv_par13) 
cEnd    := mv_par14
cMun    := mv_par15
cSocios := mv_par16
cContrato:= GetNewPar("MV_CONTR","000001")    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
                                    
While .T.
	If cCasado == 1 .AND. Empty (Alltrim(mv_par10))
		MsgInfo ("Campo esposa vazio, favor verificar", "ATENÇÃO")
		Pergunte(cPerg,.T.)
	Else
		Exit
	EndIf
EndDo                    

If cSocios == 1
	aSocios := U_Socios ()
EndIf

Processa( {|| lRet := CANR001A() }, "Aguarde...", "Processando o relatório...",.F.)

If !lRet
	Return // Caso a rotina de Geração de títulos não seja concluída sai da rotina de renegociação
Endif


//Atualiza o parâmetro que controla o número do contrato

PutMv("MV_CONTR",Soma1(GetMv("MV_CONTR")))

Return



Static Function CANR001A()


//Posiciona nas tabelas necessárias
//***********************************
dbSelectArea("SM0") //Empresas
dbSeek(cEmpAnt+cFilAnt)	

dbSelectArea("SA1") //Clientes
dbSeek(xFilial("SA1")+cCliente+cLoja)

//Localiza os dados das novas parcelas
For i:=1 to Len(aParcelas)
	nPar++
 	cTitulo += "Parcela "+StrZero(nPar,3)+" em "+Space(76)+DTOC(aParcelas[i,1])+" -  R$ "+Transform(aParcelas[i,2],"@E 999,999,999.99")+Chr(13)+Chr(10)
Next


//Localiza o numero dos títulos renegociados, para usar no numero da NF
For i := 1 to Len (aCols)
	If !(aCols[i, nPosTit] $ cNumTit)
		cNumTit += aCols [i, nPosTit]+Chr(13)+Chr(10)
	Endif
Next 

		  
		 AAdd( aDados, { "cRazao" 	   , Upper(Alltrim(SM0->M0_NOMECOM))  } )
		 AAdd( aDados, { "cCnpj" 	   , Transform(SM0->M0_CGC, "@R 99.999.999/9999-99") } )    
		 AAdd( aDados, { "cInsc" 	   , Alltrim(SM0->M0_INSC)  } )
		 AAdd( aDados, { "cEnd" 	   , Alltrim(SM0->M0_ENDCOB)	} )      
		 AAdd( aDados, { "cCidade" 	, Alltrim(Capital(SM0->M0_CIDCOB))  } )   
		 AAdd( aDados, { "cCep" 	   , Transform(SM0->M0_CEPCOB,"@R 99999-999")  } )   
		 AAdd( aDados, { "cEstado" 	, Upper(SM0->M0_ESTCOB)  } )     
		 AAdd( aDados, { "cTelefone" 	, Transform(Substr(SM0->M0_TEL,2),"@R (99)9999-9999")  } )     
		 AAdd( aDados, { "cRazaoCli"  , Alltrim(Upper(SA1->A1_NOME))  } )
		 AAdd( aDados, { "cFantCli"   , Alltrim(Upper(SA1->A1_NREDUZ))	 } )
		 AAdd( aDados, { "cCnpjCli"   , Transform(SA1->A1_CGC,"@R 99.999.999/9999-99")	} )   
		 AAdd( aDados, { "cEndCli" 	, Alltrim(SA1->A1_END) 	} )     
		 AAdd( aDados, { "cCompCli" 	, Alltrim(SA1->A1_COMPLEM) } )     
		 AAdd( aDados, { "cBairroCli" , Alltrim(SA1->A1_BAIRRO)		} )   
		 AAdd( aDados, { "cCidCli" 	, Alltrim(SA1->A1_MUN)		} )   
		 AAdd( aDados, { "cEstCli" 	, Alltrim(SA1->A1_EST)	} )   
		 AAdd( aDados, { "cRepres"    , Alltrim(Upper(cRepres))		} )   
		 AAdd( aDados, { "cProfiss"   , Alltrim(Lower(cProfis))		} )   
		 AAdd( aDados, { "cNacion" 	, Alltrim(Lower(cNacion))		} )   
		 AAdd( aDados, { "cCPFRepr"   , Transform(cCPF,"@R 999.999.999-99")		} )   
		 AAdd( aDados, { "nTotal" 	   , Transform(nValor,"@E 999,999,999.99")  	} )   
		 AAdd( aDados, { "cExtTotal"  , Extenso(nValor)		} )   
		 AAdd( aDados, { "nQtParcel"  , nPar		} )   
		 AAdd( aDados, { "cExtQPar"   , Lower(Extenso(nPar,.T.)) 		} )   
		 AAdd( aDados, { "cBanco" 	   , Upper(Posicione("SA6",1,xFilial("SA6")+cBco+cAgenc+cConta,"A6_NOME")) 	} )   
		 AAdd( aDados, { "nAgencia"   , cAgenc		} )   
		 AAdd( aDados, { "nConta" 	   , cConta		} )   
		 AAdd( aDados, { "cTitulo" 	, cTitulo	} )   
		 AAdd( aDados, { "cNumTit" 	, cNumTit	} )   
		 AAdd( aDados, { "nIdent" 	   , cIdent		} )   
		 AAdd( aDados, { "cContrato"  , cContrato } )   
		 AAdd( aDados, { "cDia" 	   , StrZero(Day(Date()),2)	} )   
		 AAdd( aDados, { "cMes" 	   , MesExtenso()   } )   
		 AAdd( aDados, { "cAno" 	   , Year(Date())	  } )
		 
		 If len(aSocios)>0  
			 For nI := 1 to Len(aSocios)
			 	AAdd( aDados, {aSocios[nI, 1], aSocios[nI, 2]} )    
			 Next             
		 EndIf
		 
		 If cCasado == 1 
			AAdd( aDados, { "cIdEsp" 	   , Alltrim(Upper(mv_par10))  } )      
		 	AAdd( aDados, { "cCPFesp" 	   , Alltrim(Upper(cCPFesp))  } )      
		 	AAdd( aDados, { "cNacesp" 	   , Alltrim(Upper(cNacesp))  } )      
		 	AAdd( aDados, { "cProfes" 	   , Alltrim(Upper(cProfes))  } )
		 	AAdd( aDados, { "cEnd"        , Alltrim(Lower(cEnd))   	} )    
		 	AAdd( aDados, { "cMun"        , Alltrim(Lower(cMun))		} )    
		 	     
		EndIf                                                                
		    		 
		 Memowrite("C:\ZZ2HX\aDADOS.html",varinfo("aDados",aDados))
		 
		If cCasado == 1 
			ACImpDoc( cArqOrg2, aDados )  
		Else 
			ACImpDoc( cArqOrg, aDados ) 
		EndIf 

Return .T. 
   
 
Static Function CriaSx1(cPerg)
	PutSx1(cPerg,"01","Representante"  ,"Representante" ,"Representante" ,"mv_ch1","C",40,0,0,"G","",""   ,"","","mv_par01")
	PutSx1(cPerg,"02","CPF"	           ,"CPF"           ,"CPF"	         ,"mv_ch2","C",15,0,0,"G","",""   ,"","","mv_par02")
	PutSx1(cPerg,"03","Nacionalidade"  ,"Nacionalidade" ,"Nacionalidade" ,"mv_ch3","C",20,0,0,"G","",""   ,"","","mv_par03")
	PutSx1(cPerg,"04","Profissão"      ,"Profissão"     ,"Profissão"     ,"mv_ch4","C",20,0,0,"G","",""   ,"","","mv_par04") 
	PutSx1(cPerg,"05","Casado"         ,"Casado"        ,"Casado"        ,"mv_ch5","C",04,0,0,"C","",""   ,"","","mv_par05","SIM","","","","NAO" )
	PutSx1(cPerg,"06","Banco"	       ,"Banco"         ,"Banco"	       ,"mv_ch6","C",03,0,0,"G","","SA6","","","mv_par06")
	PutSx1(cPerg,"07","Agência"	       ,"Agência"       ,"Agência"	     ,"mv_ch7","C",06,0,0,"G","",""   ,"","","mv_par07")
	PutSx1(cPerg,"08","Conta"	       ,"Conta"         ,"Conta"	       ,"mv_ch8","C",20,0,0,"G","",""   ,"","","mv_par08")
	PutSx1(cPerg,"09","Identificação"  ,"Identificação" ,"Identificação" ,"mv_ch9","C",20,0,0,"G","",""   ,"","","mv_par09")
	PutSx1(cPerg,"10","Esposa"         ,"Esposa"        ,"Esposa"        ,"mv_cha","C",40,0,0,"G","",""   ,"","","mv_par10")
	PutSx1(cPerg,"11","CPF"	           ,"CPF"	        ,"CPF"	         ,"mv_chb","C",15,0,0,"G","",""   ,"","","mv_par11")
	PutSx1(cPerg,"12","Nacionalidade"  ,"Nacionalidade" ,"Nacionalidade" ,"mv_chc","C",20,0,0,"G","",""   ,"","","mv_par12")
    PutSx1(cPerg,"13","Profissão"      ,"Profissão"     ,"Profissão"     ,"mv_chd","C",20,0,0,"G","",""   ,"","","mv_par13") 
    PutSx1(cPerg,"14","Endereço"       ,"Endereço"      ,"Endereço"      ,"mv_che","C",99,0,0,"G","",""   ,"","","mv_par14")
    PutSx1(cPerg,"15","Mun./UF"        ,"Mun./UF"       ,"Mun./UF"       ,"mv_chf","C",40,0,0,"G","",""   ,"","","mv_par15")
    PutSx1(cPerg,"16","Possui Socios"  ,"Possui Socios" ,"Possui Socios" ,"mv_chg","C",04,0,0,"C","",""   ,"","","mv_par16","SIM","","","","NAO" )
Return  


