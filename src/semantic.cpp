#include <iostream>
#include <stdio.h>
#include <string>
#include <cstring>
#include <map>
#include "semantic.h"

using namespace std;

extern FILE * outFile;
extern unsigned long int currentAddress;
extern map<string, unsigned long int> symbolTable;

void init() {
    currentAddress = 0;
}

void finish() {
    fprintf (outFile, ":00000001FF\n");
}

void printR(unsigned long int address,
	    unsigned long int op,
	    unsigned long int rd,
	    unsigned long int rs,
	    unsigned long int rt,
	    unsigned long int shamt,
	    unsigned long int funct) {

    unsigned long int instr = ((op & 0x3f) << 26 |
			       (rs & 0x1f) << 21 |
			       (rt & 0x1f) << 16 |
			       (rd & 0x1f) << 11 |
			       (shamt & 0x1f) << 6 |
			       (funct & 0x3f));
    outputHex(address, instr);
}

void printI(unsigned long int address,
	    unsigned long int op,
	    unsigned long int rt,
	    unsigned long int rs,
	    unsigned long int imm) {

    unsigned long int instr = ((op & 0x3f) << 26 |
			       (rs & 0x1f) << 21 |
			       (rt & 0x1f) << 16 |
			       (imm & 0xffff));
    outputHex(address, instr);
}

void printJ(unsigned long int address,
	    unsigned long int op,
	    unsigned long int imm) {
  
  unsigned long int instr = ((op & 0x3f) << 26 |
			     (addr & 0x3ffffff));

  outputHex(address, instr);
}

void outputHex(unsigned long int address,
	       unsigned long int instr) {

    // Function written by Eric Villasenor
    
    /* vars to compute checksum and addr */
    int i, j, checksum = 0;

    /* hex format address is 16 bits
     * also our memory model is 16 bits
     * but only allows under 30kbytes of storage
     */
    unsigned short addr = address / WORD_SIZE;
    char bytes[17];
    char byte[3];

    /* compute check sum */
    sprintf (bytes, "%02X%04X%02X%08X", 4, addr, 0, instr);
    for (i = 0; i < strlen(bytes)-1; i++)
    {
      byte[0] = bytes[i++];
      byte[1] = bytes[i];
      byte[2] = '\0';
      sscanf (byte, "%2X", &j);
      /* add fields 2 3 4 5 to other
       * sum each 2digit hex value
       */
      checksum += j;
    }

    /* two ways to do this
     * subtract sum from x100
     * or invert and add 1
     */
    /* keep only the least significant byte */
    checksum &= 0xff;
    /* invert the result */
    checksum = ~checksum;
    /* add 1 to get check sum */
    checksum += 1;
    /* again lsb is what we want */
    checksum &= 0xff;

    /* six fields for intel hex format
     * 1 - :
     * 2 - byte count - 04
     * 3 - address 16bits
     * 4 - record type - 00
     * 5 - data - 32bits
     * 6 - checksum - ???
     */
    /* hex format */
    fprintf (outFile, ":%02X%04X%02X%08X%02X\n", 4, addr, 0, instr, checksum);
}
