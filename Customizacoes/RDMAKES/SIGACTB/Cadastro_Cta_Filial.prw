#include "rwmake.ch"

//
//эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
//╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
//╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
//╠╠╨Programa  Ё CCT002   ╨ Autor Ё Pedro A. de Souza  ╨ Data ЁMon  21/11/07╨╠╠
//╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
//╠╠╨Descri┤└o Ё Cadastro de Contas por Filiais                             ╨╠╠
//╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
//╠╠╨Uso       Ё Especifico para Cantu                                      ╨╠╠
//╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
//╠╠╨Arquivos  Ё SZ0 -> Cabecalho de Contas                                 ╨╠╠
//╠╠╨          Ё SZ1 -> Filiais das Contas                                  ╨╠╠
//╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
//╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
//ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
//
User Function cct002()
   SetPrvt("CCADASTRO,AROTINA,")
   cCadastro := "Cadastro de Contas Contabeis Filiais"
   aRotina   := { { "Pesquisar"    ,"AxPesqui" , 0, 1},;
                  { "Visualizar"   ,'ExecBlock("CADSZ0VIS",.F.,.F.)' , 0, 2},;
                  { "Incluir"      ,'ExecBlock("CADSZ0INC",.F.,.F.)' , 0, 3},;
                  { "Alterar"      ,'ExecBlock("CADSZ0ALT",.F.,.F.)' , 0, 4},;
                  { "Excluir"      ,'ExecBlock("CADSZ0EXC",.F.,.F.)' , 0, 5},;
                  { "I&mprimir"    ,'ExecBlock("CADSZ0IMP",.F.,.F.)' , 0, 6} }

	//здддддддддддддддддддддддддддддддддддддддддддддддддддд
	//ЁChama funГЦo para monitor uso de fontes customizadosЁ
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддд
	U_USORWMAKE(ProcName(),FunName())

   dbSelectArea("SZ0")
   dbSetOrder(1)
   mBrowse( 6,1,22,75,"SZ0")
Return


//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Rotina de VisualizaГЦo                                              Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

User Function CADSZ0VIS()            

	//здддддддддддддддддддддддддддддддддддддддддддддддддддд
	//ЁChama funГЦo para monitor uso de fontes customizadosЁ
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддд
	U_USORWMAKE(ProcName(),FunName())    

   SetPrvt("COPCAO,NOPCE,NOPCG,NUSADO,AHEADER,ACOLS")
   SetPrvt("N,_NI,CCPO,_NPOSORDEM,CTITULO,CALIASENCHOICE")
   SetPrvt("CALIASGETD,CLINOK,CTUDOK,CFIELDOK,ACPOENCHOICE,_LRET")

   dbSelectArea("SZ0")
   If EOF() .And. BOF()
       Help("",1,"ARQVAZIO")
       Return
   Endif

   //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё Opcoes de acesso para a Modelo 3                             Ё
   //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

   cOpcao := "VISUALIZAR"
   nOpcE := 2 ; nOpcG := 2

   //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё Cria variaveis M->????? da Enchoice                          Ё
   //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

   RegToMemory("SZ0",(cOpcao == "INCLUIR"))

   //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё Cria aHeader e aCols da GetDados                             Ё
   //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   aHeader := {}
   aCols   := {}
   nUsado  := 0
   mtaMod3(@aHeader, @aCols, @nUsado)

   //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё Executa a Modelo 3                                           Ё
   //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды     

   cTitulo        := "Cadastro de Contas Contabeis Filiais"
   cAliasEnchoice := "SZ0"
   cAliasGetD     := "SZ1"
   cLinOk         := 'ExecBlock("ValidSZ0",.F.,.F.)'
   cTudOk         := "AllwaysTrue()"
   cFieldOk       := "AllwaysTrue()"
   aCpoEnchoice   := {"Z0_CODIGO"}
   n              := 1
   _lRet := Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk)
Return            


//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Rotina de InclusЦo                                           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды   

