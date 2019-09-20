#Include 'Protheus.ch'
#Include 'topconn.ch'

//TARGET
User Function XMTA103MNU()

//Local aRotina := {}
                 
aadd(aRotina,{'Quitacao c/ Operadora','U_DVMLPAG()' , 0 , 2,0,.F.}) 
aadd(aRotina,{'Impressao RPA'		,'U_RTMS04A()' , 0 , 2,0,.F.})   
aadd(aRotina,{OemtoAnsi('Log') 		,'U_prologf1()', 0 , 7})

Return

