%{
  
#define YY_DECL extern "C" int yylex()

#include <stdlib.h>
#include "parser.h"

%}

%%

[ \t] 

("#".*\n | "--".*\n | "//".*\n) {
  /* eat comments */
  unput('\n');
}


%%
