#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????
???Programa  ? FretExp   ? Autor ? Edison G. Barbieri  Data ?  11/06/19  ???
????????????????????????????????????????????????????????????????????????????
???Descricao ? Geracao de arquivo conforme layout da rm.                 ???
???          ?                                                           ???
????????????????????????????????????????????????????????????????????????????
???Uso       ? Cantu Oeste Imp. Exportação                               ???
????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????
/*/
// --------------------------------------------------------------------------------------
// Parametros especificos:
// MV_XFRETEX -> SEQUENCIAL DOS ARQUIVOS GERADOS PARA IMPORTAÇÃO
// TIPO:C EX.:000001
// --------------------------------------------------------------------------------------

User Function FretExt()

	Private oFretExt
	Private cPerg := "FretExt"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama função para monitor uso de fontes customizados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())

	@ 200,001 TO 380,380 DIALOG oFretExt TITLE OemToAnsi("Geracao de Arquivo Texto")
	@ 002,010 TO 080,190
	@ 010,018 Say " Este programa ira gerar um arquivo texto, conforme layout para  "
	@ 018,018 Say " IMPORTACAO RM."
	@ 60,090 BMPBUTTON TYPE 01 ACTION OkFretExt()
	@ 60,120 BMPBUTTON TYPE 02 ACTION Close(oFretExt)
	@ 60,150 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

	Activate Dialog oFretExt Centered

Return

Static Function OkFretExt

	Private nSeqRem	:= StrZero(Val(GetMV("MV_XFRETEX")),6)
	Private nHdl    := fCreate(AllTrim(mv_par01)+nSeqRem+".txt")

	Private cEOL    := "CHR(13)+CHR(10)"
	If Empty(cEOL)
		cEOL := CHR(13)+CHR(10)
	Else
		cEOL := Trim(cEOL)
		cEOL := &cEOL
	Endif

	If nHdl == -1
		MsgAlert("O arquivo de nome "+mv_par01+" nao pode ser executado! Verifique os parametros.","Atencao!")
		Return
	Endif

	Processa({|| RunCont() },"Processando...")
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RUNCONT ºAutor  ³  Edison G. Barbieri  º Data ³  11/06/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função auxiliar chamada pela PROCESSA. A função PROCESSA 	º±±
±±º          ³ monta a janela com a régua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RunCont
	Local cCampo	:= "DA4->DA4_XSQFEX"
	Local cLin
	Local nSeqReg	:= 0

	cSql := "SELECT DA4.DA4_FILIAL, DA4.DA4_COD, DA4.DA4_CHAPA, DA4.DA4_FORNEC, DA4.DA4_LOJA, DA4.DA4_NOME, DA4.DA4_CGC, DA4.DA4_DATNAS, "
	cSql += "DA4.DA4_ESTCIV, DA4.DA4_NACION, DA4.DA4_SEXO, DA4.DA4_END, DA4.DA4_XNUME, DA4.DA4_BAIRRO, DA4.DA4_EST, DA4.DA4_MUN, DA4.DA4_CEP, "
	cSql += "DA4.DA4_CGC, DA4.DA4_TEL, DA4.DA4_RG, DA4.DA4_RGEST, DA4.DA4_RGORG, DA4.DA4_NUMCNH, DA4.DA4_CATCNH, DA4.DA4_NATURA "
	//cSql += " "
	cSql += "FROM "+RetSqlName("DA4")+" DA4 "
	cSql += "WHERE DA4.D_E_L_E_T_ = ' ' "
	cSql += "AND DA4.DA4_FILIAL BETWEEN '"+mv_par02+"' AND '"+mv_par03+"' "
	cSql += "AND DA4.DA4_CHAPA BETWEEN '"+mv_par04+"' AND '"+mv_par05+"' "
	cSql += "AND DA4.DA4_FORNEC BETWEEN '"+mv_par06+"' AND '"+mv_par07+"' "
	cSql += "AND DA4.DA4_LOJA BETWEEN '"+mv_par08+"' AND '"+mv_par09+"' "
	//cSql += "AND DA4.DA4_XSQFEX = ' ' "

	cSql += "ORDER BY DA4.DA4_FILIAL, DA4.DA4_CHAPA, DA4.DA4_FORNEC, DA4.DA4_LOJA

	TcQuery cSql NEW ALIAS "TMPDA4"
	Memowrite("C:\freteiros.txt",cSql)

	TMPDA4->(dbSelectArea("TMPDA4"))
	TMPDA4->(dbGoTop())

	// monta toda a estrutura do arquivo, posição por posição.

	ProcRegua(RecCount())
	While !TMPDA4->(EOF())

		IncProc()
		cLin 	:= ""
		cLin 	+= SubStr(ALLTRIM(TMPDA4->DA4_CHAPA)+";",1,16)		//1 PFUNC.CHAPA
		cLin 	+= SubStr(ALLTRIM(TMPDA4->DA4_NOME)+";",1,120)		//2 PPESSOA.NOME
		cLin 	+= ";"		                                        //3 PPESSOA.APELIDO
		cLin 	+= SubStr(ALLTRIM(TMPDA4->DA4_DATNAS),7,2)	        //4 PESSOA.DTNASCIMENTO
		cLin 	+= SubStr(ALLTRIM(TMPDA4->DA4_DATNAS),5,2)	        //4 PESSOA.DTNASCIMENTO
		cLin 	+= SubStr(ALLTRIM(TMPDA4->DA4_DATNAS),1,4)+";"	    //4 PESSOA.DTNASCIMENTO
		cLin 	+= SubStr(ALLTRIM(TMPDA4->DA4_ESTCIV),1,1)+";"	    //5 PPESSOA.ESTADOCIVIL
		cLin 	+= SubStr(ALLTRIM(TMPDA4->DA4_SEXO),1,1)+";"	    //6 PPESSOA.SEXO
		cLin 	+= SubStr(ALLTRIM(TMPDA4->DA4_NACION),1,3)+";"	    //6 PPESSOA.NACIONALIDADE
		cLin 	+= "7"+";"                                    	    //8 PPESSOA.GRAUINSTRUCAO
		cLin 	+= SubStr(ALLTRIM(TMPDA4->DA4_END),1,30)+";"        //9 PESSOA.RUA 
		cLin 	+= SubStr(ALLTRIM(TMPDA4->DA4_XNUME),1,8)+";"       //10 PPESSOA.NUMERO 
		cLin 	+= ";"		                                        //11 PPESSOA.COMPLEMENTO
        cLin 	+= SubStr(ALLTRIM(TMPDA4->DA4_BAIRRO),1,20)+";"     //12 PPESSOA.BAIRRO
        cLin 	+= SubStr(ALLTRIM(TMPDA4->DA4_EST),1,2)+";"         //13 PPESSOA.ESTADO
        cLin 	+= SubStr(ALLTRIM(TMPDA4->DA4_MUN),1,32)+";"        //14 PPESSOA.CIDADE
        cLin 	+= SubStr(ALLTRIM(TMPDA4->DA4_CEP),1,9)+";"         //15 PPESSOA.CEP
        cLin 	+= "Brasil"+";"                                     //16 PPESSOA.PAIS
        cLin 	+= ";"		                                        //17 PPESSOA.REGPROFISSIONAL
        cLin 	+= SubStr(ALLTRIM(TMPDA4->DA4_CGC),1,12)+";"        //18 PPESSOA.CPF
        cLin 	+= SubStr(ALLTRIM(TMPDA4->DA4_TEL),1,15)+";"        //19 PPESSOA.TELEFONE1
        cLin 	+= ";"		                                        //20 PPESSOA.TELEFONE2
        cLin 	+= SubStr(ALLTRIM(TMPDA4->DA4_RG),1,15)+";"         //21 PPESSOA.CARTIDENTIDADE
        cLin 	+= SubStr(ALLTRIM(TMPDA4->DA4_RGEST),1,2)+";"       //22 PPESSOA.UFCARTIDENT
        cLin 	+= SubStr(ALLTRIM(TMPDA4->DA4_RGORG),1,15)+";"      //23 PPESSOA.ORGEMISSORIDENT
        cLin 	+= ";"		                                        //24 PPESSOA.DTEMISSAOIDENT
        cLin 	+= ";"		                                        //25 PPESSOA.DTVENCIDENT
        cLin 	+= ";"		                                        //26 PPESSOA.TITULOELEITOR
        cLin 	+= ";"		                                        //27 PPESSOA.ZONATITELEITOR
        cLin 	+= ";"		                                        //28 PPESSOA.SECAOTITELEITOR
        cLin 	+= "9999999999"+";"                                 //29 PPESSOA.CARTEIRATRAB
        cLin 	+= ";"		                                        //30 PPESSOA.SERIECARTTRAB
        cLin 	+= ";"		                                        //31 PPESSOA.UFCARTTRAB
        cLin 	+= ";"		                                        //32 PPESSOA.DTCARTTRAB
        cLin 	+= ";"		                                        //33 PPESSOA.DTVENCCARTTRAB
        cLin 	+= "0"+";"                                          //34 PPESSOA.NIT
        cLin 	+= SubStr(ALLTRIM(TMPDA4->DA4_NUMCNH),1,15)+";"     //35 PPESSOA.CARTMOTORISTA  
        cLin 	+= SubStr(ALLTRIM(TMPDA4->DA4_CATCNH),1,5)+";"      //36 PPESSOA.TIPOCARTHABILIT
        cLin 	+= ";"		                                        //33 PPESSOA.DTVENCHABILIT  
        cLin 	+= ";"		                                        //38 PPESSOA.CERTIFRESERV
        cLin 	+= ";"		                                        //39 PPESSOA.CATEGMILITAR
        cLin 	+= SubStr(ALLTRIM(TMPDA4->DA4_NATURA),1,32)+";"     //40 PPESSOA.NATURALIDADE
        cLin 	+= SubStr(ALLTRIM(TMPDA4->DA4_EST),1,2)+";"         //41 PPESSOA.ESTADO
        cLin 	+= ";"		                                        //42 PPESSOA.DATACHEGADA
        cLin 	+= ";"		                                        //43 PPESSOA.CARTMODELO19
        cLin 	+= "1"+";"	                                        //44 PPESSOA.CONJUGEBRASIL
        cLin 	+= "0"+";"	                                        //45 PPESSOA.NATURALIZADO
        cLin 	+= "0"+";"	                                        //46 PPESSOA.FILHOSBRASIL
        cLin 	+= "0"+";"	                                        //47 PPESSOA.NROFILHOSBRASIL
        cLin 	+= ";"		                                        //48 PPESSOA.NROREGGERAL
        cLin 	+= ";"		                                        //49 PPESSOA.NRODECRETO
        cLin 	+= ";"		                                        //50 PPESSOA.TIPOVISTO
        cLin 	+= ";"		                                        //51 PPESSOA.EMAIL
        cLin 	+= ";"		                                        //52 ?
        cLin 	+= ";"		                                        //53 PFUNC.NROFICHAREG
        cLin 	+= ";"		                                        //54 PFUNC.CODRECEBIMENTO
        cLin 	+= "A"+";"		                                    //55 PFUNC.CODSITUACAO
        cLin 	+= "A"+";"		                                    //56 PFUNC.CODTIPO
        cLin 	+= SubStr(ALLTRIM(TMPDA4->DA4_FILIAL),1,2)  		//57 PFUNC.CODSECAO
        cLin 	+= ".01.001"+";"		                            //57 PFUNC.CODTIPO
        cLin 	+= "077"+";"	                                    //58 PFUNC.CODFUNCAO
        cLin 	+= "10"+";"	                                        //59 PFUNC.CODSINDICATO
        cLin 	+= "220:00"+";"	                                    //60 PFUNC.JORNADAMENSAL
        cLin 	+= SubStr(ALLTRIM(TMPDA4->DA4_FILIAL),1,2)  		//61 PFUNC.CODHORARIO
        If SubStr(ALLTRIM(TMPDA4->DA4_FILIAL),1,2) == '01'
        	cLin += "013"+";"	                                    //61 PFUNC.CODHORARIO	
        Elseif SubStr(ALLTRIM(TMPDA4->DA4_FILIAL),1,2) == '02'
            cLin +=	"008"+";"	                                    //61 PFUNC.CODHORARIO        
        Elseif SubStr(ALLTRIM(TMPDA4->DA4_FILIAL),1,2) == '04'
            cLin +=	"032"+";"	                                    //61 PFUNC.CODHORARIO
        Elseif SubStr(ALLTRIM(TMPDA4->DA4_FILIAL),1,2) == '05'
            cLin +=	"998"+";"	                                    //61 PFUNC.CODHORARIO
        Elseif SubStr(ALLTRIM(TMPDA4->DA4_FILIAL),1,2) == '10'
            cLin +=	"013"+";"	                                    //61 PFUNC.CODHORARIO
        Elseif SubStr(ALLTRIM(TMPDA4->DA4_FILIAL),1,2) == '11'
            cLin +=	"007"+";"	                                    //61 PFUNC.CODHORARIO                
        EndIf
        cLin 	+= ";"		                                        //62 PFUNC.NRODEPIRRF
        cLin 	+= ";"		                                        //63 PFUNC.NRODEPSALFAM
        cLin 	+= GRAVADATA( DDATABASE, .F., 5 )+";"               //64 PFUNC.DTBASE
        cLin 	+= "0"+";"  	                                    //65 PFUNC.SALARIO
        cLin 	+= "2"+";"  	                                    //66 PFUNC.SITUACAOFGTS
        cLin 	+= ";"		                                        //67 PFUNC.DTOPCAOFGTS
        cLin 	+= ";"		                                        //68 PFUNC.CONTAFGTS
        cLin 	+= ";"		                                        //69 PFUNC.SALDOFGTS
        cLin 	+= ";"		                                        //70 PFUNC.DTSALDOFGTS
        cLin 	+= ";"		                                        //71 PFUNC.PISPASEP
        cLin 	+= ";"		                                        //72 PFUNC.DTCADASTROPIS
        cLin 	+= ";"		                                        //73 PFUNC.CODBANCOPIS
        cLin 	+= "J"+";"  	                                    //74 PFUNC.CONTRIBSINDICAL
        cLin 	+= "0"+";"  	                                    //75 PFUNC.APOSENTADO
        cLin 	+= "0"+";"  	                                    //76 PFUNC.TEMMAIS65ANOS
        cLin 	+= ";"		                                        //77 PFUNC.AJUDACUSTO
        cLin 	+= ";"		                                        //78 PFUNC.PERCENTADIANT
        cLin 	+= ";"		                                        //79 PFUNC.ARREDONDAMENTO
        cLin 	+= GRAVADATA( DDATABASE, .F., 5 )+";"               //80 PFUNC.DATAADMISSAO
        cLin 	+= "R"+";"  	                                    //81 PFUNC.TIPOADMISSAO
        cLin 	+= ";"		                                        //82 PFUNC.DTTRANSFERENCIA
        cLin 	+= "01"+";"  	                                    //83 PFUNC.MOTIVOADMISSAO
        cLin 	+= "0"+";"  	                                    //83 PFUNC.TEMPRAZOCONTR
        cLin 	+= ";"		                                        //84 PFUNC.DTTRANSFERENCIA
        cLin 	+= ";"		                                        //85 PFUNC.FIMPRAZOCONTR
        cLin 	+= ";"		                                        //86 PFUNC.DATADEMISSAO
        cLin 	+= ";"		                                        //87 PFUNC.TIPODEMISSAO
        cLin 	+= ";"		                                        //88 PFUNC.MOTIVODEMISSAO
        cLin 	+= ";"		                                        //89 PFUNC.DTDESLIGAMENTO
        cLin 	+= ";"		                                        //90 PFUNC.DTULTIMOMOVIM
        cLin 	+= ";"		                                        //91 PFUNC.DTPAGTORESCISAO
        cLin 	+= ";"		                                        //92 PFUNC.CODSAQUEFGTS
        cLin 	+= "0"+";"  	                                    //93 PFUNC.TEMAVISOPREVIO
        cLin 	+= ";"		                                        //94 PFUNC.DTAVISOPREVIO
        cLin 	+= ";"		                                        //95 PFUNC.NRODIASAVISO
        cLin 	+= ";"		                                        //96 PFUNC.DTVENCFERIAS
        cLin 	+= ";"		                                        //97 PFUNC.INICPROGFERIAS
        cLin 	+= ";"		                                        //98 PFUNC.FIMPROGFERIAS
        cLin 	+= "1"+";"  	                                    //99 PFUNC.QUERABONO
        cLin 	+= "1"+";"  	                                    //100 PFUNC.QUER1APARC13O
        cLin 	+= ";"		                                        //101 PFUNC.NRODIASADIANTFER
        cLin 	+= ";"		                                        //102 PFUNC.EVTADIANTFERIAS
        cLin 	+= "0"+";"  	                                    //103 PFUNC.FERIASCOLETIVAS
        cLin 	+= ";"		                                        //104 PFUNC.NRODIASFERIAS
        cLin 	+= ";"		                                        //105 PFUNC.NRODIASABONO
        cLin 	+= ";"		                                        //106 PFUNC.SALDOFERIAS
        cLin 	+= ";"		                                        //107 PFUNC.SALDOFERIASANT
        cLin 	+= ";"		                                        //108 PFUNC.SALDOFERANTAUX
        cLin 	+= ";"		                                        //109 PFUNC.OBSFERIAS
        cLin 	+= ";"		                                        //110 PFUNC.DTPAGTOFERIAS
        cLin 	+= ";"		                                        //111 PFUNC.DTAVISOFERIAS
        cLin 	+= ";"		                                        //112 PFUNC.NDIASLICREM1
        cLin 	+= ";"		                                        //113 PFUNC.NDIASLICREM2
        cLin 	+= ";"		                                        //114 PFUNC.DTINICIOLICENCA
        cLin 	+= ";"		                                        //115 PFUNC.MEDIASALMATERN
        cLin 	+= "1"+";" 	                                        //116 PFUNC.SITUACAORAIS
        cLin 	+= ";"		                                        //117 PFUNC.CODBANCOPAGTO
        cLin 	+= ";"		                                        //118 PFUNC.CODAGENCIAPAGTO
        cLin 	+= ";"		                                        //119 PFUNC.CONTAPAGAMENTO
        cLin 	+= "0"+";" 	                                        //120 PFUNC.MEMBROSINDICAL
        cLin 	+= ";"		                                        //121 PFUNC.VINCULORAIS
        cLin 	+= "0"+";" 	                                        //122 PFUNC.USAVALETRANSP
        cLin 	+= ";"		                                        //123 PFUNC.DIASUTEISMES
        cLin 	+= ";"		                                        //124 PFUNC.DIASUTMEIOEXP
        cLin 	+= ";"		                                        //125 PFUNC.DIASUTPROXMES
        cLin 	+= ";"		                                        //126 PFUNC.DIASUTPROXMEIO
        cLin 	+= ";"		                                        //127 PFUNC.DIASUTRESTANTES
        cLin 	+= ";"		                                        //128 PFUNC.DIASUTRESTMEIO
        cLin 	+= "0"+";"		                                    //129 PFUNC.MUDOUENDERECO
        cLin 	+= "0"+";"		                                    //130 PFUNC.MUDOUCARTTRAB
        cLin 	+= ";"		                                        //131 PFUNC.ANTIGACARTTRAB
        cLin 	+= ";"		                                        //132 PFUNC.ANTIGASERIECART
        cLin 	+= "0"+";"		                                    //133 PFUNC.MUDOUNOME
        cLin 	+= ";"		                                        //134 PFUNC.ANTIGONOME
        cLin 	+= "0"+";"		                                    //135 PFUNC.MUDOUPIS
        cLin 	+= ";"		                                        //136 PFUNC.ANTIGOPIS
        cLin 	+= "0"+";"		                                    //137 PFUNC.MUDOUCHAPA
        cLin 	+= ";"		                                        //138 PFUNC.ANTIGACHAPA
        cLin 	+= "0"+";"		                                    //139 PFUNC.MUDOUADMISSAO
        cLin 	+= ";"		                                        //140 PFUNC.ANTIGADTADM
        cLin 	+= ";"		                                        //141 PFUNC.ANTIGOVINCULO
        cLin 	+= ";"		                                        //142 PFUNC.ANTIGOTIPOFUNC
        cLin 	+= ";"		                                        //143 PFUNC.ANTIGOTIPOADM
        cLin 	+= "0"+";"		                                    //144 PFUNC.MUDOUDTOPCAO
        cLin 	+= ";"		                                        //145 PFUNC.ANTIGADTOPCAO
        cLin 	+= "0"+";"		                                    //146 PFUNC.MUDOUSECAO
        cLin 	+= ";"		                                        //147 PFUNC.ANTIGASECAO
        cLin 	+= "0"+";"		                                    //148 PFUNC.MUDOUDTNASCIM
        cLin 	+= ";"		                                        //149 PFUNC.ANTIGADTNASCIM
        cLin 	+= "0"+";"		                                    //150 PFUNC.FALTAALTERFGTS
        cLin 	+= "0"+";"		                                    //151 PFUNC.DEDUZIRRF65
        cLin 	+= ";"		                                        //152 PFUNC.PISPARAFGTS
        cLin 	+= ";"		                                        //153 PFUNC.CODBANCOFGTS
        cLin 	+= ";"		                                        //154
        cLin 	+= ";"		                                        //155 PFUNC.CODFILIAL 
        cLin 	+= "0"+";"		                                    //156 PFUNC.INDINICIOHOR
        cLin 	+= "1"+";"		                                    //157 PFUNC.USASALCOMPOSTO
        cLin 	+= "0"+";"		                                    //158 PFUNC.MEMBROCIPA
        cLin 	+= ";"		                                        //159 PFUNC.OPBANCARIA
        cLin 	+= ";"		                                        //160 PFUNC.NUMVEZESDESCEMPRESTIMO
        cLin 	+= ";"		                                        //161 PFUNC.DATAINICIODESCEMPRESTIMO
        cLin 	+= ";"		                                        //162 PFUNC.GRUPOSALARIAL
        cLin 	+= "1"+";"		                                    //163 PFUNC.REGATUAL
        cLin 	+= ";"		                                        //164
        cLin 	+= ";"		                                        //165 PFUNC.CODOCORRENCIA
        cLin 	+= ";"		                                        //166 PFUNC.CODCATEGORIA
        cLin 	+= ";"		                                        //167 PFUNC.CLASSECONTRIB
        cLin 	+= ";"		                                        //168 PFUNC.CODEQUIPE
        cLin 	+= "0"+";"		                                    //169 PFUNC.ESUPERVISOR
        cLin 	+= ";"		                                        //170 PFUNC.INTEGRCONTABIL
        cLin 	+= ";"		                                        //171 PFUNC.INTEGRGERENCIAL
        cLin 	+= "0"+";"		                                    //172 PFUNC.USACONTROLEDESALDO
        cLin 	+= ";"		                                        //173 PFUNC.CI
        cLin 	+= "0"+";"		                                    //174 PFUNC.MUDOUCI
        cLin 	+= ";"		                                        //175 PFUNC.ANTIGOCI
        cLin 	+= ";"		                                        //176 PFUNC.PERIODORESCISAO
        cLin 	+= ";"		                                        //177 PFUNC.CORRACA
        cLin 	+= ";"		                                        //178 PFUNC.DEFICIENTEFISICO  
        cLin 	+= "0"+";"		                                    //179 PFUNC.FGTSMESANTRECOLGRFP
        cLin 	+= ";"		                                        //180 PFUNC.CODNIVELSAL
        cLin 	+= ";"		                                        //181 PFUNC.NRODIASFERIASJORNRED
        cLin 	+= "1"+";"		                                    //182 PFUNC.POSSUIALVARAMENOR16
        cLin 	+= ";"		                                        //183 PFUNC.SITUACAOINSS
        cLin 	+= ";"		                                        //184 PFUNC.DTAPOSENTADORIA
        cLin 	+= "0"+";"		                                    //185 PFUNC.QUERADIANTAMENTO
        cLin 	+= ";"		                                        //186 PFUNC.DTPROXAQUISFERIAS
        cLin 	+= ";"		                                        //187 PFUNC.CODCOLFORNEC
        cLin 	+= ";"		                                        //188 PFUNC.CODFORNECEDOR
        cLin 	+= ";"		                                        //189 PFUNC.DEFICIENTEAUDITIVO
        cLin 	+= ";"		                                        //190 PFUNC.DEFICIENTEFALA
        cLin 	+= ";"		                                        //191 PFUNC.DEFICIENTEMENTAL
        cLin 	+= ";"		                                        //192 PFUNC.DEFICIENTEVISUAL
        cLin 	+= ";"		                                        //193 PFUNC.CODMUNICIPIO
        cLin 	+= ";"		                                        //194 PFUNC.LOCALIDADE
        cLin 	+= "0"+";"		                                    //195 PFUNC.POSICAOABONO
        cLin 	+= ";"		                                        //196 PFUNC.NRODIASFERIASCORRIDOS
        cLin 	+= ";"		                                        //197 PFUNC.PAISORIGEM
        
        
          
		clin 	+= cEOL

		If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
				Exit
			Endif
		Endif

		cChaveA2 := TMPDA4->DA4_FILIAL+TMPDA4->DA4_COD

		DbSelectArea("DA4")
		DA4->(DbSetOrder(1))
		DA4->(DbGotop())
		If DbSeek(cChaveA2)
			RecLock("DA4",.F.)
			&cCampo := nSeqRem

			MsUnlock("DA4")
		Endif

		nSeqReg += 1 					// Sequencial de registros

		TMPDA4->(DbSelectArea("TMPDA4"))
		TMPDA4->(dbSkip())

	EndDo
	TMPDA4->(DbSelectArea("TMPDA4"))
	TMPDA4->(DbCloseArea())

	If nSeqReg > 0
		MsgAlert("Total de registros exportados: "+Str(nSeqReg))
		PutMv("MV_XFRETEX",StrZero(Val(GetMV("MV_XFRETEX"))+1,6))
	Else
		MsgAlert("Nenhum registro encontrado.")
	Endif

	fClose(nHdl)
	Close(oFretExt)

Return

