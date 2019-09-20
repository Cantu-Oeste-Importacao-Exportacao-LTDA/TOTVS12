#Include "PROTHEUS.CH"
#Include "RWMAKE.CH" 

/*__________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    �  SOCIO      � Autor � Renata C. Cala�a    � Data �08.03.13 ���
��+----------+------------------------------------------------------------���
���Descri��o � Fun��o para exibir os dados dos s�cios no Termo de         ���
���          � Confiss�o de D�vida gerado pela rotina de renegocia��o     ���
��+----------+------------------------------------------------------------���
��� Uso      � Cantu - Call Center                                        ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/  

User Function Socios ()       
       
Local aSocios   := {}
Local lSocios   := .T.                     
Local cString   := ''
Private cPerg1  := 'CANR002  '  

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName()) 

CriaSx1(cPerg1)
                  
While lSocios
                  
	If MsgYesNo ("Inserir novo s�cio?")
		Pergunte (cPerg1,.T.)                	
	    	     
		
		 cString += ", e seu s�cio(a), Sr(a) " + Alltrim(Upper(mv_par01)) + ", "   
		
		 cString += Alltrim(Lower(mv_par02)) 
		 
		 If mv_par03 == 1
			 cString += " casado (a) com " + Alltrim(Upper(mv_par04))
		 EndIf                                                                
		 cString += " residente(s) � " + Alltrim(Lower(mv_par05))		
		 cString += " no munic�pio de " + Alltrim(Lower(mv_par06)) + " "
		 
	Else
		lSocios := .F.	 
	EndIf        

End   

	AAdd (aSocios,{"csSocio", cString})           

//Alimenta as vari�veis com os dados dos parametros
_cSocio  := mv_par01
_cCPF    := mv_par02
_cNacion := mv_par03 
_cProfis := mv_par04   
_cCasado := mv_par05
_cIdesp  := mv_par06
_cCPFesp := mv_par07
_cNacesp := mv_par08
_cProfes := mv_par09 

Return (aSocios)
	 
Static Function CriaSx1(cPerg1)
	PutSx1(cPerg1,"01","Socio"          ,"Socio"         ,"Socio"         ,"mv_ch1","C",40,0,0,"G","",""   ,"","","mv_par01")
	//PutSx1(cPerg,"02","CPF"	           ,"CPF"           ,"CPF"	         ,"mv_ch2","C",15,0,0,"G","",""   ,"","","mv_par02")
	PutSx1(cPerg1,"02","Nacionalidade"  ,"Nacionalidade" ,"Nacionalidade" ,"mv_ch2","C",20,0,0,"G","",""   ,"","","mv_par02")
	//PutSx1(cPerg1,"04","Profiss�o"      ,"Profiss�o"     ,"Profiss�o"     ,"mv_ch4","C",20,0,0,"G","",""   ,"","","mv_par04") 
	PutSx1(cPerg1,"03","Casado"         ,"Casado"        ,"Casado"        ,"mv_ch3","C",20,0,0,"C","",""   ,"","","mv_par03","SIM","","","","NAO" )
	PutSx1(cPerg1,"04","Esposa"         ,"Esposa"        ,"Esposa"        ,"mv_ch4","C",40,0,0,"G","",""   ,"","","mv_par04")
	//PutSx1(cPerg1,"07","CPF"	           ,"CPF"	        ,"CPF"	         ,"mv_ch7","C",15,0,0,"G","",""   ,"","","mv_par07")
	//PutSx1(cPerg1,"05","Nacionalidade"  ,"Nacionalidade" ,"Nacionalidade" ,"mv_ch5","C",20,0,0,"G","",""   ,"","","mv_par05")
    //PutSx1(cPerg1,"09","Profiss�o"      ,"Profiss�o"     ,"Profiss�o"     ,"mv_ch9","C",20,0,0,"G","",""   ,"","","mv_par09")
    PutSx1(cPerg1,"05","End. Socio"     ,"End. Socio"    ,"End. Socio"    ,"mv_ch5","C",99,0,0,"G","",""   ,"","","mv_par05")  
    PutSx1(cPerg1,"06","Mun./UF"        ,"Mun./UF"       ,"End. Socio"    ,"mv_ch6","C",40,0,0,"G","",""   ,"","","mv_par06")  
    
Return
