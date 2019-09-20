#INCLUDE "rwmake.ch"
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    � XEXPHA1             �Autor � Flavio Dias  � Data �17/09/08 ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao � Exportacao do cadastro de clientes - Personalizado	 			  ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Analista    � Data   �Motivo da Alteracao                              ���
�������������������������������������������������������������������������Ĵ��
���            �        �                                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function HHCriaBase()
Local cAlias := GetNextAlias()
Local aCampos := {}
Local cNomArq                    

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

// criacao do arquivo tempor�rio
AADD(aCampos,{ "HH_OK"   ,"C",2,0 } ) // vendedor
AADD(aCampos,{ "HH_GRUPO"   ,"C",6,0 } ) // grupo
AADD(aCampos,{ "HH_SERIE"   ,"C",20,0 } ) // serie
AADD(aCampos,{ "HH_CODBAS"   ,"C",6,0 } ) // cod. vendedor
AADD(aCampos,{ "HH_VEND"   ,"C",50,0 } ) // vendedor
AADD(aCampos,{ "HH_STATUS"   ,"C",1,0 } ) // Status
AADD(aCampos,{ "HH_DTHR"   ,"C",20,0 } ) // Data da cria��o da base

cNomArq 	:= CriaTrab(aCampos,.T.)
dbUseArea( .T.,, cNomArq,"PLM", .T. , .F. )
ExibeCadPalm()
PLM->(DbCloseArea())
fErase(cNomArq+GetDBExtension())
Return nil

/***********************************************************/
// Funcao que exibe a tela de cadastro dos palms dispon�veis
/***********************************************************/
Static Function ExibeCadPalm()
//Local aArea := GetArea()
Local aCpos := {}
Local aCampos := {}
Local cAlias := "SZD"
Local cRetFiltro := ""  
Local cFiltra := ""
Local cEmpFil := cEmpAnt + cFilAnt
Local cArq := "\hhtrg\hgrphh.dtc"
Local cArq2 := "\hhtrg\hcadgrp.dtc"
Local cArq3 := "\hhtrg\hcadhh.dtc"
Local cArq4 := "\hhtrg\hhtime.dtc"
Local cGrupo
Local cAliasPlm := GetNextAlias()
Local cAliasGrp := GetNextAlias()
Local cArqInd := "";

Private cCadastro := "Palms dispon�veis"
Private aRotina := {}
Private cMarca
Private cAliasHHc  := GetNextAlias()
Private cAliasHtm := GetNextAlias()

// Montagem dos campos do MBrowse
AAdd(aCpos, "HH_OK")
AAdd(aCpos, "HH_GRUPO")
AAdd(aCpos, "HH_SERIE")
AAdd(aCpos, "HH_CODBAS")
AAdd(aCpos, "HH_VEND")
AAdd(aCpos, "HH_STATUS")
AAdd(aCpos, "HH_DTHR")

// Campos a ser mostrado 
Aadd(aCampos, {"HH_OK", , "", "@!"})
Aadd(aCampos, {"HH_GRUPO", , "Grupo", "@!"})
Aadd(aCampos, {"HH_SERIE", , "S�rie", "@!"})
Aadd(aCampos, {"HH_CODBAS", , "C�digo", "@!"})
Aadd(aCampos, {"HH_VEND", , "Vendedor", "@!"})
Aadd(aCampos, {"HH_STATUS", ,"Status", "@!"})
Aadd(aCampos, {"HH_DTHR", ,"Data/Hora", "@!"})

// rotina a exibir no MBrowse
Aadd(aRotina, {"Recriar", "U_RecBase", 0, 1})

DbUseArea(.T.,,cArq,cAliasPlm,.T.)
DbSelectArea(cAliasPlm)
dbsetorder(1)
dbgotop()

// localiza o grupo de handhel da empresa e filial atual
DbUseArea(.T.,,cArq2,cAliasGRP,.T.)
(cAliasGrp)->(DbGoTop())

// localiza o arquivo de data de criacao das bases
DbUseArea(.T.,,cArq4,cAliasHtm,.T.)
(cAliasHtm)->(DbGoTop())

// abre o arquivo de status de cada palm
DbUseArea(.T.,,cArq3,cAliasHHc,.T.)
(cAliasGrp)->(DbGoTop())

While (cAliasGrp)->(!Eof())
	if ((cAliasGrp)->HHG_EMPFIL == cEmpFil)
		AddGrpPl(cAliasPlm, (cAliasGrp)->HHG_COD)
	EndIf
	(cAliasGrp)->(DbSkip())
EndDo

cArqInd := CriaTrab(NIL, .F.)
//controla o indice da tabela temporaria
IndRegua("PLM", cArqInd, "HH_CODBAS",,, "Organizando Registros...")

(cAliasGrp)->(DbCloseArea())                            
(cAliasPlm)->(DbCloseArea())
(cAliasHtm)->(DbCloseArea())

PLM->(DbGoTop())
cMarca := GetMark(,"PLM", "HH_OK")
linverte := .F.
MarkBrow("PLM", aCpos[1],, aCampos, linverte, cMarca)
// S� fecha o arquivo neste momento, devido ao mesmo ser usado na funcao de desbloquear o palm
(cAliasHHc)->(DbCloseArea())

