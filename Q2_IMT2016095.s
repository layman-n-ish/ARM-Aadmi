	AREA greatest, CODE, READONLY
	EXPORT __main
	ENTRY

input1 RN 0 ; R0 -> input
input2 RN 1 ; R1 -> input
input3 RN 2 ; R2 -> input
temp RN 3
result RN 4 ; R4 -> output
      
__main  FUNCTION	
	MOV input1, #5
	MOV input2, #10
	MOV input3, #6
	
	CMP input1, input2
	ITE GT
	MOVGT temp, input1 ; if input1 > input2, temp = input1
	MOVLE temp, input2 ; if input1 <= input2, temp = input2
	
	CMP input3, temp
	ITE GT
	MOVGT result, input3 ; if input3 > temp, result = input3
	MOVLE result, temp ; if temp <= input3, result = temp
	
stop B stop ; stop program
	ENDFUNC
	END 