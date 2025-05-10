.thumb
strh	r0,[r1]
ldrb	r0,[r4,#0x0A]
push	{r0-r3}
@Clear the ap item receiving address
ldr	r0, =#0x203FF10
mov	r1, #0x0
strh	r1, [r0]
@Other stuff
ldr	r3,=#0x807A910
mov	lr,r3
.short	0xF800
pop	{r0-r3}
cmp	r0,#0x43
bgt	end2

end:
ldr	r3,=#0x8083621
bx	r3

end2:
ldr	r3,=#0x808363F
bx	r3
