@ Expect 0x3003FA8 to be written to with 2 bytes
@ from apworld whenever an item is received.
@ Injected into GameTask_Main (0x0805185A)
.thumb
push { r0-r3 }
ldr r2, =#0x3003FA8     @ Read item id
ldrb r0, [r2]           @ Read primary item id into r0 for sending to GiveItem func
ldrb r1, [r2, #0x1]     @ Read sub item id into r1 for sending to GiveItem func
mov r3, #0x0
strh r3, [r2]           @ Clear ram address for next cycle
cmp r0, #0x0            @ If there is not an item to give...
beq ap_end              @ Skip to the end
ldr r3, =#0x08F13C5C    @ Return point after GiveItem
mov lr, r3
ldr r2,=#0x8053B89      @ Else: call GiveItem with the 2 item ids
bx r2

ap_end:                 @ Call the original functions overwritten by jumpToHack
ldr r0, =#0x8F13C64     @ DrawUIElements return point
mov lr, r0
ldr r0, =#0x801C241     @ DrawUIElements
bx r0
ldr r0, =#0x8F13C6C     @ UpdateCarriedObject return point
mov lr, r0
ldr r0, =#0x80786E1     @ UpdateCarriedObject
bx r0
ldr r0, =#0x8F13C74     @ DrawEntities return point
mov lr, r0
ldr r0, =#0x80AD155     @ DrawEntities
bx r0
pop { r0-r3 }           @ Grab the used reused registers back from the stack
ldr r3, =#0x8051867     @ and jump back to the GameTask_Main function where we left off
bx r3

pointers:
@POIN pointers
@POIN func2
@POIN func3
@POIN ret
