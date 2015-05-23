 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	peek a tile
; in	a:	y (screen coordinate)
;		hl: x (level coordinate)
; out	a:  tile at x,y
;		hl: pointer in level_buffer to  tile
 
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
	
	struct star_data
x	db	0
y	db	0
add	dw	0
	ends
	
starlist:
	star_data	234,62,234/16+(64/16)*256
	star_data	39,10,39/16+(10/16)*256
	star_data	211,50,211/16+(50/16)*256
	star_data	138,52,138/16+(52/16)*256
	star_data	240,56,240/16+(56/16)*256
    star_data	20,5,20/16+(5/16)*256
	star_data	113,26,113/16+(26/16)*256
    star_data	27,17,27/16+(17/16)*256
	
test_star:
	ld	ix,starlist
	
	ld	b,8
1:
	ld	e,(ix+star_data.add)
	ld	d,(ix+star_data.add+1)
	ld	hl,(_levelmap_pos)
	add	hl,de
	ld	a,(hl)
	and	a
	call	z,plot
	ld	de,star_data
	add	ix,de
	djnz	1b
	ret
	
	
plot:
	ld	a,(_displaypage)
	ld	d,(ix+star_data.y)
	ld	e,(ix+star_data.x)
	call	_vdpsetvramwr2
	ld	a,255
	out	(0x98),a
	ret
	
other:
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
