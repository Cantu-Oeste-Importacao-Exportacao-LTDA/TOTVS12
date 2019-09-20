#Include "Rwmake.ch"
#Include "Topconn.ch"
#Include "Protheus.ch"
#Include "Tbiconn.ch"
 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �USORWMAKE �Autor  �Gustavo Lattmann    � Data �  06/23/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o com o objetivo de registrar o uso de fontes 		  ���
���          �customizados                                                ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Cantu                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function UsoRwMake(cUsrFunc,cFuncPai) 

Local cData 	:= DToS(Date()) + ' ' + Substr(Time(), 1, 5)
Local cEmpDef 	:= "40"
Local cFilDef 	:= "01"   

If SuperGetMv("MV_X_LOGCU", .F., .F.)
 	
 	if !ISINCALLSTACK("PCOA530")  //Rotina de Contingencia do PCO, se utilizar GetArea() ocorrem problemas na gravadao do campo ref. AKA_CHVCTG            
 		aArea 	:= GetArea() 
 	endif
 
	//������������������������������������������������������������������������������Ŀ
	//�Verifica se j� est� posicionado em uma empresa, sen�o define como padr�o 50/01�
	//��������������������������������������������������������������������������������

	If ValType(cEmpAnt) == "U"
		RpcClearEnv()
		RPCSetType(3)
		PREPARE ENVIRONMENT EMPRESA cEmpDef FILIAL cFilDef MODULO "FAT"
	EndIf
	
	//�������������������������������������������������������������������������������������������Ŀ
	//�Faz a grava��o dentro de uma Transaction pois caso ocorra erro estorna o que j� foi gravado�
	//��������������������������������������������������������������������������������������������
	
	  BEGIN TRANSACTION
		dbSelectArea("Z66")       
		
		//������������������������������������������������������
		//�Grava a fun��o chamada, a fun��o pai a data e a hora�
		//�����������������������������������������������������
	   		
	   		RecLock("Z66",.T.)
			Z66->Z66_USRFUN := cUsrFunc 		//Fun��o customizada que esta sendo monitorada
			Z66->Z66_FUNPAI	:= cFuncPai 		//Fun��o que foi chamada no Menu - Fun��o pai
			Z66->Z66_DATA	:= cData			//Data e hora do evento     
			Z66->Z66_USER	:= cUserName    	//Variavel p�blica que contem o nome do usu�rio
			Z66->Z66_EMP	:= SM0->M0_CODIGO	//Empresa atual
		
		//���������������������������������������Ŀ
		//�Libera a tabela e encerra a transaction�
		//�����������������������������������������
		Z66->(MsUnlock())
			  
	  END TRANSACTION

	if !ISINCALLSTACK("PCOA530") 
		RestArea(aArea)
	endif
		
EndIf



Return