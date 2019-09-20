#INCLUDE 'PROTHEUS.CH' 
#INCLUDE 'RWMAKE.CH'  
#INCLUDE "MSOLE.CH"
#INCLUDE "GPEWORD.CH"
#INCLUDE "TOPCONN.CH"   
                     
/*
+----------+----------+-------+-----------------------+------+----------+
Dioni Reginatto - 03/01/2012
WF - Chamados de integra�ao com o word - 
PEDIDO DE MUDAN�A DE SETOR
+----------+------------------------------------------------------------+
 ***************************************************************
 Passa os par�metros para o Word em .dot - integra��o com Word
 ***************************************************************/

User Function MudSetor()                      
                    
Local cCadastro := "REQUERIMENTO PARA TRANSFER�NCIA DE FILIAL "
Local cFunc := CriaVar("RA_MAT")

//Conecta ao word 
Private oWord     := OLE_CreateLink() 

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName()) 

DEFINE MSDIALOG oDlg1 TITLE cCadastro From 8,0 To 250, 400 OF oMainWnd COLORS 0, 16777215 PIXEL

	oTPanel2 := TPanel():New(0,0,"",oDlg1,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPanel2:Align := CONTROL_ALIGN_ALLCLIENT
	                     
	@15, 05 Say "Funcion�rio: " size 40, 10  OF oTPanel2 COLORS 0, 16777215 PIXEL
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
Local cPathDot  := cGetFile( "arquivo Requerimento | *.dot*" , "Selecione o arquivo TRANSFER�NCIA DE FILIAL", 0,"",.T.)
if !File(cPathDot)
	Alert("Caminho espeficicado n�o � v�lido.")
	Return nil
EndIf     //"c:\Requerimento para mudan�a de setor.doc" //colocar .dot

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
OLE_SetDocumentVar(oWord,"cData", cData)       //primera variavel � a que est� no word, a segunda vari�vel � do codigo
OLE_SetDocumentVar(oWord,"cNome", cNome) 
OLE_SetDocumentVar(oWord,"cSetor", cSetor) 
OLE_SetDocumentVar(oWord,"cDesFun", cDesFun) 
OLE_SetDocumentVar(oWord,"cDataAdm", cDataAdm) 
 
OLE_UpdateFields(oWord) 

Aviso("Carregando...","Documento Carregado com sucesso!",{"OK"},2)
//If MsgYesNo("Imprime o Documento ?") 
   //  Ole_PrintFile(oWord,"ALL",,,1)    //envia paara impressora
//EndIf 

Aviso("Aten��o...","Salve o Documento antes de fechar!",{"OK"},2)           
If MsgYesNo("Fechar Documento ?") 
   OLE_CloseFile( oWord ) 
   OLE_CloseLink( oWord ) 
Endif      

Return                    

***********************************************************************************************************************************************


/*
+----------+----------+-------+-----------------------+------+----------+
Dioni Reginatto - 04/01/2012
WF - Chamados de integra�ao com o word - 
REQUERIMENTO PARA RESCIS�O CONTRATUAL
+----------+------------------------------------------------------------+
 ***************************************************************
 Passa os par�metros para o Word em .dot - integra��o com Word
 ***************************************************************/

User Function RescCont()                      
                    
Local cCadastro := "REQUERIMENTO PARA RESCIS�O CONTRATUAL "
Local cFunc := CriaVar("RA_MAT")

//Conecta ao word 
Private oWord     := OLE_CreateLink()  

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

DEFINE MSDIALOG oDlg1 TITLE cCadastro From 8,0 To 250, 400 OF oMainWnd COLORS 0, 16777215 PIXEL

	oTPanel2 := TPanel():New(0,0,"",oDlg1,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPanel2:Align := CONTROL_ALIGN_ALLCLIENT
	                     
	@15, 05 Say "Funcion�rio: " size 40, 10  OF oTPanel2 COLORS 0, 16777215 PIXEL
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
Local cPathDot  := cGetFile( "arquivo Requerimento | *.dot*" , "Selecione o arquivo RESCIS�O CONTRATUAL", 0,"",.T.)
if !File(cPathDot)
	Alert("Caminho espeficicado n�o � v�lido.")
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
OLE_SetDocumentVar(oWord,"cData", cData)       //primera variavel � a que est� no word, a segunda vari�vel � do codigo
OLE_SetDocumentVar(oWord,"cNome", cNome) 
OLE_SetDocumentVar(oWord,"cSetor", cSetor) 
 
OLE_UpdateFields(oWord) 

Aviso("Carregando...","Documento Carregado com sucesso!",{"OK"},2)
        
Aviso("Aten��o...","Salve o Documento antes de fechar!",{"OK"},2)           
If MsgYesNo("Fechar Documento ?") 
   OLE_CloseFile( oWord ) 
   OLE_CloseLink( oWord ) 
Endif

Return 
                                        
************************************************************************************************************************  

/*
+----------+----------+-------+-----------------------+------+----------+
Dioni Reginatto - 05/01/2012
WF - Chamados de integra�ao com o word - 
REQUERIMENTO PARA AUMENTO SALARIAL
+----------+------------------------------------------------------------+
 ***************************************************************
 Passa os par�metros para o Word em .dot - integra��o com Word
 ***************************************************************/

User Function AumSalar()                      
                    
Local cCadastro := "REQUERIMENTO PARA AUMENTO SALARIAL "
Local cFunc := CriaVar("RA_MAT")

//Conecta ao word 
Private oWord     := OLE_CreateLink()  

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

DEFINE MSDIALOG oDlg1 TITLE cCadastro From 8,0 To 250, 400 OF oMainWnd COLORS 0, 16777215 PIXEL

	oTPanel2 := TPanel():New(0,0,"",oDlg1,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPanel2:Align := CONTROL_ALIGN_ALLCLIENT
	                     
	@15, 05 Say "Funcion�rio: " size 40, 10  OF oTPanel2 COLORS 0, 16777215 PIXEL
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
	Alert("Caminho espeficicado n�o � v�lido.")
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
OLE_SetDocumentVar(oWord,"cData", cData)       //primera variavel � a que est� no word, a segunda vari�vel � do codigo
OLE_SetDocumentVar(oWord,"cNome", cNome) 
OLE_SetDocumentVar(oWord,"cSetor", cSetor) 
OLE_SetDocumentVar(oWord,"cDataAdm", cDataAdm) 
OLE_SetDocumentVar(oWord,"cSalario", cSalario)
 
OLE_UpdateFields(oWord) 

Aviso("Carregando...","Documento Carregado com sucesso!",{"OK"},2)
                      
Aviso("Aten��o...","Salve o Documento antes de fechar!",{"OK"},2)           
If MsgYesNo("Fechar Documento ?") 
   OLE_CloseFile( oWord ) 
   OLE_CloseLink( oWord ) 
Endif

Return 

***********************************************************************************************************************************                                        

/*
+----------+----------+-------+-----------------------+------+----------+
Dioni Reginatto - 06/01/2012
WF - Chamados de integra�ao com o word - 
REQUERIMENTO PARA MUDAN�A DE FUN��O
+----------+------------------------------------------------------------+
 ***************************************************************
 Passa os par�metros para o Word em .dot - integra��o com Word
 ***************************************************************/

User Function MudFunc()                      
                    
Local cCadastro := "REQUERIMENTO PARA MUDAN�A DE FUN��O "
Local cFunc := CriaVar("RA_MAT")

//Conecta ao word 
Private oWord     := OLE_CreateLink()  

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

DEFINE MSDIALOG oDlg1 TITLE cCadastro From 8,0 To 250, 400 OF oMainWnd COLORS 0, 16777215 PIXEL

	oTPanel2 := TPanel():New(0,0,"",oDlg1,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPanel2:Align := CONTROL_ALIGN_ALLCLIENT
	                     
	@15, 05 Say "Funcion�rio: " size 40, 10  OF oTPanel2 COLORS 0, 16777215 PIXEL
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
Local cPathDot  := cGetFile( "arquivo Requerimento | *.dot*" , "Selecione o arquivo MUDAN�A DE FUN��O", 0,"",.T.)
if !File(cPathDot)
	Alert("Caminho espeficicado n�o � v�lido.")
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
 
OLE_SetDocumentVar(oWord,"cData", cData)       //primera variavel � a que est� no word, a segunda vari�vel � do codigo
OLE_SetDocumentVar(oWord,"cNome", cNome) 
OLE_SetDocumentVar(oWord,"cSetor", cSetor) 
OLE_SetDocumentVar(oWord,"cDesFun", cDesFun) 
OLE_SetDocumentVar(oWord,"cDataAdm", cDataAdm) 
OLE_SetDocumentVar(oWord,"cSalario", cSalario) 
OLE_UpdateFields(oWord) 

Aviso("Carregando...","Documento Carregado com sucesso!",{"OK"},2)

Aviso("Aten��o...","Salve o Documento antes de fechar!",{"OK"},2)           
If MsgYesNo("Fechar Documento ?") 
   OLE_CloseFile( oWord ) 
   OLE_CloseLink( oWord ) 
Endif

Return                                                                                                                      

****************************************************************************************************************************