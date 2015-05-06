 
 ;-------------------------------------
 ;	in x = hl, y = a in pixels
 ; 	out tile
 
probe_level:

	ld	bc,_levelmap
[4]	rrca
	and 15
[4]	add	hl,hl
	ld	l,h
	ld	h,a
	add	hl,bc
	ld	a,(hl)
	ret

	
test_star:
	ld	hl,(xship)
	ld	a,(yship)
	call	probe_level
	exx
	ld	hl,_levelmap+256
	ld	bc,13
	cpir
	ret nz
	dec	h
	dec l
	ld  a,(hl)
	exx
	ld  (hl),a
	exx
	ld  a,l
	sub	a,low _levelmap
	ld  l,a
	push	hl					; L block#
		
	ld		a,(_displaypage)
	ld		h,a
	ld		a,(_xoffset)		; compensate R#18 
	add		a,xship_rel
	and		0xF0
	ld		e,a					; destX
	ld		a,(yship)
	and 	0xF0
	ld		d,a					; destY

	push	de
	call	_plot_distrucable
	pop		de
	
	pop		hl
	ld		a,h
	xor		1
	ld		h,a
	
	ret
	ld		a,(dxmap)
	rlc a
	jp	nc,1f		; >0 == dx
					; <0 == sx
	ld	a,-16
	add	a,e
	ld	e,a
	jp		_plot_distrucable
	
1:	ld	a,+16
	add	a,e
	ld	e,a
	jp		_plot_distrucable
