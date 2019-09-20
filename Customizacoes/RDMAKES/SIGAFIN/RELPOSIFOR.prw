#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "report.ch"
 
User Function RELPOSIFOR()
	Local oReport := nil
	Local cPerg:= "RELPOSIFOR"
	
	//Incluo/Altero as perguntas na tabela SX1
	ajustaSx1(cPerg)	
	//gero a pergunta de modo oculto, ficando disponível no botão ações relacionadas
	Pergunte(cPerg,.F.)	          
		
	oReport := RptDef(cPerg)
	oReport:PrintDialog()  
	

Return
 
Static Function RptDef(cNome)
	Local oReport := Nil
	Local oSection1:= Nil
	Local oSection2:= Nil
	Local oBreak
	Local oFunction
	
	/*Sintaxe: TReport():New(cNome,cTitulo,cPerguntas,bBlocoCodigo,cDescricao)*/
	oReport := TReport():New(cNome,"Relatório Fornecedor x Movimentaçoes",cNome,{|oReport| ReportPrint(oReport)},"Descrição do meu relatório")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.T.) 
	

	
	//Monstando a primeira seção
	//Aqui crio a primeira seção, onde sera o cabeçalho do relatório.
	oSection1:= TRSection():New(oReport, "Fornecedor", {"SE5"})
	TRCell():New(oSection1,"E5_FILIAL"  ,"SE5","Filial")
	TRCell():New(oSection1,"A2_COD"		,"SA2","Fornecedor")
	TRCell():New(oSection1,"A2_LOJA"    ,"SA2","Loja") 
	TRCell():New(oSection1,"A2_NOME"    ,"SA2","Nome fornecedor")
	TRCell():New(oSection1,"E2_EMISSAO" ,"SE2","Emissao") 
	TRCell():New(oSection1,"E5_NUMERO" 	,"SE5","Titulo")       
	TRCell():New(oSection1,"E5_PARCELA" ,"SE5","Parcela")

	
	//A segunda seção, será apresentado apresentada todas as movimentações para o titulo.    

	oSection2:= TRSection():New(oReport, "Movimento", {"SE5"})  
    TRCell():New(oSection2,"E5_MOTBX"	,"SE5","Motivo Baixa")
	TRCell():New(oSection2,"E5_VALOR"	,"SE5","Valor")	
	TRCell():New(oSection2,"E5_DATA"	,"SE5","Data Movimento")	
	TRCell():New(oSection2,"E5_HISTOR"	,"SE5","Historico")
	TRCell():New(oSection2,"E5_DOCUMEN"	,"SE5","Documento")
        

	TRFunction():New(oSection1:Cell("E5_NUMERO"),NIL,"COUNT",,,,,.F.,.T.)
	
	oReport:SetTotalInLine(.F.)
       
        //Aqui, quebro por pagina (.F.ou .T.)
	oSection1:SetPageBreak(.F.)
	oSection1:SetTotalText("Total de titulos:")				
