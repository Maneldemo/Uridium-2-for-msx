


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


