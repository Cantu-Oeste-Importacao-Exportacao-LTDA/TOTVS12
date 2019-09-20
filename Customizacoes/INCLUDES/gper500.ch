#ifdef SPANISH
	#define STR0001 "Detalle de movimiento de empleados (Turn-Over)  "
	#define STR0002 "Se imprimira de acuerdo con los parametros solicitados por"
	#define STR0003 "el usuario."
	#define STR0004 "A rayas"
	#define STR0005 "Administracion"
	#define STR0006 "DETALLE DE MOVIMIENTOS DE EMPLEADOS "
	#define STR0007 "                                          MOVIMIENTO DE EMPLEADOS       -  "
	#define STR0008 " A "
	#define STR0009 "|MES/ANO |  INICIO  | ADMISION | ENT TRANSF | SALI TRANSF| DEMISION |   FIN   |"
	#define STR0010 "Seleccionando registros..."
	#define STR0011 "SUCURSAL"
	#define STR0012 "Movimiento de empleados"
	#define STR0013 "Esta rutina efectua la impresion de la cantidad de movimiento de empleados dentro da empresa, es decir,  la cantidad de empleados dimitidos, admitidos y transferidos."
	#define STR0014 "Total de Sucur."
#else
	#ifdef ENGLISH
		#define STR0001 "Report on Emplyees Transactions       (Turn-Over)"
		#define STR0002 "It will be printed according to the parameters selected "
		#define STR0003 "by the User.   "
		#define STR0004 "Z.Form "
		#define STR0005 "Management   "
		#define STR0006 "REPORT ON EMPLOYEES TRANSACTIONS     "
		#define STR0007 "                                          EMPLOYEES TRANSACTIONS        -  "
		#define STR0008 " A "
		#define STR0009 "|MTH/YR. |  START   | ADMISSION| ENT.TRANSF.| EXITTRANSF.| DISMISSAL|   END   |"
		#define STR0010 "Selecting Records...     "
		#define STR0011 "BRANCH: "
		#define STR0012 "Employees movements         "
		#define STR0013 "This routine prints the number of movements of employees within the company, i.e., the number of employees dismissed, admitted and transferred.                         "
		#define STR0014 "Branch total    "
	#else
		#define STR0001  "Relaçäo de Movimentaçöes Funcionarios (Turn-Over)"
		#define STR0002  "Sera impresso de acordo com os parametros solicitados pelo"
		#define STR0003  "usuario."
		#define STR0004  "Zebrado"
		#define STR0005  "Administraçäo"
		#define STR0006  "RELAÇÄO DE MOVIMENTAÇÖES FUNCIONARIOS"
		#define STR0007  "                                          MOVIMENTACAO DE FUNCIONARIOS  -  "
		#define STR0008  " A "
		#define STR0009  "|MES/ANO |  INICIO  | ADMISSAO | ENT.TRANSF.| SAI.TRANSF.| DEMISSAO |   FIM   |"
		#define STR0010  "Selecionando Registros..."
		#define STR0011  "FILIAL:  "
		#define STR0012  "Movimentacao de funcionarios"
		#define STR0013  "Esta rotina faz a impressão da quantidade de movimentacao de funcionarios dentro da empresa, ou seja,  a quantidade de funcionarios demitidos, admitidos e transferidos."
		#define STR0014  "Total da Filial"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "ANG"
			STR0001 := "Relação de Movimentações Empregados (Turn-Over)"
			STR0002 := "Sera impresso de acordo com os parâmetro s solicitados pelo"
			STR0003 := "Utilizador."
			STR0004 := "Código de barras"
			STR0005 := "Administração"
			STR0006 := "RELAÇÃO DE MOVIMENTAÇÕES DE EMPREGADOS"
			STR0007 := "                                          movimentação de empregados  -  "
			STR0008 := " a "
			STR0009 := "|mês/ano |  início  | admissão | ent.transf.| sai.transf.| demissão |   fim   |"
			STR0010 := "A Seleccionar Registos..."
			STR0011 := "Filial:"
			STR0012 := "Movimentação de empregados"
			STR0013 := "Esta rotina faz a impressão da quantidade de movimentação de empregados dentro da empresa, ou seja,  a quantidade de empregados demitidos, admitidos e transferidos."
			STR0014 := "Total Da Filial"
		ElseIf cPaisLoc == "PTG"
			STR0001 := "Relação de Movimentações Empregados (Turn-Over)"
			STR0002 := "Sera impresso de acordo com os parâmetro s solicitados pelo"
			STR0003 := "Utilizador."
			STR0004 := "Código de barras"
			STR0005 := "Administração"
			STR0006 := "RELAÇÃO DE MOVIMENTAÇÕES DE EMPREGADOS"
			STR0007 := "                                          movimentação de empregados  -  "
			STR0008 := " a "
			STR0009 := "|mês/ano |  início  | admissão | ent.transf.| sai.transf.| demissão |   fim   |"
			STR0010 := "A Seleccionar Registos..."
			STR0011 := "Filial:"
			STR0012 := "Movimentação de empregados"
			STR0013 := "Esta rotina faz a impressão da quantidade de movimentação de empregados dentro da empresa, ou seja,  a quantidade de empregados demitidos, admitidos e transferidos."
			STR0014 := "Total Da Filial"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
