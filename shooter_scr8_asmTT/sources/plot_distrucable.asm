
_plot_distrucable:

		di
		ld 		a, 32
		out 	(0x99),a
		ld 		a, 17+128
		out 	(0x99),a
		ei

		ld 		c, 0x9B
	
		call _waitvdp

		ld		a,l
[4]		add		a,a
		out		(0x9B), a 		; sx
		xor a
		out		(0x9B), a 		; sx (high)
		
		ld		a,mapHeight*16+32
		out		(0x9B), a 		; sy
		ld		a,1				; source page for animated tiles
		out 	(0x9B), a 		; sy (high-> page 3)
		
		ld		a,e
		out 	(0x9B), a 	; dx	
		xor a
		out 	(0x9B), a	; dx (high)
	
		ld		a,d
		out 	(0x9B), a	; dy
		ld 		a,h			; destination page
		out 	(0x9B), a	; dy (high-> page 0 or 1)

		ld 		hl,16*257 	; block size

		out 	(c), l
		xor a
		out 	(0x9B), a
		out 	(c), h
		out 	(0x9B), a
		out 	(0x9B), a
		out 	(0x9B), a

		ld		a,11010000B
		out 	(0x9B), a		; command HMMM
		ret

