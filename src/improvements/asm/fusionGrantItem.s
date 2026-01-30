.thumb

vanilla:
push	{r0-r6, lr}
ldr	r0, =#0x03003f80
ldr	r0, [r0, #0x30]
movs	r1, #0x80
and	r0, r1
cmp	r0, #0
bne	minish

@ Call SetPlayerActionNormal
ldr	r3, =#0x8078BE9
mov	lr, r3
.short	0xF800

b	checkFusionComplete

@ Call PlayerMinishSetNormalAndCollide
minish:
ldr	r3, =#0x8078C85
mov	lr, r3
.short	0xF800

checkFusionComplete:
ldr	r4, =#0x2022740	@ FuseInfo (Fusion State)
ldrb	r5, [r4]
cmp	r5, #2		@ Fuse Successful
bne	end

loadItem:
ldrb	r5, [r4, #3]	@ Fuse ID
mov	r6, #8
mul	r5, r6
ldr	r4, fusionTable
ldrb	r0, [r4, r5]
add	r5, #1
ldrb	r1, [r4, r5]

checkVanillaFusion:
cmp	r0, #0xF2
beq	vanillaFusion
customItem:
ldr	r3, =#0x80A73F9
mov	lr, r3
.short	0xF800
b	end

vanillaFusion:
ldr	r0, =#0x02002C81	@ Fusion address start
ldr	r3, =#0x0801D5F4	@ WriteBit
mov	lr, r3
.short	0xF800

end:
pop	{r0-r6, pc}

.align
.ltorg
fusionTable:
@POIN fusionTable
