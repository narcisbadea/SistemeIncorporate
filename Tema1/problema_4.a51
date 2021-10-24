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

		ORG 	0h
START: 	MOV 	DPTR,#1000h			;incarcare adresa in DPTR 
		MOVX 	A,@DPTR				;citire din MD externa si depunere in acumulator
		MOV 	B,#0Ah				;incarcare 0Ah in B
		DIV 	AB					;executa impartirea unui intreg fara semn pe 8 biti, aflat in acumulator, la un intreg
									;fara semn pe 8 biti aflat in registrul B
		MOV 	DPTR,#100h			;incarcare adresa(100h) in DPTR 
		MOVX 	@DPTR,A				;depunere in MD externa
		MOV 	A,B					;incarca adresa registrului B in acumulator
		MOV 	DPTR,#101h			;incarcare adresa(101h) in DPTR
		MOVX 	@DPTR,A				;depunere in MD externa
		SJMP 	$
END
	
