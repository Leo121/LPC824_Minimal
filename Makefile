# Minimal gcc makefile for LPC824

# default Linux USB device name for upload
TTY ?= /dev/ttyUSB*

# use the arm cross compiler, not std gcc
TRGT = arm-none-eabi-
CC = $(TRGT)gcc
CXX = $(TRGT)g++
CP = $(TRGT)objcopy

# compiler and linker settings
CFLAGS = -mcpu=cortex-m0plus -mthumb -I../minimal -Os -ggdb
CXXFLAGS = $(CFLAGS) -fno-rtti -fno-exceptions
LDFLAGS = -Wl,--script=LPC824.ld -nostartfiles

# permit including this makefile from a sibling directory
vpath %.c ../minimal
vpath %.cpp ../minimal

# default target
upload: firmware.bin
	./lpc21isp/lpc21isp -control -donotstart -bin $< $(TTY) 115200 0

firmware.elf: main.o gcc_startup_lpc82x.o system_LPC82x.o
	$(CC) -o $@ $(CFLAGS) $(LDFLAGS) $^

%.bin: %.elf
	$(CP) -O binary $< $@

clean:
	rm -f *.o *.elf

# these target names don't represent real files
.PHONY: upload clean
