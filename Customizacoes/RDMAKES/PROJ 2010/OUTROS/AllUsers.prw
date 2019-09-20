#Include "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³ AllUsers º       Autor ³ Gustavo Lattmann º Data ³ 16/12/14 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório de usuários do sistema, extraindo informações    º±±
±±º            do sigapss.spf                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso ³ Protheus 11													  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function AllUsers()

Local cDesc1 := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2 := "de acordo com os parametros informados pelo usuario."
Local cDesc3 := ""
Local cPict := ""
Local imprime := .T.
Local aOrd := {}
Private titulo := "Relatorio de Acessos dos Usuarios"
Private nLin := 80
Private Cabec1 := ""
Private Cabec2 := ""
Private tamanho := "M"
Private nomeprog := "AllUser"
Private nTipo := 15
Private aReturn := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
//Private cPerg := "MAPAUS"
Private cPerg := Space(10)
Private m_pag := 01
Private wnrel := "AllUser"
Private cString := ""     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

cPerg := "AllUser"

AjustSX1()

Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario... ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³ AllUsers º       Autor ³ Gustavo Lattmann º Data ³ 16/12/14 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Monta a tela com a regua de processamento                  º±±
±±º          							                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso ³ Protheus 11													  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local aIdiomas := {"Portugues","Ingles","Espanhol"}
Local aTipoImp := {"Em Disco","Via Spool","Direto na Porta","E-Mail"}
Local aFormImp := {"Retrado","Paisagem"}
Local aAmbImp  := {"Servidor","Cliente"}
Local aColAcess:= {000,040,080}
Local aColMenus:= {000,044,088}
Local aAllUsers:= AllUsers()
Local aUser := {}
Local i := 0
Local k := 0
Local j := 0
Local aMenu   
Local aUserAux := aUser

aModulos := fModulos()
aAcessos := fAcessos()

For i := 1 to Len(aAllUsers)
	If aAllUsers[i][01][01]>=mv_par01 .and. aAllUsers[i][01][01]<=mv_par02 .and.;
		Lower(aAllUsers[i][01][02]) >= Lower(AllTrim(mv_par03)) .and. Lower(aAllUsers[i][01][02]) <= Lower(AllTrim(mv_par04))
		aAdd(aUser,aAllUsers[i])
	Endif 
Next      


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica bloqueio do usuário e valida com o parâmetro informado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For i := Len(aUserAux) To 1 Step -1
	If mv_par06 == 2 .and. (aUser[i][01][17])
		//Exclui o usuário do vetor
		ADel(aUser,i)		
		aSize(aUser, Len(aUser)-1)
	EndIf
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄX¿
//³Filtra por acesso, caso não possua é excluído do vetor para não ser impresso³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄXÙ
For i := Len(aUserAux) To 1 Step -1
	If !Empty(mv_par12) .and. mv_par12 != 0
   		If Substr(aUser[i][02][5],mv_par12,1) != "S"
  			//Exclui o usuário do vetor
			ADel(aUser,i)		
			aSize(aUser, Len(aUser)-1)
  		EndIf
	EndIf
Next    



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtra por menu em especifico³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For i := Len(aUserAux) To 1 Step -1
	If !Empty(mv_par13) .and. mv_par13 != 0
		If Substr(aUser[i][03][mv_par13],3,1) == "X"
			//Exclui o usuário do vetor
			ADel(aUser,i)		
			aSize(aUser, Len(aUser)-1)
		EndIf
	EndIf
Next

If mv_par05==1 //ID
	aSort(aUser,,,{ |aVar1,aVar2| aVar1[1][1] < aVar2[1][1]})
