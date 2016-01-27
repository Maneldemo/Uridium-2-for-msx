

xscroll:
		ld		a,(_xoffset)		; set R#18 

		add		a,-8
		and		0Fh
		out		(099h),a
		ld		a,18+128
		out		(099h),a
		
		ret

pageswap:

		ld		a,(_displaypage)
		and		a
		ld		a,00011111B			; page 0
		jr		z,1f
		ld		a,00111111B			; page 1
1:		out 	(0x99),a
		ld 		a,2+128
		out 	(0x99),a
		ret
		
		
set_displaypage:
		ld		a,(_displaypage)
		ld		l,a
		ld		a,(_xmappos)
		and		16
		jr		z,1f
		ld		a,1
1:		ld		(_displaypage),a		
		xor	l
		ret	z
		; page has changed !
		ld	(_sliceflag_reset),a
		ret
		
