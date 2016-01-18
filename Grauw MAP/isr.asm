

_fake_isr
		push	af
		
		; ld	a,(noscroll)
		; or	a
		; jr	z,1f
		
		push   hl         
		push   de         
		push   bc         
		exx               
		ex     af,af'     
		push   hl         
		push   de         
		push   bc         
		push   af         
		push   iy         
		push   ix         

		ld	hl,(_xmappos)			; corner top left of the screen window in the map in pixels
		ld	a,15
		and	l
		ld	(_xoffset),a			; screen offset
		
		repeat 4
		srl	h
		rr	l
		endrepeat					; corner top left of the screen window in the map in tiles
		
		ld	de,_levelmap+16
		add	hl,de					; HL = corner top right of the screen window in the map in tiles
		
		call	pageswap			; test for page swap
		call	xscroll				; move the screen 			
		call	_brdrs				; build a column right pointed by HL, clear a column left, move a stripe of screen
		
		call _waitvdp				; no need ATM
		
		ld	hl,(_xmappos)
		inc	hl
		ld	a,15
		and	h
		ld	h,a
		ld	(_xmappos),hl			; scroll one pixel right

		ld	hl,(_jiffy)				; timer
		inc	hl
		ld	(_jiffy),hl
				
		xor		a
		out		(0x99),a
		ld		a,7+128
		out		(0x99),a
		
		pop    ix         
		pop    iy         
		pop    af         
		pop    bc         
		pop    de         
		pop    hl         
		ex     af,af'     
		exx               
		pop    bc         
		pop    de         
		pop    hl         

1:		
		xor	a 			; read S#0
		out (0x99),a
		ld a,128+15
		out (0x99),a
		in	a,(0x99)
		pop	af
		ei
		ret

 ;-------------------------------------
