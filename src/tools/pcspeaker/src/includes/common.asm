clear_screen:
;
; wipes all the contents shown on screen
;
    pusha

    mov ax, 0x0600
    mov bh, 00000111b
    xor cx, cx
    mov dl, 79
    mov dh, 24
    int 0x10
    
    popa
    ret

play_note:
;
; INPUT:
;     AX    = frequency
;     CX:DX = microsseconds
;
    pusha
    pushf

    mov bx, ax

    mov al, 0xB6
    out 0x43, al                  ; Set up PIT

    mov ax, bx

    out 0x42, al
    mov al, ah
    out 0x42, al                  ; Set note frequency

    in al, 0x61
    or al, 0x03
    out 0x61, al                  ; Enable speaker

    mov ah, 0x86
    int 0x15                      ; Wait

    in al, 0x61
    and al, 0x0FC
    out 0x61, al                  ; Disable speaker

    popf
    popa
    ret

play_tune:
; 
; INPUT:
;     SI = tune data
;
    pusha
    push si
    xor dx, dx                    ; We use only CX for duration data

    .loop:
        mov ah, 0x01
        int 0x16                  ; Get status of the keyboard buffer
        jnz .key_event            ; and handle if user has pressed a key

        lodsw
        mov bx, ax                ; Load note to BX

        cmp bx, nEND
        je .break                 ; If note = nEND, stop
        
        lodsw
        mov cx, ax                ; Load duration to CX

        lodsw
        mov dx, ax                ; Load duration to DX

        cmp bx, nBRK
        je .wait                  ; If note = nBRK, wait in silence

        mov ax, bx
        call play_note

        jmp .loop

    .wait:
        mov ah, 0x86
        int 0x15
        jmp .loop

    .key_event:
        call read_key
        
        cmp ah, 0x01
        je .break

        jmp .loop

    .break:
        pop si
        popa
        ret

write_a:
;
; writes a single character with an attribute to the screen
;
; INPUT:
;     AL = character
;     BL = attribute
;
;
    pusha

    .get_cursor:
        mov ah, 0x03
        int 0x10
        push dx

    .write_char:
        mov ah, 0x09
        mov cx, 1
        int 0x10

    .set_cursor:
        pop cx
        add cx, 1
        mov dx, cx
        mov ah, 0x02
        int 0x10

    popa
    ret

print_a:
;
; writes a string with an attribute to the screen
;
; INPUT:
;     BL = attribute
;     SI = string *
;
;
    push ax
    push bx
    push si
    xor bh, bh

    .loop:
        lodsb
        test al, al
        jz .break
        call write_a
        jmp .loop

    .break:
        pop si
        pop bx
        pop ax
        ret

set_cursor_position:
;
; sets the position of the cursor in the screen
;
; INPUT:
;     DH = row
;     DL = column
;
;
    push ax
    push bx

    mov ah, 0x02
    xor bx, bx
    int 0x10

    pop bx
    pop ax

    ret

hide_cursor:
;
; sets the position of the cursor in the screen
;
; INPUT:
;     DH = row
;     DL = column
;
;
    push ax
    push cx

    mov ah, 0x01
    mov ch, 0x01
    int 0x10

    pop cx
    pop ax
    ret

read_key:
;
; reads a key press
;
; OUTPUT:
;     AH = key scan code
;     AL = ascii character
;
;
    mov ah, 0x00
    int 0x16
    ret