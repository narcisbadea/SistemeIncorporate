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
Start: 	MOV		DPTR,#1000h 	;incarcare adresa(1000h) in DPTR 
		MOVX 	A,@DPTR			;citire din MD externa a octetului mai semnificativ
								;a adresei de start a sirului 
		CJNE 	A,#30h,Next0	;testarea caracterului citit daca este egal cu CR(30h) nu se face salt la Next0
Next0: 	JC 		Exit			;salt la exit daca carry este setat pe 1
		CJNE 	A,#39h,Next1	;testarea caracterului citit daca este egal cu CR(39h) nu se face salt la Next1
Next1: 	JNC		Next2			;salt la Next2 daca carry este setat pe 0
		SUBB	A,#30h			;scadere cu imprumut – scade al doilea operand sursa din primul operand, aflat in acumulator
		MOV 	DPTR,#1001h		;incarcare adresa(1001h) in DPTR 
		MOVX	@DPTR,A			;depunere in MD externa
		SJMP 	Exit			;salt scurt la iesire
Next2: 	CJNE 	A,#41h,Next3	;testarea caracterului citit daca este egal cu CR(39h) nu se face salt la Next3
Next3: 	JC 		Exit			;salt la exit daca carry este setat pe 1
		CJNE 	A,#46h,Next4	;testarea caracterului citit daca este egal cu CR(39h) nu se face salt la Next4
Next4: 	JNC 	Exit			;salt la Exit daca carry este setat pe 0
		SUBB	A,#37h			;scadere cu imprumut – scade al doilea operand sursa din primul operand, aflat in acumulator
		MOV 	DPTR,#1001h		;incarcare adresa(1000h) in DPTR 
		MOVX 	@DPTR,A			;depunere in MD externa
		SJMP 	Exit			;salt scurt la iesire
Exit: 	SJMP 	$
END