User Function CADSZ0INC()
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддд
	//ЁChama funГЦo para monitor uso de fontes customizadosЁ
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддд
	U_USORWMAKE(ProcName(),FunName())

   SetPrvt("COPCAO,NOPCE,NOPCG,NUSADO,AHEADER,ACOLS")
   SetPrvt("_NI,_NPOSFIL,_NPOSCONTA,CTITULO")
   SetPrvt("CALIASENCHOICE,CALIASGETD,CLINOK,CTUDOK,CFIELDOK,ACPOENCHOICE")
   SetPrvt("_LRET,NNUMIT,NIT,_NPOSABS,_LCOMMIT")
   _lCommit := .F.  // Utilizado para verificar se o registro foi gravado e incrementar o SXE

   //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё Opcoes de acesso para a Modelo 3                             Ё
   //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

   cOpcao := "INCLUIR"
   nOpcE := 3 ; nOpcG := 3

   //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё Cria variaveis M->????? da Enchoice                          Ё
   //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

   RegToMemory("SZ0",(cOpcao == "INCLUIR"))

   //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё Cria aHeader e aCols da GetDados                             Ё
   //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   aHeader := {}
   aCols   := {}
   nUsado  := 0
   mtaMod3(@aHeader, @aCols, @nUsado)

   //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё Variaveis de posicionamento no aCols                                Ё
   //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

   _nPosFil     := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z1_FIL"})
   _nPosConta   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z1_CONTA"})
   _nPosDel     := Len(aHeader) + 1

   //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё Executa a Modelo 3                                           Ё
   //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды   
   
   cTitulo        := "Cadastro de Contas Contabeis por Filial "
   cAliasEnchoice := "SZ0"
   cAliasGetD     := "SZ1"
   cLinOk         := 'ExecBlock("ValidSZ0",.F.,.F.)'
   cTudOk         := "AllwaysTrue()"
   cFieldOk       := "AllwaysTrue()"
   aCpoEnchoice   := {"Z0_CODIGO"}

   _lRet := Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk) 
           
   If _lRet
      GravaInc()
      ConfirmSX8()		
   Else
      RollBackSX8()					
   Endif
Return


//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё FunГЦo Grava InclusЦo                                               Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

Static Function GravaInc()

   //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё Gravacao do Cabecalho - SZ0                                         Ё
   //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

   If Len(aCols) <= 0
      MsgBox("Nenhum Item foi Incluido","Alerta","ALERT")
      RollBackSX8()
      Return
   Endif

   DbSelectArea("SZ0")
   RecLock("SZ0",.T.)
   SZ0->Z0_FILIAL  := xFilial("SZ0")
   SZ0->Z0_CODIGO  := M->Z0_CODIGO
   SZ0->Z0_DESC    := M->Z0_DESC
   SZ0->(MsUnLock())

   //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё Gravacao dos itens - SZ1                                            Ё
   //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

   For nIt := 1 To Len(aCols)
      If !aCols[nIt,_nPosDel]
         DbSelectArea("SZ1")
         RecLock("SZ1",.T.)
         SZ1->Z1_FILIAL  := xFilial("SZ1")
         SZ1->Z1_CODIGO  := M->Z0_CODIGO
         SZ1->Z1_FIL     := aCols[nIt,_nPosFil]
         SZ1->Z1_CONTA   := aCols[nIt,_nPosConta]
         SZ1->(MsUnLock())
      Endif
   Next nIt
   dbSelectArea("SZ0")
