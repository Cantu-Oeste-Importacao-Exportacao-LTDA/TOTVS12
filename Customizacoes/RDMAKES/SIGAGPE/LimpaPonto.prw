#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  LIMPAPONTO �Autor  �Cleidisson Drazewski  Data �   2710/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para limpar pontos quando n�o l� por completo       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 11                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function LimpaPonto()

Local cPerg := "LIMPAPONTO"
Local cPerg := PadR(cPerg,10," ")
Local cSql	:= ""   
Local cEol	:= CHR(10) + CHR(13)  
Local lOk	:= .F.
Local aGrupos := {}
/*
PswOrder(2) //Nome do usu�rio
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
	ShowHelpDlg("Aten��o",{"Usu�rio n�o possui acesso de administrador."},5,{"Op��o s� poder� ser executada pelo administrador."},5)	
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
 		MsgInfo("Processo Conclu�do \o/ ")
 	EndIf


Return    


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VLDPERG  �Autor  �Gustavo Lattmann     � Data �  07/03/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o respons�vel pelo par�metros informados pelo usu�rio  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Protheus                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function VldPerg(cPerg)
PutSX1(cPerg,"01","Filial"	    ,"Filial"       ,"Filial "  ,"MV_CH1","C",002,0,0,"G","","","","","MV_PAR01","","","","","","","","","", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")
PutSX1(cPerg,"02","Data Inicio ","Data Inicio "	,"Data Inicio ","MV_CH1","D",008,0,0,"G","","","","","MV_PAR02","","","","","","","","","", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")
PutSX1(cPerg,"03","Data Fim "	,"Data Fim "	,"Data Fim "   ,"MV_CH1","D",008,0,0,"G","","","","","MV_PAR03","","","","","","","","","", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")
Return
