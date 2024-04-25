rsect mario

check_pixel: ext
move_map: ext

move_mario>
  push r0
  jsr prepare 
  jsr check_x_bigger_half_map
  jsr check_x_less
  jsr check_x_bigger

  ldi r4, 0xfe00 # mario x
  stb r4, r2 #store mario x

  jsr check_y_and_jump
  jsr decline_jump_if
  jsr increase_y
  jsr decrease_y
    
  ldi r4, 0xfe01 # mario y
  stb r4, r3 #store y
  pop r0

  rts

prepare:
  ldi r0, 0xfefe # left right
  ldi r1,0xfeff # up down
  ldi r2, 0xfe00 # mario x
  ldi r3, 0xfe01 # mario y

  ldb r0, r0
  ldb r1, r1
  ldi r5, 0x00ff
  if # if r0 is 00ff change it to ffff 
    cmp r0,r5
  is eq
    ldi r0, 0xffff
  fi
  if # if r1 is 00ff change it to ffff 
    cmp r1,r5
  is eq
    ldi r1, 0xffff
  fi

  ldb r2,r2
  ldb r3,r3


  add r0,r2
  rts

check_x_less:
  ldi r5, 0x0020
  if #check for x less 32
    cmp r2,r5
  is ge
    sub r2, r0
    move r0, r2
  fi
  rts

check_x_bigger:
  ldi r4, 0x0001
  if #check for x bigger 1
    cmp r2, r4
  is lt
    sub r2, r0
    move r0, r2
  fi
  rts

check_x_bigger_half_map:
  ldi r4, 0x0010
  if #check for x >= halh of map
    cmp r2, r4
  is ge
    if
      tst r0
    is gt #check move right
      dec r2
      jsr move_map
    fi
  fi
  rts

check_y_and_jump:
  ldi r2, 0x0001
  #check jump = 1 and y = 2
  if
    cmp r1, r2
  is eq
    ldi r2, 0x0002
    if
      cmp r3, r2
    is le
      ldi r6, 0x0001
    fi
    #check y - 1= map
    ldi r5, 0xfe00 #mario x
    ldb r5,r5
    ldi r7, 0xfe01 #mario y
    ldb r7, r7
    dec r7
    jsr check_pixel
    if
      tst r7
    is gt
      ldi r6, 0x0001
    fi
  fi
  rts

decline_jump_if:
  #set r6 = 0 if r6 =5
  ldi r1, 0x0005
  if
    cmp r6, r1
  is ge
    ldi r6, 0x0000
  fi
  #set r6 = 0 if pixel above
  ldi r5, 0xfe00 #mario x
  ldb r5,r5
  ldi r7, 0xfe01 #mario y + 3
  ldi r2, 3
  ldb r7, r7
  add r2,r7
  jsr check_pixel
  #i f map
  if
    tst r7
  is gt
    ldi r6, 0x0000
  fi

  rts

increase_y:
#incrise y of mario if r6
  if
    tst r6
  is gt
  ldi r1, 0x0003
    add r1, r3
    inc r6
  fi
  
  ldi r5, 0x0000

  rts
decrease_y:
  ldi r2, 0x0002
  if
    cmp r3, r2
  is gt
    ldi r5, 0xfe00 #mario x
    ldb r5,r5
    ldi r7, 0xfe01 #mario y
    ldb r7, r7
    dec r7
    jsr check_pixel
    #i f map
    ldi r5, 0x0000
    if # if r7 > 0 
      tst r7
    is le #fall if doesnt have map
      ldi r1, 0xffff
      add r1,r3
      ldi r5 , 0x0001 #set r5 for trigger
    fi
  fi
  rts
end