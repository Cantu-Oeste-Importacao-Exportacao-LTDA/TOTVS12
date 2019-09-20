#Include "RwMake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VLDF1EMIS  �Autor  �Gustavo Lattmann    � Data �  05/12/16  ���
�������������������������������������������������������������������������͹��
���Desc.  �Valida��o no campo data de emiss�o do documento de entrada     ���
���       �para que n�o sejam inseridas notas com data menor que 6 meses. ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function VLDF1EMIS()

Local lRet := .T. 

If dDemissao <= (Date() - 30) 
	//ShowHelpDlg("Aten��o - VLDF1EMIS",{"Data de emiss�o n�o pode ser menor que 180 dias da data atual!"},5,{"Verifica da data informada, ou solicite ";
	//" ao libera��o do supervisor do processo."},5) 
	lRet := .F.

	If MsgYesNo("Data de emiss�o n�o pode ser menor que 30 dias da data atual! Deseja incluir com libera��o do superior?","Aten��o - VLDF1EMIS")
		lRet := fLogSUP()
	EndIf
EndIf          

If dDemissao > Date()
//	ShowHelpDlg("Aten��o - VLDF1EMIS",{"Data de emiss�o n�o pode ser maior do que data atual!"},5,{"Verifica da data informada, ou solicite ";
//	" ao libera��o do supervisor do processo."},5) 	
	lRet := .F.
	If MsgYesNo("Data de emiss�o n�o pode ser maior do que data atual! Deseja incluir com libera��o do superior?","Aten��o - VLDF1EMIS")
		lRet := fLogSUP()
	EndIf
EndIf

Return lRet                       

*----------------------------------------*
Static Function fLogSUP()
*----------------------------------------*
Local lRet := .T.
Private cUSRSUP := Space(15)
Private cPASSUP := Space(15)
Private nOpcao  := 0
Private oDlgPASS

	//������������������������������������������������������������������������Ŀ
	//�Janela de autoriza��o                                                   �
	//��������������������������������������������������������������������������

	DEFINE MSDIALOG oDlgPASS FROM 000,000 TO 160,200 TITLE "Autoriza��o de inclus�o"  OF oDlgPASS PIXEL
	@ 005, 005 TO 050, 095 OF oDlgPASS  PIXEL 
	@ 013,010 SAY "Usu�rio:" OF oDlgPASS PIXEL
	@ 012,040 GET cUSRSUP  SIZE 050,10 WHEN .T. VALID (!Vazio()) OF oDlgPASS PIXEL
	@ 028,010 SAY "Senha:" OF oDlgPASS PIXEL
	@ 027,040 GET cPASSUP  SIZE 050,10 WHEN .T. PASSWORD VALID (!Vazio()) OF oDlgPASS PIXEL
				
	DEFINE SBUTTON FROM 060, 040 TYPE 1 ACTION ( fValPass(cUSRSUP, cPASSUP, @nOpcao) )  ENABLE OF oDlgPASS PIXEL
	DEFINE SBUTTON FROM 060, 070 TYPE 2 ACTION (oDlgPASS:End()) ENABLE OF oDlgPASS PIXEL
	
	ACTIVATE MSDIALOG oDlgPASS CENTERED
	
	If nOpcao == 0
		lRet := .F.
	EndIf

Return (lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fValPass   �Autor  �Rafael Parma       � Data �  03/08/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para valida��o de usu�rio/senha do superior.         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �RJU                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*-------------------------------------------------*
Static Function fValPass(cUSRSUP, cPASSUP, nOpcao)
*-------------------------------------------------*
Local lRet	:= .T.	

	//������������������������������������������������������������������������Ŀ
	//�Verifica se o usuario digitado tem permissao                            �
	//��������������������������������������������������������������������������

	If ! ALLTRIM(cUSRSUP) $ ALLTRIM(SuperGetMV("MV_X_F1EMI",,"gutto"))
		Aviso("Aviso", "Este usu�rio n�o foi definido como superior.", {"OK"}, 2)
		lRet:=.F.
	EndIf


	//������������������������������������������������������������������������Ŀ
	//�Pesquisa no arquivo de senhas o usuario e valida a senha digitada       �
	//��������������������������������������������������������������������������
	
	If lRet
		PswOrder(2)
		PswSeek(cUSRSUP,.T.)
		If !PswName(cPASSUP)
			HELP("",1,"INVSENHA")
			lRet := .F.
		EndIf
	EndIf
	
	If lRet
		nOpcao := 1
		oDlgPASS:End()
	EndIf
	         	
Return (lRet)

