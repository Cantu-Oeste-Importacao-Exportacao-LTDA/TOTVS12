#ifdef SPANISH
	#define STR0001 "Confirmar"
	#define STR0002 "Salir"
	#define STR0003 "Rehace datos Clientes/Proveedores"
	#define STR0004 "  El objetivo de este programa es recalcular los saldos acumulados de "
	#define STR0005 "clientes o proveedores.                                             "
	#define STR0006 "  El objetivo de este programa es recalcular los datos acumulados de "
	#define STR0007 "clientes o proveedores.                                            "
	#define STR0008 "Error en la llamada del proceso"
	#define STR0009 "Actualizacion OK"
	#define STR0010 "Actualizacion con Error"
	#define STR0011 "Parametros"
	#define STR0012 "Visualizar"
#else
	#ifdef ENGLISH
		#define STR0001 "OK"
		#define STR0002 "Quit "
		#define STR0003 "Redo Customers/Suppliers Data"
		#define STR0004 "This program has the purpose of recalculating accumulated balances "
		#define STR0005 "of customers and/or suppliers.                                     "
		#define STR0006 "This program has the purpose of recalculating accumulated data of  "
		#define STR0007 "customers and/or suppliers.                                        "
		#define STR0008 "Process call error"
		#define STR0009 "Update OK"
		#define STR0010 "Updating Error"
		#define STR0011 "Parameters"
		#define STR0012 "View"
	#else
		#define STR0001  "Confirma"
		#define STR0002  "Abandona"
		#define STR0003  "Refaz Dados Clientes/Fornecedores"
		#define STR0004  "  Este programa tem como objetivo recalcular os saldos acumulados de    "
		#define STR0005  "clientes e/ou fornecedores.                                             "
		#define STR0006  "   Este programa tem como objetivo recalcular os dados acumulados de "
		#define STR0007  "clientes e/ou fornecedores.                                          "
		#define STR0008  "Erro na chamada do processo"
		#define STR0009  "Atualizacao OK"
		#define STR0010  "Atualizacao com Erro"
		#define STR0011  "Parâmetros"
		#define STR0012  "Visualizar"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0002 := "Abandonar"
			STR0003 := "Refaz Dados Clientes/fornecedores"
			STR0004 := "  este programa tem como objectivo recalcular os saldos acumulados de    "
			STR0005 := "Clientes e/ou fornecedores.                                             "
			STR0006 := "   este programa tem como objectivo recalcular os dados acumulados de "
			STR0007 := "Clientes e/ou fornecedores.                                          "
			STR0008 := "Houve um erro na chamada do processo"
			STR0009 := "Actualização Ok"
			STR0010 := "Actualização Com Erros"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
