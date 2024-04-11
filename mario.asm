rsect mario

move_mario>
  push r0

    ldi r0, 0xffee # left right
    ldi r1,0xffef # up down
    ldi r2, 0xfff0 # mario x
    ldi r3, 0xfff1 # mario y

    ldb r0, r0
    ldb r1, r1
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

    if #check for x bigger 0
      tst r2
    is lt
      sub r2, r0
      move r0, r2
    fi

    ldi r4, 0xfff0 # mario x
    st r4, r2

    #check y 
    if
      cmp r1, 0x0001
    is eq
      if
        tst r3
      is le
        ldi r1, 0x0008
        add r1,r3
      fi 
    else
      if
        tst r3
      is gt
        ldi r1, 0xffff
        add r1,r3
      fi
    fi   

    ldi r5, 0xfff1 # mario y
    st r5, r3 # i can't set 0 in logisim
    pop r0

    rts


end