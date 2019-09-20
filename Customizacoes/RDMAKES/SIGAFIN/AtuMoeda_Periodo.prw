// Colocar as linhas abaixo no MP8SRV.INI
// [ONSTART]
// jobs=Moedas
// ;Tempo em Segundos 86400=24 horas
// RefreshRate=86400  
//
// [Moedas]
// main=u_AtuMoeda
// Environment=???


#include 'protheus.ch'

User Function Old_AtuMoeda()

Private lAuto		:= .F.
Private dDataRef, dData, dDataCETIP
Private nValDolar, nValEuro, nValGuarani, nValPeso, nValCDI
Private nValReal	:= 1.000000
Private nValUfir	:= 1.064100
Private nN		    := 0
Private nS1, nS2, nS3
Private nI1, nI2, nI3
Private oDlg
Private nDiasPro    := 999
Private nDiasreg	:= 999
Private cServidor 
Private cEmp := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//Testa se esta sendo rodado do menu
If	Select('SX2') == 0
	RPCSetType( 3 )						//Não consome licensa de uso
	RpcSetEnv('01','01',,,,GetEnvServer(),{ "SM2" })
	cEmp:=1
	sleep( 5000 )						//Aguarda 5 segundos para que as jobs IPC subam.
	ConOut('Atualizando Moedas... '+Dtoc(DATE())+' - '+Time())
	lAuto := .T.
EndIf

If	( ! lAuto )
	LjMsgRun(OemToAnsi('Atualização On-line BCB e Cetip'),,{|| xExecMoeda()} )
Else
	xExecMoeda()
EndIf

If	( lAuto )
	RpcClearEnv()		   				//Libera o Environment
	ConOut('Moedas Atualizadas na Empresa 01 / Filial 01. '+Dtoc(DATE())+' - '+Time())
	If	Select('SX2') == 0
		RPCSetType( 3 )						//Não consome licensa de uso
		RpcSetEnv('02','01',,,,GetEnvServer(),{ "SM2" })
		cEmp:=2
		sleep( 5000 )						//Aguarda 5 segundos para que as jobs IPC subam.
		ConOut('Atualizando Moedas... '+Dtoc(DATE())+' - '+Time())
		xExecMoeda()
	Endif
	RpcClearEnv()		   				//Libera o Environment
	ConOut('Moedas Atualizadas na Empresa 02 / Filial 01. '+Dtoc(DATE())+' - '+Time())
EndIf

Return


Static Function xExecMoeda()
Local nPass, cFileBCB, cFileCETIP, cTextoBCB, cTextoCETIP, nLinhas, cLinha, cdata, cCompra, cVenda, J, K, L

For nPass := 5 to 0 step -1					//Refaz os ultimos 6 dias. O BCB não disponibiliza periodo maior de uma semana
	dDataRef := dDataBase - nPass
    
	//Feriados Bancário Fixo
	If ( Dtos(dDataRef) == STR(Year(Date()),4)+'0101' )	//Dia Mundial da Paz
		cFileBCB   := Dtos(dDataRef - 1)+'.csv'
		cFileCETIP := Dtos(dDataRef - 1)+'.txt'	
	ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'0421'	//Dia de Tradentes
		cFileBCB   := Dtos(dDataRef - 1)+'.csv'
		cFileCETIP := Dtos(dDataRef - 1)+'.txt'	
	ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'0501'	//Dia do Trabalho
		cFileBCB   := Dtos(dDataRef - 1)+'.csv'
		cFileCETIP := Dtos(dDataRef - 1)+'.txt'	
	ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'0907'	//Dia da Independencia
		cFileBCB   := Dtos(dDataRef - 1)+'.csv'
		cFileCETIP := Dtos(dDataRef - 1)+'.txt'	
	ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'1012'	//Dia da N. Sra. Aparecida
		cFileBCB   := Dtos(dDataRef - 1)+'.csv'
		cFileCETIP := Dtos(dDataRef - 1)+'.txt'	
	ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'1102'	//Dia de Finados
		cFileBCB   := Dtos(dDataRef - 1)+'.csv'
		cFileCETIP := Dtos(dDataRef - 1)+'.txt'	
	ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'1115'	//Dia da Proclamação da Republica
		cFileBCB   := Dtos(dDataRef - 1)+'.csv'
		cFileCETIP := Dtos(dDataRef - 1)+'.txt'	
	ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'1225'	//Natal
		cFileBCB   := Dtos(dDataRef - 1)+'.csv'
		cFileCETIP := Dtos(dDataRef - 1)+'.txt'	
	ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'1231'	//Dia sem Expediente Bancário
		cFileBCB   := Dtos(dDataRef - 1)+'.csv'		
		cFileCETIP := Dtos(dDataRef - 1)+'.txt'	
