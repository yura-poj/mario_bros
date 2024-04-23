rsect enemies

check_pixel: ext
check_under_pixel: ext

set_coordinates>
  push r0

  ldi r0, 0xff02
  ldi r1, 0xff0c
  ldi r2, 0x0020 #start point x
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
      ldb r0, r2 #set r2 as y of enemy
      if
        cmp r2, r4 #bigger than 2
      is gt 
        ldi r3, 0xfffb
        add r3, r2 #decrise r2 on 5
        jsr check_sky_enemy_under_map
        ldb r0, r2 #set r2 as y of enemy
        if
          tst r7
        is le
          ldi r3, 0xfffb
          add r3, r2 #decrise r2 on 5
        fi
      else
        jsr delete_sky_enemy
      fi
    else
      ldi r3, 0xffff
      add r3, r2 #decrise r2
      stb r0,r2

      inc r0 
      ldi r2, 0x001f
    fi
    

    stb r0,r2
    inc r0

  wend
  pop r0
  rts

check_sky_enemy_under_map:
  push r0
  push r1
  push r5
  push r2

  dec r0
  ldb r0, r5
  inc r0
  ldb r0, r7

  jsr check_under_pixel

  if
    tst r7
  is gt
    jsr delete_sky_enemy
  fi

  pop r2
  pop r5
  pop r1
  pop r0
  rts


delete_sky_enemy:
  dec r0
  ldi r3, 0x002e #set new enemy x
  stb r0, r3
  inc r0
  ldi r3, 0x001f #set new enemy y
  stb r0, r3
  rts

move_earth_enemies>
  push r0
  ldi r0, 0xff06
  ldi r1, 0xff0a
  ldi r4, 2
  

  while
    cmp r0, r1
  stays lt
    #перебираем всех наземных врагов
    ldb r0, r2 #set r2 as x of enemy

    ldi r3, 0xffff #set up -1 or 1 
    jsr check_map_left
    jsr check_map_right

    if
      tst r2 #bigger than 0
    is gt 
      add r3, r2 #decrise r2
    else
      ldi r2, 0x002e #el se set enemy to new coordinate
      inc r0
      ldi r3, 0x001f
      st r0, r3
      dec r0
    fi

    stb r0,r2

    inc r0
    ldb r0, r2 #set r2 as y of enemy

    if
      cmp r2, r4 #bigger than 2
    is gt
      move r2, r7
      dec r7
      dec r0
      ldb r0, r5
      inc r0
      jsr check_pixel
      if 
        tst r7
      is le
        ldi r3, 0xfffa
        add r3, r2 #decrise r2
      fi
    fi

    stb r0,r2
    inc r0

  wend
  pop r0
  rts


check_map_left:
  move r2, r5
  dec r5
  inc r0
  ldb r0, r7
  dec r7
  dec r0
  jsr check_pixel
  if 
    tst r7
  is le
    ldi r3, 1
  fi
  rts

check_map_right:
  move r2, r5
  inc r5
  inc r0
  ldb r0, r7
  dec r7
  dec r0
  jsr check_pixel
  if 
    tst r7
  is le
    ldi r3, 0xffff
  fi
  rts

end