#INCLUDE "PROTHEUS.CH" 

User Function MDFeMun() 

cEntSai := PARAMIXB[1] //1-Saída/2-Entrada 
cSerie := PARAMIXB[2] //Série da NF 
cNota := PARAMIXB[3] //Número da Nota da NF 
cCliFor := PARAMIXB[4] //Cliente/Fornecedor 
cLoja := PARAMIXB[5] //Loja 

SA1->(dbSetOrder(1)) 
If SA1->(dbSeek(xFilial("SA1")+cCliFor+cLoja)) 
cRetMun := SA1->A1_COD_MUN 
EndIf 

Return cRetMun