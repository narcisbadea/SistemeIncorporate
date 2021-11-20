;Sa se scrie un program care sa converteasca o variabila A_DIGIT, aflata in memoria de
;date externa la adresa 1000h, codificata ASCII, intr-un numar codficat hexazecimal
;H_DIGIT aflat in meoria de date externa la adresa 1001h.
;Exemple:
;	a) 	Intrari: 	A_DIGIT: (1000h) = 43h ‘C’
; 		Iesiri: 	H_DIGIT: (1001h) = 0Ch
;
;	b) 	Intrari: 	A_DIGIT: (1000h) = 36h ‘6’
; 		Iesiri: 	H_DIGIT: (1001h) = 06h 

		ORG 	0h
Start: 	MOV		DPTR,#1000h
		MOVX 	A,@DPTR
		CJNE 	A,#30h,Next0
Next0: 	JC 		Exit
		CJNE 	A,#39h,Next1
Next1: 	JNC		Next2
		SUBB	A,#30h
		MOV 	DPTR,#1001h
		MOVX	@DPTR,A
		SJMP 	Exit
Next2: 	CJNE 	A,#41h,Next3
Next3: 	JC 		Exit
		CJNE 	A,#46h,Next4
Next4: 	JNC 	Exit
		SUBB	A,#37h
		MOV 	DPTR,#1001h
		MOVX 	@DPTR,A
		SJMP 	Exit
Exit: 	SJMP 	$
END