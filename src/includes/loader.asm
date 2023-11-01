MODULE_AREA_LOC equ 0x100

%macro load_module 2
    mov cx, %1
    mov si, %2
    mov di, MODULE_AREA_LOC
    rep movsb                     ; Load module to MODULE_AREA_LOC
    call MODULE_AREA_LOC          ; Call the module
%endmacro

%macro  restore_view 0
    call hide_cursor

    push cx
    push dx

    xor cx, cx
    mov dx, 0x184F
    call clear_area                ; Clear entire screen

    pop dx
    pop cx

    call title_draw
%endmacro

load_floppybird:
    load_module EMB_FLOPPYBIRD_SIZE, EMB_FLOPPYBIRD
    call set_video_mode
    restore_view
    ret

load_pillman:
    load_module EMB_PILLMAN_SIZE, EMB_PILLMAN
    call set_video_mode
    restore_view
    ret

load_pcspeaker:
    load_module EMB_PCSPEAKER_SIZE, EMB_PCSPEAKER
    restore_view
    ret
