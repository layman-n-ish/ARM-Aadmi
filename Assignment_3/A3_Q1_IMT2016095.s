; Implementation of Digital Logic Gates using Neural Networks

	PRESERVE8
	AREA  nn_logic_gates, CODE,READONLY
	IMPORT printMsg
	IMPORT printErrorMsg
	IMPORT get_exp
	EXPORT __main
	ENTRY
	
input1 RN 4							; activation value at neuron 1 to the neural network
input2 RN 5							; activation value at neuron 2 to the neural network
input3 RN 6							; activation value at neuron 3 to the neural network
gate_selection RN 7					; 0 -> AND, 1 -> OR, 2 -> NOT, 3 -> XOR, 4 -> XNOR, 5 -> NAND, 6 -> NOR		

__main FUNCTION
	
	 MOV input1, #0				
	 MOV input2, #1				
	 MOV input3, #1				
	 MOV gate_selection, #0		

	 VMOV.F32 S0, input1			; Moving to the FPU to do computation there
     VCVT.F32.S32 S0, S0 			; Converting signed 32-bit integer into float
	 VMOV.F32 S1, input2
     VCVT.F32.S32 S1, S1
	 VMOV.F32 S2, input3
     VCVT.F32.S32 S2, S2
	 
	 ; Get into the Switch-Case (jump table) block to select Logic Gate to emulate of our choice
	 
	 CMP gate_selection, #0			; AND
	 BNE case2						; Jump to next case if this is not the choice we made
	 BL __and;						; else, jump to the function to execute corresponding to our choice
	 B break
case2
	 CMP gate_selection, #1			; OR
	 BNE case3
	 BL __or					
	 B break
case3
	 CMP gate_selection, #2			; NOT
	 BNE case4
	 BL __not				
	 B break
case4
	 CMP gate_selection, #3			; XOR
	 BNE case5
	 BL __xor				
	 B break
case5
	 CMP gate_selection, #4			; XNOR
	 BNE case6
	 BL __xnor					
	 B break	
case6
	 CMP gate_selection, #5			; NAND
	 BNE case7
	 BL __nand					
	 B break
case7
	 CMP gate_selection, #6			; NOR
	 BNE default
	 BL __nor				
	 B break
default 							; default case
	 BL printErrorMsg				; print error message
	 B stop	 
	 
break
	 BL printMsg					; print output
	 B stop
	 
stop B stop

	 ENDFUNC

;----------------------------------------------------------------------------------------

get_sigmoid FUNCTION
	 
	 ; Compute sigmoid function e^-x in S7 and Sigmoid function output in S9
	 
	 PUSH {LR}
	 VLDR.F32 S8, =1			
	 VADD.F32 S9, S7, S8			; compute (e^-x)+1
	 VDIV.F32 S9, S8, S9			; S9 has 1/(e^-x)+1
	 POP {LR};	
	 BX lr;
	 
	ENDFUNC
;---------------------------------------------------------------------------------------

apply_sigmoid FUNCTION
	 PUSH {LR}
	 BL get_exp						; Compute e^-x
	 BL get_sigmoid					; Sigmoid function output in S9
	 
	 VLDR.F32 S14, =0.5				
	 VCMP.F32 S9,S14				; Compare NN output with 0.5		
	 VMRS    APSR_nzcv, FPSCR;
	 MOVGT	R0, #1					; If Y > 0.5, output is 1
	 MOVLT	R0, #0					; If Y < 0.5, output is 0
	 POP {LR}
	 BX lr
	 
	 ENDFUNC	 
;--------------------------------------------------------------------------------------------------
	
;		logic AND

__and FUNCTION
	 PUSH {LR};	 
	 VLDR.F32 S4, = 2				; W1
	 VLDR.F32 S5, = 2				; W2
	 VLDR.F32 S6, = 2				; W3
	 VLDR.F32 S7, = -5				; Bias
	 
	 VMUL.F32 S0, S0, S4			; A1*W1
	 VMUL.F32 S1, S1, S5			; A2*W2
	 VMUL.F32 S2, S2, S6			; A3*W3
	 VADD.F32 S3, S0, S1			; A1*W1 + A2*W2 
	 VADD.F32 S3, S3, S2			; A1*W1 + A2*W2 + A3*W3 
	 VADD.F32 S3, S3, S7			; A1*W1 + A2*W2 + A3*W3 + Bias
	 
	 VNEG.F32 S3, S3
	 VMOV.F32 S0, S3				; S0 has the value of x
	 BL apply_sigmoid;
	 
	 POP {LR};	
	 BX lr;
	 ENDFUNC

