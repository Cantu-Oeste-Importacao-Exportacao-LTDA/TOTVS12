#include "rwmake.ch"

User Function Valimp()

SetPrvt("CCAMPO,")

If Len(Alltrim(SE2->E2_CODBAR)) != 44
	cCampo := Substr(SE2->E2_CODBAR,34,14)
Else
	cCampo := Substr(SE2->E2_CODBAR,6,14)
Endif
cCampo := Strzero(Val(cCampo),14)
Return(cCampo)