Else //Usuario
	aSort(aUser,,,{ |aVar1,aVar2| aVar1[1][2] < aVar2[1][2]})
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(Len(aUser))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processa Usuarios ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For i := 1 to Len(aUser)
	IncRegua()
	
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 5
	
	@ nLin,000 pSay "I N F O R M A C O E S D O U S U A R I O"
	nLin+=1
	@ nLin,000 pSay "User ID.........................: "+aUser[i][01][01] //ID
	nLin+=1
	@ nLin,000 pSay "Usuario.........................: "+aUser[i][01][02] //Usuario
	nLin+=1
	@ nLin,000 pSay "Nome Completo...................: "+aUser[i][01][04] //Nome Completo
	nLin+=1
	@ nLin,000 pSay "Validade........................: "+DTOC(aUser[i][01][06]) //Validade
	nLin+=1
	@ nLin,000 pSay "Acessos para Expirar............: "+AllTrim(Str(aUser[i][01][07])) //Expira em n acessos
	nLin+=1
	@ nLin,000 pSay "Autorizado a Alterar Senha......: "+If(aUser[i][01][08],"Sim","Nao") //Autorizado a Alterar Senha
	nLin+=1
	@ nLin,000 pSay "Alterar Senha no Proximo LogOn..: "+If(aUser[i][01][09],"Sim","Nao") //Alterar Senha no Proximo LogOn
	nLin+=1
	
	PswOrder(1)
	PswSeek(aUser[i][1][11],.t.)
	aSuperior := PswRet(NIL)
	@ nLin,000 pSay "Superior........................: "+If(!Empty(aSuperior),aSuperior[01][02],"") //Superior
	nLin+=1
	@ nLin,000 pSay "Departamento....................: "+aUser[i][01][12] //Departamento
	nLin+=1
	@ nLin,000 pSay "Cargo...........................: "+aUser[i][01][13] //Cargo
	nLin+=1
	@ nLin,000 pSay "E-Mail..........................: "+aUser[i][01][14] //E-Mail
	nLin+=1
	@ nLin,000 pSay "Acessos Simultaneos.............: "+AllTrim(Str(aUser[i][01][15])) //Acessos Simultaneos
	nLin+=1
	@ nLin,000 pSay "Ultima Alteracao................: "+DTOC(aUser[i][01][16]) //Data da Ultima Alteracao
	nLin+=1
	@ nLin,000 pSay "Usuario Bloqueado...............: "+If(aUser[i][01][17],"Sim","Nao") //Usuario Bloqueado
	nLin+=1
	@ nLin,000 pSay "Digitos p/o Ano.................: "+AllTrim(STR(aUser[i][01][18])) //Numero de Digitos Para o Ano
	nLin+=1
	@ nLin,000 pSay "Idioma..........................: "+aIdiomas[aUser[i][02][02]] //Idioma
	nLin+=1
	@ nLin,000 pSay "Diretorio do Relatorio..........: "+aUser[i][02][03] //Diretorio de Relatorio
	nLin+=1
	/*	@ nLin,000 pSay "Tipo de Impressao...............: "+aTipoImp[aUser[i][02][08]] // Tipo de Impressao
	nLin+=1
	@ nLin,000 pSay "Formato de Impressao............: "+aFormImp[aUser[i][02][09]] // Formato
	nLin+=1
	@ nLin,000 pSay "Ambiente de Impressao...........: "+aAmbImp[aUser[i][02][10]] // Ambiente
	nLin+=2	*/	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime Grupos ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ nLin,000 pSay Replic("-",132)
	nLin+=1
	@nLin,000 pSay "G R U P O S"
	nLin+=2
	For k:=1 to Len(aUser[i][01][10])
		fCabec(@nLin,70)
	
		PswOrder(1)
		PswSeek(aUser[i][01][10][k],.f.)
		aGroup := PswRet(NIL)
		@ nLin,005 pSay aGroup[01][2] //Grupos
		nLin+=1
	Next k
	nLin+=1
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime Horarios ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par07==1
		fCabec(@nLin,50)
		
		@ nLin,000 pSay Replic("-",132)
		nLin+=1
		@nLin,000 pSay "H O R A R I O S"
		nLin+=2
		For k:=1 to Len(aUser[i][02][01])
			fCabec(@nLin,70)
			
			@ nLin,005 pSay aUser[2][01][k] //Horarios
			nLin+=1
		Next k
		nLin+=1
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime Empresas / Filiais ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par08==1
		fCabec(@nLin,50)
		
		@ nLin,000 pSay Replic("-",132)
		nLin+=1
		@nLin,000 pSay "E M P R E S A S / F I L I A I S"
		nLin+=2
		For k:=1 to Len(aUser[i][02][06])
			fCabec(@nLin,70)
			
			dbSelectArea("SM0")
			dbSetOrder(1)
			dbSeek(aUser[i][02][06][k])
			@ nLin,005 pSay Substr(aUser[i][02][06][k],1,2)+"/"+Substr(aUser[i][02][06][k],3,2)+If(Found()," "+M0_NOME+" - "+M0_NOMECOM,If(Substr(aUser[i][02][06][k],1,2)=="@@"," - Todos","")) //Empresa / Filial
			nLin+=1
			
		Next k
		nLin+=1
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime Modulos ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par09==1
		fCabec(@nLin,50)
		
		@ nLin,000 pSay Replic("-",132)
		nLin+=1
		@ nLin,000 pSay "M O D U L O S"
		nLin+=2
		// 1 2 3 4 5 6 7 8
		// 123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
		@ nLin,000 pSay "MODULO NIVEL ARQ.MENU"
		nLin+=1
		@ nLin,000 pSay ""
		nLin+=1
		
		For k:=1 to Len(aModulos)
			If Substr(aUser[i][03][k],3,1) <> "X"
				If nLin > 55
				fCabec(@nLin,70)
				@ nLin,000 pSay "MODULO NIVEL ARQ.MENU"
				nLin+=1
				@ nLin,000 pSay ""
				nLin+=1
			Endif
		
			@ nLin,000 pSay aModulos[k][02]+" - "+aModulos[k][3]
			@ nLin,048 pSay Substr(aUser[i][03][k],3,1)
			@ nLin,052 pSay Substr(aUser[i][03][k],4)
			
			nLin+=1
			Endif
		Next k
		nLin+=1
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime Acessos ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par10 == 1
		fCabec(@nLin,50)
	
		@ nLin,000 pSay Replic("-",132)
   		nLin+=1
   		@ nLin,000 pSay "A C E S S O S"
   		nLin+=2
	    nCol := 1

		For k:=1 to Len(aAcessos)
   			If Substr(aUser[i][02][5],k,1) == "S"
				fCabec(@nLin,70)
	   			@ nLin,aColAcess[nCol] pSay aAcessos[k]
	   			If nCol==3
	   				nCol := 1 
	   				nLin += 1
	   			Else
					nCol+=1
				Endif
   			Endif
		Next k

	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime Menus ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par11 == 1
		fCabec(@nLin,50)
		
		@ nLin,000 pSay Replic("-",132)
		nLin+=1
		@ nLin,000 pSay "M E N U S"
		nLin+=2
		// 1 2 3 4 5 6 7 8
		// 123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
		@ nLin,000 pSay "TITULO PROGRAMA ACESSOS TITULO PROGRAMA ACESSOS TITULO PROGRAMA ACESSOS"
		nLin+=1
		@ nLin,000 pSay ""
		nLin+=1
		
		For k:=1 to Len(aModulos)
			If Substr(aUser[i][03][k],3,1) <> "X"
			aMenu := fGetMnu(Substr(aUser[i][03][k],4),aUser[i][01][02])
	
			nLin +=1
			@ nLin,000 pSay aModulos[k][02]+" - "+AllTrim(aModulos[k][3])+" --> "+Substr(aUser[i][03][k],4)
			nLin+=2
	
			nCol := 1
			nimp := "00"
				For j:=1 to Len(aMenu)
					If nLin > 55
						fCabec(@nLin,70)
						@ nLin,000 pSay "TITULO PROGRAMA ACESSOS TITULO PROGRAMA ACESSOS TITULO PROGRAMA ACESSOS"
						nLin+=1
						@ nLin,000 pSay ""
						nLin+=1
					Endif
					If !(aMenu[j][4] $ "T")
						Loop
					Endif
	
					IF nimp <> aMenu[j][01]
						IF aMenu[j][01] <> "10"
					   		nLin += 2
						ENDIF
						If nLin > 55
							fCabec(@nLin,70)
							@ nLin,000 pSay "TITULO PROGRAMA ACESSOS TITULO PROGRAMA ACESSOS TITULO PROGRAMA ACESSOS"
							nLin+=1
							@ nLin,000 pSay ""
							nLin+=1
						Endif
						do case
						case aMenu[j][01] = "10"
							@ nLin, 020 PSAY "........................................ Atualizações ........................................"
						case aMenu[j][01] = "20"
							@ nLin, 020 PSAY "........................................ Consultas ........................................"
						case aMenu[j][01] = "30"
							@ nLin, 020 PSAY "........................................ Relatorios ........................................"
						case aMenu[j][01] = "40"
							@ nLin, 020 PSAY "........................................ Miscelaneas ........................................"
						endcase
						nLin ++
						nCol := 1
						nimp := aMenu[j][01]
					endif
	
					do case
						case nCol = 1
							nccc := 0
						case nCol = 2
							nccc := 44
						case nCol = 3
							nccc := 88
					endcase
		
					@ nLin,nccc+000 pSay aMenu[j][02]
					@ nLin,nccc+019 pSay aMenu[j][03]
					@ nLin,nccc+030 pSay aMenu[j][06]
	
					// @ nLin,aColMenus[nCol]+000 pSay aMenu[j][02]
					// @ nLin,aColMenus[nCol]+019 pSay aMenu[j][03]
					// @ nLin,aColMenus[nCol]+030 pSay aMenu[j][06]
					If nCol==3
						nCol:=1
						nLin+=1
					Else
						nCol+=1
					Endif
				Next
				nLin+=1
			Endif
		Next k
		nLin+=1
	Endif
	
	Roda(,,"M")
	
