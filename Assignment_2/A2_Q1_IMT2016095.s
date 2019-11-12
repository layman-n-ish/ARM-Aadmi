; Exponential series implementation on Cortex-M4 by Taylor Series Expansion

	AREA expo_series, CODE, READONLY
	EXPORT __main
	ENTRY

; S0 -> input
; S1 -> current loop counter
; S2 -> max loop counter (#terms to expand to)
; S3 -> numerator of a specific term (temp register )
; S4 -> denominator of a specific term (temp register)
; S5 -> incremental term (temp register)
; S6 -> counter incrementer
; S7 -> output
  
__main FUNCTION
	BL enable_fpu
	
	VLDR.F32 S0, =17				; taking input, exp of this number is found
	VLDR.F32 S1, =1					; current term index in the Taylor series expansion
	VLDR.F32 S2, =30				; maximum number of terms to be considered in the expansion
	VMOV.F32 S3, S0					; since we want to start evaluating from second term of the expansion, we start with 'x'; as term index increases, we multiply this by 'x' at every loop
	VLDR.F32 S4, =1					; factorial starts with '1'; as we go on with the subsequent terms, we compute the factorial by multiplying this with my current term index
	VLDR.F32 S6, =1					; constant to increment the counter by at every loop
	VLDR.F32 S7, =1
	
loop
	VDIV.F32 S5, S3, S4				; computing (x^n/n!)
	VADD.F32 S7, S7, S5				; adding this to previous term stored
	
	VADD.F32 S1, S1, S6				; updating current term index
	VMUL.F32 S3, S3, S0				; updating numerator by multiplying by 'x'
	VMUL.F32 S4, S4, S1				; updating denominator by re-computing factorial
	
	VCMP.F32 S1, S2					; checking exit condition (when current term index reaches maximum)
	VMRS APSR_nzcv, FPSCR			; VCMP sets FPSCR Flags so ought to move those flags values into ARM Core registers
	BNE loop						; when exit condition is NOT satisfied

stop B stop ; stop program
											
enable_fpu							; References: http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.ddi0439b/BEHBJHIG.html
	LDR.W R0, =0xE000ED88 			; Using CPACR register (0xE000ED88) to specify access priviliges for coprocessors
	LDR R1, [R0]					; Read CPACR
	ORR R1, R1, #(0xF << 20)		; Set bits 20-23 to enable CP10 and CP11 coprocessors (Full access)
	STR R1, [R0]					; Write back the modified value to the CPACR
	BX LR
	
	ENDFUNC
	END 