#IFNDEF WINDOWS
	#include "Inkey.ch"
#ELSE
	#include "Fivewin.ch"
#ENDIF
//#INCLUDE "CFGX025.ch"

Static __aUserLg := {}

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � prolog  � Autor � Heitor dos Santos     � Data �20/03/2014���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Permite Visualizacao dos campos para gravacao de Logs      ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Sem Argumentos                                             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico       �                                          )���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function prologe5()

cArq:="SE5"
U_prolog(cArq)

return

User Function prologe2()

cArq:="SE2"
U_prolog(cArq)

return

User Function prologe1()

cArq:="SE1"
U_prolog(cArq)

User Function prologf1()

cArq:="SF1"
U_prolog(cArq)

User Function prologf2()

cArq:="SF2"
U_prolog(cArq)

return

User Function prologc5()

cArq:="SC5"
U_prolog(cArq)

Return

User Function prolog(cArq)

setNaoUsado( .F. )

SelArq(cArq)

dbselectarea(cArq)

VisualLog()


Return Nil


Static Function SelArq(cArq)
Local  i
DbSelectArea("SX2")
DbSeek(cArq)
cArquivo := RetArq(__cRdd,AllTrim(x2_path)+AllTrim(x2_arquivo),.t.)
If !MSFile(cArquivo)
	Help("",1,"NOFILE")
	Return .F.
Else
	If Select(cArq) == 0
		If !ChkFile(cArq,.F.)
			Help("",1,"ABREEXCL")
			Return .F.		
		Endif
	Else
		dbselectarea(cArq)
	endif
Endif
Return .T.
	

