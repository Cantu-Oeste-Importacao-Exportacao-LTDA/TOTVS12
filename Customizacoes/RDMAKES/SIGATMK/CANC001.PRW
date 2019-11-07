#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*__________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçäo    ¦  CANC001    ¦ Autor ¦ Lucilene Mendes     ¦ Data ¦13.11.12 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Função para exibir os títulos em aberto do cliente em      ¦¦¦
¦¦¦          ¦ outras filiais, chamada através do botão TITULOS do menu   ¦¦¦
¦¦¦          ¦ superior da rotina de telecobrança.                        ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ Cantu - Call Center                                        ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function CANC001()

Private nSuperior 	:= 015
Private nEsquerda 	:= 000
Private nInferior 	:= 200
Private nDireita	:= 433
Private cLinOk		:= "AllwaysTrue"
Private cTudoOk		:= "AllwaysTrue"
Private cDelOk		:= "AllwaysFalse"
Private cFieldOk	:= "AllwaysTrue"
Private nOpca		:= 1

Private oDlg1
Private oSay1
Private oGetDad
Private bRefresh	:= {|| oDlg1:Refresh() }
Private bGDRefresh  := {|| oGetDad:oBrowse:Refresh() }
Private aHeader		:= {}
Private aCols  		:= {}
Private aFields		:= {}

Private cNomCli		:= ''
Private cCodCli		:= ''
Private nTotal		:= 0


cCodCli := M->ACF_CLIENT
cNomCli := Posicione("SA1",1,xFilial("SA1")+cCodCli,"A1_NOME")
cFechar := "&Fechar"
cSair   := "Sair"
 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//Seleciona todos os títulos em aberto na empresa logada para o cliente
cQry := " Select E1_FILIAL, E1_NRDOC, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_EMISSAO, E1_VENCTO, E1_MOTIVO, E1_VALOR, E1_SALDO " //, E1_CONTRAT " 
cQry += " From "+RetSQLName("SE1")+" SE1 "
cQry += " Where E1_FILIAL <> '"+cFilAnt+"' "
cQry += " And E1_CLIENTE = '"+cCodCli+"' "
cQry += " And E1_SALDO > 0 "
cQry += " And SE1.D_E_L_E_T_ = ' ' "  
cQry += " Order by E1_FILIAL,E1_PREFIXO, E1_NUM, E1_PARCELA "  
If Select("TIT") > 0
	TIT->(dbCloseArea())   
Endif
TcQuery cQry New Alias "TIT"

If TIT->(Eof())
	MsgInfo("Não existem títulos em aberto em outras filiais para este cliente!")
	Return .F.
Endif

aFields := {"E1_FILIAL", "E1_NRDOC", "E1_PREFIXO", "E1_NUM", "E1_PARCELA", "E1_TIPO", "E1_EMISSAO", "E1_VENCTO", "E1_MOTIVO", "E1_VALOR",;
            "E1_SALDO"}  //, "E1_CONTRAT"} 
dbSelectArea("SX3")
SX3->(dbSetOrder(2))

//Monta o aHeader buscando na SX3 as propriedades dos campos do array aFields
For nX := 1 to Len(aFields) 
	If SX3->(dbSeek(aFields[nX]))
		Aadd(aHeader, {AllTrim(X3_Titulo),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"AllwaysTrue()",;  
		SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO, SX3->X3_VISUAL}) 
		If aHeader[nX,1]="Nr.Documento"
			aHeader[nX,1]:= "Nome"
			aHeader[nX,4]:= 16
		Elseif aHeader[nX,1]="Motivo"
			aHeader[nX,1]:= "Atraso"
			aHeader[nX,4]:= 05
	/*			
		Elseif aHeader[nX,1]="Contrato"
			aHeader[nX,1]:= "Juros"
			aHeader[nX,4]:= 20
	*/	
		Endif	
	Endif
Next nX

//Monta o aCols com os campos da query TIT
While TIT->(!Eof())
	cNomeFil := Posicione("SM0",1,cEmpAnt+TIT->E1_FILIAL,"M0_FILIAL")
	cAtraso  := (stod(TIT->E1_VENCTO) - dDataBase)
	cJuros   := 0 
   	aAdd(aCols,{TIT->E1_FILIAL, cNomeFil, TIT->E1_PREFIXO, TIT->E1_NUM, TIT->E1_PARCELA, TIT->E1_TIPO, stod(TIT->E1_EMISSAO), stod(TIT->E1_VENCTO), cAtraso,;
   	            TIT->E1_VALOR, TIT->E1_SALDO, .F.})
	nTotal += TIT->E1_VALOR
	TIT->(dbSkip()) 
End                                   


DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD

//Monta a tela
DEFINE MSDIALOG oDlg1 TITLE "Títulos a Receber em Aberto - Outras Filiais" FROM 000, 000  TO 450, 860 COLORS 0,16777215 PIXEL //40, 158 PIXEL
@ 005,005 SAY oSay1 PROMPT "Cliente:   " 	 SIZE 250, 030 OF oDlg1 FONT oBold COLORS CLR_BLACK, 16777215 PIXEL 
@ 005,030 SAY oSay1 PROMPT cCodCli+"  -   "+cNomCli 	 SIZE 250, 030 OF oDlg1 FONT oBold COLORS CLR_BLUE, 16777215 PIXEL 

//Totais
@ 207,005 SAY oSay1 PROMPT "Total em aberto:   R$"  SIZE 250, 030 OF oDlg1 FONT oBold COLORS CLR_BLACK, 16777215 PIXEL
@ 207,060 SAY oSay1 PROMPT Str(nTotal,17,2)  SIZE 250, 030 OF oDlg1 FONT oBold COLORS CLR_BLUE, 16777215 PIXEL
@ 207,370 BUTTON cfechar PROMPT cSair      SIZE 037, 012 ACTION (oDlg1:End()) OF oDlg1 PIXEL


//Criação do Grid
oGetDad := MsNewGetDados():New(nSuperior, nEsquerda, nInferior, nDireita,  , "AllwaysTrue", "AllwaysTrue", , ,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg1, aHeader, aCols)

Eval(bGDRefresh)//Atualiza Grid    
Eval(bRefresh)  //Atualiza Tela 

ACTIVATE MSDIALOG oDlg1 CENTERED 

Return	