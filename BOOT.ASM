; Created by George at 19:47 13.07.2023 UTC+3 time
[org 0x7c00]			; Set programm start addres to 0x7c00
[cpu 8086]			; Set CPU config
[bits 16]			; Set program mode

MOV [BOOT_DISK], DL		; MOV to BOOT_DISK number of boot disk

; Stack settings
XOR AX, AX   			; AX = 0                       
MOV ES, AX			; ES = 0
MOV DS, AX			; DS = 0
MOV BP, 0x8000			; BP = 0x8000
MOV SP, BP			; SP = 0x8000

; Set screen settings
mov ax, 03	 		; Clear display
int 0x10			; Use interrupt

mov ah, 0x06    		; Scroll up function
xor al, al     			; Clear entire screen
xor cx, cx     			; Upper left corner CH=row, CL=column
mov dx, 0x184f 			; Lower right corner DH=row, DL=column 
mov bh, 0x1B    		; Light-blue On Blue
int 0x10			; Use interrupt

jmp MESSAGES			; Jump to WAIT_KEY

WAIT_KEY:
    	in al, 0x60		; Use interrupt

   	cmp al, 0x3B        	; Check if F1 was pressed
   	je BOOT			; If so then jump to boot sustem

	cmp al, 0x3C		; Check if F2 was pressed
	je OFF			; If so then jump to off pc

	cmp al, 0x02		; Check if 1 was pressed
	je WHITEBLUE		; If so then jump to White on blue

	cmp al, 0x03		; Check if 2 was pressed
	je YELLOWBLUE		; If so then jump to Yellow on blue

	cmp al, 0x04		; Check if 3 was pressed
	je WHITERED		; If so then jump to White on red

	cmp al, 0x05		; Check if 4 was pressed
	je BLUEBLUE		; If so then jump to Light-blue on blue

   	jmp WAIT_KEY    	; Otherwise go back to WAIT_KEY label
PRINT:
	mov ah, 0x0e		; Set AH to print text
    	mov al, [si]		; Load to AL character in SI
    	cmp al, 0		; if AL == 0 then jump to BREAK
    	je BREAK		; Jump to BREAK
    	int 0x10		; Interrupt

    	inc si			; SI = SI + 1

    	jmp PRINT		; Jump to PRINT
MESSAGES:
    	MOV SI, MSG		; MOV to SI MSG adress
	CALL PRINT		; CALL PRINT function
	
	CALL SLEEP		; CALL SLEEP function

	MOV SI, QUE		; MOV to SI QUE adress
	CALL PRINT		; CALL PRINT function

	JMP WAIT_KEY		; Jump to WAIT_KEY
SLEEP:
	mov ah, 0x86		; Function to sleep
	MOV AL, 0		; To correct work
    	mov cx, 0x1E		; Microseconds time
    	mov dx, 0x8480		; Microseconds time
    	int 0x15		; Use interrupt

    	ret			; Return
BOOT:
	; Reading the disk
	mov bx, 0x7e00
	mov ah, 2
	mov al, 1
	mov ch, 0
	mov dh, 0
	mov cl, 2
	mov dl, [BOOT_DISK]
	int 0x13
	
	MOV AH, 0x0E
	MOV AL, [0x7E00]
	INT 0x10
.wait:
	in al, 0x60          	; Get keyboard input

   	cmp al, 0xBB         	; Check if the user realises the F2 key
   	je WAIT_KEY             ; If so then jump to loop

	JMP .wait		; Else jump to .wait
OFF:
	mov si, OFFMSG		; Set si to OFFMSG addres
	call PRINT		; Jump to PRINT

	call SLEEP		; Jump to SLEEP

	mov ax, 0x5307 		; Power management
    	mov bx, 0x0001 		; Power management of all devices
    	mov cx, 0x0003 		; Off
    	int 0x15		; Use interrupt

WHITEBLUE:
	mov ax, 03	 	; Clear display
	int 0x10		; Use interrupt

	mov ah, 0x06    	; Scroll up function
	xor al, al     		; Clear entire screen
	xor cx, cx     		; Upper left corner CH=row, CL=column
	mov dx, 0x184f 		; Lower right corner DH=row, DL=column 
	mov bh, 0x1f    	; White on blue
	int 0x10		; Use interrupt

	jmp MESSAGES		; Return
YELLOWBLUE:
	mov ax, 03	 	; Clear display
	int 0x10		; Use interrupt

	mov ah, 0x06    	; Scroll up function
	xor al, al     		; Clear entire screen
	xor cx, cx     		; Upper left corner CH=row, CL=column
	mov dx, 0x184f 		; Lower right corner DH=row, DL=column 
	mov bh, 0x1e    	; Yellow on blue
	int 0x10		; Use interrupt

	jmp MESSAGES		; Return
WHITERED:
	mov ax, 03	 	; Clear display
	int 0x10		; Use interrupt

	mov ah, 0x06    	; Scroll up function
	xor al, al     		; Clear entire screen
	xor cx, cx     		; Upper left corner CH=row, CL=column
	mov dx, 0x184f 		; Lower right corner DH=row, DL=column 
	mov bh, 0x4f    	; White on red
	int 0x10		; Use interrupt

	jmp MESSAGES		; Return
BLUEBLUE:
	mov ax, 03	 	; Clear display
	int 0x10		; Use interrupt

	mov ah, 0x06    	; Scroll up function
	xor al, al     		; Clear entire screen
	xor cx, cx     		; Upper left corner CH=row, CL=column
	mov dx, 0x184f 		; Lower right corner DH=row, DL=column 
	mov bh, 0x1B    	; Light-blue on blue
	int 0x10		; Use interrupt

	jmp MESSAGES		; Return
BREAK:
	ret			; Return

MSG: 
	db 'KGB OS is loading...', 0xA, 0xD, 0
QUE: 
	db 'Press F1 to load kernel or F2 to off PC!', 0xA, 0xD, 0
OFFMSG:
	db 'Computer shutting down...', 0xA, 0xD, 0
BOOT_DISK:
	db 0
TIMES 510-($-$$) db 0		; Fill butes to zeroes to 510 byte
dw 0xAA55			; Set 511 and 512 bytes
TIMES 512 db 'A'		; 0x41
