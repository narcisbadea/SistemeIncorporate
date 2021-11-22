;se lucreaza cu intreruperi si se deviaza programul principal la 100h
;timerul 0 - temporizator pe 16 biti
;T=20 msec N=65536-20000=45536 N=B1E0h

init_timer 	EQU 01h ;c.c. timer 0 in modul 1 pornire soft
const_omps 	EQU 0E0h ;o.m.p.s. al constantei de timp timer 0
const_oms 	EQU 0B1h ;o.m.s. al constantei de timp timer 0
init_P1 	EQU 00h ;initializare port P1
loc_rez 	EQU 0100h ;adresa locatiei rezultatului citirii
	
		ORG 0000h
		LJMP PP ;salt la adresa PP unde se afla programul principal
		
		ORG 000Bh
		LJMP rut_t0 ;salt la adresa rut_t0 unde se afla rutina de tratare a intreruperii
		
;corpul programului principal
		ORG 100h
PP: 	CLR 	IE.7 ;dezactiveaza sistemul de intreruperi
		MOV 	P1,#init_P1 ;initializare port P1
		MOV 	TMOD,#init_timer ;scrie c.c. timer
		MOV 	TL0,#const_omps ;initializare parte low timer 0
		MOV 	TH0,#const_oms ;initializare parte high timer 0
		SETB 	IE.1 ;activare intreruperi timer 0
		SETB 	TCON.4 ;pornire timer 0
		SETB 	IE.7 ;activare sistem de intreruperi
		SJMP 	$ ;oprire program principal


;rutina propriu-zisa de tratare a intreruperii de la timerul 0
		ORG 500h
rut_t0: CLR 	IE.1 ;dezaciveaza intreruperi timer 0
		CLR 	TCON.4 ;opreste timerul 0
;reinitializare timer
		MOV 	TL0,#const_omps ;initializare parte low timer 0
		MOV 	TH0,#const_oms ;initializare parte high timer 0
		MOV 	A,#0FFh ;valoare initiala locatie rezultat
		MOV 	DPTR,#loc_rez ;adresa locatiei rezultatului in DPTR
		MOVX 	@DPTR,A ;initializare locatie rezultat
		INC		P1
		RET
