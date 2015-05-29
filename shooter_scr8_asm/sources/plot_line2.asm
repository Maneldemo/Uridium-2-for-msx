plot_line1:
	ld	a,(_xoffset)
	add a,e
	ld	e,a		; de = y*256+x

	ld	a,(_displaypage)
[2] add a,a
	di
	out (0x99),a 	; set bits 14-16
	ld a,14+128
	out (0x99),a
	ei
	ld	d,0x40		; write access
	jp	_1stblock	; trace 16 pixels

plot_line2:
	inc	h
	ld	a,(_xoffset)
	add a,e
	ld	e,a		; de = y*256+x

	ld	a,(_displaypage)
[2] add a,a
	di
	out (0x99),a 	; set bits 14-16
	ld a,14+128
	out (0x99),a
	ei
	ld	d,0x50		; write access
	call	_2nd	; trace 48 pixels
	
	ld	a,(_displaypage)
[2] add a,a
	or	1
	di
	out (0x99),a 	; set bits 14-16
	ld a,14+128
	out (0x99),a
	ei
	ld	d,0x40		; write access
	call	_1st	; trace 64 pixels
	
	ld	a,(_displaypage)
[2] add a,a
	or	2
	di
	out (0x99),a 	; set bits 14-16
	ld a,14+128
	out (0x99),a
	ei
	ld	d,0x40		; write access
	call	_2nd	; trace 48 pixels

	ret


; plot_line:
	; ld	a,(_xoffset)
	; add a,e
	; ld	e,a		; de = y*256+x

	; ld	a,(_displaypage)
; [2] add a,a
	; di
	; out (0x99),a 	; set bits 14-16
	; ld a,14+128
	; out (0x99),a
	; ei
	; ld	d,0x40		; write access
	; call	_1st
	
	; ld	a,(_displaypage)
; [2] add a,a
	; or	1
	; di
	; out (0x99),a 	; set bits 14-16
	; ld a,14+128
	; out (0x99),a
	; ei
	; ld	d,0x40		; write access
	; call	_1st	
	
	; ld	a,(_displaypage)
; [2] add a,a
	; or	2
	; di
	; out (0x99),a 	; set bits 14-16
	; ld a,14+128
	; out (0x99),a
	; ei
	; ld	d,0x40		; write access
	; call	_2nd

	; ret
	
_1stblock:
; hl ->   Map in RAM
	ld	a,(hl)
[3]	rlca
	and	00000111B
	add	a,:_tiles0
	ld	(_kBank4),a
	ld	a,(hl)
	and	00011111B
	add	a,high _tiles0
	ld	h,a
	ld	a,(_xoffset)
[4]	add	a,a
	ld	l,a

	; hl -> tile column

	ld	bc,16*256+0x98
	di
1:	ld a,e 		;set bits 0-7
	out (0x99),a
	ld a,d 		;set bits 8-13
	out (0x99),a
	inc	d
	outi
	jp	nz,1b
	ei
	ret
	
_1st:
; hl ->   Map in RAM
	push	hl
		
	ld	a,(hl)
[3]	rlca
	and	00000111B
	add	a,:_tiles0
	ld	(_kBank4),a
	ld	a,(hl)
	and	00011111B
	add	a,high _tiles0
	ld	h,a
	ld	a,(_xoffset)
[4]	add	a,a
	ld	l,a

	; hl -> tile column

	ld	bc,16*256+0x98
	di
1:	ld a,e 		;set bits 0-7
	out (0x99),a
	ld a,d 		;set bits 8-13
	out (0x99),a
	inc	d
	outi
	jp	nz,1b
	ei
	
	pop	hl
	inc h
_2nd:
	repeat 3
	push	hl
		
	ld	a,(hl)
[3]	rlca
	and	00000111B
	add	a,:_tiles0
	ld	(_kBank4),a
	ld	a,(hl)
	and	00011111B
	add	a,high _tiles0
	ld	h,a
	ld	a,(_xoffset)
[4]	add	a,a
	ld	l,a

	; hl -> tile column

	ld	bc,16*256+0x98
	di
1:	ld a,e 		;set bits 0-7
	out (0x99),a
	ld a,d 		;set bits 8-13
	out (0x99),a
	inc	d
	outi
	jp	nz,1b
	ei
	
	pop	hl
	inc h
	endrepeat
	ret
	