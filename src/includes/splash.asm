SPLASH_STR_TEXT     db 'Press M to enter Magnolia', 0x00
SPLASH_STR_PROGRESS db '.', 0x00

splash:
    mov bl, DEFAULT_ATTR_TEXT
    mov si, SPLASH_STR_TEXT
    call print_a

    xor cx, cx
    mov cl, 4                     ; Loop 4 times

    .loop:
        call read_keyboard_buffer ; Get status of the keyboard buffer
        jnz .key_event            ; and handle if user has pressed a key

        push cx
        xor cx, cx
        mov cl, 0x07
        mov dx, 0xA120
        call sleep
        pop cx

        mov si, SPLASH_STR_PROGRESS
        call print_a

        loop .loop

    .exit:
        xor cx, cx
        mov dx, 0x184F
        call clear_area           ; Clear the entire screen
        ret

    .key_event:
        call read_key
        cmp ah, 0x32
        jne .loop                 ; If key != M, go back to the loop

    .load_main:
        restore_view
        call main