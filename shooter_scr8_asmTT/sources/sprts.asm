


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
		ld		de,0F830h			;	0FA00h-512+3*16
		call	_vdpsetvramwr
		call	bull_color
		
		ld		c,0
		ld		de,0FD80h		   ;	0FE00h-512+max_enem*16
		call	_vdpsetvramwr
		call	bull_color
		ret
		

bull_color:	
		ld	b,16*(max_bullets+max_enem_bullets)
		ld	a,15
1:
		out	(0x98),a
		djnz 1b		
		ret
		
