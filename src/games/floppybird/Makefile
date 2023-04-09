# This file has been heavily modified for usage in the Magnolia project.
# It has not been approved by the original author.

NASM							= nasm
NAME							= floppybird
MAGNOLIA_FILENAME				= $(NAME).bin
MAGNOLIA_TARGET					= bin/$(MAGNOLIA_FILENAME)

COM								= src/com.asm

KERNEL							= src/sys/rnd.asm \
								src/sys/snd.asm \
								src/sys/tmr.asm \
								src/sys/txt.asm \
								src/sys/vga.asm

GAME							= src/main.asm	\
								src/game/background.asm \
								src/game/bird.asm \
								src/game/bushes.asm \
								src/game/clouds.asm \
								src/game/data.asm \
								src/game/flats.asm \
								src/game/ground.asm \
								src/game/pipes.asm \
								src/game/score.asm

all: clean $(MAGNOLIA_TARGET)

$(MAGNOLIA_TARGET):
	$(NASM) -isrc/ -f bin -o $(MAGNOLIA_TARGET) $(COM)

clean:
	rm -f $(MAGNOLIA_TARGET)