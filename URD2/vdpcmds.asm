

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; input
; e = sx	from not _displaypage
; d = dx	to _displaypage
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

move_slice:
		ld 		a, 32
		out 	(0x99),a
		ld 		a, 17+128
		out 	(0x99),a

		ld 		c, 0x9B
		
		; call _waitvdp				; no need ATM
		
		out		(c), e 				; sx
		xor a
		out		(0x9B), a 			; sx (high)
		
		out		(0x9B), a 			; sy
		ld 		a,(_displaypage)	; source page
		out 	(0x9B), a 			; sy 	(high-> page 0 or 1)

		out 	(c), d 				; dx
		xor a
		out 	(0x9B), a			; dx (high)
		
		out 	(0x9B), a 			; dy
		ld 		a,(_displaypage)	; destination page
		xor	1				
		out 	(0x9B), a			; dy 	(high-> page 0 or 1)

		ld 		a,16 				; block size
		out 	(0x9B), a
		xor a
		out 	(0x9B), a	
		ld		a,10*16				; mapHeight*16
		out 	(0x9B), a			; y block size
		xor		a
		out 	(0x9B), a
		out 	(0x9B), a
		out 	(0x9B), a

		ld		a,11010000B
		out 	(0x9B), a			; command HMMM
		ret
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; input
; d = page
; e = dx
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
clear_slice:
		ld 		a, 36
		out 	(0x99),a
		ld 		a, 17+128
		out 	(0x99),a
		
		; call _waitvdp
		
		ld		a,e
		out 	(0x9B), a 			; dx
		xor		a
		out 	(0x9B), a			; dx (high)
		
		out 	(0x9B), a			; dy
		ld 		a,d					; destination page
		out 	(0x9B), a			; dy (high-> page 0 or 1)
		
		ld 		a,16
		out 	(0x9B), a			; x block size
		xor	a
		out 	(0x9B), a

		ld		a,10*16				; mapHeight*16
		out 	(0x9B), a			; y block size
		xor a
		out 	(0x9B), a

		ld	a,00011100B
		out 	(0x9B), a			; border_color
		xor a
		out 	(0x9B), a

		ld		a,11000000B
		out 	(0x9B), a			; command HMMV
		ret
