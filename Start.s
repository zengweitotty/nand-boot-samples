@***********************************
@File: Start.s
@Description: initialize SDRAM and boot from Nand Flash
@***********************************

.equ MEM_CTL_BASE, 0x48000000
@BANK 6 and using ADDR24&ADDR25 pin
.equ SDRAM_BASE,   0x30000000 
.text
.global _start
_start:
	bl watchdog_disable
	bl memctl_setup
	bl copyNandflash2SDRAM
	ldr pc,=on_sdram
on_sdram:
	mov sp,#0x34000000 @SDRAM area is 0x30000000--0x33FFFFFF 64M
@mov sp,#4096 @SDRAM area is 0x30000000--0x33FFFFFF 64M
	bl main
halt_loop:
	b halt_loop
watchdog_disable:
    mov r1,#0x53000000
	mov r2,#0x0
	str r2,[r1]
	mov pc,lr

copyNandflash2SDRAM:
	mov r1,#0x00000000
	ldr	r2,=SDRAM_BASE
	mov r3,#4096 @4K Boot internal SRAM
loop1:
	ldr r4,[r1],#4
	str r4,[r2],#4
	cmp r1,r3
	bne loop1
	mov pc,lr

memctl_setup:
	mov r1,#MEM_CTL_BASE
	adrl r2,mem_cfg_val
	add r3,r1,#52
loop2:
	ldr r4,[r2],#4
	str r4,[r1],#4
	cmp r3,r1
	bne loop2
    mov pc,lr	
.align 4
mem_cfg_val:
	.long 0x22011110 @BWSCON
	.long 0x00000700 @BANKCON0
	.long 0x00000700 @BANKCON1
	.long 0x00000700 @BANKCON2
	.long 0x00001F4C @BANKCON3
	.long 0x00000700 @BANKCON4
	.long 0x00000700 @BANKCON5
	.long 0x00018005 @BANKCON6 with SDRAM
	.long 0x00018005 @BANKCON7 with SDRAM
	.long 0x008E04F4 @REFRESH
	.long 0x00000032 @BANKSIZE
	.long 0x00000030 @MRSRB6
	.long 0x00000030 @MRSRB7

