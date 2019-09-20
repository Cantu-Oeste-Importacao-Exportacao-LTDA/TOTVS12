#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

User Function F050REL()     

Local lAdjustToLegacy := .F.
Local lDisableSetup := .T.
Local cLocal := "\spool"     
Local cNomeArq := "comprovante-" + ALLTRIM(SE2->E2_NUM) +".rel"
Local oPrinter       
Local nLin	:= 0   
Local bCondicao   


//-- Posiciona nas tabelas relacionadas
dbSelectArea("SM0") 
dbSeek(cEmpAnt+cFilAnt)	

dbSelectArea("SA2")
SA2->(dbSetOrder(1))
SA2->(dbSeek(xFilial("SA2") + SE2->E2_FORNECE + SE2->E2_LOJA))

bCondicao := {|| SEA->EA_NUMBOR == SE2->E2_NUMBOR .And. SEA->EA_NUM == SE2->E2_NUM .And. SEA->EA_PREFIXO == SE2->E2_PREFIXO .And. SEA->EA_PARCELA == SE2->E2_PARCELA}
cCondicao := "SEA->EA_NUMBOR == SE2->E2_NUMBOR .And. SEA->EA_NUM == SE2->E2_NUM .And. SEA->EA_PREFIXO == SE2->E2_PREFIXO .And. SEA->EA_PARCELA == SE2->E2_PARCELA"

dbSelectArea("SEA")
SEA->(dbSetOrder(1))
SEA->(dbSetFilter(bCondicao,cCondicao))     
SEA->(dbGoBottom())
                       
dbSelectArea("SX5")
SX5->(dbSetOrder(1))
SX5->(dbSeek(xFilial("SX5")+ "59" + SEA->EA_TIPOPAG))  

dbSelectArea("SE5")
SE5->(dbSetOrder(7))
SE5->(DbSeek(xFilial("SE5") + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA))

//-- Valida em todas as baixas da parcela para encontrar se alguma tem autorização preenchida
While SE2->E2_FILIAL == SE5->E5_FILIAL .And. SE2->E2_NUM == SE5->E5_NUMERO .And. SE2->E2_PREFIXO == SE5->E5_PREFIXO .And. SE2->E2_PARCELA == SE5->E5_PARCELA;
  				.And. SE2->E2_FORNECE == SE5->E5_CLIFOR .And. SE2->E2_LOJA == SE5->E5_LOJA  
  If !Empty(SE5->E5_AUTBCO)  //-- Se encontrar autorização de uso sai do While
  	Exit
  Else
  	SE5->(dbSkip())
  EndIf
EndDo

//-- Só deve gerar comprovante se tiver autorização do banco
If Empty(SE5->E5_AUTBCO)
	Alert("Não existe comprovante de pagamento para esse título.")
	Return
EndIf  
                     
//-- Inicializa componente do relatório
oPrinter := FWMSPrinter():New(cNomeArq, IMP_PDF, lAdjustToLegacy,cLocal, lDisableSetup, , , , , , .F., )


//oTFont := TFont():New('Courier new',,-16,.T.)
oFont1N := TFont():New("Arial",09,08,,.T.,,,,,.F.)            // Título das Grades 
oFont3 	:= TFont():New("Arial",09,25,,.F.,,,,,.F.)            // Dados do Recibo de Entrega 
oFont4	:= TFont():New("Arial",09,12,,.T.,,,,,.F.)            // Codigo de Compensação do Banco
Private oFnt16  := TFont():New( "Arial",, -12, ,.T.) 


oPrinter:Line(nLin:=nLin+10, 010, nLin:=nLin+10, 580)

//-- Valida se existe imagem de logo pra por no boleto, senão imprime o nome do banco
if fValImage(SEA->EA_PORTADO)
	oPrinter:sayBitmap(nLin+10,30,"/system/"+SEA->EA_PORTADO+".bmp",115,26)
Else
	oPrinter:Say(nLin+10,100,SEA->EA_PORTADO,oFont3,100) //
EndIf

