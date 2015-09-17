#include <stdlib.h>
#include <unistd.h>
#include <iostream>
#include "parser.h"
#include "asmv.h"

using namespace std;

extern "C" int yyparse();

int main (int argc, char * argv[]) {

  extern FILE * yyin;
  
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
  outfile = fopen(DEFAULT_OUT, "w");
  if (outfile == NULL) {
    cout << "Unable to create " << DEFAULT_OUT << endl;
    exit(EXIT_FAILURE);
  }

  // Pass to build label table
  pass = 0;
  do {
    yyparse();
  } while (!feof(yyin));

  rewind(yyin);

  pass = 1;
  do {
    yyparse();
  } while (!feof(yyin));

  fclose(yyin);
  fclose(outfile);

  return EXIT_SUCCESS;
}
