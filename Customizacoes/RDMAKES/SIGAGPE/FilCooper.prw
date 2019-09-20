#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"    
#include "Fileio.ch" 

User Function FilCooper()
Local cFile
Local cStr 
Local nArq                                                                                
Local cPath 
Local cTipo := "Arquivos txt | *.txt"
nGravados := 0     

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

cFile := cGetFile( "arquivo CooperCred | *.txt*" , "Selecione o arquivo enviado pelo forncedor CooperCred", 0,"",.T.)
if !File(cFile)
	Alert("Caminho espeficicado n�o � v�lido.")
	Return nil
EndIf       

//criando o arquivo com os registros
cNome := "COOPERCRED.txt"
cPath := cGetFile( cTipo , "Selecione onde salvar o arquivo que ser� filtrado", 0,"",.F., GETF_RETDIRECTORY + GETF_LOCALHARD)
  if ExistDir(cPath)
	   nArq  := FCreate(cPath+cNome)	
  else
    Alert("Diret�rio inv�lido!")
	  Return nil
  EndIf
  If nArq == -1
     MsgAlert("Nao foi poss�vel criar o arquivo!")
     Return
  EndIf

  if !Empty(cFile)
	   nHdl := FT_FUSE(cFile)           		

	  // Vai para as linhas
	  cStr := Ft_Freadln()
		
	While !FT_FEOF() 
		cStr := Ft_Freadln()  	
    
    //excluir a linha do arqivo
	  if SubStr(cStr, 16, 6) = "000000"     //se os '6'ultimos digitos forem "0" entao n�o gravar no arquivo
		   cStr := ''
    else         
	     cConteudo := ""
	  
	     // Controle do processamento
	     IncProc("Filtrados "+ cValToChar(nGravados) +" registros")

       cConteudo := PadL(cStr, 21)         
       //grava o arquivo
 	     FWrite(nArq, PadR(cConteudo,123) + Chr(13) + Chr(10))  
 	     nGravados++ 
    endif 
    FT_FSKIP()
	EndDo
	
	FT_FUSE()
	fClose(nHdl)
  FClose(nArq)

  MsgInfo("Arquivo criado em " + cPath + cNome, "Exporta��o para Arquivo .txt")
                   	
else
	MsgInfo("Arquivo vazio.") 
EndIf
Return