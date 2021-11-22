;La intrarea /INT0 a unui µC P89C51RD2 se aplica un semnal de forma celui prezentat in figura
;de mai jos. Sa se scrie un program cu ajutorul caruia sa se determine valoarea lui T. Frecventa
;de oscilatie a cristalului de cuart este fclk = 12 MHz. Valoarea lui T va fi depusa in memoria
;de date externa de la adresa 1000h




;Pentru simulare se foloseste counter-ul 0 in modul 0 si se asteapta aplicarea 
;unui semnal la portul INT0(P3.2, pentru simulare se aplica manual) iar dupa folosind
;counter-ul se numara cat timp semnalul este aplicat. Cand punem INT0(P3.2) pe 0
;se scrie in MD la adresa 1001h respectiv 10001h valorile din TH0 respectiv TL0 iar apoi se reia

init_timer 	EQU 0Ch 	;counter 0 in modul 0, GATE pe 1
const_omps 	EQU 00h		;o.m.p.s. al constantei de timp timer 0
const_oms 	EQU 00h		;o.m.s. al constantei de timp timer 0
loc_rez 	EQU 1000h 	;adresa locatiei rezultatului

			ORG	00h
PP:			MOV		TMOD,#init_timer	;setare counter
			MOV 	TH0,#const_oms		;initializare parte low counter 0
			MOV 	TL0,#const_omps		;initializare parte high counter 0
			CLR		INT0				;reseteaza /INT0
			SETB	TCON.4				;start counter	0
			
LOOP:		JNB		INT0,$				;testeaza /INT0 iar atat timp cat e pe 0 se blocheaza

rut_INT0:	CLR		T0					;genereaza un
			SETB	T0					;impuls
			
			MOV		A,p3				;incarca valoarea portului p3 in acumulator
			CJNE	A,#0FBh,rut_INT0	;daca valoarea din acumulator este diferita de #0FBh(INT0 pe 1) 
										;revine la rut_INT0 altfel se trece mai departe
			MOV		DPTR,#loc_rez		;incarca adresa la care se scrie in DPTR
			MOV		A,TH0				;incarca partea high a timer-ului 0 in acumulator
			MOVX	@DPTR,A				;scrie valoarea din acumulator in MD la 1000h
			INC		DPTR				;incrementeaza adresa din DPTR
			MOV		A,TL0				;incarca partea low a timer-ului 0 in acumulator
			MOVX	@DPTR,A				;scrie valoarea din acumulator in MD la 1001h
			
			MOV 	TH0,#const_oms		;reinitializare parte low counter 0
			MOV 	TL0,#const_omps		;reinitializare parte high counter 0
			
			LJMP	LOOP				;salt la LOOP
END