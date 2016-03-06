		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; test code to move a marker
;
; returns
; d = dx	
; e = dy	

movemarker:		
		ld	a,(joystick)
		ld	l,a

		bit 7,l
		jr	nz,notright
		ld	a,(_xtest)
		add	a,16
		cp	240
		jr	z,1f
		ld	(_xtest),a
		jr	1f
notright:
		bit 4,l
		jr	nz,1f
		ld	a,(_xtest)
		sub	a,16
		jr	z,1f
		ld	(_xtest),a
1:		
		ld	a,(_xtest)
		ld	d,a

		bit 5,l
		jr	nz,notup
		ld	a,(_ytest)
		sub	a,16
		jp	c,1f
		ld	(_ytest),a
		jr	1f
notup:
		bit 6,l
		jr	nz,1f
		ld	a,(_ytest)
		add	a,16
		cp	10*16
		jr	z,1f
		ld	(_ytest),a
1:
		ld	a,(_ytest)
		ld	e,a
		ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
animtest:
		ld	a,(anim_buffer.flag)
		and	a
		jr	nz,.manage_buffer

		ld		a,(_xoffset)		
[4]		add		a,a					
		ld		h,a
		
		
		ld		a,(_xspeed+1)
		rlc a
		jp	c,.scroll_left
		
.scroll_right:			
		ld		a,(_xoffset)	
		cp		15
		jr		nz,.noexceptionr
		call	test_change_page		; if xoffset=15 test for page swap
		jp		nz,.intercept_right		; if page swap intercetp
.noexceptionr
		call 	movemarker
		ld		a,e
		ld		(anim_buffer.dy),a

		ld		a,h
		cp		d
		jp 		c,single_move
		
		ld		a,d
		sub		a,16
		ld		(anim_buffer.dx),a
		jr		1f
		
.scroll_left:
		ld		a,(_xoffset)	
		and		a
		jr		nz,.noexceptionl
		call	test_change_page		; if xoffset=0 test for page swap		
		jp		nz,.intercept_left		; if page swap intercetp
.noexceptionl
		call 	movemarker
		ld		a,e
		ld		(anim_buffer.dy),a

		ld		a,d
		cp		h
		jp 		c,single_move

		ld		a,d
		add		a,16
		ld		(anim_buffer.dx),a
1:		
		ld 		a,(_displaypage)	; destination page	
		ld		b,a		
		xor		1
		ld		(anim_buffer.page),a
		
		ld		a,15	
		ld		(anim_buffer.flag),a

		ld		a,(_xoffset)
		and		15
		ld		(anim_buffer.tile),a
		
		jp 		move_tile
.intercept_right:
		call 	movemarker

		ld 		a,(_displaypage)	; destination page	
		xor		1
		ld		b,a		
		ld		a,(_xoffset)
		and 15
		jp 		move_tile

.intercept_left:
		
		
		ret
	
.manage_buffer:
		xor	a
		ld	(anim_buffer.flag),a
		
		ld	a,(anim_buffer.dy)
		ld	e,a
		
		ld	a,(anim_buffer.dx)
		ld	d,a
		
		ld	a,(anim_buffer.page)
		ld	b,a
		
		ld	a,(anim_buffer.tile)
		jp 	move_tile
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		

test_change_page:
		ld		hl,(_xmappos)		; corner top left of the screen window in the map in pixels
		ld		a,(_displaypage)
		ld		h,a
		ld		a,16
		and		l
		jr		z,1f
		ld		a,1
1:		xor		h
		ret						;	Z if there is no page change
								;	NZ if page changed


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
single_move:
		ld 		a,(_displaypage)	; destination page	
		ld		b,a		
		ld		a,(_xoffset)
		and		15		
		jp 		move_tile
		
