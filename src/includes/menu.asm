MENU_Y                    equ 13
MENU_X                    equ 1
MENU_HEIGHT               equ 10
MENU_WIDTH                equ 37

MENU_HELP_Y               equ 13
MENU_HELP_X               equ 39
MENU_HELP_HEIGHT          equ 10
MENU_HELP_WIDTH           equ 40

MENU_ATTR_HLGHT           equ DEFAULT_ATTR_HLGHT
MENU_ATTR_HELP_TITLE      equ DEFAULT_ATTR_TITLE
MENU_ATTR_TEXT            equ DEFAULT_ATTR_TEXT
MENU_ATTR_TITLE           equ DEFAULT_ATTR_TITLE

; ---------------------------------------------------------------------

MENU_MAIN                 db 3    ; Menu length (in items)

                          dw MENU_STR_GAMES
                          dw MENU_HELP_STR_GAMES
                          dw games

                          dw MENU_STR_TOOLS
                          dw MENU_HELP_STR_TOOLS
                          dw tools

                          dw MENU_STR_EXIT
                          dw MENU_HELP_STR_EXIT
                          dw 0

MENU_STR_GAMES            db 'Games ', 0xAF, 0x00
MENU_HELP_STR_GAMES       db 'Enter the Games menu to discover', 0x0A
                          db 'games that can run from Magnolia.', 0x00

MENU_STR_TOOLS            db 'Tools ', 0xAF, 0x00
MENU_HELP_STR_TOOLS       db 'The Tools menu contains utilities', 0x0A
                          db 'to help interact with and diagnose', 0x0A
                          db `your computer's hardware.`, 0x00

; ---------------------------------------------------------------------

MENU_GAMES                db 3    ; Menu length (in items)

                          dw MENU_STR_FLOPPYBIRD
                          dw MENU_HELP_STR_FLOPPYBIRD
                          dw load_floppybird

                          dw MENU_STR_PILLMAN
                          dw MENU_HELP_STR_PILLMAN
                          dw load_pillman

                          dw MENU_STR_BACK
                          dw MENU_HELP_STR_BACK
                          dw 0

MENU_STR_FLOPPYBIRD       db 'Floppy Bird', 0x00
MENU_HELP_STR_FLOPPYBIRD  db 'Play a clone of the infamous Flappy', 0x0A
                          db 'Bird game.', 0x00

MENU_STR_PILLMAN          db 'Pillman', 0x00
MENU_HELP_STR_PILLMAN     db 'Play a clone of PAC-MAN', 0x0A
                          db 'Classical game.', 0x00

; ---------------------------------------------------------------------

MENU_TOOLS                db 2    ; Menu length (in items)

                          dw MENU_STR_PCSPEAKER
                          dw MENU_HELP_STR_PCSPEAKER
                          dw load_pcspeaker

                          dw MENU_STR_BACK
                          dw MENU_HELP_STR_BACK
                          dw 0

MENU_STR_PCSPEAKER        db 'PC Speaker Test', 0x00
MENU_HELP_STR_PCSPEAKER   db 'Start a program that plays a simple', 0x0A
                          db 'une via the onboard PC Speaker.', 0x00

; ---------------------------------------------------------------------

MENU_STR_TITLE            db 'Menu', 0x00
MENU_HELP_STR_TITLE       db 'Help', 0x00

MENU_STR_BACK             db 'Back', 0x00
MENU_HELP_STR_BACK        db 'Go back to the previous menu.', 0x00

MENU_STR_EXIT             db 'Exit', 0x00
MENU_HELP_STR_EXIT        db 'Exit Magnolia and return to normal', 0x0A
                          db 'system operation.', 0x00

; ---------------------------------------------------------------------

menu_active               dw 0

%macro print_spaced 0
    mov al, 0x20
    call write_a
    call print_a
    call write_a
%endmacro

%macro use_menu 3
    mov si, %1
    call menu_input
    cmp ax, 0
    je %3
    call ax
    jmp %2
%endmacro