Next i

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio... ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao... ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³ fModulos ºAutor ³Carlos G. Berganton º Data ³ 16/02/04      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc. ³ Retorna Array com Codigos e Nomes dos Modulos                  º±±
±±º ³                                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fModulos()

Local aReturn

aReturn := {{"01","SIGAATF ","Ativo Fixo "},;
{"02","SIGACOM ","Compras "},;
{"03","SIGACON ","Contabilidade "},;
{"04","SIGAEST ","Estoque/Custos "},;
{"05","SIGAFAT ","Faturamento "},;
{"06","SIGAFIN ","Financeiro "},;
{"07","SIGAGPE ","Gestao de Pessoal "},;
{"08","SIGAFAS ","Faturamento Servico "},;
{"09","SIGAFIS ","Livros Fiscais "},;
{"10","SIGAPCP ","Planej.Contr.Producao "},;
{"11","SIGAVEI ","Veiculos "},;
{"12","SIGALOJA","Controle de Lojas "},;
{"13","SIGATMK ","Call Center "},;
{"14","SIGAOFI ","Oficina "},;
{"15","SIGARPM ","Gerador de Relatorios Beta1 "},;
{"16","SIGAPON ","Ponto Eletronico "},;
{"17","SIGAEIC ","Easy Import Control "},;
{"18","SIGAGRH ","Gestao de R.Humanos "},;
{"19","SIGAMNT ","Manutencao de Ativos "},;
{"20","SIGARSP ","Recrutamento e Selecao Pessoal "},;
{"21","SIGAQIE ","Inspecao de Entrada "},;
{"22","SIGAQMT ","Metrologia "},;
{"23","SIGAFRT ","Front Loja "},;
{"24","SIGAQDO ","Controle de Documentos "},;
{"25","SIGAQIP ","Inspecao de Projetos "},;
{"26","SIGATRM ","Treinamento "},;
{"27","SIGAEIF ","Importacao - Financeiro "},;
{"28","SIGATEC ","Field Service "},;
{"29","SIGAEEC ","Easy Export Control "},;
{"30","SIGAEFF ","Easy Financing "},;
{"31","SIGAECO ","Easy Accounting "},;
{"32","SIGAAFV ","Administracao de Forca de Vendas "},;
{"33","SIGAPLS ","Plano de Saude "},;
{"34","SIGACTB ","Contabilidade Gerencial "},;
{"35","SIGAMDT ","Medicina e Seguranca no Trabalho "},;
{"36","SIGAQNC ","Controle de Nao-Conformidades "},;
{"37","SIGAQAD ","Controle de Auditoria "},;
{"38","SIGAQCP ","Controle Estatistico de Processos "},;
{"39","SIGAOMS ","Gestao de Distribuicao "},;
{"40","SIGACSA ","Cargos e Salarios "},;
{"41","SIGAPEC ","Auto Pecas "},;
{"42","SIGAWMS ","Gestao de Armazenagem "},;
{"43","SIGATMS ","Gestao de Transporte "},;
{"44","SIGAPMS ","Gestao de Projetos "},;
{"45","SIGACDA ","Controle de Direitos Autorais "},;
{"46","SIGAACD ","Automacao Coleta de Dados "},;
{"47","SIGAPPAP","PPAP "},;
{"48","SIGAREP ","Replica "},;
{"49","SIGAGAC ","Gerenciamento Academico "},;
{"50","SIGAEDC ","Easy DrawBack Control "},;
{"97","SIGAESP ","Especificos "},;
{"98","SIGAESP1","Especificos I "}}


