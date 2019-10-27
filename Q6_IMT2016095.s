	AREA gcd, CODE, READONLY
	EXPORT __main
	ENTRY

a RN 0 ; R0 -> input 
b RN 1	; R1 -> input 
result RN 2 ; R2 -> output
      
__main FUNCTION	
	MOV a, #3
	MOV b, #2
	
loop CMP a, b ; while(a != b) 
	BEQ finish 
	SUBGT a, a, b ; if(a > b) a -= b
	SUBLT b, b, a ; if (a < b) b -= a
	BNE loop
	
finish MOV result, a ; gcd(a, b) in R2
	
stop B stop ; stop program
	ENDFUNC
	END 