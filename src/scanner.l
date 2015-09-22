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

(?i:addu) { return ADDU; }
(?i:add)  { return ADD;  }
(?i:and)  { return AND; }
(?i:jr)   { return JR; }
(?i:nor)  { return NOR; }
(?i:or)   { return OR; }
(?i:slt)  { return SLT; }
(?i:sltu) { return SLTU; }
(?i:sll)  { return SLL; }
(?i:srl)  { return SRL; }
(?i:subu) { return SUBU; }
(?i:sub)  { return SUB; }
(?i:xor)  { return XOR; }

(?i:addiu) { return ADDIU; }
(?i:addi)  { return ADDI; }
(?i:andi)  { return ANDI; }
(?i:beq)   { return BEQ; }
(?i:bne)   { return BNE; }
(?i:lui)   { return LUI; }
(?i:lw)    { return LW; }
(?i:ori)   { return ORI; }
(?i:slti)  { return SLTI; }
(?i:sltiu) { return SLTIU; }
(?i:sw)    { return SW; }
(?i:ll)    { return LL; }
(?i:sc)    { return SC; }
(?i:xori)  { return XORI; }

(?i:j)    { return J; }
(?i:jal)  { return JAL; }

(?i:halt) { return HALT; }

(?i:push) { return PUSH; }
(?i:pop)  { return POP; }
(?i:nop)  { return NOP; }

(?i:org)  { return ORG; }
(?i:chw)  { return CHW; }
(?i:cfw)  { return CFW; }

(?i:vaddu) { return VADDU; }
(?i:vadd)  { return VADD;  }
(?i:vand)  { return VAND; }
(?i:vnor)  { return VNOR; }
(?i:vor)   { return VOR; }
(?i:vslt)  { return VSLT; }
(?i:vsltu) { return VSLTU; }
(?i:vsll)  { return VSLL; }
(?i:vsrl)  { return VSRL; }
(?i:vsubu) { return VSUBU; }
(?i:vsub)  { return VSUB; }
(?i:vxor)  { return VXOR; }

(?i:vaddiu) { return VADDIU; }
(?i:vaddi)  { return VADDI; }
(?i:vandi)  { return VANDI; }
(?i:vlui)   { return VLUI; }
(?i:vlw)    { return VLW; }
(?i:vori)   { return VORI; }
(?i:vslti)  { return VSLTI; }
(?i:vsltiu) { return VSLTIU; }
(?i:vsw)    { return VSW; }
(?i:vxori)  { return VXORI; }

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
