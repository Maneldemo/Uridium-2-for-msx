

fsm:
		ld		a,(_xoffset)		; set R#18 only if not scrolling
		ld		b,a

		add		a,-8
		and		0Fh
		out		(099h),a

		ld		a,18+128
		out		(099h),a
	
		djnz	99f
		jp		x1
99:		djnz	99f
		jp		x2
99:		djnz	99f
		jp		x3
99:		djnz	99f
		jp		x4
99:		djnz	99f
		jp		x5
99:		djnz	99f
		jp		x6
99:		djnz	99f
		jp		x7
99:		djnz	99f
		jp		x8
99:		djnz	99f
		jp		x9
99:		djnz	99f
		jp		x10
99:		djnz	99f
		jp		x11
99:		djnz	99f
		jp		x12
99:		djnz	99f
		jp		x13
99:		djnz	99f
		jp		x14
99:		djnz	99f
		jp		x15
99:		jp		x0

x0:		ld		a,(_displaypage)
		ld		d,a
		ld		e,240
		call 	clear_slice
		ret
x1:		ld		e,16
		ld		d,0
		call	move_slice
		ld		ixl,0
		ld		e,240
		call	_brdrs
		ret
x2:		ld		e,16*2
		ld		d,16
		call	move_slice
		ld		ixl,1
		ld		e,241
		call	_brdrs
		ret
x3:		ld		e,16*3
		ld		d,16*2
		call	move_slice
		ld		ixl,2
		ld		e,242
		call	_brdrs
		ret
x4:		ld		e,16*4
		ld		d,16*3
		call	move_slice
		ld		ixl,3
		ld		e,243
		call	_brdrs
		ret
x5:		ld		e,16*5
		ld		d,16*4
		call	move_slice
		ld		ixl,4
		ld		e,244
		call	_brdrs
		ret
x6:		ld		e,16*6
		ld		d,16*5
		call	move_slice
		ld		ixl,5
		ld		e,245
		call	_brdrs
		ret
x7:		ld		e,16*7
		ld		d,16*6
		call	move_slice
		ld		ixl,6
		ld		e,246
		call	_brdrs
		ret
x8:		ld		e,16*8
		ld		d,16*7
		call	move_slice
		ld		ixl,7
		ld		e,247
		call	_brdrs
		ret
x9:		ld		e,16*9
		ld		d,16*8
		call	move_slice
		ld		ixl,8
		ld		e,248
		call	_brdrs
		ret
x10:	ld		e,16*10
		ld		d,16*9
		call	move_slice
		ld		ixl,9
		ld		e,249
		call	_brdrs
		ret
x11:	ld		e,16*11
		ld		d,16*10
		call	move_slice
		ld		ixl,10
		ld		e,250
		call	_brdrs
		ret
x12:	ld		e,16*12
		ld		d,16*11
		call	move_slice
		ld		ixl,11
		ld		e,251
		call	_brdrs
		ret
x13:	ld		e,16*13
		ld		d,16*12
		call	move_slice
		ld		ixl,12
		ld		e,252
		call	_brdrs
		ret	
x14:	ld		e,16*14
		ld		d,16*13
		call	move_slice
		ld		ixl,13
		ld		e,253
		call	_brdrs
		ret
x15:	ld		e,16*15
		ld		d,16*14
		call	move_slice
		ld		ixl,14
		ld		e,254
		call	_brdrs
		ret
		
		
		
		
		
		