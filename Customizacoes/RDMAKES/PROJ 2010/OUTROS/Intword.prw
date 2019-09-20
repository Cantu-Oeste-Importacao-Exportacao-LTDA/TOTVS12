#INCLUDE 'PROTHEUS.CH' 
#INCLUDE 'RWMAKE.CH'  
#INCLUDE "MSOLE.CH"
#INCLUDE "GPEWORD.CH"
#INCLUDE "TOPCONN.CH"   
                     
/*
+----------+----------+-------+-----------------------+------+----------+
Dioni Reginatto - 03/01/2012
WF - Chamados de integraçao com o word - 
PEDIDO DE MUDANÇA DE SETOR
+----------+------------------------------------------------------------+
 ***************************************************************
 Passa os parâmetros para o Word em .dot - integração com Word
 ***************************************************************/

User Function MudSetor()                      
                    
Local cCadastro := "REQUERIMENTO PARA TRANSFERÊNCIA DE FILIAL "
Local cFunc := CriaVar("RA_MAT")

//Conecta ao word 
Private oWord     := OLE_CreateLink() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName()) 

DEFINE MSDIALOG oDlg1 TITLE cCadastro From 8,0 To 250, 400 OF oMainWnd COLORS 0, 16777215 PIXEL

	oTPanel2 := TPanel():New(0,0,"",oDlg1,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPanel2:Align := CONTROL_ALIGN_ALLCLIENT
	                     
	@15, 05 Say "Funcionário: " size 40, 10  OF oTPanel2 COLORS 0, 16777215 PIXEL
	@14, 60 MSGET oGet Var cFunc Valid (!Empty(cFunc)) F3 "SRA" Size 40, 10  OF oTPanel2 COLORS 0, 16777215 PIXEL
    
	ACTIVATE MSDIALOG oDlg1 CENTER ON INIT ;
	EnchoiceBar(oDlg1,{|| Funcionario(cFunc)}, {|| oDlg1:End() })
  Return Nil 

Static Function Funcionario(cFunc)  

Local cQuery  := ""                                                
Local cData
Local cSetor
Local cDesFun
Local cDataAdm

// caminho do arquivo .DOT   
Local cPathDot  := cGetFile( "arquivo Requerimento | *.dot*" , "Selecione o arquivo TRANSFERÊNCIA DE FILIAL", 0,"",.T.)
if !File(cPathDot)
	Alert("Caminho espeficicado não é válido.")
	Return nil
EndIf     //"c:\Requerimento para mudança de setor.doc" //colocar .dot

cQuery := "SELECT SRA.RA_FILIAL, SRA.RA_NOME, SRA.RA_MAT, "
cQuery += "SRA.RA_ADMISSA, SRA.RA_CC, SRA.RA_X_DESCS, SRA.RA_X_DESCC, SRA.RA_X_DESCF " 
cQuery += "FROM " + RetSqlName("SRA") + " SRA "
cQuery += "WHERE  SRA.RA_MAT = '"+ cFunc +"' AND SRA.d_e_l_e_t_ <> '*' "  
cQuery += "AND SRA.RA_FILIAL = '"+xFilial("SRA")+"' "

//MemoWrite("c:\intword.txt",cQuery)

TCQUERY cQuery NEW ALIAS "TMPSRA"
dbSelectArea("TMPSRA")
IF TMPSRA->(!EOF())	
   dbSelectArea("SRA")
   dbSetOrder(1)
   if dbseek(TMPSRA->RA_FILIAL + cFunc)
      cData   := date()
      cNome   := TMPSRA->RA_NOME
      cSetor  := TMPSRA->RA_X_DESCC + ' - ' + TMPSRA->RA_X_DESCS
      cDesFun := TMPSRA->RA_X_DESCF                                  
      cDataAdm:= SToD(TMPSRA->RA_ADMISSA)  
                                
      TMPSRA->(dbCloseArea())
   endif  
ENDIF      
OLE_NewFile(oWord, cPathDot )    

//OLE_SetDocumentVar(oWord, 'testedioni','testando') 
OLE_SetDocumentVar(oWord,"cData", cData)       //primera variavel é a que está no word, a segunda variável é do codigo
OLE_SetDocumentVar(oWord,"cNome", cNome) 
OLE_SetDocumentVar(oWord,"cSetor", cSetor) 
OLE_SetDocumentVar(oWord,"cDesFun", cDesFun) 
OLE_SetDocumentVar(oWord,"cDataAdm", cDataAdm) 
 
OLE_UpdateFields(oWord) 

Aviso("Carregando...","Documento Carregado com sucesso!",{"OK"},2)
//If MsgYesNo("Imprime o Documento ?") 
   //  Ole_PrintFile(oWord,"ALL",,,1)    //envia paara impressora
//EndIf 

Aviso("Atenção...","Salve o Documento antes de fechar!",{"OK"},2)           
If MsgYesNo("Fechar Documento ?") 
   OLE_CloseFile( oWord ) 
   OLE_CloseLink( oWord ) 
Endif      

Return                    

***********************************************************************************************************************************************


/*
+----------+----------+-------+-----------------------+------+----------+
Dioni Reginatto - 04/01/2012
WF - Chamados de integraçao com o word - 
REQUERIMENTO PARA RESCISÃO CONTRATUAL
+----------+------------------------------------------------------------+
 ***************************************************************
 Passa os parâmetros para o Word em .dot - integração com Word
 ***************************************************************/

User Function RescCont()                      
                    
Local cCadastro := "REQUERIMENTO PARA RESCISÃO CONTRATUAL "
Local cFunc := CriaVar("RA_MAT")

//Conecta ao word 
Private oWord     := OLE_CreateLink()  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

DEFINE MSDIALOG oDlg1 TITLE cCadastro From 8,0 To 250, 400 OF oMainWnd COLORS 0, 16777215 PIXEL

	oTPanel2 := TPanel():New(0,0,"",oDlg1,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPanel2:Align := CONTROL_ALIGN_ALLCLIENT
	                     
	@15, 05 Say "Funcionário: " size 40, 10  OF oTPanel2 COLORS 0, 16777215 PIXEL
	@14, 60 MSGET oGet Var cFunc Valid (!Empty(cFunc)) F3 "SRA" Size 40, 10  OF oTPanel2 COLORS 0, 16777215 PIXEL
    
	ACTIVATE MSDIALOG oDlg1 CENTER ON INIT ;
	EnchoiceBar(oDlg1,{|| ReqResc(cFunc)}, {|| oDlg1:End() })
  Return Nil 

Static Function ReqResc(cFunc)  

Local cQuery  := ""                                                
Local cData
Local cSetor
Local cNome

// caminho do arquivo .DOT   
Local cPathDot  := cGetFile( "arquivo Requerimento | *.dot*" , "Selecione o arquivo RESCISÃO CONTRATUAL", 0,"",.T.)
if !File(cPathDot)
	Alert("Caminho espeficicado não é válido.")
	Return nil
EndIf     

cQuery := "SELECT SRA.RA_FILIAL, SRA.RA_NOME, "
cQuery += "SRA.RA_X_DESCS, SRA.RA_X_DESCC " 
cQuery += "FROM " + RetSqlName("SRA") + " SRA "
cQuery += "WHERE SRA.RA_MAT = '"+ cFunc +"' AND SRA.d_e_l_e_t_ <> '*' "  
cQuery += "AND SRA.RA_FILIAL = '"+xFilial("SRA")+"' "

//MemoWrite("c:\intword.txt",cQuery)

TCQUERY cQuery NEW ALIAS "TMPSRA"
dbSelectArea("TMPSRA")
IF TMPSRA->(!EOF())	
   dbSelectArea("SRA")
   dbSetOrder(1)
   if dbseek(TMPSRA->RA_FILIAL + cFunc)
      cData   := date()
      cNome   := TMPSRA->RA_NOME
      cSetor  := TMPSRA->RA_X_DESCC + ' - ' + TMPSRA->RA_X_DESCS                           
                                      
      TMPSRA->(dbCloseArea())
   endif  
ENDIF      
OLE_NewFile(oWord, cPathDot )    

//OLE_SetDocumentVar(oWord, 'testedioni','testando') 
OLE_SetDocumentVar(oWord,"cData", cData)       //primera variavel é a que está no word, a segunda variável é do codigo
OLE_SetDocumentVar(oWord,"cNome", cNome) 
OLE_SetDocumentVar(oWord,"cSetor", cSetor) 
 
OLE_UpdateFields(oWord) 

Aviso("Carregando...","Documento Carregado com sucesso!",{"OK"},2)
        
Aviso("Atenção...","Salve o Documento antes de fechar!",{"OK"},2)           
If MsgYesNo("Fechar Documento ?") 
   OLE_CloseFile( oWord ) 
   OLE_CloseLink( oWord ) 
Endif

Return 
                                        
************************************************************************************************************************  

/*
+----------+----------+-------+-----------------------+------+----------+
Dioni Reginatto - 05/01/2012
WF - Chamados de integraçao com o word - 
REQUERIMENTO PARA AUMENTO SALARIAL
+----------+------------------------------------------------------------+
 ***************************************************************
 Passa os parâmetros para o Word em .dot - integração com Word
 ***************************************************************/

User Function AumSalar()                      
                    
Local cCadastro := "REQUERIMENTO PARA AUMENTO SALARIAL "
Local cFunc := CriaVar("RA_MAT")

//Conecta ao word 
Private oWord     := OLE_CreateLink()  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

DEFINE MSDIALOG oDlg1 TITLE cCadastro From 8,0 To 250, 400 OF oMainWnd COLORS 0, 16777215 PIXEL

	oTPanel2 := TPanel():New(0,0,"",oDlg1,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPanel2:Align := CONTROL_ALIGN_ALLCLIENT
	                     
	@15, 05 Say "Funcionário: " size 40, 10  OF oTPanel2 COLORS 0, 16777215 PIXEL
	@14, 60 MSGET oGet Var cFunc Valid (!Empty(cFunc)) F3 "SRA" Size 40, 10  OF oTPanel2 COLORS 0, 16777215 PIXEL
    
	ACTIVATE MSDIALOG oDlg1 CENTER ON INIT ;
	EnchoiceBar(oDlg1,{|| ReqSal(cFunc)}, {|| oDlg1:End() })
  Return Nil 

Static Function ReqSal(cFunc)  

Local cQuery  := ""                                                
Local cData
Local cSetor
Local cNome
Local cDataAdm, cSalario
   

// caminho do arquivo .DOT   
Local cPathDot  := cGetFile( "arquivo Requerimento | *.dot*" , "Selecione o arquivo AUMENTO SALARIAL", 0,"",.T.)
if !File(cPathDot)
	Alert("Caminho espeficicado não é válido.")
	Return nil
EndIf     

cQuery := "SELECT SRA.RA_FILIAL, SRA.RA_NOME, "
cQuery += "SRA.RA_X_DESCS, SRA.RA_X_DESCC, SRA.RA_SALARIO, SRA.RA_ADMISSA " 
cQuery += "FROM " + RetSqlName("SRA") + " SRA "
cQuery += "WHERE SRA.RA_MAT = '"+ cFunc +"' AND SRA.d_e_l_e_t_ <> '*' "  
cQuery += "AND SRA.RA_FILIAL = '"+xFilial("SRA")+"' "

//MemoWrite("c:\intword.txt",cQuery)

TCQUERY cQuery NEW ALIAS "TMPSRA"
dbSelectArea("TMPSRA")
IF TMPSRA->(!EOF())	
   dbSelectArea("SRA")
   dbSetOrder(1)
   if dbseek(TMPSRA->RA_FILIAL + cFunc)
      cData   := date()
      cNome   := TMPSRA->RA_NOME
      cSetor  := TMPSRA->RA_X_DESCC + ' - ' + TMPSRA->RA_X_DESCS                           
      cDataAdm:= SToD(TMPSRA->RA_ADMISSA)  
      cSalario:= Transform(TMPSRA->RA_SALARIO, "@E 99,999,999.99")                                
   
      TMPSRA->(dbCloseArea())
   endif  
ENDIF      
OLE_NewFile(oWord, cPathDot )    

//OLE_SetDocumentVar(oWord, 'testedioni','testando') 
OLE_SetDocumentVar(oWord,"cData", cData)       //primera variavel é a que está no word, a segunda variável é do codigo
OLE_SetDocumentVar(oWord,"cNome", cNome) 
OLE_SetDocumentVar(oWord,"cSetor", cSetor) 
OLE_SetDocumentVar(oWord,"cDataAdm", cDataAdm) 
OLE_SetDocumentVar(oWord,"cSalario", cSalario)
 
OLE_UpdateFields(oWord) 

Aviso("Carregando...","Documento Carregado com sucesso!",{"OK"},2)
                      
Aviso("Atenção...","Salve o Documento antes de fechar!",{"OK"},2)           
If MsgYesNo("Fechar Documento ?") 
   OLE_CloseFile( oWord ) 
   OLE_CloseLink( oWord ) 
Endif

Return 

***********************************************************************************************************************************                                        

/*
+----------+----------+-------+-----------------------+------+----------+
Dioni Reginatto - 06/01/2012
WF - Chamados de integraçao com o word - 
REQUERIMENTO PARA MUDANÇA DE FUNÇÃO
+----------+------------------------------------------------------------+
 ***************************************************************
 Passa os parâmetros para o Word em .dot - integração com Word
 ***************************************************************/

User Function MudFunc()                      
                    
Local cCadastro := "REQUERIMENTO PARA MUDANÇA DE FUNÇÃO "
Local cFunc := CriaVar("RA_MAT")

//Conecta ao word 
Private oWord     := OLE_CreateLink()  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

DEFINE MSDIALOG oDlg1 TITLE cCadastro From 8,0 To 250, 400 OF oMainWnd COLORS 0, 16777215 PIXEL

	oTPanel2 := TPanel():New(0,0,"",oDlg1,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPanel2:Align := CONTROL_ALIGN_ALLCLIENT
	                     
	@15, 05 Say "Funcionário: " size 40, 10  OF oTPanel2 COLORS 0, 16777215 PIXEL
	@14, 60 MSGET oGet Var cFunc Valid (!Empty(cFunc)) F3 "SRA" Size 40, 10  OF oTPanel2 COLORS 0, 16777215 PIXEL
    
	ACTIVATE MSDIALOG oDlg1 CENTER ON INIT ;
	EnchoiceBar(oDlg1,{|| ReqFunc(cFunc)}, {|| oDlg1:End() })
  Return Nil 

Static Function ReqFunc(cFunc)  

Local cQuery  := ""                                                
Local cData
Local cSetor
Local cDesFun
Local cDataAdm
Local cSalario

// caminho do arquivo .DOT   
Local cPathDot  := cGetFile( "arquivo Requerimento | *.dot*" , "Selecione o arquivo MUDANÇA DE FUNÇÃO", 0,"",.T.)
if !File(cPathDot)
	Alert("Caminho espeficicado não é válido.")
	Return nil
EndIf    

cQuery := "SELECT SRA.RA_FILIAL, SRA.RA_NOME, SRA.RA_MAT, SRA.RA_SALARIO, "
cQuery += "SRA.RA_ADMISSA, SRA.RA_CC, SRA.RA_X_DESCS, SRA.RA_X_DESCC, SRA.RA_X_DESCF " 
cQuery += "FROM " + RetSqlName("SRA") + " SRA "
cQuery += "WHERE  SRA.RA_MAT = '"+ cFunc +"' AND SRA.d_e_l_e_t_ <> '*' "  
cQuery += "AND SRA.RA_FILIAL = '"+xFilial("SRA")+"' "

//MemoWrite("c:\intword.txt",cQuery)

TCQUERY cQuery NEW ALIAS "TMPSRA"
dbSelectArea("TMPSRA")
IF TMPSRA->(!EOF())	
   dbSelectArea("SRA")
   dbSetOrder(1)
   if dbseek(TMPSRA->RA_FILIAL + cFunc)
      cData   := date()
      cNome   := TMPSRA->RA_NOME
      cSetor  := TMPSRA->RA_X_DESCC + ' - ' + TMPSRA->RA_X_DESCS
      cDesFun := TMPSRA->RA_X_DESCF                                  
      cDataAdm:= SToD(TMPSRA->RA_ADMISSA)  
      cSalario:= Transform(TMPSRA->RA_SALARIO, "@E 99,999,999.99")
                                
      TMPSRA->(dbCloseArea())
   endif  
ENDIF      
OLE_NewFile(oWord, cPathDot )    
 
OLE_SetDocumentVar(oWord,"cData", cData)       //primera variavel é a que está no word, a segunda variável é do codigo
OLE_SetDocumentVar(oWord,"cNome", cNome) 
OLE_SetDocumentVar(oWord,"cSetor", cSetor) 
OLE_SetDocumentVar(oWord,"cDesFun", cDesFun) 
OLE_SetDocumentVar(oWord,"cDataAdm", cDataAdm) 
OLE_SetDocumentVar(oWord,"cSalario", cSalario) 
OLE_UpdateFields(oWord) 

Aviso("Carregando...","Documento Carregado com sucesso!",{"OK"},2)

Aviso("Atenção...","Salve o Documento antes de fechar!",{"OK"},2)           
If MsgYesNo("Fechar Documento ?") 
   OLE_CloseFile( oWord ) 
   OLE_CloseLink( oWord ) 
Endif

Return                                                                                                                      

****************************************************************************************************************************