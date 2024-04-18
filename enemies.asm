rsect enemies

set_coordinates>
  push r0

  ldi r0, 0xff02
  ldi r1, 0xff0c
  ldi r2, 0x0002 #start point x
  ldi r3, 0x0009
  ldi r4, 0x001f
  while
    cmp r0, r1
  stays lt
    stb r0, r2
    inc r0
    stb r0, r4
    add r3, r2
    inc r0
  wend
  pop r0
rts

move_sky_enemies>
  push r0
  ldi r0, 0xff02
  ldi r1, 0xff06
  ldi r4, 3
  ldi r5, 0xff00
  ldb r5, r5 #mario x + 3 
  add r4, r5

  ldi r4, 2

  while
    cmp r0, r1
  stays lt
    #перебираем летящих всех врагов
    ldb r0, r2 #set r2 as x of enemy
    #i f mario under enemy = enemy will drop
    if
      cmp r2, r5
    is le
      inc r0 
      ldb r0, r2 #set r0 as y of enemy
      if
        cmp r2, r4 #bigger than 2
      is gt 
        ldi r3, 0xfffb
        add r3, r2 #decrise r2 on 5
      else
        dec r0
        ldi r3, 0x002e #set new enemy x
        stb r0, r3
        inc r0
        ldi r3, 0x001f #set new enemy y
        stb r0, r3
      fi
    else
      if
        tst r2 #bigger than 0
      is gt 
        ldi r3, 0xffff
        add r3, r2 #decrise r2
      else
        ldi r2, 0x002e #el se set enemy to new coordinate
      fi

      stb r0,r2

      inc r0 
      ldi r2, 0x001f
    fi
    

    stb r0,r2
    inc r0

  wend
  pop r0
  rts

move_earth_enemies>
  push r0
  ldi r0, 0xff06
  ldi r1, 0xff0c
  ldi r4, 2

  while
    cmp r0, r1
  stays lt
    #перебираем всех наземных врагов
    ldb r0, r2 #set r2 as x of enemy
    if
      tst r2 #bigger than 0
    is gt 
      ldi r3, 0xffff
      add r3, r2 #decrise r2
    else
      ldi r2, 0x002e #el se set enemy to new coordinate
    fi

    stb r0,r2

    inc r0
    ldb r0, r2 #set r0 as y of enemy

    if
      cmp r2, r4 #bigger than 2
    is gt 
      ldi r3, 0xfffe
      add r3, r2 #decrise r2
    fi

    stb r0,r2
    inc r0

  wend
  pop r0
  rts

end