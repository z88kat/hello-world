#
# make all
#

#
# Configure your CC65 location
#

CC65=/Users/kate/Applications/cc65
CC65_BIN=$(CC65)/bin
CC65_INC=$(CC65)/include
CC65_TARGET=$(CC65)/target
CC65_ASMINC=$(CC65)/asminc
CC65_TOOLS=$(CC65)/wbin


BUILDDIR=$(MAKEDIR)/$(BUILD)
ODIR=$(MAKEDIR)/obj
.SUFFIXES : .c .s .o .asm .bmp .pal .spr
.SOURCE : 

# Compiling for Atari Lynx system
SYS=lynx

# Names of tools
CO=co65
CC=cc65
AS=ca65
AR=ar65
CL=cl65
SPRPCK=sprpck
CP=cp
RM=rm
ECHO=echo
TOUCH=touch

CODE_SEGMENT=CODE
DATA_SEGMENT=DATA
RODATA_SEGMENT=RODATA
BSS_SEGMENT=BSS

SEGMENTS=--code-name $(CODE_SEGMENT) --rodata-name $(RODATA_SEGMENT) --bss-name $(BSS_SEGMENT) --data-name $(DATA_SEGMENT)

# Flag for assembler
AFLAGS=

# Flags for C-code compiler
CFLAGS=-I . -t $(SYS) --add-source -O -Or -Cl -Os

# Rule for making a *.o file out of a *.s file
.s.o:
	$(AS) -t $(SYS) -I $(CC65_ASMINC) -o $@ $(AFLAGS) $<

# Rule for making a *.o file out of a *.c file
.c.o:
	$(CC) $(SEGMENTS) $(CFLAGS) $<
	$(AS) -o $@ $(AFLAGS) $(*).s

lynx-stdjoy.o:
	$(CP) $(CC65_TARGET)/lynx/drv/joy/$*.joy .
	$(CO) --code-label _lynxjoy $*.joy
	$(AS) -t lynx -o $@ $(AFLAGS) $*.s
	$(RM) $*.joy
	$(RM) $*.s

lynx-160-102-16.o:
	$(CP) $(CC65_TARGET)/lynx/drv/tgi/$*.tgi .
	$(CO) --code-label _lynxtgi $*.tgi
	$(AS) -t lynx -o $@ $(AFLAGS) $*.s
	$(RM) $*.tgi
	$(RM) $*.s

# Rule for making a *.o file out of a *.bmp file
.bmp.o:
	$(SPRPCK) -v -t6 -p2 $<
	$(ECHO) .global _$(*B) > $*.s
	$(ECHO) .segment '"$(RODATA_SEGMENT)"' >> $*.s
	$(ECHO) _$(*B): .incbin '"$*.spr"' >> $*.s
	$(AS) -t lynx -o $@ $(AFLAGS) $*.s
	$(RM) $*.s
	$(RM) $*.pal
	$(RM) $*.spr

#
# OUTPUT HERE
#
target = hello.lnx

#
# CHANGE THE NAME HERE
#
objects = lynx-160-102-16.o lynx-stdjoy.o hello.o

$(target) : $(objects)
	$(CL) -t $(SYS) -o $@ $(objects) lynx.lib
#	$(CP) $@ ./$(BUILD)/$@

all: $(target)

clean:
	$(RM) -f *.tgi
	$(RM) -f *.s
	$(RM) -f *.joy
	$(RM) -f *.o
	$(RM) -f *.lnx