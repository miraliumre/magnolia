str_title       db 'PC Speaker Test', 0x00
str_wait        db 'Press P to play or ESC to exit', 0x00
str_playing     db 'Playing... Press ESC to stop  ', 0x00

main:
    call clear_screen
    call hide_cursor
    
    xor dx, dx
    call set_cursor_position

    mov bl, 00001111b
    mov si, str_title
    call print_a

    inc dh
    mov bl, 00000111b

    .wait:
        call set_cursor_position

        mov si, str_wait
        call print_a

        call read_key

        cmp ah, 0x19
        je .play                  ; Handle P press
        
        cmp ah, 0x01
        je .exit                  ; Handle ESC press         

        jmp .wait
    
    .play:
        call set_cursor_position

        mov si, str_playing
        call print_a

        mov si, tune
        call play_tune
        
        jmp .wait

    .exit:
        ret

%include 'includes/common.asm'
%include 'includes/frequencies.asm'
%include 'includes/tune.asm'