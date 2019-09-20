#DEFINE USADO CHR(0)+CHR(0)+CHR(1)
// Função para adicionar campo de Atualizar preço de compra na transferencia de estoque de produtos
User Function MA261CPO( )
Local aTam := {} 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

aTam := TamSX3('D3_ATPRCOM')
Aadd(aHeader, {'Atual. Preço' , 'D3_ATPRCOM' , PesqPict('SD3', 'D3_ATPRCOM' , aTam[1]) , aTam[1], aTam[2], '', USADO, 'C', 'SD3', ''})
Return Nil