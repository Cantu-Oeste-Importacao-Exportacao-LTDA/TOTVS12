#INCLUDE "Protheus.CH"
#INCLUDE "IMPRESH.CH"
#INCLUDE "MSOLE.CH"
#DEFINE   nColMax	2264
#DEFINE   nLinMax  2900
/*
��������������������������������������������������������������������������������������
��������������������������������������������������������������������������������������
����������������������������������������������������������������������������������ͻ��
���Programa  �IMPRESW   �Autor  �Wagner Montenegro            � Data �  15/12/2010 ���
����������������������������������������������������������������������������������͹��
���Desc.     �Impressao da Rescisao em modo Grafico Homolognet                     ���
���          �                                                                     ���
����������������������������������������������������������������������������������͹��
���Uso       � AP6                                                                 ���
����������������������������������������������������������������������������������ͼ��  
���                ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.               ���
����������������������������������������������������������������������������������Ĵ��
���Programador � Data     � BOPS/FNC  �  Motivo da Alteracao                       ���
����������������������������������������������������������������������������������Ĵ��
��|            �          �           �                                            |��
���Mauricio MR �07/02/2011�002412/2011�Ajuste para forcar a impressao do campo 71  ���
���Mauricio MR �16/02/2011�002361/2011�Ajuste no laco de impressao do campo 95 - Ou���
���            �          �           �tras verbas.								   ���
���Mauricio MR �16/02/2011�003385/2011�Ajuste p/ obter adequadamente remuneracao do���
���            �          �           �mes anterior ao afastamento (campo 23).     ���
���Kelly Soares�12/04/2011�006161/2011�Alteracoes para impressao de ferias por     ���
���            �          �           �periodos aquisitivos - homolognet.          ���
���            �          �           �Horas extras ordenadas por percentual.      ���
���Kelly Soares�17/05/2011�006161/2011�Ajuste no campo 27-Cod Afastamento para pagi���
���            �          �           �nar codigo de saque. Quando nao houver codi-���
���            �          �           �go valido, pagina NAO.                      ���
���Mauricio MR �22/06/2011�015039/2011�Ajuste para descontar as verbas de descontos���
���            �          �           �no saldo de salario qdo solicitado.		   ���
���Renata Elena�04/07/2011�013875/2011�Ajuste na paginacao da qtd de horas do      ���
���            �          �           �adicional noturno p\paginar com 2 decimais  ���
���Mauricio MR �27/07/2011�016361/2011�Ajuste p/ iniciar a numeracao dos descontos ���
���            �          �           �denominados "Outros" em '115'.			   ���
���            �          �017899/2011�Ajuste p/ deduzir do saldo de salario dedu- ���
���            �          �           �coes determinadas na parametrizacao da roti-���
���            �          �           �na , mesmo que o total de deducoes seja i-  ���
���            �          �           �gual ao saldo de salario.				   ���
���            �          �           �Realizados ajustes para considerar a confi- ��� 
���            �          �           �gura��o do parametro que determina a impres-��� 
���            �          �           �s�o da data de homologa��o no campo 154 do  ��� 
���            �          �           �TRCT.                                       ��� 
���Renata Elena�25/08/2011�022030/2011�Ajuste na paginacao do item 66.ferias inde- ���
���            �          �           �nizadas, mesmo que funcionario nao tenha.   ���
���Allyson M   �09/09/2011�021625/2011�Ajuste no desconto de valores no campo 50.  ���
���            �          �           �Caso o valor desconto ultrapasse o saldo do ���
���            �          �           �salario, zera o saldo no campo 50 e exibe   ���
���            �          �           �as verbas em Deducoes com valor descontado. ���
���Allyson M   �16/09/2011�024155/2011�Ajuste no desconto de valores no campo 50.  ���
���            �          �           �Caso as verbas informadas sejam em horas,   ���
���            �          �           �efetua a conversao em dias, conforme horas/ ���
���            �          �           �dia do cadastro do funcionario. 			   ���
���Allyson M   �06/12/2011�031461/2011�Ajuste na somatoria dos avos das ferias pro-���
���            �          �     TEDGA4�porcionais e indenizadas p/ considerar os   ���
���            �          �           �das medias, quando nao ha o id de ferias.   ���
���Allyson M   �08/12/2011�031755/2011�Ajuste na impressao do campo 66 - Ferias    ���
���            �          �     TEDRWQ�vencidas p/ fazer o controle nos dias venci-���
���            �          �           �dos e nao proporcionais.      			   ���
���Allyson M   �27/12/2011�033415/2011�Ajuste na somatoria dos avos do 13o. propor-���
���            �          �     TEGCPO�cionais p/ considerar os avos das medias    ���
���            �          �           �quando nao ha o id de 13o.   			   ���
���Allyson M   �06/01/2012�000513/2012�Ajustes p/ aumentar o tamanho do fonte uti- ���
���            �          �     TEHQDB�lizado p/ melhor legibilidade.    		   ���
���Leandro Dr. �02/02/2012�002790/2012�Inclusao do Termo de Quitacao de Rescisao de���
���            �          �     TELSO6�acordo com Portaria 2.685 do MTE. 		   ���
���Leandro Dr. �04/04/2012�           �Inclusao do Termo de Homologacao de Rescisao���
���            �          �     TETNUX�de acordo com Portaria 2685 do MTE.   	   ���
���Mauricio MR �11/04/2012�008451/2012�Ajuste para recuperar o salario anterior ao ���
��|            |          |TETIB0	  |afastamento (campo 23 do TRCT) . 		   ���
���Leandro Dr. �20/04/2012�           �Ajuste para no codigo de afastamento conside���
���            �          �     TEWGER�rar o cadastro do parametro 32.       	   ���
���Leandro Dr. �21/05/2012�           �Ajuste para suprimir item "Formalizacao da  ���
���            �          �     TFAOA6�rescisao" do TRCT.                    	   ���
���Gustavo M.  �25/06/2012�           �Ajuste para adicionar a qtde de dias de av  ���
���            �          �     TFEUHX�previo - campo 69 - Legislacao.         	   ���
���Allyson M.  �23/07/2012�           �Ajustes diversos para adequacao da portaria ���
���            �          �     TFJLCZ�MTE 1.057/2012.   					       ���
���Allyson M.  �01/08/2012�           �Adicao da referencia da tabela SRA no campo ���
���            �          �     TFMTAK�RA_VIEMRAI.   					           ���
���Luis Artuso �02/08/2012�019467/2012�Ajuste na impressao do Termo de rescisao do ���
���            �          �     TFMJXN�Grupo 56. Impressao fora de ordem.		   ���
���Luis Artuso �08/08/2012�020024/2012�Ajuste na impressao do Termo de rescisao -  ���
���            �          �     TFNKOR�grupo 69, verificacao de dias de aviso pre- ���
���            �          �     	  �vio.                                        ���
���Renata Elena�19/10/2012�     TFZJCS�Ajuste para deixar o campo 99 fixo.		   ���
���            �          �     	  �Ajuste para paginar % nos campos 53 e 54    ���
���            �          �     	  �(Insalubridade e Periculosidade)            ���
���Renata Elena�23/10/2012�     TFZJCS�Ajuste na variavel n_x1 para caso retornar  ���
���            �          �     	  �em branco ou nula, iniciliza-la com zero    ���
���Allyson M.  �25/10/2012�           �Ajustes nos posicionamento dos campos e     ���
���            �          �     TG9241�ajuste no tamanho dos fontes utilizados.    ���  
���Marcia Moura�06/11/2012�     TFYWEQ�Ajuste na impressao da linha 22- mot afast  ���    
���Marcia Moura�08/11/2012�     TGCADP�Impressao do campo 27 corretamente          ���    
���Allyson M.  �05/12/2012�     TGFVVG�Ajuste no titulo dos campos 56 e 64.		   ���    
���Marcia Moura�14/11/2012�     TGDANL�O campo 71 estava sem a palavra inden,e ocpo���              
���            �          �     	  �103 - Av. Previo, sem a qtde dias            ��
���            �          �     	  �Somente o segundo erro ocorreu na minha base ��
���            �          �     	  �e foi corrigido                              �� 
���Marcia Moura�11/12/2012�     TFZHOU�O campo 31 n�o deve ser preenchido para os  ���             
���            �          �     	  �funcionarios rurais.                         ��
���            �          �     	  �Conforme Portaria 1057 de 09/07/2012         ��
���            �          �     	  �Anexo VIII. para todos os doctos             ��   
���Gustavo M.  �07/02/2013�     TGQKMO�Ajuste no layout do TRCT.				   ���
���Gustavo M.  �08/03/2013�     TGRMIT�Ajuste para hachurar conforme item 2. da    ���
���            �          �     	  �Portaria 1057.       					   ���  
���Allyson M   �25/03/2013|     TGXVDG|Ajuste na validacao do tempo de empresa p/  ���
���            �          |      	  |geracao do termo de homologacao/quitacao.   ���
���            �          |           |Ajuste na quebra de pagina, quando ha muitas���
���            �       	  |           |verbas rescisorias. 						   ���
���Luis Artuso �02/05/2013|     THAOGT|Ajuste na exibicao do campo 31. Exibir o    ���
���            �          |      	  |codigo da entidade sindical sem alteracoes  ���
���            �          |           |caso haja caracteres especiais.             ���
���Gustavo M.  �03/05/2013�     THAMOD�Ajuste para demonstrar corretamente o valor ���
���            �          �     	  �do campo 50, caso descontado faltas.		   ��� 
���Allyson M   �06/05/2013|     THBXNT|Ajuste na quebra de pagina, quando ha muitas���
���            �          |      	  |verbas rescisorias; o cabecalho da rescisao ���
���            �          |      	  |sera gerado novamente, se assim configurado ���
���            �          |      	  |na parametrizacao da impressao.			   ���
���Allyson M   �24/05/2013|     THHNDU|Impressao do Id 430 no campo 58 (DSR)	   ���
���Gustavo M   �06/06/2013|     THH683|Ajuste para nao sobrepor o campo 116.	   ���
���Gustavo M   �20/06/2013|     THHHWA|Ajustes na fonte, margem e verbas nao obrig.���
���			   �		  |     	  |com valores zerados.						   ���
���Allyson M   �24/06/2013|     THCYYD|Ajuste na validacao do tempo trabalhado, p/ ���
���            �          �      	  |geracao do termo de quitacao/homologacao.   ���
���Fabio G.    �28/06/2013�		THLAEB�Ajuste p/ identificar em qual campo foi inf.���
���       	   �		  �  		  �numero do endereco RA_ENDEREC ou RA_NUMENDE.���
���Gustavo M.  �04/07/2013�		THKB51�Ajuste na centralizacao e letras maiusculas.���
�����������������������������������������������������������������������������������ٱ� 
��������������������������������������������������������������������������������������
������������������������������������������������������������������������������������*/              
User Function IMPRESH()

//����������������������������������������������������������Ŀ
//�Define Variaveis PRIVATE utilizadas para Impressao Grafica�
//������������������������������������������������������������
Private nPos		:= 0				//LINHA DE IMPRESSAO DO RELATORIO GRAFICO
Private nTot		:= 0
Private nNumMax		:= 18			//Numero maximo de verbas impressas no Detalhe da rescisao 
Private nImprime	:= 1 				//Variavel Auxiliar 
Private nImpre		:= 1 
Private CONTFL		:= 1				//CONTA PAGINA

//������������������������������������������������������������������Ŀ
//�Objetos para Impressao Grafica - Declaracao das Fontes Utilizadas.�
//��������������������������������������������������������������������
Private oFont08, oFont09, oFont09n, oFont10, oFont13n  

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

oFont08	:= TFont():New("Arial",11,11,,.F.,,,,.T.,.F.,)
oFont08n:= TFont():New("Arial",11,11,,.T.,,,,.T.,.F.,)
oFont09	:= TFont():New("Arial",12,12,,.F.,,,,.T.,.F.)
oFont09n:= TFont():New("Arial",12,12,,.T.,,,,.T.,.F.)    //Negrito//
oFont10	:= TFont():New("Arial",12,12,,.F.,,,,.T.,.F.) 
oFont12n:= TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)		//Negrito//
oFont13n:= TFont():New("Arial",17,17,,.T.,,,,.T.,.F.)    //Negrito// 


nEpoca:= SET(5,1910)
//-- MUDAR ANO PARA 4 DIGITOS 
SET CENTURY ON 

fHomolog()

Set(5,nEpoca)
If nTdata > 8
	SET CENTURY ON
Else
	SET CENTURY OFF
Endif
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fHomolog� Autor � Wagner Montenegro       � Data � 15.12.10 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao Formulario Homolonet                             ���
�������������������������������������������������������������������������Ĵ��
���Uso       � RdMake                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fHomolog()

Local aString	:= {} 
Local aAreaRCE	:= {} 
Local nBloco1	:=360
Local nX
Local aAreaSRD
Local aAreaSRV
Local nDescAux	:= 0
Local nDescRes	:= 0
Local nFalta	:= 0
Local nOrderSRD
Local nY,nW
Local nCkHomV:=0
Local n_XX 
Local n_X
Local n_Y
Local n_XX1           
Local n_X1
Local n_X2
Local n_Y1,nFor,nT
Local aPreSelect:={}
Local cPreSelect:=MV_PAR32
Local nAchou:=0
Local cD1:=""
Local cD2:=""
Local aPer	:= {}
Local cOrgao:=""  
Local nCont   
Local nPosFixa := 0
Local cVrbFixa := ""
Local cString      
Local cCompet := GetMv( "MV_FOLMES",,Space(06) ) 
Local cDSRSalV	:= LoadCodDSR(.F.,SRA->RA_FILIAL)    
Local lTemVerba := .F.
Local lHomolog		:= .F.
Local aTab25  := {}
Local nPenunSal := 0.00
Local cItem			:= ''
Local cTpFalta		:= ""
Local lTrabRural	:= .F.
Local cVal69		:= ""
Local nValLin		:= 1

