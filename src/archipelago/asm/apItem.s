.equ	idsSetInventory, idsGiveItem+4
.equ	receivingItem, idsSetInventory+4
.thumb
push	{r0-r7}
ldr	r3, =#0x2002A4A
ldrb	r0, [r3]
cmp	r0, #0x1
bne	ap_end
ldr	r3, receivingItem
ldrb	r0, [r3]
ldrb	r1, [r3, #0x1]
mov	r2, #0x0
cmp	r0, #0x0
beq	ap_end
mov	r4, r0
ldr	r0,idsGiveItem

@ Loop through the GiveItem table :8F13C56
giveItemLoop:
ldrb	r1,[r0]
@ Check if the item id is in the table, meaning it can be `GiveItem`d
cmp	r1, r4
beq	giveItemMatch
@ If we've reached the end of the table
cmp	r1, #0xFF
beq	notGiveItem
@ Else increment table index and repeat
add	r0, #1
b	giveItemLoop

@ The item in r4 can be `GiveItem`d
giveItemMatch:
mov	r0, r4
ldrb	r1, [r3, #0x1]
ldr	r3, =#0x8053B89		@ Call GiveItem
mov	lr, r3
.short	0xF800
b	clear

notGiveItem:
ldr	r0, idsSetInventory
setInventoryLoop:
ldrb	r1, [r0]
cmp	r1, r4
beq	setInventoryMatch
cmp	r1, #0xFF
beq	createItem
add	r0, #1
b	setInventoryLoop

setInventoryMatch:
mov	r0, r4
mov	r1, #1
ldr	r3, =#0x0807C4C5	@ Call SetInventoryValue
mov	lr, r3
.short	0xF800
b clear

@ The item needs to be passed to CreateItemEntity
createItem:
ldr	r3, receivingItem
mov	r0, r4
ldrb	r1, [r3, #0x1]
mov	r2, #0x0
@ Call CreateItemEntity
ldr	r3, =#0x80A73F9
mov	lr, r3
.short	0xF800

@ Reload the memory address to be cleared for the next cycle
clear:
ldr	r3, receivingItem
mov	r4, #0x0
strh	r4, [r3]

@ Call the original instructions starting at 0x80701D4
ap_end:
pop	{ r0-r7 }
ldr	r6, =#0x3003F80
add	r3, r6, #0x0
add	r3, #0xA8
mov	r4, #0x0
ldr	r7, =#0x80701DD
bx	r7

.align
.ltorg
idsGiveItem:
@POIN idsGiveItem
@POIN idsSetInventory
@POIN receivingItem
