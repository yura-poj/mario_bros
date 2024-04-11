rsect enemies

set_coordinates>
  push r0

  ldi r0, 0xfff2
  ldi r1, 0xfffc
  ldi r2, 0x0020
  ldi r3, 0x0009
  ldi r4, 0x001f
  while
    cmp r0, r1
  stays le
    st r0, r2
    inc r0
    st r0, r4
    add r3, r2
    inc r0
  wend
  pop r0
rts

move_enemies>
  push r0
  ldi r0, 0xfff2
  ldi r1, 0xfffc

  while
    cmp r0, r1
  stays lt
    #перебираем всех врагов
    ld r0, r2 #set r2 as x of enemy
    if
      tst r2 #bigger than 0
    is gt 
      ldi r3, 0xffff
      add r3, r2 #decrise r2
    else
      ldi r2, 0x002e #el se set enemy to new coordinate
    fi

    st r0,r2

    inc r0
    ld r0, r2 #set r0 as y of enemy

    if
      tst r2 #bigger than 0
    is gt 
      ldi r3, 0xffff
      add r3, r2 #decrise r2
    fi

    st r0,r2
    inc r0

  wend
  pop r0
  rts

end