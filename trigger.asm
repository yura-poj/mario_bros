rsect trigger

get_triggers>
  #r5 is 1 if mario is dropping and is 0 in other situation
  #i f r0 is 0 mario get hurt else enemy
  push r0
  #
  if
    tst r6
  is gt
    ldi r0, 0 #mario is jumping and will get hurt
  else
    if
      tst r5
    is gt
      ldi r0, 1 #mario is getting down and wont get hurt
    else
      ldi r0, 0 #mario is just walking
    fi
  fi

  ldi r1, 0xfe02
  ldi r2, 0xfe06
  
  ldi r3, 0xfe00 #mario x
  ldb r3,r3 

  ldi r4, 0xfe01 #mario y
  ldb r4,r4

  while
    cmp r1, r2
  stays lt
    #перебираем всех врагов
    jsr check
    if
      tst r2
    is gt
      if
        tst r0
      is gt #mario kill enemy
        jsr inc_points
        ldi r2, 0x0001
        sub r1, r2
        
        ldi r5, 0x0020
        stb r2, r5

        inc r2
        ldi r5, 0x001a
        stb r2, r5
      else
        #game over
        ldi r5, 1
        while 
          tst r5
        stays gt
          ldi r4, 0xff01
          ldb r4, r5
          inc r5
          stb r4,r5
        wend
      fi

    fi
    inc r1
    ldi r2, 0xfe06
  wend

  pop r0
  rts

  check:
    push r6
    ldb r1, r5
    sub r3, r5
    if
      tst r5
    is lt
      not r5
      inc r5
    fi
    #r5 is abs(mario x - enemy x)
  
    ldi r2, 0x0002

    if 
      cmp r5, r2
    is le
      ldi r6, 1
    else 
    ldi r6, 0
    fi

    inc r1
    ldb r1, r5
    
    sub r4, r5

    if
      tst r5
    is lt
      not r5
      inc r5
    fi
        #r5 is abs(mario y - enemy y)

    ldi r2, 0x0002

    if 
      cmp r5, r2
    is le
      ldi r2, 1
    else 
      ldi r2, 0
    fi

    and r6, r2 #res if r2  = 1 => mario trigger with enemy

    pop r6
    rts
  
  inc_points:
    push r0
    push r1
    push r2
    ldi r1, 0xff0f
    ld r1,r2
    ldi r0, 0x0010
    add r0, r2
    st r1, r2
    pop r2
    pop r1
    pop r0
    rts
end