oPrinter:Say(nLin+=15, 250, "Comprovante Pagamento ",oFnt16)    
oPrinter:Say(nLin+=10, 240, SX5->X5_DESCRI)    
oPrinter:Line(nLin+=10, 010, nLin+=10, 580, , "-4")             
oPrinter:Say(nLin+=20, 200, "Identificação no extrato: SISPAG FORNECEDORES")    
oPrinter:Line(nLin  , 010, nLin+=10, 580)


//-- Informações do pagador
oPrinter:Say(nLin+=10, 030, "Dados da conta debitada:",oFont1N)
oPrinter:Say(nLin+=10, 100, "Nome: " + SM0->M0_NOMECOM)
oPrinter:Say(nLin+=10, 100, "Agência: " + SEA->EA_AGEDEP)
oPrinter:Say(nLin    , 200, "Conta: " + SEA->EA_NUMCON)

//-- Dados do favorecido
oPrinter:Line(nLin+=10, 010, nLin+=10, 580)
oPrinter:Say(nLin+=10, 030, "Dados da conta creditada:")
oPrinter:Say(nLin+=10, 100, "Nome do favorecido: " + SA2->A2_NOME)
oPrinter:Say(nLin+=10, 100, "CPF/CNPJ: " + SA2->A2_CGC)                      

//-- Posiciona no SX5 para buscar a descrição do banco
dbSelectArea("SX5")
SX5->(dbSetOrder(1))
SX5->(dbSeek(xFilial("SX5")+ "EU" + SA2->A2_BANCO))

If Empty(SE2->E2_CODBAR) //Caso seja boleto não imprime banco e conta
	oPrinter:Say(nLin+=10, 100, "Banco: " + SA2->A2_BANCO + " " + SX5->X5_DESCRI)
	oPrinter:Say(nLin+=10, 100, "Agência: " + ALLTRIM(SA2->A2_AGENCIA) + IIf(!Empty(SA2->A2_DIGAGEN),"-" + ALLTRIM(SA2->A2_DIGAGEN),""))
	oPrinter:Say(nLin+=10, 100, "Conta: " + ALLTRIM(SA2->A2_NUMCON) + IIf(!Empty(SA2->A2_DIGCON),"-" + ALLTRIM(SA2->A2_DIGCON),""))
EndIf
oPrinter:Say(nLin+=10, 100, "Valor: R$" + Transform(SE5->E5_VALOR,"@E 999,999.99")) 

//-- Posiciona no X5 novamente para buscar descrição da finalidade
dbSelectArea("SX5")
SX5->(dbSetOrder(1))
SX5->(dbSeek(xFilial("SX5")+ "58" + SEA->EA_MODELO)) 

oPrinter:Say(nLin+=10, 100, "Finalidade: " + SX5->X5_DESCRI) 
If !Empty(SE2->E2_CODBAR)
	oPrinter:Say(nLin+=10, 100, "Código Barras: " + SE2->E2_CODBAR)
EndIf
oPrinter:Line(nLin+=10, 010, nLin+=10, 580)      
oPrinter:Say(nLin+=20, 010, "Pagamento efetuado em: " + DTOC(SE5->E5_DATA)) 
oPrinter:Line(nLin, 010, nLin+=10, 580) 

//-- Quadro autenticação
oPrinter:Say(nLin+=10, 010, "Autenticação: ")
oPrinter:Say(nLin+=10, 010, SE5->E5_AUTBCO)   

//--Mensagem rodapé       
oPrinter:Line(nLin+=530, 010, nLin+=10, 580)
cObs := "Dúvidas, segestões e reclamações: na sua agência."
oPrinter:Say(nLin+=10, 010, cObs)   

oPrinter:Setup()
if oPrinter:nModalResult == PD_OK
	oPrinter:Preview()
EndIf                                                                                                          
                                                                                                               
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que valida se existe logo para o banco escolhido³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fValImage(cBanco)
Local cImage := "/system/"+cBanco+".bmp"
Local lRet   := .F.

if File(cImage)
	lRet := .T.
EndIf

Return lRet