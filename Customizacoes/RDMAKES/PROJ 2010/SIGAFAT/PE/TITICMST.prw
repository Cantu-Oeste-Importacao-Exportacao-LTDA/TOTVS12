#include "protheus.ch" 

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �TITICMST  �Autor  �Paulo D. Ferreira   � Data �  27/06/2010    ���
����������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada localizado no momento da grava��o do 	     ���
���			   titulo financeiro de impostos ICMS/ST na fun��o GravaTit(),   ���
���			   deve ser utilizado para complementar a grava��o do titulo     ���
���			   gerado pelos programas MATA461 (Nota Fiscal de Sa�da) ou      ���
���			   MATA103 (Nota Fiscal de Entrada) Atrav�s da configura��o      ���
���			   via F12 para gerar titulos de ICMS-ST, o registro da tabela   ���
���			   SE2 esta posicionado, � passado como parametro para o ponto   ���
���			   o nome a rotina que esta sendo executada no momento para      ���
���			   facilitar o desenvolvimento  de situa��es especificas 	     ���
���			   dentro do ponto de entrada.                                   ���
���          �                                                               ���
����������������������������������������������������������������������������͹��
���Uso       � Espec�fico Cliente:                                           ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/

User Function TITICMST()
                    
Local aArea			:= GetArea()
Local cOrigem		:= PARAMIXB[1]  
Local cTipoImp 		:= PARAMIXB[2]

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())
          
//��������������������������������������������������������������������������
//�Efetua replica��o da informa��o do Segmento e Centro de Custos ao t�tulo�
//��������������������������������������������������������������������������

// DFT - 06/04/2015
// MILDESK: 15581
// QUANDO TITULO FOR GERADO PELO FATURAMENTO  
If AllTrim(cOrigem)=="MATA460A"  
	
	If cTipoImp == "3" //ICMS-ST
	  
		/* NAO � NECESSARIO POSICIONAR NA SC5, POIS NO FATURAMENTO J� EST� POSICIONADO
		dbSelectArea("SC5")
		SC5->(dbSetOrder(1))
		SC5->(dbGoTop())
		SC5->(dbSeek(xFilial("SC5") + SD2->D2_PEDIDO))
		*/         
		
		
		//ABRE UMA SEGUNDA SE2 PARA PESQUISAR SE O TITULO J� EXISTE COM A CHAVE FILIAL+PREFIXO+NUM+TIPO+PARCELA+FORNECE+LOJA
		If Select("NEWSE2") != 0
			NEWSE2->(dbCloseArea())
		EndIf
		
		cPrefixo	:= SE2->E2_PREFIXO 
		cNumero 	:= SF2->F2_DOC  //MUDA PARA NUMERO DA NOTA FISCAL
		cParcela	:= SE2->E2_PARCELA
		cTipo		:= SE2->E2_TIPO
		cFornece	:= SE2->E2_FORNECE
		cLoja		:= SE2->E2_LOJA
		
		If ( ChkFile("SE2",.F.,"NEWSE2") )
			
			DbSelectArea("NEWSE2")                                               
			
			// PROCURA SE O TITULO JA EXISTE PARA INCREMENTAR O NUMERO DE PARCELA
			NEWSE2->(dbSetOrder(1))
			NEWSE2->(dbGoTop())
			While NEWSE2->(dbSeek(xFilial("SE2")+cPrefixo+cNumero+cParcela+cTipo+cFornece+cLoja)) 
				cParcela	:=	Soma1(cParcela, TAMSX3("E2_PARCELA")[1])
				NEWSE2->(dbSkip())
			Enddo
			NEWSE2->(dbCloseArea())
		
		EndIf
	
		//SE2->E2_PREFIXO	:= "ICM"
		SE2->E2_NUM			:= cNumero //SF2->F2_DOC   
		SE2->E2_PARCELA		:= cParcela
		SE2->E2_NATUREZ 	:= GETMV("MV_X_NATST")
		SE2->E2_VENCTO		:= dDataBase
		SE2->E2_VENCREA		:= DataValida( dDataBase )
		SE2->E2_HIST		:= "ICMS ST NF. " + ALLTRIM(SF2->F2_SERIE)+" - "+ ALLTRIM(SF2->F2_DOC)  
		SE2->E2_CLVLDB 		:= SC5->C5_X_CLVL
		SE2->E2_CCD			:= SC5->C5_X_CC
	EndIf
	
	//-- Titulos de Difal e FECP grava n�mero da nota nos hist�ricos
	If cTipoImp == "B" 
		SE2->E2_HIST	:= "DIFAL NF. " + ALLTRIM(SF2->F2_SERIE)+" - "+ ALLTRIM(SF2->F2_DOC)  	
	EndIf
Endif
	
                
RestArea(aArea)

Return ({SE2->E2_NUM,SE2->E2_VENCTO})
