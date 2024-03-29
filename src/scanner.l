%{
  
#define YY_DECL extern "C" int yylex()

#include <vector>
#include <iostream>
#include <stdlib.h>
#include "parser.h"

using namespace std;

int lineno;

%}

%%

[ \t] 

(("#".*\n)|("--".*\n)|("//".*\n)) {
  /* eat comments */
  unput('\n');
}

"," { return COMMA; }
"(" { return LPAR; }
")" { return RPAR; }

"\n" { yylval.number = ++lineno; return NEWLINE; }

(s.)?(?i:addu) { return ADDU; }
(s.)?(?i:add)  { return ADD;  }
(s.)?(?i:and)  { return AND; }
(s.)?(?i:nor)  { return NOR; }
(s.)?(?i:or)   { return OR; }
(s.)?(?i:slt)  { return SLT; }
(s.)?(?i:sltu) { return SLTU; }
(s.)?(?i:sll)  { return SLL; }
(s.)?(?i:srl)  { return SRL; }
(s.)?(?i:subu) { return SUBU; }
(s.)?(?i:sub)  { return SUB; }
(s.)?(?i:xor)  { return XOR; }

(s.)?(?i:addiu) { return ADDIU; }
(s.)?(?i:addi)  { return ADDI; }
(s.)?(?i:andi)  { return ANDI; }
(s.)?(?i:lui)   { return LUI; }
(s.)?(?i:lw)    { return LW; }
(s.)?(?i:ori)   { return ORI; }
(s.)?(?i:slti)  { return SLTI; }
(s.)?(?i:sltiu) { return SLTIU; }
(s.)?(?i:sw)    { return SW; }
(s.)?(?i:ll)    { return LL; }
(s.)?(?i:sc)    { return SC; }
(s.)?(?i:xori)  { return XORI; }

(?i:jr)   { return JR; }
(?i:j)    { return J; }
(?i:jal)  { return JAL; }

(s.)?(?i:beq)        { return BEQ; }
(s.)?(?i:bne)        { return BNE; }
(v.)(?i:beq)        { return VBEQ; }
(v.)(?i:bne)        { return VBNE; }

(?i:setsync) { return SYNC; }

(?i:halt) { return HALT; }

(?i:push) { return PUSH; }
(?i:pop)  { return POP; }
(?i:nop)  { return NOP; }

(?i:org)  { return ORG; }
(?i:cfw)  { return CFW; }

(v.)(?i:addu) { return VADDU; }
(v.)(?i:add)  { return VADD;  }
(v.)(?i:and)  { return VAND; }
(v.)(?i:nor)  { return VNOR; }
(v.)(?i:or)   { return VOR; }
(v.)(?i:slt)  { return VSLT; }
(v.)(?i:sltu) { return VSLTU; }
(v.)(?i:sll)  { return VSLL; }
(v.)(?i:srl)  { return VSRL; }
(v.)(?i:subu) { return VSUBU; }
(v.)(?i:sub)  { return VSUB; }
(v.)(?i:xor)  { return VXOR; }

(v.)(?i:addiu) { return VADDIU; }
(v.)(?i:addi)  { return VADDI; }
(v.)(?i:andi)  { return VANDI; }
(v.)(?i:lui)   { return VLUI; }
(v.)(?i:slti)  { return VSLTI; }
(v.)(?i:sltiu) { return VSLTIU; }
(v.)(?i:sw)    { return VSW; }
(v.)(?i:swo)   { return VSWO; }
(v.)(?i:xori)  { return VXORI; }
(v.)(?i:lw)    { return VLW; }
(v.)(?i:lwo)   { return VLWO; }
(v.)(?i:ori)   { return VORI; }

(m.)(v.)(?i:addu) { return MVADDU; }
(m.)(v.)(?i:add)  { return MVADD;  }
(m.)(v.)(?i:and)  { return MVAND; }
(m.)(v.)(?i:nor)  { return MVNOR; }
(m.)(v.)(?i:or)   { return MVOR; }
(m.)(v.)(?i:slt)  { return MVSLT; }
(m.)(v.)(?i:sltu) { return MVSLTU; }
(m.)(v.)(?i:sll)  { return MVSLL; }
(m.)(v.)(?i:srl)  { return MVSRL; }
(m.)(v.)(?i:subu) { return MVSUBU; }
(m.)(v.)(?i:sub)  { return MVSUB; }
(m.)(v.)(?i:xor)  { return MVXOR; }

(m.)(v.)(?i:addiu) { return MVADDIU; }
(m.)(v.)(?i:addi)  { return MVADDI;  }
(m.)(v.)(?i:andi)  { return MVANDI; }
(m.)(v.)(?i:ori)   { return MVORI; }
(m.)(v.)(?i:xori)  { return MVXORI; }
(m.)(v.)(?i:lui)  { return MVLUI; }

(?i:mlt)  { return MLT; }
(?i:mltu) { return MLTU; }
(?i:meq) { return MEQ; }
(?i:minv) { return MINV; }

"0x"[0-9a-fA-F]+ {
  yylval.number = strtol(yytext, (char **)NULL, 16);
  return INTEGER;
}

[-]{0,1}[0-9]+ {
  yylval.number = strtol(yytext, (char **)NULL, 10);
  return INTEGER;
}

['$']([0-9]|1[0-9]|2[0-9]|3[0-1]) { 
  yylval.number = atoi(&yytext[1]);
  return REGISTER;
}

['$'](?i:zero) { 
  yylval.number = 0;
  return REGISTER;
}

[a-zA-Z][a-zA-Z0-9_]*":" { 
  yytext[strlen(yytext)-1] = '\0'; 
  yylval.string = (char *)strdup(yytext);
  return LABEL_DECL;
}

[a-zA-Z][a-zA-Z0-9_]* { 
  yylval.string = (char *)strdup(yytext);
  return LABEL;
}

. {
  cerr << "Line: " << lineno << endl
       << "Error ( " << yytext << " )" << endl;
}

%%
