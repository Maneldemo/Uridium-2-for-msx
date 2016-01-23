_brdrs:
		bdrclr 11100000B

		call	vdp_task

		bdrclr 0

		call	brdrs
		
		ld		a,(_xoffset)
		cp		15
		call	z,colmn_patch

		bdrclr 11100000B

		ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		

vdp_task:
		ld		a,(_xoffset)
		and		a
		jr		nz,.x1_15
.x0:		
		ld		a,(_displaypage)
		xor		1
		ld		d,a
		ld		e,240
		jp 		clear_slice

.x1_15:
[4]		add		a,a
		ld		b,a			; source slice
		sub		a,16
		ld		d,a			; destination slice
		jp		move_slice

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		

	; hl -> tile column in the map
		
brdrs:
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
		call plot_col64

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
	; small patch on last column
	
	; hl -> tile column in the map + 10
	
colmn_patch:
		ld		a,-10		; return to the start of the column
		add		a,h
		ld 		h,a
		
		ld		a,(hl)			; first tile in the column
[3]		rlca
		and		00000111B
		add		a,:_tiles0
		ld		(_kBank4),a
		ld		a,(hl)
		and		00011111B
		add		a,high _tiles0
		ld		h,a
		ld		l,0xF0
		
		ld		a,(_displaypage)
		xor		1				; hidden page
[2] 	add 	a,a
		out 	(0x99),a 		; set bits 14-16
		ld 		a,14+128
		out 	(0x99),a

		ld		de,0x40EF		; write access, columns 239 on hidden page
				
		; hl -> tile column in the tile set
	
		ld 		a,e 			;set bits 0-7
		out 	(0x99),a
		ld 		a,d 			;set bits 8-13
		out 	(0x99),a
		outi	
		inc d
		ld 		a,e 			;set bits 0-7
		out 	(0x99),a
		ld 		a,d 			;set bits 8-13
		out 	(0x99),a
		outi	
		ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
plot_col64:
	; hl -> tile in the map
		call	plot_col32
plot_col32:		
		call	plot_col16
plot_col16:
		push	hl
		call	_plot_col16
		pop		hl
		inc h			; next line in the map 	; inc l for maps stored column-wise
		ret


_plot_col16:
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

	; hl -> tile column in the tile set
	
		repeat 16
		ld a,e 			;set bits 0-7
		out (0x99),a
		ld a,d 			;set bits 8-13
		out (0x99),a
		outi			; 18
		ld	a,ixl 		;set bits 0-7
		out (0x99),a
		ld a,d 			;set bits 8-13
		out (0x99),a
		xor	a
		out	(0x98),a
		inc	d
		endrepeat
		ret
		
