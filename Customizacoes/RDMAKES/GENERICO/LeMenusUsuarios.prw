#INCLUDE 'RWMAKE.CH'
#include "tbiconn.ch"
#include "topconn.ch"

#DEFINE APSWDET_USER_ID				aPswDet[01][01]
#DEFINE APSWDET_USER_NAME			aPswDet[01][02]
#DEFINE APSWDET_USER_PWD			aPswDet[01][03]
#DEFINE APSWDET_USER_FULL_NAME	aPswDet[01][04]
#DEFINE APSWDET_USER_GROUPS		aPswDet[01][10]
#DEFINE APSWDET_USER_DEPARTMENT	aPswDet[01][12]
#DEFINE APSWDET_USER_JOB			aPswDet[01][13]
#DEFINE APSWDET_USER_MAIL			aPswDet[01][14]
#DEFINE APSWDET_USER_STAFF			aPswDet[01][22]
#DEFINE APSWDET_USER_DIR_PRINTER	aPswDet[02][03]
#DEFINE APSWDET_USER_MENUS			aPswDet[03]

** Criado por: Alessandro de Farias - amjgfarias@gmail.com - Em: 01/02/2010
** Adaptado por: Flavio Dias - 21/12/2011

User Function RjLeMenu
Local oDlg1
Local nMenu := 0      

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿎hama fun豫o para monitor uso de fontes customizados�
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
U_USORWMAKE(ProcName(),FunName())

@ 150,1 TO 250,300 DIALOG oDlg1 TITLE "Importacao de Contatos"
@ 10, 05 Say "Informe o c�digo do m�dulo:"
@ 10, 90 Get nMenu Picture "@E 99"
@ 40,100 BMPBUTTON TYPE 1 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 CENTERED

if (nMenu > 0)
	MsgRun( "Obtendo infomra寤es do menu dos usuarios no arquivo SIGAPSS.SPF",	"Aguarde...", {|| U_Spf_Proc(nMenu) } )
EndIf

Return

User Function Spf_Proc(nMenu)
Local aUser       := allusers(.T.,.T.)
Private cMenus := ""  

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿎hama fun豫o para monitor uso de fontes customizados�
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
U_USORWMAKE(ProcName(),FunName())

For xi:=1 to Len(aUser)
	ChgUsrInf( aUser[xi][01][01], nMenu )
Next xi

Aviso("Menus dos usu�rios", cMenus, {"OK"}, 3)

Return

Static Function ChgUsrInf(__cUser, nMenu)
Local aPswDet
Local cPswFile	:= "sigapss.spf"
Local cPswId	:= ""
Local cPswName	:= ""
Local cPswPwd 	:= ""
Local cPswDet 	:= ""
Local cUserId	:= __cUser
Local lEncrypt	:= .F.
Local nPswRec	:= 0
Local __cNewDir := "\SIGAADV\"
Local __cOldDir := "\SYSTEM\"

// tratamento para evitar erro do usuario Administrador
If cUserId == "000000"
	Return
Endif

Begin Sequence

//Procuro pelo ID do usuario (imaginando que o ID 000001 esteja cadastrado)
IF ( ( nPswRec := spf_seek( cPswFile , "1U"+cUserId , 1 ) ) <= 0 )
	//Usuario Nao Localizado
	Break
EndIF

IF Type( "cEmpAnt" ) <> "C"
	Private cEmpAnt := "01"
EndIF
IF Type( "cFilAnt" ) <> "C"
	Private cFilAnt := "01"
EndIF

//Obtenho as Informacoes do usuario  retornadas por referencia na variavel cPswDet)
spf_GetFields( @cPswFile , @nPswRec , @cPswId, @cPswName, @cPswPwd, @cPswDet )

//Converto o conteudo da string cPswDet em um Array
aPswDet	:= Str2Array( cPswDet , lEncrypt )

/*For nx:=1 to Len(aPswDet[03])
	ConOut("Menu: " + aPswDet[03][nx])
	cMenus += aPswDet[03][nx] + chr(13) + chr(10)
	//aPswDet[03][nx] :=  Padr(StrTran( aPswDet[03][nx], __cOldDir, __cNewDir ),53) // 53 � o padrao da versao 10 R 1.3
Next nx*/                                          // Valida se o usu�rio est� bloqueado
if (SubStr(aPswDet[03][nMenu], 3, 1) != "X") .And. !aPswDet[01][17]
	cMenus += SubStr(cPswName,3) + aPswDet[03][nMenu] + chr(13) + chr(10)
EndIf

If .F. // ativar este trecho para mudanca de e-mail em massa

	_cEmail    := UsrRetMail(cUserId) // recupera o e-mail do usuario
	If ! Empty(_cEmail) .And. "@DOMINIO_ANTERIOR" $ Upper(_cEmail)
		
		__cEmail := Substr(_cEmail, 1, At('@',_cEmail)) + "novo_dominio.com.br"
		aPswDet[01][14] := APSWDET_USER_MAIL := __cEmail
		
	Endif
	
Endif

//ReConvertendo as informacoes para gravacao
//cPswDet := Array2Str( @aPswDet , lEncrypt )

//Efetivando a alteracao dos dados do usuario
//spf_Update( @cPswFile, @nPswRec, "1U"+APSWDET_USER_ID , Upper("1U"+APSWDET_USER_NAME) , "1U"+APSWDET_USER_PWD , @cPswDet )

End Sequence

Return