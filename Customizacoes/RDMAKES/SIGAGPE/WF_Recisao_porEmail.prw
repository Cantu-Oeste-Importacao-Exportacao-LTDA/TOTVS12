#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �WF_RECISAO_POREMAIL�Autor  �Microsiga  � Data �  30/11/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada executado no c�lculo da rescis�o          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Gest�o de Pessoal                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User function GP040RES()
Local cFunci
Local cEmailFunc                                
Local _Fil       := SRA->RA_FILIAL  
Local _Nome      := SRA->RA_NOME
Local _Motivo    := substr( fDesc("SRX","32"+ctipres,"RX_TXT",,SRA->RA_FILIAL),1,30)
Local _Codresc   := substr( fDesc("SRX","32"+ctipres,"RX_TXT",,SRA->RA_FILIAL),46,2)
Local _email     := pswret(1)[1][14]
Private _data    := ddatadem1

//���������������������������������������������������������������������������������������������������������������������������GH�GH�G\�
//�Ficou definido no treinamento de TMS que o codigo do motorista deve ser sempre igual ao codigo da matricula do funcionario�
//���������������������������������������������������������������������������������������������������������������������������G�S��

Private _Mat     := SRA->RA_MAT        

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

//��������������������������������������������������������������������������������������������Ŀ
//�Exclui o calculo da rescisao quando efetuado por usuario nao autorizado. (Luiz Gamero Prado)�
//����������������������������������������������������������������������������������������������

If !(__CUSERID) $ GetMV("MV_X_USROK")
	
	Alert("Usuario sem permissao para efetuar o calculo da rescisao . . .")
	Gpem040EXC(SRG->(RECNO()))

Else
	
	_TEM := .T.
	
	//����������������������������������������������������������������������Ŀ
	//�Valida se tabela temporaria esta aberta, caso afirmativo fecha a mesma�
	//������������������������������������������������������������������������
	
	If select ("TMPRES2010") > 0
		("TMPRES2010")->(dbclosearea())
	EndIf
	
	//�������������������������������������������������Ŀ
	//�Verifica se existe pend�ncias junto ao financeiro�
	//���������������������������������������������������
	
	cQuery := " "
	cQuery := "select sum(eu_sldadia) saldo "
	cQuery += " from  "+RetSqlName("SEU")+" seu "
	cQuery += " where seu.eu_filial = '"+_Fil+"' and"
	cQuery += " seu.eu_codmot = '"+_mat+"' and"
	cQuery += " seu.eu_tipo = '01' and "
	cQuery += " seu.d_e_l_e_t_ <> '*' "
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPRES2010",.F.,.T.)
	
	If Alias() <> "TMPRES2010"
		MsgBox("TMPRES2010 - Par�metros Inv�lidos!")
	Endif
	
	//�����������������������������������������������
	//�Valida se existe saldos em aberto do motorista
	//�����������������������������������������������
	
	If TMPRES2010->SALDO > 0
		Alert("Funcionario com pendencia de acerto de viagem, favor informar ao financeiro. ")
		Alert("Nao ser� possivel continuar o calculo da rescisao antes do acerto de viagem. ")
	Endif
	
	
	If !_TEM
		Gpem040EXC(SRG->(RECNO()))
	Else
		
		//�������������������������������������������������Ŀ
		//�Enviar email informando da recis�o do funcion�rio�
		//���������������������������������������������������
		
		cFunci := AllTrim(SRA->RA_MAT + " - " + SRA->RA_NOME + " com o cargo " + SRA->RA_X_DESCF)
	 	cEmailFunc := AllTrim(SRA->RA_EMAIL)
	 	U_SndMReci(cfunci, cEmailFunc)  

	EndIf
		
EndIf
	
Return nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SNDMRECI �Autor  �Microsiga           � Data �  30/11/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o respons�vel por enviar email informando da recis�o  ���
���          � do funcion�rio.                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Gest�o de Pessoal                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User function SndMReci(cFunci, cEmailFunc) 
Local aArea := GetArea()
Local cEmail
Local oProcess, oHtml, cProcess, cStatus  

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//����������������������������������������������������� 

U_USORWMAKE(ProcName(),FunName())
cEmail := GetMv('MV_X_MRECI') 

if (AllTrim(cEmail) <> "")
	                 
	//����������������������������������Ŀ
	//�Inicia processo de envio do e-mail�
	//������������������������������������
	
	cProcess := OemToAnsi("001010")
	cStatus  := OemToAnsi("001011")
	
	oProcess := TWFProcess():New(cProcess,OemToAnsi("Recis�o de funcion�rio"))
	oProcess:NewTask(cStatus,"\workflow\wfRecisaoFunc.html")
	oProcess:cSubject := OemToAnsi("Recis�o de funcion�rio " + cFunci) 
 	oProcess:cTo := ALLTRIM(cEmail)
		
	oProcess:oHTML:ValByName("FUNCIONARIO", cFunci) 
	oProcess:oHTML:ValByName("emp", SM0->M0_CODIGO + " - " + SM0->M0_NOME)
	oProcess:oHTML:ValByName("filial", SM0->M0_CODFIL + " - " + SM0->M0_FILIAL)
	oProcess:oHTML:ValByName("EmailFunc", cEmailFunc) 

	oProcess:Start()	
EndIf	

RestArea(aArea)

Return Nil