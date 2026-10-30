	ldi	r24,	1 << 2	    ; for pin 2 (4 = 2^2)
	ldi	r25,	0
	out	0x0a,	r24
loop:
	; pulse width: (r21r20 * 4 + 5) * 62.5ns
	; r21r20 = 1 =>  9 cycles => 562.5ns
	; r21r20 = 2 => 13 cycles => 812.5ns
	; ...
	; r21r20 = 65535 => 5+4*65535 cycles => 16385187.5ns = ~16.4ms
	eor	r25,	r24	    ; 1 cycle
	out	0x0b,	r25	    ; 1 cycle

	ldi	r20,	0xFF	    ; 1 cycle
	ldi	r21,	0xFF	    ; 1 cycle
delay:
	subi	r20,	1	    ; 1 cycle
	sbci	r21,	0	    ; 1 cycle
	brne	delay		    ; 2 cycles if the branch is taken, 1 cycle otherwise

	rjmp	loop		    ; 2 cycles
