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
		MOVX 	A,@DPTR 		;citire din MD externa si depunere in acumulator
		ADD		A,#30h			;aduna continutul acumulatorului la operandul sursa si depune rezultatul in acumulator
		CJNE	A,#39h,Next		;testarea caracterului citit daca este egal cu CR(09h) nu se face salt la Next
Next:	JC		Exit			;salt la exit daca carry este setat pe 1(in acumulator nu este incarcat un numar BCD)
		MOV		A,#20h			;incarcare valoare(20h) in acumulator 
		SJMP	Exit			;salt scurt la iesire
Exit:	MOV 	DPTR,#0100h		;incarcare adresa(0100h) in DPTR 
		MOVX 	@DPTR,A			;depunere in MD externa
		SJMP	$
END