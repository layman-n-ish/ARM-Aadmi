; Tangent series implementation on Cortex-M4

	AREA tan_series, CODE, READONLY
	EXPORT tan
	ENTRY

; S0 -> input
; S1 -> current loop counter
; S2 -> max loop counter (#terms to expand to)
; S3 -> numerator of a specific term (temp register)
; S4 -> denominator of a specific term (temp register)
; S5 -> sign toggle bit
; S6 -> incremental sin(x) term
; S7 -> incremental cos(x) term
; S8 -> final sin(x) term
; S9 -> final cos(x) term
; S10 -> counter incrementer
; S11 -> factorial counter
; S12 -> output
  
tan FUNCTION
	BL enable_fpu
	
	VLDR.F32 S0, =6					; taking input (in radians), tangent of this number is found
	VLDR.F32 S1, =1					; current term index in the Taylor series expansion
	VLDR.F32 S2, =10				; maximum number of terms to be considered in the expansion
	VMOV.F32 S3, S0					; since we want to start evaluating from second term of the expansion, we start with 'x'; as term index increases, we multiply this by 'x' at every loop
	VLDR.F32 S4, =1					; factorial starts with '1'; as we go on with the subsequent terms, we compute the factorial by multiplying this with my current term index
	VLDR.F32 S5, =1					; sign toggle bit
	VMOV.F32 S8, S0					; sin(x) starting term
	VLDR.F32 S9, =1					; cos(x) starting term
	VLDR.F32 S10, =1				; constant to increment the counter by at every loop
	VLDR.F32 S11, =1				; factorial counter

loop
	VADD.F32 S11, S11, S10			; updating factorial counter
	VNEG.F32 S5, S5					; toggling sign bit
	
	VMUL.F32 S3, S3, S0				; updating numerator to get the next power of 'x'
	VMUL.F32 S4, S4, S11			; updating denominator to get the next factorial term
	VDIV.F32 S7, S3, S4				
	VMUL.F32 S7, S7, S5				; incremental cos(x) term
	VADD.F32 S9, S9, S7				; updating final cos(x) term
	
	VADD.F32 S11, S11, S10			; updating factorial counter
	
	VMUL.F32 S3, S3, S0				; updating numerator to get the next power of 'x'
	VMUL.F32 S4, S4, S11			; updating denominator to get the next factorial term
	VDIV.F32 S6, S3, S4				
	VMUL.F32 S6, S6, S5				; incremental sin(x) term
	VADD.F32 S8, S8, S6				; updating final sin(x) term
	
	VADD.F32 S1, S1, S10 			; updating current term index
	
	VCMP.F32 S1, S2					; checking exit condition (when current term index reaches maximum)
	VMRS APSR_nzcv, FPSCR			; VCMP sets FPSCR Flags so ought to move those flags values into ARM Core registers
	BNE loop						; when exit condition is NOT satisfied

	VDIV.F32 S12, S8, S9			; computing tan(x) by executing sin(x)/cos(x)

stop B stop ; stop program
											
enable_fpu							; References: http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.ddi0439b/BEHBJHIG.html
	LDR.W R0, =0xE000ED88 			; Using CPACR register (0xE000ED88) to specify access priviliges for coprocessors
	LDR R1, [R0]					; Read CPACR
	ORR R1, R1, #(0xF << 20)		; Set bits 20-23 to enable CP10 and CP11 coprocessors (Full access)
	STR R1, [R0]					; Write back the modified value to the CPACR
	BX LR
	
	ENDFUNC
	END 