Return(aReturn)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³ fAcessos ºAutor ³Gustavo Lattmann    º Data ³ 16/12/14      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc. ³ Retorna os Acessos dos Sistema                                 º±±
±±º ³                                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fAcessos()

Local aReturn

aReturn := { "Excluir produtos"	,;
 "Alterar produtos"	,;
 "Excluir cadastros" 	,;
 "Alterar solicit compras"	,;
 "Excluir solicit compras" 	,;
 "Alterar pedidos compras" 	,;
 "Excluir pedidos compras" 	,;
 "Analisar cotações" 	,;
 "Relat. ficha cadastral" 	,;
 "Relat. bancos"	,;
 "Relação solicit. compras"	,;
 "Relação de pedidos compras" 	,;
 "Alterar estruturas" 	,;
 "Excluir estruturas"	,;
 "Alterar TES"	,;
 "Excluir TES"	,;
 "Inventário" 	,;
 "Fechamento mensal"	,;
 "Proc. diferença de inventário"	,;
 "Alterar pedidos de venda" 	,;
 "Excluir pedidos de venda"	,;
 "Alterar helps" 	,;
 "Substituição de títulos" 	,;
 "Inclusão de dados via F3" 	,;
 "Rotina de atendimento"	,;
 "Proc. troco"	,;
 "Proc. sangria" 	,;
 "Borderô cheques pré-dat."	,;
 "Rotina de pagamento"	,;
 "Rotina de recebimento" 	,;
 "Troca de mercadorias" 	,;
 "Acesso tabela de preços" 	,;
 "Não utilizado"	,;
 "Não utilizado" 	,;
 "Acesso condição negociada"	,;
 "Alterar database do sistema" 	,;
 "Alterar empenhos de OPs." 	,;
"Não utilizado"	,;
 "Form. preços todos níveis"	,;
 "Configura venda rápida" 	,;
 "Abrir/Fechar caixa" 	,;
"Excluir nota/orç. loja"	,;
 "Alterar bem ativo fixo"	,;
 "Excluir bem ativo fixo"	,;
 "Incluir bem via cópia" 	,;
 "Tx. juros condic. negociada"	,;
 "Liberação venda forcad. TEF"	,;
 "Cancelamento venda TEF" 	,;
 "Cadastra moeda na abertura"	,;
 "Alterar num. da NF" 	,;
 "Emitir NF retroativa" 	,;
 "Excluir baixa - receber"	,;
 "Excluir baixa - pagar" 	,;
 "Incluir tabelas"	,;
 "Alterar tabelas"	,;
 "Excluir tabelas"	,;
 "Incluir contratos" 	,;
 "Alterar contratos"	,;
 "Excluir contratos" 	,;
 "Uso integração SIGAEIC"	,;
 "Incluir empréstimo" 	,;
 "Alterar empréstimo"	,;
 "Excluir empréstimo"	,;
 "Incluir leasing"	,;
 "Alterar leasing"	,;
 "Excluir leasing" 	,;
 "Incluir imp. não financ." 	,;
 "Alterar imp. não financ." 	,;
 "Excluir imp. não financ." 	,;
 "Incluir imp. financiada" 	,;
 "Alterar imp. financiada"	,;
 "Excluir imp. financiada"	,;
 "Incluir imp. fin. export."	,;
 "Alterar imp. fin. export."	,;
 "Excluir imp. fin. export" 	,;
 "Incluir contrato"	,;
 "Alterar contrato"	,;
 "Excluir contrato"	,;
 "Lançar taxa Libor" 	,;
 "Consolidar empresas" 	,;
 "Incluir cadastros"	,;
 "Alterar cadastros"	,;
 "Incluir cotação moedas" 	,;
 "Alterar cotação moedas"	,;
 "Excluir cotação moedas" 	,;
 "Incluir corretoras" 	,;
 "Alterar corretoras"	,;
 "Excluir corretoras" 	,;
 "Incluir Imp./Exp./Cons" 	,;
 "Alterar Imp./Exp./Cons" 	,;
 "Excluir Imp./Exp./Cons"	,;
 "Baixa solicitações"	,;
 "Visualiza arquivo limite"	,;
 "Imprime doctos. cancelados"	,;
 "Reativa doctos. cancelados"	,;
 "Consulta doctos. obsoletos" 	,;
 "Imprime doctos. obsoletos"	,;
 "Consulta doctos. vencidos"	,;
 "Imprime doctos. vencidos"	,;
 "Def. laudo final entrega" 	,;
 "Imprime param. relatórios"	,;
 "Transfere pendências"	,;
 "Usa relatório por e-mail" 	,;
 "Consulta posição cliente" 	,;
 "Manuten. aus. temp. todos"	,;
 "Manuten. aus. temp. usuário"	,;
 "Formação de preço" 	,;
 "Gravar resposta parâmetros"	,;
 "Configurar consulta F3"	,;
 "Permite alterar configuração  de impressora" 	,;
 "Gerar rel. em disco local"	,;
 "Gerar rel. no servidor" 	,;
 "Incluir solic. de compras" 	,;
 "MBrowse - Visualiza outras filiais" 	,;
 "MBrowse - Edita registros de outras filiais" 	,;
 "MBrowse - Permite o uso de filtro" 	,;
 "F3 - Permite o uso de filtro"	,;
 "MBrowse - Permite a configuração de colunas"	,;
 "Altera orçamento aprovado" 	,;
 "Revisa orçamento aprovado" 	,;
 "Usa impressora no server" 	,;
 "Usa impressora no client" 	,;
 "Agendar processos/relatórios" 	,;
 "Processos idênticos na MDI"	,;
 "Datas diferentes na MDI" 	,;
 "Cad. cli. no catálogo de e-mail" 	,;
 "Cad. for. no catálogo de e-mail" 	,;
 "Cad. ven. no catálogo de e-mail" 	,;
 "Impr. informações personalizadas" 	,;
 "Respeita parâmetro MV_WFMESSE" 	,;
 "Aprovar/Rejeitar pré-estrutura"	,;
 "Criar estrutura com base em pré-estrutura"	,;
 "Gerir etapas" 	,;
 "Gerir despesas"	,;
 "Liberar despesa para faturamento"	,;
 "Lib. ped. venda (crédito)" 	,;
 "Lib. ped. venda (estoque)"	,;
 "Habilitar opção Executar (CTRL+R)"	,;
 "Permite incluir ordem de produção" 	,;
 "Acesso via ActiveX" 	,;
 "Excluir bens" 	,;
 "Rateio do item por centro de custo" 	,;
 "Alterar o cadastro de clientes"	,;
 "Excluir cadastro de clientes" 	,;
 "Habilitar filtros nos relatórios" 	,;
 "Contatos no catálogo de e-mail" 	,;
 "Criar fórmulas nos relatórios" 	,;
 "Personalizar relatórios" 	,;
 "Acesso ao cadastro de lotes" 	,;
 "Gravar resposta de parâmetros por empresa"	,;
 "Manutenção no repositório de imagens" 	,;
 "Criar relatórios personalizáveis" 	,;
 "Permissão para utilizar o TOII" 	,;
 "Acesso ao SIGARPM" 	,;
 "Maiúsculo/minúsculo na consulta padrão"	,;
 "Valida acesso do grupo por emp/filial" 	,;
 "Acessa base instalada no cad.  técnicos"	,;
 "Desabilita opção usuários do menu" 	,;
 "Impressão local p/ componente gráfico" 	,;
 "Impressão em planilha"	,;
 "Acesso a scripts confidenciais" 	,;
 "Qualificação de suspects" 	,;
 "Execução de scripts dinâmicos"	,;
 "MDI - Permite encerrar ambiente pelo X" 	,;
 "Permite utilizar o WalkThru" 	,;
 "Geração de Forecast" 	,;
 "Execução de Mashup" 	,;
 "Permite exportar planilha PMS para Excel" 	,;
 "Gravar filtro do browse com Empresa/Filial" 	,;
 "Exportar telas para Excel (Mod 1 e 3)" 	,;
 "Se Administrador, pode utilizar o SIGACFG" 	,;
 "Se Administrador, pode utilizar o APSDU"	,;
 "Se acessa APSDU, é Read-Write"	,;
 "Acesso a inscrição nos eventos do EventViewer" 	,;
 "MBrowse - Permite utilização do localizador"	,;
 "Visualização via F3"	,;
 "Excluir purchase order"	,;
 "Alterar purchase order"	,;
"Excluir solicitação de importação"	,;
"Alterar solicitação de importação"	,;
"Excluir desembaraço"	,;
"Alterar desembaraço"	,;
"Incluir Agenda Médica"	,;
"Alterar Agenda Médica"	,;
"Excluir Agenda Médica"	,;
"Acesso a Fórmulas"}

