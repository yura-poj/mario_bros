asect 0 
main: ext            # Declare labels 
default_handler: ext # as external


macro popit/0
  pop r7
  pop r6
  pop r5
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
  push r5
  push r6
  push r7
mend

# Interrupt vector table (IVT) 
# Place a vector to program start and 
# map all internal exceptions to default_handler 
dc main, 0 	       # Startup/Reset vector 
dc default_handler, 0 # Unaligned SP 
dc default_handler, 0 # Unaligned PC 
dc default_handler, 0 # Invalid instruction 
dc default_handler, 0 # Division by zero 
align 0x80 # Reserve space for the rest of IVT 

# Exception handlers section 
rsect exc_handlers # This handler halts processor 
default_handler> halt 

# Main program section 
rsect main 
move_mario: ext
move_earth_enemies: ext
move_sky_enemies: ext
set_coordinates: ext
get_triggers: ext
set_up: ext
main>
  jsr set_up
  jsr set_coordinates
  ldi r0, 0x0001
  ldi r1, 0xff00
  ldi r2, 0xff01
  ldi r3, 0x0002
  stb r1, r3
  stb r2, r3
  while 
    tst r0  
  stays gt
    jsr inc_points
    jsr move_earth_enemies
    jsr move_sky_enemies
    jsr move_mario
    jsr get_triggers
    jsr update_screen
  wend

  halt

  inc_points:
    ldi r1, 0xff0f
    ld r1,r2
    inc r2
    st r1, r2
    rts

  update_screen:
    ldi r1, 0xfe00
    ldi r2, 0xff00
    ldi r3, 0
    ldi r4, 7
    while
      cmp r3,r4
    stays lt
      ldb r1, r5
      st r2, r5

      inc r1
      inc r2
      inc r3
    wend

    rts
end.


