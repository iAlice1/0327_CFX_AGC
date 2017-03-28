===============================================================================
 Mono FIFO Copy
===============================================================================

This code is an example of a simple audio passthrough application.

The following steps are performed in every new frame:

1) An interrupt (FIFO_0) is generated when the current output block of the mono
   output FIFO B0_0 has been completely read by the IOC for the OD0 output. This
   interrupt is used to synchronize processing since it is associated with the
   last scheduled data transfer by the IOC (the transfer of data from ADC0 to
   mono input FIFO A0_0 will already have completed). Refer to the section on
   IOC Data Transfer Timing in the Hardware Reference Manual for more
   information.

2) The application services the FIFO 0 interrupt since it happens after the
   completion of the latest input block in FIFO A0_0, when it is safe to copy
   from FIFO A0_0 to FIFO B0_0.

3) The FIFO 0 interrupt service routine (ISR) starts the FIFO_Copy function
   on the CFX. This operation reads data from the input FIFO and copies it to
   the mono output FIFO B0_0 at location FIFO_B0_0_START in B0MEM.

   This copying must be completed before the next FIFO 0 interrupt,
   which indicates the beginning of the next frame.

Note:  In this Mono FIFO Copy example, the HEAR is not used; the CFX code
       initializes the HEAR in the initialization routine and disables the HEAR
       interrupts. Though they are not required in this application, these steps
       are performed to demonstrate the normal process required to initialize
       the HEAR. The HEAR is not started, however, as undefined behavior could
       result from unknown HEAR microcode residing in memory prior to launch.

       The Filter Engine and the ARM Cortex-M3 processor are not used; they are
       reset and then disabled.

For more information, see the comments in the code.
The code files are organized as follows:

-  app.cfs          : main file, containing the main loop and FIFO_Copy function
-  app.cfi          : definitions
-  app_init.cfs     : application initialization routine
-  app_memory.cfs   : variable declarations, stack initialization
-  app_isr.cfs      : interrupt vector table and CFX ISRs

===============================================================================
Copyright (c) 2013 Semiconductor Components Industries, LLC
(d/b/a ON Semiconductor).

