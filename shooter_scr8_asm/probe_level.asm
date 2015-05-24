 
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
	star_data	 32,64+10, 32/16+(10/16)*256
	star_data	208,64+50,208/16+(50/16)*256
	star_data	128,64+52,128/16+(52/16)*256
starlist2:
    star_data	 16,64+5,  16/16+((64+ 5)/16)*256
    star_data	 48,64+17, 48/16+((64+17)/16)*256
	star_data	112,64+26,112/16+((64+26)/16)*256
starlist3:
    star_data	 48,64+17, 48/16+((128+17)/16)*256
	star_data	112,64+26,112/16+((128+26)/16)*256
	star_data	224,64+42,224/16+((128+42)/16)*256
	
test_star:
	di
	ld	a,(_xoffset)
[4]	add	a,a
	ld  c,a
	
	ld	a,(_displaypage)
[2]	add	a,a
	ld	b,a
	
	ld	ix,starlist
	call	.star_loop	

	inc	b
	ld	a,b

	call	.star_loop

	inc	b
	ld	a,b

	call	.star_loop

	ld	a,(_xoffset)		
	ld	(__xoffset),a
	ei
	ret
	
.star_loop
	out (0x99),a ;set bits 14-16
	ld a,14+128
	out (0x99),a


	repeat 3
1:	ld	e,(ix+star_data.add)
	ld	d,(ix+star_data.add+1)
	ld	hl,(_levelmap_pos)
	add	hl,de
	ld	a,(hl)
	and	a
	jp	nz,2f
	ld	a,(__xoffset)		; compensate R#18 
	add	a,(ix+star_data.x)
	out (0x99),a
	ld a,(ix+star_data.y) 	;	set bits 8-13
	out (0x99),a
	xor	a
	out	(0x98),a
	call	.set_star
2:	ld	de,star_data
	add	ix,de
	endrepeat
	ret
	
.set_star:
	ld	a,c
	cp	(ix+star_data.x)
	ret	z
	ld	a,(_xoffset)		; compensate R#18 
	add	a,(ix+star_data.x)
	out (0x99),a
	ld a,(ix+star_data.y) 	;	set bits 8-13
	out (0x99),a
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
