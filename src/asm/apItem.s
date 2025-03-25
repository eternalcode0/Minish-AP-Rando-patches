.equ	receivingItem, tableGiveItem+4
.equ    returnPoint, clear
.thumb
push {r0-r7}
ldr r3, =#0x3001004     @ Task Substate
ldrb r0, [r3]
cmp r0, #0x2
bne ap_end
ldr r3, receivingItem   @ Register for the ap item
ldrb r0, [r3]           @ Read primary item id into r0, will control which table we use
ldrb r1, [r3, #0x1]     @ Sub id, unused so far.
mov r2, #0x0
cmp r0, #0x0            @ If there is not an item to give...
beq ap_end              @ Then skip to the end
mov r4, r0              @ Else, setup table data for GiveItem
ldr r5,tableGiveItem
ldr r0, [r5]

tableLoop:              @ Loop through the GiveItem table :8F13C56
ldrb r1,[r0]
cmp r1, r4              @ Check if the item id is in the table, meaning it can be `GiveItem`d
beq tableMatch
cmp r1, #0xFF           @ If we've reached the end of the table
beq noMatch
add r0, #1              @ Else increment table index and repeat
b tableLoop

tableMatch:             @ The item in r4 can be `GiveItem`d
mov r0, r4
ldrb r1, [r3, #0x1]
ldr r3, =#0x8053B89     @ Call GiveItem
mov lr, r3
.short 0xF800
b clear

noMatch:                @ The item needs to be passed to CreateItemEntity
ldr r3, receivingItem
mov r0, r4
ldrb r1, [r3, #0x1]
mov r2, #0x0
ldr r3, =#0x80A73F9     @ Call CreateItemEntity
mov lr, r3
.short 0xF800


clear:
ldr r3, receivingItem   @ Reload the memory address to be cleared for the next cycle
mov r4, #0x0
strh r4, [r3]

ap_end:                 @ Call the original instructions starting at 0x80AD158
pop { r0-r7 }
ldr r6, =#0x3003F80
add r3, r6, #0x0
add r3, #0xA8
mov r4, #0x0
ldr r7, =#0x80701DD
bx r7

.align
.ltorg
tableGiveItem:
@POIN tableGiveItem
@POIN receivingItem
@POIN returnPoint
