[BITS 16]

%define ROM_SIZE_SECTORS (ROM_SIZE + 512) / 512

%include 'includes/header.asm'

MODULE_AREA_SIZE equ 10496 - $     ; Memory area for loading modules is
times MODULE_AREA_SIZE db 0xFF     ; at 0x100. Maximum 10 kB

%include 'autogen/embeds.asm'
%include 'autogen/metadata.asm'
%include 'autogen/pci.asm'

%include 'includes/common.asm'
%include 'includes/loader.asm'
%include 'includes/menu.asm'
%include 'includes/screen.asm'
%include 'includes/splash.asm'
%include 'includes/title.asm'

init:
    pushf
    pusha
    push ds
    push es
    mov ax, cs
    mov ds, ax
    mov es, ax
    cld
    call set_video_mode
    call splash
    pop es
    pop ds
    popa
    popf
    retf

main:
    mov si, SCREEN_MAIN
    call draw_screen
    use_menu MENU_MAIN, main, .exit
    .exit:
        call reboot

games:
    mov si, SCREEN_GAMES
    call draw_screen
    use_menu MENU_GAMES, games, .exit
    .exit:
        ret

tools:
    mov si, SCREEN_TOOLS
    call draw_screen
    use_menu MENU_TOOLS, tools, .exit
    .exit:
        ret

ROM_SIZE       equ $-$$
ROM_SIZE_ROUND equ ROM_SIZE_SECTORS * 512 - 1

times ROM_SIZE_ROUND-ROM_SIZE db 0