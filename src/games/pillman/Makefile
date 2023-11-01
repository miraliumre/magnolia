NASM					= nasm
NAME					= pillman

MODULE					= src/$(NAME).asm

MAGNOLIA_FILENAME		= $(NAME).bin
MAGNOLIA_TARGET			= bin/$(MAGNOLIA_FILENAME)

all: clean $(MAGNOLIA_TARGET)

$(MAGNOLIA_TARGET):
	$(NASM) -f bin -Dcom_file=1 -o $(MAGNOLIA_TARGET) $(MODULE)

clean:
	rm -rf $(MAGNOLIA_TARGET)
	rm -rf $(BOOT_TARGET)
