#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FILEIO.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
���������������������������������������������`���������������������������ͻ��
���Programa  � RECIPROC    �Autor: Microsiga         � Data �  11/12/2012 ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa que ser� utilizado para avaliar o arquivo de      ���
���          � Reciprocidade do Serasa.                                   ���
�������������������������������������������������������������������������͹��
���Uso       � Financeiro                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Reciproc()

Local cEol       := CHR(13) + CHR(10)
Private cFile    := ""
Private nQtdProc := 0
Private nQtdLiq  := 0
Private lCorreto := .T.             

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

ConOut("IN�CIO EXECU��O DA ROTINA DE RECIPROCIDADE...")
	

//����������������������������������������������������������������������������������
//�Utilizado fun��o cGetFile para que o usu�rio aponte orquivo que ser� processado.�
//����������������������������������������������������������������������������������

cFile := cGetFile( "Reciprocidade Serasa | *.txt" , "Selecione o arquivo disponibilizado pelo Serasa", 1, , .T., GETF_LOCALHARD + GETF_NETWORKDRIVE)

//������������������������������������������������������������
//� Se o retorno da fun��o cGetFile for vazio, sai da rotina.�
//������������������������������������������������������������

if !File(cFile)
	
	//�������������������������������������������������������������������
	//� Se o arquivo informado n�o for um arquivo v�lido, sai da rotina.�
	//�������������������������������������������������������������������
	
	if !Empty(cFile)
		MsgInfo("O arquivo informado n�o existe ;( ")
	EndIf
	
	ConOut("PROCESSO ABORTADO: ARQUIVO INFORMADO INV�LIDO.")
	
	Return nil
EndIf 

ConOut("IN�CIO DO PROCESSAMENTO DO ARQUIVO "+ Upper(AllTrim(cFile)) +".")
	
Processa({|| ProcArq()}," Avaliando arquivo de Reciprocidade... ")

if lCorreto 
	Aviso("Execu��o Finalizada com Sucesso!", AllTrim(Str(nQtdProc))+ iif(nQtdProc > 1," t�tulos processados."," t�tulo processado.")+ cEol +;
		  									  AllTrim(Str(nQtdLiq)) + iif(nQtdLiq > 1," t�tulos liquidados."," t�tulo liquidado."), {"Finalizar"},2)
Else
	Aviso("Execu��o Finalizada com ERRO!", AllTrim(Str(nQtdProc))+ " t�tulos processados."+ cEol +;
		  								   AllTrim(Str(nQtdLiq)) + " t�tulos liquidados.", {"Finalizar"},2)
EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
���������������������������������������������`���������������������������ͻ��
���Programa  � PROCARQ  �Autor: Microsiga            � Data �  13/12/2012 ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o que far� o processamento do arquivo de texto.       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Financeiro                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ProcArq()

Local nHdl
Local cBuffer := ""
Local cBufGrv := ""
Local cCabec  := ""
Local cChave  := ""
Local nPosChv := 68					// Posi��o da chave do t�tulo no arquivo
Local nTamChv := 18					// Tamanho do campo chave do t�tulo
Local nPosDat := 58					// Posi��o da data do pagamento no arquivo
Local nTipDat := 8					// Tipo da data de pagamento que ser� gravada 8 - AAAAMMDD
Local nTamDat := 8					// Tamanho do campo data
Local nTamArq := 0			
Local nTamLin := 130 				// Tamanho da Linha do arquivo
Local nBytes  := 0  
local cDtArq  := ""
Local cEol    := CHR(13)+CHR(10)	// Final de Linha

//����������������������������������������������������������������������������������������������������
//� Utilizado fun��o fOpen para abrir o arquivo passando como par�metro a op��o 2 - Leitura e Edi��o �
//����������������������������������������������������������������������������������������������������

nHdl := fOpen(cFile,2)
if !(nHdl > 0)
	
	//�������������������������������������������������������������
	//� Se ocorrer erro na abertura do arquivo, aborta o processo �
	//�������������������������������������������������������������
	
	ConOut("N�O FOI POSS�VEL FAZER A ABERTURA DO ARQUIVO")
	lCorreto := .F.
	
	Alert("O arquivo informado est� vazio ou corrompido. Processo cancelado...")
	Return Nil
EndIf

//����������������������������������������������������������������
//� L� o tamanho do arquivo para setar na r�gua de processamento �
//����������������������������������������������������������������

nTamArq := fSeek(nHdl,0,FS_END)
ProcRegua(nTamArq / (nTamLin+1))

//���������������������������������������������
//� Posiciona no primeiro caractere do arquivo.�
//���������������������������������������������

