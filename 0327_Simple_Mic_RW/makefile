# -----------------------------------------------------------------------------
#  Copyright (c) 2013 Semiconductor Components Industries, LLC
#  (d/b/a ON Semiconductor). All rights reserved.
#
#  This code is the property of ON Semiconductor and may not be redistributed
#  in any form without prior written permission from ON Semiconductor. The
#  terms of use and warranty for this code are covered by contractual
#  agreements between ON Semiconductor and the licensee.
# -----------------------------------------------------------------------------
#  makefile
#  - build rules for the project
# -----------------------------------------------------------------------------
#  $Revision: 1.20 $
#  $Date: 2014/08/20 17:14:29 $
# -----------------------------------------------------------------------------

# Define project name
PROJECT=0316_Simple_Mic_RW

# Force the use of the Windows shell, cmd.exe
SHELL=cmd.exe

# Define the toolset
FAS=feasm
HCT=hct
AS=cfcc -c
CPP=cfpp
LD=cfcc
RM=cs-rm
DPP=dpp

# Define the Ezairo 7100 architecture
ARCH=sk4
CID=102

# Define the output folder
OUTDIR=Debug

# Define the libraries to link with
LIBS=sk4_eeprom.a sk4_sys.a sk4_math.a

# Define the include and library paths
INCDIRS=$(SK4_TOOLS)/include/cfx $(OUTDIR) 
LIBDIRS=$(SK4_TOOLS)/lib/cfx

# Define flags for the stages of compilation
COMMONFLAGS=-g --toolchain=gnu
CPPFLAGS=$(patsubst %,-I%,$(INCDIRS)) -DSK4_CID=$(CID) 
DPPFLAGS= -MG -MT
HCTFLAGS=-b$(ARCH)c$(CID) -i $(OUTDIR) -s $(patsubst %,-L%,$(LIBDIRS)) \
	-lstdhear2.hcl
ASFLAGS=-b$(ARCH) --strictnop
LDFLAGS=-b$(ARCH) $(patsubst %,-L%,$(LIBDIRS)) \
    --mem0=0x8000/0xDBFF --mem0=0xDFE0/0xDFFF \
    --mem1=0x0120/0x2FFF --mem1=0x4000/0x67FF --mem1=0x8000/0xFFFF \
    --mem2=0x0120/0x0FFF --mem2=0xC000/0xFFFF \
    --mem3=0x0020/0x011F \
    --mem0=0xE000/0xEFFF --mem0=0xF300/0xF312 \
    --mem0=0xF800/0xF8BF --mem0=0xF900/0xF9FF
LDLIBS=$(patsubst %,-l%,$(LIBS) )

# Define the output executable name
OUTPUT=$(OUTDIR)/$(PROJECT).cfe

# Define the CFX assembly source files
SRCS= \
    app_init.cfs \
    app_isr.cfs \
    app_memory.cfs \
    app.cfs

# Define the HEAR configuration source file
HCTFILE=microcode.hct

# Define the dependency files
DEPS= \
	$(patsubst %,$(OUTDIR)/%,$(SRCS:cfs=dep)) \
	$(subst cfi,dep,)

# Filter Engine source file
FENGSRC=feng.fs

# Generate a list of object files
OBJS=$(patsubst %,$(OUTDIR)/%,$(SRCS:.cfs=.o)  )
GENERATED_HEADERS=

# Generate the executable file
$(OUTPUT): $(OBJS)
	$(LD) $(COMMONFLAGS) $(LDFLAGS) $(OBJS) $(LDLIBS) --entry=main -o$@

# The 'all' build rule
all:
	$(MAKE) CID=102

# Pattern rules for generating dependency files
$(OUTDIR)/%.dep: %.cfs makefile $(GENERATED_HEADERS)
	@if not exist $(OUTDIR) mkdir $(OUTDIR)
	$(DPP) $(CPPFLAGS) $(DPPFLAGS) $(@:dep=o) $< $@ 

$(OUTDIR)/%.dep: %.hct 
	@if not exist $(OUTDIR) mkdir $(OUTDIR)
	$(DPP) $(CPPFLAGS) $(DPPFLAGS) $(@:dep=cfi) $< $@ 
  
# Pattern rules for generating object files
$(OUTDIR)/%.o: %.cfs makefile
	$(AS) $(COMMONFLAGS) $(CPPFLAGS) $(ASFLAGS) -o$@ $<

$(OUTDIR)/%.o: $(OUTDIR)/%.cfs makefile
	$(AS) $(COMMONFLAGS) $(CPPFLAGS) $(ASFLAGS) -o$@ $<

$(OUTDIR)/%.o $(OUTDIR)/%.cfi: %.hct $(OUTDIR)/%.dep makefile 
	$(HCT) $(COMMONFLAGS) $(CPPFLAGS) $(HCTFLAGS) $< -o$(OUTDIR)

# Pattern rule for generating cfs files from Filter Engine source files
$(OUTDIR)/%.cfs : %.fs makefile
	$(FAS) /m:SK4 $< /o:$@

# A rule to remove all generated files
clean:
	$(RM) -f $(OBJS)
	$(RM) -f $(OUTPUT)
	$(RM) -f $(DEPS)
	$(RM) -f $(OUTDIR)/$(HCTFILE:.hct=.smy)
	$(RM) -f $(OUTDIR)/$(HCTFILE:.hct=.cfi)
	$(RM) -f $(OUTDIR)/$(FENGSRC:.fs=.cfs)

clean-all:
	$(MAKE) CID=102 clean

# Prevent MAKE from treating generated headers as an intermediate file and deleting it
.Secondary: $(GENERATED_HEADERS)

# Include the dependency files if not cleaning, and not twice in same build
ifneq ($(MAKECMDGOALS),clean)
ifneq ($(MAKECMDGOALS),all)
ifneq ($(MAKECMDGOALS),clean-all)
ifneq ($(strip $(DEPS)),)
-include $(DEPS)
endif
endif
endif
endif
# vim:set noexpandtab tabstop=4 shiftwidth=4:
