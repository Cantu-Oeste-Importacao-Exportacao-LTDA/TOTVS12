#DEFINE USADO CHR(0)+CHR(0)+CHR(1)
// Fun��o para adicionar campo de Atualizar pre�o de compra na transferencia de estoque de produtos
User Function MA261CPO( )
Local aTam := {} 

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

aTam := TamSX3('D3_ATPRCOM')
Aadd(aHeader, {'Atual. Pre�o' , 'D3_ATPRCOM' , PesqPict('SD3', 'D3_ATPRCOM' , aTam[1]) , aTam[1], aTam[2], '', USADO, 'C', 'SD3', ''})
Return Nil