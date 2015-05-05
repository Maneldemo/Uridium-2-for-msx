 
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
	and	a
	ret nz
	di
	ld	a,r
	out		(0x99),a
	ld		a,7+128
	out		(0x99),a
	ei
	ret