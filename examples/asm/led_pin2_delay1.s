	ldi	r19,	4	    ; for pin 2 (4 = 2^2)
	out	0x0a,	r19	    ; pin 2 as output
	ldi	r18,	0	    ; r18 = 0
loop:
	; pulse width: (r20 * 3 + 4) * 62.5ns
	; r20 = 1 => 437.5ns
	; r20 = 2 => 625ns
	; r20 = 3 => 812.5ns
	; r20 = 4 => 1000ns
	; ...
	; r20 = 255 => 480625ns = ~48us

	eor	r18,	r19	    ; 1 cycle
	out	0x0b,	r18	    ; 1 cycle
	ldi	r24,	0x2	    ; 1 cycle
delay:
	subi	r24,	1	    ; 1 cycle
	brne	delay		    ; 2 cycles if the branch is taken, 1 cycle otherwise

	rjmp	loop		    ; 2 cycles
