.equ	singleValueCheck, safeAddress+4
.equ	multiValueCheck, singleValueCheck+4
.equ	actionFlagsCheck, multiValueCheck+4
.thumb
push	{r0-r2}
ldr	r0, singleValueCheck

@ Loop through the Single Value Check table
checkSingle:
ldr	r1, [r0]
@ Check if we reached the end of the table
cmp	r1, #0xFF
beq	checkMulti
@ Check if the value in the register is equal to the value after the pointer
ldrb	r2, [r0,#4]
ldrb	r1, [r1]
cmp	r2, r1
bne	unsafe
@ Else increment table pointer and repeat
add	r0, #8
b	checkSingle

@ Not yet implemented
checkMulti:

checkActions:
ldr	r0, =#0x3003FB0
ldr	r1, [r0]
ldr	r2, actionFlagsCheck
orr	r1, r2
cmp	r1, r2
bne	unsafe

safe:
ldr	r0, safeAddress
mov	r1, #0x1
strb	r1, [r0]
b	end

@ It's not safe to received items, set the flag for later functions
unsafe:
ldr	r0, safeAddress
mov	r1, #0x0
strb	r1, [r0]

@ Call the original instructions starting at 0x804FD94
end:
pop	{ r0-r2 }
ldrh	r0, [r4,#0x8]
mov	r5, #0x1C
and	r5, r0
mov	r6, #0x0
ldr	r7, =#0x804FD9B
bx	r7

.align
.ltorg
safeAddress:
@POIN singleValueCheck
@POIN multiValueCheck
@WORD actionFlagsCheck
