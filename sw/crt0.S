.attribute arch, "rv32ic_zicsr_zmmul"

.section .boot,"ax"

.global _start


_start:

    li sp,0x40000
    la t0,_sbss
    la t1,_ebss


clear_bss:

    beq t0,t1,bss_done

    sw zero,0(t0)

    addi t0,t0,4

    j clear_bss


bss_done:
    jal ra, main

    li t0, 0x20000000
    li t1, 1
    sw t1, 0(t0)


hang:

    j hang