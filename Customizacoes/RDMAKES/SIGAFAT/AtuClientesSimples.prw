#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

// Atualização de clientes (optantes pelo simples) conforme layout pre-definido.
// Exemplo de layout:
// CNPJ/CPF 	 ; BASE;    DATA OPÇÃO
// 00057223000195;	RJU;	01/07/2007

User Function ImpCli02()

Private oLeTxt
Private cPerg := "IMPCLI0002"
Private cUFs := Space(100)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

ValidPerg()
Pergunte(cPerg,.F.)

@ 200,001 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Atualização de Clientes")
@ 002,010 TO 080,190
@ 010,018 Say " Programa para atualização do cadastro de clientes optantes "
@ 018,018 Say " pelo simples."
@ 030,010 Say "UFs : (Separadas por /)"
@ 040,010 Get cUFs Size 100, 30
@ 60,090 BMPBUTTON TYPE 01 ACTION OkLeTxt()
@ 60,120 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)
@ 60,150 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oLeTxt Centered

Return()

// Verifica arquivo
Static Function OkLeTxt()      
Private nHdl    := FT_FUSE(mv_par01)

If nHdl == -1
   MsgAlert("O arquivo " + mv_par01 + " não pode ser aberto! Verifique se o arquivo existe.","Atencao!")
   Return
Endif

Processa({|| RunCont() },"Processando...")

Return

// Processa arquivo
Static Function RunCont()
Local cCGC 		:= ""
Local cData		:= ""
Local nVer 		:= 0
Local cLog	 	:= fCreate("c:\logimpcli002.txt")
Local cEOL    	:= "CHR(13)+CHR(10)" 

If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

aCliente		:= {}
FT_FGOTOP()
ProcRegua(FT_FLASTREC())
While !FT_FEOF()
	IncProc("Processando CNPJ "+SubStr(Ft_Freadln(),1,14))
	cLin := Ft_Freadln()
	For nR := 1 To Len(cLin)
		If SubStr(cLin,nR,1) == ";"
			nVer += 1
		Endif	
		If SubStr(cLin,nR,1) <> ";" .AND. SubStr(cLin,nR,1) <> '	' 
			Do Case
				Case nVer = 0
					If !Empty(SubStr(cLin,nR,1)) 
						cCGC += SubStr(cLin,nR,1)
					Endif
				Case nVer = 2
					If !Empty(SubStr(cLin,nR,1))  
						cData += SubStr(cLin,nR,1)
					Endif
			EndCase
		Endif
	Next nR
	If !Empty(cData)
		SA1->(DbSelectArea("SA1"))
		SA1->(DbSetOrder(3))                                                       // Processa somente para as ufs informadas
		If SA1->(DbSeek(xFilial("SA1")+cCGC)) .And. (SA1->A1_SIMPNAC != '1') .And. (SA1->A1_EST $ cUFs)
	      SA1->(RecLock("SA1",.F.))
				SA1->A1_SIMPNAC	:= '1'
				cMsg :=   + "Optante pelo simples desde " + cData
				
				if !(cMsg $ SA1->A1_OBSRJU)				
					SA1->A1_OBSRJU := SA1->A1_OBSRJU + CHR(13) + CHR(10)
				EndIf
				
				if (SA1->A1_EST = "SC") .And. Empty(SA1->A1_GRPTRIB)
					SA1->A1_GRPTRIB := "001"
				EndIf
				
	   	  SA1->(MsUnlock())
	    	cLin := "CLIENTE "+SA1->A1_COD+" "+SA1->A1_NOME+" COM O CNPJ: "+cCGC+" ATUALIZADO COM SUCESSO."
			cLin += cEOL 
			fWrite(cLog,cLin,Len(cLin))	        
		Else
	 		cLin := "CLIENTE COM O CNPJ: "+cCGC+" NÃO CADASTRADO OU NÃO ATUALIZADO."
			cLin += cEOL 
			fWrite(cLog,cLin,Len(cLin))			
		Endif
	Else
    	cLin := "CLIENTE COM O CNPJ: "+cCGC+" NÃO OPTANTE PELO SIMPLES."
		cLin += cEOL 
		fWrite(cLog,cLin,Len(cLin))	
	Endif
	nVer := 0
	cCGC 	:= ""
	cData  := ""
	FT_FSKIP()
End
FT_FUSE()
fClose(nHdl)
Close(oLeTxt)
MsgAlert("Atualização efetuada com sucesso.")

MS_FLUSH()

Return()

Static Function ValidPerg()
Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)

cPerg := PADR(cPerg,10)
// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DEFSP1/DFENG1/Cnt01/Var02/Def02/DEFSP1/DFENG1/Cnt02/Var03/Def03/DEFSP1/DFENG1/Cnt03/Var04/Def04/DEFSP1/DFENG1/Cnt04/Var05/Def05/DEFSP1/DFENG1/Cnt05
aAdd(aRegs,{cPerg,"01","Local do Arquivo      ?","","","mv_ch1","C",50,0,0,"F",""        ,"mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
    If !dbSeek(cPerg+aRegs[i,2])
        RecLock("SX1",.T.)
        For j:=1 to FCount()
            If j <= Len(aRegs[i])
                FieldPut(j,aRegs[i,j])
            Endif
        Next
        MsUnlock()
    Endif
Next
dbSelectArea(_sAlias)

Return