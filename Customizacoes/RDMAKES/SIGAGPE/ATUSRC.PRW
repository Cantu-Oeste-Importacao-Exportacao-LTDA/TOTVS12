#INCLUDE "COLORS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FONT.CH"
#INCLUDE "PRINT.CH"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ATUSRC ºAutor  ³Luiz Gamero prado       º Data ³  04/05/2011º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualiza os campos personalizados do movimento mensal (src) ±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Grupo cantu                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function ATUSRC   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

if select("TMPSRC") > 0
	("TMPSRC")->(dbclosearea())
endif

cQuery :=""
cQuery +=" select src.rc_filial, src.rc_mat, src.rc_cc, src.rc_x_clvl "
cQuery +=" from "+RetSqlName("SRC")+" src "
cQuery +="  where src.rc_x_clvl = ' ' "
cQuery +="    and src.d_e_l_e_t_ <> '*' "
cQuery +="    order by src.rc_filial, src.rc_mat "

//MemoWrite("TMPSRC.TXT",cQuery)
TcQuery cQuery NEW ALIAS "TMPSRC"
If Alias() <> "TMPSRC"
	MsgBox("TMPSRC - Parâmetros Inválidos!")
	Return .f.
Endif

dbGoTop("TMPSRC")

_Vazio := 0
While TMPSRC->(!EOF())
	_Vazio := _Vazio + 1
	TMPSRC->(DBSKIP())
EndDo
dbGoTop("TMPSRC")

if _Vazio > 0 
	While TMPSRC->(!EOF())
		
		DBSelectArea("SRA")
		DbSetOrder(1)
		DbGoTop()
		
		dbSeek(TMPSRC->RC_FILIAL + TMPSRC->RC_MAT )
		_x_segme := SRA->RA_X_SEGME
		
		DBSelectArea("SRC")
		DbSetOrder(1)
		SRC->(DbGoTop())
		if dbseek(TMPSRC->RC_FILIAL+TMPSRC->RC_MAT)
			while TMPSRC->RC_FILIAL == SRC->RC_FILIAL .AND. TMPSRC->RC_MAT == SRC->RC_MAT 
				RecLock("SRC",.f.)
				SRC->RC_X_CLVL := _x_segme
				SRC->(MSUnLock())
				SRC->(DBSKIP())
			ENDDO
		endif
		TMPSRC->(DBSKIP())
	enddo
Else
	msgbox("Nâo existe cálculo de provisôes para o periodo solicitado, favor verificar . . . ")
EndIf

("TMPSRC")->(dbclosearea())
SRA->(dbclosearea())
return
