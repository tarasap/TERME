
OUTPUT_ARCH( "riscv" )
ENTRY(_start)

MEMORY {
    /* 128KB for Instructions */
    IMEM (rx)  : ORIGIN = 0x00000000, LENGTH = 128K
    
    /* 128KB for Data, safely shifted out of the way to the 128KB mark */
    DMEM (rwx) : ORIGIN = 0x00020000, LENGTH = 128K 
}


SECTIONS {
    /* Code and read-only data go into IMEM */
    .text : {
        *(.boot)         
        *(.text.startup) 
        *(.text .text.*)
        *(.rodata .rodata.*)
        *(.srodata .srodata.*)  
    } > IMEM

    /* Initialized data goes into DMEM */
    .data : {
        . = ALIGN(4);
        *(.data .data.*)
        *(.sdata .sdata.*)     
        . = ALIGN(4);
    } > DMEM

    /* Uninitialized data (zeroed out) goes into DMEM */
    .bss : 
{
    . = ALIGN(4);

    _sbss = .;

    *(.bss .bss.*)
    *(.sbss .sbss.*)
    *(COMMON)

    . = ALIGN(4);

    _ebss = .;

} > DMEM
}