Return  

 
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Alterar                                                             Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
User Function CADSZ0ALT()            
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддд
	//ЁChama funГЦo para monitor uso de fontes customizadosЁ
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддд
	U_USORWMAKE(ProcName(),FunName())

   SetPrvt("COPCAO,NOPCE,NOPCG,NUSADO,AHEADER,ACOLS")
   SetPrvt("_NI,CCPO,_NPOSFIL,_NPOSCONTA,_NPOSDEL")
   SetPrvt("N,CTITULO,CALIASENCHOICE,CALIASGETD,CLINOK,CTUDOK")
   SetPrvt("CFIELDOK,ACPOENCHOICE,_LRET,NIT,NNUMIT,_NPOSABS")

   dbSelectArea("SZ0")
   If EOF() .And. BOF()
       Help("",1,"ARQVAZIO")
       Return
   Endif

   //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё Opcoes de acesso para a Modelo 3                             Ё
   //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

   cOpcao := "ALTERAR"
   nOpcE := 4 ; nOpcG := 4

   //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё Cria variaveis M->????? da Enchoice                          Ё
   //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды  

   RegToMemory("SZ0",(cOpcao == "INCLUIR"))

   //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё Cria aHeader e aCols da GetDados                             Ё
   //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   aHeader := {}
   aCols   := {}
   nUsado  := 0
   mtaMod3(@aHeader, @aCols, @nUsado)

   //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё Variaveis de posicionamento no aCols                                Ё
   //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

   _nPosFil     := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z1_FIL"})
   _nPosConta   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z1_CONTA"})
   _nPosDel     := Len(aHeader) + 1

   //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё Executa a Modelo 3                                           Ё
   //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды 

   cTitulo        := "Cadastro de Contas Contabeis Filiais"
   cAliasEnchoice := "SZ0"
   cAliasGetD     := "SZ1"
   cLinOk         := 'ExecBlock("ValidSZ0",.F.,.F.)'
   cTudOk         := "AllwaysTrue()"
   cFieldOk       := "AllwaysTrue()"
   aCpoEnchoice   := {"Z0_CODIGO"}
   n              := 1

   _lRet := Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk)
       
   If _lRet
      Grava()
   Endif
   
Return


//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Grava AlteraГУes                                                    Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

Static Function Grava()

   //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё Gravacao do Cabecalho - SZ0                                         Ё
   //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

   dbSelectArea("SZ0") 
   dbSetOrder(1)
   dbSeek(xFilial()+M->Z0_CODIGO)
   RecLock("SZ0",.F.)
   SZ0->Z0_FILIAL  := xFilial("SZ0")
   SZ0->Z0_CODIGO  := M->Z0_CODIGO
   SZ0->Z0_DESC	 := M->Z0_DESC
   SZ0->(MsUnLock())

   //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё Gravacao dos itens - SZ1                                            Ё
   //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды


   dbSelectArea("SZ1")
   SZ1->(DbSetOrder(1))
   SZ1->(DbSeek(xFilial("SZ1")+M->Z0_CODIGO))
   While SZ1->Z1_FILIAL+SZ1->Z1_CODIGO == xFilial("SZ1")+M->Z0_CODIGO .and. !SZ1->(Eof())
      RecLock("SZ1",.F.)
      SZ1->(dbDelete())
      SZ1->(MsUnLock())
      SZ1->(DbSeek(xFilial("SZ1")+M->Z0_CODIGO))
   Enddo


   For nIt := 1 To Len(aCols)
      If !aCols[nIt,_nPosDel]
         RecLock("SZ1",.T.)
         SZ1->Z1_FILIAL  := xFilial("SZ1")
         SZ1->Z1_CODIGO  := M->Z0_CODIGO
         SZ1->Z1_FIL     := aCols[nIt,_nPosFil]
         SZ1->Z1_CONTA   := aCols[nIt,_nPosConta]
         MsUnLock()
      EndIf
   Next nIt
   dbSelectArea("SZ0")
Return
                       

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё ExclusЦo                                                            Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