If File(cArqInd+OrdBagExt())
	FErase(cArqInd+OrdBagExt())
Endif

//RestArea(aArea)  
Return Nil

Static Function AddGrpPl(cAliasPlm, cGrupo)

// localizar os vendedores
SA3->(DbSetOrder(01))
(cAliasPlm)->(DbGoTop())

While (cAliasPlm)->(!Eof())
  // avalia se deve ser mostrado o handhel para a filial atual
  If ((cAliasPlm)->HGU_GRUPO == cGrupo)
    // localiza o vendedor
	  SA3->(DbSeek(xFilial("SA3") + (cAliasPlm)->HGU_CODBAS))
	  // cria registro para ser mostrado
    RecLock("PLM", .T.)
    PLM->HH_GRUPO := (cAliasPlm)->HGU_GRUPO
    PLM->HH_SERIE := (cAliasPlm)->HGU_SERIE
    PLM->HH_CODBAS := (cAliasPlm)->HGU_CODBAS
    PLM->HH_VEND := SA3->A3_NREDUZ
    
    // busca a data e hora da ultima cria��o de base
    (cAliasHtm)->(DbSetOrder(01)) // pesquisa pelo grupo + serie    
    (cAliasHtm)->(DbSeek((cAliasPlm)->HGU_GRUPO + (cAliasPlm)->HGU_SERIE))
    cDtTime := (cAliasHtm)->HH_TIME
    if !Empty(cDtTime)
	    // processa e formata a data
	    dDataRec := SToD(SubStr(cDtTime, 1, 8))
	    dDataRec := dDataRec - 1
    	PLM->HH_DTHR :=  dToC(dDataRec) + " " + SubStr(cDtTime, 9)
    else
    	PLM->HH_DTHR :=  Space(20)
    EndIf
    // Substr(cDtTime, 7, 2) + "/" + Substr(cDtTime, 5, 2) + "/" +Substr(cDtTime, 1, 4) + " " + SubStr(cDtTime, 9)
    
    // busca o status do arquivo
    (cAliasHHc)->(dbSetOrder(1))
    (cAliasHHc)->(DbSeek((cAliasPlm)->HGU_SERIE))
    PLM->HH_STATUS := (cAliasHHc)->HHU_LOCK
    MsUnlock()  
  EndIf  
  (cAliasPlm)->(DbSkip())  
EndDo

Return .T.


/**************************************************
 Fun��o para recriar a base do palm
 **************************************************/
User Function RecBase(cAlias, nReg, nOpc)
Local cAliasTime := GetNextAlias()
Local cMarca := ThisMark()
Local lInverte := ThisInv()
PLM->(DbGoTop())
// abre o arquivo de controle de cria��o de base para os vendedores
DbUseArea(.T.,,"\hhtrg\hhtime.dtc",cAliasTime,.T.)
(cAliasTime)->(DbSetOrder(1))
dbSelectArea("PLM")
    
//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

cTime := Substr(Time(), 1, 2)
if !(cTime $ "16/17/")
	While PLM->(!Eof())
		// avalia se est� marcado e cria somente para os marcados
		If Marcado("PLM", "HH_OK",cMarca,lInverte)
			if (cAliasTime)->(DbSeek(PLM->HH_GRUPO + PLM->HH_SERIE))
	      // Verifica se est� bloqueado e desbloqueia
	      if (PLM->HH_STATUS == "B")
	      	U_Desbloq(cAlias, nReg, nOpc)
	      EndIf
	      // atualiza o campo de criacao de base do palm
	      RecLock(cAliasTime, .F.)
	      (cAliasTime)->HH_TIME := Space(16)
	      (cAliasTime)->(MsUnlock())
	    EndIf
	  EndIf
	  PLM->(DbSkip())
	EndDo
	MsgInfo("Processo de recriac�o dos dados para os vendedores selecionados ser� iniciado em minutos.", "Aten��o!")
	MsgInfo("Aguarde de 2 a 5 minutos a cada vendedor selecionado para sincronizar o palm do mesmo.", "Aten��o!")
else
	Alert("Neste hor�rio n�o � poss�vel recriar a base do vendedor por esta rotina. Entre em contato com o Suporte SFA.","Hor�rio cr�tico")
EndIf
	
CloseBrowse()
(cAliasTime)->(DbCloseArea())
Return Nil

// Fun��o usada para desbloquear um vendedor que encontra-se bloqueado.
User Function Desbloq(cAlias, nReg, nOpc)
(cAliasHHc)->(dbSetOrder(01))
(cAliasHHc)->(DbSeek(PLM->HH_SERIE))

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())    

// libera o palm
RecLock(cAliasHHc, .F.)
(cAliasHHc)->HHU_LOCK := " "
(cAliasHHc)->(MsUnlock())
Return Nil

Static Function Marcado(cAlias, cCpo, cMark, lInverte)
Local lRet := .F.
lRet := ((cAlias)->&cCpo == cMark .And. !lInverte) .Or. ((cAlias)->&cCpo != cMark .And. lInverte)
Return lRet