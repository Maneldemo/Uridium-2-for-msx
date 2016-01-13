

xfsm:
		ld		a,(_xoffset)		; set R#18 only if not scrolling

		add		a,-8
		and		0Fh
		out		(099h),a
		ld		a,18+128
		out		(099h),a
		
		ld		a,(_xoffset)
		and		a
		jr		z,x0

x1_15:
		ld		a,(_xoffset)
		dec		a
[4]		add		a,a
		ld		d,a
		add		a,16
		ld		e,a
		call	move_slice

		ld		a,(_xoffset)
		ld		ixl,a
		add		a,240
		ld		e,a
		call	_brdrs
		ret
		
		
x0:
		ld		a,(_displaypage)
		xor		1
		ld		d,a
		ld		e,240
		call 	clear_slice

		ld		ixl,0
		ld		e,240
		call	_brdrs
		ret

hfsm:
		ld		a,(_jiffy)
		and		16
		add 	a,a 		;x32
		or		 00011111B
		out 	(0x99),a
		ld 		a,2+128
		out 	(0x99),a
		ld		a,(_jiffy)
		and		16
		jr		z,1f
		ld		a,1
1:		ld		(_displaypage),a		
		ret
		
