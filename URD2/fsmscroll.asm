

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
		ld		hl,(_xmappos)		; corner top left of the screen window in the map in pixels
		ld		a,15
		and		l
		ld		(_xoffset),a		; screen offset

		ld		a,(_displaypage)
		ld		h,a

		ld		a,16
		and		l
		
		jr		z,1f
		
		ld		a,1
		
1:		ld		(_displaypage),a
		xor		h
		ret		z	
		ld		(_sliceflag_reset),a 	; page has changed !
		ret

reset_sliceflag:
		ld		a,(_sliceflag_reset)
		and		a
		ret		z	; _sliceflag_reset testing

		exx			; clear _sliceflag and _sliceflag_reset
		ld	bc,16			
		ld	hl,_sliceflag
		ld	de,_sliceflag+1
		ld	(hl),b
		ldir
		exx
		ret
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; test code to move a marker
;
; returns
; _xspeed change pressing right and left

changespeed:		
		ld	a,(joystick)
		ld	l,a
		
		bit 7,l
		jr	nz,.notright

		ld	hl,(_xspeed)
		ld	a,h
		dec	h
		ret	p		; if hl>1.0 exit
		inc	hl
		inc	h
		ld	(_xspeed),hl
		xor	h
		and	128							;dir change neg to pos
		ld		(_dxchng),a 			; direction has changed !
		ret	z		
		ld		(_sliceflag_reset),a 	; reset slice flags
		ret
		
.notright:
		bit 4,l
		ret	nz
		
		ld	hl,(_xspeed)
		ld	a,h
		dec	hl
		inc	h
		ret	m		; if hl<-1.0 exit
		dec	h
		ld	(_xspeed),hl
		xor	h
		and	128							;dir change neg to pos
		ld		(_dxchng),a 			; direction has changed !
		ret	z
		ld		(_sliceflag_reset),a 	; reset slice flags
		ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				
changexpos:
		ld	de,(_xspeed)
		ld	a,(_xmappos+2)
		add	a,e
		ld	(_xmappos+2),a
		ld	e,d
		bit	7,d
		ld	d,0
		jr	z,1f
		ld	d,-1
1:		ld	hl,(_xmappos)
		adc	hl,de
		ld	a,h
		and	15
		ld	h,a
		ld	(_xmappos),hl			; scroll one pixel right
		ret
		