Private aCpoForm:={}
Private aCpoFor1:={}
Private aCpoFormD:={}
Private cCateg	:= fCateg(0)
Private cPercSRV:=""
Private aCpoExtra:={}
Private lQuebraD:=.F.
Private lQuebraP:=.F.
Private oBrush1
Private oBrush2		
Private nBoxIni	:=0
Private nCl01a	:=120
Private nCl01b	:=634
Private nCl02a	:=834
Private nCl02b	:=1348
Private nCl03a	:=1548
Private nCl03b	:=2062
Private nL		:=0 
Private nPD 	:=40
Private nPT 	:=05
Private nTamL	:=10
Private nAddL	:=85 
Private nTit	:=60 
Private nSubT	:=42
Private nTip	:=151
Private nXCol 
Private cCodAfa := ""
Private nPagina  := 1
Static aCodFol:={}  

fp_CodFol( @aCodFol , xFilial("SRV"), .F. ) 

oPrint:StartPage() 			//Inicia uma nova pagina  

Aadd(aCpoForm,{"72",2,"Percentagem","006","",""})
Aadd(aCpoForm,{"73",2,"Pr�mios","008","",""})
Aadd(aCpoForm,{"74",2,"Viagens","010","",""})
Aadd(aCpoForm,{"75",2,"Sobreaviso","015","",""})
Aadd(aCpoForm,{"76",2,"Prontid�o","016","",""})
Aadd(aCpoForm,{"77",2,"Adicional por tempo de servi�o","018","",""})
Aadd(aCpoForm,{"78",2,"Adicional por Transfer�ncia de Localidade de Trabalho","019","",""})
Aadd(aCpoForm,{"79",2,"Sal�rio Fam�lia excedente ao Valor Legal","020","",""})
Aadd(aCpoForm,{"80",2,"Abono/Gratifica��o de F�rias Excedente 20 dias de sal�rio","021","",""})
Aadd(aCpoForm,{"81",2,"Valor global di�rias para viagem Excedente 50% sal�rio","022","",""})
Aadd(aCpoForm,{"82",2,"Ajuda de Custo art. 470/CLT","023","",""})
Aadd(aCpoForm,{"83",2,"Etapas mar�timos","024","",""})
Aadd(aCpoForm,{"84",2,"Licen�a Pr�mio indenizada","025","",""})
Aadd(aCpoForm,{"85",2,"Quebra de Caixa","026","",""})
Aadd(aCpoForm,{"86",2,"PLR","027","",""})
Aadd(aCpoForm,{"87",2,"Indeniza��o a T�tulo de Incentivo � demiss�o","028","",""})
Aadd(aCpoForm,{"88",2,"Bolsa Aprendizagem","029","",""})
Aadd(aCpoForm,{"89",2,"Abonos Desvinculados do Sal�rio","030","",""})
Aadd(aCpoForm,{"90",2,"Ganhos Eventuais Desvinculados do Sal�rio","031","",""})
Aadd(aCpoForm,{"91",2,"Reembolso Creche","032","",""})
Aadd(aCpoForm,{"92",2,"Reembolso Bab�","033","",""})
Aadd(aCpoForm,{"93",2,"Gratifica��o Semestral","034","",""})

Aadd(aCpoFor1,{"96",1,"Indeniza��o art 9� Lei 7238/84","178","",""})
Aadd(aCpoFor1,{"98",2,"Multa art. 476-A & 5� da CLT","036","",""})

Aadd(aCpoFormD,{"115",1,"Outros descontos n�o previstos acima","","",""})

GPER140Sum(1,,,.T.)
GPER140Sum(2,,,.T.)
For nY:=1 to Len(aCpoForm)
	If Val(Strtran(StrTran(aCpoForm[nY,5],".",""),",","."))>0 
		nCkHomV++
	Endif
Next             
For nY:=1 to Len(aCpoFor1)
	If Val(Strtran(StrTran(aCpoFor1[nY,5],".",""),",","."))>0 
		nCkHomV++
	Endif
Next
For nW:= 1 to Len(aHomV)
	If aHomV[nW,7]==0
	   nCkHomV++
	Endif
Next	   
If nCkHomV>=3
	nTamL:=nTamL+Int(nCkHomV/3)	
Endif                 

fRetTab(@aTab25,"S025",,,,,.T.)

//Imprime o cabecalho da rescisao (Campos 01 a 32)
fCabec()

oPrint:say (nL+nSubT,nCl01a+30,STR0036, oFont09n) //-- "VERBAS RESCIS�RIAS"

nL:=nL+nSubT
nBoxIni:=nL      

// -------------------------------------------------------------------------------------------------------
//  Cabecalho de Verbas Rescisorias
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+02+nSubT,nCl01a+30		,STR0037	, oFont09n) //"RUBRICAS"
oPrint:say (nL+02+nSubT,nCl01b+30		,STR0038	, oFont09n) //"VALOR"
oPrint:say (nL+02+nSubT,nCl02a+30		,STR0037	, oFont09n) //"RUBRICAS"
oPrint:say (nL+02+nSubT,nCl02b+30		,STR0038	, oFont09n) //"VALOR"
oPrint:say (nL+02+nSubT,nCl03a+30		,STR0037	, oFont09n) //"RUBRICAS"
oPrint:say (nL+02+nSubT,nCl03b+30		,STR0038	, oFont09n) //"VALOR" 
nL+=nSubT	
oPrint:line(nL,135,nL,nColMax )

// -------------------------------------------------------------------------------------------------------
//  |50| Saldo de dias trabalhados 
// -------------------------------------------------------------------------------------------------------
n_Y:=0
n_Y1:=0
n_X:= GPER140Sum(1,1,"048/112",,,1)    //Considerar aviso previo trabalhado no mes como saldo de salario
n_X1:=GPER140Sum(1,1,"048/112",,2,1)                     
n_X2:=GPER140Sum(2,1,"113",,2,1)

If n_X1 == Nil .or. empty(n_X1)
	n_X1 := 0
EndIf

If n_X2 == Nil .or. empty(n_X2)
	n_X2 := 0
EndIf

If !(Empty(Alltrim(cPreSelect)))
   	For nFor := 1 To Len( Alltrim(cPreSelect) ) Step 3
		aAdd( aPreSelect , SubStr( cPreSelect , nFor , 3 ) )
	Next nFor
	For nY:= 1 to Len(aPreSelect)
		For nT:= 1 to Len(aHomD)
			If aHomD[nT,4]==aPreSelect[nY]
				//-- Verifica se o tipo de lancamento da verba e' em horas ou em dias
				cTpFalta := PosSrv(aHomD[nT,4],xFilial("SRV", SRA->RA_FILIAL),"RV_TIPO")
				//-- Se Verba e' em horas, converte as horas de falta em dias de acordo com as horas/mes do cadastro do funcionario
				If cTpFalta == "H"
					nFalta := Int(aHomD[nT,2]/Round(SRA->RA_HRSMES/30,2))
					//-- Se a falta for menor do que um dia, nao sera descontada do campo 50
					If nFalta >= 1
						n_Y	+= aHomD[nT,3]
						n_Y1+= nFalta
						aHomD[nT,7]	:= 2
					EndIf
			   	//-- Se Verba e' em Dias, utiliza os valores diretamente
			   	ElseIf cTpFalta == "D"
					n_Y	+= aHomD[nT,3]
					n_Y1+= aHomD[nT,2]
					aHomD[nT,7]	:= 2
			   	EndIf
			Endif
		Next
	Next
Else
   n_Y:=0
   n_Y1:=0
Endif	
n_XX := n_X - n_Y   //Valor
n_XX1:= n_X1 - n_Y1 //Dias
nL+=37
If n_X >= n_Y .and. n_X1 >= n_Y1 
    //-- Retira o valor anteriormente somado ao Provento
    nProv-= n_X
    //-- Recompoe o valor de provento atrav�s do valor liquido do saldo de salario
    nProv+= n_XX
    
    //-- Recompoe o valor do desconto, deduzindo as faltas (ou demais verbas correspondentes) utilizadas
    //-- no calculo do saldo de salario liquido
    nDesc-= n_Y
Else
    //-- Retira o valor anteriormente somado ao Provento
    nProv -= n_X
    //-- Recompoe o valor do desconto, deduzindo as faltas (ou demais verbas correspondentes) utilizadas
    //-- no calculo do saldo de salario liquido
    nDesc 		-= n_X
	//-- Guarda o valor maximo do desconto do saldo
    nDescRes 	:= n_X
	//-- Guarda a diferenca entre os descontos e saldo de salario
	nDescAux	:= Abs(n_XX)
	For nY := 1 To Len(aPreSelect)
		For nT := 1 To Len(aHomD)
			If nDescAux > 0 .And. aHomD[nT,4] == aPreSelect[nY]
				//-- Habilita a exibicao da verba em deducoes
				aHomD[nT,7] := 0
				//-- Verifica se ha valor a descontar e se o valor de desconto da verba eh maior ao desconto
				If aHomD[nT,3] >= nDescRes
					//-- Desconta o valor da verba
					aHomD[nT,3] -= nDescRes
					//-- Desconta o valor descontado do total a ser descontado
					nDescAux	-= nDescRes
					//-- Zera o valor a descontar
					nDescRes 	:= 0
				ElseIf nDescRes > 0 
					//-- Guarda o valor que necessita ser descontado
					nDescRes := ( nDescRes - aHomD[nT,3] )
					//-- Zera o valor a descontar 
					aHomD[nT,3] -= aHomD[nT,3]
					//-- Desabilita a exibicao da verba em deducoes
					aHomD[nT,7] := 2
					//-- Desconta o valor descontado do total a ser descontado
					nDescAux	-= nDescRes
				EndIf
			EndIf
		Next nT
	Next nY
EndIf
oPrint:say (nL+nPT+10,nCl01a+30		,STR0039 + If(n_XX1<0,"00",StrZero(n_XX1,2)) + STR0040, oFont08) // 50 Saldo de 00/dias Salario 
oPrint:say (nL+nPD+10,nCl01a+30		,STR0154 + StrZero(n_Y1,2)+STR0041, oFont08)                
oPrint:say (nL+nPD+10,nCl01b+10	,TransForm(n_XX,"@E 99,999,999.99"), oFont10) 

// -------------------------------------------------------------------------------------------------------
//  |51| Comissoes
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT+10,nCl02a+30	,STR0045, oFont08)  //"51 Comissoes"
oPrint:say (nL+nPD+10,nCl02b+10	,GPER140Sum(1,2,"007"), oFont10) 

// -------------------------------------------------------------------------------------------------------
//  |52| Gratificacoes
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT+10,nCl03a+30	,STR0046, oFont08)  //"52 Gratifica��o"
oPrint:say (nL+nPD+10,nCl03b+10	,GPER140Sum(1,2,"017"), oFont10) 

nL+=nAddL+10
oPrint:line(nL,135,nL,nColMax )

// -------------------------------------------------------------------------------------------------------
//  |53| Insalubridade
// -------------------------------------------------------------------------------------------------------
cPercSRV:="" 
oPrint:say (nL+nPT,nCl01a+30		,STR0047 +  TransForm(GPER140Sum(1,2,"013",,2,1),"@E 999.99")  , oFont08)  //"53 Adicional de Insalubridade"
oPrint:say (nL+nPD,nCl01a+30	,cPercSRV+" %", oFont08) 
oPrint:say (nL+nPD,nCl01b+10	,GPER140Sum(1,2,"013"), oFont10) 

// -------------------------------------------------------------------------------------------------------
//  |54| Periculosidade
// -------------------------------------------------------------------------------------------------------
cPercSRV:="" 
oPrint:say (nL+nPT,nCl02a+30	,STR0048 +  TransForm(GPER140Sum(1,2,"014",,2,1),"@E 999.99"), oFont08)  //"54 Adicional de Periculosidade"
oPrint:say (nL+nPD,nCl02a+30	,cPercSRV+" %", oFont08) 
oPrint:say (nL+nPD,nCl02b+10	,GPER140Sum(1,2,"014"), oFont10)

// -------------------------------------------------------------------------------------------------------
//  |55| Adicional Noturno
// -------------------------------------------------------------------------------------------------------
cPercSRV:="" 
oPrint:say (nL+nPT,nCl03a+30	,STR0049 + TransForm(GPER140Sum(1,2,"012",,2,1),"@E 999.99") + STR0050, oFont08) // "55 Adicional Noturno XX horas"
oPrint:say (nL+nPD,nCl03a+30	,cPercSRV+" %", oFont08) 
oPrint:say (nL+nPD,nCl03b+10	,GPER140Sum(1,2,"012"), oFont10) 
  
nL+=nAddL+05
oPrint:line(nL,135,nL,nColMax )

// -------------------------------------------------------------------------------------------------------
//  |56| Horas Extras
// -------------------------------------------------------------------------------------------------------

aAreaSRV:=GetArea()
SRV->(DbSetOrder(RETORDER("SRV","RV_FILIAL+RV_HOMOLOG+STR(RV_PERC,7,3)+RV_COD")))
SRV->(DbSeek(xFilial("SRV")+"004")) //004 = Cod.Homolognet p/ H.Extra
While !SRV->(EOF()) .and. SRV->RV_HOMOLOG=="004"
	Aadd(aCpoExtra,{"56.",2,SRV->RV_DESC,(SRV->RV_PERC-100),0,0,SRV->RV_COD,""})
	SRV->(DbSkip())
Enddo 
RestArea(aAreaSRV)
aSort(aCpoExtra,,,{|x,y| x[7] < y[7]}) //ordenado por codigo da verba

