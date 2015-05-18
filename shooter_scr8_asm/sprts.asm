


_hw_sprite_init:

teller:=0
		repeat	4				; 4 SPTs, at 0xD800, 0xE000, 0xE800, 0xF000
		ld		c,0
		ld		de,0F000h-64*32*3+64*32*teller
		call	_vdpsetvramwr
		ld		d, :sprtdata
		ld		e, 1
		call	outvram
teller:=teller+1
		endrepeat
		
		ld		c,0
		ld		de,0FA00h
		call	_vdpsetvramwr

		ld		a,0xD8
		out 	(0x98),a

		ret

		
	; load static colors 
load_colors:
		ld		c,0
		ld		de,0F800h			;	0FA00h-512
		call	_vdpsetvramwr

		call	ship_color
		call	bull_color
		call	enem_color
		
		ld		c,0
		ld		de,0FE00h-512
		call	_vdpsetvramwr
				
		call	enem_color
		call	bull_color
		call	ship_color
		ret
		
ship_color:
		ld	b,16*3
		xor	a
1:
		out	(0x98),a
		djnz 1b		
		ret

bull_color:	
		ld	b,16*(max_bullets+max_enem_bullets)
		ld	a,15
1:
		out	(0x98),a
		djnz 1b		
		ret
		
enem_color:	
		ld	c,2*max_enem
		ld	b,16
		xor	a
1:
		out	(0x98),a
		djnz 1b	
		dec	c
		jr	nz,1b
		ret