fseek(nHdl,0,FS_SET)
nBytes := fRead(nHdl,@cBuffer,nTamLin+1)   

//�����������������������������������
//� Valoriza o cabe�alho do arquivo �
//�����������������������������������

cCabec := cBuffer 

if Empty(cCabec)
	
	//����������������������������������������������������������������
	//� Finaliza o arquivo caso houver erro na leitura do cabe�alho. �
	//����������������������������������������������������������������
	
	lCorreto := .F.
	
	Alert("Primeira linha do arquivo � inv�lida. Verifique se o arquivo est� correto!")
	fClose(nHdl) 
	Return
EndIf

if SubStr(cCabec,37,08) != "CONCILIA"
	
	//��������������������������������������������������������������
	//� Finaliza o arquivo caso n�o for um arquivo de concilia��o. �
	//��������������������������������������������������������������
	
	lCorreto := .F.
	
	Alert("O arquivo informado n�o � um arquivo de concilia��o!")
	fClose(nHdl) 
	Return
EndIf
      
cDtArq := Alltrim(SubStr(cCabec,45,08))

if Aviso("Data de Processamento","S� ser�o considerados t�tulos baixados com data anterior ou igual � data do arquivo: "+; 
				 AllTrim(DtoC(StoD(cDtArq))),{"Continua?","Cancelar?"},2) != 1
	fClose(nHdl)
	Return
EndIf

While (nBytes == nTamLin+1) 
	IncProc()
	
	nBytes := fRead(nHdl,@cBuffer,nTamLin+1)
	
	//�����������������������������������������������
	//� Verifica se � o �ltimo registro do arquivo. �
	//�����������������������������������������������
	
	if (SubStr(cBuffer,01,02) == "01")
	
		nQtdProc++
		
		//������������������������������������������������������������
		//� Valoriza com a chave do t�tulo que est� vindo no arquivo �
		//������������������������������������������������������������
		
		cChave := SubStr(cBuffer, nPosChv, nTamChv)
		
		DbSelectArea("SE1")
		SE1->(DbSetOrder(1))
		
		//��������������������������������������������������������
		//� Busca pela chave no C.R. e verifica se foi liquidado.�
		//��������������������������������������������������������
		
		if SE1->(dbseek(xFilial("SE1") + cChave))
			if SE1->E1_SALDO == 0 .and. DtoS(SE1->E1_BAIXA) <= cDtArq
				
				nQtdLiq++                                              			
				
				cBufGrv := SubStr(cBuffer, 01, nPosDat-1) + GravaData(SE1->E1_BAIXA,.F.,8) +;
						   SubStr(cBuffer, (nPosDat+nTamDat), ((nTamLin + 1)-(nPosDat+nTamDat-1)))
				
				//�����������������������������������������������������
				//� Posiciona no in�cio do registro que ser� alterado �
				//�����������������������������������������������������
				
				fSeek(nHdl,-1 * (nTamLin+1),1)		
				
				//��������������������������������
				//� Efetua a grava��o no arquivo �
				//��������������������������������
				
				fWrite(nHdl,cBufGrv)				
			
			Else
				
				cBufGrv := SubStr(cBuffer, 01, nPosDat-1) + Space(08) +;
						   SubStr(cBuffer, (nPosDat+nTamDat), ((nTamLin + 1)-(nPosDat+nTamDat-1)))
				
				//�����������������������������������������������������
				//� Posiciona no in�cio do registro que ser� alterado �
				//�����������������������������������������������������
				
				fSeek(nHdl,-1 * (nTamLin+1),1)		
				
				//��������������������������������
				//� Efetua a grava��o no arquivo �
				//��������������������������������
				
				fWrite(nHdl,cBufGrv)				
						  
			EndIf
		Else
		  
			cBufGrv := SubStr(cBuffer, 01, nPosDat-1) + Space(08) +;
						   SubStr(cBuffer, (nPosDat+nTamDat), ((nTamLin + 1)-(nPosDat+nTamDat-1)))
			
			//�����������������������������������������������������
			//� Posiciona no in�cio do registro que ser� alterado �
			//�����������������������������������������������������
			
			fSeek(nHdl,-1 * (nTamLin+1),1)		
			
			//��������������������������������
			//� Efetua a grava��o no arquivo �
			//��������������������������������
			
			fWrite(nHdl,cBufGrv)				
			
			ConOut("T�TULO CHAVE "+ AllTrim(cChave) +" N�O FOI ENCONTRADO.")

		EndIf
			
	EndIf
	
EndDo 	

fClose(nHdl)

ConOut("FIM DO PROCESSAMENTO DO ARQUIVO...")

Return  