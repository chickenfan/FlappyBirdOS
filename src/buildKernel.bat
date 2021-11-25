gcc -c main.s -o kernel.o
objcopy -O binary kernel.o kernel.bin
