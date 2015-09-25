%{

#include <iostream>
#include <stdlib.h>
#include <map>
#include <vector>
#include <string>
#include "parser.h"
#include "semantic.h"
#include "asmv.h"

using namespace std;

extern unsigned long int currentAddress;
extern int round;
extern map<string, unsigned long int> symbolTable;

extern "C" int yylex();
extern "C" int yyparse();

void yyerror(const char *);

%}

%union {
    char * string;
    unsigned long int number;
}

%token	<number>	INTEGER REGISTER NEWLINE

%token	<string>	LABEL_DECL LABEL

%token			ADDU ADD AND JR NOR
			OR SLT SLTU SLL SRL
			SUBU SUB XOR
			ADDIU ADDI ANDI BEQ BNE
			LUI LW ORI SLTI SLTIU
			SW LL SC XORI J JAL
			HALT PUSH POP NOP ORG
			CHW CFW 
			VADDU VADD VAND VNOR
			VOR VSLT VSLTU VSLL VSRL
			VSUBU VSUB VXOR
			VADDIU VADDI VANDI VLUI 
			VLW VORI VSLTI VSLTIU
			VSW VXORI 

%token			COMMA LPAR RPAR

%type	<number>	immediate word
	    
%%

program:   	{init();} statement_list {finish();}
		;

statement_list:	statement
	|	statement_list statement
		;

statement:	basic_statement 
	|	label_decl basic_statement

label_decl:	LABEL_DECL
		{
		    if (round == 0) 
			symbolTable[string($1)] = currentAddress;
		};

basic_statement: 
		NEWLINE
	|	rtype NEWLINE 
	|	itype NEWLINE 
	|	vtype NEWLINE 
	|	vitype NEWLINE
	|	jtype NEWLINE 
	|	halt NEWLINE  
	|	pseudo NEWLINE 
	|	other NEWLINE
	;

rtype:		ADDU REGISTER COMMA REGISTER COMMA REGISTER
		{
		    if (round != 0) 
			printR(currentAddress, 0, $2, $4, $6, 0, 0x21);
		    currentAddress += 4;
		}
	|	ADD REGISTER COMMA REGISTER COMMA REGISTER
		{
		    if (round != 0)
			printR(currentAddress, 0, $2, $4, $6, 0, 0x20);
		    currentAddress += 4;
		    
		}
	|	AND REGISTER COMMA REGISTER COMMA REGISTER
		{
		    if (round != 0) 
			printR(currentAddress, 0, $2, $4, $6, 0, 0x24);
		    currentAddress += 4;
		    
		}
	|	JR REGISTER
		{
		    if (round != 0) 
			printR(currentAddress, 0, 0, $2, 0, 0, 0x08);
		    currentAddress += 4;
		    
		}
	|	NOR REGISTER COMMA REGISTER COMMA REGISTER
		{
		    if (round != 0) 
			printR(currentAddress, 0, $2, $4, $6, 0, 0x27);
		    currentAddress += 4;
		    
		}
	|	OR REGISTER COMMA REGISTER COMMA REGISTER
		{
		    if (round != 0) 
			printR(currentAddress, 0, $2, $4, $6, 0, 0x25);
		    currentAddress += 4;
		    
		}
	|	SLT REGISTER COMMA REGISTER COMMA REGISTER 
		{
		    if (round != 0) 
			printR(currentAddress, 0, $2, $4, $6, 0, 0x2a);
		    currentAddress += 4;
		    
		}
	|	SLTU REGISTER COMMA REGISTER COMMA REGISTER
		{
		    if (round != 0) 
			printR(currentAddress, 0, $2, $4, $6, 0, 0x2b);
		    currentAddress += 4;
		    
		}
	|	SLL REGISTER COMMA REGISTER COMMA INTEGER
		{
		    if (round != 0) 
			printR(currentAddress, 0, $2, $4, 0, $6, 0x00);
		    currentAddress += 4;
		    
		}
	|	SRL REGISTER COMMA REGISTER COMMA INTEGER
		{
		    if (round != 0) 
			printR(currentAddress, 0, $2, $4, 0, $6, 0x02);
		    currentAddress += 4;
		    
		}
	|	SUBU REGISTER COMMA REGISTER COMMA REGISTER
		{
		    if (round != 0) 
			printR(currentAddress, 0, $2, $4, $6, 0, 0x23);
		    currentAddress += 4;
		    
		}
	|	SUB REGISTER COMMA REGISTER COMMA REGISTER
		{
		    if (round != 0)
			printR(currentAddress, 0, $2, $4, $6, 0, 0x22);
		    currentAddress += 4;
		    
		}
	|	XOR REGISTER COMMA REGISTER COMMA REGISTER
		{
		    if (round != 0)
			printR(currentAddress, 0, $2, $4, $6, 0, 0x26);
		    currentAddress += 4;
		   
		};
