.equ shopData, customSets+4
.equ disableKinstoneDrops, shopData+4
.thumb
push	{r2}
@ put set index (0-4) in r2
ldr	r1,=#0x2002CA3
ldrb	r3,[r1]
mov	r2,#0
mov	r0,#0x40
tst	r3,r0
beq	result
add	r2,#1
mov	r0,#0x80
tst	r3,r0
beq	result
add	r2,#1
ldrb	r3,[r1,#1]
mov	r0,#0x01
tst	r3,r0
beq	result
add	r2,#1
mov	r0,#0x02
tst	r3,r0
beq	result
add	r2,#1

result:
ldr	r1,customSets
ldrb	r1,[r1]
cmp	r1,r2
bhi	custom
@ check if we should use vanilla behavior or skip the item
ldr	r1,disableKinstoneDrops
cmp	r1,#0
bne	skip

vanilla:
mov	r1,#0x5C
pop	{r2}
mov	r0,#0
push	{r0}
b	end

custom:
pop	{r0}
@ the 15 item slots should each have a unique number
lsl	r0,r2,#2
add	r0,r5
push	{r0}
ldr	r3,shopData
lsl	r0,r2,#3
add	r3,r0
lsl	r0,r5,#1
add	r3,r0
ldrb	r1,[r3]
ldrb	r2,[r3,#1]

end:
mov	r0,#0x02
ldr	r3,=#0x80A217C @ CreateObject
mov	lr,r3
.short	0xF800
cmp	r0,#0
beq	objectfail
@ store the unique number (or 0 if vanilla) in the entity so it can be used by a trap disguise
mov	r2,#0x7E
pop	{r1}
strb	r1,[r0,r2]

objectfail:
ldr	r3,=#0x805D1C1
bx	r3

skip:
pop	{r3}
ldr	r3,=#0x805D1FD
bx	r3

.align
.ltorg
customSets:
@POIN goronMerchantCustomSets
@POIN goronMerchantData
@WORD disableKinstoneDrops