Return(aReturn)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³ fCabec ºAutor ³Carlos G. Berganton º Data ³ 18/02/04        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc. ³ Quebra de Pagina e Imprime Cabecalho                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fCabec(nLin,nLimite)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do cabecalho do relatorio. . . ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nLin > nLimite
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 6
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³fGetMnu ºAutor ³Carlos G. Berganton º        Data ³ 15/03/04 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc. ³Obtem dados de um arquivo .xnu                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fGetMnu(cArq,cUsuario)

Local aRet := {}
Local aTmp := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre o Arquivo ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If File(cArq)
	ft_fuse(cArq)
Else
	//ApMsgAlert("Arquivo "+AllTrim(cArq)+" nao foi encontrado. Usuario "+AllTrim(cUsuario)+".")
	Return({})
Endif

While ! ft_feof()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Le linha do Arquivo ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cBuff := ft_freadln()
	aTmp := {}
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta Array com Dados da Linha ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAdd(aTmp,Substr(cBuff,01,02))
	aAdd(aTmp,Substr(cBuff,03,18))
	aAdd(aTmp,Substr(cBuff,21,10))
	aAdd(aTmp,Substr(cBuff,31,01))
	aAdd(aTmp,{})
	For i:=32 to 89 Step 3
		If Substr(cBuff,i,3)<>"..."
	   		aAdd(aTmp[5],Substr(cBuff,i,3))
		Endif
	Next
	aAdd(aTmp,Substr(cBuff,122,10))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Abastece Array de Retorno ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAdd(aRet,aTmp)
	
	ft_fskip()
EndDo

ft_fuse()

Return(aRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjustaSX1  ºAutor  ³Gustavo Lattmann   º Data ³  19/12/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria perguntas no SX1                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AjustSX1()

Local i

cPerg := PADR(cPerg,10)


PutSx1(cPerg,"01","Do ID..............?","Do ID..............?","Do ID..............?","mv_ch1","C",06,0,0,"G","","","","","mv_par01" )
PutSx1(cPerg,"02","Ate ID.............?","Ate ID.............?","Ate ID.............?","mv_ch2","C",06,0,0,"G","","","","","mv_par02" )
PutSx1(cPerg,"03","Do Usuario.........?","Do Usuario.........?","Do Usuario.........?","mv_ch3","C",15,0,0,"G","","","","","mv_par03" )
PutSx1(cPerg,"04","Ate Usuario........?","Ate Usuario........?","Ate Usuario........?","mv_ch4","C",15,0,0,"G","","","","","mv_par04" )
PutSx1(cPerg,"05","Ordem..............?","Ordem..............?","Ordem..............?","mv_ch5","N",01,0,2,"C","","","","","mv_par05","ID" ,"","","ID","Usuario")
PutSx1(cPerg,"06","Imprime Bloqueados.?","Imprime Bloqueados.?","Imprime Bloqueados.?","mv_ch6","N",01,0,2,"C","","","","","mv_par06","Sim","","","Sim","Nao" )
PutSx1(cPerg,"07","Imprime Horarios...?","Imprime Horarios...?","Imprime Horarios...?","mv_ch7","N",01,0,2,"C","","","","","mv_par07","Sim","","","Sim","Nao" )
PutSx1(cPerg,"08","Imprime Emp/Filiais?","Imprime Emp/Filiais?","Imprime Emp/Filiais?","mv_ch8","N",01,0,2,"C","","","","","mv_par08","Sim","","","Sim","Nao" )
PutSx1(cPerg,"09","Imprime Modulos....?","Imprime Modulos....?","Imprime Modulos....?","mv_ch9","N",01,0,2,"C","","","","","mv_par09","Sim","","","Sim","Nao" )
PutSx1(cPerg,"10","Imprime Acessos....?","Imprime Acessos....?","Imprime Acessos....?","mv_cha","N",01,0,2,"C","","","","","mv_par10","Sim","","","Sim","Nao" )
PutSx1(cPerg,"11","Imprime Menus......?","Imprime Menus......?","Imprime Menus......?","mv_chb","N",01,0,2,"C","","","","","mv_par11","Sim","","","Sim","Nao" )
PutSx1(cPerg,"12","Possui Acesso......?","Possui Acesso......?","Possui Acesso......?","mv_chc","N",03,0,0,"G","","","","","mv_par12" )   
PutSx1(cPerg,"13","Possui Menu........?","Possui Menu........?","Possui Menu........?","mv_chd","N",02,0,0,"G","","","","","mv_par13" )

Return