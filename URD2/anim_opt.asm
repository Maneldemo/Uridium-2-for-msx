	
		; ld		a,(_xoffset)		
; [4]		add		a,a					
		; cp		d
		
		; if _xoffset*16 =>dx 	
			; b = _displaypage
		; else	
			; b = _displaypage xor 1

		; jr		nc,1f
		
		; ld 		a,(_displaypage)	; destination page	
		; xor		1
		; ld		b,a	
		; ld		a,16
		; add		a,d
		; ld		d,a
		; ld		a,14	
		; jp move_tile
		
; 1:		ld 		a,(_displaypage)	; destination page	
		; ld		b,a		
		; ld		a,15	
		; jp move_tile

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


animtest:
		ld	a,(anim_buffer.flag)
		and	a
		jr	nz,.manage_buffer

		call 	movemarker

		ld	a,e
		ld	(anim_buffer.dy),a
		
		ld		a,(_xspeed+1)
		rlc a
		ld	a,d
		jp	c,.scroll_left
		sub	a,16
		jr		1f
.scroll_left:
		add	a,16
1:		ld	(anim_buffer.dx),a
		
		ld 		a,(_displaypage)	; destination page	
		ld		b,a		
		xor		1
		ld		(anim_buffer.page),a
		
		ld		a,15	
		ld		(anim_buffer.tile),a
		ld		(anim_buffer.flag),a
		
		jp move_tile

	
.manage_buffer:
		xor	a
		ld	(anim_buffer.flag),a
		
		ld	a,(anim_buffer.dy)
		ld	e,a
		
		ld	a,(anim_buffer.dx)
		ld	d,a
		
		ld	a,(anim_buffer.page)
		ld	b,a
		
		ld	a,15	; c
		jp move_tile
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; test code to move a marker
;
; returns
; d = dx	
; e = dy	

movemarker:		
		ld	e,8
		call	checkkbd
		ld	(joystick),a

		bit 7,l
		jr	nz,notright
		ld	a,(_xtest)
		add	a,16
		ld	(_xtest),a
		jr	1f
notright:
		bit 4,l
		jr	nz,1f
		ld	a,(_xtest)
		sub	a,16
		ld	(_xtest),a
1:		
		ld		a,(_xtest)
		ld		d,a

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
		ld		e,a
		ret
		
		
		
