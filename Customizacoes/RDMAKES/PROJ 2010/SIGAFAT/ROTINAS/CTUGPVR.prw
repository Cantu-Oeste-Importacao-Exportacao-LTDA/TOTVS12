#Include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"  


Static function TiraGraf (_sOrig)   

   local _sRet := _sOrig
   
   _sRet = strtran (_sRet, ".", "")
   _sRet = strtran (_sRet, ",", "") 
   _sRet = strtran (_sRet, ":", "")    
   _sRet = strtran (_sRet, "-", "")
   _sRet = strtran (_sRet, "/", "")
   _sRet = strtran (_sRet, "\", "")
   _sRet = strtran (_sRet, "-", "")
   _sRet = strtran (_sRet, "&", "")
   _sRet = strtran (_sRet, "á", "a")
   _sRet = strtran (_sRet, "é", "e")
   _sRet = strtran (_sRet, "í", "i")
   _sRet = strtran (_sRet, "ó", "o")
   _sRet = strtran (_sRet, "ú", "u")
   _SRET = STRTRAN (_SRET, "Á", "A")
   _SRET = STRTRAN (_SRET, "É", "E")
   _SRET = STRTRAN (_SRET, "Í", "I")
   _SRET = STRTRAN (_SRET, "Ó", "O")
   _SRET = STRTRAN (_SRET, "Ú", "U")
   _sRet = strtran (_sRet, "ã", "a")
   _sRet = strtran (_sRet, "õ", "o")
   _SRET = STRTRAN (_SRET, "Ã", "A")
   _SRET = STRTRAN (_SRET, "Õ", "O")
   _sRet = strtran (_sRet, "â", "a")
   _sRet = strtran (_sRet, "ê", "e")
   _sRet = strtran (_sRet, "î", "i")
   _sRet = strtran (_sRet, "ô", "o")
   _sRet = strtran (_sRet, "û", "u")
   _SRET = STRTRAN (_SRET, "Â", "A")
   _SRET = STRTRAN (_SRET, "Ê", "E")
   _SRET = STRTRAN (_SRET, "Î", "I")
   _SRET = STRTRAN (_SRET, "Ô", "O")
   _SRET = STRTRAN (_SRET, "Û", "U")
   _sRet = strtran (_sRet, "ç", "c")
   _sRet = strtran (_sRet, "Ç", "C")
   _sRet = strtran (_sRet, "à", "a")
   _sRet = strtran (_sRet, "À", "A")
   _sRet = strtran (_sRet, "º", ".")
   _sRet = strtran (_sRet, "ª", ".")
   _sRet = strtran (_sRet, chr (9), " ") // TAB
return _sRet                       



User Function CONTRATOS()
                          		                                                                                                
Local   cAlias     := "ZVC"
Private cCadastro  := "Cadastro de Contratos"
Private aRotina    := {}               


AADD(aRotina,{"Pesquisar" ,"AxPesqui" ,0,1})
AADD(aRotina,{"Visualizar","AxVisual" ,0,2})
AADD(aRotina,{"Incluir" ,"AxInclui" ,0,3})
AADD(aRotina,{"Alterar" ,"AxAltera",0,4})
AADD(aRotina,{"Excluir" ,"AxDeleta",0,5})


dbSelectArea(cAlias)
dbSetOrder(1)
mBrowse(6,1,22,75,cAlias)

Return 




//Rateio de Vale Refeicao
User Function CTUGPVR()  

Private cCadastro := "Rateio de Vale Refeicao"
Private aRotina := {} 
Private aCores  := {}   

AADD(aRotina,{"Pesquisar","AxPesqui",0,1})
AADD(aRotina,{"Visualizar","AxVisual",0,2})
AADD(aRotina,{"Gerar Valores","U_GeraTbVR",0,3})  
AADD(aRotina,{"Cadastro Contratos", "U_CONTRATOS()",0,3}) 
AADD(aRotina,{"Alterar","AxAltera",0,4})
AADD(aRotina,{"Excluir","U_ApagaVR",0,5}) 
                                         
AADD(aRotina,{"Arquivo - ALELO", "U_ArquiAVR()",0,6}) 
AADD(aRotina,{"Arquivo - TICKET","U_ArquiTVR()",0,6})     

AADD(aRotina,{"Gera Desc Folha","U_VerbaDesconto",0,6})
AADD(aRotina,{"Legenda",'U_LEGCANTU', 0,8} )
                           
AADD(aCores,{"ZVR_FLAG == 0 " ,"BR_VERDE"    }) // SEM AFASTAMENTO         
AADD(aCores,{"ZVR_FLAG == 1 " ,"BR_LARANJA"     }) // PROPORCIONAL A ADMISSÃO
AADD(aCores,{"ZVR_FLAG == 2 " ,"BR_AMARELO" })  // OUTROS AFASDTAMENTOS
AADD(aCores,{"ZVR_FLAG == 3 " ,"BR_AZUL" })  // AFASTADO FÉRIAS
    

dbSelectArea("ZVR")   //Tabela de Vale Refeição por Matricula.
dbSetOrder(1)
mBrowse(6,01,22,75,"ZVR",,,,,,aCORES)  

Return             

User Function LEGCANTU()

Local aLegenda := {}

AADD(aLegenda,{"BR_VERDE" ,"Integral" })             
AADD(aLegenda,{"BR_AZUL" ,"Proporcional Férias" })
AADD(aLegenda,{"BR_AMARELO" ,"Proporcional Afastamentos" })
AADD(aLegenda,{"BR_LARANJA" ,"Proporcional Admissão" })

BrwLegenda("Cálculo VR/VA", "Legenda", aLegenda)

Return Nil   

User function ApagaVR() 

Local cMesAno
Local cFilialDe
Local cFilialAte
Local cPerg := "GERATBVR" 

cPerg := PadR (cPerg,10," ")
_Ajusta000(cPerg)

If !Pergunte (cPerg,.T.)
	Return
Else      
	cFilialDe    := MV_PAR01
	cFilialAte   := MV_PAR02
	cMesAno      := DTOS(MV_PAR03) // 20130831
EndIf
                                                             
if MSGYESNO("<html><b><span style='color:red'>Confirma exclusão dos lançamentos de: "+SUBSTR(cMesAno,5,2)+"/"+SUBSTR(cMesAno,1,4)+"?</html>")   
    
    cQuery := " SELECT R_E_C_N_O_ RECZVR FROM " + RetSQLName("ZVR") + " ZVR WHERE ZVR_MESANO = '"+SUBSTR(cMesAno,5,2)+SUBSTR(cMesAno,1,4)+"' AND ZVR_FILIAL BETWEEN '"+cFilialDe+"' AND '"+cFilialAte+"' AND ZVR.D_E_L_E_T_ <> '*' "
    TcQuery cQuery new Alias "DELVR"
    
DELVR->(DbGoTop())
If DELVR->(Eof())
	msgAlert("Não foi encontrado nenhum item com os parâmetros informados!", "Atenção")
	DELVR->(dbCloseArea())
	Return
Endif
 
    While DELVR->(!Eof())
	   	dbselectarea("ZVR")
	   	dbgoto(DELVR->RECZVR)
	   	RECLOCK("ZVR",.F.)
		DBDELETE()
		MSUNLOCK()
		DELVR->(DbSkip())
    End	
		
	DELVR->(dbclosearea())

ENDIF
                                            
Return    

User function GeraTbVR() 
	Processa({||GeraVR1(),"Gerando valores de Vale Refeição" })
Return

Static Function GeraVR1()      
//Tabela 
//Campos Filial, Matricula, Mes/Ano, CC, Dias, ValorVale, ValorCesta   

Local cQuery 	:= "" 
Local cDataIni
Local cDataFim 
Local cDataBase 
Local cMesAno
Local cFilialDe
Local cFilialAte
Local cPerg := "GERATBVR"  
Local nDireito := 0  
Local cTipo := 0

cPerg := PadR (cPerg,10," ")
_Ajusta000(cPerg)

If !Pergunte (cPerg,.T.)
	Return
Else      
	cFilialDe    := MV_PAR01
	cFilialAte   := MV_PAR02       //12345678
	cMesAno      := DTOS(MV_PAR03) //20130831
EndIf

cMes    := SUBSTR(cMesAno,5,2)
cAno    := SUBSTR(cMesAno,1,4)
                                   
cDataIni := cAno+cMes+'01' 
cDataFim := DTOS(LastDate(STOD(cAno+cMes+"01")))     
cDataBase := DTOS(dDataBase)       

cQuery := " SELECT MAX(RCF_DIATRA) RCF_DIATRA FROM " + RetSQLName("RCF") + " RCF WHERE RCF_MES = '"+cMes+"' AND RCF_ANO = '"+cAno+"' AND RCF.D_E_L_E_T_ <> '*' "
TcQuery cQuery new Alias "QRP"

DbSelectArea("QRP")

IF !QRP->(EOF())
	
	cDiasRef := QRP->RCF_DIATRA
	
Else
	
    msgAlert("Não foi localizado o período do mês informado!", "Erro")
    QRP->(dbclosearea())
	return

Endif

QRP->(dbclosearea()) 



cQuery := " SELECT DISTINCT RA_FILIAL, RA_MAT, (CASE WHEN RA_ADMISSA >= '"+cDataIni+"' THEN 'SIM' ELSE 'NAO' END) ADMMES, RA_ADMISSA ,  "
cQuery += " RCE_X_VLVA VA, "
cQuery += " RA_NOME, SUBSTR(SRX.RX_TXT,21,12)*1 VR,  "
cQuery += "	CASE WHEN EXISTS(SELECT 1 FROM " + RetSQLName("SR8") + " SR8 WHERE R8_FILIAL = RA_FILIAL AND R8_MAT = RA_MAT AND R8_DATAFIM = ' ' AND R8_TIPO IN ('P','Q') AND '" + cDataBase + "' - R8_DATAINI >15 ) OR  "
cQuery += " EXISTS(SELECT 1 FROM " + RetSQLName("SR8") + " SR8 WHERE R8_FILIAL = RA_FILIAL AND R8_MAT = RA_MAT AND R8_DATAFIM > '" + cDataBase + "' AND R8_TIPO IN ('P','Q') AND '" + cDataBase + "' - R8_DATAINI >15) THEN 'A' ELSE ' ' END AFAST
cQuery += " FROM " + RetSQLName("SRA") + " SRA "
cQuery += " LEFT JOIN " + RetSQLName("SRX") + " SRX ON SUBSTR(SRX.RX_COD,13,2)=SRA.RA_VALEREF AND SRX.RX_TIP='26' AND SRX.D_E_L_E_T_ <> '*' "
cQuery += "  INNER JOIN " + RetSQLName("RCE") + " RCE ON RA_SINDICA = RCE_CODIGO AND RCE.D_E_L_E_T_ <> '*' "
cQuery += " WHERE RA_SITFOLH <> 'D' AND RA_FILIAL BETWEEN '"+cFilialDe+"' AND '"+cFilialAte+"' "
cQuery += " AND SRA.RA_VALEREF <> ' ' AND RA_CATFUNC IN ('H','M') AND SRA.D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY RA_FILIAL, RA_NOME "

//MemoWrite("D:\cQuery.txt", cQuery)

TcQuery cQuery new Alias "QSRA"

TCSetField ("QSRA", "VA","N",8)
TCSetField ("QSRA", "VR","N",8)

dbSelectArea("QSRA")

While QSRA->(!EOF())
	
	cQuery2 := " SELECT * FROM " + RetSQLName("SR8") + " SR8 WHERE R8_FILIAL = '"+QSRA->RA_FILIAL+"' AND R8_MAT = '"+QSRA->RA_MAT+"' AND  ( SUBSTR(R8_DATAINI,1,6) = '"+SUBSTR(cDataIni,1,6)+"' OR SUBSTR(R8_DATAFIM,1,6) ='"+SUBSTR(cDataFim,1,6)+"' ) AND SR8.D_E_L_E_T_ <> '*' AND R8_TIPO IN ('Q','P','F')  "
	
//	MemoWrite("D:\cQuery2.txt", cQuery2)
	
		IF SELECT("QRCG") > 0
			QRCG->(dbclosearea())
		ENDIF
	
	TcQuery cQuery2 new Alias "QSR8"
	
	dbSelectArea("QSR8")
	
	
	While QSR8->(!EOF())
		
		IF LEFT(QSR8->R8_DATAINI,6) <> SUBSTR(cDataIni,1,6)
			cNovaIni := cDataIni
		ELSE
			cNovaIni := QSR8->R8_DATAINI
		ENDIF
		
		
		IF LEFT(QSR8->R8_DATAFIM,6) <> SUBSTR(cDataIni,1,6)
			cNovaFim := cDataFim
		ELSE
			cNovaFim := QSR8->R8_DATAFIM
		ENDIF
		
		
		cQuery3 := " SELECT COUNT(*) DIAS FROM " + RetSQLName("RCG") + " RCG WHERE RCG_SEMANA = ' ' "
		cQuery3 += " AND RCG_DIAMES BETWEEN '"+cNovaIni+"' AND '"+cNovaFim+"' AND RCG_TIPDIA = '1' AND RCG_VREFEI = 1 AND RCG.D_E_L_E_T_ <> '*' "
		
		IF SELECT("QRCG") > 0
			QRCG->(dbclosearea())
		ENDIF
		
		TcQuery cQuery3 new Alias "QRCG"
		nDireito := nDireito + QRCG->DIAS
		cTipo := QSR8->R8_TIPO
		
		QSR8->(DbSkip())
		
	END
	
	
	
	IF QSRA->ADMMES = "SIM" .AND. QSRA->AFAST <> 'A'
		cQuery4 := " SELECT COUNT(*) DIAS FROM " + RetSQLName("RCG") + " RCG WHERE RCG_SEMANA = ' ' "
		cQuery4 += " AND RCG_DIAMES BETWEEN '"+QSRA->RA_ADMISSA+"' AND '"+cDataFim+"' AND RCG_TIPDIA = '1' AND RCG_VREFEI = 1 AND RCG.D_E_L_E_T_ <> '*' "
		
		IF SELECT("Q2RCG") > 0
			Q2RCG->(dbclosearea())
		ENDIF
		TcQuery cQuery4 new Alias "Q2RCG"
		nGravaDias := Q2RCG->DIAS
	ENDIF
	
	
	IF QSRA->ADMMES = "NAO" .AND. QSRA->AFAST <> 'A'
		nGravaDias := cDiasRef-nDireito
	ENDIF
	
	nDireito := 0
	
	
	IF ( QSRA->VR + QSRA->VA ) > 0
		DbSelectArea("ZVR")
		DbSetOrder(1)
		DbGoTop()
		If !DbSeek(QSRA->RA_FILIAL+QSRA->RA_MAT+cMes+cAno)
			RecLock("ZVR",.t.)
			ZVR->ZVR_FILIAL 	:= QSRA->RA_FILIAL
			ZVR->ZVR_MAT   		:= QSRA->RA_MAT
			ZVR->ZVR_MESANO 	:= cMes+cAno
			ZVR->ZVR_DIAS  		:= nGravaDias
			ZVR->ZVR_VALVR 		:= nGravaDias * QSRA->VR
			ZVR->ZVR_VALVA 		:= QSRA->VA / cDiasRef * nGravaDias  
	
// 0 - SEM AFASTAMENTO         
// 1 - PROPORCIONAL A ADMISSÃO
// 2 - AFASTADO 
// 3 - FERIAS
				
			DO CASE
				CASE nGravaDias = cDiasRef
				ZVR->ZVR_FLAG := 0
				CASE QSRA->ADMMES = "SIM"
				ZVR->ZVR_FLAG := 1 
				CASE cTipo $ 'QP'
				ZVR->ZVR_FLAG := 2
				CASE cTipo = 'F'
				ZVR->ZVR_FLAG := 3
			ENDCASE				
			MsUnLock()
		ELSE
			RecLock("ZVR",.f.)
			ZVR->ZVR_DIAS  		:= nGravaDias
			ZVR->ZVR_VALVR 		:= nGravaDias * QSRA->VR
			ZVR->ZVR_VALVA 		:= QSRA->VA / cDiasRef * nGravaDias 
			
// 0 - SEM AFASTAMENTO         
// 1 - PROPORCIONAL A ADMISSÃO
// 2 - AFASTADO 
// 3 - FERIAS
				
			DO CASE
				CASE nGravaDias = cDiasRef
				ZVR->ZVR_FLAG := 0
				CASE QSRA->ADMMES = "SIM"
				ZVR->ZVR_FLAG := 1 
				CASE cTipo $ 'QP'
				ZVR->ZVR_FLAG := 2
				CASE cTipo = 'F'
				ZVR->ZVR_FLAG := 3
			ENDCASE				
			MsUnLock()
		ENDIF
	ENDIF
	
	QSRA->(DbSkip())
	QSR8->(dbclosearea())
	
END

QSRA->(dbclosearea())

Return     


                

User Function ArquiAVR()

Local cQuery 	:= ""  
Local cMesAno  
Local cPerg := "ARQVR001"  


cPerg := PadR (cPerg,10," ")
_Ajusta001(cPerg)

If !Pergunte (cPerg,.T.)
	Return
Else      
	cDataPed := SUBSTR(DTOS(MV_PAR01),7,2) + SUBSTR(DTOS(MV_PAR01),5,2) + SUBSTR(DTOS(MV_PAR01),1,4)
	cDataLib := SUBSTR(DTOS(MV_PAR02),7,2) + SUBSTR(DTOS(MV_PAR02),5,2) + SUBSTR(DTOS(MV_PAR02),1,4) 
	cTipo    := IF(MV_PAR03 = 1, "A", "R") 
	cMesAno  := DTOS(MV_PAR05) //20130831 
EndIf

cMes    := SUBSTR(cMesAno,5,2)
cAno    := SUBSTR(cMesAno,1,4)

IF cTipo = 'R'
cTipoBen := "<html><b><span style='color:blue'>Vale Refeição</html>" 
cTipoPed := "1"   
cArq     := "FILIAL_" + MV_PAR04 + "_" + cMes+cAno +"_VR"
ELSE
cTipoBen := "<html><b><span style='color:blue'>Vale Alimentação</html>"   
cTipoPed := "2" 
cArq     := "FILIAL_" + MV_PAR04 + "_" + cMes+cAno +"_VA"
ENDIF 

If !MsgBox("Esta função gera um arquivo TXT com a solicitação "+cTipoBen,"Confirme","YESNO")
	return
EndIf
     
If Select("ZVR1") > 0
     ZVR1->(dbCloseArea())
Endif
     
cQuery := "  SELECT  "
cQuery += "  RA_FILIAL, "
cQuery += "  RA_MAT, "
cQuery += "  RA_NOME, "
cQuery += "  RA_CIC, "
cQuery += "  RA_PIS, "
cQuery += "  RA_RG, "
cQuery += "  RA_ADMISSA, "
cQuery += "  RA_NASC, "
cQuery += "  ZVR_MESANO, "
cQuery += "  ZVR_DIAS, "
cQuery += "  ZVR_VALVR VR, "
cQuery += "  ZVR_VALVA VA, "
cQuery += "  (SELECT COUNT(*) FROM " + RetSQLName("RCG") + "  RCG WHERE RCG_MES = '"+cMes+"' AND  RCG_ANO = '"+cAno+"' AND RCG_SEMANA = '' AND RCG_VREFEI = 1 AND RCG.D_E_L_E_T_ <> '*') DIASVR "
cQuery += "  FROM "
cQuery += "  " + RetSQLName("ZVR") + " ZVR "
cQuery += "  INNER JOIN " + RetSQLName("SRA") + " SRA ON RA_FILIAL = ZVR_FILIAL AND RA_MAT = ZVR_MAT AND SRA.D_E_L_E_T_ <> '*' "
cQuery += "  WHERE  "
cQuery += "  ZVR_MESANO = '"+cMes+cAno+"' AND ZVR_FILIAL = '"+MV_PAR04+"' AND ZVR.D_E_L_E_T_ <> '*' ORDER BY RA_NOME "

cQuery := changequery(cQuery)  
 

//MemoWrite("C:\TEMP\cQuery1.txt", cQuery)

TcQuery cQuery new Alias "ZVR1"  

ZVR1->(DbGoTop())
If ZVR1->(Eof())
	msgAlert("Não foi encontrado nenhum item com os parâmetros informados!", "Atenção")
	ZVR1->(dbCloseArea())
	Return
Endif

cPath := GETMV("MV_DIRVALE")

IF Empty( cPath )
	MsgInfo( OemToAnsi( "Não foi possível encontrar o diretório para Exportação" ) )
	Return
EndIF

//cArq  := CriaTrab(Nil, .F.)
nArq  := FCreate(cPath + UPPER(cArq) + ".TXT")

HANDLE := FCREATE (cPath,0)

If nArq == -1
	MsgAlert("Não conseguiu criar o arquivo!")
	Return
EndIf
       
cNomeEMP     := POSICIONE("SM0", 1, cEmpant+MV_PAR04 , "M0_NOMECOM")
cCgcEMP      := POSICIONE("SM0", 1, cEmpant+MV_PAR04 , "M0_CGC")
cEndEMP      := POSICIONE("SM0", 1, cEmpant+MV_PAR04 , "M0_ENDENT")
cCompEndEMP  := POSICIONE("SM0", 1, cEmpant+MV_PAR04 , "M0_COMPENT")
cCepEMP      := POSICIONE("SM0", 1, cEmpant+MV_PAR04 , "M0_CEPENT")    
cCidadeEMP   := POSICIONE("SM0", 1, cEmpant+MV_PAR04 , "M0_CIDENT") 
cEstadoEMP   := POSICIONE("SM0", 1, cEmpant+MV_PAR04 , "M0_ESTENT")   
cContrato    := POSICIONE("ZVC", 1, MV_PAR04+cTipo   , "ZVC_CONTRAT")

    
    
	cBuffer_0  := "0" + ; 
	              cDataPed + ; // DATA DO PEDIDO
	              "A001" + ; // CANAL DE ENTRADA
	              PadL(cNomeEMP,35) + ; // NOME RAZÃO CLIENTE
	              PadL(cCgcEMP,14) + ; // CNPJ EMPRESA
	              REPLICATE("0", 11) + ; // CPF DO CLIENTE 
	              PadL(cContrato, 11) + ; // NUMERO DO CONTRATO
	              REPLICATE(" ", 6) + ; // NUMERO DO PEDIDO CLIENTE
	              cDataLib + ; // DATA DA EFETIVAÇÃO DO BENEFICIO
	              "2" +; // TIPO DO PEDIDO
	              "1" +; // PEDIDO NORNAL OU COMPLEMENTAR
	              cMesAno + ; // MES COMPETÊNCIA DO BENEFICIO
	              REPLICATE(" ", 18) + ; // RESERVADO PARA USO LIVRE DOS CLIENTES
	              "007" +; //LAYOUT DA EXPORTAÇÃO
	              REPLICATE(" ", 267) + ; // ESPAÇOS EM BRANCO
	              "000001" // NUMERO SEQUENCIAL
	              
	
	FWrite(nArq, cBuffer_0 + Chr(13) + Chr(10)) 

	cBuffer_1  := "1" + ; 
	              SUBSTR(cCgcEMP,1,8) + ; // CNPJ EMPRESA 
	              SUBSTR(cCgcEMP,9,4) + ; // NUMERO DA FILIAL DO CNPJ 
	              SUBSTR(cCgcEMP,13,2) +; // DIGITO VERIFICADOR DO CNPJ
	              REPLICATE(" ", 10) + ;     // CODIGO DA EMPRESA JURIDICA ALELO DA FILIAL
	              PadL(cNomeEMP,35) + ; // NOME DA FILIAL
	              strzero(val("46"), 4)   + ; // DDD DOS INTERLOCUTORES
	              PadL("EDERSON LUIZ VIEIRA", 35) + ; // NOME DO PRIMEIRO INTERLOCUTOR DE ENTREGA
	              PadL("PASSO DA PAT 1682 VILA LEOP 05085000 SP", 40) +; // ENDEREÇO DE LOCALIZAÇÃO INTERNA PRIMEIRO INTER
	              strzero(val("21014869"), 12) +; // TELEFONE DO PRIMEIRO INTERLOCUTOR DE ENTREGA
	              REPLICATE("0", 6)  +; // RAMAL DO PRIMEIRO INTERLOCUTOR DE ENTREGA
	              REPLICATE(" ", 35) + ; // NOME DO SEGUNDO INTERLOCUTOR DE ENTREGA
	              REPLICATE(" ", 40) +; // ENDEREÇO DE LOCALIZAÇÃO INTERNA SEGUNDO INTER
	              REPLICATE("0", 12) +; // TELEFONE DO SEGUNDO INTERLOCUTOR DE ENTREGA
	              REPLICATE("0", 6)  +; // RAMAL DO SEGUNDO INTERLOCUTOR DE ENTREGA
	              REPLICATE(" ", 35) + ; // NOME DO TERCEIRO INTERLOCUTOR DE ENTREGA
	              REPLICATE(" ", 40) +; // ENDEREÇO DE LOCALIZAÇÃO INTERNA TERCEIRO INTER
	              REPLICATE("0", 12) +; // TELEFONE DO TERCEIRO INTERLOCUTOR DE ENTREGA
	              REPLICATE("0", 6)  +; // RAMAL DO TERCEIRO INTERLOCUTOR DE ENTREGA    
	              PadL(cCgcEMP, 20) + ; // CODIGO DA FILIAL / POSTO DE TRABALHO USADO PELO CLIENTE
	              REPLICATE(" ", 31) + ; // ESPAÇOS EM BRANCO
	              "000002"  // NUMERO SEQUENCIAL
	              
	
	FWrite(nArq, cBuffer_1 + Chr(13) + Chr(10)) 


	cBuffer_2  := "2" + ; 
	              REPLICATE(" ", 20) + ; // NOME DA DIRETORIA
	              REPLICATE(" ", 20) + ; // NOME DO DEPARTAMENTO
	              REPLICATE(" ", 20) + ; // CODIGO DA AREA FUNCIONAL, ATRIBUIDO PELO CLIENTE  
	              REPLICATE(" ", 20) + ; // NOME DA AREA FUNCIONAL, ATRIBUIDO PELO CLIENTE 
	              REPLICATE(" ", 40) + ; // LOCALIZAÇÃO INTERNA DA AREA FUNCIONAL
	              REPLICATE("0", 04) + ; // DDD DOS INTERLOCUTORES DE ENTREGA (OBRIGATORIO, SE O NUMERO DE TELEFONE PRESENTE   
	              REPLICATE(" ", 35) + ; // NOME DO PRIMEIRO INTERLOCUTOR DE ENTREGA
	              REPLICATE("0", 12) + ; // TELEFONE DO PRIMEIRO INTERLOCUTOR DE ENTREGA
	              REPLICATE("0", 06) + ; // RAMAL DO PRIMEIRO INTERLOCUTOR DE ENTREGA
	              REPLICATE(" ", 35) + ; // NOME DO SEGUNDO INTERLOCUTOR DE ENTREGA
	              REPLICATE("0", 12) + ; // TELEFONE DO SEGUNDO INTERLOCUTOR DE ENTREGA
	              REPLICATE("0", 06) + ; // RAMAL DO SEGUNDO INTERLOCUTOR DE ENTREGA
	              REPLICATE(" ", 163) + ; // ESPAÇOS EM BRANCO 
	              "000003"  // NUMERO SEQUENCIAL
	             
	              
	FWrite(nArq, cBuffer_2 + Chr(13) + Chr(10)) 

 nSeq_5 := 4                 
 nSoma5 := 0
 nValorBen := 0

While !ZVR1->(Eof()) 

IF cTipo = 'R'
nValor := ZVR1->VR
ELSE
nValor := ZVR1->VA
ENDIF 

   	   	    
IF nValor > 0
	cBuffer_5 := "5" + ;
	strzero(val(STRTRAN(ALLTRIM(TRANSFORM(nValor,"@E 9999.99")),",","")),11) + ; // VALOR DO BENEFICIO
	REPLICATE("0", 1) + ; // RESERVADO
	strzero(val(ZVR1->RA_MAT),13) + ; // MATRICULA
	REPLICATE(" ", 54) + ;   // RESERVADO
	SUBSTR(ZVR1->RA_NASC,7,2) + SUBSTR(ZVR1->RA_NASC,5,2) + SUBSTR(ZVR1->RA_NASC,1,4) + ; // DATA NASCIMENTO
	strzero(val(ZVR1->RA_CIC), 11) + ;    // CPF
	"1" + ; // TIPO DO DOCUMENTO 1-RG
	PadL(TiraGraf(STRTRAN(ZVR1->RA_RG," ","")),13)+ ; // RG
	REPLICATE(" ", 20) + ;   // ORGAO EMISSOR RG
	REPLICATE(" ", 06) + ;   // SIGLA DO ESTADO EMISSOR DO DOC ID
	REPLICATE("0", 15) + ;   // NUMERO PIS
	REPLICATE(" ", 1) + ;   // COD SEXO
	REPLICATE("0", 1) + ;   // ESTADO CIVIL
	REPLICATE(" ", 35) + ;   // TIPO NOME LOGRADOURO
	REPLICATE(" ", 10) + ;   // COMPLEMENTO DO ENDEREÇO DA RESIDENCIA
	REPLICATE("0", 5) + ;   // NUMERO DO LOGRADOURO
	REPLICATE("0", 8) + ;   // CEP RESIDENCIAL
	REPLICATE(" ", 28) + ;   // MUNICIPIO RESIDENCIA
	REPLICATE(" ", 30) + ;   // BAIRRO RESIDENCIA
	REPLICATE(" ", 2) + ;   // SIGLA DO EST RESIDENCIA
	REPLICATE(" ", 35) + ;   // NOME DA MAE
	REPLICATE(" ", 1) + ;   // COD OPÇÃO ENDER CORRESPONDENCIA
	REPLICATE("0", 4) + ; // COD DDD COMERCIAL
	REPLICATE("0", 8) + ; // NUM TELEFONE COMERCIAL
	REPLICATE("0", 4) + ; // NUM RAMAL COMERCIAL
	REPLICATE("0", 4) + ; // DDD RESIDENCIAL
	REPLICATE("0", 8) + ; // NUM TELEFONE RESIDENCIAL
	REPLICATE("0", 1) + ; // COD ESCOLARIDADE
	SUBSTR(ZVR1->RA_ADMISSA,7,2) + SUBSTR(ZVR1->RA_ADMISSA,5,2) + SUBSTR(ZVR1->RA_ADMISSA,1,4) + ; // DATA ADMISSÃO
	REPLICATE(" ", 1) + ; // RESERVADO
	PadL(" ", 40) + ;    // NOME DO USUÁRIO
	REPLICATE(" ", 6) + ; // RESERVADO
	strzero(nSeq_5,6)  // SEQUENCIA
	nSeq_5++
	nSoma5++
	nValorBen := nValorBen+nValor
	
	FWrite(nArq, cBuffer_5 + Chr(13) + Chr(10))

ENDIF    		
   
	ZVR1->(DbSkip())    

EndDo


cBuffer_Rodape  := "9" + ;
strzero(nSoma5,6)+ ;
strzero(val(STRTRAN(ALLTRIM(TRANSFORM(nValorBen,"@E 9999.99")),",","")),15) + ;
REPLICATE(" ",372) + ;
strzero(nSeq_5++,6)
FWrite(nArq, cBuffer_Rodape + Chr(13) + Chr(10))	                   


If Ferror() # 0
	MsgStop("Ocorreu um erro na gravacao do arquivo!")
	Return
Else
	MsgInfo("Arquivo "+cPath + cArq + ".TXT" + " criado com sucesso!")
EndIf

FClose(nArq)

ZVR1->(dbCloseArea())

Return         

           



























///  TICKET ACCOR SERVICES


User Function ArquiTVR()
                               
Local cQuery := ""  
Local cMesAno  
Local cFilial := "" 
Local cPerg := "ARQVR002" 

cPerg := PadR (cPerg,10," ")
_Ajusta002(cPerg)

If !Pergunte (cPerg,.T.)
	Return
Else      
	cDataPed := SUBSTR(DTOS(MV_PAR01),7,2) + SUBSTR(DTOS(MV_PAR01),5,2) + SUBSTR(DTOS(MV_PAR01),1,4)
	cDataLib := SUBSTR(DTOS(MV_PAR02),7,2) + SUBSTR(DTOS(MV_PAR02),5,2) + SUBSTR(DTOS(MV_PAR02),1,4) 
	cTipo    := IF(MV_PAR03 = 1, "A", "R") 
	cMesAno  := DTOS(MV_PAR05) //20130831 
EndIf

cMes    := SUBSTR(cMesAno,5,2)
cAno    := SUBSTR(cMesAno,1,4)

IF cTipo = 'R'
cTipoBen := "<html><b><span style='color:blue'>Ticket Restaurante</html>"
cTipoCar := "34"
cArq     := "FILIAL_" + MV_PAR04 + "_" + cMes+cAno +"_VR"
ELSE
cTipoBen := "<html><b><span style='color:blue'>Ticket Alimentação</html>"   
cTipoCar := "33"
cArq     := "FILIAL_" + MV_PAR04 + "_" + cMes+cAno +"_VA"
ENDIF 

If !MsgBox("Esta função gera um arquivo TXT com a solicitação "+cTipoBen,"Confirme","YESNO")
	return
EndIf
     
If Select("ZVR1") > 0
     ZVR1->(dbCloseArea())
Endif   

cQuery := "  SELECT  "
cQuery += "  RA_FILIAL, "
cQuery += "  RA_MAT, "
cQuery += "  RA_NOME, "
cQuery += "  RA_CIC, "
cQuery += "  RA_PIS, "
cQuery += "  RA_RG, "
cQuery += "  RA_ADMISSA, "
cQuery += "  RA_NASC, "
cQuery += "  ZVR_MESANO, "
cQuery += "  ZVR_DIAS, "
cQuery += "  ZVR_VALVR VR, "
cQuery += "  ZVR_VALVA VA, "
cQuery += "  (SELECT COUNT(*) FROM " + RetSQLName("RCG") + "  RCG WHERE RCG_MES = '"+cMes+"' AND  RCG_ANO = '"+cAno+"' AND RCG_SEMANA = '' AND RCG_VREFEI = 1 AND RCG.D_E_L_E_T_ <> '*') DIASVR "
cQuery += "  FROM "
cQuery += "  " + RetSQLName("ZVR") + " ZVR "
cQuery += "  INNER JOIN " + RetSQLName("SRA") + " SRA ON RA_FILIAL = ZVR_FILIAL AND RA_MAT = ZVR_MAT AND SRA.D_E_L_E_T_ <> '*' "
cQuery += "  WHERE  "
cQuery += "  ZVR_MESANO = '"+cMes+cAno+"' AND ZVR_FILIAL = '"+MV_PAR04+"' AND ZVR.D_E_L_E_T_ <> '*' ORDER BY RA_NOME "

cQuery := changequery(cQuery)  

//MemoWrite("C:\TEMP\cQuery2.txt", cQuery)

TcQuery cQuery new Alias "ZVR1"  

ZVR1->(DbGoTop())
If ZVR1->(Eof())
	msgAlert("Não foi encontrado nenhum item com os parâmetros informados!", "Atenção") 
	ZVR1->(dbCloseArea())
	Return
Endif

cPath := GETMV("MV_DIRVALE")

IF Empty( cPath )
	MsgInfo( OemToAnsi( "Não foi possível encontrar o diretório para Exportação" ) )
	Return
EndIF

//cArq  := CriaTrab(Nil, .F.)
nArq  := FCreate(cPath + UPPER(cArq) + ".TXT")

HANDLE := FCREATE (cPath,0)

If nArq == -1
	MsgAlert("Não conseguiu criar o arquivo!")
	Return
EndIf

cNomeEMP     := POSICIONE("SM0", 1, cEmpant+MV_PAR04 , "M0_NOMECOM")
cCgcEMP      := POSICIONE("SM0", 1, cEmpant+MV_PAR04 , "M0_CGC")
cEndEMP      := POSICIONE("SM0", 1, cEmpant+MV_PAR04 , "M0_ENDENT")
cCompEndEMP  := POSICIONE("SM0", 1, cEmpant+MV_PAR04 , "M0_COMPENT")
cCepEMP      := POSICIONE("SM0", 1, cEmpant+MV_PAR04 , "M0_CEPENT")    
cCidadeEMP   := POSICIONE("SM0", 1, cEmpant+MV_PAR04 , "M0_CIDENT") 
cEstadoEMP   := POSICIONE("SM0", 1, cEmpant+MV_PAR04 , "M0_ESTENT")   
cContrato    := POSICIONE("ZVC", 1, MV_PAR04+cTipo   , "ZVC_CONTRAT")
    
	cBuffer_0  := "T" + ;  // TIPO PRODUTO
	              cTipo + ; //PRODUTO
	              "02" + ; //FIXO
	              "0" + ;   // TIPO REGISTRO   
	              cTipo + ; //PRODUTO
                  IF(cContrato = "" , strzero(val(""),10) , strzero(val(cContrato),10)  )  + ; // CODIGO CONTRATO CLIENTE
	              PadL(cNomeEMP,24) + ; // NOME RAZÃO CLIENTE
	              REPLICATE(" ", 6) + ; // RESERVADO
	              cDataPed + ; // DATA DO PEDIDO
	              cDataLib + ; // DATA LIBERAÇÃO PEDIDO
	              "C" + ; // TIPO PEDIDO
	              REPLICATE(" ", 16) + ; // RESERVADO
	              SUBSTR(cDataPed,1,2) +; // MES DE REFERENCIA DO PEDIDO
	              REPLICATE(" ", 19) + ; // RESERVADO 
	              "04" +; // TIPO LAYOUT
	              cTipoCar + ; // TIPO DO CARTÃO
	              REPLICATE(" ", 48) + ; // RESERVADO 
	              "   SUP" + ; // ORIGEM
	              "000001"
	
	FWrite(nArq, cBuffer_0 + Chr(13) + Chr(10)) 
                 

	cBuffer_2  := "T" + ; 
	              cTipo + ; //PRODUTO
	              "02" + ; // FIXO
	              "2" + ; // TIPO REGISTRO
	              PadL(cNomeEMP,26) + ; // NOME UNIDADE                            
	              "   R" + ; // TIPO LOGRADOURO
	              PadL(cEndEMP,30) + ; // LOGRADOURO
	              PadL(" ",06) + ; // NUMERO
	              PadL(cCompEndEMP,10) + ; // COMPLEMENTO
	              PadL(cCidadeEMP,25) + ; // MUNICIPIO
	              PadL(cEstadoEMP,15) + ; // BAIRRO 
	              SUBSTR(cCepEMP,1,5) + ; // CEP  81050500
	              "PR" + ; // ESTADO
	              PadL("ELENICE DA SILVA NORA",20) + ; // RESPONSÁVEL PELO RECEBIMENTO DO PEDIDO NA UNIDADE
	              SUBSTR(cCepEMP,6,3) + ; // COMPLEMENTO DO CEP
	              REPLICATE(" ", 7) + ; // ESPAÇOS EM BRANCO
	              "000002"  // NUMERO SEQUENCIAL
	              
	
	FWrite(nArq, cBuffer_2 + Chr(13) + Chr(10)) 

nSeq_3 := 3
nValorBen := 0
nQuant_3 := 0

While !ZVR1->(Eof()) 

IF cTipo = 'R'
	nValor := ZVR1->VR
ELSE
	nValor := ZVR1->VA
ENDIF  

IF nValor > 0
	cBuffer_3 := "T" + ;
	cTipo + ; //PRODUTO
	"02" + ; // FIXO
	"3" + ; // TIPO REGISTRO
	REPLICATE(" ", 26) + ;   // CODIGO DO DEPARTAMENTO
	strzero(val(ZVR1->RA_MAT),12) + ; // MATRICULA
	SUBSTR(ZVR1->RA_NASC,7,2) + SUBSTR(ZVR1->RA_NASC,5,2) + SUBSTR(ZVR1->RA_NASC,1,4) + ; // DATA NASCIMENTO
	REPLICATE(" ", 18) + ; // RESERVADO
	PadL(cNomeEMP,26) + ; // NOME UNIDADE
	"00101" + ; // FIXO
	strzero(val(STRTRAN(ALLTRIM(TRANSFORM(nValor,"@E 9999.99")),".",",")),9) + ; // VALOR DO BENEFICIO
	cTipo + ; //PRODUTO
	"E" + ; // FIXO
	PadL(ZVR1->RA_NOME,30) + ; // NOME FUNCIONARIO
	REPLICATE(" ", 17) + ; // RESERVADO
	strzero(nSeq_3,6)  // SEQUENCIA
	nSeq_3++
	nQuant_3++
	nValorBen := nValorBen+nValor
	
	FWrite(nArq, cBuffer_3 + Chr(13) + Chr(10))

ENDIF
   		  
	ZVR1->(DbSkip())    

EndDo


	cBuffer_9 := "T" + ;
	cTipo + ; //PRODUTO
	"02" + ; // FIXO
	"9" + ; // TIPO REGISTRO
	strzero(nQuant_3,8) +; // QUANTIDADE DE REGISTROS TIPO 3 
	strzero(nValorBen,14) +; // SOMATORIO DO VALOR DO PEDIDO  
	REPLICATE(" ", 131) + ;   // RESERVADO
    strzero(nSeq_3++,6)     // SEQUENCIA
    
	FWrite(nArq, cBuffer_9 + Chr(13) + Chr(10))


	cBuffer_9 := "T" + ;
	cTipo + ; //PRODUTO
	"02" + ; // FIXO
	"9" + ; // TIPO REGISTRO
	strzero(nQuant_3,8) +; // QUANTIDADE DE REGISTROS TIPO 3 
	strzero(val(STRTRAN(ALLTRIM(TRANSFORM(nValorBen,"@E 999999.99")),",","")),14) + ; // SOMATORIO DO VALOR DO PEDIDO  
	REPLICATE(" ", 131) + ;   // RESERVADO
    strzero(nSeq_3++,6)     // SEQUENCIA
    
	FWrite(nArq, cBuffer_9 + Chr(13) + Chr(10))
  

	cBuffer_Rodape := "LSUP9" + ;
	cTipo + ; //PRODUTO
	strzero(1,8) + ; // SOMATORIO HEADERS  
	strzero(1,8) + ; // SOMATORIO TRAILLERS 
	strzero(nQuant_3,8) + ; // SOMATORIO PEDIDO  
	REPLICATE(" ", 277)   // EM BRANCOS
    
	FWrite(nArq, cBuffer_Rodape)


If Ferror() # 0
	MsgStop("Ocorreu um erro na gravacao do arquivo!")
	Return
Else
	MsgInfo("Arquivo "+cPath + cArq + ".TXT" + " criado com sucesso!")
EndIf

ZVR1->(dbCloseArea())

FClose(nArq)

Return         




User Function VerbaDesconto()

Local cQuery 	:= ""  
Local nConta	:= 0
Local nAltera	:= 0 
Local cPerg := "ARQVR003"  

cPerg := PadR (cPerg,10," ")
_Ajusta003(cPerg)

If !Pergunte (cPerg,.T.)
	Return
Else      
	cFil    := MV_PAR01
	cVerba  := MV_PAR02
	cMesAno  := DTOS(MV_PAR03) //20130831 
EndIf

cMes    := SUBSTR(cMesAno,5,2)
cAno    := SUBSTR(cMesAno,1,4)

If !MsgBox("Esta função gera verba de desconto na folha atual: " + SUBSTR(GETMV("MV_FOLMES"),5,2) + "/" + SUBSTR(GETMV("MV_FOLMES"),1,4) ,"Confirme","YESNO")
	return
EndIf 

cQuery := "  SELECT  "
cQuery += "  ZVR_FILIAL FILIAL, "
cQuery += "  ZVR_MAT MATRICULA, RA_CC CC,  "
cQuery += "  ZVR_VALVR / 100 * SUBSTR(SRX.RX_TXT,37,6) VALORDESC, "
cQuery += "  SUBSTR(SRX.RX_TXT,37,6) PERCDESC "
cQuery += "  FROM " + RetSQLName("ZVR") + " ZVR "
cQuery += "  INNER JOIN " + RetSQLName("SRA") + " SRA ON RA_MAT = ZVR_MAT AND ZVR_FILIAL = RA_FILIAL AND SRA.D_E_L_E_T_ <> '*' "
cQuery += "  INNER JOIN " + RetSQLName("SRX") + " SRX ON SUBSTR(SRX.RX_COD,13,2)=SRA.RA_VALEREF AND SRX.RX_TIP='26' AND SRX.D_E_L_E_T_ <> '*'  "
cQuery += "  WHERE  "
cQuery += "  ZVR_VALVR > 0 AND ZVR_MESANO = '"+ cMes+cAno +"' AND ZVR_FILIAL = '"+cFil+"' AND ZVR.D_E_L_E_T_ <> '*' "
                               
//MemoWrite("D:\cQuery.txt", cQuery)

TcQuery cQuery new Alias "QRY"   


QRY->(DbGoTop())
If QRY->(Eof())
	msgAlert("Não foi encontrado nenhum item com os parâmetros informados!", "Atenção")
	QRY->(dbCloseArea())
	Return
Endif 

    
    QRY->(DbGoTop())  

	While !QRY->(Eof()) 
	
	DbSelectArea("SRC")
	DbSetOrder(1)
 	DbGoTop()
	IF !DbSeek(QRY->FILIAL+QRY->MATRICULA+cVerba)  
		RecLock("SRC",.t.)	
		SRC->RC_FILIAL := QRY->FILIAL
		SRC->RC_MAT    := QRY->MATRICULA
		SRC->RC_PD     := cVerba
		SRC->RC_TIPO1  := "V"
		SRC->RC_TIPO2  := "G"
		SRC->RC_HORAS  := val(QRY->PERCDESC)
		SRC->RC_VALOR  := QRY->VALORDESC
		SRC->RC_CC     := QRY->CC
		MsUnLock()
		nConta++ 
	ELSE
		RecLock("SRC",.f.)	
        SRC->RC_HORAS  := val(QRY->PERCDESC)
		SRC->RC_VALOR  := QRY->VALORDESC
		MsUnLock()
		nAltera++ 
	EndIf	
	
	QRY->(DbSkip())

	EndDo
    
	MsgInfo ( "<html>Descontos Integrados:<b><span style='color:blue'>" + Str(nConta,3,0) + "</span></b><br><br>Descontos Substituídos:<b><span style='color:red'>" + Str(nAltera,3,0) + "</span></b></html>")  

    QRY->(dbCloseArea())
    SRC->(dbCloseArea())

Return         

 

Static Function _Ajusta000(cPerg)

dbSelectArea("SX1")

SX1->(dbSetOrder(1))

              
If !dbSeek(cPerg+"01")
 RecLock("SX1",.T.)
Else
 RecLock("SX1",.F.)
EndIf

sx1->x1_grupo  := cPerg
sx1->x1_ordem  := '01'
sx1->x1_pergunt:= 'Filial de?                   '
sx1->x1_variavl:= 'mv_ch1'
sx1->x1_tipo   := 'C'
sx1->x1_tamanho:= 2
sx1->x1_decimal:= 0
sx1->x1_gsc    := 'G'
sx1->x1_f3     := 'XM0'
sx1->x1_pyme   := 'S'   
sx1->x1_valid  := 'naovazio()'  
sx1->x1_var01  := 'mv_par01'                                                   
sx1->(MsUnlock())       


If !dbSeek(cPerg+"02")
 RecLock("SX1",.T.)
Else
 RecLock("SX1",.F.)
EndIf

sx1->x1_grupo  := cPerg
sx1->x1_ordem  := '02'
sx1->x1_pergunt:= 'Filial Ate?                   '
sx1->x1_variavl:= 'mv_ch2'
sx1->x1_tipo   := 'C'
sx1->x1_tamanho:= 2
sx1->x1_decimal:= 0
sx1->x1_gsc    := 'G'
sx1->x1_f3     := 'XM0'
sx1->x1_pyme   := 'S'  
sx1->x1_valid  := 'naovazio()'  
sx1->x1_var01  := 'mv_par02'                                                   
sx1->(MsUnlock())       


If !dbSeek(cPerg+"03")
 RecLock("SX1",.T.)
Else
 RecLock("SX1",.F.)
EndIf

sx1->x1_grupo  := cPerg
sx1->x1_ordem  := '03'
sx1->x1_pergunt:= 'Mês Referência'
sx1->x1_variavl:= 'mv_ch3'
sx1->x1_tipo   := 'D'
sx1->x1_tamanho:= 8
sx1->x1_decimal:= 0
sx1->x1_gsc    := 'G'
sx1->x1_pyme   := 'S'  
sx1->x1_valid  := 'naovazio()'  
sx1->x1_var01  := 'mv_par03'                                                   
sx1->(MsUnlock())       

Return




Static Function _Ajusta001(cPerg)

dbSelectArea("SX1")

SX1->(dbSetOrder(1))

If !dbSeek(cPerg+"01")
 RecLock("SX1",.T.)
Else
 RecLock("SX1",.F.)
EndIf

sx1->x1_grupo  := cPerg
sx1->x1_ordem  := '01'
sx1->x1_pergunt:= 'Data do Pedido             '
sx1->x1_variavl:= 'mv_ch1'
sx1->x1_tipo   := 'D'
sx1->x1_tamanho:= 8
sx1->x1_decimal:= 0
sx1->x1_gsc    := 'G'
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
sx1->x1_pergunt:= 'Data da Liberacao             '
sx1->x1_variavl:= 'mv_ch2'
sx1->x1_tipo   := 'D'
sx1->x1_tamanho:= 8
sx1->x1_decimal:= 0
sx1->x1_gsc    := 'G'
sx1->x1_var01  := 'mv_par02'
sx1->x1_valid  := 'naovazio()'                                                                                                      
sx1->(MsUnlock())


If !dbSeek(cPerg+"03")
 RecLock("SX1",.T.)
Else
 RecLock("SX1",.F.)
EndIf

sx1->x1_grupo   :=cPerg
sx1->x1_ordem   :='03'
sx1->x1_pergunt :='Informe o Beneficio?'
sx1->x1_variavl :='mv_ch2'
sx1->x1_tipo    :='N'
sx1->x1_tamanho :=1
sx1->x1_decimal :=0
sx1->x1_gsc     :='C'
sx1->x1_var01   :='mv_par03'
sx1->x1_f3      :=''
sx1->x1_def01   :='Alimentação' // 1
sx1->x1_def02   :='Refeição' // 2
MsUnlock("SX1")
         

If !dbSeek(cPerg+"04")
 RecLock("SX1",.T.)
Else
 RecLock("SX1",.F.)
EndIf

sx1->x1_grupo  := cPerg
sx1->x1_ordem  := '04'
sx1->x1_pergunt:= 'Filial ?                   '
sx1->x1_variavl:= 'mv_ch4'
sx1->x1_tipo   := 'C'
sx1->x1_tamanho:= 2
sx1->x1_decimal:= 0
sx1->x1_gsc    := 'G'
sx1->x1_f3     := 'XM0'
sx1->x1_pyme   := 'S' 
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
sx1->x1_pergunt:= 'Mês Referência'
sx1->x1_variavl:= 'mv_ch5'
sx1->x1_tipo   := 'D'
sx1->x1_tamanho:= 8
sx1->x1_decimal:= 0
sx1->x1_gsc    := 'G'
sx1->x1_pyme   := 'S'  
sx1->x1_valid  := 'naovazio()'  
sx1->x1_var01  := 'mv_par05'                                                   
sx1->(MsUnlock())       


Return




Static Function _Ajusta002(cPerg)

dbSelectArea("SX1")

SX1->(dbSetOrder(1))

If !dbSeek(cPerg+"01")
 RecLock("SX1",.T.)
Else
 RecLock("SX1",.F.)
EndIf

sx1->x1_grupo  := cPerg
sx1->x1_ordem  := '01'
sx1->x1_pergunt:= 'Data do Pedido             '
sx1->x1_variavl:= 'mv_ch1'
sx1->x1_tipo   := 'D'
sx1->x1_tamanho:= 8
sx1->x1_decimal:= 0
sx1->x1_gsc    := 'G'
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
sx1->x1_pergunt:= 'Data da Liberacao             '
sx1->x1_variavl:= 'mv_ch2'
sx1->x1_tipo   := 'D'
sx1->x1_tamanho:= 8
sx1->x1_decimal:= 0
sx1->x1_gsc    := 'G'
sx1->x1_var01  := 'mv_par02'
sx1->x1_valid  := 'naovazio()'                                                                                                      
sx1->(MsUnlock())


If !dbSeek(cPerg+"03")
 RecLock("SX1",.T.)
Else
 RecLock("SX1",.F.)
EndIf

sx1->x1_grupo   :=cPerg
sx1->x1_ordem   :='03'
sx1->x1_pergunt :='Informe o Beneficio?'
sx1->x1_variavl :='mv_ch3'
sx1->x1_tipo    :='N'
sx1->x1_tamanho :=1
sx1->x1_decimal :=0
sx1->x1_gsc     :='C'
sx1->x1_var01   :='mv_par03'
sx1->x1_f3      :=''
sx1->x1_def01   :='Alimentação' // 1
sx1->x1_def02   :='Restaurante' // 2
MsUnlock("SX1")
         
       
If !dbSeek(cPerg+"04")
 RecLock("SX1",.T.)
Else
 RecLock("SX1",.F.)
EndIf

sx1->x1_grupo  := cPerg
sx1->x1_ordem  := '04'
sx1->x1_pergunt:= 'Filial ?                   '
sx1->x1_variavl:= 'mv_ch4'
sx1->x1_tipo   := 'C'
sx1->x1_tamanho:= 2
sx1->x1_decimal:= 0
sx1->x1_gsc    := 'G'
sx1->x1_f3     := 'XM0'
sx1->x1_pyme   := 'S' 
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
sx1->x1_pergunt:= 'Mês Referência'
sx1->x1_variavl:= 'mv_ch5'
sx1->x1_tipo   := 'D'
sx1->x1_tamanho:= 8
sx1->x1_decimal:= 0
sx1->x1_gsc    := 'G'
sx1->x1_pyme   := 'S'  
sx1->x1_valid  := 'naovazio()'  
sx1->x1_var01  := 'mv_par05'                                                   
sx1->(MsUnlock())       
       
                    
Return


Static Function _Ajusta003(cPerg)

dbSelectArea("SX1")

SX1->(dbSetOrder(1))

              
If !dbSeek(cPerg+"01")
 RecLock("SX1",.T.)
Else
 RecLock("SX1",.F.)
EndIf

sx1->x1_grupo  := cPerg
sx1->x1_ordem  := '01'
sx1->x1_pergunt:= 'Filial ?                   '
sx1->x1_variavl:= 'mv_ch1'
sx1->x1_tipo   := 'C'
sx1->x1_tamanho:= 2
sx1->x1_decimal:= 0
sx1->x1_gsc    := 'G'
sx1->x1_f3     := 'XM0'
sx1->x1_pyme   := 'S'
sx1->x1_var01  := 'mv_par01'                                                   
sx1->(MsUnlock())       


If !dbSeek(cPerg+"02")
 RecLock("SX1",.T.)
Else
 RecLock("SX1",.F.)
EndIf

sx1->x1_grupo  := cPerg
sx1->x1_ordem  := '02'
sx1->x1_pergunt:= 'Verba Desconto                   '
sx1->x1_variavl:= 'mv_ch2'
sx1->x1_tipo   := 'C'
sx1->x1_tamanho:= 3
sx1->x1_decimal:= 0
sx1->x1_gsc    := 'G'
sx1->x1_f3     := 'SRV'
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
sx1->x1_pergunt:= 'Mês Referência'
sx1->x1_variavl:= 'mv_ch3'
sx1->x1_tipo   := 'D'
sx1->x1_tamanho:= 8
sx1->x1_decimal:= 0
sx1->x1_gsc    := 'G'
sx1->x1_pyme   := 'S'  
sx1->x1_valid  := 'naovazio()'  
sx1->x1_var01  := 'mv_par03'                                                   
sx1->(MsUnlock())       
                      

Return