nCont := 1
For nY := 1 to Len(aCpoExtra)
	If ( nAchou := Ascan(aHomV,{|x| x[4]==aCpoExtra[nY,7]}) ) > 0	.and. aHomV[nAchou,3] > 0
		aCpoExtra[nY,5] += aHomV[nAchou,2]
		aCpoExtra[nY,6] += aHomV[nAchou,3]						
		aHomV[nAchou,7]:=1
	Else
		aCpoExtra[nY,8] := "D" //Deletado
	Endif
Next nY

aSort(aCpoExtra,,, {|x,y| x[8]+Str(x[4])+x[7] < y[8]+Str(y[4])+y[7]})
nXCol := 1
If ( Len(aCpoExtra) = 0 ) .or. ( Len(aCpoExtra) > 0 .and. !Empty(aCpoExtra[1,8]) )
	oPrint:say (nL+nPT,nCl01a+30		,"56.1 " + STR0051 + " 0,00" + STR0050, oFont08) 
	oPrint:say (nL+nPD,nCl01a+30		,"   0,00%"	, oFont08) 
	oPrint:say (nL+nPD,nCl01b+10	,TransForm(0,"@E 99,999,999.99"), oFont10)
	fNewLine()    				
Else
	nCont	:=	1			
	For nY := 1 to Len(aCpoExtra)
		If !Empty(aCpoExtra[nY,8])
			Exit
		Endif
		aCpoExtra[nY,1] += cValToChar(nCont++)
		oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30+If(nXCol>1,30,0),aCpoExtra[nY,1] + STR0051 + TransForm(aCpoExtra[nY,5],"@E 999.99") + STR0050, oFont08)
		oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a" )+30+If(nXCol>1,80,40),TransForm(aCpoExtra[nY,4],"@E 999.99") + "%", oFont08)
		oPrint:say (nL+nPD,	&("nCl0" + cValToChar(nXCol) + "b")+10,TransForm(aCpoExtra[nY,6],"@E 99,999,999.99"), oFont10)
		fNewLine()
	Next nY
Endif
           
// -------------------------------------------------------------------------------------------------------
//  |57| Gorjetas
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30, STR0052, oFont08) 
oPrint:say (nL+nPD,	&("nCl0" + cValToChar(nXCol) + "b")+10, GPER140Sum(1,2,"011"), oFont10) 
fNewLine()

// -------------------------------------------------------------------------------------------------------
//  |58| DSR
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30, STR0053, oFont08)
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a" )+30, STR0054, oFont08)
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10, GPER140Sum(1,1,"033/430"), oFont10) 
fNewLine()

// -------------------------------------------------------------------------------------------------------
//  |59| Reflexo do DSR
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 , STR0057, oFont08) 
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a" )+30 , STR0058, oFont08) 
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10,GPER140Sum(1, 1,cDSRSalV,/*lCampo*/,/*nRef*/,/*nType*/,.T.), oFont10) 
fNewLine()

// -------------------------------------------------------------------------------------------------------
//  |60| Multa Art. 477
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 , STR0059, oFont08)  
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10, GPER140Sum(1,2,"009"), oFont10) 
fNewLine()

If Alltrim(GPER140Sum(1,1,"176")) <> "0,00"
	// -------------------------------------------------------------------------------------------------------
	//  |61| Multa Art. 479
	// -------------------------------------------------------------------------------------------------------
	oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 ,STR0060, oFont08) 
	oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10, GPER140Sum(1,1,"176"), oFont10) 
	fNewLine()
Endif
// -------------------------------------------------------------------------------------------------------
//  |62| Salario Familia
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 , STR0055, oFont08) 
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10, GPER140Sum(1,1,"034"), oFont10) 
fNewLine()

// -------------------------------------------------------------------------------------------------------
//  |63| 13o. Salario Proporcional
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 , STR0061, oFont08) 
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a" )+30 , If(aScan(aHomV, {|aHomV| aHomV[5] == "114"}) == 0, GPER140Sum(1,1,"251",,2), GPER140Sum(1,1,"114",,2) )+"/12 avos"	, oFont08) 
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10, GPER140Sum(1,1,"114/251"), oFont10) 
fNewLine()
                  
// -------------------------------------------------------------------------------------------------------
//  |64| 13o. Salario Vencido
// -------------------------------------------------------------------------------------------------------
If Len(aTab25) > 0 .and. (nAchou := aScan(aTab25, {|x| x[5] = '64'})) > 0
	cVrbFixa := aTab25[nAchou,6]
	nPosFixa := aScan(aHomV, {|x| x[4] = cVrbFixa})
Endif

If nPosFixa > 0
	oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 , STR0062 + " " + SubStr(aHomV[nPosFixa,9],3,4), oFont08)
	oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a" )+30 , SubStr(aHomV[nPosFixa,9],1,2) + "/12 " + STR0064, oFont08)  
	oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b" + 30)+10, TransForm(aHomV[nPosFixa,3],"@E 99,999,999.99"), oFont10)  
	aHomV[nPosFixa,7] := 1
Else
	oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 , STR0062, oFont08)
	oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a" )+30 , " __/12 " + STR0064, oFont08)
	oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10, TransForm(0,"@E 99,999,999.99"), oFont10)  
Endif
fNewLine()

// -------------------------------------------------------------------------------------------------------
//  |65| Ferias Proporcionais
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 , STR0065, oFont08) 
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a" )+30 , If(aScan(aHomV, {|aHomV| aHomV[5] == "087"}) == 0, GPER140Sum(1,1,"249",,2), GPER140Sum(1,1,"087",,2) )+"/12 " + STR0064, oFont08)  
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10, GPER140Sum(1,1,"087/249"), oFont10)
fNewLine()

// -------------------------------------------------------------------------------------------------------
//  |66| Ferias Vencidas
// -------------------------------------------------------------------------------------------------------
aPer := fPerArquisitivo()
If Len(aPer) = 0 .or. (Len(aPer) == 1 .and. aPer[1,4] < 30)
	oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 , "66 " + STR0066, oFont08) 
	oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a" )+30 , '  /  /  '+" a "+'  /  /  ', oFont08)
	oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10, TransForm(0,"@E 99,999,999.99"), oFont10)  
	fNewLine()
Else
	nCont := 1
	For nY := 1 to Len(aPer)            
		If aPer[nY,4] > 0
			oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 , "66." + cValToChar(nCont) + " " + STR0066, oFont08) 
			oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a" )+30 ,DTOC(aPer[nY,1])+" a "+DTOC(aPer[nY,2]), oFont08)
			oPrint:say (nL+nPD,	&("nCl0" + cValToChar(nXCol) + "b")+10,GPER140Sum(1,1,"086/248",,,,,DTOS(aPer[nY,1]) + " - " + DTOS(aPer[nY,2])), oFont10)
			fNewLine()
			nCont++
		Endif
	Next nY
Endif

// -------------------------------------------------------------------------------------------------------
//  |67| Ferias em Dobro
// -------------------------------------------------------------------------------------------------------
aPerDobra := {}
If aCodFol[224,1] # Space(3)
	If ( nAchou := Ascan(aHomV,{|x| x[4]==aCodFol[224,1]}) ) > 0
		While nAchou <= Len(aHomV) .and. aHomV[nAchou,4]==aCodFol[224,1]
			cString := aHomV[nAchou,9]
			aAdd(aPerDobra,{STOD(SubStr(cString,1,At("-",cString)-1)),STOD(SubStr(cString,At("-",cString)+2,Len(cString))),aHomV[nAchou,3]})
			aHomV[nAchou,7]:=1
			nAchou++
		Enddo
	Endif
Endif
If aCodFol[925,1] # Space(3)
	If ( nAchou := Ascan(aHomV,{|x| x[4]==aCodFol[925,1]}) ) > 0
		While nAchou <= Len(aHomV) .and. aHomV[nAchou,4]==aCodFol[224,1]
			cString := aHomV[nAchou,9]
			aAdd(aPerDobra,{STOD(SubStr(cString,1,At("-",cString)-1)),STOD(SubStr(cString,At("-",cString)+2,Len(cString))),aHomV[nAchou,3]})
			aHomV[nAchou,7]:=1
			nAchou++
		Enddo
	Endif
Endif

IF Len(aPerDobra) > 0
	aSort(aPerDobra,,,{|x,y| x[1] < y[1]})
	For nY := 1 to Len(aPerDobra)
		oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 , "67." + cValToChar(nY) + " " + STR0063, oFont08) 
		oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a" )+30 ,DTOC(aPerDobra[nY,1])+STR0067+DTOC(aPerDobra[nY,2]), oFont08)
		oPrint:say (nL+nPD,	&("nCl0" + cValToChar(nXCol) + "b")+10,TransForm(aPerDobra[nY,3],"@E 99,999,999.99"), oFont10)
		fNewLine()
	Next nY
Endif

// -------------------------------------------------------------------------------------------------------
//  |68| 1/3 de Ferias 
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 , STR0068, oFont08) 
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10	,GPER140Sum(1,1,"125/226/231/926"), oFont10) 
fNewLine()

// -------------------------------------------------------------------------------------------------------
//  |69| Aviso Previo Indenizado
// -------------------------------------------------------------------------------------------------------
cVal69	:= GPER140Sum(1,1,"111/250")
If ( Val(cVal69) > 0 )

	oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 , STR0069, oFont08)
	oPrint:say(nL+nPT+28,&("nCl0" + cValToChar(nXCol) + "a" )+30 ,If(ValType(nDiasAv)!="U",Space(1)+Str (nDiasAv,5,1)+STR0151,Space(6)+STR0151), oFont08)	

Else

	oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 , STR0069 , oFont08)

EndIf

oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10, cVal69 , oFont10) 

fNewLine()

// -------------------------------------------------------------------------------------------------------
//  |70| 13o. Salario s/ Aviso Previo
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 , STR0070, oFont08) 
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a" )+30 , STR0071, oFont08) 		
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10, GPER140Sum(1,1,"115/253"), oFont10) 
fNewLine()

// -------------------------------------------------------------------------------------------------------
//  |71| Ferias s/ Aviso Previo
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 , STR0119, oFont08)
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a" )+30 , STR0071, oFont08) 		
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10, GPER140Sum(1,1,"230/252"), oFont10) 
fNewLine()
       
// -------------------------------------------------------------------------------------------------------
//  |72| Percentagem - A - |93| Gratificacao Semestral
// -------------------------------------------------------------------------------------------------------
For nY := 1 to Len(aCpoForm)
   	If Val(Strtran(StrTran(aCpoForm[nY,5],".",""),",","."))>0 
		oPrint:line(nL,135,nL,nColMax )
		oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 ,aCpoForm[nY,1]+" "+Substr(aCpoForm[nY,3],1,33), oFont08) 
		If Len(aCpoForm[nY,3])>33
			oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a" )+30 ,aCpoForm[nY,1]+" "+Substr(aCpoForm[nY,3],34,33), oFont08) 
		Endif
		oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10,aCpoForm[nY,5], oFont10) 
		fNewLine()
	Endif
Next
		
// -------------------------------------------------------------------------------------------------------
//  |94| Salario do mes anterior a rescisao
// -------------------------------------------------------------------------------------------------------
nPosFixa := 0
If Len(aTab25) > 0 .and. (nAchou := aScan(aTab25, {|x| x[5] = '94'})) > 0
	cVrbFixa := aTab25[nAchou,6]
	nPosFixa := aScan(aHomV, {|x| x[4] = cVrbFixa})
Endif

If nPosFixa > 0
	oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 , STR0120, oFont08) 
	oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10, TransForm(aHomV[nPosFixa,3],"@E 99,999,999.99"), oFont10) 
	aHomV[nPosFixa,7] := 1
	fNewLine()
Endif

// -------------------------------------------------------------------------------------------------------
//  |95| Outros
// -------------------------------------------------------------------------------------------------------
nCont := 1
For nY:= 1 to Len(aHomV)
	If aHomV[nY,7]==0
		oPrint:line(nL,135,nL,nColMax )
		oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 ,"95."+AllTrim(Str(nCont))+" "+Capital(Substr(aHomV[nY,1],1,33)), oFont08) 
		If Len(aHomV[nY,1])>33
			oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a" )+30 ,Substr(aHomV[nY,1],34,33), oFont08) 
		Endif
		oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10,TransForm(aHomV[nY,3],"@E 99,999,999.99"), oFont10) 
		nCont++
		fNewLine()
	Endif
Next  
        
// -------------------------------------------------------------------------------------------------------
//  |96| Indeniza��o art. 9�, Lei n� 7.238/1984 - A - |98| Multa art. 476-A & 5� da CLT"
// -------------------------------------------------------------------------------------------------------
For nY := 1 to Len(aCpoFor1)
	If Val(Strtran(StrTran(aCpoFor1[nY,5],".",""),",","."))>0 
		oPrint:line(nL,135,nL,nColMax )
		oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 ,aCpoFor1[nY,1]+" "+Substr(aCpoFor1[nY,3],1,33), oFont08) 
		If Len(aCpoFor1[nY,3])>33
			oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a" )+30 ,aCpoFor1[nY,1]+" "+Substr(aCpoFor1[nY,3],34,33), oFont08) 
		Endif
		oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10,aCpoFor1[nY,5], oFont10) 
		fNewLine()
	Endif
Next

// -------------------------------------------------------------------------------------------------------
//  |99| Ajuste do Saldo Devedor
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a" )+30 , STR0153, oFont08) 
oPrint:say (nL+nPD,	&("nCl0" + cValToChar(nXCol) + "b")+10, GPER140Sum(1,1,"045"), oFont10) 

fNewLine()
 
oPrint:FillRect( {nL+05, nCl03a+02, nL+nAddL+05, nColMax}, oBrush1 )  

oPrint:say (nL+nPT+20,nCl03a+30,STR0072, oFont08n) //"TOTAL BRUTO" 
oPrint:say (nL+nPD,nCl03b-10,Transform(nProv,"@E 999,999,999.99"), oFont10)

nL+=nAddL+05

