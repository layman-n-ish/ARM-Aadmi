	AREA fibonacci, CODE, READONLY
	EXPORT __main
	ENTRY

input RN 0 ; R0 -> input
result RN 4 ; R4 -> output
      
__main FUNCTION
	; NOTE - fib(n) series starts with n = 0...
	MOV input, #5 ; n = input; input to compute fib(n)
	MOV R1, #0 ; temp reg; stores fib(n-1)
	MOV R2, #1 ; temp reg; stores fib(n)
	
	; for (i = input, , i--)
loop CMP input, #1
	BLT case0 ; if i == 0, jump to label 'case0'
	BEQ finish ; if i == 1, jump to label 'finish'
	
	; else, 
	MOV R3, R1 ; store fib(i-1) in temp reg
	MOV R1, R2 ; R1 now stores fib(i)   
	ADDGT R2, R2, R3 ; R2 now stores fib(i+1) by adding fib(i-1), fib(i)
	SUBGT input, input, #1 ; i--
	BGT loop ; if i > 1, jump to label 'loop'

case0 MOV result, R1 
	B stop
	
finish ADD result, R1 ; R1 (after the end of the loop) stores fib(n)
	B stop
	
stop B stop ; stop program
	ENDFUNC
	END 