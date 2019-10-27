	AREA odd_or_even, CODE, READONLY
	EXPORT __main
	ENTRY

input RN 0 ; R0 -> input
result RN 1 ; R1 -> output
      
__main FUNCTION	
	MOV input, #8
	TST input, #0x1 ; input AND 0x1 (logic - if even -> LSB is clear, if odd -> LSB is set)
	
	MOVEQ result, #0 ; if even, R4 has '0' stored (because Z flag is set)
	MOVNE result, #1 ; if odd, R4 has '1' stored (because Z flag is clear)
	
stop B stop ; stop program
	ENDFUNC
	END 