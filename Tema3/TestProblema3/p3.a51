init_timers EQU 051h 	;c.c. timer 0 in modul 1 pornire soft
const_omps 	EQU 0F0h	;0E0h ;o.m.p.s. al constantei de timp timer 0
const_oms 	EQU 0FFh	;0B1h ;o.m.s. al constantei de timp timer 0
const_T1	EQU	00h
loc_rez 	EQU 1000h 	;adresa locatiei rezultatului citirii
		
		
		ORG 0000h
		LJMP PP							;salt la adresa PP unde se afla programul principal
		
		ORG 000Bh			
		LJMP rut_t0						;salt la adresa rut_t0 unde se afla tratarea intreruperii
		
		ORG 100h
PP:		CLR 	IE.7 					;dezactiveaza sistemul de intreruperi
		MOV		TMOD,#init_timers		;scrie c.c. counter
		
		MOV		TH0,#const_oms			;initializare parte high timer 0
		MOV		TL0,#const_omps			;initializare parte low timer 0
		
		MOV		TH1,#const_T1			;initializare parte high counter 0
		MOV		TL1,#const_T1			;initializare parte low counter 0
		
		SETB 	TCON.4 					;pornire timer 0
		SETB 	IE.1 					;activare intreruperi timer 0
		SETB 	IE.7 					;activare sistem de intreruperi	
		
Loop:	SETB	TR1						;porneste counterul 1
		SJMP	$						;blocheaza si asteapta intreruperea
		
		ORG 300h
rut_t0:	CLR		TCON.4					;opreste timerul 0
		MOV		DPTR,#loc_rez			;incarca adresa de scriere in DPTR
		MOV		A,TH1					;incarca partea high a counter-ului 1 in acumulator
		MOVX	@DPTR,A					;se scrie TH1 in MD la adresa 1000h
		MOV		A,TL1					;incarca partea low a counter-ului 1 in acumulator
		INC		DPTR					;se incrementeaza adresa din DPTR
		MOVX	@DPTR,A					;se scrie TL1 in MD la adresa 1001h
		MOV 	TL1,#00h				;initializare parte low a counterului 1
		MOV		TH1,#00h				;initializare parte high a counterului 1
		
RETURN:	MOV 	TL0,#const_omps 		;initializare parte low timer 0
		MOV 	TH0,#const_oms 			;initializare parte high timer 0
		SETB	TCON.4					;se reporneste timerul 0
		RETI								;se revine la rutina de tratare a intreruperii
END