/*	//Feriado Bancário Variável 2007. Rever Anualmente
	ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'0219'	//Segunda de Carnaval
		cFileBCB   := Dtos(dDataRef - 1)+'.csv'		
		cFileCETIP := Dtos(dDataRef - 1)+'.txt'	
	ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'0220'	//Terça de Carnaval
		cFileBCB   := Dtos(dDataRef - 1)+'.csv'		
		cFileCETIP := Dtos(dDataRef - 1)+'.txt'	 */
	ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'0406'	//Sexta-Feira da Paixão
		cFileCETIP := Dtos(dDataRef - 1)+'.txt'	
		cFileBCB   := Dtos(dDataRef - 1)+'.csv'		
	ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'0607'	//Corpus Christi
		cFileBCB   := Dtos(dDataRef - 1)+'.csv'		
		cFileCETIP := Dtos(dDataRef - 1)+'.txt'	
	//Finais de Semana
	ElseIf	Dow(dDataRef) == 1				//Se for domingo
		cFileBCB   := Dtos(dDataRef - 2)+'.csv'
		cFileCETIP := Dtos(dDataRef - 2)+'.txt'	
	ElseIf	Dow(dDataRef) == 7  				//Se for sabado
		cFileCETIP := Dtos(dDataRef - 1)+'.txt'	
		cFileBCB   := Dtos(dDataRef - 1)+'.csv'
	//Dias Normais
	Else							//Se for dia normal
		cFileBCB   := Dtos(dDataRef)+'.csv'	
		cFileCETIP := Dtos(dDataRef)+'.txt'	
	EndIf
	
	cTextoBCB    := HttpGet('http://www5.bcb.gov.br/Download/'+cFileBCB)
    cServidor := 'ftp.cetip.com.br'
	FTPDisconnect()
	If FTPConnect(cServidor) //,24,"Anonymous","IEUser@")
		If FTPDirChange('/MediaCDI')
			If FTPDOWNLOAD('\system\moeda\'+cFileCETIP,cFileCETIP)
				cArqCETIP  := '\system\moeda\'+cFileCETIP
				nHdl       := FOpen(cArqCETIP)
				If (nHdl <> -1)
					cTextoCETIP := Space(9)
					FRead(nHdl,@cTextoCETIP,9)
				Endif
			EndIf
		Endif
	Endif
	If	( lAuto )
		ConOut('DownLoading from BCB '+cFileBCB+ ' and from CETIP '+cFileCETIP+' In '+Dtoc(DATE()))
	EndIf

	If ! Empty(cTextoBCB)
		nLinhas := MLCount(cTextoBCB, 81)
		For J	:= 1 to nLinhas
			cLinha	:= Memoline(cTextoBCB,81,j)
			cData  	:= Substr(cLinha,1,10)
			cCompra := StrTran(Substr(cLinha,22,14),',','.')//Caso a empresa use o Valor de Compra nas linhas abaixo substitua por esta variável
			cVenda  := StrTran(Substr(cLinha,37,14),',','.')//Para conversão interna nas empresas normalmente usa-se Valor de Venda
			If	( Substr(cLinha,12,3)=='220' )	//Seleciona o Valor do Dolar
				dData   := Ctod(cData)
 				nValDolar	:= Val(cVenda)
			EndIf

			If	( Substr(cLinha,12,3)=='450' )	//Seleciona o Valor do Guarani
				dData   := Ctod(cData)
 				nValGuarani := Val(cVenda)
			EndIf
			
			If	( Substr(cLinha,12,3)=='978' )	//Seleciona o Valor do Euro
				dData   := Ctod(cData)
 				nValEuro	:= Val(cVenda)
			EndIf

			If	( Substr(cLinha,12,3)=='706' )	//Seleciona o Valor do Peso
				dData   := Ctod(cData)
 				nValPeso    := Val(cVenda)
			EndIf
		Next
	Endif     
	If ! Empty(cTextoCETIP)
			dDataCETIP := stod(Substr(cFileCETIP,1,8))
			nValCDI    := Val(Substr(cTextoCETIP,5,3)+'.'+Substr(cTextoCETIP,8,2))//Para conversão interna nas empresas normalmente usa-se Valor de Venda
	Endif     
	GravaDados()                            		//Grava Dados do Período selecionado em "J"
Next
          
If	( Dow(dData) == 6 )					//Se for sexta
	For K := 1 to 2
		dData ++
		GravaDados()	      				//Grava os Valores de Sabado e Domingo, Para calculo da Regressão
	Next                                                                                              
EndIf	

Return


Static Function GravaDados()

if (dData <> nil .and. dData <> stod("  /  /  "))
	DbSelectArea("SM2")						//Grava Moedas
	SM2->(DbSetorder(1))  	
	If SM2->(DbSeek(dData))
		Reclock('SM2',.F.)
		M2_MOEDA1	:= IIF(M2_MOEDA1==0,nValReal,M2_MOEDA1)		//Real
		M2_MOEDA2	:= IIF(M2_MOEDA2==0,nValDolar,M2_MOEDA2)	//Dolar
		M2_MOEDA3	:= IIF(M2_MOEDA3==0,nValUfir,M2_MOEDA3)		//Ufir
		M2_MOEDA4	:= IIF(cEmp==1,IIF(M2_MOEDA4==0,nValEuro,M2_MOEDA4),IIF(cEmp==2,IIF(M2_MOEDA4==0,nValPeso,M2_MOEDA4),M2_MOEDA4)) //Empresa01-Euro e Empresa02-Peso
		M2_MOEDA5	:= IIF(M2_MOEDA5==0,nValGuarani,M2_MOEDA5)	//Guarani
		if cEmp == 1
			M2_MOEDA6	:= IIF(M2_MOEDA6==0,nValPeso,M2_MOEDA6)		//Peso
			if(dDataCETIP == dData)
				M2_MOEDA7 := IIF(M2_MOEDA7==0,nValCDI,M2_MOEDA7)	//CDI
			Endif
		Elseif cEmp == 2
			if(dDataCETIP == dData)
				M2_MOEDA6 := IIF(M2_MOEDA6==0,nValCDI,M2_MOEDA6)	//CDI
			Endif
		Endif
	Else
		Reclock('SM2',.T.)
		SM2->M2_DATA	:= dData
		SM2->M2_MOEDA1	:= nValReal				//Real
		SM2->M2_MOEDA2	:= nValDolar			//Dolar
		SM2->M2_MOEDA3	:= nValUfir				//Ufir
		SM2->M2_MOEDA4	:= IIF(cEmp==1,nValEuro,IIF(cEmp==2,nValPeso,0))
		SM2->M2_MOEDA5	:= nValGuarani			//Guarani
		if cEmp == 1
			SM2->M2_MOEDA6	:= nValPeso 			//Peso
			if(dDataCETIP == dData)
				M2_MOEDA7 := IIF(M2_MOEDA7==0,nValCDI,M2_MOEDA7)	//CDI
			Endif
		Elseif cEmp = 2
			if(dDataCETIP == dData)
				M2_MOEDA6 := IIF(M2_MOEDA6==0,nValCDI,M2_MOEDA6)	//CDI
			Endif
		Endif
	EndIf
	SM2->M2_INFORM	:= "S"
	MsUnlock('SM2')
Endif
if (dData == nil .OR. dData == stod("  /  /  ")) .and. (dDataCETIP <> nil)
	DbSelectArea("SM2")						//Grava Moedas
	SM2->(DbSetorder(1))
	If SM2->(DbSeek(dDataCETIP))
		Reclock('SM2',.F.)
		SM2->M2_MOEDA1	:= nValReal				        //Real
		SM2->M2_MOEDA3	:= nValUfir				        //Ufir
		if cEmp == 1
				M2_MOEDA7 := IIF(M2_MOEDA7==0,nValCDI,M2_MOEDA7)	//CDI
		Elseif cEmp == 2
				M2_MOEDA6 := IIF(M2_MOEDA6==0,nValCDI,M2_MOEDA6)	//CDI
		Endif
	Else
		Reclock('SM2',.T.)
		SM2->M2_DATA	:= dDataCETIP
		SM2->M2_MOEDA1	:= nValReal				        //Real
		SM2->M2_MOEDA3	:= nValUfir				        //Ufir
		if cEmp == 1
			SM2->M2_MOEDA7	:= IIF(nValCDI<>0,nValCDI,0)  	//CDI
		Elseif cEmp == 2
			SM2->M2_MOEDA6	:= IIF(nValCDI<>0,nValCDI,0)  	//CDI
		Endif
	EndIf
	SM2->M2_INFORM	:= "S"
	MsUnlock('SM2')
Endif

Return