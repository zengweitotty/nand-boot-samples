led.bin : Start.s led.c
	arm-linux-gcc -nostdlib -c -o led.o led.c
	arm-linux-gcc -nostdlib -c -o Start.o Start.s
	arm-linux-ld -Tnand.lds  Start.o led.o -o led_elf
	arm-linux-objcopy -O binary -S led_elf led.bin
clean:
	rm -f *.o *.dis *_elf *.bin
