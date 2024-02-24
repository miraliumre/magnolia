SCREEN_Y          equ 2
SCREEN_X          equ 2
SCREEN_HEIGHT     equ 10
SCREEN_WIDTH      equ 76

SCREEN_ATTR_TITLE equ DEFAULT_ATTR_TITLE

SCREEN_MAIN       db 'Welcome!', 0x00
                  db 'Magnolia is an open source platform that brings ',
                  db 'applications directly to', 0x0A,
                  db `your PC's BIOS! Visit our repository on GitHub:`,
                  db 0x0A, 'https://github.com/miraliumre/magnolia',
                  db 0x00

SCREEN_GAMES      db 'Games', 0x00
                  db 'This menu provides access to a selection of ',
                  db 'simple yet engaging games which ', 0x0A,
                  db 'can run directly from Magnolia.', 0x00

SCREEN_TOOLS      db 'Tools', 0x00,
                  db 'This menu offers utility applications designed ',
                  db 'to assist with system-level ', 0x0A,
                  db 'tasks related to programming, reverse ',
                  db 'engineering, and hardware diagnostics.', 0x00

draw_screen:
    pusha
    
    prepare_area SCREEN_Y, SCREEN_X, SCREEN_HEIGHT, SCREEN_WIDTH

    xor bh, bh
    mov bl, SCREEN_ATTR_TITLE

    .title_loop:
        lodsb
        test al, al
        jz .update_cursor
        call write_a
        jmp .title_loop

    .update_cursor:
        add dh, 1
        call set_cursor_position

    .text_loop:
        lodsb
        test al, al
        jz .break
        cmp al, 0x0A
        je .update_cursor
        mov ah, 0x0E
        xor bh, bh
        int 0x10
        jmp .text_loop

    .break:
        popa
        ret