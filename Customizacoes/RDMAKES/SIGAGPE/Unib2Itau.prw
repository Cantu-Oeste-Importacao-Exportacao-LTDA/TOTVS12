#INCLUDE "rwmake.ch"                     
#INCLUDE "TopConn.ch"
/************************************************
 Fun��o para gerar arquivo de transferencia das 
 	contas do unibanco para itau.
 Faz o processamento do envio e outra far� o 
 processamento do retorno.
 Flavio - 27/07/2010 
 ************************************************/
User Function Unib2Itau()
Local cBanco := "409"
Local cDataAt := DToS(Date())
Local cTipo := "Arquivos Texto | *.txt"
Local cFile	:= cGetFile( cTipo , "Selecione onde salvar o arquivo", 0,"",.F.)
Private nHdl := 0
nHdl := FCreate(cFile)
dbSelectArea("SRA")
dbSetOrder(01)
dbSeek(xFilial("SRA")) 

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

While SRA->(!Eof()) .and. SRA->RA_FILIAL == xFilial("SRA")
	if SubStr(SRA->RA_BCDEPSA, 1, 3) == cBanco
		cLinha := SubStr(cDataAt, 7, 2) + SubStr(cDataAt, 5, 2) + SubStr(cDataAt, 1, 4) // data
		cLinha += PadL(AllTrim(SM0->M0_CGC), 14, '0') + cBanco  // cnpj do cliente + banco
		cLinha += PadL(AllTrim(SubStr(SRA->RA_BCDEPSA, 4)), 4, '0') // agencia
		cLinha += SubStr(SRA->RA_CTDEPSA, 6, 7)  // Conta + digito conta
		cLinha += "1"//  1 - fisica  2 - juridica
		cLinha += SRA->RA_CIC
		cLinha += "341"
		cLinha += Replicate('0', 12) // dados de retorno
		cLinha += Replicate('0', 24) // complemento de registro
		Write(cLinha)
	EndIf
	SRA->(dbSkip())
EndDo
            
// fecha o arquivo
fClose(nHdl)

Return

// Fun��o que escreve cada linha do arquivo
Static Function Write(cLin)
cEOL    := "CHR(13)+CHR(10)"
cEOL	:= &cEOL
cLin += cEOL
If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
		Break
	Endif
Endif

Return Nil



/************************************************
 Fun��o para processar o arquivo de retorno das 
 	contas do unibanco para itau.
 Flavio - 20/09/2010 
 ************************************************/
User Function Atu2Itau()
Local cBanco := "409"
Local cDataAt := DToS(Date())
Local cTipo := "Arquivos retorno | *.*"
Local cFile	:= cGetFile( cTipo , "Selecione onde salvar o arquivo", 0,"",.T.)
Local nQtdAtu := 0
Private nHdl := 0
// nHdl := FOpen(cFileNF)

dbSelectArea("SRA")
dbSetOrder(05)

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

FT_FUse(cFile)
FT_FGOTOP()
While !FT_FEof()
	cStr := FT_FReadln()
  if !Empty(cStr) .And. (SubStr(cStr, 66, 1) == "2")
  	cChave := xFilial("SRA") + SubStr(cStr, 38, 11)	
  	if SRA->(dbSeek(cChave))
  		RecLock("SRA", .F.)
  		SRA->RA_BCDEPSA := SubStr(cStr, 52, 7)
  		SRA->RA_CTDEPSA := PadL(SubStr(cStr, 59, 7), 12, '0')
  		MsUnlock()
  		nQtdAtu++
  	Else
  		Alert("Funcionario " + SubStr(cChave, 2) + " n�o localizado.")
  	EndIf  	
  EndIf
  FT_FSkip()
EndDo

MsgInfo("Foram atualizadas "  + AllTrim(Str(nQtdAtu)) + " contas de funcion�rios")

// fecha o arquivo
FT_FUse()
Return