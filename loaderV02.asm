[BITS 16]               ;Set code generation to 16 bit mode

org 0x2345		;set addressing to begin at 100H

push cs
pop ds

start:
  call dspmsg	;call routine to display message
 call dspmsg2

  call date
  call cvtmo
  call cvtday
  call cvtcent
  call cvtyear
  call dspdate
  
  call time
  call cvthrs
  call cvtmin
  call cvtsec
  call dsptime

jmp word 0x0000:0x7D30

  int 20h ;halt operation (VERY IMPORTANT!!!)



dspmsg: 
  mov ah,13h	;function 13h (Display String)
  mov al,0	;Write mode is zero
  mov bh,0	;Use video page of zero
  mov bl,7ch	;Attribute (bright white on bright blue)
  mov cx,8	;Character string is 25 long
  mov dh,5	;position on row 3
  mov dl,1	;and column 28
  push ds		;put ds register on stack
  pop es		;pop it into es register
lea bp, [msg]
  int 10H
  ret
 	
msg db '                                  '

dspmsg2:
;;logointeriortext

	mov al,1			;Write mode is zero: cursor stay after last char
	mov bh,0			;Use video page of zero
	mov cx,mlen2		;Character string length
	mov bl,53h
	mov dh,6			;Position on row 0
	mov dl,38			;And column 0
	lea bp,[msg2]		;Load the offset address of string into BP
	int 10h
;;cursor reset
	mov bh, 0
	mov dh,0			;Position on row 0
	mov dl,70			;And column 0
	mov ah, 2

	int 10h				;interrupt

	ret		

msg2 db 'DiamondOS'
mlen2 equ $-msg2

date:
;Get date from the system
mov ah,04h	 ;function 04h (get RTC date)
int 1Ah		;BIOS Interrupt 1Ah (Read Real Time Clock)
ret

;CH - Century
;CL - Year
;DH - Month
;DL - Day

cvtmo:
;Converts the system date from BCD to ASCII
mov bh,dh ;copy contents of month (dh) to bh
shr bh,1
shr bh,1
shr bh,1
shr bh,1
add bh,30h ;add 30h to convert to ascii
mov [dtfld],bh
mov bh,dh
and bh,0fh
add bh,30h
mov [dtfld + 1],bh
ret

cvtday:
mov bh,dl ;copy contents of day (dl) to bh
shr bh,1
shr bh,1
shr bh,1
shr bh,1
add bh,30h ;add 30h to convert to ascii
mov [dtfld + 3],bh
mov bh,dl
and bh,0fh
add bh,30h
mov [dtfld + 4],bh
ret

cvtcent:
mov bh,ch ;copy contents of century (ch) to bh
shr bh,1
shr bh,1
shr bh,1
shr bh,1
add bh,30h ;add 30h to convert to ascii
mov [dtfld + 6],bh
mov bh,ch
and bh,0fh
add bh,30h
mov [dtfld + 7],bh
ret

cvtyear:
mov bh,cl ;copy contents of year (cl) to bh
shr bh,1
shr bh,1
shr bh,1
shr bh,1
add bh,30h ;add 30h to convert to ascii
mov [dtfld + 8],bh
mov bh,cl
and bh,0fh
add bh,30h
mov [dtfld + 9],bh
ret

dtfld db '00/00/0000'

dspdate:
;Display the system date
mov ah,13h ;function 13h (Display String)
mov al,0 ;Write mode is zero
mov bh,0 ;Use video page of zero
mov bl,7ch ;Attribute
mov cx,10 ;Character string is 10 long
mov dh,5 ;position on row 4
mov dl,1 ;and column 28
push ds ;put ds register on stack
pop es ;pop it into es register
lea bp,[dtfld] ;load the offset address of string into BP
int 10H
ret

time:
;Get time from the system
mov ah,02h
int 1Ah
ret

;CH - Hours
;CL - Minutes
;DH - Seconds

cvthrs:
;Converts the system time from BCD to ASCII
mov bh,ch ;copy contents of hours (ch) to bh
shr bh,1
shr bh,1
shr bh,1
shr bh,1
add bh,30h ;add 30h to convert to ascii
mov [tmfld],bh
mov bh,ch
and bh,0fh
add bh,30h
mov [tmfld + 1],bh
ret

cvtmin:
mov bh,cl ;copy contents of minutes (cl) to bh
shr bh,1
shr bh,1
shr bh,1
shr bh,1
add bh,30h ;add 30h to convert to ascii
mov [tmfld + 3],bh
mov bh,cl
and bh,0fh
add bh,30h
mov [tmfld + 4],bh
ret

cvtsec:
mov bh,dh ;copy contents of seconds (dh) to bh
shr bh,1
shr bh,1
shr bh,1
shr bh,1
add bh,30h ;add 30h to convert to ascii
mov [tmfld + 6],bh
mov bh,dh
and bh,0fh
add bh,30h
mov [tmfld + 7],bh
ret

tmfld: db '00:00:00'

dsptime:
;Display the system time
mov ah,13h ;function 13h (Display String)
mov al,0 ;Write mode is zero
mov bh,0 ;Use video page of zero
mov bl,7ch ;Attribute
mov cx,8 ;Character string is 8 long
mov dh,6 ;position on row 5
mov dl,1 ;and column 28
push ds ;put ds register on stack
pop es ;pop it into es register
lea bp,[tmfld] ;load the offset address of string into BP
int 10H
ret

int 20H





