;Sa se un program cu ajutorul caruia sa se converteasca o variabila DIGIT aflata in
;memoria de date externa la adresa 1000h dintr-un numar codificat BCD intr-un numar
;CHAR codificat ASCII si aflat in memoria de date externa la adresa 100h. Daca DIGIT
;nu este un numar BCD continutul lui CHAR va fi spatiul (20h).
;Exemple:
;a) Intrari: DIGIT: (1000h) = 07h
; 	Iesiri: CHAR: (0100h) = 37h ‘7’
;
;b) Intrari: DIGIT: (1000h) = 55h
; 	Iesiri: CHAR: (0100h) = 20h 

		ORG 	0h
Start: 	MOV 	DPTR,#1000h
		MOVX 	A,@DPTR
		MOV 	R0,#20h
		CJNE 	A,#09h,Next0
Next0: 	JNC 	Exit
		ADD 	A,#30h
		MOV 	R0,A
Exit: 	MOV 	A,R0
		MOV 	DPTR,#0100h
		MOVX 	@DPTR,A
		SJMP 	$
END