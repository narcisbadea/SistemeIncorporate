;Sa se scrie un program care sa asigure contorizarea fronturilor negative ale semnalului aplicat
;la intrarea /INT0. Contorizarea se va efectua in BCD rezultatul fiind depus in memoria de date
;externa la adresele 1000h si 1001h.Valoarile memorate in locatiile de memorie de date externa
;mai sus mentionate vor fi in intervalul 0 – 9999. La depasirea valorii 9999 contorul din memoria
;de date externa va fi initializat la 0.
;La intrarea /INT1 se considera ca se aplica un semnal de reset (activ pe fontul negativ) care, in
;momentul activarii, va pune “contorul” pe 0.
;Intreruperea /INT1 va fi mai prioritara decat /INT0. 

loc_rezUZ 	EQU 1001h
loc_rezSM	EQU 1000h
	
			ORG 0000h
			LJMP PP						;salt la programul principal
	
			ORG 0003h
			LCALL rut_int0				;salt la rutina de intreruperi pt INT0
			RETI

			ORG 0007h
			LCALL rut_int1				;salt la rutina de intreruperi pt INT1
			RETI
	
			ORG 100h
PP:			;validam INT0, INT1 si sistemul global de intreruperi
			SETB	IE.0
			SETB	IE.2
			SETB	IE.7
			
			SETB 	IP.2				;setam INT1 cu prioritate maxima
			SETB 	TCON.0				;run INT0 pe front cazator
			MOV 	DPTR, #loc_rezUZ	;setam adresa unitatilor si zecilor
			
IMPULS: 		;se simuleaza un semnal la INT0 prin setare si resetare
			CLR 	INT0
			SETB 	INT0
			SJMP 	IMPULS
			
			ORG 250h
rut_int0: 	CJNE 	R0, #99h, NEXT1		;verifica daca sutele si miile sunt egale cu 99
			LJMP 	rut_int1			;daca nu se face salt la rut_int1
			RET							;revenire la rutina
		
NEXT1:		CLR 	PSW.7				;resetam bitul de carry activat de CJNE
			INC 	A					;incrementam valoarea din acumulator
			DA 		A					;ajustam valoarea din acumulator pentru a afisa in BCD(fara A...F)
			MOVX 	@DPTR, A			;scriem valoarea din acumulator in MD
			JC 		NEXT2				;daca dupa DA valoarea din A trece de 99 
										;se semnaleaza ca trebuie incrementat si contorul sutelor si se trece la NEXT2
			RET							;revenire la rutina
			
NEXT2:		MOV 	DPTR, #loc_rezSM	;setam ca adresa sutelor si miilor sa fie 1000h
			CLR 	PSW.0				;resetam bitul de paritate 
			CLR 	PSW.7				;resetam bitul de carry
			MOV 	A, R0				;incarcam valoarea sutelor si miilor in acumulator
			INC 	A					;incrementam contorul
			DA 		A					;ajustam valoarea din acumulator pentru a afisa in BCD(fara A...F)
			MOVX 	@DPTR, A			;scriem valoarea din acumulator in MD
			MOV 	R0, A				;incarcam noua valoare a sutelor si miilor in R0
			MOV 	A, #00h				;resetam acumulatorul
			MOV 	DPTR, #loc_rezUZ	;incarcam adresa unitatilor si zecilor in DPTR
			RET							;revenire la rutina

;rutina de reset
			ORG 500h
rut_int1:	CLR 	PSW.0				;resetam bitul de paritate 
			CLR 	PSW.7				;resetam bitul de carry
			MOV 	A, #00h				;resetam valoarea lui A
			MOV 	R0, #00h			;resetam valoarea sutelor si miilor
			
			;resetam valoarea contorului scrisa in MD
			MOVX 	@DPTR, A		
			MOV 	DPTR, #loc_rezUZ	
			MOVX 	@DPTR, A			;scrie 00h la adresa unitatilor si zecilor
			
			MOV 	R1, #00h
			RET							;revenire la rutina
END