	AREA nested_condi, CODE, READONLY
	EXPORT __main
	ENTRY
	
x RN 0 ; R0 -> input
y RN 1 ; R1 -> output

;pgm:
; if (x < 10) {
;	y = 0
; }
; else {
; 	if (x < 15) {
; 		y = 1
;	}
; 	else {
;		y = 2
;	}
;}

__main FUNCTION	
	MOV x, #16
	
	CMP x, #10
	BLT case0
	CMP x, #15
	BLT case1
	MOV y, #2
	B stop

case0 MOV y, #0
	B stop
	
case1 MOV y, #1
	B stop

stop B stop ; stop program
	ENDFUNC
	END 