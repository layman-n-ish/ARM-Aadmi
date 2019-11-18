; Constructing circles on Cortex-M4

	AREA circle_construct, CODE, READONLY
	IMPORT get_trig_fn
	IMPORT printMsg2p
	EXPORT __main
	ENTRY

;PI EQU 3.14159265359

centre_x RN 4 ; R4 -> input
centre_y RN 5 ; R5 -> input
radius RN 6 ; R6 -> input
resolution RN 7 ; R7 -> input 
  
__main FUNCTION
	BL enable_fpu
	
	MOV centre_x, #320
	MOV centre_y, #240
	MOV radius, #5
	MOV resolution, #1				; in degrees; decrease it for more accuracy
	MOV R8, #360					; max degree
	MOV R9, #0						; current theta (in degrees)
	
loop
	BL deg_to_rad					; subroutine to convert theta from degrees to radians
	BL get_trig_fn					; compute sin(t) -> S8 and cos(t) -> S9 
	
	VMOV.F32 S0, radius
	VCVT.F32.U32 S0, S0				; converting from INTEGER to FLOAT
	VMUL.F32 S8, S8, S0				; r * sin(t)
	VMUL.F32 S9, S9, S0				; r * cos(t)
	
	VMOV.F32 S0, centre_x
	VCVT.F32.U32 S0, S0
	VMOV.F32 S1, centre_y
	VCVT.F32.U32 S1, S1
	VADD.F32 S0, S0, S9				; x = x_centre + r * cos(t)
	VADD.F32 S1, S1, S8				; y = y_centre + r * sin(t)
	
	VCVT.U32.F32 S0, S0				; converting from FLOAT to INTEGER
	VMOV.F32 R0, S0
	VCVT.U32.F32 S1, S1				; converting from FLOAT to INTEGER
	VMOV.F32 R1, S1
	BL printMsg2p					; prints contents of R0 and R1 in debug viewer
	
	ADD R9, R9, resolution			; updating current theta by increasing it by 'resolution'
	CMP R9, R8						; comparing current theta to see if's made a complete circle or not
	BLT loop

stop B stop ; stop program
											
enable_fpu							; References: http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.ddi0439b/BEHBJHIG.html
	LDR.W R0, =0xE000ED88 			; Using CPACR register (0xE000ED88) to specify access priviliges for coprocessors
	LDR R1, [R0]					; Read CPACR
	ORR R1, R1, #(0xF << 20)		; Set bits 20-23 to enable CP10 and CP11 coprocessors (Full access)
	STR R1, [R0]					; Write back the modified value to the CPACR
	
	BX LR

deg_to_rad
	VLDR.F32 S1, =3.14159265359		; storing numeric constant 'pi'
	VLDR.F32 S2, =180
	VMOV.F32 S0, R9
	VCVT.F32.U32 S0, S0				; converting from INTEGER to FLOAT
	VMUL.F32 S0, S0, S1				
	VDIV.F32 S0, S0, S2				; x(radians) = (x(degrees) * pi / 180)
	
	BX LR
	
	ENDFUNC
	END 
	