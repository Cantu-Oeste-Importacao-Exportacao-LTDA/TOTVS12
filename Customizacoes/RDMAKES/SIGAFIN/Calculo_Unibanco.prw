#include "rwmake.ch"
//-----------------------
// Função para calcular a tal da amarração que está no layout do unibanco, com a seguinte formula
//   Cálculo do Campo Check Horizontal (Amarração Horizontal do Registro)
//   Fórmula:	(Dados do Favorecido + Valor da Transação)  x  Tipo de Operação 
//   Dados do Favorecido	= posição 33 a 50 do detalhe
//   Tipo de operação	= posição 53 do detalhe
//   Valor da Transação 	= posição 55 a 67 do detalhe
//   ATENÇÃO : Se o total do campo ultrapassar 18 dígitos, desprezar o 1o. dígito à esquerda
// Data Criacao: 05/08/06 - Eder Gasparin
//-----------------------
User Function UNIB320()                                             
local resultado  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
      str1:= "409"+SUBS(SRA->RA_BCDEPSA,4,4)+"0000"+SUBSTR(SRA->RA_CTDEPSA,6,6)
      str2:= SomaStr(str1,str(NVALOR))
      multiplicador := '5'
      str3:= MultStr(str2,multiplicador)
      resultado:= str3
Return (resultado)