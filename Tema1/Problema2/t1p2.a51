;Sa se scrie un program care sa asigure conversia unei variabile CODE aflata in memoria
;de date externa la adresa 1000h dintr-un numar codificat 7 segmente intr-un numar
;DIGIT codificat BCD si aflat in memoria de date externa la adresa 100h. Daca CODE nu
;este codificat 7 segmente in DIGIT se inscrie FFh.
;Exemple:
;a) Intrari: CODE: (1000h) = 4Fh
; 	Iesiri: DIGIT: (0100h) = 03h
;
;b) Intrari: CODE: (1000h) = 28h
; 	Iesiri: DIGIT: (0100h) = FFh

		ORG 	0h
START: 	MOV 	DPTR,#1000H
		MOVX 	A,@DPTR
		MOV 	R1,A
		MOV 	DPTR,#SSEG
		MOV 	A,#00H
		MOV 	R0,A
LOOP: 	MOV 	A,R0
		MOVC 	A,@A+DPTR
		SUBB 	A,R1
		ADD 	A,#01h
		JZ 		EXIT
		INC 	R0
		MOV 	A,R0
		CJNE 	A,#0AH,LOOP
		MOV	 	R0,#0FFH
EXIT: 	MOV 	DPTR,#1001H
		MOV 	A,R0
		MOVX 	@DPTR,A
		SJMP 	$
		ORG 	1000H
SSEG: 	DB 		3FH
		DB 		06H
		DB 		5BH
		DB 		4FH
		DB 		66H
		DB 		6DH
		DB 		7DH
		DB 		07H
		DB 		7FH
		DB 		6FH
END