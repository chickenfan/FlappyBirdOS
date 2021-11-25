gcc -c bootloader.s -o bootloader.o
objcopy -O binary bootloader.o bootloader.bin
