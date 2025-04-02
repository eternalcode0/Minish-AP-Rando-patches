.equ boomerangShopItem, walletShopItem+4
.equ quiverShopItem, boomerangShopItem+4
.thumb
cmp	r5,#0x64
beq	wallet
cmp	r5,#0x0B
beq	boomerang
cmp	r5,#0x66
beq	quiver
cmp	r5,#0x0D
beq	shield
vanilla:
mov	r0,r5
end:
mov	r2,#0
wasshield:
ldr	r3,=#0x80A7410
mov	lr,r3
.short	0xF800
ldr	r3,=#0x8064ED5
bx	r3

shield:
mov	r0,r5
mov	r2,#2
b	wasshield

wallet:
ldr	r0,=#0x2002EA4
mov	r1,#24
ldr	r3,=#0x801D5F4	@vanilla flag set routine
mov	lr,r3
.short	0xF800
ldr	r1,walletShopItem
ldrb	r0,[r1,#0]
ldrb	r1,[r1,#1]
b	end

boomerang:
ldr	r0,=#0x2002EA4
mov	r1,#25
ldr	r3,=#0x801D5F4	@vanilla flag set routine
mov	lr,r3
.short	0xF800
ldr	r1,boomerangShopItem
ldrb	r0,[r1,#0]
ldrb	r1,[r1,#1]
b	end

quiver:
ldr	r0,=#0x2002EA4
mov	r1,#26
ldr	r3,=#0x801D5F4	@vanilla flag set routine
mov	lr,r3
.short	0xF800
ldr	r1,quiverShopItem
ldrb	r0,[r1,#0]
ldrb	r1,[r1,#1]
b	end

.align
.ltorg
walletShopItem:
@POIN walletShopItem
@POIN boomerangShopItem
@POIN quiverShopItem