User Function CADSZ0EXC()            
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддд
	//ЁChama funГЦo para monitor uso de fontes customizadosЁ
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддд
	U_USORWMAKE(ProcName(),FunName())

   SetPrvt("COPCAO,NOPCE,NOPCG,NUSADO,AHEADER,ACOLS")
   SetPrvt("_NI,CCPO,_NPOSFIL,_NPOSCONTA,_NPOSDEL,")
   SetPrvt("N,CTITULO,CALIASENCHOICE,CALIASGETD,CLINOK,CTUDOK")
   SetPrvt("CFIELDOK,ACPOENCHOICE,_LRET,_NIT,_NPOSABS,")

   dbSelectArea("SZ0")
   If BOF() .And. EOF()
       Help("",1,"ARQVAZIO")
       Return
   Endif

   //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё Opcoes de acesso para a Modelo 3                             Ё
   //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

   cOpcao := "VISUALIZAR"
   nOpcE := 2 ; nOpcG := 2

   //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё Cria variaveis M->????? da Enchoice                          Ё
   //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

   RegToMemory("SZ0",(cOpcao == "INCLUIR"))

   //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё Cria aHeader e aCols da GetDados                             Ё
   //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   aHeader := {}
   aCols   := {}
   nUsado  := 0
   mtaMod3(@aHeader, @aCols, @nUsado)


   //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё Variaveis de posicionamento no aCols                                Ё
   //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

   _nPosFil     := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z1_FIL"})
   _nPosConta   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z1_CONTA"})
   _nPosDel     := Len(aHeader) + 1

   //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё Executa a Modelo 3                                           Ё
   //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

   cTitulo        := "Cadastro de Contas Contabeis Filiais"
   cAliasEnchoice := "SZ0"
   cAliasGetD     := "SZ1"
   cLinOk         := 'ExecBlock("ValidSZ0",.F.,.F.)'
   cTudOk         := "AllwaysTrue()"
   cFieldOk       := "AllwaysTrue()"
   aCpoEnchoice   := {"Z0_CODIGO"}
   n              := 1

   _lRet := Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk)

   If _lRet

       //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
       //Ё Exclui os itens                                                     Ё
       //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
       
      dbSelectArea("SZ1")
      SZ1->(DbSetOrder(1))
      For _nIt := 1 To Len(aCols)
         If SZ1->(dbSeek(xFilial("SZ1")+M->Z0_CODIGO))
            RecLock("SZ1",.F.)
            SZ1->(dbDelete())
            SZ1->(MsUnLock())
         Endif
      Next _nIt

       //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
       //Ё Exclui o cabecalho                                                  Ё
       //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

      dbSelectArea("SZ0")
      SZ0->(DbSetOrder(1))
      If SZ0->(dbSeek(xFilial()+M->Z0_CODIGO))
         RecLock("SZ0",.F.)
         SZ0->(dbDelete())
         SZ0->(MsUnLock())
      Endif
   Endif
Return


//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё FunГЦo Para Validar as Linhas da GetDados do Modelo3                Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

User Function ValidSZ0()             

	//здддддддддддддддддддддддддддддддддддддддддддддддддддд
	//ЁChama funГЦo para monitor uso de fontes customizadosЁ
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддд
	U_USORWMAKE(ProcName(),FunName())

   SetPrvt("_LRET")
   _lRet := .T.

   //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё Processa somente se o item nao estiver deletado                     Ё
   //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

   If !aCols[n,_nPosDel]
      For _nVldIt := 1 To Len(aCols)
         If ( (aCols[_nVldIt,_nPosFil] == aCols[n,_nPosFil])) .and. (_nVldIt <> n) .and. !aCols[_nVldIt,_nPosDel]
            MsgBox("Filial ja cadastrada","Alerta","ALERT")
            _lRet := .F.			
         Endif
         If (Empty(aCols[_nVldIt,_nPosFil]) .or. empty([_nVldIt,_nPosConta])) .and. !aCols[_nVldIt,_nPosDel]
            MsgBox("Registro em branco","Alerta","ALERT")
            _lRet := .F.			
         Endif		
      Next _nVldIt
   Endif
Return(_lRet)       

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё FunГЦo Para Montar arrays aHeader e aCols do Modelo 3               Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

