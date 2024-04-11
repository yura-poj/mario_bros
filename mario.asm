rsect mario

move_mario>
  push r0

    ldi r0, 0xffee # left right
    ldi r1,0xffef # up down
    ldi r2, 0xfff0 # mario x
    ldi r3, 0xfff1 # mario y

    ldw r0, r0
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

    ldi r4, 0x0001
    if #check for x bigger 0
      cmp r2, r4
    is lt
      sub r2, r0
      move r0, r2
    fi

    ldi r4, 0xfff0 # mario x
    st r4, r2


    ldi r2, 0x0001
    #check y 
    if
      cmp r1, r2
    is eq
      if
        cmp r3, r2
      is eq
        #i f map
        ldi r6, 0x0001
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
    if
      cmp r3, r2
    is gt
      #i f map
      ldi r1, 0xffff
      add r1,r3
    fi

    ldi r5, 0xfff1 # mario y
    st r5, r3
    pop r0

    rts


end