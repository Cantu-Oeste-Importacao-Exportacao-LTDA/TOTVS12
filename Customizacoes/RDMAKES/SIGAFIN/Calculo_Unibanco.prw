#include "rwmake.ch"
//-----------------------
// Fun��o para calcular a tal da amarra��o que est� no layout do unibanco, com a seguinte formula
//   C�lculo do Campo Check Horizontal (Amarra��o Horizontal do Registro)
//   F�rmula:	(Dados do Favorecido + Valor da Transa��o)  x  Tipo de Opera��o 
//   Dados do Favorecido	= posi��o 33 a 50 do detalhe
//   Tipo de opera��o	= posi��o 53 do detalhe
//   Valor da Transa��o 	= posi��o 55 a 67 do detalhe
//   ATEN��O : Se o total do campo ultrapassar 18 d�gitos, desprezar o 1o. d�gito � esquerda
// Data Criacao: 05/08/06 - Eder Gasparin
//-----------------------
User Function UNIB320()                                             
local resultado  
//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())
      str1:= "409"+SUBS(SRA->RA_BCDEPSA,4,4)+"0000"+SUBSTR(SRA->RA_CTDEPSA,6,6)
      str2:= SomaStr(str1,str(NVALOR))
      multiplicador := '5'
      str3:= MultStr(str2,multiplicador)
      resultado:= str3
Return (resultado)