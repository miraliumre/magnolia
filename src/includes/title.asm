title_draw:
    pusha
    
    mov si, TITLE_DATA

    lodsb
    mov bl, al                    ; Load attribute from TITLE_DATA

    mov ax, 0x0920
    mov cx, 80
    int 0x10                      ; Fill title bar background

    xor cx, cx
    xor dx, dx

    lodsb
    mov cl, al                    ; Load title length to CL

    mov al, 80
    sub al, cl
    shr al, 1
    mov dl, al                    ; Set DL = required leading length
    call set_cursor_position      ; to use with set_cursor_position
    
    call print_al                 ; SI already points to string here
    
    popa
    ret