//Fecha o box e cria as linhas verticais
oPrint:Box( nBoxIni, 135 ,nL,nColMax )
oPrint:line(nBoxIni,nCl01b+20,nL,nCl01b+20 )
oPrint:line(nBoxIni,nCl02a,nL,nCl02a )
oPrint:line(nBoxIni,nCl02b+20,nL,nCl02b+20 )
oPrint:line(nBoxIni,nCl03a,nL,nCl03a )
oPrint:line(nBoxIni,nCl03b+20,nL,nCl03b+20 )

nTamL:=5

fVerQuebra(2, .F.)

oPrint:Box(nL, 135,nL+nSubT, nColMax ) 									
oPrint:say (nL+05,nCl01a+30,STR0073, oFont09n)	//"DEDU��ES"
nL+=nSubT

fVerQuebra(2, .F.)

nCkHomV:=0
For nY:=1 to Len(aCpoFormD)
	If Val(Strtran(StrTran(aCpoFormD[nY,5],".",""),",","."))>0 
		nCkHomV++
	Endif
Next		
nBoxIni:=nL	
For nX:=1 to nTamL
	If nX==1
		oPrint:say (nL+02,nCl01a+30   ,STR0074, oFont09n)	 //"DESCONTO"
		oPrint:say (nL+02,nCl01b+30	,STR0038, oFont09n) 	 //"VALOR"
		oPrint:say (nL+02,nCl02a+30	,STR0074, oFont09n) 	 //"DESCONTO"
		oPrint:say (nL+02,nCl02b+30	,STR0038, oFont09n) 	 //"VALOR"
		oPrint:say (nL+02,nCl03a+30	,STR0074, oFont09n) 	 //"DESCONTO"
		oPrint:say (nL+02,nCl03b+30	,STR0038, oFont09n) 	 //"VALOR"
	Elseif nX==2
		oPrint:say (nL+nPT,nCl01a+30		,STR0075, oFont08)  //"100 Pens�o Aliment�cia"
		oPrint:say (nL+nPD,nCl01b+10	,GPER140Sum(2,3,"172/170/128/058/056"), oFont10) // dentro da rotina os identificadores serao ignorados
		oPrint:say (nL+nPT,nCl02a+30	,STR0076, oFont08)  //"101 Adiantamento Salarial"
		oPrint:say (nL+nPD,nCl02b+10	,GPER140Sum(2,2,"A01"), oFont10) 
		oPrint:say (nL+nPT,nCl03a+30	,STR0077, oFont08)  //"102 Adiantamento de 13� Sal�rio"
		oPrint:say (nL+nPD,nCl03b+10	,GPER140Sum(2,2,"A02"), oFont10) 
	Elseif nX==3
		oPrint:say (nL+nPT,nCl01a+30		,STR0078+" ", oFont08)  //"103 Aviso-Pr�vio Indenizado" 
		oPrint:say (nL+nPT+28,nCl01a+30		, StrZero(n_X2,2)+STR0151, oFont08)  //"103 Aviso-Pr�vio Indenizado"      
		oPrint:say (nL+nPD,nCl01b+10	,GPER140Sum(2,1,"113"), oFont10) 
		
	    nValLin:=2
	     
	   	If Alltrim(GPER140Sum(2,2,"A09") ) <> "0,00" 
	   		oPrint:say (nL+nPT,&("nCl0"+STR(nValLIn,1)+"a") +30	,STR0079, oFont08)  //"104 Multa Art. 480/CLT"
	   		oPrint:say (nL+nPD,&("nCl0"+STR(nValLIn,1)+"b")+10	,GPER140Sum(2,2,"A09"), oFont10)
	   		nValLin++
	   	ElseIF Alltrim(GPER140Sum(2,2,"A08")) <> "0,00" 
	   		oPrint:say (nL+nPT,&("nCl0"+STR(nValLIn,1)+"a")+30	,STR0080, oFont08)  //"105 Empr�stimo em Consigna��o"
	   		oPrint:say (nL+nPD,&("nCl0"+STR(nValLIn,1)+"b")+10	,GPER140Sum(2,2,"A08"), oFont10)
	   		fDesconto(@nValLin)
		ElseIF Alltrim(GPER140Sum(2,2,"A04")) <> "0,00" 
			oPrint:say (nL+nPT,&("nCl0"+STR(nValLIn,1)+"a")+30	,STR0081, oFont08)  //"106 Vale-Transporte"
			oPrint:say (nL+nPD,&("nCl0"+STR(nValLIn,1)+"b")+10	,GPER140Sum(2,2,"A04"), oFont10)
		    fDesconto(@nValLin)
	   	ElseIF Alltrim(GPER140Sum(2,2,"A06")) <> "0,00" 
	   		oPrint:say (nL+nPT,&("nCl0"+STR(nValLIn,1)+"a")+30	,STR0082, oFont08)  //"107 Reembolso do Vale-Transporte"
	   		oPrint:say (nL+nPD,&("nCl0"+STR(nValLIn,1)+"b")+10	,GPER140Sum(2,2,"A06"), oFont10)
	   		fDesconto(@nValLin)
	   	ElseIF Alltrim(GPER140Sum(2,2,"A05")) <> "0,00" 
	   		oPrint:say (nL+nPT,&("nCl0"+STR(nValLIn,1)+"a")+30	,STR0083, oFont08)  //"108 Vale-Alimenta��o"
			oPrint:say (nL+nPD,&("nCl0"+STR(nValLIn,1)+"b")+10	,GPER140Sum(2,2,"A05"), oFont10)
		    fDesconto(@nValLin)
	   	ElseIF Alltrim(GPER140Sum(2,2,"A07")) <> "0,00" 	 
			oPrint:say (nL+nPT,&("nCl0"+STR(nValLIn,1)+"a")+30  		,STR0084, oFont08)  //"109 Reembolso Vale-Alimenta��o"
	   		oPrint:say (nL+nPD,&("nCl0"+STR(nValLIn,1)+"b")+10	,GPER140Sum(2,2,"A07"), oFont10)
	   		fDesconto(@nValLin)
		ElseIF Alltrim(GPER140Sum(2,2,"A11")) <> "0,00" 
			oPrint:say (nL+nPT,&("nCl0"+STR(nValLIn,1)+"a")+30	,STR0085, oFont08)  //"110 Contibui��o para o FAPI"
			oPrint:say (nL+nPD,&("nCl0"+STR(nValLIn,1)+"b")+10	,GPER140Sum(2,2,"A11"), oFont10)
			fDesconto(@nValLin)
		ElseIF Alltrim(GPER140Sum(2,2,"A13")) <> "0,00" 
			oPrint:say (nL+nPT,&("nCl0"+STR(nValLIn,1)+"a")+30	,STR0086, oFont08)  //"111 Contribui��o Sindical Laboral"
			oPrint:say (nL+nPD,&("nCl0"+STR(nValLIn,1)+"b")+10	,GPER140Sum(2,2,"A13"), oFont10)
			fDesconto(@nValLin)
		Endif
		oPrint:say (nL+nPT,&("nCl0"+STR(nValLIn,1)+"a")+30  	,STR0087, oFont08)  //"112.1 Previd�ncia Social"
   		oPrint:say (nL+nPD,&("nCl0"+STR(nValLIn,1)+"b")+10	,GPER140Sum(2,1,"064/065"), oFont10)
   		fDesconto(@nValLin)
   		
  		oPrint:say (nL+nPT,&("nCl0"+STR(nValLIn,1)+"a")+30	,STR0088, oFont08)  //"112.2 Previd�ncia Social 13� Salario"
   		oPrint:say (nL+nPD,&("nCl0"+STR(nValLIn,1)+"b")+10	,GPER140Sum(2,1,"070"), oFont10)
   		fDesconto(@nValLin)
	   		 
        IF Alltrim(GPER140Sum(2,2,"A10")) <> "0,00" 
        	oPrint:say (nL+nPT,&("nCl0"+STR(nValLIn,1)+"a")+30	,STR0089, oFont08)  //"113 Contribui��o Previd�ncia "
			oPrint:say (nL+nPD,&("nCl0"+STR(nValLIn,1)+"a")+30	,STR0090, oFont08)  //"Complementar"
	   		oPrint:say (nL+nPD,&("nCl0"+STR(nValLIn,1)+"b")+10	,GPER140Sum(2,2,"A10"), oFont10)
	   		fDesconto(@nValLin)
	   	Endif  
	   	
   		oPrint:say (nL+nPT,&("nCl0"+STR(nValLIn,1)+"a")+30  	,STR0091, oFont08)  //"114.1 IRRF"
		oPrint:say (nL+nPD,&("nCl0"+STR(nValLIn,1)+"b")+10	,GPER140Sum(2,1,"066/067"), oFont10)
		fDesconto(@nValLin)
     
		oPrint:say (nL+nPT,&("nCl0"+STR(nValLIn,1)+"a")+30	,STR0092, oFont08)  //"114.2 IRRF sobre 13� Sal�rio"
		oPrint:say (nL+nPD,&("nCl0"+STR(nValLIn,1)+"b")+10	,GPER140Sum(2,1,"071"), oFont10)
		fDesconto(@nValLin)
			
		IF Alltrim(GPER140Sum(2,1,"152")) <> "0,00" 
			oPrint:say (nL+nPT,&("nCl0"+STR(nValLIn,1)+"a")+30	,STR0093, oFont08)  //"114.3 IRRF sobre Participa��o nos "
		  	oPrint:say (nL+nPD,&("nCl0"+STR(nValLIn,1)+"a")+30	,STR0094, oFont08)  //"Lucros ou Resultados"
			oPrint:say (nL+nPD,&("nCl0"+STR(nValLIn,1)+"b")+10	,GPER140Sum(2,1,"152"), oFont10)
			nValLin++
		  	fDesconto(@nValLin)
		Endif
	Elseif nX=4 
   		For nY:= 1 to Len(aHomD)
			If aHomD[nY,7]==0
			   nCkHomV++
			Endif
		Next
		If nCkHomV>=4
			nTamL:=nTamL+Int((nCkHomV-4)/3)	
		Endif  
			
		If nCkHomV<4
			nW:=nValLin-1
			For nY := 1 to Len(aCpoFormD)
				If Val(Strtran(StrTran(aCpoFormD[nY,5],".",""),",","."))>0 
					nW++
					If nW==1
						oPrint:say (nL+nPT,nCl01a+30,aCpoFormD[nY,1]+" "+Capital(Substr(aCpoFormD[nY,3],1,33)), oFont08) 
						If Len(aCpoFormD[nY,3])>33
							oPrint:say (nL+nPD,nCl01a+30,aCpoFormD[nY,1]+" "+Substr(aCpoFormD[nY,3],34,33), oFont08) 
						Endif
						oPrint:say (nL+nPD,nCl01b+10,aCpoFormD[nY,5], oFont10) 
					Elseif nW==2
						oPrint:say (nL+nPT,nCl02a+30,aCpoFormD[nY,1]+" "+Capital(Substr(aCpoFormD[nY,3],1,33)), oFont08) 
						If Len(aCpoFormD[nY,3])>33
							oPrint:say (nL+nPD,nCl02a+30,aCpoFormD[nY,1]+" "+Substr(aCpoFormD[nY,3],34,33), oFont08) 
						Endif
						oPrint:say (nL+nPD,nCl02b+10,aCpoFormD[nY,5], oFont10) 
					Elseif nW==3
						nW:=0
						oPrint:say (nL+nPT,nCl03a+30,aCpoFormD[nY,1]+" "+Capital(Substr(aCpoFormD[nY,3],1,33)), oFont08) 
						If Len(aCpoFormD[nY,3])>33
							oPrint:say (nL+nPD,nCl03a+30,aCpoFormD[nY,1]+" "+Substr(aCpoFormD[nY,3],34,33), oFont08) 
						Endif
						oPrint:say (nL+nPD,nCl03b+10,aCpoFormD[nY,5], oFont10) 
						nL+=nAddL+10
						oPrint:line(nL,135,nL,nColMax )	
						fVerQuebra(2)
					Endif
				Endif
			Next
			nT:=0	
			For nY:= 1 to Len(aHomD)
				If aHomD[nY,7]==0
					nW++
					nT++
					cItem:= If(nT ==1,"115","115."+AllTrim(Str(nT-1)))
					If nW==1
						oPrint:say (nL+nPT,nCl01a+30,cItem+" "+Capital(Substr(aHomD[nY,1],1,33)), oFont08) 
						If Len(aHomD[nY,1])>33
							oPrint:say (nL+nPD,nCl01a+30,Substr(aHomD[nY,1],34,33), oFont08) 
						Endif
						oPrint:say (nL+nPD,nCl01b+10,TransForm(aHomD[nY,3],"@E 99,999,999.99"), oFont10) 
					Elseif nW==2
						oPrint:say (nL+nPT,nCl02a+30,cItem+" "+Capital(Substr(aHomD[nY,1],1,33)), oFont08) 
						If Len(aHomD[nY,1])>33
							oPrint:say (nL+nPD,nCl02a+30,Substr(aHomD[nY,1],34,33), oFont08) 
						Endif
						oPrint:say (nL+nPD,nCl02b+10,TransForm(aHomD[nY,3],"@E 99,999,999.99"), oFont10) 
					Elseif nW==3
						nW:=0
						oPrint:say (nL+nPT,nCl03a+30,cItem+" "+Capital(Substr(aHomD[nY,1],1,33)), oFont08) 
						If Len(aHomD[nY,1])>33
							oPrint:say (nL+nPD,nCl03a+30,Substr(aHomD[nY,1],34,33), oFont08) 
						Endif
						oPrint:say (nL+nPD,nCl03b+10,TransForm(aHomD[nY,3],"@E 99,999,999.99"), oFont10)   
						nL+=nAddL+10
						oPrint:line(nL,135,nL,nColMax )	
						fVerQuebra(2)
					Endif
				Endif
			Next
			If nW ==0 
				oPrint:say (nL+nPT,nCl01a+30,STR0095, oFont08)      //"116 Desc. de Valor Liq. de TRCT-"
				oPrint:say (nL+nPD,nCl01a+30,STR0096, oFont08)      //"Quitado"
				oPrint:say (nL+nPD,nCl01b+10,TransForm(0,"@E 99,999,999.99"), oFont10) 
				If nL < 3131 .And. !lQuebraP .And. !lQuebraD
					nL+=nAddL+05
					oPrint:line(nL,135,nL,nColMax )						
				EndIf
			Elseif nW==1
				oPrint:say (nL+nPT,nCl02a+30,STR0095	, oFont08) //"116 Desc. de Valor Liq. de TRCT-"
				oPrint:say (nL+nPD,nCl02a+30,STR0096	, oFont08) //"Quitado"
				oPrint:say (nL+nPD,nCl02b+10,TransForm(0,"@E 99,999,999.99"), oFont10) 
				If nL < 3131 .And. !lQuebraP .And. !lQuebraD
					nL+=nAddL+05
					oPrint:line(nL,135,nL,nColMax )						
				EndIf
			Elseif nW==2 
				If nL < 3131 .And. !lQuebraP .And. !lQuebraD
					oPrint:say (nL+nPT,nCl03a+30,STR0095, oFont08)   //"116 Desc. de Valor Liq. de TRCT-"
					oPrint:say (nL+nPD,nCl03a+30,STR0096, oFont08)   //"Quitado"
					oPrint:say (nL+nPD,nCl03b+10,TransForm(0,"@E 99,999,999.99"), oFont10)  
					nL+=nAddL+05
					oPrint:line(nL,135,nL,nColMax )						
				ElseIf nL == 3131
					oPrint:say (nL+nPT+nAddL+05,nCl01a+30,STR0095, oFont08)   //"116 Desc. de Valor Liq. de TRCT-"
					oPrint:say (nL+nPD+nAddL+05,nCl01a+30,STR0096, oFont08)   //"Quitado"
					oPrint:say (nL+nPD+nAddL+05,nCl01b+10,TransForm(0,"@E 99,999,999.99"), oFont10)  
				ElseIf nL == 3221
					oPrint:say (nL+nPT,nCl03a+30,STR0095, oFont08)   //"116 Desc. de Valor Liq. de TRCT-"
					oPrint:say (nL+nPD,nCl03a+30,STR0096, oFont08)   //"Quitado"
					oPrint:say (nL+nPD,nCl03b+10,TransForm(0,"@E 99,999,999.99"), oFont10)  
					nL+=nAddL+05
					oPrint:line(nL,135,nL,nColMax )	
					fVerQuebra(2)
				Else
					oPrint:say (nL+nPT+nAddL+05,nCl01a+30,STR0095, oFont08)   //"116 Desc. de Valor Liq. de TRCT-"
					oPrint:say (nL+nPD+nAddL+05,nCl01a+30,STR0096, oFont08)   //"Quitado"
					oPrint:say (nL+nPD+nAddL+05,nCl01b+10,TransForm(0,"@E 99,999,999.99"), oFont10)  
				EndIf
				lTemVerba := .T.
		    	nL+=nAddL+05
				oPrint:line(nL,135,nL,nColMax )	
				fVerQuebra(2)
			Endif
			Exit 
		Else
			Loop
		Endif
	Elseif nX > 4
		nW:=nValLin-1
  		For nY := 1 to Len(aCpoFormD)
			If Val(Strtran(StrTran(aCpoFormD[nY,5],".",""),",","."))>0   		
				nW++
				If nW==1 
					oPrint:say (nL+nPT,nCl01a+30,aCpoFormD[nY,1]+" "+Capital(Substr(aCpoFormD[nY,3],1,33)), oFont08)
					If Len(aCpoFormD[nY,3]) >33
						oPrint:say (nL+nPD,nCl01a+30,aCpoFormD[nY,1]+" "+Substr(aCpoFormD[nY,3],34,33), oFont08)
					Endif
					oPrint:say (nL+nPD,nCl01b+10,aCpoFormD[nY,5], oFont10) 
				Elseif nW==2
					oPrint:say (nL+nPT,nCl02a+30,aCpoFormD[nY,1]+" "+Capital(Substr(aCpoFormD[nY,3],1,33)), oFont08) 
					If Len(aCpoFormD[nY,3]) >33
						oPrint:say (nL+nPD,nCl02a+30,aCpoFormD[nY,1]+" "+Substr(aCpoFormD[nY,3],34,33), oFont08)
					Endif					
					oPrint:say (nL+nPD,nCl02b+10,aCpoFormD[nY,5], oFont10) 
				Elseif nW==3 
					nW:=0
					oPrint:say (nL+nPT,nCl03a+30,aCpoFormD[nY,1]+" "+Capital(Substr(aCpoFormD[nY,3],1,33)), oFont08) 
					If Len(aCpoFormD[nY,3]) >33
						oPrint:say (nL+nPD,nCl03a+30,aCpoFormD[nY,1]+" "+Substr(aCpoFormD[nY,3],34,33), oFont08)
					Endif					
					oPrint:say (nL+nPD,nCl03b+10,aCpoFormD[nY,5], oFont10) 				
					nL+=nAddL+05
					oPrint:line(nL,135,nL,nColMax )
					fVerQuebra(2)
				Endif
			Endif
		Next	
	   	nT:=0	
		For nY:= 1 to Len(aHomD)
			If aHomD[nY,7]==0
				nW++
				nT++
				cItem:= If(nT ==1,"115","115."+AllTrim(Str(nT-1)))
				If nW==1
					oPrint:say (nL+nPT,nCl01a+30,cItem+" "+Capital(Substr(aHomD[nY,1],1,33)), oFont08) 
					If Len(aHomD[nY,1])>33
						oPrint:say (nL+nPD,nCl01a+30,cItem+" "+Substr(aHomD[nY,1],34,33), oFont08) 					
					Endif
					oPrint:say (nL+nPD,nCl01b+10,TransForm(aHomD[nY,3],"@E 99,999,999.99"), oFont10) 
				Elseif nW==2
					oPrint:say (nL+nPT,nCl02a+30,cItem+" "+Capital(Substr(aHomD[nY,1],1,33)), oFont08) 
					If Len(aHomD[nY,1])>33
						oPrint:say (nL+nPD,nCl02a+30,cItem+" "+Substr(aHomD[nY,1],34,33), oFont08) 					
					Endif
					oPrint:say (nL+nPD,nCl02b+10,TransForm(aHomD[nY,3],"@E 99,999,999.99"), oFont10) 
				Elseif nW==3
					nW:=0
					oPrint:say (nL+nPT,nCl03a+30,cItem+" "+Capital(Substr(aHomD[nY,1],1,33)), oFont08) 
					If Len(aHomD[nY,1])>33
						oPrint:say (nL+nPD,nCl03a+30,cItem+" "+Substr(aHomD[nY,1],34,33), oFont08) 					
					Endif
					oPrint:say (nL+nPD,nCl03b+10,TransForm(aHomD[nY,3],"@E 99,999,999.99"), oFont10)   
					nL+=nAddL+05
					oPrint:line(nL,135,nL,nColMax )						
					fVerQuebra(2)
				Endif
			Endif
		Next
		Exit 
	Endif
	If (nX < 4 .And. nValLin == 1) .or. (nX<5 .and. nCkHomV>3 )
		nL+=If(nX==1,(nAddL-42),nAddL+05)
		oPrint:line(nL,135,nL,nColMax )
		fVerQuebra(2)
	Endif
