     ORG 00H
     MOV A,#38H
		ORG	00H
		
RS	EQU	P3.5	
		RW	EQU	P3.6	
		E	EQU	P3.7	
		
		MOV	SP, #70H
		MOV	PSW, #00H
		
LCD_IN:		MOV	A, #38H			
		ACALL	COMNWRT		
		ACALL 	DELAY			
		MOV 	A, #0FH		
		ACALL	COMNWRT			
		ACALL 	DELAY			
		MOV	A, #01			
		ACALL	COMNWRT			
		ACALL 	DELAY	
		MOV	A, #06H			
		ACALL	COMNWRT			
		ACALL 	DELAY			
		MOV	A, #80H		
		ACALL	COMNWRT			
		ACALL 	DELAY
              				
	MOV R1,#0	
        MOV R2,#0
        MOV R3,#0
        MOV R6,#0
        MOV R5,#0
        MOV R4,#7
	MOV P2,#0FFH
START:	DJNZ R4,K1
	LJMP RESULT
K1:	MOV P3,#0
	MOV A,P2
	ANL A,#00001111B
	CJNE A,#00001111B,K1
K2:	ACALL DELAY
	MOV A,P2
	ANL A,#00001111B
	CJNE A,#00001111B,OVER
	SJMP K2
	
OVER:	ACALL DELAY
	MOV A,P2
	ANL A,#00001111B
	CJNE A,#00001111B,OVER1
	SJMP K2
OVER1:	MOV P3,#11111110B
	MOV A,P2
	ANL A,#00001111B
	CJNE A,#00001111B, ROW_0
	MOV P3,#11111101B
	MOV A,P2
	ANL A,#00001111B
	CJNE A,#00001111B,ROW_1
	MOV P3,#11111011B
	MOV A,P2
	ANL A,#00001111B
	CJNE A,#00001111B, ROW_2
	MOV P3,#11110111B
	MOV A,P2
	ANL A,#00001111B
	CJNE A,#00001111B, ROW_3
	LJMP K2
ROW_0: MOV DPTR,#KCODE0
	SJMP FIND
ROW_1: MOV DPTR,#KCODE1
	SJMP FIND
ROW_2: MOV DPTR,#KCODE2
	SJMP FIND
ROW_3: MOV DPTR,#KCODE3
FIND:	RRC A
	JNC MATCH
	INC DPTR
	SJMP FIND
MATCH:  CLR A
	MOVC A,@A+DPTR
	ACALL DATAWRT
	CJNE R4,#6,CHECKIFFIVE
	LJMP FIRSTPRESS
CHECKIFFIVE: CJNE R4,#5,CHECKIFFOUR
	     LJMP SECONDPRESS
CHECKIFFOUR: CJNE R4,#4,CHECKIFTHREE
             LJMP THIRDPRESS
 CHECKIFTHREE: CJNE R4,#3,CHECKIFTWO
             LJMP FORTHPRESS
 CHECKIFTWO: CJNE R4,#2,CHECKIFONE
             LJMP FIVTHPRESS
 CHECKIFONE: CJNE R4,#1,ERROR
              LJMP SIXTHPRESS
 ERROR: MOV DPTR,#MYDATA
 FIRSTPRESS: CLR C
             SUBB A,#48
             MOV R1,A
             CLR A
             LJMP START
 SECONDPRESS: LJMP ISITADD1
             
 RETURN:      CLR C
              SUBB A,#48
              MOV R2,A
              CLR A
              MOV A,R1
              MOV B,#10
              MUL AB 
              ADD A,R2
              MOV R1,A
              MOV R2,#0
              LJMP START
 ISITADD1:  CJNE A,#43,ISITSUBB1
          MOV R3,A
          LJMP START
	
ISITSUBB1: CJNE A,#45,ISITDIV1
          MOV R3,A
          LJMP START
ISITDIV1:  CJNE A,#47,ISITMUL1
          MOV R3,A
          LJMP START
ISITMUL1:  CJNE A,#42,ISITCLR
          MOV R3,A
          LJMP START
