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
move_enemies: ext
set_coordinates: ext
get_triggers: ext
main>
  ldi r0, 0x0001
  ldi r1, 0xfff0
  ldi r2, 0xfff1
  ldi r3, 0x0001
  stb r1, r3
  stb r2, r3
  jsr set_coordinates
  while 
    tst r0  
  stays gt
    jsr move_mario
    jsr move_enemies
    jsr get_triggers
  wend


  halt
end.