Next

While nL < 3042 .And. nPagina==1
	nL+=nAddL+05
	oPrint:line(nL,135,nL,nColMax )
EndDo   

IF lTemVerba
	oPrint:FillRect( {nL+05-90, nCl03a, nL+nAddL-90, nColMax}, oBrush1 )
	oPrint:say (nL+nPT-70,nCl03a+30,STR0097, oFont08n)   //"TOTAL DEDU��ES"
	oPrint:say (nL+nPD-90,nCl03b-10,Transform(nDesc,"@E 999,999,999.99"), oFont10)
	oPrint:FillRect( {nL+5, nCl03a+01, nL+nAddL+05, nColMax}, oBrush1 ) 
	oPrint:say (nL+nPT,nCl02a+30	,"            ", oFont08) 
	oPrint:say (nL+nPD,nCl02b+10	,"            ", oFont08) 
	oPrint:say (nL+nPT+20,nCl03a+30	,STR0099, oFont08n)  //"VALOR L�QUIDO"
	oPrint:say (nL+nPD,nCl03b-15,Transform(nProv - nDesc,"@E 999,999,999.99"), oFont10)  	
Else
	oPrint:FillRect( {nL+05, nCl03a, nL+nAddL, nColMax}, oBrush1 )
	oPrint:say (nL+nPT+20,nCl03a+30,STR0097, oFont08n)   //"TOTAL DEDU��ES"
	oPrint:say (nL+nPD,nCl03b-10,Transform(nDesc,"@E 999,999,999.99"), oFont10)
	nL+=nAddL+05         
	fVerQuebra(2)
	oPrint:FillRect( {nL+5, nCl03a+01, nL+nAddL+05, nColMax}, oBrush1 )
	oPrint:line(nL,135,nL,nColMax )
	oPrint:say (nL+nPT,nCl01a+30,"        "	   , oFont08)
	oPrint:say (nL+nPD,nCl01b+10,"            ", oFont08) 
	oPrint:say (nL+nPT,nCl02a+30,"            ", oFont08) 
	oPrint:say (nL+nPD,nCl02b+10,"            ", oFont08) 
	oPrint:say (nL+nPT+20,nCl03a+30,STR0099, oFont08n)  //"VALOR L�QUIDO"
	oPrint:say (nL+nPD,nCl03b-10,Transform(nProv - nDesc,"@E 999,999,999.99"), oFont10) 	
Endif	

nL+=nAddL+05 

//Fecha o box e cria as linhas verticais
oPrint:Box( nBoxIni,  135,nL,nColMax )
oPrint:line(nBoxIni,nCl01b+20,nL,nCl01b+20 )
oPrint:line(nBoxIni,nCl02a,nL,nCl02a )
oPrint:line(nBoxIni,nCl02b+20,nL,nCl02b+20 )
oPrint:line(nBoxIni,nCl03a,nL,nCl03a )
oPrint:line(nBoxIni,nCl03b+20,nL,nCl03b+20 )          

oPrint:EndPage()

//Se teve mais de um ano trabalhado deve ser impresso o termo de homologacao (Anexo VII) ao inves do termo de quitacao (Anexo VI)
//Se possuir aviso previo indenizado, deve-se considerar os dias de aviso na validacao do ano trabalhado
lHomolog := ( ( YearSum( SRA->RA_ADMISSA, 1 ) <= SRG->RG_DATADEM ) .Or. ( Val(cVal69) > 0 .And. YearSum( SRA->RA_ADMISSA, 1 ) <= DaySum( SRG->RG_DATADEM, nDiasAv ) ) )

//INICIO DA IMPRESSAO DO TERMO DE QUITACAO/HOMOLOGACAO DE RESCISAO DE CONTRATO DE TRABALHO - ANEXO VI/VII - PORTARIA MTE N. 2.685 - 26/12/2011 - DOU 27/12/2011
oPrint:StartPage() 			//Inicia uma nova pagina
 
nL:=077

If lHomolog   
	oPrint:FillRect( {nL, 135, nL+nTit, nColMax}, oBrush1 )
	oPrint:Box(nL, 135,nL+(nAddL+50)+(nPT*5)+nAddL+(nAddL*9)+(nPT*5)-125+nSubT , nColMax ) 		//-- Box   -155
	oPrint:say (nL+05,278,STR0138, oFont13n) //-- "TERMO DE HOMOLOGA��O DE RESCIS�O DE CONTRATO DE TRABALHO"	
Else   
	oPrint:FillRect( {nL, 135, nL+nTit, nColMax}, oBrush1 )
	oPrint:Box(nL, 135,nL+(nAddL+50)+(nPT*2)+nAddL+(nAddL*8)+(nPT*3)-100+nSubT , nColMax ) 		//-- Box 
	oPrint:say (nL+05,354,STR0121, oFont13n) //-- "TERMO DE QUITA��O DE RESCIS�O DE CONTRATO DE TRABALHO"	
EndIf

oPrint:FillRect( {nL+nTit, 037, nL+nTit+nSubT-05, nColMax+10}, oBrush2 )

nL:=nL+nTit
oPrint:line(nL,135 ,nL,nColMax)

nL+=nSubT

oPrint:FillRect( {nL, 137, nL+nSubT, nColMax}, oBrush1 )
oPrint:line(nL,135 ,nL,nColMax) 			//Linha Horizontal

nL:=nL+nPT

//����������������������������������������������������������������������������Ŀ
//�IDENTIFICACAO DO EMPREGADOR                                                 �
//������������������������������������������������������������������������������
oPrint:say (nL,160,STR0122, oFont09n) 	//-- "EMPREGADOR"

nL:=nL+nSubT-05

oPrint:line(nL,135 ,nL,nColMax) 										//Linha Horizontal
oPrint:line(nL,535 ,nL+nAddL+10,535 )									//Linha Vertical Meio
oPrint:say (nL+05,155,STR0056, oFont08) 		 						//"01- CNPJ/CEI: 	
oPrint:say (nl+05,550,STR0001, oFont08)								    //"02- Raz�o Social / Nome:"
oPrint:say (nL+nPD,175 ,SUBSTR(aInfo[8]+Space(20),1,20), oFont10 ) 	//"|01- CNPJ: 
oPrint:say (nL+nPD,565 ,aInfo[3], oFont10 )							//"02- Razao Social / Nome:"

