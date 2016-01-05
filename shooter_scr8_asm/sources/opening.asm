

opening:
		ld		c,0
		ld		d,c
		ld		e,c
		call	_vdpsetvramwr

		ld	de,256*:_opening+7
		call	outvram
		
1:		ld e,8
		call	checkkbd
		and		00000001B
		jr		nz,1b

		call	_cls
		ret
