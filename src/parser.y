%{

#include <iostream>
#include <stdlib.h>
#include "parser.h"
#include "asmv.h"

using namespace std;

void yyerror(const char * s);

%}

%union {
    int reg;
}



%%

%%

yyerror (char * s) {
    cerr << "ERROR : " << s << endl;
}
