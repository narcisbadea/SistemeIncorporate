			ORG 0000h
			LJMP PP;salt la programul principal
	
	
			ORG 0003h
		
E_INT0:		MOVX @DPTR,A;mutam valoarea lui A in DPTR
			MOV R0,A;salvam valorea initiala a lui A
			ANL A,#0FH;trunchiem primii biti ai lui A
			CJNE A,#0AH,NEXT;comparam pe A cu 0h
			RETI

NEXT:		JNC RETURN
			ACALL CONVERSION;apelam functia de conversie
			MOV DPTR,#1000h;mutam adresa registrului DPTR la 1000h
			MOVX @DPTR,A;mutam valoarea lui A in DPTR
			MOV A,R0;salvam valoarea lui A
			SWAP A;inversam primii 4 biti cu ultimii 4 biti
			ANL A,#0FH;trunchiem primii biti ai lui A
			CJNE A,#0AH,NEXT1;comparam pe A cu 0h

NEXT1:		JNC RETURN
			ACALL CONVERSION;apelam functie de conversie 
			MOV DPTR,#1001H;mutam adresa registrului DPTR la 1001h
			MOVX @DPTR,A;mutam valoarea lui A in DPTR

RETURN: 	RETI;funcita de revenire

CONVERSION:	CJNE A,#09H,NEXT2;comparam pe A cu 09h


NEXT2:		JNC LOOP;in cazul in care este mai mare ca 09h ne intoarcem la functia LOOP
			MOV DPTR,#SSEG;Mutam valoriile lui SSEG in DPTR
			MOVC A,@A+DPTR;facem conversia lui A in DPTR
			RET
	
//Functia pentru initializare
PP:			MOV IE,#85h
			MOV IP,#05h
			MOV TCON,#05h
			MOV DPTR,#1000H

//Functia LOOP in care citim valorea lui P1 si o comparam cu vechea valoarea
LOOP:		MOV A,P1
			CJNE A,P1,RESET
			SJMP LOOP

//Functia pentru activarea intreruperii
RESET:		CLR P3.2
			SETB P3.2
			SJMP LOOP


// Functia pentru 7 SEGMENTE
SSEG: DB 3FH
      DB 06H
      DB 5BH
      DB 4FH
      DB 66H
      DB 6DH
      DB 7DH
      DB 07H
      DB 7FH
      DB 6FH 
	
	

END;sfarsitul programului

	
	
	
	