ISITCLR: CJNE A,#35,RETURN
         MOV A,#01
         ACALL COMNWRT
     
 THIRDPRESS:  LJMP ISITADD2
 RETURN2:      CLR C
               SUBB A,#48
               MOV R5,A
               LJMP START
 ISITADD2: CJNE A,#43,ISITSUBB2
           MOV R3,A
           LJMP START
ISITSUBB2: CJNE A,#45,ISITDIV2
          MOV R3,A
          LJMP START
ISITDIV2:  CJNE A,#47,ISITMUL2
          MOV R3,A
          LJMP START
ISITMUL2:  CJNE A,#42,RETURN2
          MOV R3,A
          LJMP START
ISITCLR1: CJNE A,#35,RETURN2
         MOV A,#01
         ACALL COMNWRT

 FORTHPRESS: LJMP ISITEQUAL1
 RETURN3:     CLR C
              SUBB A,#48
              MOV R6,A
              CLR A
              MOV A,R5
              MOV B,#10
              MUL AB 
              ADD A,R6
              MOV R5,A
              MOV R6,#0
              LJMP START
 ISITEQUAL1:CJNE A,#61,ISITCLR2
            SJMP RESULT
 ISITCLR2: CJNE A,#35,RETURN3
         MOV A,#01
         ACALL COMNWRT
 
            
 FIVTHPRESS: LJMP ISITEQUAL2
 RETURN4:     CLR C
              SUBB A,#48
              MOV R6,A
              CLR A
              MOV A,R5
              MOV B,#10
              MUL AB 
              ADD A,R6
              MOV R5,A
              MOV R6,#0
              LJMP START
 ISITEQUAL2:  CJNE A,#61,ISITCLR3
              SJMP RESULT
  ISITCLR3: CJNE A,#35,RETURN4
         MOV A,#01
         ACALL COMNWRT
 SIXTHPRESS:  LJMP ISITEQUAL3
 ISITEQUAL3:  CJNE A,#61,ISITCLR4
              SJMP RESULT
 RETURN11:     MOV DPTR,#MYDATA
  ISITCLR4:  CJNE A,#35,RETURN11
              MOV A,#01
              ACALL COMNWRT
 RESULT:      LCALL ISITADD3
              
              
 
 ISITADD3:  CJNE R3,#43,ISITSUBB3
            MOV A,R5
            ADD A,R1
            LJMP NUM2ASCII
 NUM2ASCII: MOV B,#100
            DIV AB
            ADD A,#48
            SETB PSW.3  
            MOV R1,A
            CLR A
            MOV A,B
            MOV B,#10
            DIV AB
            ADD A,#48
            MOV R2,A
            MOV A,B
            ADD A,#48
            MOV R3,A  
            MOV A,R1
            ACALL DATAWRT
            MOV A,R2
            ACALL DATAWRT
            MOV A,R3
            ACALL DATAWRT
            CLR PSW.3 
            LJMP K1 
 
     
           
ISITSUBB3:CJNE R3,#45,ISITDIV3
          MOV A,R1
          MOV 40H,#0
          MOV 40H,R5
          CJNE A,40H,HELLO
HELLO:    JNC NORMAL
          CLR A
          MOV A,R5
          CLR C
          SUBB A,R1
          MOV R4,A
          MOV A,#45
          ACALL DATAWRT
          MOV A,R4 
          SJMP NUM2ASCII
NORMAL:   SUBB A,R5
          SJMP NUM2ASCII          
ISITDIV3: CJNE R3,#47,ISITMUL3
          MOV A,R1
          MOV B,R5
          DIV AB
          MOV B,#0
          LJMP NUM2ASCII

 RETURN5:    MOV DPTR,#MYDATA
            
           
