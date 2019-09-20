#INCLUDE "PROTHEUS.CH"
#INCLUDE "xmlxfun.CH"
#INCLUDE "TOPCONN.CH"

User Function ExpStatus()  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//U_USORWMAKE(ProcName(),FunName())

RpcSetType(3)
RpcSetEnv("30","01")

PrcExpStatus()

/*RpcClearEnv()
RpcSetType(3)
RpcSetEnv("31","01")

PrcExpStatus()       */

Return .T.

Static Function PrcExpStatus()
Local cModelo := ''
Local cXml := '' , oXml
Local nL := 0
Local nSaldo := 0
Local aItens := {}
Local aFTPKmv := {}
Local aFTPPS  := {}
Local cFolderFTP := ""
Local _n := 0       
Local ntam :=0

aFTPKmv := StrToKArr(SuperGetMv("MVX_FTPKMV",.F.,"www.kmvpneus.com.br;21;kmvpneus;topgear"),";")
aFTPPS  := StrToKArr(SuperGetMv("MVX_FTPPS" ,.F.,"www.pneustore.com.br;21;pneustore;topgear"),";")
cFolderFTP := SuperGetMv("MVX_FOLDST" ,.F.,"/acceptance/status")

Makedir("\Adena\status\")
cDir := GetSrvProfString("ROOTPATH","") + "Adena/status"

For _n:=1 to 2
	conout("Entrou no FOR n= ")
	conout(_n)
	//sql
	cQuery := "SELECT C6_FILIAL, C5_XPEDADE, C6_NOTA, C6_SERIE, C6_DATFAT, F2_CHVNFE "
	cQuery += " FROM SC6300 SC6 "
	cQuery += " INNER JOIN SC5310 SC5 ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND C5_XPEDADE <> ' ' AND SC5.D_E_L_E_T_ <> '*' "
	cQuery += " AND " + IIF(_n==2,"C5_VEND1 = 'P00422'","C5_VEND1 IN('P00253','P00254')") //SEPARAR POR AMBIENTE
	cQuery += " LEFT JOIN SF2300 SF2 ON F2_FILIAL = C6_FILIAL AND F2_DOC = C5_NOTA AND F2_SERIE = C5_SERIE AND SF2.D_E_L_E_T_ <> '*' AND F2_CHVNFE <> ' ' "
	cQuery += " WHERE C6_NOTA <> ' ' "
	cQuery += " AND C6_DATFAT BETWEEN '" + DtoS(DaySub(dDataBase,1)) + "' AND '" + DtoS(dDataBase) + "'"
	cQuery += " AND SC6.D_E_L_E_T_ <> '*' "   
	cQuery += " GROUP BY C6_FILIAL, C5_XPEDADE, C6_NOTA, C6_SERIE, C6_DATFAT, F2_CHVNFE"
	cQuery += " UNION ALL "
	cQuery += "SELECT C6_FILIAL, C5_XPEDADE, C6_NOTA, C6_SERIE, C6_DATFAT, F2_CHVNFE "
	cQuery += " FROM SC6310 SC6 "
	cQuery += " INNER JOIN SC5310 SC5 ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND C5_XPEDADE <> ' ' AND SC5.D_E_L_E_T_ <> '*' "
	cQuery += " AND " + IIF(_n==2,"C5_VEND1 = 'P00422'","C5_VEND1 IN('P00253','P00254')") //SEPARAR POR AMBIENTE	
	cQuery += " LEFT JOIN SF2310 SF2 ON F2_FILIAL = C6_FILIAL AND F2_DOC = C5_NOTA AND F2_SERIE = C5_SERIE AND SF2.D_E_L_E_T_ <> '*' AND F2_CHVNFE <> ' ' "
	cQuery += " WHERE C6_NOTA <> ' ' "
	cQuery += " AND C6_DATFAT BETWEEN '" + DtoS(DaySub(dDataBase,1)) + "' AND '" + DtoS(dDataBase) + "'"
	cQuery += " AND SC6.D_E_L_E_T_ <> '*' "   
	cQuery += " GROUP BY C6_FILIAL, C5_XPEDADE, C6_NOTA, C6_SERIE, C6_DATFAT, F2_CHVNFE"	
	cQuery += "	ORDER BY 2"
	cQuery := ChangeQuery(cQuery)

	conout("SQL")
	conout(cQuery)

	If Select("WORK") != 0
	  	WORK->( DbCloseArea() )
	EndIf
	
	TCQUERY cQuery NEW ALIAS "WORK"
	dbSelectArea("WORK")
	
	If WORK->(!EOF())
		cModelo +=  '<?xml version="1.0" encoding="UTF-8"?>'
		cModelo += 	'<pedidos>'
		cModelo += 	'<pedido>'
		cModelo +=  '<codigo></codigo>'
		cModelo += 	'<status></status>'
		cModelo += 	'<mensagem></mensagem>'
		cModelo += 	'</pedido>'
		cModelo += 	'</pedidos>'
		
		CREATE oXML XMLSTRING cModelo SETASARRAY _Pedidos:_Pedido
		
		nXmlStatus := XMLError()
		
		If ( nXmlStatus == XERROR_SUCCESS )
			
			oXml:__XML:_ENCODING:TEXT := RemAspas(oXml:__XML:_ENCODING:TEXT)
			oXml:__XML:_VERSION:TEXT  := RemAspas(oXml:__XML:_VERSION:TEXT)
			
			nL := 0
			
			While WORK->(!EOF())
				
				/*dbSelectArea("SF2")
				dbSetOrder(1)
				dbGoTop()
				If dbSeek ( WORK->C6_FILIAL + WORK->C6_NOTA + WORK->C6_SERIE )*/
					
					nL++
					                                               
					ntam:= len(Alltrim(WORK->C5_XPEDADE))
					conout(ntam)
					oXml:_Pedidos:_Pedido[nL]:_codigo:TEXT 		:= substr(Alltrim(WORK->C5_XPEDADE),1,ntam-1)
					conout(substr(Alltrim(WORK->C5_XPEDADE),1,ntam-1))
					If WORK->C6_DATFAT == DTOS(dDataBase)
						oXml:_Pedidos:_Pedido[nL]:_status:TEXT 	:= "LE"
					Else
						oXml:_Pedidos:_Pedido[nL]:_status:TEXT 	:= "PE"
					EndIf
					oXml:_Pedidos:_Pedido[nL]:_mensagem:TEXT 	:= Alltrim(WORK->C6_NOTA) + "-" + Alltrim(WORK->C6_SERIE) + "/" + ALLTRIM(WORK->F2_CHVNFE)
					
					ADDNODE oXml:_Pedidos:_Pedido NODE '_Pedido' ON oXML
					
			   //	EndIf
				
				WORK->(dbSkip())
				
			EndDo
			
			// Ao fim do processo , gera a string XML correspondente ao Objeto
			SAVE oXml XMLSTRING cXml
			
			MemoWrite(cDir+"\status.xml",cXml)
			conout("Gerou XML")
			If _n == 1 //KMV
				If FTPConnect(aFTPKmv[1],Val(aFTPKmv[2]),aFTPKmv[3],aFTPKmv[4])
					conout("FTP KMV")
					If FTPDirChange(cFolderFTP)
						If !FTPUPLOAD( "/adena/status/status.xml"  , "status.xml" )
							//	Aviso( "CEXPKTN", "Nao foi possivel enviar arquivo!!", {"Ok"} )
						Endif
						
						FTPDISCONNECT()
					endif
				Endif
				
				If FErase("/adena/status/status.xml" ) != 0
					//	Aviso( "CEXPKTN	", "erro ao excluir arquivos", {"Ok"} )
				Endif
			else //PneuStore
				If FTPConnect(aFTPPS[1],Val(aFTPPS[2]),aFTPPS[3],aFTPPS[4])
					conout("FTP Pneu Store") 
					If FTPDirChange(cFolderFTP)
						if !FTPUPLOAD( "/adena/status/status.xml" , "status.xml" )
							//	Aviso( "CEXPKTN", "Nao foi possivel enviar arquivo!!", {"Ok"} )
						Endif
						
						FTPDISCONNECT()
					endif
				Endif
				
				If FErase("/adena/status/status.xml" ) != 0
					//	Aviso( "CEXPKTN	", "erro ao excluir arquivos", {"Ok"} )
				Endif
			EndIf
		Endif
	EndIf
Next _n

Return

Static function RemAspas(cx)

if left(cx,1) == '"' .and. right(cx,1) == '"'
	
	return substr(cx,2,len(cx)-2)
	
Elseif left(cx,1) == "'" .and. right(cx,1) == "'"
	
	return substr(cx,2,len(cx)-2)
	
Endif

return cx
