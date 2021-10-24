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
Start: 		MOV		DPTR,#1000h		;incarcare adresa(1000h) in DPTR 
			MOVX	A,@DPTR			;citire din MD externa si incarcare in acumulator
			SUBB	A,#30h			;scadere cu imprumut – scade al doilea operand sursa din primul operand, aflat in acumulator
			CJNE	A,#0Ah,Next		;testarea caracterului citit daca este egal cu CR(0Ah) nu se face salt la Next
Next:		JC		Exit			;salt la exit daca carry este setat pe 1
			SUBB	A,#07h			;scadere cu imprumut – scade al doilea operand sursa din primul operand, aflat in acumulator
			SJMP	Exit			;salt scurt la iesire
Exit:		MOV 	DPTR,#1001h		;incarcare adresa(1000h) in DPTR 
			MOVX 	@DPTR,A			;depunere in MD externa
			SJMP	$
END