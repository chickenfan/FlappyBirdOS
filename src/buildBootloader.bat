gcc -c bootloader.s -o bootloader.o
objcopy -j .text -O binary bootloader.o bootloader.bin
