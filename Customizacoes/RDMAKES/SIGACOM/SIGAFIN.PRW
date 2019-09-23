#INCLUDE "URZUM.CH" 

//+-----------------------------------------------------------------------------------//
//|Empresa...: aFill Tecnologia
//|Funcao....: U_SIGAFIN()
//|Autor.....: aFill Tecnologia - suporte@afill.com.br
//|Data......: 06 de Outubro de 2011, 19:00
//|Uso.......: SIGACOM   
//|Versao....: Protheus - 10
//|Descricao.: PE para não permitir a baixa de titulos de previsão do template
//|Observação: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
User Function SIGAFIN()
*-----------------------------------------*,

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

MVPROVIS := Iif( !"|PRP|PRC" $ MVPROVIS,MVPROVIS+"|PRP|PRC",MVPROVIS) 

Return
	



