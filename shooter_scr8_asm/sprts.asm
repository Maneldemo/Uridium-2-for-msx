

_plot_distrucable:

		di
		ld 		a, 32
		out 	(0x99),a
		ld 		a, 17+128
		out 	(0x99),a
		ei

		ld 		c, 0x9B
	
		call _waitvdp

		ld		a,(_xoffset)
[4]		add		a,a
		out		(0x9B), a 		; sx
		xor a
		out		(0x9B), a 	; sx (high)
		
		ld		a,mapHeight*16+32
		out		(0x9B), a 		; sy
		ld		a,1			; source page for animated tiles
		out 	(0x9B), a 	; sy (high-> page 3)
		
		ld		a,(_xoffset)
[2]		add		a,a
		add		a,64
		out 	(0x9B), a 	; dx
		xor a
		out 	(0x9B), a	; dx (high)
	
		ld		a,(yship)
		out 	(0x9B), a	; dy
		ld 		a,(_displaypage)	; destination page
		out 	(0x9B), a	; dy (high-> page 0 or 1)

		ld 		hl,16*257 	; block size

		out 	(c), l
		xor a
		out 	(0x9B), a
		out 	(c), h
		out 	(0x9B), a
		out 	(0x9B), a
		out 	(0x9B), a

		ld		a,11010000B
		out 	(0x9B), a		; command HMMM
		ret


_hw_sprite_init:

		ld		c,0
		ld		de,0F000h
		call	_vdpsetvramwr

		ld		d, :sprtdata
		ld		e, 1
		call	outvram

		ld		c,0
		ld		de,0FA00h
		call	_vdpsetvramwr

		ld		a,0xD8
		out 	(0x98),a

		ret

		
	; load static colors 
load_colors:
		ld		c,0
		ld		de,0FA00h-512
		call	_vdpsetvramwr

		call	3f
		
		ld		c,0
		ld		de,0FE00h-512
		call	_vdpsetvramwr
3:				
		ld	c,32
2:
		ld	b,16
		ld	a,15
1:
		out	(0x98),a
		djnz 1b		
		dec	c
		jp	nz,2b
			
		ret