oPrint:FillRect( {nL+nAddL+10, 137, nL+nPT+nSubT+nAddL+05, nColMax}, oBrush1 )
oPrint:line(nL+nAddL+10,135 ,nL+nAddL+10,nColMax)						//Linha Horizontal
//����������������������������������������������������������������������������Ŀ
//�IDENTIFICACAO DO EMPREGADOR                                                 �
//������������������������������������������������������������������������������
nL:=nL+nPT
nL:=nL+nAddL+10

oPrint:say (nL,160,STR0123, oFont09n)   			//-- "TRABALHADOR"
oPrint:line(nL+nSubT-05,135 ,nL+nSubT-05,nColMax) 		//Linha Horizontal

nL:=nL+nSubT-05

oPrint:say (nL+nPT,160 ,STR0025, oFont08) 		//"10 PIS/PASEP:" 
oPrint:say (nL+nPT,650 ,STR0023, oFont08)		//"11 NOME:"
oPrint:line(nL+nAddL+10,135 ,nL+nAddL+10,nColMax) 	//Linha Horizontal
oPrint:line(nL,635 ,nL+nAddL+10,635 )			

oPrint:say (nL+nPD,175 ,SRA->RA_PIS,oFont10) //PIS
If SRA->(FieldPos("RA_NOMECMP")) # 0 .And. !Empty(SRA->RA_NOMECMP)
	oPrint:say (nL+nPD,665 ,Subs(SRA->RA_NOMECMP+Space(60),1,60),oFont10) //NOME
Else
	oPrint:say (nL+nPD,665 ,Subs(SRA->RA_NOME+Space(30),1,30),oFont10) //NOME
EndIf	
	
oPrint:say (nL+nAddL+nPT+10,160 ,"17 "+STR0024, oFont08) 	//17 Carteira de Trabalho
oPrint:say (nL+nAddL+nPT+10,650 , STR0012, oFont08)		//18 CPF:"
oPrint:say (nL+nAddL+nPT+10,1045 , STR0027, oFont08)		//19 Nasc.:"
oPrint:say (nL+nAddL+nPT+10,1440, STR0007, oFont08)		//20 Nome da Mae"

oPrint:say (nL+nAddL+nPD+10,175 , SRA->RA_NUMCP+"- "+SRA->RA_SERCP+"/"+SRA->RA_UFCP, oFont10)	//17 CNAE
oPrint:say (nL+nAddL+nPD+10,665 , SRA->RA_CIC, oFont10)											//18 CPF:"
oPrint:say (nL+nAddL+nPD+10,1060 , DtoC(SRA->RA_NASC), oFont10)									//19 Nasc.:"
oPrint:say (nL+nAddL+nPD+10,1455, SUBSTR(SRA->RA_MAE+Space(30),1,40), oFont10)					//20 Nome da Mae"  

nL := nL + nAddL + 10

oPrint:line(nL,635 ,nL+nAddL+10,635 )		//Linha Vertical Meio	
oPrint:line(nL,1030,nL+nAddL+10,1030)		//Linha Vertical Meio	
oPrint:line(nL,1425,nL+nAddL+10,1425)		//Linha Vertical Meio	

//����������������������������������������������������������������������������Ŀ
//�DADOS DO CONTRATO	                                                       �
//������������������������������������������������������������������������������

nL:=nL+nAddL+10

oPrint:FillRect( {nL, 137, nL+nSubT, nColMax}, oBrush1 )
oPrint:Line(nL,135,nL,nColMax) //Linha Horizontal
oPrint:say (nL+05,160,STR0124, oFont09n) //-- "CONTRATO"
nL:=nL+nSubT
oPrint:Box(nL,135,nL,nColMax) //Linha Horizontal
oPrint:say (nL+nPT,160,STR0019, oFont08) 							//22 Causa do Afastamento
oPrint:say (nL+nPD,175,Left(cCausa,100), oFont10)

oPrint:say (nL+nTip+nPT,160,STR0021	, oFont08) 					//24 Data de Admissao
oPrint:say (nL+nTip+nPD,175,DtoC(SRA->RA_ADMISSA), oFont10) 
oPrint:say (nL+nTip+nPT,650,STR0022, oFont08) 					//25 Data do Aviso Previo
oPrint:say (nL+nTip+nPD,665,DtoC(SRG->RG_DTAVISO), oFont10) 
oPrint:say (nL+nTip+nPT,1045,STR0026, oFont08) 					//26 Data de Afastamento
oPrint:say (nL+nTip+nPD,1060,DtoC(SRG->RG_DATADEM), oFont10) 
oPrint:say (nL+nTip+nPT,1440	,STR0028	, oFont08)	 			//27 Cod. Afast.
oPrint:say (nL+nTip+nPD,1455	,cCodAfa, oFont10) 
oPrint:say (nL+nTip+nPT,1735,STR0136	, oFont08) 					//29 Pensao Alimenticia (FGTS)
oPrint:say (nL+nTip+nPD,1750,Transform(nPerFGTS,"@E 999.99"), oFont10)

nL := nL + nTip + nPT - 05

oPrint:line(nL,135 ,nL,nColMax) 		//Linha Horizontal
oPrint:line(nL,635,nL+nAddL+10,635)		//Linha Vertical Meio	
oPrint:line(nL,1030,nL+nAddL+10,1030)		//Linha Vertical Meio	
oPrint:line(nL,1425,nL+nAddL+10,1425)		//Linha Vertical Meio
oPrint:line(nL,1720,nL+nAddL+10,1720)		//Linha Vertical Meio

nL := nL + nAddL + 10

oPrint:line(nL,135 ,nL,nColMax) 										//Linha Horizontal
          
oPrint:say (nL+nPT,160,STR0031	, oFont08) //30 Categoria do Trabalhador
oPrint:say (nL+nPD,180,cCateg, oFont10) 


If lHomolog
	cCodSind   := ''
	cNomeSind  := ''
	lTrabRural := ( SRA->RA_VIEMRAI == "20" .Or. SRA->RA_VIEMRAI == "25" )
	
	If !Empty(SRA->RA_SINDICA)
		aAreaRCE := GetArea()
		
		DbSelectArea("RCE")
		If DbSeek(xFilial('RCE',SRA->RA_FILIAL)+SRA->RA_SINDICA)                          
			if !lTrabRural
				If ( ALLTRIM(STR(VAL(RCE->RCE_ENTSIN))) == ALLTRIM(RCE->RCE_ENTSIN) )
					cCodSind  := Transform(RCE->RCE_ENTSIN,"@R 999.999.999.99999-9")
				Else
					cCodSind  := ALLTRIM(RCE->RCE_ENTSIN)					
				EndIf
		    Endif
			cNomeSind := Transform( RCE->RCE_CGC , "@R 99.999.999/9999-99") + " - " + RCE->RCE_DESCRI
		EndIf
		
		RestArea(aAreaRCE)
	EndIf
	
	//Se nao existir entidade representativa da categoria, deve ser usado os dados do MTE
	If !lTrabRural .And. Empty(cCodSind)
		cCodSind  := '999.000.000.00000-3'
		cNomeSind := '37.115.367/0035-00 - Minist�rio do Trabalho e Emprego - MTE'
	EndIf
	
	nL := nL + nPT
//	oPrint:line(nL,035 ,nL,nColMax) 		//Linha Horizontal

	nL := nL + nAddL + 05	
	oPrint:say (nL+nPT,160,STR0139	, oFont08) //31 C�digo Sindical                                      
	oPrint:say (nL+nPD,175,cCodSind, oFont10)	
	oPrint:say (nL+nPT,650,STR0140, oFont08)  //32 CNPJ e Nome da Entidade Sindical Laboral
	oPrint:say (nL+nPD,665,cNomeSind, oFont10)

	oPrint:line(nL,135 ,nL,nColMax) 		//Linha Horizontal	
	oPrint:line(nL,635,nL+nAddL+nPT+05,635)		//Linha Vertical Meio
	
EndIf	

nL := nL + (nAddl*2) + nPT

If lHomolog
	oPrint:say (nL+nPT,140		,STR0141, oFont08)  //"Foi prestada, gratuitamente, assist�ncia na rescis�o do contrato de trabalho, nos termos do artigo n.� 477, � 1�, da Consolida�ao das Leis do Trabalho "                                                                                                                                                                                                                                                                                                                                                           
	nL += 35	
	oPrint:say (nL+nPT,140		,STR0142 , oFont08)  //"(CLT), sendo comprovado neste ato o efetivo pagamento das verbas rescis�rias especificadas no corpo do TRCT, no valor l�quido de R$ "
	nL += 35	
	oPrint:say (nL+nPT,140		,STR0157 + Transform(nProv - nDesc,"@E 999,999,999.99") + "," + STR0143, oFont08)  //"o qual, devidamente rubricado pelas partes, � parte integrante do presente Termo de Homologa�ao."    
	nL += 35
	
	nL += 35
	oPrint:say (nL+nPT,140		,STR0144, oFont08)  //"As partes assistidas no presente ato de rescis�o contratual foram identificadas como leg�timas conforme previsto na Instru�ao Normativa/SRT"                                                                                                                                                                                                                                                                                                                                                                       
	nL += 35	
	oPrint:say (nL+nPT,140		,STR0145, oFont08)  //"n.� 15/2010."
	                                                                                                      	
	nL += 35
	oPrint:say (nL+nPT,140		,STR0146, oFont08)  //�Fica ressalvado o direito de o trabalhador pleitear judicialmente os direitos informados no campo 155, abaixo."
				       
Else
	oPrint:say (nL+nPT,140		,STR0125, oFont08)  //"Foi realizada a rescis�o do contrato de trabalho do trabalhador acima qualificado, nos termos do artigo n� 477 da Consolida��o das Leis do Trabalho (CLT). "                                                                                                                                                                                                                                                                                                                                                       
	nL += 35
	oPrint:say (nL+nPT,140		,STR0126, oFont08)  //"A assist�ncia � rescis�o prevista no � 1� do art. n� 477 da CLT n�o � devida, tendo em vista a dura��o do contrato de trabalho n�o ser superior a um ano "                                                                                                                                                                                                                                                                                                                                                         
	nL += 35
	oPrint:say (nL+nPT,140		,STR0127, oFont08)  //"de servi�o e n�o existir previs�o de assist�ncia � rescis�o contratual em Acordo ou Conven��o Coletiva de Trabalho da categoria a qual pertence o "                                                                                                                                                                                                                                                                                                                                                                
	nL += 35
	oPrint:say (nL+nPT,140		,STR0128, oFont08)  //"trabalhador."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
	
	nL += 35
	oPrint:say (nL+nPT,140		,STR0130 + Space(1)+ " ___/___/______ " + STR0131, oFont08) //"No dia __/__/____  foi realizado, nos termos do art. 23 da Instru��o Normativa/SRT n� 15/2010, o efetivo pagamento das verbas rescis�rias especificadas" 
	nL += 35
	oPrint:say (nL+nPT,140		,STR0132 + Space(2)+ Transform(nProv - nDesc,"@E 999,999,999.99") + STR0152, oFont08)  //"no corpo do TRCT, no valor l�quido de R$ "##//", o qual, devidamente rubricado pelas partes, � parte integrante do presente Termo de Quita��o." 
	nL += 35
	oPrint:say (nL+nPT,140		,STR0158, oFont08)
EndIf

nL += 70

oPrint:say (nL+nPT,140		," __________________________/___, ____ de __________________________ de ________ " , oFont10) 

nL := nL + nAddl * 2

//oPrint:say (nL+nPT,140		," ___________________________________________________________ " , oFont08)  
oPrint:say (nL+nPT,140		," _____________________________________________________________________ " , oFont08) 
   
IF ALLTRIM(MV_PAR27) == "" .AND. ALLTRIM(MV_PAR28) == ""
	oPrint:say (nL+nPT+35,140		,STR0129 , oFont09) //150 Assinatura do Empregador ou Preposto
ELSE
	oPrint:say (nL+nPT+35,140		,STR0129 + " - " + ALLTRIM(MV_PAR28) + " RG: " + ALLTRIM(MV_PAR27), oFont09) //150 Assinatura do Empregador ou Preposto
END

nL := nL + nAddl * 2

oPrint:say (nL+nAddL,140,"_________________________________________________________", oFont08) 
oPrint:say (nL+nAddL+nPT+30,150,STR0133, oFont09)//-- 151 Assinatura do Trabalhador

oPrint:say (nL+nAddL,1200,"_________________________________________________________", oFont08) 
oPrint:say (nL+nAddL+nPT+30,1215,STR0134, oFont09)//-- 152 Assinatura do Respons�vel Legal do Trabalhador

If lHomolog
	nL := nL + nAddl * 2
	oPrint:say (nL+nAddL,140,"_________________________________________________________", oFont08) 
	oPrint:say (nL+nAddL+nPT+40,150,STR0148, oFont09)//-- "153 Carimbo e Assinatura do Assistente"                                                                                                                                                                                                                                                                                                                                                                                                                                                                            

	oPrint:say (nL+nAddL,1200,"_________________________________________________________", oFont08) 
	oPrint:say (nL+nAddL+nPT+40,1215,STR0149, oFont09)//-- "154 Nome do �rg�o Homologador"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

	nL:=nL+(nAddL*2)+(nPT)+15

	oPrint:Box(nL,135,nL+((nAddL+nPT)*12.5) - 60,nColMax) //BOX
	oPrint:say (nL+nPT+5,160,STR0150, oFont09)//-- "155 Ressalvas"

	nL := nL + ( ( nAddl + nPT + nPD ) * 6 ) - 60
Else
	nL := nL + nAddl * 2
	nL:=nL+(nAddL*2)+(nPT)+15	
	nL := nL + ( ( nAddl + nPT + nPD ) * 6 ) - 60
EndIf

nL:=nL+20+nPT

