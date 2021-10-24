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
Start: 	MOV 	DPTR,#1000h		;incarcare adresa in DPTR
		MOVX 	A,@DPTR			;incarca in acumulator  continutul aflat in DPTR
		MOV 	R0,#20h			;depunere in registrul R0
		CJNE 	A,#09h,Next		;testarea caracterului citit daca este egal cu CR(09h) nu se face salt la Next
Next: 	JNC 	Exit			;salt la Exit daca carry este setat pe 0
		ADD 	A,#30h			;aduna continutul acumulatorului la operandul sursa si depune rezultatul in acumulator
		MOV 	R0,A			;depunere in registrul R0
Exit: 	MOV 	A,R0			;depunere in acumulator
		MOV 	DPTR,#0100h		;incarcare adresa in DPTR 
		MOVX 	@DPTR,A			;depunere in MD externa
		SJMP 	$
END