.equ	savesize, savereg+4
.equ	savestart, savesize+4
.equ	safereturn, savestart+4
.thumb
push	{r0-r7}
ldr	r4, savereg
ldr	r5, savesize
ldr	r6, savestart
loop:
cmp	r5, #0
beq	end
ldrb	r0, [r4, r5]
cmp	r0, #0
beq	skipbyte
strb	r0, [r6, r5]
skipbyte:
sub	r5, #1
b	loop
end:
ldr	r3, safereturn
mov	lr, r3
pop	{r0-r7}
.short	0xF800

.align
.ltorg
savereg:
@POIN savesize
@POIN savestart
