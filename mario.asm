rsect mario

check_pixel: ext
move_map: ext

move_mario>
  push r0

    ldi r0, 0xfefe # left right
    ldi r1,0xfeff # up down
    ldi r2, 0xff00 # mario x
    ldi r3, 0xff01 # mario y

    ldw r0, r0
    ldb r1, r1
    ldi r5, 0x00ff
    if # if r1 is 00ff change it to ffff 
      cmp r1,r5
    is eq
      ldi r1, 0xffff
    fi

    ldb r2,r2
    ldb r3,r3


    add r0,r2

    ldi r5, 0x0020
    if #check for x less 32
      cmp r2,r5
    is ge
      sub r2, r0
      move r0, r2
    fi

    ldi r4, 0x0001
    if #check for x bigger 1
      cmp r2, r4
    is lt
      sub r2, r0
      move r0, r2
    fi

    ldi r4, 0x0010
    if #check for x >= halh of map
      cmp r2, r4
    is ge
      jsr move_map
    fi

    ldi r4, 0xff00 # mario x
    stb r4, r2


    ldi r2, 0x0001
    #check y = 1
    if
      cmp r1, r2
    is eq
      if
        cmp r3, r2
      is eq
        jsr set_up_r6
      fi
      #check y - 1= map
      ldi r5, 0xff00 #mario x
      ld r5,r5
      ldi r7, 0xff00 #mario y
      ld r7, r7
      dec r7
      jsr check_pixel
      if
        tst r7
      is gt
        jsr set_up_r6
      fi
    fi

    #set r6 = 0 if r6 =4
    ldi r1, 0x0004
    if
      cmp r6, r1
    is ge
      ldi r6, 0x0000
    fi

    #incrise y of mario if r6
    if
      tst r6
    is gt
    ldi r1, 0x0003
      add r1, r3
      inc r6
    fi

    #decrise y of mario
    ldi r5, 0x0000
    if
      cmp r3, r2
    is gt
      ldi r5, 0xff00 #mario x
      ld r5,r5
      ldi r7, 0xff00 #mario y
      ld r7, r7
      dec r7
      jsr check_pixel
      #i f map
      if # if r7 > 0 
        tst r7
      is le #fall if doesnt have map
        ldi r1, 0xffff
        add r1,r3
        ldi r5 , 0x0001 #set r5 for trigger
      fi
    fi

    ldi r5, 0xff01 # mario y
    stb r5, r3
    pop r0

    rts

set_up_r6:
  ldi r5, 0xff00 #mario x
  ld r5,r5
  ldi r7, 0xff00 #mario y + 3
  ldi r2, 3
  ld r7, r7
  add r2,r7
  #i f map
  if
    tst r7
  is le
    ldi r6, 0x0001
  fi

  rts

end