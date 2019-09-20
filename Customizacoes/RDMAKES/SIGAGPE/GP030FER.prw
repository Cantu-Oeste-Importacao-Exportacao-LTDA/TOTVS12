#INCLUDE "Protheus.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GP030FER  ºAutor  ³Luiz Prado          º Data ³  29/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para envio wf para avisar as pessoas      º±±
±±º          ³ definidas no parametro MV_X_FER que o funcionario sai de   º±±
±±º          ³ ferias                                                     º±±
±±ºDesc.     ³  Ponto de entrada para verificar se existe bloqueio de     º±±
±±º          ³  rescisao na tabela Z26, caso afirmativo e o periodo do    º±±
±±º          ³  calculo de ferias que esta sendo calculado altera tipo bloº±±
±±º          ³  queio                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P10 - Especifico GRUPO CANTU                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function GP030FER()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// Inicio envio wf

cProcess := OemToAnsi("000001") // Numero do Processo
cStatus  := OemToAnsi("001000")

oProcess := TWFProcess():New(cProcess,OemToAnsi("Ferias calculadas "))
oProcess:NewTask(cStatus,"\workflow\cantu\wfferias.html")
oProcess:cSubject := OemToAnsi("Ferias calculadas para funcionario: " + ALLTRIM(M->RH_NOME))

oProcess:cTo :=  GetMv('MV_X_FERIA')

oHtml:= oProcess:oHtml

oHtml:ValByName("CODIGO", CEMPANT)
oHtml:ValByName("EMPRESA", SM0->M0_NOMECOM)
oHtml:ValByName("FILIAL", CFILANT)
oHtml:ValByName("MATRICULA" , M->RH_MAT)
oHtml:ValByName("NOME", M->RH_NOME)
oHtml:ValByName("AVISO", DTOC(M->RH_DTAVISO))
oHtml:ValByName("DIAS", M->RH_DFERIAS)
oHtml:ValByName("INICIO", DTOC(M->RH_DATAINI))
oHtml:ValByName("FINAL" , DTOC(M->RH_DATAFIM))
oHtml:ValByName("USUARIO", SubStr(cUsuario,7,15))

oProcess:Start()
// final envio wf para diretoria

// Verifica se existe bloqueio de rescisao na tabela Z26, caso afirmativo e o periodo do calculo de ferias que esta sendo calculado altera tipo bloqueio                                                     º±±

DbSelectArea("Z26")
DbSetorder(4)
DbGotop()
If dbSeek(xFilial("Z26") + SRF->RF_MAT + DtoS(SRF->RF_DATABAS) )
	RecLock("Z26",.F.)
	Z26->Z26_LIBERA  := "S"
	Z26->Z26_USERLI := cUserName
	Z26->Z26_DTLIBER := dDataBase
	Z26->Z26_OBS := "Lib atraves calculo ferias "
	Z26->(MSUnLock())
endif

Return
