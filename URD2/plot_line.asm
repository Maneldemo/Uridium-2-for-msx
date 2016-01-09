;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; no input
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	

blank_line:
	di
	ld 		a, 36
	out 	(0x99),a
	ld 		a, 17+128
	out 	(0x99),a

	call _waitvdp		; no need ATM
	
	ld		a,(_xoffset)
	add		a,e
	out 	(0x9B), a 			; dx
	xor a
	out 	(0x9B), a			; dx (high)
	
	out 	(0x9B), a			; dy
	ld 		a,(_displaypage)	; destination page
	out 	(0x9B), a			; dy (high-> page 0 or 1)
	
	ld		a,1
	out 	(0x9B), a			; x block size
	xor a
	out 	(0x9B), a

	ld		a,mapHeight*16
	out 	(0x9B), a			; y block size
	xor a
	out 	(0x9B), a

	out 	(0x9B), a			; color
	out 	(0x9B), a

	ld		a,11000000B
	out 	(0x9B), a		; command HMMV
	ei
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; no input
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

plot_line_lft1:
	ld	hl,(_levelmap_pos)
	ld	e,0
	jp plot_line1
plot_line_lft2:
	ld	hl,(_levelmap_pos)
	ld	e,0
	jp plot_line2


; plot_line_lft:
	; ld	hl,(_levelmap_pos)
	; ld	e,0
	; jp plot_line
	
plot_line_rgt1:
	ld	hl,(_levelmap_pos)
	ld	de,15
	add	hl,de
	ld	e,240
	jp plot_line1
plot_line_rgt2:
	ld	hl,(_levelmap_pos)
	ld	de,15
	add	hl,de
	ld	e,240
	jp plot_line2
	
; plot_line_rgt:
	; ld	hl,(_levelmap_pos)
	; ld	de,15
	; add	hl,de
	; ld	e,240
	; jp plot_line
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; input
; de = y,x configured in window map 256x256
; a  tile to be plot
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
plot_tile:
		push	de
		exx
		pop		de
		
		ld	h,a
[3]		rlca
		and	00000111B
		add	a,:_tiles0
		ld	(_kBank4),a
		ld	a,h
		and	00011111B
		add	a,high _tiles0
		ld	h,a
		ld	l,0

		ld	a,(_displaypage)
					; de = y*256+x
		rlc d		; set VDP for writing at address ADE (17-bit) ;
		rla
		rlc d
		rla
		srl d 		 ; first shift
		di
		out (0x99),a	; set bits 14-16
		ld a,14+128
		out (0x99),a
		ei
		srl d 		 ;  second shift.     
		set 6,d		 ;  write access

		ld	bc,16*256+0x98
	
2:		push	bc
		ld	b,16
		di
1:		ld a,e 		;set bits 0-7
		out (0x99),a
		ld a,d 		;set bits 8-13
		out (0x99),a
		inc	d
		outi
		jp nz,1b
		ei
		ld	a,-16
		add	a,d
		ld	d,a
		inc	e
		pop	bc
		djnz 2b
		exx
		ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 		
init_page0:
		ld		a,(_displaypage)
		ld		d,a
		ld		e,240
		call	clrboder
		ld		hl,(_levelmap_pos)
		ld		de,0x0000			; e=x=0, d=y=0
		
		ld		b,11
2:		push	bc
		ld		b,15
1:		ld		a,(hl)
		call 	plot_tile
		inc		hl
		ld	a,16
		add	a,e
		ld	e,a
		djnz	1b
				
		ld	e,b
		ld	a,16
		add	a,d
		ld	d,a
		ld	bc,mapWidth-15
		add	hl,bc
		pop	bc
		djnz	2b
		ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 		
; init_page1:
		; ld		a,(_displaypage)
		; ld		d,a
		; ld		e,0
		; call	clrboder
		; ld		hl,(_levelmap_pos)
		; ld		de,0x0010			; e=x=16, d=y=0
		
		; ld		b,11
; 2:		push	bc
		; ld		b,15
; 1:		ld		a,(hl)
		; call 	plot_tile
		; inc		hl
		; ld	a,16
		; add	a,e
		; ld	e,a
		; djnz	1b
		
		; ld	e,0x10
		; ld	a,e
		; add	a,d
		; ld	d,a
		; ld	bc,mapWidth-15
		; add	hl,bc
		; pop	bc
		; djnz	2b
		; ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; input
; d = page
; e = dx
; l = background color
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
clrboder:
	di
	ld 		a, 36
	out 	(0x99),a
	ld 		a, 17+128
	out 	(0x99),a
	
	call _waitvdp
	
	ld		a,e
	out 	(0x9B), a 			; dx
	xor		a
	out 	(0x9B), a			; dx (high)
	
	out 	(0x9B), a			; dy
	ld 		a,d					; destination page
	out 	(0x9B), a			; dy (high-> page 0 or 1)
	
	ld a,16
	out 	(0x9B), a			; x block size
	xor	a
	out 	(0x9B), a

	ld		a,mapHeight*16
	out 	(0x9B), a			; y block size
	xor a
	out 	(0x9B), a

	ld		a,border_color
	out 	(0x9B), a			; color
	xor a
	out 	(0x9B), a

	ld		a,11000000B
	out 	(0x9B), a		; command HMMV
	ei
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; input
; e = sx	from not _displaypage
; d = dx	to _displaypage
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

move_block:
	di
	ld 		a, 32
	out 	(0x99),a
	ld 		a, 17+128
	out 	(0x99),a

	ld 		c, 0x9B
	
	call _waitvdp		; no need ATM
	
	out		(c), e 		; sx
	xor a
	out		(0x9B), a 	; sx (high)
	
	out		(0x9B), a 	; sy
	ld 		a,(_displaypage)	; source page
	out 	(0x9B), a 	; sy 	(high-> page 0 or 1)

	out 	(c), d 		; dx
	xor a
	out 	(0x9B), a	; dx (high)
	
	out 	(0x9B), a 		; dy
	ld 		a,(_displaypage)	; destination page
	xor	1				
	out 	(0x9B), a	; dy 	(high-> page 0 or 1)

	ld 		a,16 		; block size
	out 	(0x9B), a
	xor a
	out 	(0x9B), a	
	ld		a,mapHeight*16
	out 	(0x9B), a
	xor		a
	out 	(0x9B), a
	out 	(0x9B), a
	out 	(0x9B), a

	ld		a,11010000B
	out 	(0x9B), a		; command HMMM
	ei
	ret
	