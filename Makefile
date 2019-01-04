VER			= V02
ASM			= nasm
ASMFLAGS	= -f bin
IMG			= a.img

MBR			= os423V.asm
LDR			= loaderV.asm
MBR_SRC		= $(subst V,$(VER),$(MBR))
MBR_BIN		= $(subst .asm,.bin,$(MBR_SRC))
LDR_SRC		= $(subst V,$(VER),$(LDR))
LDR_BIN		= $(subst .asm,.bin,$(LDR_SRC))
TEXT_FILE		= text

.PHONY : everything

everything : $(MBR_BIN) $(LDR_BIN)
 ifneq ($(wildcard $(IMG)), )
else
		dd if=/dev/zero of=$(IMG) bs=512 count=2880
 endif

		dd if=$(MBR_BIN) of=$(IMG) bs=512 count=1 conv=notrunc
		dd if=$(LDR_BIN) of=$(IMG) bs=512 count=1 seek=37 conv=notrunc
		dd if=$(TEXT_FILE) of=$(IMG) bs=512 count=1 seek=39 conv=notrunc

$(MBR_BIN) : $(MBR_SRC)
	$(ASM) $(ASMFLAGS) $< -o $@

$(LDR_BIN) : $(LDR_SRC)
	$(ASM) $(ASMFLAGS) $< -o $@

clean :
	rm -f $(MBR_BIN) $(LDR_BIN)

reset:
	rm -f $(MBR_BIN) $(LDR_BIN) $(IMG)
	
blankimg:
	dd if=/dev/zero of=$(IMG) bs=512 count=2880