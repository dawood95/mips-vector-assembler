#include <stdlib.h>
#include <stdio.h>
#include <map>
#include <unistd.h>
#include <iostream>
#include "parser.h"
#include "asmv.h"

using namespace std;

extern "C" int yyparse();

extern FILE * yyin;
FILE * outFile;

int round;
unsigned long int currentAddress;
map<char*, unsigned long int> symbolTable;

int main (int argc, char * argv[]) {

  if (argc < 2) {
    cout << USAGE << endl;
    exit(EXIT_FAILURE);
  }

  // Input file
  yyin = fopen(argv[1], "r");
  if (yyin == NULL) {
    cout << "Unable to open " << argv[1] << endl;
    exit(EXIT_FAILURE);
  }

  // Output file
  outFile = fopen(DEFAULT_OUT, "w");
  if (outFile == NULL) {
    cout << "Unable to create " << DEFAULT_OUT << endl;
    exit(EXIT_FAILURE);
  }


    cout << symbolTable.size() << endl;

  // Pass to build label table
  round = 0;
  do {
    yyparse();
  } while (!feof(yyin));

  cout << symbolTable.size() << endl;
  
  rewind(yyin);
  
  round = 1;
  do {
    yyparse();
  } while (!feof(yyin));

  fclose(yyin);
  fclose(outFile);

  return EXIT_SUCCESS;
}

