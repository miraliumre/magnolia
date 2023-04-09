NASM					= nasm
NAME					= pcspeaker

MODULE					= src/$(NAME).asm

MAGNOLIA_FILENAME		= $(NAME).bin
MAGNOLIA_TARGET			= bin/$(MAGNOLIA_FILENAME)

all: clean $(MAGNOLIA_TARGET)

$(MAGNOLIA_TARGET):
	$(NASM) -isrc/ -f bin -o $(MAGNOLIA_TARGET) $(MODULE)

clean:
	rm -rf $(MAGNOLIA_TARGET)
	rm -rf $(BOOT_TARGET)