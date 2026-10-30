	ldi	r19,	4	    ; r19 = mask for pin 2 (note: 4 = 2^2)
	out	0x0a,	r19	    ; pin 2 as output
	ldi	r18,	0	    ; r18 = 0
loop:
	eor	r18,	r19	    ; r18 = r18 XOR r19 ("toggle")
	out	0x0b,	r18	    ; set pin 2 HIGH or LOW
	rjmp	loop
