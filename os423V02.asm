	;bit16					; 16bit by default
	org 0x7c00
	jmp short start
	nop

start:
	
;;clearscreen			WIPES THE SCREEN CLEAN
	mov ah,06h		
	mov al,0		
	mov bh,7ch		;color profile 
	mov ch,0			;zeros the available spaces
	mov cl,0		
	mov dh,24		
	mov dl,79		
	int 10h				;interrupt

;;printHello			PRINTS THE WELCOME MESSAGE
	mov ah,13h		;Function 13h (display string)
	mov al,1			;Write mode is zero: cursor stay after last char
	mov bh,0			;Use video page of zero
	mov bl,7eh		;Attribute (lightgreen on black)
	mov cx,mlen		;Character string length
	mov dh,0			;Position on row 0
	mov dl,0			;And column 0
	lea bp,[msg]		;Load the offset address of string into BP
	int 10h				;interrupt


;;printlogo below



;;logoborder		
	mov al, 205		;ascii 'double line'
	mov dl, 35			;sets col to 35

printtop:				;Loop for top portion of border
	mov ah, 2			;set cursor location
	mov bh, 0			;page=0
	mov bl,7fh			;color preset
	mov dh, 4			;row, 0..24
	int 10h				;interrupt

	mov ah, 09h		;write a char and attribute
	mov bh, 0			;page=0		
	mov cx, 1			;repetitions 
	int 10h				;interrupt

	inc dl				;increment col 
	cmp dl, 50			;compares col to 50
	jne printtop
	int 10h				;interrupt

	mov dl, 35			;resets col

printbot:				;Loop for bottom portion of border
	mov ah, 2			;set cursor location
	mov bh, 0			;page=0
	mov dh, 8			;row, 0..24
	int 10h				;interrupt

	mov ah, 09h		;write a char and attribute
	mov bh, 0			;page=0		
	mov cx, 1			;repetitions 
	int 10h				;interrupt

	inc dl				;increment col 
	cmp dl, 50			;compares col to 50
	jne printbot		
	int 10h				;interrupt

;;initialize

	lea si, [left]		;sets leftside array
	mov dh, 4			;row, 0..24

printleft:
	mov al, [si]		;assigns array
	mov ah, 2			;set cursor location
	mov bh, 0			;page=0
	mov dl, 34			;col set to 34
	int 10h				;interrupt

	mov ah, 09h		;write a char and attribute
	mov bh, 0			;page=0		
	mov cx, 1			;repetitions 
	int 10h				;interrupt

	inc si				;increment the array
	inc dh				;increment row 
	cmp dh, 9			;compare row to 9
	jne printleft
	int 10				;interrupt

;;initialize

	lea si, [right]	
	mov dh, 4			;row set to 4

printright:
	mov al, [si]		;assigns array
	mov ah, 2			;set cursor location
	mov bh, 0			;page=0
	mov dl, 50			;col set to 50
	int 10h				;interrupt

	mov ah, 09h		;write a char and attribute
	mov bh, 0			;page=0		
	mov cx, 1			;repetitions 
	int 10h				;interrupt

	inc si				;increments the array
	inc dh				;increment row 
	cmp dh, 9			;compares row to 9
	jne printright
	int 10				;interrupt

;;diamondlogo		;diamond logo code

;;initialize				
	lea si, [ditop]		;assigns ditop to si		
	mov dl, 24			;col set to 24

printditop:
	mov al, [si]		;sets array
	mov ah, 2			;set cursor location
	mov bh, 0			;page=0
	mov bl, 79h		;white on black
	mov dh, 5			;row, 0..24
	int 10h				;interrupt

	mov ah, 09h		;write a char and attribute
	mov bh, 0			;page=0		
	mov cx, 1			;repetitions 
	int 10h				;interrupt
	inc si				;increments array
	inc dl				;increment col 
	cmp dl, 31			;compares col to 31
	jne printditop
	int 10h				;interrupt

;;initialize
	mov dl, 24			;col 24