If !lHomolog
	nL+=95
	oPrint:Box((nL+((nAddL+nPT)*1.4)),135,(nL+((nAddL+nPT)*2.0))+55,nColMax) //BOX
Endif

oPrint:say (nL+((nAddL+nPT)*1.4)+25+nPT,160,STR0135, oFont09)//-- "156 Informa��es � CAIXA:"

nL:=nL+20 

If lHomolog                                                                             
	oPrint:line((nL+((nAddL+nPT)*1.4)),135 ,(nL+((nAddL+nPT))*1.4),nColMax) 		//Linha Horizontal  
Endif


nL:=(nL+((nAddL+nPT)*2.0))+35

oPrint:FillRect( {nL, 135, nL+nPD+nPD+nPD+45, nColMax+01}, oBrush1 )
oPrint:say (nL,480			,STR0115, oFont12n) //"A ASSIST�NCIA NO ATO DA RESCIS�O CONTRATUAL � GRATUITA."
oPrint:say (nL+nPD+10,180		,STR0116, oFont09n) //"Pode o trabalhador iniciar a��o judicial quanto aos cr�ditos resultantes das rela��es de trabalho at� o limite de dois anos ap�s a extin��o do contrato de trabalho"
oPrint:say (nL+nPD+nPD+10,400	,STR0117, oFont09n) //"(Inc. XXIX, Art.7� da Constitui��o Federal/1988)."


oPrint:EndPage()

//FIM DA IMPRESSAO DO TEMRO DE QUITACAO DE RESCISAO

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fNewLine  � Autor � Kelly Soares          � Data � 20.01.11 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Inicia nova linha na impressao das verbas rescisorias.     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � RdMake                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fNewLine()

If nXCol = 3
	nXCol := 0
	nL+=nAddL+05
	oPrint:line(nL,135,nL,nColMax )		
Endif
nXCol++

//Verifica se atingiu o limite de linhas e efetua a quebra da pagina
fVerQuebra(1)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �PenunSal  � Autor � Mauricio MR		    � Data � 16.02.11 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Obtem o penultimo salario do funcionario antes da demissao.���
�������������������������������������������������������������������������Ĵ��
���Uso       � IMPRESH                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

Static Function PenunSal(dAdmissao, dDemissao, cVerbas, cFolMes, cVerbSal)

Local nEpoch	:= Set( _SET_EPOCH  )	//Obtem a configuracao de seculo corrente

Local aArea		:= GetArea()
Local aSRCArea	:= SRC->(GetArea())

//-- Data do Penultimo Salario.
Local dDTPenSal 
Local nValPenSal     
Local cFilMat	:= SRA->(RA_FILIAL+RA_MAT)

DEFAULT dAdmissao	:= SRA->RA_ADMISSA	
DEFAULT	dDemissao  	:= SRG->RG_DATADEM  
DEFAULT	cVerbas		:= ''  
DEFAULT cFolMes		:= SuperGetMv("MV_FOLMES")  
DEFAULT cVerbSal	:= acodfol[318,1]


Set( _SET_EPOCH , 1920 )	//Altera o Set Epoch para 1920

dDTPenSal := If(Month(dDemissao)-1 != 0, CtoD('01/' +StrZero(Month(dDemissao)-1,2)+'/'+Right(StrZero(Year(dDemissao),4),2)),CtoD('01/12/'+Right(StrZero(Year(dDemissao)-1,4),2)) )

If MesAno(dDtPenSal) < MesAno(dAdmissao)
	dDTPenSal 	:= CTOD("  /  /  ")
	nValPenSal 	:= 0.00
Endif
//--Penultimo 
If !Empty(dDTPenSal)              
	nValPenSal := fBuscaAcm(cVerbas + cVerbSal  ,,dDTPenSal,dDTPenSal,"V")	//-- Salario do mes + verbas que incorporaram  ao salario
	//--Pesquisa no movimento mensal quando o mes corrente estiver aberto
	//--e nao encontrar salario nos acumulados anuais.
	If nValPenSal == 0 .And. MesAno(dDTPenSal) == cFolMes
		If SRC->(Dbseek(cFilMat))
			While !SRC->(eof()) .And. cFilMat == SRC->(RC_FILIAL+RC_MAT)
				If SRC->RC_PD $cVerbas + cVerbSal
					nValPenSal += SRC->RC_VALOR
				Endif
				SRC->(dbskip())
			Enddo
		Endif
	Endif
Endif             

/*/
������������������������������������������������������������Ŀ
�Restaura o Set Epoch Padrao								 �
��������������������������������������������������������������/*/
Set( _SET_EPOCH , nEpoch )
	
RestArea(aSRCArea)
RestArea(aArea)

Return(nValPenSal)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fVerQuebra� Autor � Allyson M	            � Data � 25.03.13 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica se quebra linha e finaliza os box e ilinhas.      ���
�������������������������������������������������������������������������Ĵ��
���Uso       � RdMake                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fVerQuebra( nTipo, lLinhas )

Default lLinhas := .T.

If nL > 3290   

	//Quebra nos proventos
	If nTipo == 1
		lQuebraP := .T.    
	//Quebra nos descontos
	Else
		lQuebraD := .T.
	EndIf
	//Fecha o box e cria as linhas verticais
	oPrint:Box( nBoxIni,  135,nL,nColMax )
	If lLinhas
		oPrint:line(nBoxIni,nCl01b+20,nL,nCl01b+20 )
		oPrint:line(nBoxIni,nCl02a,nL,nCl02a )
		oPrint:line(nBoxIni,nCl02b+20,nL,nCl02b+20 )
		oPrint:line(nBoxIni,nCl03a,nL,nCl03a )
		oPrint:line(nBoxIni,nCl03b+20,nL,nCl03b+20 )  
	EndIf
	
	oPrint:EndPage()  //Termina a p�gina
	oPrint:StartPage()//Inicia uma nova pagina

	//Se imprime cabecalho novamente
	If lImpCabec
		//Imprime o cabecalho da rescisao novamente (Campos 01 a 32)
		fCabec()
		//Quebra nos proventos
		If nTipo == 1
			oPrint:say (nL+nSubT,nCl01a+30,STR0036, oFont09n) //-- "VERBAS RESCIS�RIAS"
			nL := nL+nSubT
			nBoxIni := nL      
			oPrint:say (nL+02+nSubT,nCl01a+30		,STR0037	, oFont09n) //"RUBRICAS"
			oPrint:say (nL+02+nSubT,nCl01b+30		,STR0038	, oFont09n) //"VALOR"
			oPrint:say (nL+02+nSubT,nCl02a+30		,STR0037	, oFont09n) //"RUBRICAS"
			oPrint:say (nL+02+nSubT,nCl02b+30		,STR0038	, oFont09n) //"VALOR"
			oPrint:say (nL+02+nSubT,nCl03a+30		,STR0037	, oFont09n) //"RUBRICAS"
			oPrint:say (nL+02+nSubT,nCl03b+30		,STR0038	, oFont09n) //"VALOR" 
		//Quebra nos descontos
		Else
			//oPrint:Box(nL, 035,nL+nSubT, nColMax ) 									
			oPrint:say (nL+nSubT,nCl01a+30,STR0073, oFont09n)	//"DEDU��ES"
			nL := nL+nSubT
			nBoxIni := nL
			oPrint:say (nL+02+nSubT,nCl01a+30   ,STR0074, oFont09n)	 //"DESCONTO"
			oPrint:say (nL+02+nSubT,nCl01b+30	,STR0038, oFont09n) 	 //"VALOR"
			oPrint:say (nL+02+nSubT,nCl02a+30	,STR0074, oFont09n) 	 //"DESCONTO"
			oPrint:say (nL+02+nSubT,nCl02b+30	,STR0038, oFont09n) 	 //"VALOR"
			oPrint:say (nL+02+nSubT,nCl03a+30	,STR0074, oFont09n) 	 //"DESCONTO"
			oPrint:say (nL+02+nSubT,nCl03b+30	,STR0038, oFont09n) 	 //"VALOR"
		EndIf
		nL += nSubT	
		oPrint:line(nL,135,nL,nColMax )
		nL += nSubT + 1
	Else
		nL := nBoxIni := 077
	EndIf  
	nPagina+= 1
EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fCabec	� Autor � Allyson M	            � Data � 06.05.13 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime o cabecalho da Rescisoa.      					  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � RdMake                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fCabec( nTipo, lLinhas )

nL:=078

oBrush1 := TBrush():New( ,  RGB(197,197,197)  )  
oBrush2	:=  TBrush():New( ,  CLR_WHITE  )  
oPrint:FillRect( {nL, 135, nL+(nTit-60)+nTit, nColMax}, oBrush1 )

oPrint:Box(nL, 135,nL+(nTit-50)+(nTit+10)+nPT+10+nTit+nTit+(nTit*3)+20+nPT+nTit+(nTit*4)+nTit+(nTit*3)+540   , nColMax ) 		//-- Box p/ Tit. "TERMO DE RESCIS�O DO CONTRATO DE TRABALHO"

nL:=nL+nTit-60
oPrint:say (nL,537,STR0003, oFont13n) //-- "TERMO DE RESCIS�O DO CONTRATO DE TRABALHO"
                                              
oPrint:FillRect( {nL+nTit, 037, nL+nTit+nSubT-15, nColMax+10}, oBrush2 )
oPrint:line(nL+nTit,135 ,nL+nTit,nColMax) 			//Linha Horizontal
nL:=nL+nTit
//oPrint:line(nL,035 ,nL,nColMax) 			//Linha Horizontal

oPrint:FillRect( {nL+nSubT-15, 137, nL+nSubT+nSubT-15, nColMax}, oBrush1 )
oPrint:line(nL+nSubT-15,135 ,nL+nSubT-15,nColMax)
nL:=nL+nSubT+nPT-15
oPrint:say (nL-05,890,STR0002, oFont09n) 	//-- "IDENTIFICA��O DO EMPREGADOR"



//����������������������������������������������������������������������������Ŀ
//�IDENTIFICACAO DO EMPREGADOR                                                 �
//������������������������������������������������������������������������������
nL:=nL+nSubT+05
//oPrint:Box( nL , 0035 , nL+(nAddL*3) ,nColMax ) 	//-- Box Identificacao do Trabalhador
                                 

//����������������������������������������������������������������������������Ŀ
//�Efetua a impressao do texto na vertical                                     �
//������������������������������������������������������������������������������

oPrint:line(nL-10,135 ,nL-10,nColMax) 							//Linha Horizontal
oPrint:line(nL-10,635 ,nL+nAddL,635 )							//Linha Vertical Meio
oPrint:say (nL+05,155,STR0056, oFont08) 		 			//"01- CNPJ/CEI: 	
oPrint:say (nl+05,650,STR0001, oFont08)					//"02- Raz�o Social / Nome:"
oPrint:say (nL+nPD,175 ,SUBSTR(aInfo[8]+Space(20),1,20), oFont10 ) //"|01- CNPJ: 
oPrint:say (nL+nPD,665 ,aInfo[3], oFont10 )					//"02- Razao Social / Nome:"

oPrint:line(nL+nAddL,135 ,nL+nAddL,nColMax) 				//Linha Horizontal	
oPrint:line(nL+nAddL,1580,nL+(nAddL*2)+10,1580)				//Linha Vertical Meio	BAIRRO
oPrint:say (nL+nAddL+05,155 ,"03 "+STR0005, oFont08)      	//"Endere�o (Logradouro, n�, andar, apartamento)"
oPrint:say (nL+nAddL+05,1620,"04 "+STR0014, oFont08)		//04 Bairro : "
oPrint:say (nL+nAddL+nPD,175 ,aInfo[4], oFont10)			//03 Endereco   : "
oPrint:say (nL+nAddL+nPD,935 ,aInfo[14], oFont10)			//03 Complemento
oPrint:say (nL+nAddL+nPD,1635,aInfo[13], oFont10)	   		//04 Bairro : "
	
oPrint:line(nL+(nAddL*2)+10,900 ,nL+(nAddL*3)+20,900 )		//Linha Vertical Meio
oPrint:line(nL+(nAddL*2)+10,1080,nL+(nAddL*3)+20,1080)		//Linha Vertical Meio
oPrint:line(nL+(nAddL*2)+10,1300,nL+(nAddL*3)+20,1300)		//Linha Vertical Meio	
oPrint:line(nL+(nAddL*2)+10,1580,nL+(nAddL*3)+20,1580)  		//Linha Vertical Meio
oPrint:line(nL+(nAddL*2)+10,0135,nL+(nAddL*2)+10,nColMax) 		//Linha Horizontal
oPrint:say (nL+(nAddL*2)+15,155 ,"05 "+STR0015, oFont08)										//"|05 Munic.: "
oPrint:say (nL+(nAddL*2)+15,920 ,"06 "+STR0016, oFont08)										//"|06 UF : "
oPrint:say (nL+(nAddL*2)+15,1100,"07 "+STR0013, oFont08)								   		//"|07 Cep: "
oPrint:say (nL+(nAddL*2)+15,1320,"08 "+STR0017, oFont08)										//"|08 CNAE " 
oPrint:say (nL+(nAddL*2)+15,1600,"09 "+STR0004, oFont08)										//"|09 CNPJ/CEI Tomador/Obra: "

oPrint:say (nL+(nAddL*2)+10+nPD,175 ,aInfo[5] , oFont10)									  	 	//"|05 Munic.: "
oPrint:say (nL+(nAddL*2)+10+nPD,920 ,aInfo[6] , oFont10)									 	  	//"|06 UF : "
oPrint:say (nL+(nAddL*2)+10+nPD,1120,aInfo[7] , oFont10)									  		//"|07 Cep: "
oPrint:say (nL+(nAddL*2)+10+nPD,1310,aInfo[16], oFont10)									  		//"|08 CNAE"
oPrint:say (nL+(nAddL*2)+10+nPD,1600,Substr(fDesc("CTT",SRA->RA_CC,"CTT_CEI")+Space(5),1,15), oFont10)//"|09 CNPJ/CEI Tomador/Obra: "