;----------------------------------------------------------------------------------------
;		logic OR

__or FUNCTION
	 PUSH {LR};	 
	 VLDR.F32 S4,= 2				; W1
	 VLDR.F32 S5,= 2				; W2
	 VLDR.F32 S6,= 2				; W3
	 VLDR.F32 S7,= -1				; Bias
	 
	 VMUL.F32 S0,S0,S4				; A1*W1
	 VMUL.F32 S1,S1,S5				; A2*W2
	 VMUL.F32 S2,S2,S6				; A3*W3
	 VADD.F32 S3,S0,S1				; A1*W1 + A2*W2 
	 VADD.F32 S3,S3,S2				; A1*W1 + A2*W2 + A3*W3 
	 VADD.F32 S3,S3,S7				; A1*W1 + A2*W2 + A3*W3 + Bias
	 
	 VNEG.F32 S3, S3
	 VMOV.F32 S0, S3				; S0 has the value of x
	 BL apply_sigmoid;
	 POP {LR};	
	 BX lr;
	 ENDFUNC

;----------------------------------------------------------------------------------------
;		logic NOT	We only consider 1st input (in R4) for NOT 

__not FUNCTION
	 PUSH {LR};	 
	 VLDR.F32 S4,= -2			; W1
	 VLDR.F32 S7,= 1			; Bias
	 
	 VMUL.F32 S0,S0,S4			; A1*W1
	 VADD.F32 S3,S0,S7			; A1*W1 + Bias
	 
	 VNEG.F32 S3, S3
	 VMOV.F32 S0,S3				; S0 has the value of x
	 BL apply_sigmoid;
	 POP {LR};	
	 BX lr;
	 ENDFUNC

;----------------------------------------------------------------------------------------
;		logic XOR

__xor FUNCTION
	
	PUSH {LR}
	 ; Store the inputs 
	 VMOV.F32 S19,S0;			S19 has A1
	 VMOV.F32 S20,S1;			S20 has A2
	 VMOV.F32 S21,S2;			S21 has A3
	 
	 BL __not;					Computes not for A
			;					A' stored in R0
	 VMOV.F32 S22,R0;			Move the count in R0 to S22 (floating point register)
     VCVT.F32.S32 S22,S22; 		Convert into signed 32bit number	 
	 
	 VMOV.F32 S0,S20;			Move value of A2 to S0			
	 BL __not;					Computes not for B
			;					B' stored in R1
	 VMOV.F32 S23,R0;			Move the count in R1 to S23 (floating point register)
     VCVT.F32.S32 S23,S23; 		Convert into signed 32bit number
	 
	 VMOV.F32 S0,S21;			Move value of A3 to S0	
	 BL __not;					Computes not for C
			;					C' stored in R2
	 VMOV.F32 S24,R0;			Move the count in R2 to S24 (floating point register)
     VCVT.F32.S32 S24,S24; 		Convert into signed 32bit number
	 
;1)	 A1'*A2*A3'	
	 VMOV.F32 S0,S22;	
	 VMOV.F32 S1,S20;
	 VMOV.F32 S2,S24;
	 BL __and;					compute A1'*A2*A3' 
	 MOV R4,R0;					Store value in R4
	 
;2)	 A1*A2'*A3'	
	 VMOV.F32 S0,S19;	
	 VMOV.F32 S1,S23;
	 VMOV.F32 S2,S24;
	 BL __and;					compute A1*A2'*A3' 
	 MOV R5,R0;					Store value in R5

;3)	 A1'*A2'*A3	
	 VMOV.F32 S0,S22;	
	 VMOV.F32 S1,S23;
	 VMOV.F32 S2,S21;
	 BL __and;					compute A1'*A2'*A3 
	 MOV R6,R0;					Store value in R6
	 
