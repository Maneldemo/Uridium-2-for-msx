

opening:
		ld		c,0
		ld		d,c
		ld		e,c
		call	_vdpsetvramwr

		ld	de,256*:_opening+7
		call	outvram
		
1:		call	ms_ctrl.rd_joy
		call	ms_ctrl.z_or_space
		jr		nz,1b

		call	_cls
		
		di
		ld		a,(RG9SAV)		
		and		01111111B		; Set 192 lines
		ld		(RG9SAV),a
		out		(0x99),a
		ld		a,128+9
		out		(0x99),a
		ei
		
		ret