Return(oReport)
 
Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)	 
	Local cQuery    := ""		
	Local cTit      := ""   
	Local lPrim 	:= .T.	      
 
	//Monto minha consulta conforme parametros passado
	cQuery := "	SELECT E5_FILIAL, A2_COD, A2_LOJA, E5_NUMERO, E5_PARCELA, E5_MOTBX, E5_VALOR, TO_DATE(E5_DATA,'YYYYMMDD') AS DATA, E5_HISTOR, E5_DOCUMEN, A2_NOME, TO_DATE(E2_EMISSAO,'YYYYMMDD') AS EMISSAO "
	cQuery += "	FROM "+RETSQLNAME("SA2")+" SA2 "
	cQuery += "	LEFT JOIN "+RETSQLNAME("SE5")+" SE5 ON SE5.D_E_L_E_T_= ' ' AND E5_CLIFOR = A2_COD AND E5_LOJA = A2_LOJA " 
	cQuery += "	LEFT JOIN "+RETSQLNAME("SE2")+" SE2 ON SE2.D_E_L_E_T_= ' ' AND E5_CLIFOR = E2_FORNECE AND E5_LOJA = E2_LOJA AND E5_TIPO = E2_TIPO AND E5_FILIAL = E2_FILIAL AND E5_NUMERO = E2_NUM AND E5_PREFIXO = E2_PREFIXO "
	cQuery += "	WHERE SA2.D_E_L_E_T_=' ' "  
	cQuery += " AND A2_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cQuery += " AND A2_LOJA BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'" 
	cQuery += " AND E5_DATA >= '" + DTOS(MV_PAR05)	+ "'"
	cQuery += " AND E5_DATA <= '" + DTOS(MV_PAR06)	+ "'"
	
	cQuery += "	ORDER BY E5_NUMERO "
		
	
	//crio o novo alias
	TCQUERY cQuery NEW ALIAS "TRBSA2"	
	
	dbSelectArea("TRBSA2")
    TRBSA2->(dbGoTop())
	
    TRBSA2->(LastRec())

	

	//Irei percorrer todos os meus registros
	While !Eof()
		
		If oReport:Cancel()
			Exit
		EndIf
	
		//inicializo a primeira seção
		oSection1:Init()
 
		oReport:IncMeter()

		cTit 	:= TRBSA2->E5_NUMERO
		IncProc("Imprimindo Fornecedor "+alltrim(E5_NUMERO))        
		oReport:ThinLine()  
       
		//imprimo a primeira seção				
		oSection1:Cell("E5_FILIAL"):SetValue(E5_FILIAL)
		oSection1:Cell("A2_COD"):SetValue(A2_COD)
		oSection1:Cell("A2_LOJA"):SetValue(A2_LOJA)	  
		oSection1:Cell("A2_NOME"):SetValue(A2_NOME)	  
		oSection1:Cell("E2_EMISSAO"):SetValue(EMISSAO)	  
		oSection1:Cell("E5_NUMERO"):SetValue(E5_NUMERO)			
		oSection1:Cell("E5_PARCELA"):SetValue(E5_PARCELA) 
		

		oSection1:Printline()  
	           
	
		
		//inicializo a segunda seção
		oSection2:init()

		
		//verifico se o numero é mesmo, se sim, imprimo suas movimentações
		While TRBSA2-> E5_NUMERO == cTit
			oReport:IncMeter()		
		
			IncProc("Imprimindo movimentos "+alltrim(E5_VALOR)) 
		    oSection2:Cell("E5_MOTBX"):SetValue(E5_MOTBX)
			oSection2:Cell("E5_VALOR"):SetValue(E5_VALOR)						
			oSection2:Cell("E5_DATA"):SetValue(DATA)
			oSection2:Cell("E5_HISTOR"):SetValue(E5_HISTOR)
			oSection2:Cell("E5_DOCUMEN"):SetValue(E5_DOCUMEN)
			oSection2:Printline()    
			
	
 			TRBSA2->(dbSkip())
 		EndDo		
 		//finalizo a segunda seção para que seja reiniciada para o proximo registro
 		oSection2:Finish()
 		//imprimo uma linha para separar uma fornecedor de outro
 	  	//oReport:ThinLine()            
 		//finalizo a primeira seção
		oSection1:Finish()
	Enddo
Return
 
static function ajustaSx1(cPerg)
	//Aqui utilizo a função putSx1, ela cria a pergunta na tabela de perguntas
PutSX1(cPerg, "01", "Fornecedor De       ?", "Fornecedor De        ?", "Fornecedor De       ?", "mv_ch1"  ,"C",TAMSX3("A2_COD")[1]	,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",PESQPICT("SA2", "A2_COD"))
PutSX1(cPerg, "02", "Fornecedor Até      ?", "Fornecedor Até       ?", "Fornecedor Até      ?", "mv_ch2"  ,"C",TAMSX3("A2_COD")[1]	,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",PESQPICT("SA2", "A2_COD"))
PutSX1(cPerg, "03", "Loja De       ?", "Loja De        ?", "Loja De       ?", "mv_ch3"  ,"C",TAMSX3("A2_LOJA")[1]	,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",PESQPICT("SA2", "A2_LOJA"))
PutSX1(cPerg, "04", "Loja Até      ?", "Loja Até       ?", "Loja Até      ?", "mv_ch4"  ,"C",TAMSX3("A2_LOJA")[1]	,0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","",PESQPICT("SA2", "A2_LOJA"))
PutSX1(cPerg, "05", "Data De       ?", "Data De        ?", "Data De       ?", "mv_ch5"  ,"D",TAMSX3("E5_DATA")[1]	,0,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",PESQPICT("SE5", "E5_DATA"))
PutSX1(cPerg, "06", "Data Até      ?", "Dataa Até      ?", "Data Até      ?", "mv_ch6"  ,"D",TAMSX3("E5_DATA")[1]	,0,0,"G","","","","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","",PESQPICT("SE5", "E5_DATA"))


return