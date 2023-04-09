SCREEN_Y          equ 2
SCREEN_X          equ 2
SCREEN_HEIGHT     equ 10
SCREEN_WIDTH      equ 76

SCREEN_ATTR_TITLE equ DEFAULT_ATTR_TITLE

SCREEN_MAIN       db 'Welcome!', 0x00

                  db 'Explore the potential of games and tools '
                  db 'available directly through your', 0x0A
                  db `computer's BIOS.`, 0x0A, 0x0A
                  db 'Magnolia is open source software. We invite you '
                  db 'to join our growing', 0x0A
                  db 'community of contributors on GitHub, where you '
                  db 'can help us expand and ', 0x0A
                  db 'refine this project: '
                  db 'https://github.com/miraliumre/magnolia', 0x00

SCREEN_GAMES      db 'Games', 0x00

                  db 'Immerse yourself in pure gaming entertainement '
                  db 'directly within your BIOS!', 0x0A
                  db 'Experience the joy of lauching games without the '
                  db 'need for any operating', 0x0A
                  db 'system in between.', 0x00

SCREEN_TOOLS      db 'Tools', 0x00

                  db 'Discover an ever-expanding collection of '
                  db 'utilities designed to help you', 0x0A
                  db `delve deeper into your hardware's capabilities. `
                  db 'As Magnolia evolves, we ', 0x0A
                  db 'will introduce more tools to this section.', 0x00

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