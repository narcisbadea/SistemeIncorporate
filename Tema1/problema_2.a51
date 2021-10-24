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
START: 	MOV 	DPTR,#1000h	;incarcare adresa in DPTR 
		MOVX 	A,@DPTR		;citire din MD externa si incarcare in acumulator
		MOV 	R0,A		;incarca in registrul R0 continutul acumulatorului
		MOV 	DPTR,#SSEG	;incarca adresa SSEG(1000h) in DPTR
		MOV 	A,#00h		;incarca in acumulator 00h
		MOV 	R1,A		;incarca in registrul R1 continutul aculumatorului
LOOP: 	MOV 	A,R1		;incarca in acumulator continutul registrului R1
		MOVC 	A,@A+DPTR	;incarca in acumulator continutul locatiei de memorie de adresa calculata ca fiind A+DPTR
		SUBB 	A,R0		;scadere cu imprumut – scade al doilea operand sursa din primul operand, aflat in acumulator
		ADD 	A,#01h		;aduna continutul acumulatorului la operandul sursa si depune rezultatul in acumulator
		JZ 		EXIT		;executa un salt daca continutul acumulatorului este zero;
		INC 	R1			;incrementeaza R1 cu o unitate si pune rezultatul in locul lui;
		MOV 	A,R1		;incarca in acumulator continutul registrului R1
		CJNE 	A,#0Ah,LOOP	;testarea caracterului citit daca este egal cu 0Ah nu se face salt la Loop
		MOV 	R1,#0FFh	;incarca in registrul R1 valoarea 0FFh
EXIT: 	MOV 	DPTR,#0100h	;incarcare adresa(0100h) in DPTR 
		MOV 	A,R1		;incarca in acumulator continutul registrului R1 
		MOVX 	@DPTR,A		;incarcare in MD externa
		SJMP 	$
			
		ORG 	1000h
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