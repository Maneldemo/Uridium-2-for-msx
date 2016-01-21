;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; hl	-> 256 tile data (columnwise)
; destination:
; 	d,e = dy,dx
;	b = page
;
LMMC_tile:
		ld 		a, 36
		out 	(0x99),a
		ld 		a, 17+128
		out 	(0x99),a

		ld		c,0x9B
		out 	(c), e 			; dx
		xor		a
		out 	(0x9B), a		; dx (high)

		out 	(c), d			; dy
								; destination page
		out 	(c), b			; dy (high-> page 0 or 1)
		
		ld 		b,16
		out 	(c), b			; x block size
		out 	(0x9B), a

		out 	(c), b			; y block size
		out 	(0x9B), a

		outi					; 1st byte color
		out 	(0x9B), a		; normal tracing

		ld		a,0xF0			; HMMC
		out 	(0x9B), a

		ld 		a, 44 + 128
		out 	(0x99),a
		ld 		a, 17+128
		out 	(0x99),a
		
		ld		de,15
		ld		b,e					; 15 other bytes
		ld		a,16
		
1:		add		hl,de
		outi						; other byte color
		jp		nz,1b
		ld		b,a					; 16 other bytes
		dec		h
		inc		l
		jp		nz,1b

		xor		a
		out 	(0x99),a
		ld 		a, 46+128
		out 	(0x99),a		; patch: reset vdp commands
		
		ret


animtest:
		ld		d,120
		ld		e,80
		ld		a,(_xoffset)		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; input
; a = tile number	from page 0
; 
; d = dx	to _displaypage
; e = dy	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; destructible tiles have to be in range 0..n-1 in the tile set
; even tiles are the destroyed version
; odd tiles are the integer version

move_tile:
		ld		h,a
		and		00001111B	
[4]		add		a,a					
		ld		l,a			; sx
		ld		a,h
		and		11110000B	; tiles are under the lower border						
		add		a,160+16
		ld		h,a			; sy

		ld 		a, 32
		out 	(0x99),a
		ld 		a, 17+128
		out 	(0x99),a

		ld 		c, 0x9B
		
		; call _waitvdp				; no need ATM
		
		out		(c), l 				; sx
		xor 	a
		out		(0x9B), a 			; sx (high)
		
		out		(c), h 	     		; sy
		ld		a,1					; source page
		out 	(0x9B), a 			; sy 	(high-> page 0 or 1)

		out 	(c), d 				; dx
		xor 	a
		out 	(0x9B), a			; dx (high)
		
		out 	(c), e	 			; dy
		ld 		a,(_displaypage)	; destination page	
		out 	(0x9B), a			; dy 	(high-> page 0 or 1)

		ld 		l,16 				
		out 	(c), l			; x block size
		xor 	a
		out 	(0x9B), a					
		out 	(c), l			; y block size
		out 	(0x9B), a
		out 	(0x9B), a
		out 	(0x9B), a

		ld		a,11010000B
		out 	(0x9B), a			; command HMMM
		ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; input
; b = sx	from not _displaypage
; d = dx	to _displaypage
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

move_slice:
		ld 		a, 32
		out 	(0x99),a
		ld 		a, 17+128
		out 	(0x99),a

		ld 		c, 0x9B
		
		; call _waitvdp				; no need ATM
		
		out		(c), b 				; sx
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
		
		ld 		c, 0x9B
		
		; call _waitvdp
		
		out 	(c), e 			; dx
		xor		a
		out 	(0x9B), a		; dx (high)
		
		out 	(0x9B), a		; dy
								; destination page
		out 	(c), d			; dy (high-> page 0 or 1)
		
		ld 		a,16
		out 	(0x9B), a			; x block size
		xor		a
		out 	(0x9B), a

		ld		a,10*16				; mapHeight*16
		out 	(0x9B), a			; y block size
		xor a
		out 	(0x9B), a

		out 	(0x9B), a			; border_color
		out 	(0x9B), a

		ld		a,11000000B
		out 	(0x9B), a			; command HMMV
		ret
