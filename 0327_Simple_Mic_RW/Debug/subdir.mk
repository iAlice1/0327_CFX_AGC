################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CFS_SRCS += \
../app.cfs \
../app_init.cfs \
../app_isr.cfs \
../app_memory.cfs 

CFS_OBJS += \
./app.o \
./app_init.o \
./app_isr.o \
./app_memory.o 

CFS_DEPS += \
./app.dep \
./app_init.dep \
./app_isr.dep \
./app_memory.dep 


# Each subdirectory must supply rules for building sources it contributes
%.o %.orc: ../%.cfs $(HCT_DEPS:.dep=.cfi)
	@echo 'Building file: $<'
	@echo 'Invoking: CFCC Assembler'
	dpp -IC:\PROGRA~2\ONSEMI~1\EZAIRO~1/include/cfx -I. -DSK4_CID=102 -DFILTER_TYPE_SFIR -DFILTER_TYPE_FIR -DUSAGE1 -MG -MT $@ $< $(addsuffix .dep,$(basename $@))
	cfcc -c -bSK4 --toolchain=gnu -g -IC:\PROGRA~2\ONSEMI~1\EZAIRO~1/include/cfx -I. -DSK4_CID=102 -DFILTER_TYPE_SFIR -DFILTER_TYPE_FIR -DUSAGE1 --lst --strictnop -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

app.orc: app.o

app_init.orc: app_init.o

app_isr.orc: app_isr.o

app_memory.orc: app_memory.o


