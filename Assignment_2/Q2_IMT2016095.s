; Tangent series implementation on Cortex-M4

AREA tan_series, CODE, READONLY
	EXPORT __main
	ENTRY

input RN 0 ; R0 -> input
result RN 1 ; R1 -> output
  
__main FUNCTION	
	MOV input, #5
	
	
stop B stop ; stop program
	ENDFUNC
	END 
