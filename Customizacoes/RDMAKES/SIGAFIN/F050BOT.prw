#include "rwmake.ch"

User Function F050BOT()

//Local aMenu := {}
Local aRotina := {}

//aadd(aMenu,{'S4WB011N',{ || U_F050REL()},'Comp. Pagamento'})
aAdd(aRotina,{"MsDocument","FATA340",0,3,0,Nil})//"Conhecimento"

Return aRotina
