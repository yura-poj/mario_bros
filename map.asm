rsect map

move_earth_enemies: ext
move_sky_enemies: ext

macro popit/0
  pop r6
  pop r4
  pop r3
  pop r2
  pop r1
  pop r0
mend

macro pushit/0
  push r0
  push r1
  push r2
  push r3
  push r4
  push r6
mend

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
  pushit
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

  ldi r5, 1
  if
    cmp r5, r7
  is eq
    ldi r7, 0
  fi

  if
    cmp r2, r7
  is eq
    ldi r7,1
  else
    ldi r7,0
  fi
  popit
  rts

check_under_pixel>
  pushit
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
  popit
  rts

move_map>
  pushit

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
  popit
  rts

move_enemies:
  ldi r0, 0xfe02
  ldi r1, 0xfe06
  ldi r4, 2

  while
    cmp r0, r1
  stays lt
    #перебираем всех  врагов
    ldb r0, r2 #set r2 as x of enemy
    dec r2
    stb r0, r2
    add r4,r0
  wend
  rts

number: ds 1
columns: dc 7, 7, 7, 7, 7, 7, 7, 7, 7, 1, 1, 1, 1, 1, 1, 1, 7, 7, 7, 7, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
end