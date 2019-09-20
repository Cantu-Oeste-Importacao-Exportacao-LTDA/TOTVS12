#Include "Protheus.ch"

/*/{Protheus.doc} OM040BTN
Adiciona Funcao no Menu

@author Davis Magalhães
@since  30/01/2013
@version 1.0 

@param  cFilOri   Filial de Origem.
        cViagem   Numero da Viagem


@return Logico (.T. ou .F.)
/*/


User Function OM040BTN()       

Local aBtn := {}  

AAdd(aBtn,{"SDUREPL", {|| MsAguarde( { || U_DVMASSC(DA4->DA4_COD)},"Motorista: "+DA4->DA4_COD,"Associando Cartao...") } ,"Associar Cartao"})
AAdd(aBtn,{"SDUREPL", {|| MsAguarde( { || U_DVMDESC(DA4->DA4_COD)},"Motorista: "+DA4->DA4_COD,"Desbloqueando Cartao...") },"Desbloquear Cartao"}) 
AAdd(aBtn,{"SDUREPL", {|| MsAguarde( { || U_DVMSCTMT(DA4->DA4_COD,.T.)},"Motorista: "+DA4->DA4_COD,"Substituindo Cartao...") },"Substituir Cartao"}) 
                                                           
Return(aBtn)