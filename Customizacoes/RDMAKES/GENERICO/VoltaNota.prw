#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VOLTANOTA �Autor  �Gustavo Lattmann    � Data �  18/08/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para retornar notas n�o canceladas pela Sefaz       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 11                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function VoltaNota()

Local cPerg := "VOLTANOTA"
Local cPerg := PadR(cPerg,10," ")
Local cSql	:= ""   
Local cEol	:= CHR(10) + CHR(13)  
Local lOk	:= .F.
Local aGrupos := {}

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

If lOk
    If MV_PAR07 == 1
		cSql += "BEGIN "																										+cEol
		cSql += "UPDATE " + RetSqlName("SD1") + " ITEM SET  ITEM.D_E_L_E_T_   = ' ' "  											+cEol
		cSql += "WHERE ITEM.D1_DOC BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04	+ "'"											+cEol
		cSql += "AND ITEM.D1_FILIAL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'"											+cEol
		cSql += "AND ITEM.D1_SERIE BETWEEN '"+ MV_PAR05 + "' AND '" + MV_PAR06 +"'; " 											+cEol
		cSql += "UPDATE " + RetSqlName("SF1") + " CAB  SET  CAB.D_E_L_E_T_   = ' ' "											+cEol
		cSql += "WHERE CAB.F1_DOC BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04	+ "'"											+cEol  
		cSql += "AND CAB.F1_FILIAL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02	+ "'"	   										+cEol 
		cSql += "AND CAB.F1_SERIE  BETWEEN '"+ MV_PAR05 + "' AND '" + MV_PAR06 +"'; "  											+cEol
		cSql += "UPDATE " + RetSqlName("SE2") + " TIT  SET  TIT.D_E_L_E_T_   = ' ' "	  										+cEol
		cSql += "WHERE TIT.E2_NUM BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'"											+cEol 
		cSql += "AND TIT.E2_FILIAL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02	+ "'"  											+cEol 
		cSql += "AND TIT.E2_PREFIXO BETWEEN '"+ MV_PAR05 + "' AND '" + MV_PAR06 +"'; "										   	+cEol
		cSql += "UPDATE " + RetSqlName("SF3") + " LFIS SET LFIS.F3_DTCANC = ' ' , LFIS.F3_OBSERV  = ' ', LFIS.F3_CODRSEF = '100' " +cEol   
		cSql += "WHERE LFIS.F3_NFISCAL BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'"	 									+cEol 
		cSql += "AND LFIS.F3_FILIAL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'" 											+cEol 
		cSql += "AND LFIS.F3_SERIE BETWEEN '"+ MV_PAR05 + "' AND '" + MV_PAR06 +"'; "  											+cEol
		cSql += "UPDATE " + RetSqlName("SFT") + " LF   SET LF.FT_DTCANC   = ' ' , LF.FT_OBSERV    = ' ' " 						+cEol
		cSql += "WHERE LF.FT_NFISCAL BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'"											+cEol 
		cSql += "AND LF.FT_FILIAL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'"   											+cEol 
		cSql += "AND LF.FT_SERIE BETWEEN '"+ MV_PAR05 + "' AND '" + MV_PAR06 +"'; " 	   										+cEol
		cSql += "END;"  																										+cEol	
    
	ElseIf MV_PAR07 == 2 
		cSql += "BEGIN "																										+cEol
		cSql += "UPDATE " + RetSqlName("SD2") + " ITEM SET  ITEM.D_E_L_E_T_   = ' ' "  											+cEol
		cSql += "WHERE ITEM.D2_DOC BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04	+ "'"											+cEol
		cSql += "AND ITEM.D2_FILIAL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'"											+cEol
		cSql += "AND ITEM.D2_SERIE BETWEEN '"+ MV_PAR05 + "' AND '" + MV_PAR06 +"'; " 											+cEol
		cSql += "UPDATE " + RetSqlName("SF2") + " CAB  SET  CAB.D_E_L_E_T_   = ' ' "											+cEol
		cSql += "WHERE CAB.F2_DOC BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04	+ "'"											+cEol  
		cSql += "AND CAB.F2_FILIAL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02	+ "'"	   										+cEol 
		cSql += "AND CAB.F2_SERIE  BETWEEN '"+ MV_PAR05 + "' AND '" + MV_PAR06 +"'; "  											+cEol
		cSql += "UPDATE " + RetSqlName("SE1") + " TIT  SET  TIT.D_E_L_E_T_   = ' ' "	  										+cEol
		cSql += "WHERE TIT.E1_NUM BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'"											+cEol 
		cSql += "AND TIT.E1_FILIAL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02	+ "'"  											+cEol 
		cSql += "AND TIT.E1_PREFIXO BETWEEN '"+ MV_PAR05 + "' AND '" + MV_PAR06 +"'; "										   	+cEol
		cSql += "UPDATE " + RetSqlName("SF3") + " LFIS SET LFIS.F3_DTCANC = ' ' , LFIS.F3_OBSERV  = ' ', LFIS.F3_CODRSEF = '100' " +cEol   
		cSql += "WHERE LFIS.F3_NFISCAL BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'"	 									+cEol 
		cSql += "AND LFIS.F3_FILIAL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'" 											+cEol 
		cSql += "AND LFIS.F3_SERIE BETWEEN '"+ MV_PAR05 + "' AND '" + MV_PAR06 +"'; "  											+cEol
		cSql += "UPDATE " + RetSqlName("SFT") + " LF   SET LF.FT_DTCANC   = ' ' , LF.FT_OBSERV    = ' ' " 						+cEol
		cSql += "WHERE LF.FT_NFISCAL BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'"											+cEol 
		cSql += "AND LF.FT_FILIAL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'"   											+cEol 
		cSql += "AND LF.FT_SERIE BETWEEN '"+ MV_PAR05 + "' AND '" + MV_PAR06 +"'; " 	   										+cEol
		cSql += "END;"  																										+cEol	
	EndIf
	If (TCSQLExec(cSql) < 0)
    	Return MsgStop("TCSQLError() " + TCSQLError()) 
 	Else
 		MsgInfo("Processo Conclu�do \o/ ")
 	EndIf
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

PutSX1(cPerg,"01","Filial de "	,"Filial de "   ,"Filial de "  ,"MV_CH1","C",002,0,0,"G","","","","","MV_PAR01","","","","","","","","","", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")
PutSX1(cPerg,"02","Filial at� "	,"Filial at� "  ,"Filial at� " ,"MV_CH1","C",002,0,0,"G","","","","","MV_PAR02","","","","","","","","","", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")
PutSX1(cPerg,"03","Nota de "	,"Nota de "		,"Nota de "    ,"MV_CH1","C",009,0,0,"G","","","","","MV_PAR03","","","","","","","","","", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")
PutSX1(cPerg,"04","Nota at� "	,"Nota at� "	,"Nota at� "   ,"MV_CH1","C",009,0,0,"G","","","","","MV_PAR04","","","","","","","","","", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")
PutSX1(cPerg,"05","S�rie de "	,"S�rie de "	,"S�rie de "   ,"MV_CH1","C",003,0,0,"G","","","","","MV_PAR05","","","","","","","","","", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")
PutSX1(cPerg,"06","S�rie at� "	,"S�rie at� "	,"S�rie at� "  ,"MV_CH1","C",003,0,0,"G","","","","","MV_PAR06","","","","","","","","","", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")
PutSx1(cPerg,"07","Movimenta��o","Movimenta��o","Movimenta��o" ,"MV_CH1","N",001,0, ,"C","","","","","MV_PAR07","Entrada","Entrada","Entrada", "","Sa�da","Sa�da","Sa�da")
Return
