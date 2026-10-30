	ldi	r19,	4	    ; for pin 2 (4 = 2^2)
	out	0x0a,	r19
	ldi	r18,	0
loop:
	; pulse width: (r24r23r22r21 * 6 + 7) * 62.5ns
	; r24r23r22r21 = 1 => 13 cycles => 812.5ns
	; r24r23r22r21 = 2 => 19 cycles => 1187.5ns
	eor	r18,	r19	    ; 1 cycle
	out	0x0b,	r18	    ; 1 cycle

	ldi	r24,	0x54	    ; 1 cycle
	ldi	r25,	0x58	    ; 1 cycle
	ldi	r26,	0x14	    ; 1 cycle
	ldi	r27,	0x00	    ; 1 cycle
delay:
	subi	r24,	1	    ; 1 cycle
	sbci	r25,	0	    ; 1 cycle
	sbci	r26,	0	    ; 1 cycle
	sbci	r27,	0	    ; 1 cycle
	brne	delay		    ; 2 cycles if the branch is taken, 1 cycle otherwise

	rjmp	loop		    ; 2 cycles
