;1. Sa se scrie un program cu ajutorul caruia sa se citeasca cate un octet prin intermediul portului
;P1 al unui µC P89C51RD2 cu o cadenta de 20 msec. Octetii cititi sunt convertiti in doua
;caractere ASCII care vor fi apoi depuse in memoria de date externa de la adresa 1000h.
;Frecventa de oscilatie a cristalului de cuart este fclk = 12 MHz. 




;folosind intreruperile realizate de timer-ul 0 la fiecare 20msec citesc paloarea portului p1
;si il separ in doua parti a cate 4 biti apoi il convertesc in ASCII si il depun la adresele 1000h respectiv 1001h
;Pentru a simula mai bine am adaugat o incrementare a portului P1 automata

init_timer 	EQU 01h 				;timer 0 in modul 1 pornire soft
									;am lasat valorile pentru simulare F0h si FFh pentru a se intrerupe la 16 treceri 
									;insa valorile pentru 20msec sunt in paranteza
const_omps 	EQU 0F0h				;(0E0h) o.m.p.s. al constantei de timp timer 0
const_oms 	EQU 0FFh				;(0B1h) o.m.s. al constantei de timp timer 0
	
init_P1 	EQU 00h 				;initializare port P1
loc_rez 	EQU 1000h 				;adresa locatiei rezultatului


		ORG 0000h
		LJMP PP						;salt la adresa PP unde se afla programul principal
				
		ORG 000Bh			
		LJMP rut_t0					;salt la adresa rut_t0 unde se afla tratarea intreruperii


;programul principal	
		ORG 100h		
PP:		CLR 	IE.7 				;dezactiveaza sistemul de intreruperi
		MOV		DPTR,#loc_rez		;se incarca adresa la care se scrie in DPTR
		MOV 	P1,#init_P1 		;initializare port P1
		MOV 	TMOD,#init_timer 	;scrie mod timer
		MOV 	TL0,#const_omps 	;initializare parte low timer 0
		MOV 	TH0,#const_oms 		;initializare parte high timer 0
		SETB 	IE.1 				;activare intreruperi timer 0
		SETB 	IE.7 				;activare sistem de intreruperi
		SETB 	TCON.4 				;pornire timer 0

Loop:	SJMP 	$ 					;oprire program principal pana la realizarea intreruperii
			
			
;tratarea intreruperii
		ORG 300H		
rut_t0:
		MOV 	A,P1				;incarca valoarea din P1 in acumulator
		MOV 	R1,A				;incarca valoarea acumulatorului in R1
		ANL 	A,#0FH				;pastreaza in acumulator doar biti de la 1-4 din octet
		ACALL 	CONVERSIE			;conversie valoare primilor 4 octeti in ASCII
		MOVX 	@DPTR,A				;se scrie nr-ul in MD
		INC 	DPTR				;se trece la urmatoarea adresa in DPTR	
		MOV 	A,R1				;reia octetul nemodificat din R1 si il incarca in acumulator
		SWAP 	A					;face swap intre cele 2 perechi de cate 4 biti ale octetului
		ANL 	A,#0FH				;pastreaza in acumulator doar biti de la 4-8 din octet
		ACALL 	CONVERSIE			;conversie valoare ultimilor octeti in ASCII
		MOVX 	@DPTR,A				;se scrie nr-ul in MD
		MOV 	DPTR,#loc_rez	    ;se revine la adresa 1000h
		
NEW_P1:	INC 	P1					;incrementeaza portul P1

RETURN:	MOV 	TL0,#const_omps 	;initializare parte low timer 0
		MOV 	TH0,#const_oms 		;initializare parte high timer 0
		RETI						;revenire la rutina


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CONVERSIA IN ASCII
		ORG 250H
conversie:
		CJNE 	A,#0Ah,next0		;daca numarul din acumulator aeste diferit de #0Ah merge la next0
		
next0: 
		JC 		next1				;salt la next1 daca carry este setat pe 1
		ADD 	A,#37h				;aduna continutul acumulatorului cu #37h		
		RET							;revenire din rutina
		
next1: 
		ADD 	A,#30h				;aduna continutul acumulatorului cu #30h
		RET							;revenire din rutina
	
END	