;4)	 A1*A2*A3	
	 VMOV.F32 S0,S19;	
	 VMOV.F32 S1,S20;
	 VMOV.F32 S2,S21;
	 BL __and;					compute A1*A2*A3 
	 MOV R7,R0;					Store value in R7	

;    Compute OR for R4, R5, R6, R7

	 VMOV.F32 S0,R7;			Move the count in R4 to S0 (floating point register)
     VCVT.F32.S32 S0,S0; 		Convert into signed 32bit number
	 VMOV.F32 S1,R6;			Move the count in R5 to S1 (floating point register)
     VCVT.F32.S32 S1,S1; 		Convert into signed 32bit number
	 VMOV.F32 S2,R5;			Move the count in R6 to S2 (floating point register)
     VCVT.F32.S32 S2,S2; 		Convert into signed 32bit number
	 
	 BL __or;					Computes OR for R7+R6+R5
	 MOV R7,R0;					Store value in R7	
	 
	 VMOV.F32 S0,R4;			Move the count in R4 to S0 (floating point register)
     VCVT.F32.S32 S0,S0; 		Convert into signed 32bit number
	 VMOV.F32 S1,R7;			Move the count in R4 to S0 (floating point register)
     VCVT.F32.S32 S1,S1; 		Convert into signed 32bit number
	 VLDR.F32 S2,= 0;			3rd input
	 
	 BL __or;					Computes AND for R7+R6+R5+R4

	 POP {LR}	
	 BX lr
	 ENDFUNC

;----------------------------------------------------------------------------------------
;		logic XNOR

__xnor FUNCTION
	 PUSH {LR}	

	 BL __xor
	 VMOV.F32 S0,R0				; Move the count in R4 to S0 (floating point register)
     VCVT.F32.S32 S0,S0			
	 BL __not
	 
	 POP {LR}	
	 BX lr
	 ENDFUNC

;----------------------------------------------------------------------------------------
;		logic NAND

__nand FUNCTION
	 PUSH {LR}
	 VLDR.F32 S4, =-2				; W1
	 VLDR.F32 S5, =-2				; W2
	 VLDR.F32 S6, =-2				; W3
	 VLDR.F32 S7, =5				; Bias
	                            
	 VMUL.F32 S0, S0, S4			; A1*W1
	 VMUL.F32 S1, S1, S5			; A2*W2
	 VMUL.F32 S2, S2, S6			; A3*W3
	 VADD.F32 S3, S0, S1			; A1*W1 + A2*W2 
	 VADD.F32 S3, S3, S2			; A1*W1 + A2*W2 + A3*W3 
	 VADD.F32 S3, S3, S7			; A1*W1 + A2*W2 + A3*W3 + Bias
	                            
	 VNEG.F32 S3, S3            
	 VMOV.F32 S0, S3;				; S0 has the value of x
	 BL apply_sigmoid;
	 POP {LR}
	 BX lr
	 ENDFUNC

;----------------------------------------------------------------------------------------
;		logic NOR

__nor FUNCTION
	 PUSH {LR} 
	 VLDR.F32 S4, =-10				; W1
	 VLDR.F32 S5, =-10				; W2
	 VLDR.F32 S6, =-10				; W3
	 VLDR.F32 S7, =5				; Bias
	                            
	 VMUL.F32 S0, S0, S4			; A1*W1
	 VMUL.F32 S1, S1, S5			; A2*W2
	 VMUL.F32 S2, S2, S6			; A3*W3
	 VADD.F32 S3, S0, S1			; A1*W1 + A2*W2 
	 VADD.F32 S3, S3, S2			; A1*W1 + A2*W2 + A3*W3 
	 VADD.F32 S3, S3, S7			; A1*W1 + A2*W2 + A3*W3 + Bias
	          
	 VNEG.F32 S3, S3   
	 VMOV.F32 S0, S3				; S0 has the value of x
	 BL apply_sigmoid           
	 POP {LR}	
	 BX lr
	 ENDFUNC
	  		 
;--------------------------------------------------------------------------------------------------
    END