	; hl -> tile column in the map

_brdrs:
		ld		a,(_xoffset)
		ld		ixl,a
		add		a,240
		ld		e,a

		ld	c,0x98
				
		ld	a,(_displaypage)
[2] 	add a,a
		out (0x99),a 	; set bits 14-16
		ld a,14+128
		out (0x99),a

		ld	d,0x40		; write access
		call	plot_col64

		ld		a,(_xoffset)
		and		a
		jr		nz,.x1_15
.x0:		
		ld		a,(_displaypage)
		xor		1
		ld		d,a
		call 	clear_slice

.cont		
		ld	a,(_displaypage)
[2] 	add a,a
		or	1
		out (0x99),a 	; set bits 14-16
		ld a,14+128
		out (0x99),a

		ld	d,0x40		; write access	
		call	plot_col64
		
		ld	a,(_displaypage)
[2] 	add a,a
		or	2
		out (0x99),a 	; set bits 14-16
		ld a,14+128
		out (0x99),a

		ld	d,0x40		; write access	
		call	plot_col32
				
		ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		

.x1_15:
		dec		a
[4]		add		a,a
		ld		d,a
		add		a,16
		ld		b,a
		call	move_slice
		ld		c,0x98
		jr		_brdrs.cont
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
plot_col64:
	; hl -> tile in the map
		repeat 2
		push	hl
		call	plot_col16
		pop		hl
		inc h			; next line in the map
		; inc l
		endrepeat
plot_col32:		
		repeat 2
		push	hl
		call	plot_col16
		pop		hl
		inc h			; next line in the map
		; inc l
		endrepeat
		ret


plot_col16:
		ld	a,(hl)
[3]		rlca
		and	00000111B
		add	a,:_tiles0
		ld	(_kBank4),a
		ld	a,(hl)
		and	00011111B
		add	a,high _tiles0
		ld	h,a
		ld	a,(_xoffset)
[4]		add	a,a
		ld	l,a

	; hl -> tile column in the tileset
	
		repeat 16
		ld	a,ixl 		;set bits 0-7
		out (0x99),a
		ld a,d 			;set bits 8-13
		out (0x99),a
		xor	a
		out	(0x98),a
		ld a,e 			;set bits 0-7
		out (0x99),a
		ld a,d 			;set bits 8-13
		out (0x99),a
		inc	d
		outi			; 18
		endrepeat
		ret
		