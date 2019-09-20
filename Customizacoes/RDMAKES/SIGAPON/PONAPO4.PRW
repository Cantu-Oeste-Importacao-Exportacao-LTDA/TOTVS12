/***********************************************************************************

Alterado Por Silvio - SMS em 25/08/2015                                                                                   
                                       
Fonte foi reestruturado, por algum motivo a customização estava perdendo lançamentos,
foi desenvolvido uma função para limpar a spc, verba 260 e alterado o FOR do PE.

***********************************************************************************/


#INCLUDE "topconn.ch"

//Ponto de entrada para gerar 40 min de horas In Itineri por dia trabalhado para os funcionários das filiais

User Function PonaPo4()

Local aArea       := GetArea()
Local aMarcacoes  := aClone( ParamIxb[1] )
Local aTabCalend  := aClone( ParamIxb[2] )
Local aCodigos    := aClone( ParamIxb[3] )
Local aEvesIds    := aClone( ParamIxb[4] )
Local aResult     := aClone( aEventos )
Local dDtGer      := dDataBase
Local nHoras      := 0
Local cEvento     := "999"
Local cCusto      := SRA->RA_CC
Local cTpMarc     := ""
Local lSoma       := .F.
Local cPeriodo    := ""
Local nTole       := 0
Local cArred      := ""
Local lSubstitui  := .T.
Local nDias := 0
Local cAux := ''
Local aAreaSPC := {}
Local cChave      := SRA->RA_FILIAL + SRA->RA_MAT


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

U_USORWMAKE(ProcName(),FunName())

if SRA->RA_FILIAL $ GETMV('MV_X_ITINE') .and. SRA->RA_TRANS = 'S' //Verifica se para a filial devem ser calculadas as horas In Itineri e se o funcionário utiliza transporte
	
	aAreaSPC := SPC->(GetArea())
	
	ApagaSPC(cChave, "260")
	
	RestArea(aAreaSPC)
	
	// Fim da exclusão dos itens
	
	for i:= 1 to len(aMarcacoes)
		
		cDia := SubStr( DTos(aMarcacoes[i][1]) ,7,2)
		
		If cDia <> cAux
			
			dData := aMarcacoes[i][1]
			
			//Gera evento de Horas In Itineri para cada dia trabalhado

			fGeraRes(aResult ,; //01 -> Array com os Resultados do Dia
			dData  ,; //02 -> Data da Geracao
			0.4      ,; //03 -> Numero de Horas Resultantes
			'260'  ,; //04 -> Codigo do Evento
			cCusto  ,; //05 -> Centro de Custo a ser Gravado
			cTpMarc  ,; //06 -> Tipo de Marcacao
			lSoma  ,; //07 -> True para Acumular as Horas
			cPeriodo ,; //08 -> Periodo de Apuracao
			nTole  ,; //09 -> Tolerancia
			cArred  ,; //10 -> Tipo de Arredondamento a Ser Utilizado
			lSubstitui  ; //11 -> Substitui a(s) Hora(s) Existente(s)
			)
			cAux := cDia
		Endif
		
	Next i
ENDIF

aEventos := aClone( aResult )

RestArea(aArea)

Return( NIL )


Static Function ApagaSPC(cChave,cEvento)

SPC->( DbSetOrder(1)) // Filial + Matricula + Evento + Data
SPC->( DbGotop())
if (SPC->( DbSeek( cChave + cEvento)) )
	
	While SPC->( !eof()) .and. SPC->(PC_FILIAL + PC_MAT) == cChave .and. SPC->PC_PD == cEvento
		
		RECLOCK("SPC", .F.)
		
		DbDelete()
		MSUNLOCK()
		
		dbSkip()
	Enddo
	
Endif
Return
