DEFAULT_ATTR_TEXT  equ 00000111b
DEFAULT_ATTR_TITLE equ 00001111b
DEFAULT_ATTR_HLGHT equ 01110000b

%macro prepare_area 4
    mov ch, %1
    mov cl, %2
    mov dh, %3
    mov dl, %4
    call clear_area
    mov dx, cx
%endmacro

clear_area:
;
; wipes the contents from an area of the screen
;
; INPUT:
;     CH = upper left row
;     CL = upper left column
;     DH = height of the area
;     DL = width of the area
;
; OUTPUT:
;     cursor position is set to the beginning of the cleared area
;
    pusha

    mov ax, cx
    add ax, dx
    mov dx, ax
    dec dh
    dec dl                        ; Load lower right row/column position

    mov ax, 0x0600                ; AH=06h, AL=00h - clear window
    mov bh, DEFAULT_ATTR_TEXT     ; Use default attribute for text
    int 0x10                      ; Call BIOS interrupt

    mov dx, cx                    ; Set the cursor position to the
    call set_cursor_position      ; beginning of the cleared area

    popa
    ret

hide_cursor:
;
; hides the cursor
;
    push ax
    push cx
    mov ah, 0x01
    mov ch, 0x01
    int 0x10
    pop cx
    pop ax
    ret

print_a:
;
; writes a string with an attribute to the screen
;
; INPUT:
;     BL = attribute
;     SI = string *
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

print_al:
;
; writes a string with an attribute to the screen, but stop at the
; defined length instead of at a null byte
;
; INPUT:
;     BL = attribute
;     CX = length
;     SI = string *
;
    push bx
    push cx
    xor bh, bh

    .loop:
        test cx, cx
        jz .break
        lodsb
        push cx
        call write_a
        pop cx
        sub cx, 1
        jmp .loop
    
    .break:
        pop cx
        pop bx
        ret

set_cursor_position:
;
; sets the position of the cursor in the screen
;
; INPUT:
;     DH = row
;     DL = column
;
    push ax
    push bx

    mov ah, 0x02
    xor bx, bx
    int 0x10

    pop bx
    pop ax

    ret

set_video_mode:
;
; sets video mode (80x25 text mode with 16 colors)
;
    push ax
    mov ax, 0x0003
    int 0x10
    pop ax
    ret

show_cursor:
;
; unhides the cursor
;
    push ax
    push cx
    mov ah, 0x01
    mov ch, 0x07
    int 0x10
    pop cx
    pop ax
    ret

write_a:
;
; writes a single character with an attribute to the screen
;
; INPUT:
;     AL = character
;     BL = attribute
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