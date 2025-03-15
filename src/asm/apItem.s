.thumb
push {r0-r3}
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

ap_end:                 @ Call the original instructions starting at 0x80AD158
pop { r0-r3 }
ldr r0, =#0x30010A0
add r0, #0x2f
ldrb r0, [r0,#0x0]      @ I don't know why but this was in the original overwritten instructions so it stays, ig
mov r1, #0x0
ldr r3, =#0x80AD161
bx r3
