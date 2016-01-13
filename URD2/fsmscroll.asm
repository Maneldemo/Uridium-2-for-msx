

xfsm:
		ld		a,(_xoffset)		; set R#18 only if not scrolling

		add		a,-8
		and		0Fh
		out		(099h),a
		ld		a,18+128
		out		(099h),a
		
		ret

hfsm:
		ld		a,(_xmappos)
		and		16
		add 	a,a 		;x32
		or		 00011111B
		out 	(0x99),a
		ld 		a,2+128
		out 	(0x99),a
		ld		a,(_xmappos)
		and		16
		jr		z,1f
		ld		a,1
1:		ld		(_displaypage),a		
		ret
		
