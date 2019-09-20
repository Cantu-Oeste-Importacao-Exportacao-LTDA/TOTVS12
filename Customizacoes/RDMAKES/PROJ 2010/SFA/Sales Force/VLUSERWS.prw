#Include 'Protheus.ch'


/*/{Protheus.doc} VLUSERWS

Valida usuario para Webservice
	
@author devair.tonon
@since 26/01/2015
@version 1.0
		
@param cUser, character, login do usuario
@param cPassword, character, senha do usuario

@return lRet, .T. se usuario validado, .F. caso contrário

/*/

User Function VLUSERWS(cUser, cPassword)
	local lRet	:=.F.
	
	PswOrder( 2 )
	if PswSeek(cUser,.T.)
		varinfo("Achou usuario", .T.)      
		if PswName(cPassword)   
			varinfo("Achou senha", .T.)
		    lRet	:=.T.
		endif
	endif
	
Return lRet

