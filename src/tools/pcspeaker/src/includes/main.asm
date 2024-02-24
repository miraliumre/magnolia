DEFAULT_ATTR_TITLE equ 00001111b
DEFAULT_ATTR_TEXT  equ 00000111b

STR_TITLE          db 'PC Speaker Test', 0x00
STR_WAIT           db 'Press P to play or ESC to exit', 0x00
STR_PLAYING        db 'Playing... Press ESC to stop  ', 0x00

main:
    call clear_screen
    call hide_cursor
    
    xor dx, dx
    call set_cursor_position

    mov bl, DEFAULT_ATTR_TITLE
    mov si, STR_TITLE
    call print_a

    inc dh
    mov bl, DEFAULT_ATTR_TEXT

    .wait:
        call set_cursor_position

        mov si, STR_WAIT
        call print_a

        call read_key

        cmp ah, 0x19
        je .play                  ; Handle P press
        
        cmp ah, 0x01
        je .exit                  ; Handle ESC press         

        jmp .wait
    
    .play:
        call set_cursor_position

        mov si, STR_PLAYING
        call print_a

        mov si, tune
        call play_tune
        
        jmp .wait

    .exit:
        ret

%include 'includes/common.asm'
%include 'includes/frequencies.asm'
%include 'includes/tune.asm'