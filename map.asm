rsect map

set_up>
  #set number of colums = 0
  ldi r0, 0
  ldi r1, number
  stb r1, r0
  
  ldi r1, 0
  ldi r2, 0x0020
  ldi r3, columns
  ldi r5, 0xff0c
  ldi r6, 0xff0d
  ldi r7, 1
  while
    cmp r1,r2
  stays lt
    ldb r3, r4 
    stb r6, r4 #set new column
    stb r5, r7 #set tick = 1
    stb r5, r0 #set tick = 0
    inc r3
    inc r3
    inc r1
  wend
  rts

check_pixel>
  #r5 - x
  #r7 - y
  #r7 - will have answer if r7 = 1 pixil is here 0 = otherwise
  ldi r1,number
  ldb r1,r1
  add r5, r1 #r1 = number + x
  ldi r2, columns
  add r1, r2
  ldb r2, r2
  and r2, r7
  rts

move_map>
  ldi r4, number
  ldi r2, 0x001f
  ldi r3, columns
  ldb r4,r1
  inc r1
  stb r1,r4 #store inc number
  add r2,r1
  add r1,r3
  ldb r3,r3
  ldi r4, 0xff0d #regs colums
  stb r4, r3 #set new column
  ldi r4, 0xff0c #regs tick
  ldi r3, 0
  stb r5, r3 #set tick = 1
  ldi r3, 1
  stb r5, r0 #set tick = 0
  rts

number: ds 1
columns: dc 1,0x0002,3,4,5,6,7,8,9,10,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
end