; Created by George at 22:43 11.05.2023 UTC+3 time
[org 0x7c00]			; Set programm start addres to 0x7c00
[cpu 8086]			; Set CPU config   
                    
KERNEL_LOCATION equ 0x1000	; Set kernel.bin location
BOOT_DISK: db 0   		; Set boot disk

MSG: 
	db 'KGB OS is loading...', 0xA, 0xD, 0
QUE: 
	db 'F1 - load kernel', 0xA, 0xD, 'F2 - off PC', 0xA, 0xD, '1-4 - topic change', 0
OFFMSG:
	db 'Computer shutting down...', 0xA, 0xD, 0                             


mov [BOOT_DISK], dl    		; Move to BOOT_DISK disk on which we started             

                                    
xor ax, ax			; AX = 0                          
mov es, ax			; ES = 0
mov ds, ax			; DS = 0
mov bp, 0x8000			; Set stack top
mov sp, bp			; Set stack

mov bx, KERNEL_LOCATION		; BX = 0x1000
mov dh, 2			; Settings to read disk

mov ah, 0x02
mov al, dh 
mov ch, 0x00
mov dh, 0x00
mov cl, 0x02
mov dl, [BOOT_DISK]
int 0x13                	; Use interrupt

                                    
mov ah, 0x0
mov al, 0x3
int 0x10                	; Text mode


CODE_SEG equ GDT_code - GDT_start
DATA_SEG equ GDT_data - GDT_start

jmp WAIT_KEY			; Jump to WAIT_KEY

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
;	call SLEEP		; Call SLEEP function
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
	cli			; Clear interrupts
	lgdt [GDT_descriptor]	; Need to switch to 32-bit mode
	mov eax, cr0
	or eax, 1
	mov cr0, eax
	jmp CODE_SEG:start_protected_mode

	jmp $
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
	ret

GDT_start:
    GDT_null:
        dd 0x0
        dd 0x0

    GDT_code:
        dw 0xffff
        dw 0x0
        db 0x0
        db 0b10011010
        db 0b11001111
        db 0x0

    GDT_data:
        dw 0xffff
        dw 0x0
        db 0x0
        db 0b10010010
        db 0b11001111
        db 0x0

GDT_end:

GDT_descriptor:
    dw GDT_end - GDT_start - 1
    dd GDT_start


[bits 32]
start_protected_mode:
    mov ax, DATA_SEG
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	
	mov ebp, 0x90000	; 32 bit stack base pointer
	mov esp, ebp

    jmp KERNEL_LOCATION

                                     
 
times 510-($-$$) db 0              
dw 0xaa55