#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT410BRW º Autor ³ Rafael Parma       º Data ³ 06/07/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada executado antes de mostrar o Browse do    º±±
±±º          ³ Pedido de Venda, para fazer filtro no SC5                  º±±
±±º          ³ Apresenta tela apresentando opção de filtro de pedidos:    º±±
±±º          ³   filtro: 1-Todos Pedidos   2-Em Aberto                    º±±
±±º          ³           3-Encerrados      4-Liberados                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RJU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MT410BRW()
	
Local   o_Dlg                                                                                                     // Guilherme 08-04-15 filtro de bloqueados
Local   a_Radio   := {"Todos Pedidos", "Pedidos em Aberto", "Pedidos Encerrados", "A Faturar (Aberto+Liberado)", "Pedidos Bloqueados"}
Private n_Radio   := 1     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	@ 200,  1 TO 380,380 DIALOG o_Dlg TITLE "Pedidos de Venda - Opção para Filtro"
	@  10, 20 SAY " Escolha o Tipo de Filtro:"
	@  20, 20 RADIO a_Radio VAR n_Radio
	@  72,150 BMPBUTTON TYPE 01 ACTION (MstBrowse(), Close(o_Dlg))
	
	ACTIVATE DIALOG o_Dlg CENTERED  
		
Return


*----------------------------*
Static Function MstBrowse()
*----------------------------*
Local aAreaTMP := GetArea()
Local c_Filtro := "" 
	
	Do Case
		Case n_Radio == 2  // Pedido em Aberto
			c_Filtro += "SC5->C5_LIBEROK==' '.and.SC5->C5_NOTA=='         '"
	
		Case n_Radio == 3  // Pedido Encerrado
			c_Filtro += "(SC5->C5_NOTA<>'         '.Or.SC5->C5_LIBEROK=='E')"
	
		Case n_Radio == 4  // Pedidos Abertos + Liberados
			c_Filtro += "SC5->C5_X_BLQ=='N'.And.SC5->C5_NOTA=='         '" 
		
		//Guilherme 08-04-15 - Adicionar o filtro de pedidos bloqueados.	
		Case n_Radio == 5 // Pedidos bloqueados	
		  c_Filtro += "SC5->C5_X_BLQ=='S' .AND. SC5->C5_NOTA == '         ' "
	EndCase

	dbSelectArea("SC5")			
	SET FILTER TO 
	If c_Filtro != ""
		SET FILTER TO &c_Filtro	
	EndIf
	
	
	RestArea(aAreaTMP)
	
Return