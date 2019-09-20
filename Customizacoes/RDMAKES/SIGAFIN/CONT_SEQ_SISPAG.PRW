#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONT_SEQ_SISPAG  ºAutor  ³Jean         º Data ³  12/27/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Controle sequencial para geração do arquivo SISPAG         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ConSeqSis(cTipoReg, nQuant, nTam, lZerar, lFim)
Local cArq
Local cArqInd
Local aStruTrb := {}
Local cChave := "TIPOREG"
Local lReinicia
Local cEol := CHR(13)+CHR(10)
                                    
Private cRet := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³VARIAVEIS QUE DEVERÃO SER UTILIZADAS NA CHAMADA DA FUNÇÃO NO LUGAR DO CTIPOREG³
//³TOTAL : Resulta na contagem de todos os registros do arquivo                  ³
//³HEADERLOTE : Controla a quantidade de lotes do arquivo                        ³
//³DETALHE : Controla a quantidade de registros do lote                          ³
//³TOTALLOTE : Controla a quantidade de registros do lote + cabeçalho e rodapé   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Verifica se o arquivo temporário já existe.
if select ("TRBTMP") > 0 
	
	// Faz a contagem das linhas do arquivo
	if nQuant > 0 .or. (cTipoReg == "TOTALLOTE" .and. nQuant == 1)
		ExecutaSequencial("TOTAL", 1, nTam, .F.)
	EndIf                                  
	
	// Faz o controle da quantidade de registros do tipo DETALHE por lote           
	if cTipoReg == "HEADERLOTE" .and. nQuant > 0
		ExecutaSequencial("DETALHE", 0, nTam, .T.)
		ExecutaSequencial("TOTALLOTE", 1, nTam, .T.)
	EndIf            
	
	if cTipoReg == "DETALHE" .and. nQuant == 1
		ExecutaSequencial("TOTALLOTE", 1, nTam, .F.)		
	EndIf                                                    
	
	// Executa a função que controla sequencial
	ExecutaSequencial(cTipoReg, nQuant, nTam, lZerar)
else
	
	// Caso o arquivo temporário não exista, cria a estrutura para posterior criação do arquivo.
	Aadd(aStruTrb, {"TIPOREG","C",20,0})
	Aadd(aStruTrb, {"QUANT"  ,"N",03,0})
	
	// Cria arquivo temporário 
	cArq := CriaTrab(aStruTrb)
	dbUseArea(.T., "LOCAL", cArq, "TRBTMP")
	
	// Cria um arquivo vazio para armazenar o índice
	cArqInd := CriaTrab(nil,.f.)
	IndRegua("TRBTMP",cArqInd,cChave,,,"Criando Indice...")
	TRBTMP->(dbSetIndex(cArqInd+OrdBagExt()))

	if nQuant > 0 .or. (cTipoReg == "TOTALLOTE" .and. nQuant == 1)
		ExecutaSequencial("TOTAL", 1, nTam, .F.)
	EndIf                                             
	
	if cTipoReg == "HEADERLOTE" .and. nQuant > 0
		ExecutaSequencial("DETALHE", 0, nTam, .T.)
		ExecutaSequencial("TOTALLOTE", 1, nTam, .T.)
	EndIf
	
	if cTipoReg == "DETALHE" .and. nQuant == 1
		ExecutaSequencial("TOTALLOTE", 1, nTam, .F.)		
	EndIf                                                    
	                            
	ExecutaSequencial(cTipoReg, nQuant, nTam, lZerar)
EndIf                

// Se o parâmetro for verdadeiro, finaliza o arquivo temporário.
if lFim
	TRBTMP->(DbCloseArea())
EndIf

Return cRet


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄáriT¿
//³A função ExecutaSequencial é executada depois que a tabela temporária³
//³estiver criada.                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄáriTÙ

Static Function ExecutaSequencial(cTipoReg, nQuant, nTam, lZerar)

DbSelectArea("TRBTMP")
DbSetOrder(1)

// Tenta encontrar na tabela o tipo de registro (header, trailer...)
if DbSeek(cTipoReg)
	RecLock("TRBTMP", .F.)
	
	// Verifica se o parâmetro lZerar veio verdadeiro. Se sim, começa a contagem de numeração novamente.
	if lZerar
		TRBTMP->QUANT := nQuant
	else
		TRBTMP->QUANT := TRBTMP->QUANT + nQuant
	EndIf
	TRBTMP->(MsUnlock())
	
	// A variável cRet é populada com a quantidade atual do registro que foi passado no parâmetro cTipoReg 
	// e o tamanho da string varia de acordo com o conteúdo do parâmetro nTam
	cRet := StrZero(TRBTMP->QUANT, nTam)
Else
	
	// Se não encontrar o tipo de registro, cria um novo.
	RecLock("TRBTMP", .T.)
	TRBTMP->TIPOREG := cTipoReg
	TRBTMP->QUANT := nQuant
	TRBTMP->(MsUnlock())
	cRet := StrZero(TRBTMP->QUANT, nTam)
EndIf

Return                


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que faz a geração da chave do título que é gravada no arquivo do SISPAG³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User Function GeraChvTit(nReg) 
Local cChave := ""                    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

DbSelectArea("SE2")
SE2->(DbGoTo(nReg))

cChave := SE2->E2_FILIAL + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO                   

Return cChave    