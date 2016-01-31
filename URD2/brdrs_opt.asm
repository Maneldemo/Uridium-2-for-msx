brdrs_left:
		bdrclr 11100000B
		call	vdp_task_left
		bdrclr 0
		call	_brdrs_left
		ld		a,(_xoffset)
		and		a
		call	z,colmn_patch_left
		bdrclr 11100000B
		ret

brdrs_right:
		bdrclr 11100000B
		call	vdp_task_right
		bdrclr 0
		call	_brdrs_right
		ld		a,(_xoffset)
		cp		15
		call	z,colmn_patch_right
		bdrclr 11100000B
		ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		
vdp_task_left:
		;  _sliceflag management 
		; NOTE _sliceflag has to be byte aligned!!
		
		ld		a,(_xoffset)
		ld		e,a
		ld		d,high _sliceflag
		ld		a,(de)
		and		a
		ret		nz		; avoid twice the same VDP command
		dec		a
		ld		(de),a

		ld		a,e
		cp		15
		jr		nz,.x0_14
.x15:		
		ld		a,(_displaypage)
		xor		1
		ld		d,a
		ld		e,0
		jp 		clear_slice

.x0_14:
[4]		add		a,a
		ld		b,a			; source slice
		add		a,16
		ld		d,a			; destination slice
		jp		move_slice


vdp_task_right:

		;  _sliceflag management 
		; NOTE _sliceflag has to be byte aligned!!
		
		ld		a,(_xoffset)
		ld		e,a
		ld		d,high _sliceflag
		ld		a,(de)
		and		a
		ret		nz		; avoid twice the same VDP command
		dec		a
		ld		(de),a

		ld		a,e
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
_brdrs_left:
		ld		a,(_xoffset)
		ld		e,a
		add		a,240
		ld		ixl,a

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


	; hl -> tile column in the map
		
_brdrs_right:
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
	
	; hl -> tile column in the map + mapHeight
	
colmn_patch_right:
		ld		a,-mapHeight		; return to the start of the column
		add		a,h
		ld 		h,a
		
		set_tile (hl)		; first tile in the column

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
set2pixs:	
		ld 		a,e 			;set bits 0-7
		out 	(0x99),a
		ld 		a,d 			;set bits 8-13
		out 	(0x99),a
		outi	
		inc 	d
		ld 		a,e 			;set bits 0-7
		out 	(0x99),a
		ld 		a,d 			;set bits 8-13
		out 	(0x99),a
		outi	
		ret

	; small patch on first column
	
	; hl -> tile column in the map + mapHeight

colmn_patch_left:
		ld		a,-mapHeight		; return to the start of the column
		add		a,h
		ld 		h,a
		
		set_tile (hl)		; first tile in the column

		ld		h,a
		ld		l,0x00
		
		ld		a,(_displaypage)
		xor		1				; hidden page
[2] 	add 	a,a
		out 	(0x99),a 		; set bits 14-16
		ld 		a,14+128
		out 	(0x99),a

		ld		de,0x4010		; write access, columns 16 on hidden page

		; hl -> tile column in the tile set
		call	set2pixs
		inc		d
		jp		set2pixs
		
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
		set_tile (hl)

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
		