menu_draw:
    pusha
    
    prepare_area MENU_Y, MENU_X, MENU_HEIGHT, MENU_WIDTH

    xor ax, ax
    xor bx, bx
    xor cx, cx

    .title:
        mov di, si                ; Preserve SI for print operation
        
        mov bl, MENU_ATTR_TITLE
        mov si, MENU_STR_TITLE
        print_spaced
        
        add dh, 1
        call set_cursor_position  ; Advance cursor to the next line
    
        mov si, di                ; Restore SI

    .load:
        lodsb
        mov ch, al                ; Set CH to menu length

    .loop:
        mov al, [menu_active]     ; Store active menu item value in AL
        mov bl, MENU_ATTR_TEXT    ; Default item attribute

        cmp al, cl
        jne .print                ; If active item = current item
        mov bl, MENU_ATTR_HLGHT   ; (AL = CL), highlight item

        .print:
            mov di, si            ; Preserve SI

            mov ax, [si]
            mov si, ax
            print_spaced          ; Load item name address and print it

            add di, 6
            mov si, di            ; Set SI to next item

            inc cl
            cmp cl, ch            ; Update current item index
            je .break             ; Break if last item was reached

    .update_cursor:
        add dh, 1
        call set_cursor_position  ; Advance cursor to the next line
        jmp .loop

    .break:
        popa
        ret

menu_help_draw:
    pusha

    prepare_area \
        MENU_HELP_Y, MENU_HELP_X, MENU_HELP_HEIGHT, MENU_HELP_WIDTH

    .title:
        mov di, si                ; Preserve SI for print operation
        
        mov bl, MENU_ATTR_HELP_TITLE
        mov si, MENU_HELP_STR_TITLE
        call print_a
        
        add dh, 1
        call set_cursor_position  ; Advance cursor to the next line
    
        mov si, di                ; Restore SI

    .load:
        mov cx, dx                ; Preserve DX for multiplication

        add si, 3                 ; Point SI to help of first item

        mov ax, 6
        mov bx, [menu_active]
        mul bx
        add si, ax
        mov si, [si]              ; Load text address to SI

        mov dx, cx                ; Restore DX
        mov bl, MENU_ATTR_TEXT    ; Restore BX to default text attribute

    .loop:
        lodsb

        test al, al
        jz .break

        cmp al, 0x0A
        je .update_cursor

        call write_a

        jmp .loop

    .update_cursor:
        add dh, 1
        call set_cursor_position  ; Advance cursor to the next line
        jmp .loop

    .break:
        popa
        ret

menu_input:
    push bx
    push cx
    push dx
    push si

    xor cl, cl
    mov ch, [si]
    dec ch                        ; Set CH = (menu length - 1)
    mov [menu_active], cl         ; Set menu_active = 0 

    .draw:
        mov cl, [menu_active]
        call menu_draw
        call menu_help_draw
        
    .loop:
        mov ah, 0x00
        int 0x16                  ; Read keyboard input from user

        cmp ah, 0x48
        je .up                    ; Up arrow pressed

        cmp ah, 0x50
        je .down                  ; Down arrow pressed

        cmp ah, 0x1C
        je .enter                 ; Enter key pressed

        jmp .loop                 ; Ignore any other key

    .up:
        cmp cl, 0                 ; If active item is the first, do
        je .loop                  ; nothing
    
        dec cl
        mov [menu_active], cl     ; Update CL and menu_active

        jmp .draw                 ; Redraw menu

    .down:
        cmp ch, cl                ; If active item is the last, do
        je .loop                  ; nothing
    
        inc cl
        mov [menu_active], cl     ; Update CL and menu_active

        jmp .draw                 ; Redraw the menu

    .enter:
        add si, 5                 ; Point SI to subroutine of first item

        xor bx, bx
        mov bl, cl                ; Set BL to active menu item

        mov ax, 6                 ; Multiply BX by 6 to find position of
        mul bx                    ; subroutine in menu data structure

        add si, ax                ; Add result of mul to SI
        lodsw                     ; Load subroutine address to AX

        pop si
        pop dx
        pop cx
        pop bx
        ret                       ; Return subroutine address in AX
