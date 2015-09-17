---------------------<reserved registers>------------------------

$0                   zero
$1                   assembler temporary
$29                 stack pointer
$31                 return address

---------------------<R-type Instructions>-----------------------

ADDU	$rd,$rs,$rt   	R[rd] <= R[rs] + R[rt] (unchecked overflow)
ADD    	$rd,$rs,$rt   	R[rd] <= R[rs] + R[rt]
AND    	$rd,$rs,$rt   	R[rd] <= R[rs] AND R[rt]
JR     	$rs		PC <= R[rs]
NOR    $rd,$rs,$rt   	R[rd] <= ~(R[rs] OR R[rt])
OR     	$rd,$rs,$rt   	R[rd] <= R[rs] OR R[rt]
SLT    	$rd,$rs,$rt   	R[rd] <= (R[rs] < R[rt]) ? 1 : 0
SLTU   $rd,$rs,$rt   	R[rd] <= (R[rs] < R[rt]) ? 1 : 0
SLL    	$rd,$rs,shamt 	R[rd] <= R[rs] << shamt
SRL    	$rd,$rs,shamt 	R[rd] <= R[rs] >> shamt
SUBU 	$rd,$rs,$rt   	R[rd] <= R[rs] - R[rt] (unchecked overflow)
SUB  	$rd,$rs,$rt   	R[rd] <= R[rs] - R[rt]
XOR    $rd,$rs,$rt   	R[rd] <= R[rs] XOR R[rt]

---------------------<I-type Instructions>-----------------------

ADDIU  $rt,$rs,imm   	R[rt] <= R[rs] + SignExtImm (unchecked overflow)
ADDI   	$rt,$rs,imm   	R[rt] <= R[rs] + SignExtImm
ANDI  	$rt,$rs,imm  	R[rt] <= R[rs] & ZeroExtImm
BEQ    	$rs,$rt,label 	PC <= (R[rs] == R[rt]) ? npc+BranchAddr : npc
BNE    	$rs,$rt,label 	PC <= (R[rs] != R[rt]) ? npc+BranchAddr : npc
LUI    	$rt,imm       	R[rt] <= {imm,16b'0}
LW     	$rt,imm($rs)  	R[rt] <= M[R[rs] + SignExtImm]
ORI    	$rt,$rs,imm   	R[rt] <= R[rs] OR ZeroExtImm
SLTI   	$rt,$rs,imm   	R[rt] <= (R[rs] < SignExtImm) ? 1 : 0
SLTIU  $rt,$rs,imm   	R[rt] <= (R[rs] < SignExtImm) ? 1 : 0
SW     	$rt,imm($rs)  	M[R[rs] + SignExtImm] <= R[rt]
LL     	$rt,imm($rs)  	R[rt] <= M[R[rs] + SignExtImm]; rmwstate <= addr
SC     	$rt,imm($rs)  	if (rmw) M[R[rs] + SignExtImm] <= R[rt], R[rt] <= 1 
else R[rt] <= 0
XORI   $rt,$rs,imm   	R[rt] <= R[rs] XOR ZeroExtImm





---------------------<V-type Instructions>-----------------------

VADDU		$rd,$rs,$rt   	V[rd] <= V[rs] + V[rt] (unchecked overflow)
VADD    	$rd,$rs,$rt   	V[rd] <= V[rs] + V[rt]
VAND    	$rd,$rs,$rt   	V[rd] <= V[rs] AND V[rt]
VNOR    	$rd,$rs,$rt   	V[rd] <= ~(V[rs] OR [rt])
VOR     	$rd,$rs,$rt   	V[rd] <= V[rs] OR V[rt]
VSLT    	$rd,$rs,$rt   	V[rd] <= (V[rs] < V[rt]) ? 1 : 0
VSLTU   	$rd,$rs,$rt   	V[rd] <= (V[rs] < V[rt]) ? 1 : 0
VSLL    	$rd,$rs,shamt 	V[rd] <= V[rs] << shamt
VSRL    	$rd,$rs,shamt 	V[rd] <= V[rs] >> shamt
VSUBU 	$rd,$rs,$rt   	V[rd] <= V[rs] - V[rt] (unchecked overflow)
VSUB  		$rd,$rs,$rt   	V[rd] <= V[rs] - V[rt]
VXOR    	$rd,$rs,$rt   	V[rd] <= V[rs] XOR V[rt]

---------------------<VI-type Instructions>-----------------------

VADDIU  	$rt,$rs,imm   	V[rt] <= V[rs] + SignExtImm (unchecked overflow)
VADDI   	$rt,$rs,imm   	V[rt] <= V[rs] + SignExtImm
VANDI  	$rt,$rs,imm  	V[rt] <= V[rs] & ZeroExtImm
VLUI    		$rt,imm       	V[rt] <= {imm,16b'0}
VLW     	$rt,imm($rs)  	V[rt] <= M[V[rs] + SignExtImm]
VORI    	$rt,$rs,imm   	V[rt] <= V[rs] OR ZeroExtImm
VSLTI   	$rt,$rs,imm   	V[rt] <= (V[rs] < SignExtImm) ? 1 : 0
VSLTIU 	$rt,$rs,imm   	V[rt] <= (V[rs] < SignExtImm) ? 1 : 0
VSW     	$rt,imm($rs)  	M[V[rs] + SignExtImm] <= V[rt]
VLL     		$rt,imm($rs)  	V[rt] <= M[V[rs] + SignExtImm]; rmwstate <= addr
VXORI   	$rt,$rs,imm   	V[rt] <= V[rs] XOR ZeroExtImm

---------------------<J-type Instructions>-----------------------

J      	label         PC <= JumpAddr
JAL    	label         R[31] <= npc; PC <= JumpAddr

---------------------<Other Instructions>------------------------

HALT

---------------------<Pseudo Instructions>-----------------------

PUSH  $rs          $29 <= $29 - 4; Mem[$29+0] <= R[rs] (sub+sw)
POP   	$rt           R[rt] <= Mem[$29+0]; $29 <= $29 + 4 (add+lw)
NOP                    Nop


-----------------------------------------------------------------
-----------------------------------------------------------------

org  Addr         	Set the base address for the code to follow 
chw  #            	Assign value to half word memory
cfw  #            	Assign value to word of memory