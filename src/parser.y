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
    unsigned long int * list;
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
%type	<list>		word_list
	    
%%

program:   	{init();} statement_list {finish();}
		;

statement_list:	statement
	|	statement_list statement
		;

statement:	basic_statement 
	|	LABEL_DECL basic_statement
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
	|	VADD REGISTER COMMA REGISTER COMMA REGISTER 
	|	VAND REGISTER COMMA REGISTER COMMA REGISTER 
	|	VNOR REGISTER COMMA REGISTER COMMA REGISTER 
	|	VOR REGISTER COMMA REGISTER COMMA REGISTER 	
	|	VSLT REGISTER COMMA REGISTER COMMA REGISTER 
	|	VSLTU REGISTER COMMA REGISTER COMMA REGISTER 
	|	VSLL REGISTER COMMA REGISTER COMMA INTEGER 
	|	VSRL REGISTER COMMA REGISTER COMMA INTEGER 
	|	VSUBU REGISTER COMMA REGISTER COMMA REGISTER 
	|	VSUB REGISTER COMMA REGISTER COMMA REGISTER 
	|	VXOR REGISTER COMMA REGISTER COMMA REGISTER 
	;

vitype:		VADDIU REGISTER COMMA REGISTER COMMA immediate 
	|	VADDI REGISTER COMMA REGISTER COMMA immediate
	|	VANDI REGISTER COMMA REGISTER COMMA immediate
	|	VLUI REGISTER COMMA immediate
	|	VLW REGISTER COMMA immediate LPAR REGISTER RPAR
	|	VORI REGISTER COMMA REGISTER COMMA immediate
	|	VSLTI REGISTER COMMA REGISTER COMMA immediate
	|	VSLTIU REGISTER COMMA REGISTER COMMA immediate
	|	VSW REGISTER COMMA immediate LPAR REGISTER RPAR
	|	VXORI REGISTER COMMA REGISTER COMMA immediate
	;


jtype:		J immediate
		{
		    if(round != 0)
			printJ(currentAddress, 0x02, (($2 >> 2) & 0x03fffffff));
		    currentAddress += 4;
		}
	|	JAL immediate
		{
		    if(round != 0)
			printJ(currentAddress, 0x03, (($2 >> 2) & 0x03fffffff));
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
			printI(currentAddress, 0x09, 29, 29, 4);
			printI(currentAddress+4, 0x1b, $2, 29, 0);
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
		    currentAddress = $2;
		}
	|	CHW word_list 
		{
		}
	|	CFW word_list 
		{
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

word_list:	word
	|	word_list COMMA word
		;

word:		INTEGER
		{
		    $$ = $1;
		};

%%

void yyerror (const char * s) {
    cerr << "ERROR : " << s << endl;
}
