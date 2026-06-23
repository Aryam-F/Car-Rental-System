.MODEL SMALL
.STACK 100h
.DATA

msg1 DB 0DH, 0AH, ' Car Rental System $'
msg2  DB 0DH, 0AH, 0DH, 0AH, ' 1- Displaying Available Buses $'
msg3 DB 0DH, 0AH, ' 2- Booking a Car $'
msg4  DB 0DH, 0AH, ' 3- Calculating total price $'
msg5 DB 0DH, 0AH, ' 4- Exit the application $'
msg6  DB 0DH, 0AH, 0DH, 0AH, ' Enter your choice: $'
msg7 DB 0DH, 0AH, 0DH, 0AH, ' To return to the menu , press any key: $'
MENU DB " List of Cars: ",0DH,0AH

db " --------------------------------------------------------------------- ",0DH,0AH
db " | Car Number  |     Car Type     |   Car Model     | Rental Price Per Day | ",0DH,0AH
db " |--------------|---------------|---------------|----------------------|",0DH,0AH
db " |    Car 001      |       Sedan        | Toyota Camry |         100 SAR             |",0DH,0AH
db " |--------------|---------------|---------------|----------------------|",0DH,0AH
db " |    Car 002.     |       SUV           | Ford Explorer  |        150 SAR              |",0DH,0AH
db " |--------------|---------------|---------------|----------------------|",0DH,0AH
db " |    Car 003      |      Truck          |  Nissan Titan  |         200 SAR             |",0DH,0AH
db " |--------------|---------------|---------------|----------------------|",0DH,0AH,'$'
 
   
msg8 DB 0DH,0AH,0DH,0AH, 'To Get A Discount Of <15%> Only If You Are a member Press (M) Or (m) $'


msg9 DB 0DH, 0AH, 0DH, 0AH, ' The Total Is: $'
msg10 DB 0DH, 0AH, 0DH, 0AH, ' Thank You For Choosing Our Company. $'
msg11 DB 0DH, 0AH, 0DH, 0AH, ' Sorry, Not Available Choose Between (1 - 3)! $'
D15 DW 15
D100 DW 100
FinalCount DW 0


.CODE
MAIN PROC


MOV AX,@data
MOV DS,AX

START:

MOV AH,0
MOV AL,3
INT 10H


MOV AH,9 
LEA DX,msg1 
INT 21H

MOV AH,9
LEA DX,msg2
INT 21H

MOV AH,9
LEA DX,msg3
INT 21H

MOV AH,9
LEA DX,msg4
INT 21H

MOV AH,9
LEA DX,msg5
INT 21H

MOV AH,9
LEA DX,msg6
INT 21H




MOV AH,1 
INT 21H

CMP AL,"1"
JE Display 

CMP AL,"2"
JE Booking

CMP AL,"3"
JE Total 

CMP AL,"4"
JE EXIT

JMP START




Display:

MOV AH,0
MOV AL,3
INT 10H

MOV AH,9
LEA DX,MENU
INT 21H

MOV AH,9
LEA DX,msg7
INT 21H

MOV AH,1
INT 21H
JMP START



Booking:

MOV AH,0
MOV AL,3
INT 10H

MOV AH,9
LEA DX,MENU
INT 21H

MOV AH,9
LEA DX,msg6
INT 21H

MOV AH,1
INT 21H


CMP AL,"1"
JL UnAvaliable

CMP AL,"3"
JG UnAvaliable

MOV BL,AL 
JMP START




Total:

CMP BL,"1"
JE COST_100

CMP BL,"2"
JE COST_150

CMP BL,"3"
JE COST_200

JMP UnAvaliable

COST_100:
MOV FinalCount,100
JMP Bill

COST_150:
MOV FinalCount,150
JMP Bill

COST_200:
MOV FinalCount,200
JMP Bill




UnAvaliable:

MOV AH,9
LEA DX,msg11
INT 21H

MOV AH,1 
INT 21H

JMP Booking



Bill:

MOV AH,0 
MOV AL,3
INT 10H

MOV AH,9
LEA DX,msg9
INT 21H

MOV AX,FinalCount
CALL OUTDEC ; 

MOV AH,9
LEA DX,msg8
INT 21H

MOV AH,1
INT 21H

CMP AL, "m"

JE Discount

CMP AL, "M"

JE Discount

JMP No_Discount

Discount:

MOV AX,FinalCount
MUL D15
DIV D100
SUB FinalCount,AX

No_Discount:
MOV AH,9
LEA DX,msg9
INT 21H

MOV AX,FinalCount

CALL OUTDEC

MOV AH,9
LEA DX,msg7
INT 21H

MOV AH,1
INT 21H

JMP START

EXIT:

MOV AH,0 
MOV AL,3
INT 10H

MOV AH,9
LEA DX,msg10
INT 21H


MOV AH,4CH
INT 21H

MAIN ENDP
INCLUDE:
OUTDEC PROC

PUSH AX
PUSH BX
PUSH CX
PUSH DX

OR AX,AX

JGE END_IF1

PUSH AX
MOV DL,'-'

MOV AH,2
INT 21H

POP AX

NEG AX

END_IF1:

XOR CX,CX
MOV BX,10D

REPEAT1:

XOR DX,DX
DIV BX
PUSH DX
INC CX
OR AX,AX

JNE REPEAT1
MOV AH,2

PRINT_LOOP:
POP DX
OR DL,30H
INT 21H
LOOP PRINT_LOOP
POP DX
POP CX
POP BX
POP AX
RET
OUTDEC ENDP
END MAIN