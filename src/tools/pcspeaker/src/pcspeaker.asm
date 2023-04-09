[BITS 16]
[ORG 0x100]

init:
  pushf
  pusha
  call main
  popa
  popf
  ret

%include 'includes/main.asm'