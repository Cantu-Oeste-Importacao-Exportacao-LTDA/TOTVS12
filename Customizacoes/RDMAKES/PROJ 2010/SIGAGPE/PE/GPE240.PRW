/*---------------------------------------------------------------------------+
!                       FICHA TECNICA DO PROGRAMA                            !
+----------------------------------------------------------------------------+
!                          DADOS DO PROGRAMA                                 !
+------------------+---------------------------------------------------------+
!Autor             ! Silvio Rodrigues Lima - SMSTI                           !
+------------------+---------------------------------------------------------+
!Descricao         ! Ponto de entrada para gravar a data com afastamento O   !
!                  ! no cadastro do funcionário (Campo RA_DTVTEST)           !
+------------------+---------------------------------------------------------+
!Nome              ! GP240MAN                                                !
+------------------+---------------------------------------------------------+
!Data de Criação   ! 05/11/2013                                              !
+------------------+--------------------------------------------------------*/

                                       
#include "rwmake.ch"
#include "topconn.ch"
#INCLUDE "font.ch"

User Function GP240MAN()    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

nDiasEstab := POSICIONE("RCA", 1,"  M_DIASESTA", "RCA_CONTEU")

//alert (cvaltochar(nDiasEstab))

IF empty(nDiasEstab) .OR. ALLTRIM(nDiasEstab) == "0" 
MsgBox("<html><b><span style='color:red'>ATENÇÃO!! Mnemonico M_DIASESTA está zerado ou não existe!</html>","Erro","STOP")
Return
ENDIF


	BEGINSQL Alias 'QRY'
		SELECT
		R8_DATA
		FROM %Table:SR8% SR8
		WHERE
		R8_FILIAL = %Exp:SRA->RA_FILIAL% AND
		R8_MAT = %Exp:SRA->RA_MAT% AND
		R8_TIPO = 'O' AND
		SR8.%NOTDEL%
	ENDSQL
	
		IF QRY->(EOF()) == .T. .AND. !empty(SRA->RA_DTVTEST)
			If MsgBox("<html>Existe data de estabilidade sem afastamento Tipo O, deseja deletar a data <b><span style='color:red'>"+cvaltochar(SRA->RA_DTVTEST)+"</span></b> no cadastro do funcionário?</html>","Confirme","YESNO")
				dbselectarea("SRA")
				dbSetorder(1)
				If dbSeek(SRA->RA_FILIAL+SRA->RA_MAT)
					RecLock("SRA",.F.)
					SRA->RA_DTVTEST := STOD("")
					MsUnlock("SRA")
					//alert("APAGANDO DATA ESTABILIDADE SRA " + cvaltochar(SRA->RA_DTVTEST)   )
				ENDIF
			ENDIF
		ENDIF
		

		IF QRY->(EOF()) == .F. .AND. !empty(SRA->RA_DTVTEST) .AND. SRA->RA_DTVTEST <> SR8->R8_DATAFIM
			If MsgBox("<html>Existe data de estabilidade com afastamento Tipo O, deseja alterar a data de <b><span style='color:blue'>"+cvaltochar(SRA->RA_DTVTEST)+"</span></b> para <b><span style='color:red'>"+cvaltochar(SR8->R8_DATAFIM+val(nDiasEstab))+"</span></b> no cadastro do funcionário?</html>","Confirme","YESNO")
				dbselectarea("SRA")
				dbSetorder(1)
				If dbSeek(SRA->RA_FILIAL+SRA->RA_MAT)
					RecLock("SRA",.F.)
					SRA->RA_DTVTEST := SR8->R8_DATAFIM + val(nDiasEstab)
					MsUnlock("SRA")
				   //	alert("ALTERANDO DATA SRA " + cvaltochar(SR8->R8_DATAFIM+nDiasEstab)   )
				ENDIF
			ENDIF
		ENDIF


		IF QRY->(EOF()) == .F. .AND. empty(SRA->RA_DTVTEST)
			If MsgBox("<html>Deseja cadastrar estabilidade com afastamento Tipo O, com data de <b><span style='color:red'>"+cvaltochar(SR8->R8_DATAFIM+ val(nDiasEstab))+"</span></b>?</html>","Confirme","YESNO")
				dbselectarea("SRA")
				dbSetorder(1)
				If dbSeek(SRA->RA_FILIAL+SRA->RA_MAT)
					RecLock("SRA",.F.)
					SRA->RA_DTVTEST := SR8->R8_DATAFIM + val(nDiasEstab)
					MsUnlock("SRA")
				   //	alert("GRAVANDO DATA SRA " + cvaltochar(SR8->R8_DATAFIM+nDiasEstab)   )
				ENDIF
			ENDIF
		ENDIF

QRY->(DbCloseArea())
SRA->(DbCloseArea()) 

Return