ISITMUL3: CJNE R3,#42,RETURN5
          MOV A,R1
          MOV B,#10
          DIV AB
          SETB PSW.3
          MOV R1,A ;DOSOK GHOR FIRST NUMBER ER
          CLR A
          MOV A,B
          MOV R2,A ;EKOK GHOR FIRST NUMBER ER
          CLR A
          CLR PSW.3
          MOV A,R5
          MOV B,#10
          DIV AB
          SETB PSW.3
          MOV R3,A ;DOSOK GHOR SECOND NUMBER ER
          CLR A
          MOV A,B
          MOV R4,A ;EKOK GHOR SECOND NUMBER ER
          CLR A
          MOV A,R4
          MOV B,A
          CLR A
          MOV A,R2
          MUL AB
          MOV B,#10
          DIV AB
          MOV R5,A
          CLR A 
          MOV A,B
          CLR PSW.3
          SETB PSW.4
          MOV R5,A
          CLR PSW.4
          SETB PSW.3
          CLR A
          MOV A,R1
          MOV B,A
          CLR A
          MOV A,R4
          MUL AB
          ADD A,R5
          MOV R5,A
          CLR A
          MOV A,R3
          MOV B,A
          CLR A
          MOV A,R2
          MUL AB
          MOV B,#10
          DIV AB
          MOV R6,A
          CLR A
          MOV A,B
          ADD A,R5
          MOV R5,A
          CLR A
          MOV A,R3
          MOV B,A
          CLR A 
          MOV A,R1
          MUL AB
          ADD A,R6
          MOV B,#10
          DIV AB
          MOV R7,A
          CLR A
          MOV A,B
          MOV B,#10
          MUL AB
          ADD A,R5
          MOV R5,A
          MOV A,R5
          MOV B,#100
          DIV AB
          CJNE A,#1,SOM
          ADD A,R7
          ADD A,#48
          ACALL DATAWRT
           MOV A,B
          ;MOV A,R5
          MOV B,#10
          DIV AB
          MOV R0,A
          SETB PSW.4
          CLR PSW.3
          MOV A,B
          MOV R1,A
          CLR PSW.4
          SETB PSW.3
          MOV A,R0
          ADD A,#48
          ACALL DATAWRT
          CLR PSW.3
          SETB PSW.4
          MOV A,R1
          ADD A,#48
          ACALL DATAWRT
          CLR A
          MOV A,R5
          ADD A,#48
          ACALL DATAWRT
          CLR PSW.4  
          CLR PSW.3
          LJMP K1         
          
          
          
  SOM:    SETB PSW.3
          CLR PSW.4
          MOV A,R5
          MOV B,#10
          DIV AB
          SETB PSW.4
          SETB PSW.3
          MOV R0,A
          CLR PSW.3
          SETB PSW.4
          MOV A,B
          MOV R1,A
          CLR PSW.4
          SETB PSW.3
          MOV A,R7
          ADD A,#48
          ACALL DATAWRT
          SETB PSW.3
          SETB PSW.4
          MOV A,R0
          ADD A,#48
          ACALL DATAWRT
          CLR PSW.3
          SETB PSW.4
          MOV A,R1
          ADD A,#48
          ACALL DATAWRT
          CLR A
          MOV A,R5
          ADD A,#48
          ACALL DATAWRT
          CLR PSW.4  
          CLR PSW.3
          LJMP K1         
          
          
          
          
          


          
           
                                           	
	
	ORG 300H
KCODE0: DB '1','2','3','-'
KCODE1: DB '4','5','6','/'
KCODE2: DB '7','8','9','+'
KCODE3: DB '*','0','#','='


COMNWRT:	LCALL	READY			
		MOV	P1, A		
		CLR	RS			
		CLR	RW	
		SETB	E				
		ACALL	DELAY			
		CLR	E			
		RET
DATAWRT:	LCALL	READY			
		MOV	P1,A
		SETB	RS			
		CLR	RW		
		SETB	E			
		ACALL	DELAY			
		CLR	E			
		RET

		
READY:		SETB	P1.7			
		CLR	RS			
		SETB	RW			

WAIT:		CLR	E			
		LCALL	DELAY
		SETB	E
		JB	P1.7, WAIT
		RET                	

DELAY:		MOV	R0, #50			
HERE2:		MOV	R7, #255
HERE:		DJNZ	R7, HERE		
		DJNZ 	R0, HERE2
		RET
MYDATA:         DB "ERROR",0
		
	        END