// op rt rs imm
itype:		ADDIU REGISTER COMMA REGISTER COMMA immediate
		{
		    if (round != 0)
			printI(currentAddress, 0x09, $2, $4, $6);
		    currentAddress += 4;
		    
		} 
	|	ADDI REGISTER COMMA REGISTER COMMA immediate
		{
		    if (round != 0)
			printI(currentAddress, 0x08, $2, $4, $6);
		    currentAddress += 4;
		   
		}
	|	ANDI REGISTER COMMA REGISTER COMMA immediate
		{
		    if (round != 0) 
			printI(currentAddress, 0x0c, $2, $4, $6);
		    currentAddress += 4;
		    
		}
	|	BEQ REGISTER COMMA REGISTER COMMA immediate
		{
		    if (round != 0)
			printI(currentAddress, 0x04, $4, $2, ($6 - (currentAddress + 4))/4);
		    currentAddress += 4;
		    
		}
	|	BNE REGISTER COMMA REGISTER COMMA immediate
		{
		    cout << $6 << endl;
		    if (round != 0)
			printI(currentAddress, 0x05, $4, $2, ($6 - (currentAddress + 4))/4);
		    currentAddress += 4;
		    
		}
	|	LUI REGISTER COMMA immediate
		{
		    if (round != 0)
			printI(currentAddress, 0x0f, $2, 0,$4);
		    currentAddress += 4;
		
		}
	|	LW REGISTER COMMA immediate LPAR REGISTER RPAR
		{
		    if (round != 0) 
			printI(currentAddress, 0x13, $2, $6, $4);
		    currentAddress += 4;
		    
		}
	|	ORI REGISTER COMMA REGISTER COMMA immediate
		{
		    if (round != 0) 
			printI(currentAddress, 0x0d, $2, $4, $6);
		    currentAddress += 4;
		    
		}
	|	SLTI REGISTER COMMA REGISTER COMMA immediate
		{
		    if (round != 0) 
			printI(currentAddress, 0x0a, $2, $4, $6);
		    currentAddress += 4;
		    
		}
	|	SLTIU REGISTER COMMA REGISTER COMMA immediate
		{
		    if (round != 0) 
			printI(currentAddress, 0x0b, $2, $4, $6);
		    currentAddress += 4;
		    
		}
	|	SW REGISTER COMMA immediate LPAR REGISTER RPAR
		{
		    if (round != 0)
			printI(currentAddress, 0x1b, $2, $6, $4);
		    currentAddress += 4;
		    
		}
	|	LL REGISTER COMMA immediate LPAR REGISTER RPAR
		{
		    if (round != 0)
			printI(currentAddress, 0x10, $2, $6, $4);
		    currentAddress += 4;
		    
		}
	|	SC REGISTER COMMA immediate LPAR REGISTER RPAR
		{
		    if (round != 0) 
			printI(currentAddress, 0x18, $2, $6, $4);
		    currentAddress += 4;
		    
		}
	|	XORI REGISTER COMMA REGISTER COMMA immediate
		{
		    if (round != 0) 
			printI(currentAddress, 0x0e, $2, $4, $6);
		    currentAddress += 4;
		};

vtype:		VADDU REGISTER COMMA REGISTER COMMA REGISTER
		{
		    if (round != 0) 
			printR(currentAddress, 0x20, $2, $4, $6, 0, 0x21);
		    currentAddress += 4;
		}
	|	VADD REGISTER COMMA REGISTER COMMA REGISTER
		{
		    if (round != 0)
			printR(currentAddress, 0x20, $2, $4, $6, 0, 0x20);
		    currentAddress += 4;
		    
		}
	|	VAND REGISTER COMMA REGISTER COMMA REGISTER
		{
		    if (round != 0) 
			printR(currentAddress, 0x20, $2, $4, $6, 0, 0x24);
		    currentAddress += 4;
		    
		}
	|	VNOR REGISTER COMMA REGISTER COMMA REGISTER
		{
		    if (round != 0) 
			printR(currentAddress, 0x20, $2, $4, $6, 0, 0x27);
		    currentAddress += 4;
		    
		}
	|	VOR REGISTER COMMA REGISTER COMMA REGISTER
		{
		    if (round != 0) 
			printR(currentAddress, 0x20, $2, $4, $6, 0, 0x25);
		    currentAddress += 4;
		    
		}
	|	VSLT REGISTER COMMA REGISTER COMMA REGISTER 
		{
		    if (round != 0) 
			printR(currentAddress, 0x20, $2, $4, $6, 0, 0x2a);
		    currentAddress += 4;
		    
		}
	|	VSLTU REGISTER COMMA REGISTER COMMA REGISTER
		{
		    if (round != 0) 
			printR(currentAddress, 0x20, $2, $4, $6, 0, 0x2b);
		    currentAddress += 4;
		    
		}
	|	VSLL REGISTER COMMA REGISTER COMMA INTEGER
		{
		    if (round != 0) 
			printR(currentAddress, 0x20, $2, $4, 0, $6, 0x00);
		    currentAddress += 4;
		    
		}
	|	VSRL REGISTER COMMA REGISTER COMMA INTEGER
		{
		    if (round != 0) 
			printR(currentAddress, 0x20, $2, $4, 0, $6, 0x02);
		    currentAddress += 4;
		    
		}
	|	VSUBU REGISTER COMMA REGISTER COMMA REGISTER
		{
		    if (round != 0) 
			printR(currentAddress, 0x20, $2, $4, $6, 0, 0x23);
		    currentAddress += 4;
		    
		}
	|	VSUB REGISTER COMMA REGISTER COMMA REGISTER
		{
		    if (round != 0)
			printR(currentAddress, 0x20, $2, $4, $6, 0, 0x22);
		    currentAddress += 4;
		    
		}
	|	VXOR REGISTER COMMA REGISTER COMMA REGISTER
		{
		    if (round != 0)
			printR(currentAddress, 0x20, $2, $4, $6, 0, 0x26);
		    currentAddress += 4;
		   
		};

