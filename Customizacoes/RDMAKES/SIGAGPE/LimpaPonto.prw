#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  LIMPAPONTO บAutor  ณCleidisson Drazewski  Data ณ   2710/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para limpar pontos quando nใo l๊ por completo       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 11                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function LimpaPonto()

Local cPerg := "LIMPAPONTO"
Local cPerg := PadR(cPerg,10," ")
Local cSql	:= ""   
Local cEol	:= CHR(10) + CHR(13)  
Local lOk	:= .F.
Local aGrupos := {}
/*
PswOrder(2) //Nome do usuแrio
If PswSeek(cUserName)				
   aGrupos := PswRet()[1][10]
EndIf   

For nI := 1 To Len(aGrupos)
	If aGrupos[nI] == "000000" //grupo Administrador
		lOk := .T.
	EndIf
Next nI        

If lOk
	VldPerg(cPerg)  // Chama funcao VldPerg para Verificar se as Perguntas existem no SX1, se nao existir cria
	AjusteSX1(cPerg)
	If !Pergunte(cPerg,.T.)
		Return
	EndIf
Else
	ShowHelpDlg("Aten็ใo",{"Usuแrio nใo possui acesso de administrador."},5,{"Op็ใo s๓ poderแ ser executada pelo administrador."},5)	
EndIf		
  */     
  
  	VldPerg(cPerg)  // Chama funcao VldPerg para Verificar se as Perguntas existem no SX1, se nao existir cria
	AjusteSX1(cPerg)
	If !Pergunte(cPerg,.T.)
		Return
	EndIf
  
		cSql += "BEGIN "																															+cEol
		cSql += "UPDATE " + RetSqlName("RFB") + " RFB SET  RFB.D_E_L_E_T_   = '*' "  										  						+cEol
		cSql += "WHERE RFB.RFB_FILIAL = '" + MV_PAR01 + "'"																							+cEol
		cSql += "AND to_char(to_date(SUBSTR(RFB_DTHRLI,0,6),'YYMMDD'),'YYYYMMDD')BETWEEN '" + dtos(MV_PAR02) + "' AND '" + dtos(MV_PAR03) + "';" 	+cEol
	
		cSql += "UPDATE " + RetSqlName("RFE") + " RFE  SET  RFE.D_E_L_E_T_   = '*' "											  					+cEol
		cSql += "WHERE RFE.RFE_FILIAL = '" + MV_PAR01 + "'"																		  					+cEol  
		cSql += "AND RFE.RFE_DATA BETWEEN '"  + dtos(MV_PAR02) + "' AND '" + dtos(MV_PAR03)	+ "';" 								  					+cEol 
		
		cSql += "UPDATE " + RetSqlName("SP8") + " SP8  SET  SP8.D_E_L_E_T_   = '*' "	  										  					+cEol
		cSql += "WHERE SP8.P8_FILIAL = '" + MV_PAR01 + "'"																		 					+cEol 
		cSql += "AND SP8.P8_DATA BETWEEN '" + dtos(MV_PAR02) + "' AND '" + dtos(MV_PAR03)	+ "';" 								  					+cEol 
		cSql += "END;"  																										   					+cEol	

If (TCSQLExec(cSql) < 0)
    	Return MsgStop("TCSQLError() " + TCSQLError()) 
 	Else
 		MsgInfo("Processo Concluํdo \o/ ")
 	EndIf


Return    


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVLDPERG  บAutor  ณGustavo Lattmann     บ Data ณ  07/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel pelo parโmetros informados pelo usuแrio  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณProtheus                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldPerg(cPerg)
PutSX1(cPerg,"01","Filial"	    ,"Filial"       ,"Filial "  ,"MV_CH1","C",002,0,0,"G","","","","","MV_PAR01","","","","","","","","","", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")
PutSX1(cPerg,"02","Data Inicio ","Data Inicio "	,"Data Inicio ","MV_CH1","D",008,0,0,"G","","","","","MV_PAR02","","","","","","","","","", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")
PutSX1(cPerg,"03","Data Fim "	,"Data Fim "	,"Data Fim "   ,"MV_CH1","D",008,0,0,"G","","","","","MV_PAR03","","","","","","","","","", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")
Return
