%{

#include <iostream>
#include <stdlib.h>
#include "parser.h"
#include "asmv.h"

using namespace std;

extern "C" int yylex();
extern "C" int yyparse();
void yyerror(const char *);

%}

%union {
    char * string;
    int number;
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
	    
%%

program:   	{init();} statement_list {finish();}
		;

statement_list:	statement
	|	statement_list statement
		;

statement:	basic_statement
	|	LABEL_DECL basic_statement
		;

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

rtype:		ADDU tri_operands 
	|	ADD tri_operands 
	|	AND tri_operands 
	|	JR REGISTER
	|	NOR tri_operands 
	|	OR tri_operands 	
	|	SLT tri_operands 
	|	SLTU tri_operands 
	|	SLL shift_operands 
	|	SRL shift_operands 
	|	SUBU tri_operands 
	|	SUB tri_operands 
	|	XOR tri_operands 
	;

itype:		ADDIU imm_operands 
	|	ADDI imm_operands
	|	ANDI imm_operands
	|	BEQ imm_operands
	|	BNE imm_operands
	|	LUI REGISTER COMMA immediate
	|	LW ldsv_operands
	|	ORI imm_operands
	|	SLTI imm_operands
	|	SLTIU imm_operands
	|	SW ldsv_operands
	|	LL ldsv_operands
	|	SC ldsv_operands
	|	XORI imm_operands
	;

vtype:		VADDU tri_operands 
	|	VADD tri_operands 
	|	VAND tri_operands 
	|	VNOR tri_operands 
	|	VOR tri_operands 	
	|	VSLT tri_operands 
	|	VSLTU tri_operands 
	|	VSLL shift_operands 
	|	VSRL shift_operands 
	|	VSUBU tri_operands 
	|	VSUB tri_operands 
	|	VXOR tri_operands 
	;

vitype:		VADDIU imm_operands 
	|	VADDI imm_operands
	|	VANDI imm_operands
	|	VLUI REGISTER COMMA immediate
	|	VLW ldsv_operands
	|	VORI imm_operands
	|	VSLTI imm_operands
	|	VSLTIU imm_operands
	|	VSW ldsv_operands
	|	VXORI imm_operands
	;


jtype:		J LABEL
	|	JAL LABEL
	;

halt: 		HALT 
	;

pseudo:		PUSH REGISTER 
	|	POP REGISTER 
	|	NOP 
	;

other: 		ORG word 
	|	CHW word_list 
	|	CFW word_list 
	;

tri_operands:	REGISTER COMMA REGISTER COMMA REGISTER
	;

imm_operands:	REGISTER COMMA REGISTER COMMA immediate
	;

ldsv_operands:	REGISTER COMMA immediate LPAR REGISTER RPAR
	;

shift_operands:	REGISTER COMMA REGISTER COMMA INTEGER
	;

immediate:	INTEGER
	|	LABEL
	;

word_list:	word
	|	word_list COMMA word
	;

word:	INTEGER
	;
%%

void yyerror (const char * s) {
    cerr << "ERROR : " << s << endl;
}
