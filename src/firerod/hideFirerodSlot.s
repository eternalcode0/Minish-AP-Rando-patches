.thumb

@r0 is the new buttons being pushed from 0x03000FF2
@r1 is the new inventory menu pointer
@r2(new) is the current menu slot id
@r3(new) is whether the player has firerod
@r4 is the menu slot to change to
@r5 needs to be the menu pointer 0x2000080

@r0 is the buttons being pushed
@r1 is the current menuEntry
@r2(new) is whether the player has firerod
@r3(new) is
@r5 is the menu pointer (0x2000080)

checkFirerod:
@check if player has firerod
ldr	r2, =#0x2002B37
ldrb	r2, [r2]
mov	r3, #0x10
and	r3, r2

ldrb	r2, [r5, #3]	@current menu slot id

checkOverride:
cmp	r3, #0		@has firerod
bne	normalSet
cmp	r2, #0x00	@sword menu id
bne	notSword
cmp	r0, #0x20	@move left
bne	notSword
mov	r3, #2
b	override
notSword:
cmp	r2, #0x03	@boomerang menu id
bne	normalSet
cmp	r0, #0x10	@move right
bne	normalSet
mov	r3, #3

@checkOverrideNecessary:
@cmp	r4, #0x12	@ firerod menu id
@bne	noOverride
@cmp	r2, #0
@bne	noOverride

override:
ldr	r0, newMenuTable
mov	r1, #0x90
add	r1, r3
ldrb	r4, [r0, r1]

normalSet:
ldrb	r0, [r5, #3]
cmp	r0, r4
beq	end
updateSlot:
strb	r4, [r5, #3]
mov	r0, #0x69
ldr	r3, =#0x80a2a81
mov	lr, r3
.short	0xF800

end:
ldr	r3, =#0x80A4B5B
bx	r3

@ ---

@prepSlot:
@ldr	r5, =#0x2000080
@ldrb	r2, [r5, #3]	@ current menu slot id

@checkRight:
@cmp	r0, #0x10
@bne	checkLeft

@ensure we aren't moving from boomerang and if so jump to sword if we don't have firerod
@setRight:
@cmp	r2, #0x03	@ boomerang menu id
@bne	normalRight
@cmp	r3, #0
@bne	normalRight
@mov	r4, #0x00	@ jump to sword instead
@b	setNewMenuSlot
@normalRight:
@ldrb	r4, [r1, #3]	@ right slot
@b	setNewMenuSlot

@checkLeft:
@cmp	r0, #0x20
@bne	checkUp

@ensure we aren't moving from sword and if so jump to boomerang if we don't have firerod
@setLeft:
@cmp	r2, #0x00	@ sword menu id
@bne	normalLeft
@cmp	r3, #0
@bne	normalLeft
@mov	r4, #0x03	@ jump to boomerang instead
@b	setNewMenuSlot
@normalLeft:
@ldrb	r4, [r1, #2]	@ left slot
@b	setNewMenuSlot

@checkUp:
@cmp	r0, #0x40
@bne	checkDown

@setUp:
@ldrb	r4, [r1, #0]	@ up slot
@b	setNewMenuSlot

@checkDown:
@cmp	r0, #0x80
@bne	noChange

@setDown:
@ldrb	r4, [r1, #1]	@ down slot
@b	setNewMenuSlot

@noChange:
@mov	r4, r2

@setNewMenuSlot:
@mov	r0, r2
@ldr	r3, =#0x80a4b4F
@mov	lr, r3
@bx	lr

.align
.ltorg
newMenuTable:
@POIN newMenuTable
