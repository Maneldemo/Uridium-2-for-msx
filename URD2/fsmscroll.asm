

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
		ld	(_sliceflag_reset),a 	; page has changed !
		ret

reset_sliceflag:
		ld	a,(_sliceflag_reset)
		and	a
		ret	z	;  _sliceflag_reset testing

		exx		; clear _sliceflag and _sliceflag_reset
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
		inc	hl
		ld	a,h
		cp	1
		ret	nc
		ld	(_xspeed),hl
		ret
		
.notright:
		bit 4,l
		ret	nz
		
		ld	hl,(_xspeed)
		dec	hl
		ld	a,-1
		cp	h
		ret	p
		ld	(_xspeed),hl
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
		
