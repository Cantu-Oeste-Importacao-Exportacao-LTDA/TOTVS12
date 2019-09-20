#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH" 


User Function wfnotadoc() 

Local cEmpIni := "01"
Local cFilIni := "01" 
Local aEmp := {}

RpcClearEnv()
RPCSetType(3)
PREPARE ENVIRONMENT EMPRESA cEmpIni FILIAL cFilIni MODULO "COM" TABLES "SF1","AC9"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Abre a tabela de empresas do sistema e adiciona o código da empresa no aEmp³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
DbSelectArea("SM0")
DbSetOrder(01)
DbGoTop()
       
While !SM0->(EOF())  
	If !SM0->M0_CODIGO $"06/07/09"
		aAdd(aEmp, {SM0->M0_CODIGO,SM0->M0_CODFIL})
    End
   	SM0->(dbSkip()) 
Enddo  

For nI := 1 To Len(aEmp)
	U_WfNFDoc(aEmp[nI][1], aEmp[nI][2])
Next nI

Return

user Function WfNFDoc(cEmpAtu, cFilAtu)   
aEmp     := {} 
cEmpresa := "" 
cCod	 := ""
cAliasSF1 := GetNextAlias()
nLidos	 := 0   
aNotas	 := {}  


RpcClearEnv()
RPCSetType(3)
PREPARE ENVIRONMENT EMPRESA cEmpAtu FILIAL cFilAtu MODULO "COM" TABLES "SF1","AC9"
              
dDataAux := DtoS(dDataBase - 1)
cEmAtu   := cEmpAnt   

ConOut("WFNOTADOC - EMPRESA: " + cEmpAnt)
BeginSql Alias cAliasSF1    
 
	SELECT  %Exp:cEmAtu%  AS EMPRESA,
	        F1.F1_FILIAL AS FILIAL,
			F1.F1_DOC AS NOTA,
			F1.F1_SERIE AS SERIE,
			F1.F1_FORNECE AS FORNECEDOR, 
			F1.F1_LOJA AS LOJA,
            F1.F1_DTDIGIT AS DIGITACAO,
            F1.F1_USUARIO AS USUARIO,
            F1.F1_TIPO AS TIPO, 
            F1.F1_FORMUL AS FORMULARIO 
   		  FROM %table:SF1% F1
 	      	WHERE F1.F1_DTDIGIT = %Exp:dDataAux% 
   	   		AND F1.%Notdel%   
   	   		AND F1.F1_FILIAL = %Exp:cFilAtu%
       		AND F1.F1_STATUS  = %Exp:'A'% 
       		AND NOT EXISTS (SELECT * FROM %table:AC9% AC 
                        		WHERE AC.%Notdel%
                         		AND AC.AC9_FILENT = F1.F1_FILIAL 
                          		AND SUBSTR(AC.AC9_CODENT,1,9) = F1.F1_DOC 
                          		AND SUBSTR(AC.AC9_CODENT,10,3)= F1.F1_SERIE 
                          		AND SUBSTR(AC.AC9_CODENT,13,9)= F1.F1_FORNECE 
                          		AND SUBSTR(AC.AC9_CODENT,22,4)= F1.F1_LOJA) 
		
EndSql                                                                      


dbSelectArea(cAliasSF1)
(cAliasSF1)->(dbGoTop())

While !(cAliasSF1)->(EOF())  
	If (cAliasSF1)->TIPO == 'D' .AND. (cAliasSF1)->FORMULARIO == 'S'	 
		Conout("Documento Ignorado "+(cAliasSF1)->NOTA)
	ELse
		
		aAdd(aNotas,{(cAliasSF1)->EMPRESA,(cAliasSF1)->FILIAL,(cAliasSF1)->NOTA,(cAliasSF1)->SERIE,(cAliasSF1)->FORNECEDOR,(cAliasSF1)->LOJA,(cAliasSF1)->DIGITACAO,(cAliasSF1)->USUARIO,(cAliasSF1)->TIPO,(cAliasSF1)->FORMULARIO})
	EndIf
	(cAliasSF1)->(dbSkip())
EndDo 
	
(cAliasSF1)->(dbCloseArea())   

IF Len(aNotas) > 0
	oProcess := TWFProcess():New("WFDOCNF", "Notas sem documento Anexado")
	oProcess:NewTask("WFDOCNF", "\workflow\wfnfdoc.html" )
	oProcess:cSubject := "Workflow de Notas sem Documento Anexado  "
	oHTML := oProcess:oHTML
	
	aSort( aNotas,,, { |x,y| x[1]+x[2] < y[1]+y[2] } )
	
	For i:=1 to Len(aNotas)
		/*cNomeFil := ''
	
		cNomeFil := Posicione("SM0",1,aNotas[i][1],"SM0->M0_NOME")
	
		if Alltrim(cEmpresa) != aNotas[i][1]
		
		EndIf   */
		aAdd((oHtml:ValByName("IT.EMPRESA")),aNotas[i][1])
		aAdd((oHtml:ValByName("IT.FILIAL" )),aNotas[i][2]) 
		aAdd((oHtml:ValByName("IT.NUMERO" )),aNotas[i][3])
		aAdd((oHtml:ValByName("IT.SERIE"  )),aNotas[i][4])
		aAdd((oHtml:ValByName("IT.FORNECE")),aNotas[i][5])
		aAdd((oHtml:ValByName("IT.LOJA"   )),aNotas[i][6])		
		aAdd((oHtml:ValByName("IT.DIGIT"  )),DToC(StoD(aNotas[i][7])))
		aAdd((oHtml:ValByName("IT.USER"   )),aNotas[i][8])
		aAdd((oHtml:ValByName("IT.TIPO"   )),aNotas[i][9])
		aAdd((oHtml:ValByName("IT.FORMUL" )),aNotas[i][10]) 
		nLidos++		             
	
		cEmpresa := aNotas[i][1]		
	
	Next i  
    
    If nLidos = 0
    	oHtml:ValByName( "IT.FILIAL"  ,"NENHUM REGISTRO")      
    EndIf             	                               
    
	// envia o email com a lista de clientes bloqueados  
	oProcess:cTo  := AllTrim(SuperGetMV("MV_X_NFDOC", ,'suporte@cantu.com.br'))
	oProcess:Start()
	oProcess:Finish() 
	oProcess:Free()    
		                                
EndIf	

Return()