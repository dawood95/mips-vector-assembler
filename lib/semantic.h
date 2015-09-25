#ifndef SEMANTIC_H
#define SEMANTIC_H

#include <stdio.h>

#define WORD_SIZE 4

void init();
void finish();

void printI(unsigned long int,
	    unsigned long int,
	    unsigned long int,
	    unsigned long int,
	    unsigned long int);

void printR(unsigned long int,
	    unsigned long int,
	    unsigned long int,
	    unsigned long int,
	    unsigned long int,
	    unsigned long int,
	    unsigned long int);

void printJ(unsigned long int,
	    unsigned long int,
	    unsigned long int);

void outputHex(unsigned long int, unsigned long int);

#endif