static function mtaMod3(aHeader, aCols, nUsado)
   Local ni
   nUsado  := 0
   dbSelectArea("SX3")
   SX3->(DbSetOrder(1))
   SX3->(DbSeek("SZ1"))
   aHeader := {}

   While !SX3->(Eof()) .And. (SX3->x3_arquivo=="SZ1")
      If Upper(AllTrim(SX3->X3_CAMPO)) == "Z1_CODIGO"
         SX3->(DbSkip())
         Loop
      Endif
      If X3USO(SX3->x3_usado) .And. cNivel >= SX3->x3_nivel
         nUsado:=nUsado+1
         SX3->(Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,x3_tamanho, x3_decimal,X3_VALID,x3_usado, x3_tipo, x3_arquivo, x3_context } ))
      Endif
      SX3->(DbSkip())
   EndDo

   aCols:={}
   DbSelectArea("SZ1")
   SZ1->(DbSetOrder(1))
   SZ1->(DbSeek(xFilial("SZ1")+M->Z0_CODIGO))
   While !SZ1->(Eof()) .and. xFilial("SZ1") == SZ1->Z1_FILIAL .And. SZ1->Z1_CODIGO == M->Z0_CODIGO
      AADD(aCols,Array(nUsado+1))
      For _ni:=1 to nUsado
         If empty(SZ1->(FieldPos(aHeader[_ni,2])))
            aCols[Len(aCols),_ni] := Posicione("CT1",1,xFilial("CT1")+SZ1->Z1_CONTA,"CT1_DESC01")
         Else
            aCols[Len(aCols),_ni] := SZ1->(FieldGet(FieldPos(aHeader[_ni,2])))
         EndIf
      Next 
      aCols[Len(aCols),nUsado+1]:=.F.
      SZ1->(DbSkip())
   Enddo
   If Len(aCols)<=0
       AADD(aCols,Array(nUsado+1))
       For _ni:=1 to nUsado
           aCols[1,_ni] := CriaVar(aHeader[_ni,2])
       Next _ni
       aCols[1,nUsado+1]   := .f.
   Endif
return (nil)

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё FunГЦo Para Imprimir Grupo de Contas                                Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

