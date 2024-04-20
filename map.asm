rsect map

move_earth_enemies: ext
move_sky_enemies: ext

set_up>
  #set number of colums = 0
  ldi r0, 0
  ldi r1, number
  stb r1, r0
  
  ldi r0, 1
  ldi r1, 0
  ldi r2, 0x0020
  ldi r3, columns
  ldi r5, 0xff0c
  ldi r6, 0xff0d
  ldi r7, 2
  while
    cmp r1,r2
  stays lt
    ldb r3, r4 
    stb r6, r4 #set new column
    stb r5, r7 #set tick = 2
    stb r5, r0 #set tick = 1
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
  shl r1
  add r1, r2
  ldb r2, r2
  if
    cmp r2, r7
  is eq
    ldi r7,1
  else
    ldi r7,0
  fi
  rts

check_under_pixel>
  #r5 - x
  #r7 - y
  #r7 - will have answer if r7 = 1 pixil is here 0 = otherwise
  ldi r1,number
  ldb r1,r1
  add r5, r1 #r1 = number + x
  ldi r2, columns
  shl r1
  add r1, r2
  ldb r2, r2
  if
    cmp r2, r7
  is ge
    ldi r7,1
  else
    ldi r7,0
  fi
  rts

move_map>
  push r2

  ldi r4, number
  ldi r2, 0x001f
  ldi r3, columns
  ldb r4,r1
  inc r1
  stb r4,r1 #store inc number
  add r2,r1
  shl r1
  add r1,r3
  ldb r3,r3
  ldi r4, 0xff0d #regs colums
  stb r4, r3 #set new column
  ldi r4, 0xff0c #regs tick
  ldi r3, 2
  stb r4, r3 #set tick = 2
  ldi r3, 1
  stb r4, r0 #set tick = 1

  jsr move_enemies
  pop r2
  rts

move_enemies:
  ldi r0, 0xff02
  ldi r1, 0xff0a
  ldi r4, 2

  while
    cmp r0, r1
  stays lt
    #перебираем всех наземных врагов
    ldb r0, r2 #set r2 as x of enemy
    dec r2
    stb r0, r2
    add r4,r0
  wend
  rts

number: ds 1
columns: dc 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207
end