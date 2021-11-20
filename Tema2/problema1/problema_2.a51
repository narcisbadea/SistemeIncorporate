ORG 0000h
	LJMP 	PP			;salt la programul principal
	
ORG 003h			
Rut_INT0:
	SETB	P1.0		;seteaza P1.0 pe 1 logic
	RETI				;revenire din rutina de tratare a intreruperii 
	
ORG 0013h			
Rut_INT1:
	CLR 	P1.0		;reseteaza P1.0;
	RETI				;revenire din rutina de tratare a intreruperii 		  
			
PP:		
		SETB 	IE.0		;EX0 - se seteaza pe 1 => cererea de intrerupere externa /INT0 este validata	
		SETB 	IE.2	   	;EX1 - se seteaza pe 1 => cererea de intrerupere externa /INT1 este validata
		SETB 	IE.7		;EA  - Bit de validare/invalidare globala a sistemului de intreruperi se seteaza pe 1 logic	
	
		SETB 	TCON.0	   	;IT0 - se seteaza pe 1 => cererea de intrerupere INT0 este activa pe frontul coborator
		SETB 	TCON.2		;IT1 - se seteaza pe 1 => cererea de intrerupere INT1 este activa pe frontul coborator 

		CLR		P3.2		;request enable pentru INT0
		SETB	P3.2		;request disable pentru INT0
		CLR 	P3.3		;request enable pentru INT1
		SETB	P3.3		;request disable pentru INT1
		SJMP 	EXIT		;salt scurt la EXIT

EXIT:   SJMP $ 
END
