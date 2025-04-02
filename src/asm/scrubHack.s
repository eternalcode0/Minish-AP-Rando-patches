.equ item, shopData+4
.equ return, item+4
.thumb
push	{r1}
ldr	r1,shopData
cmp	r1,r6
beq	match
b	vanilla

match:
ldr	r0,item
ldrh	r1,[r0,#4]
cmp	r1,#0x1B
beq	dontreplace
ldrh	r1,[r0,#6]
cmp	r1,#0xFF
beq	replace
dontreplace:
ldrh	r1,[r0,#6]
pop	{r2}
b	jump
replace:
pop	{r1}
jump:
ldrh	r0,[r0,#4]
b	end

vanilla:
ldrb	r0,[r6,#8]
pop	{r1}

end:
mov	r2,#0
ldr	r3,=#0x80A73F8
mov	lr,r3
.short	0xF800
ldr	r3,return
bx	r3

.align
.ltorg
shopData:
