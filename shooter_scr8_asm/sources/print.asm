
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

_print_probe
	ld	a,(_mcprobeb)
	ld	e,a
	ld	d,0
	ld	hl,32*(64-2)
	add	hl,de
	ex	de,hl
	ld	hl,2*(23*32+0)
	; call 	plot_foreground
	
	ld	de,(_ticxframe)
	ld	d,0
	ld	bc,_buffer
	call	int2ascii
	
	ld	a,(_buffer+2)
	ld	e,a
	ld	d,0
	ld	hl,32*(64-2)-'0'
	add	hl,de
	ex	de,hl
	ld	hl,2*(22*32)
	; call 	plot_foreground

	ld	a,(_buffer+3)
	ld	e,a
	ld	d,0
	ld	hl,32*(64-2)-'0'
	add	hl,de
	ex	de,hl
	ld	hl,2*(22*32+1)
	; call 	plot_foreground

	ld	a,(_buffer+4)
	ld	e,a
	ld	d,0
	ld	hl,32*(64-2)-'0'
	add	hl,de
	ex	de,hl
	ld	hl,2*(22*32+2)
	; call 	plot_foreground
	ret
	
	
_print_fps:
	ld	a,(_buffer+3)
	ld	e,a
	ld	d,0
	ld	hl,32*(64-2)-'0'
	add	hl,de
	ex	de,hl
	
	ld	hl,2*(23*32+30)
	; call 	plot_foreground

	ld	a,(_buffer+4)
	ld	e,a
	ld	d,0
	ld	hl,32*(64-2)-'0'
	add	hl,de
	ex	de,hl
	
	ld	hl,2*(23*32+31)
	; call 	plot_foreground
	ret

;-------------------------------------
_compute_fps:
	ld	de,(_fps)
	ld	bc,_buffer

int2ascii:
	
; in de input 
; in bc output

	ex  de,hl
	ld  e,c
	ld  d,b

Num2asc:
	ld  bc,-10000
	call    Num1
	ld  bc,-1000
	call    Num1
	ld  bc,-100
	call    Num1
	ld  c,-10
	call    Num1
	ld  c,-1

Num1:   
	ld  a,'0'-1  ; '0' in the tileset

Num2:   
	inc a
	add hl,bc
	jr  c,Num2
	sbc hl,bc

	ld  (de),a
	inc de
	ret
