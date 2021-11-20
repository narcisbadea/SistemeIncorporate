ORG 0000h
LJMP PP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CITIREA NUMERELOR
ORG 0003h
		MOV 	A, P1 			;se incarca valoarea din P1 in acumulator
		MOV 	DPTR,#1000h 	;incarcare adresa(1000h) in DPTR 
		MOVX 	@DPTR,A 		;incarcare in MD externa
LOOP:	MOV 	B, P1 			;se incarca urmatoarea valoare din P1 in B
		CJNE 	A, B, BREAK 	;daca cele doua valori sunt egale se reciteste B din P1
		SJMP 	LOOP			;revenire la LOOP
BREAK:
		MOV 	A,B 			;valoarea lui B se incarca in acumulator
		MOV 	DPTR,#1001h		;incarcare adresa(1001h) in DPTR
		MOVX 	@DPTR,A			;incarcare in MD externa
		RETI					;revenire din rutina de tratare a intreruperii

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;SETAREA INTRERUPERILOR
PP:		SETB 	IE.0			;EX0 - se seteaza pe 1 => cererea de intrerupere externa /INT0 este validata
		SETB 	IE.7			;EA  - Bit de validare/invalidare globala a sistemului de intreruperi se seteaza pe 1 logic
		CLR		P3.2			;request enable pentru INT0
		SETB	P3.2			;request disable pentru INT0 pentru a nu mai avea intreruperi
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CONVERSIA IN ASCII

		MOV 	DPTR,#1000h		;incarcare adresa(1000h) in DPTR 
		MOVX 	A,@DPTR			;citire din MD externa si incarcare in acumulator
		CJNE 	A,#0Ah,NEXT0	;daca numarul din acumulator aeste diferit de #0Ah merge la NEXT0
		
NEXT0:	JC 		NEXT1			;salt la NEXT1 daca carry este setat pe 1
		ADD 	A,#37h			;aduna continutul acumulatorului cu #37h
		SJMP 	NEXTnr			;salt scurt la NEXTnr
		
NEXT1:	ADD 	A,#30h			;aduna continutul acumulatorului cu #30h
		
NEXTnr:	MOV 	DPTR,#100h		;incarcare adresa(100h) in DPTR 
		MOVX 	@DPTR,A			;se scrie primul nr in MD
		MOV 	DPTR,#1001h		;incarcare adresa(1001h) in DPTR 
		MOVX 	A,@DPTR			;citire din MD externa si incarcare in acumulator
		CJNE 	A,#0Ah,NEXT2	;daca continutul acumulatorului este diferit de #0Ah se merge la NEXT2
		
NEXT2:  JC 		NEXT3			;salt la NEXT3 daca carry este setat pe 1
		ADD 	A,#37h			;aduna continutul acumulatorului cu #37h
		SJMP 	EXIT			;salt scurt la EXIT
		
NEXT3:	ADD 	A,#30h			;aduna continutul acumulatorului cu #37h

EXIT:	MOV 	DPTR,#101h		;incarcare adresa(101h) in DPTR 
		MOVX 	@DPTR,A			;se scrie al doilea nr in MD externa
		SJMP 	$
END		