user function cadsz0imp()
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддд
	//ЁChama funГЦo para monitor uso de fontes customizadosЁ
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддд
	U_USORWMAKE(ProcName(),FunName())

   SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3")
   SetPrvt("ARETURN,NOMEPROG,CPERG,WNREL,LCONTINUA,CSTRING")
   SetPrvt("_NQTDPAR,_CDOC,_NQTDITEM,ACAMPOSTRB,CARQTRB,CINDTRB")
   SetPrvt("CCHAVE,LA,INC,_NLIN,_NIMPOSTO,")


   //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё Variaveis utilizadas para parametros                         Ё
   //Ё mv_par01             // Do Grupo                             Ё
   //Ё mv_par02             // Ate Grupo                            Ё
   //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

   //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё Define Variaveis Ambientais                                  Ё
   //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

   tamanho   := "P"
   limite    := 080

   titulo    := PADC("Grupos de Contas de Filiais",74)

   cDesc1    := "Este programa ira emitir a Grupo de Contas de Filiais"
   cDesc2    := ""
   cDesc3    := "Lay-Out pre-definido pelo usuario, conforme parametros selecionados."

   cabec1    := "     Filial     Conta"
   cabec2    := ""
   //            0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
   //                     10        20        30        40        50        60        70        80        90       100       110       120       130
   //            123456789012345 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 9.000.000,00 CX  1234.00.00  10.000,000  10%  123456  100. 999.999.99 999,999.99

   aReturn   := { "Especial", 1,"Faturamento", 1, 2, 1,"",1 }
   nomeprog  := "CCT002"
   cPerg     := PadR("CCT002",len(sx1->x1_grupo))
   wnrel     := "CCT002"
   m_pag     := 1

   VldPerg(cPerg)               // Pergunta no SX1

   lContinua := .T.
   Pergunte(cPerg,.F.)               // Pergunta no SX1

   cString   := ""

   //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё Envia controle para a funcao SETPRINT                        Ё
   //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

   wnrel     := SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.)

   If nLastKey == 27
      Return
   Endif

   //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё Verifica Posicao do Formulario na Impressora                 Ё
   //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   SetDefault(aReturn,cString)

   If nLastKey == 27
      Return
   Endif

   //здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё                                                              Ё
   //Ё Inicio do Processamento da Nota Fiscal                       Ё
   //Ё                                                              Ё
   //юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

   RptStatus({|lEnd| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 13/12/01 ==>        RptStatus({|lEnd| Execute(RptDetail)})

return (nil)


//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё FunГЦo Para Imprimir Grupo de Contas                                Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Static Function RptDetail()
   Local _cGrupoIni, _cGrupoFim, _cGrupoTmp
   Local _lInicio := .t.
   Local _nRecSZ1 := SZ1->(recno())
   Local _nRecSZ0 := SZ0->(recno())
   Local _lImpGrupo := .t.
   
   _cGrupoIni := MV_PAR01
   _cGrupoFim := MV_PAR02

   SZ1->(dbSetOrder(1))
   SZ1->(dbSeek(xFilial("SZ1")+_cGrupoIni, .t.))
   While !SZ1->(EOF()) .and. SZ1->Z1_CODIGO <= _cGrupoFim
      _cGrupoTmp := SZ1->Z1_CODIGO
      _lImpGrupo := .t.

      While !SZ1->(EOF()) .and. SZ1->Z1_CODIGO == _cGrupoTmp
         If lEnd
            @ Prow()+1, 0 PSAY "*** CANCELADO PELO OPERADOR ***"
            Exit
         Endif

         IF Prow() > 56 .or. _lInicio
            Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
            _lImpGrupo := .t.
            _lInicio := .f.
         EndIf
         If _lImpGrupo
            SZ0->(dbSetOrder(1))
            SZ0->(dbSeek(xFilial("SZ0")+SZ1->Z1_CODIGO))
            @ Prow()+2 , 000 Psay "Grupo : "+SZ1->Z1_CODIGO+" "+SZ0->Z0_DESC
            @ Prow()+1 , 000 Psay ""
            _lImpGrupo := .f.
         EndIF

         CT1->(DbSeek(xFilial("CT1")+SZ1->Z1_CONTA))
         @ Prow()+1 , 010 Psay SZ1->Z1_FIL
         @ Prow()   , 016 Psay trim(SZ1->Z1_CONTA)+" - "+CT1->CT1_DESC01
         SZ1->(DbSkip())
      EndDo
   EndDo

   Set device To Screen

   //зддддддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё Se impress└o em Disco, chama SPOOL                Ё
   //юддддддддддддддддддддддддддддддддддддддддддддддддддды

   If aReturn[5] == 1
      Set Printer TO
      Commit
      ourspool(wnrel)
   Endif


   //зддддддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё Libera relat╒rio para Spool da Rede               Ё
   //юддддддддддддддддддддддддддддддддддддддддддддддддддды
   FT_PFLUSH()

   SZ1->(dbGoTo(_nRecSZ1))
   SZ0->(dbGoTo(_nRecSZ0))
Return

Static Function VldPerg(cPerg)
   _sAlias := Alias()
   dbSelectArea("SX1")
   SX1->(dbSetOrder(1))
   If !SX1->(dbSeek(cPerg+"01"))
      RecLock("SX1",.T.)
      sx1->x1_grupo  := cPerg
      sx1->x1_ordem  :='01'
      sx1->x1_pergunt:='Grupo Inicial? '
      sx1->x1_variavl:='mv_ch1'
      sx1->x1_tipo   :='C'
      sx1->x1_tamanho:=04
      sx1->x1_decimal:=0
      sx1->x1_presel :=0
      sx1->x1_gsc    :='G'
      sx1->x1_var01  :='mv_par01'
      SX1->(MsUnlock())
   EndIf
   If !SX1->(dbSeek(cPerg+"02"))
      RecLock("SX1",.T.)
      sx1->x1_grupo  := cPerg
      sx1->x1_ordem  :='02'
      sx1->x1_pergunt:='Grupo Final?'
      sx1->x1_variavl:='mv_ch2'
      sx1->x1_tipo   :='C'
      sx1->x1_tamanho:=04
      sx1->x1_decimal:=0
      sx1->x1_presel :=0
      sx1->x1_gsc    :='G'
      sx1->x1_var01  :='mv_par02'
      SX1->(MsUnlock())
   EndIf
return (nil)