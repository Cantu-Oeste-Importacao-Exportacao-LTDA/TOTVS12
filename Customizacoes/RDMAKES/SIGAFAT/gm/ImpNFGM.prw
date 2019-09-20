//confirmacao NF da gm, GM ENVIA PARA FORNECEDOR
#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

User Function ImpNFGM()
Local cFile
Local cStr
Local cSql := ""
Local cEol := CHR(13)+CHR(10) 
Local cPacAlt := ""
Local nCount := 0     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

cFile := cGetFile( "arquivos de pedido GM | *.*" , "Selecione o arquivo enviado pela GM", 0,"",.T.)
if !File(cFile)
	Alert("Caminho espeficicado não é válido.")
	Return nil
EndIf       

ZZW->(dbSetOrder(2))
                                           
if !Empty(cFile)
	nHdl := FT_FUSE(cFile)           		
	nCount := 0

	// Le o Header
	cStr := Ft_Freadln()
	cPacote := SubStr(cStr, 7, 50)
	FT_FSKIP()
	// Vai para as linhas
  cStr := Ft_Freadln()
		
	//lFound := ZZW->(dbSeek(xFilial("ZZW") + cPacote))
	
  While !FT_FEOF() .And. SubStr(cStr, 1, 8) != "TRAILLER" 
      cPeca   := ""
      cCliGM  := ""
      cPedCli := ""
      cNfGm   := ""
      cSerGm  := ""
      cDtNf   := ""
      cSql    := ""
            
	   	if SubStr(cStr, 1, 8) != ""   
	   	   cPECA   := SubStr(cStr,  1, 8)
		  	 cCLIGM  := SubStr(cStr,  9, 6)
		  	 cPEDCLI := SubStr(cStr, 15, 6)
		  	 cNfGm   := SubStr(cStr, 21, 9)
		  	 cSerGm  := SubStr(cStr, 30, 3)
		  	 cDtNf   := SubStr(cStr, 46, 4) + SubStr(cStr, 44, 2) + SubStr(cStr, 42, 2)  //Converte a data para YYYMMAA
		  	  	  	   	   	   
	   	   DbSelectArea("ZZW")
		   
	   	   csql := "SELECT Z.ZZW_PACOTE,Z.ZZW_PECA,Z.ZZW_CLIGM,Z.ZZW_PEDCLI "             +cEol
         csql += "FROM " + RetSqlName("ZZW") + " Z "                                    +cEol
	   	   csql += "WHERE  Z.D_E_L_E_T_<> '*' " /*AND Z.ZZW_PACOTE = '"+cPacote+ "'*/     +cEol
	   	   csql += "AND Z.ZZW_PECA = '" +cPeca+ "' "                                      +cEol
	   	   csql += "AND Z.ZZW_CLIGM = '" +cCLIGM+ "' "                                    +cEol
	   	   csql += "AND Z.ZZW_NPEDGM = '" +cPEDCLI+ "' "                                  +cEol
         
        TcQuery cSql NEW ALIAS "ZZWTMP"
        DbSelectArea("ZZWTMP") 

       //if ZZWTMP->(!Eof())
      	DbSelectArea("ZZW") 
      	DBSetOrder(4) 
      	if dbSeek(xFilial("ZZW") + ZZWTMP->ZZW_PACOTE + ZZWTMP->ZZW_PEDCLI + ZZWTMP->ZZW_PECA)
        	 RecLock("ZZW", .F.)
           ZZW->ZZW_NFGM   := cNfGm 
           ZZW->ZZW_SERGM  := cSerGm
           ZZW->ZZW_DTCONF := cDtNf
      	   ZZW->(MsUnlock()) 
           nCount ++
           
           // Avalia o código do pacote para que o mesmo seja mostrado apenas uma vez.
           if !(At(AllTrim(ZZW->ZZW_PACOTE), cPacAlt) > 0)
           	cPacAlt += AllTrim(ZZW->ZZW_PACOTE)+cEol
           EndIf
        endif
        
        ZZWTMP->(dbCloseArea())
	   	endif
     	FT_FSKIP()
     	cStr := Ft_Freadln()
  EndDo
	
	FT_FUSE()                        
	fClose(nHdl)
EndIf

cPacAlt += cEol + Str(nCount) + " linhas alteradas."
Aviso("Pacotes atualizados: ",cPacAlt, {"OK"})

Return
