;
; Option ROM header
;
dw 0xAA55
db ROM_SIZE_SECTORS
jmp init

;
; PCI Expansion ROM header
;
; As defined on the PCI Local Bus Specification
; See https://www.ics.uci.edu/~harris/ics216/pci/PCI_22.pdf
;
PCI_PADDING_SIZE equ 24 - $
times PCI_PADDING_SIZE db 0x00

dw pci_data_structure             ; Pointer to PCI Data Structure

pci_data_structure:
    db 'PCIR'                     ; Signature
    dw PCI_VENDOR_ID              ; Vendor ID
    dw PCI_DEVICE_ID              ; Device ID
    dw 0                          ; Reserved
    dw 24                         ; PCI Data Structure length
    db 0                          ; PCI Data Structure revision
    db PCI_CLASS                  ; Class code
    db PCI_SUBCLASS               ; Class code
    db PCI_INTERFACE              ; Class code
    dw ROM_SIZE_SECTORS           ; ROM length in sectors
    dw 0                          ; Code/data revision level
    db 0                          ; Code type (0 = x86/PC-AT compatible)
    db 10000000b                  ; Indicator (bit 7 = last image)
    dw 0                          ; Reserved