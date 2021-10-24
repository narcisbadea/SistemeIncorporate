;Sa se scrie un program care sa asigure conversia unei variabile NUMAR aflata in
;memoria de date externa la adresa 1000h in doi digiti BCD continuti in variabila
;STRING aflata in memoria de date externa de la adresa 100h.
;Exemple:
;a) Intrari: NUMAR: (1000h) = 1Dh
; 	Iesiri: STRING: (0100h) = 02h
;					(0101h) = 09h
;
;b) Intrari: NUMAR: (1000h) = 61h
; 	Iesiri: STRING: (0100h) = 09h
;					(0101h) = 07h 

		ORG 	0H
START: 	MOV 	DPTR,#1000H			;incarcare adresa in DPTR 
		MOVX 	A,@DPTR				;citire din MD externa si depunere in acumulator
		MOV 	B,#0AH
		DIV 	AB
		MOV 	DPTR,#100H
		MOVX 	@DPTR,A
		MOV 	A,B
		MOV 	DPTR,#101H
		MOVX 	@DPTR,A
		SJMP 	$
END