printdimid:
	mov al, [si]		;set array
	mov ah, 2			;set cursor location
	mov bh, 0			;page=0
	mov dh, 6			;row, 0..24
	int 10h

	mov ah, 09h		;write a char and attribute
	mov bh, 0			;page=0		
	mov cx, 1			;repetitions 
	int 10h				;interrupt
	inc si				;increments array
	inc dl				;increment col 
	cmp dl, 30			;compares col to 30, 1 less because no *
	jne printdimid
	int 10h				;interrupt

;;initialize
	mov dl, 26			;col 0

printdibot:
	mov al, [si]		;sets array
	mov ah, 2			;set cursor location
	mov bh, 0			;page=0
	mov dh, 7			;row, 0..24
	int 10h				;interrupt

	mov ah, 09h		;write a char and attribute
	mov bh, 0			;page=0		
	mov cx, 1			;repetitions 
	int 10h				;interrupt
	inc si				;increments array
	inc dl				;increment col 
	cmp dl, 28			;compares col to 28
	jne printdibot

;;cursor reset
	mov bh, 0
	mov dh,0			;Position on row 0
	mov dl,70			;And column 0
	mov ah, 2

	int 10h				;interrupt

;; Print date and time

	mov bx, 0x0001            ;s:bx input buffer, temporary set 0x0000:1234
   	 mov es, bx
  	  mov bx, 0x2345
   	 mov ah, 02h                ;Function 02h (read sector)
    	mov al, 1                ;Read one sector
    	mov ch, 1                ;Cylinder#
    	mov cl, 2               ;Sector# --> 2 has program
    	mov dh, 0                ;Head# --> logical sector 1
    	mov dl, 0                ;Drive# A, 08h=C
    	int 13h

   	jmp word 0x0001:0x2345   ;Run program on sector 1, ex:bx

	push cs
	pop ds
	
;;keyboardinput
	mov ah,0
	int 16h 

;;clearscreen
	mov ah,06h		;Function 06h (scroll screen)
	mov al,0			;Scroll all lines
	mov bh,0ah		;Attribute (lightgreen on black) 
	mov ch,0			;Upper left row is zero
	mov cl,0			;Upper left column is zero
	mov dh,24			;Lower left row is 24
	mov dl,79			;Lower left column is 79
	int 10h				;interrupt


;;load the text file

	mov bx, 0x0000			;es:bx input buffer, temporary set 0x0000:1234
	mov es, bx
	mov bx, 0x1234
	mov ah, 02h				;Function 02h (read sector)
	mov al, 1				;Read one sector
	mov ch, 1				;Cylinder#
	mov cl, 4				;Sector# --> 2 has program
	mov dh, 0				;Head# --> logical sector 1
	mov dl, 0				;Drive# A, 08h=C
	int 13h

;;print the text file

	mov ah,13h		;Function 13h (display string), XT machine only
	mov al,1		;Write mode is zero: cursor stay after last char
	mov bh,0		;Use video page of zero
	mov bl,0ah		;Attribute (lightgreen on black)
	mov cx, 110		;Character string length
	mov dh,0		;Position on row 0
	mov dl,0		;And column 0
	mov bp, 0x1234	;Load the offset address of string into BP, es:bp
					;Same as mov bp, msg  
	int 10h

;;print$
	mov ah,13h		;Function 13h (display string)
	mov al,1			;Write mode is zero: cursor stay after last char
	mov bh,0			;Use video page of zero
	mov bl,0ah		;Attribute (lightgreen on black)
	mov cx,mlen2		;Character string length
	mov dh,2			;Position on row 0
	mov dl,0			;And column 0
	lea bp,[msg2]		;Load the offset address of string into BP
	int 10h				;interrupt


;;end
	int 20h
	
msg db 'DiamondOS, Jad El-Khatib, Version 0.1 (c) Press any key to continue...'
mlen equ $-msg

msg2 db '$'
mlen2 equ $-msg2

left	db 201,186,186,186,200
right	db	187,186,186,186,188
ditop 	db	47,205,205,205,205,92,42,92,32,45,45,32,47,92,47
dibot	db	92,205,47


padding	times 510-($-$$) db 0		;to make MBR 512 bytes
bootSig	db 0x55, 0xaa		;signature 