//����������������������������������������������������������������������������Ŀ
//�IDENTIFICACAO DO TRABALHADOR                                                �
//������������������������������������������������������������������������������
//nL:=535
nL:=nL+(nAddL*3)+20 

//oPrint:Box(nL, 035,nL+81+(nAddL*4), nColMax ) 	//-- Box p/ Tit. Identificacao do Trabalhador  
oPrint:FillRect( {nL, 137, nL+nSubT, nColMax}, oBrush1 )
oPrint:line(nL,135 ,nL,nColMax) 		//Linha Horizontal	
oPrint:say (nL+05,880,STR0006, oFont09n)			//"IDENTIFICA��O DO TRABALHADOR"  
oPrint:line(nL+nSubT,135 ,nL+nSubT,nColMax) 		//Linha Horizontal	//-- Identificacao do Trabalhador 
nL:=nL+nSubT										//-- Identificacao do Trabalhador 
nL:=nL+nPT


oPrint:say (nL+nPT,155 ,STR0025, oFont08) 		//"10 PIS/PASEP:" 
oPrint:say (nL+nPT,525 ,STR0023, oFont08)		//"11 NOME:"
oPrint:line(nL+nAddL+10,135 ,nL+nAddL+10,nColMax) //Linha Horizontal
oPrint:line(nL,505 ,nL+nAddL+nPT,505 )				//Linha Vertical Meio	

oPrint:say (nL+nPD,175 ,SRA->RA_PIS,oFont10) //PIS
If SRA->(FieldPos("RA_NOMECMP")) # 0 .And. !Empty(SRA->RA_NOMECMP)
	oPrint:say (nL+nPD,540 ,Subs(SRA->RA_NOMECMP+Space(60),1,60),oFont10) //NOME
Else
	oPrint:say (nL+nPD,540 ,Subs(SRA->RA_NOME+Space(30),1,30),oFont10) //NOME
EndIf	
	
oPrint:say (nL+nAddL+nPT+15,155 ,"12 "+STR0005, oFont08)  	//"Endere�o (Logradouro, n�, andar, apartamento)"
oPrint:say (nL+nAddL+nPT+15,1825,"13 "+STR0014, oFont08)	  	//"|04 Bairro : "
If SRA->(FieldPos("RA_NUMENDE")) # 0 .And. !Empty(SRA->RA_NUMENDE) 
	oPrint:say (nL+nAddL+nPD+15,175 ,Subs(SRA->RA_ENDEREC+', '+SRA->RA_NUMENDE+Space(40),1,40),oFont10) // "|03 Endereco + Numero de Endere�o
Else
	oPrint:say (nL+nAddL+nPD+15,175 ,Subs(SRA->RA_ENDEREC+Space(30),1,30),oFont10)	//"|03 Endereco   : "
EndIf
oPrint:say (nL+nAddL+nPD+15,935 ,SRA->RA_COMPLEM, oFont10)	//"|03 Complemento
oPrint:say (nL+nAddL+nPD+15,1840,SRA->RA_BAIRRO, oFont10)		//"|04 Bairro : "
oPrint:line(nL+(nAddL*2)+20,135 ,nL+(nAddL*2)+20,nColMax) 		//Linha Horizontal
oPrint:line(nL+nAddL+10,1805,nL+(nAddL*2)+20,1805)				//Linha Vertical Meio	

oPrint:say (nL+(nAddL*2)+nPT+20,155 ,"14 "+STR0015, oFont08)	//"|Munic.: "
oPrint:say (nL+(nAddL*2)+nPT+20,720 ,"15 "+STR0016, oFont08)	//"|UF : "
oPrint:say (nL+(nAddL*2)+nPT+20,1020,"16 "+STR0013, oFont08)	//"|Cep: "
oPrint:say (nL+(nAddL*2)+nPT+20,1370,"17 "+STR0024, oFont08)	//"|CTPS"
oPrint:say (nL+(nAddL*2)+nPT+20,1825, STR0012, oFont08)		//18 CPF:"

oPrint:say (nL+(nAddL*2)+nPD+20,175 ,SRA->RA_MUNICIP, oFont10)	//"|Munic.: " 
oPrint:say (nL+(nAddL*2)+nPD+20,740 ,SRA->RA_ESTADO , oFont10)	//"|UF : "
oPrint:say (nL+(nAddL*2)+nPD+20,1035,SRA->RA_CEP , oFont10)		//"|Cep: "
oPrint:say (nL+(nAddL*2)+nPD+20,1385,SRA->RA_NUMCP+"- "+SRA->RA_SERCP+"/"+SRA->RA_UFCP, oFont10)	//"|CTPS"
oPrint:say (nL+(nAddL*2)+nPD+20,1840,SRA->RA_CIC, oFont10)		//18 CPF:"

oPrint:line(nL+(nAddL*3)+30,135 ,nL+(nAddL*3)+30,nColMax) 	//Linha Horizontal 
oPrint:line(nL+(nAddL*2)+20,700 ,nL+(nAddL*3)+30,700 )		//Linha Vertical Meio	
oPrint:line(nL+(nAddL*2)+20,1000,nL+(nAddL*3)+30,1000)		//Linha Vertical Meio	
oPrint:line(nL+(nAddL*2)+20,1350,nL+(nAddL*3)+30,1350)		//Linha Vertical Meio	
oPrint:line(nL+(nAddL*2)+20,1805,nL+(nAddL*3)+30,1805)		//Linha Vertical Meio	

oPrint:say (nL+(nAddL*3)+nPT+30,155 , STR0027, oFont08)		//19 Nasc.:"
oPrint:say (nL+(nAddL*3)+nPT+30,510, STR0007, oFont08)		//20 Nome da Mae"
oPrint:say (nL+(nAddL*3)+nPD+30,180 , DtoC(SRA->RA_NASC), oFont10)	//19 Nasc.:"
oPrint:say (nL+(nAddL*3)+nPD+30,520, SUBSTR(SRA->RA_MAE+Space(30),1,40), oFont10)	//20 Nome da Mae"  
oPrint:line(nL+(nAddL*3)+30,0500,nL+(nAddL*4)+40,0500)	//Linha Vertical Meio	

nL:=nL+(nAddL*4)+40
//����������������������������������������������������������������������������Ŀ
//�DADOS DO CONTRATO	                                                       �
//������������������������������������������������������������������������������
//oPrint:Box(nL, 035,nL+70+80+(nAddL*3), nColMax ) 	//-- Box p/ Tit. "DADOS DO CONTRATO"   
oPrint:FillRect( {nL, 137, nL+nSubT, nColMax}, oBrush1 )

oPrint:Line(nL,135,nL,nColMax) //Linha Horizontal
oPrint:say (nL+05,997,STR0008, oFont09n) //-- "DADOS DO CONTRATO"

nL:=nL+nSubT
oPrint:Box(nL+nTip,135,nL,nColMax) //Linha Horizontal

oPrint:say (nL+nPT,155	,STR0009	  , oFont08) //"21 Tipo de Contrato" 
oPrint:say (nL+nPD,180	,If( ( ( SRA->RA_TPCONTR=="1" ) .or. Empty(SRA->RA_TPCONTR)),;
								STR0010 ,;//"1. Contrato de trabalho por prazo indeterminado"
								If(SRA->RA_CLAURES=="1", STR0011, STR0018)), oFont10)  //"2. Contrato de trabalho por prazo determinado com cl�usula assecurat�ria de direito rec�proco de rescis�o antecipada."##"3. Contrato de trabalho por prazo determinado sem cl�usula assecurat�ria de direito rec�proco de rescis�o antecipada."

nL:=nL+nTip-5
oPrint:say (nL+nPT,155,STR0019, oFont08) //"22 Causa do Afastamento" 
oPrint:say (nL+nPD,180,Left(cCausa,100), oFont10) 

oPrint:say (nL+nTip+nPT+10,155	,STR0020	, oFont08) //"23 Remunera��o M�s Ant."
aAreaSRD:=GetArea()
nOrderSRD:=SRD->(DbSetOrder())

nPenunSal:= PenunSal(SRA->RA_ADMISSA, SRG->RG_DATADEM, cVerbas_Aux, /*cFolMes*/, acodfol[318,1])

IF Empty(nPenunSal)  
	nPenunSal:= SRG->RG_SALMES
Endif

oPrint:say (nL+nTip+nPD+10,180	,Transform(nPenunSal,"@E 999,999,999.99"), oFont10)  

DbSelectArea(aAreaSRD)

fPHist82(SRA->RA_FILIAL ,"32",SRG->RG_TIPORES+"  ",57,3,@cCodAfa)

oPrint:say (nL+nTip+nPT+10,586+15,STR0021	, oFont08) //"24 Data de Admiss�o"
oPrint:say (nL+nTip+nPD+10,586+30,DtoC(SRA->RA_ADMISSA), oFont10) 
oPrint:say (nL+nTip+nPT+10,972+15,STR0022, oFont08) //"25 Data do Aviso Pr�vio"
oPrint:say (nL+nTip+nPD+10,972+30,DtoC(SRG->RG_DTAVISO), oFont10) 
oPrint:say (nL+nTip+nPT+10,1358+15,STR0026, oFont08)//"26 Data de Afastamento" 
oPrint:say (nL+nTip+nPD+10,1358+30,DtoC(SRG->RG_DATADEM), oFont10) 
oPrint:say (nL+nTip+nPT+10,1758+15,STR0155	, oFont08) //"27 C�d. Afastamento"
oPrint:say (nL+nTip+nPD+10,1758+30,cCodAfa, oFont10) 

oPrint:line(nL+nTip,576,nL+nTip+nAddL+10,576)	//Linha Vertical Meio	
oPrint:line(nL+nTip,962,nL+nTip+nAddL+10,962)	//Linha Vertical Meio	
oPrint:line(nL+nTip,1348,nL+nTip+nAddL+10,1348)	//Linha Vertical Meio
oPrint:line(nL+nTip,1748,nL+nTip+nAddL+10,1748)	//Linha Vertical Meio
oPrint:line(nL+nTip,135 ,nL+nTip,nColMax) 	//Linha Horizontal
          

oPrint:say (nL+nTip+nAddL+nPT+10,155,STR0029	, oFont08) //"28 Pens�o Alim. (%) (TRCT)"
oPrint:say (nL+nTip+nAddL+nPD+10,180,Transform(nPerPensa,"@E 999.99"), oFont10) 
oPrint:say (nL+nTip+nAddL+nPT+10,572+15,STR0030	, oFont08) //"29 Pens�o Alim. (%) (FGTS)"
oPrint:say (nL+nTip+nAddL+nPD+10,572+30,Transform(nPerFGTS,"@E 999.99"), oFont10) 
oPrint:say (nL+nTip+nAddL+nPT+10,1158+15,STR0031	, oFont08)//"30 Categoria do Trabalhador" 
oPrint:say (nL+nTip+nAddL+nPD+10,1158+30,cCateg, oFont10) 
                                                  	
oPrint:line(nL+nTip+nAddL+10,0562,nL+nTip+(nAddL*2)+20,562 )										//Linha Vertical Meio	
oPrint:line(nL+nTip+nAddL+10,1148,nL+nTip+(nAddL*2)+20,1148)										//Linha Vertical Meio	
oPrint:line(nL+nTip+nAddL+10,135 ,nL+nTip+nAddL+10,nColMax) 									//Linha Horizontal

IF MV_PAR25 == 1
	cOrgao	:=	fGetOrgao(SRA->RA_SINDICA,xFilial("RCE"))
ElseIf MV_PAR25 == 2
	cOrgao	:=	fGetOrgao(MV_PAR26,xFilial("RCE"))
Else                                            
	cOrgao	:=	""
EndIf

oPrint:say (nL+nTip+(nAddL*2)+nPT+30,155	,STR0033	, oFont08) //"31 Codigo Sindical"
oPrint:say (nL+nTip+(nAddL*2)+nPT+30,576+15 ,STR0140	, oFont08) //"32 CNPJ e Nome da Entidade Sindical Laboral"
If MV_PAR25 <> 3                      
	If ( SRA->RA_VIEMRAI <> "20" .AND. SRA->RA_VIEMRAI <> "25" )
		oPrint:say (nL+nTip+(nAddL*2)+30+nPD,180	,RCE->RCE_ENTSIN, oFont10) 
	Endif
	oPrint:say (nL+nTip+(nAddL*2)+nPD+30,576+30,RCE->RCE_CGC+" "+RCE->RCE_DESCRI, oFont10)  
Endif	

oPrint:line(nL+nTip+(nAddL*2)+20,576,nL+nTip+(nAddL*3)+30,576 )											//Linha Vertical Meio	
oPrint:line(nL+nTip+(nAddL*2)+20,135 ,nL+nTip+(nAddL*2)+20,nColMax) 										//Linha Horizontal

nL:=nL+nTip+(nAddL*3)+30

oPrint:FillRect( {nL, 135, nL+nSubT, nColMax}, oBrush1 )
oPrint:Box(nL, 135,nL+(nSubT*3), nColMax ) 	//-- Box p/ Tit. "DISCRIMINA��O DAS VERBAS RESCIS�RIAS"
oPrint:say (nL+05,805,STR0035, oFont09n) 	//-- "DISCRIMINA��O DAS VERBAS RESCIS�RIAS"

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fDesconto � Autor � Gustavo M		        � Data � 20/06/13 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Quebra de linha para os descontos.						  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � IMPRESH                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
Static Function fDesconto(nValLin)

nValLin++
If nValLin > 3
	nL+=nAddL+05
 	oPrint:line(nL,135,nL,nColMax )
   	fVerQuebra(2)
   	nValLin := 1
Endif
 
Return