vitype:		VADDIU REGISTER COMMA REGISTER COMMA immediate
		{
		    if (round != 0)
			printI(currentAddress, 0x29, $2, $4, $6);
		    currentAddress += 4;
		    
		} 
	|	VADDI REGISTER COMMA REGISTER COMMA immediate
		{
		    if (round != 0)
			printI(currentAddress, 0x28, $2, $4, $6);
		    currentAddress += 4;
		   
		}
	|	VANDI REGISTER COMMA REGISTER COMMA immediate
		{
		    if (round != 0) 
			printI(currentAddress, 0x2c, $2, $4, $6);
		    currentAddress += 4;
		    
		}
	|	VLW REGISTER COMMA immediate LPAR REGISTER RPAR
		{
		    if (round != 0) 
			printI(currentAddress, 0x33, $2, $6, $4);
		    currentAddress += 4;
		    
		}
	|	VORI REGISTER COMMA REGISTER COMMA immediate
		{
		    if (round != 0) 
			printI(currentAddress, 0x2d, $2, $4, $6);
		    currentAddress += 4;
		    
		}
	|	VSLTI REGISTER COMMA REGISTER COMMA immediate
		{
		    if (round != 0) 
			printI(currentAddress, 0x2a, $2, $4, $6);
		    currentAddress += 4;
		    
		}
	|	VSLTIU REGISTER COMMA REGISTER COMMA immediate
		{
		    if (round != 0) 
			printI(currentAddress, 0x2b, $2, $4, $6);
		    currentAddress += 4;
		    
		}
	|	VSW REGISTER COMMA immediate LPAR REGISTER RPAR
		{
		    if (round != 0)
			printI(currentAddress, 0x3b, $2, $6, $4);
		    currentAddress += 4;
		    
		}
	|	VXORI REGISTER COMMA REGISTER COMMA immediate
		{
		    if (round != 0) 
			printI(currentAddress, 0x2e, $2, $4, $6);
		    currentAddress += 4;
		};


jtype:		J immediate
		{
		    if(round != 0)
			printJ(currentAddress, 0x02, (($2 >> 2) & 0x03ffffff));
		    currentAddress += 4;
		}
	|	JAL immediate
		{
		    if(round != 0)
			printJ(currentAddress, 0x03, (($2 >> 2) & 0x03ffffff));
		    currentAddress += 4;
		};

halt: 		HALT
		{
		    if(round != 0)
			printI(currentAddress, 0x3f, 0x1f, 0x1f, 0xffff);
		    currentAddress += 4
		};

pseudo:		PUSH REGISTER
		{
		    if(round != 0) {
			printI(currentAddress, 0x09, 29, 29, -4);
			printI(currentAddress+4, 0x1b, $2, 29, 0);
		    } 
                    currentAddress += 8;
		}
	|	POP REGISTER 
		{
		    if(round != 0) {
			printI(currentAddress, 0x1b, $2, 29, 0);
			printI(currentAddress+4, 0x09, 29, 29, 4);
		    } 
		    currentAddress += 8;
		}
	|	NOP 
		{
		    if(round != 0)
			printI(currentAddress, 0x0, 0x0, 0x0, 0x0);
		    currentAddress += 4;
		};

other: 		ORG word
		{
		    if ($2 < currentAddress) {
			cout << "Cannot ORGanize address to " << $2 << " overlapping address " << currentAddress << endl;
			exit(-1);
		    }
		    currentAddress = $2;
		}
	|	CFW word
		{
		    outputHex(currentAddress, $2);
		    currentAddress = $2;
		};

immediate:	INTEGER
		{
		    $$ = $1;
		}
	|	LABEL
		{
		    if(round != 0)
			$$ = symbolTable[string($1)];
		    else
			$$ = 0;
		};

word:		INTEGER
		{
		    $$ = $1;
		};

%%

void yyerror (const char * s) {
    cerr << "ERROR : " << s << endl;
    exit(-1);
}
