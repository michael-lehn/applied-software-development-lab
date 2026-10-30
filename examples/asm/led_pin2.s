        sbi     0x0a, 2     ; configure pin 2 as output

loop:   sbi     0x0b, 2     ; set pin 2 HIGH
        nop		    ; do nothing
        nop		    ; do nothing
        cbi     0x0b, 2     ; set pin 2 LOW
	rjmp    loop        ; back to label 'loop' (i.e., 4 instructions back)

