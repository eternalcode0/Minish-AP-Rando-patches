.thumb
add	r0, #0xaa
ldrb	r1, [r0, #1]
cmp	r1, #24	@default max health
bcs	setTo3
setToMax:
strb	r1, [r0]
b	end

setTo3:
mov	r1, #0x18
strb	r1, [r0]

end:
ldr	r0, =#0x3001000
ldr	r3, =#0x8051d29
mov	lr, r3
.short	0xF800

.align
.ltorg
