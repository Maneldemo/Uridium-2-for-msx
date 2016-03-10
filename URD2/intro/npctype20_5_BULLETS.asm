; =============================
; NPC20
; 5 linear bullets spread of angle
; alpha in the direction of  MC
; =============================

	ld 		a,	(ix+_NPC_status)
	and		a
	jp		nz, 0f
	;;;;;;;;;;;;;;;;;;;;;;;
	; state 0
	;;;;;;;;;;;;;;;;;;;;;;;
	
	; 1st bullet

	; dx
	ld a,(myX)
	sub a,(ix+_NPC_x)
	ld (ix+_NPC_dx),a
	sbc	a,a
	ld	(ix+_NPC_ddx),a					;DDX = HI byte, DX = LO byte
	
	; dy
	ld a,(myY)
	sub a,(ix+_NPC_y)
	ld (ix+_NPC_dy),a
	sbc	a,a
	ld	(ix+_NPC_ddy),a					;DDY = HI byte, DY = LO byte
	
	ld	a,(ix+_NPC_dx)	
	bit	7,(ix+_NPC_ddx)
	call	sqr							;HL=|A|^2
	ex	de,hl
	
	ld	a,(ix+_NPC_dy)	
	bit	7,(ix+_NPC_ddy)
	call	sqr							;HL=|A|^2
	add	hl,de							;HL = |DX|^2 + |DY|^2
	
	call sqrt							; D = sqrt(|DX|^2 + |DY|^2)

	push	de
	ld	h,(ix+_NPC_dy)
	ld	l,0
	bit	7,(ix+_NPC_ddy)
	call	Div16						; HL = HL /D
	add	hl,hl							; here to increase bullet speed
	ld	(ix+_NPC_dy),l
	ld	(ix+_NPC_ddy),h

	pop	de
	ld	h,(ix+_NPC_dx)
	ld	l,0
	bit	7,(ix+_NPC_ddx)
	call	Div16						; HL = HL /D
	add	hl,hl							; here to increase bullet speed
	ld	(ix+_NPC_dx),l
	ld	(ix+_NPC_ddx),h
	
					; now we have |dx|^2+|dy|^2=1


	ld 		(ix+_NPC_pattern),0x24	
	ld 		(ix+_NPC_color),15
	ld 		(ix+_NPC_status),1
	ld 		(ix+_NPC_xoffset),6		;????????? PLACE RIGHT VALUES HERE
	ld 		(ix+_NPC_yoffset),5	
	ld 		(ix+_NPC_xsize),4
	ld 		(ix+_NPC_ysize),4										

    ld    (ix+_NPC_type),2
    ld    (ix+_NPC_status),1		; bullet is moving

	
	; a=15;
	; cos_a = round(cos(2*pi*a/360)*256) 
	; sin_a = round(sin(2*pi*a/360)*256) 
    
_npc20_cos_a	equ 247
_npc20_sin_a	equ 66

_npc20_cos_2a	equ (_npc20_cos_a*_npc20_cos_a-_npc20_sin_a*_npc20_sin_a)/256
_npc20_sin_2a	equ (_npc20_sin_a*_npc20_cos_a+_npc20_cos_a*_npc20_sin_a)/256

	; 2nd bullet
    call	castbullet     			; Ask for a new bullet
									; in hl npcrecord pointing at status
									
    jp    z,0f                      ; Init failed: no spare room

[3]	dec		hl
	push	hl
	pop		iy						; aiming to the start of the new record

	; dx' = dx*cos(a)-dy*sin(a)

	ld	e,(ix+_NPC_dx)
	ld	d,(ix+_NPC_ddx)
	ld	a,_npc20_cos_a
	call	Mul24
	push	hl				; dx*cos(a)
	
	ld	e,(ix+_NPC_dy)
	ld	d,(ix+_NPC_ddy)
	ld	a,_npc20_sin_a
	call	Mul24			; dy*sin(a)
	pop		de				
	ex		de,hl
	
	and	a
	sbc	hl,de				; dx' = dx*cos(a)-dy*sin(a)
	ld	(iy+_NPC_dx),l
	ld	(iy+_NPC_ddx),h

	add	hl,de
	add	hl,de
	ld	(temp01),hl			; dx*cos(a)+dy*sin(a)
	
	
	; dy' = dy*cos(a)+dx*sin(a)

	ld	e,(ix+_NPC_dy)
	ld	d,(ix+_NPC_ddy)
	ld	a,_npc20_cos_a
	call	Mul24
	push	hl				; dy*cos(a)

	ld	e,(ix+_NPC_dx)
	ld	d,(ix+_NPC_ddx)
	ld	a,_npc20_sin_a
	call	Mul24			; dx*sin(a)
	pop	de					
	ex		de,hl

	and	a
	sbc	hl,de
	ld	(temp02),hl			; dy*cos(a)-dx*sin(a)
	
	add	hl,de
	add	hl,de				; dy' = dy*cos(a)+dx*sin(a)
	ld	(iy+_NPC_dy),l
	ld	(iy+_NPC_ddy),h

	
	ld 		(iy+_NPC_pattern),0x24	
	ld 		(iy+_NPC_color),15
	ld 		(iy+_NPC_status),1
	ld 		(iy+_NPC_xoffset),6		;????????? PLACE RIGHT VALUES HERE
	ld 		(iy+_NPC_yoffset),5	
	ld 		(iy+_NPC_xsize),4
	ld 		(iy+_NPC_ysize),4										

    ld    (iy+_NPC_type),2
    ld    (iy+_NPC_status),1		; bullet is moving


	; 3rd bullet
	call	castbullet     			; Ask for a new bullet
									; in hl npcrecord pointing at status
									
    jp    z,0f                      ; Init failed: no spare room

[3]	dec		hl
	push	hl
	pop		iy						; aiming to the start of the new record

	
	ld	hl,(temp01)
	ld	(iy+_NPC_dx),l
	ld	(iy+_NPC_ddx),h
	
	ld	hl,(temp02)
	ld	(iy+_NPC_dy),l
	ld	(iy+_NPC_ddy),h
	
	ld 		(iy+_NPC_pattern),0x24	
	ld 		(iy+_NPC_color),15
	ld 		(iy+_NPC_status),1
	ld 		(iy+_NPC_xoffset),6		;????????? PLACE RIGHT VALUES HERE
	ld 		(iy+_NPC_yoffset),5	
	ld 		(iy+_NPC_xsize),4
	ld 		(iy+_NPC_ysize),4										

    ld    (iy+_NPC_type),2
    ld    (iy+_NPC_status),1		; bullet is moving

	; 4th bullet
    call	castbullet     			; Ask for a new bullet
									; in hl npcrecord pointing at status
									
    jp    z,0f                      ; Init failed: no spare room

[3]	dec		hl
	push	hl
	pop		iy						; aiming to the start of the new record

	; dx' = dx*cos(2a)-dy*sin(2a)

	ld	e,(ix+_NPC_dx)
	ld	d,(ix+_NPC_ddx)
	ld	a,_npc20_cos_2a
	call	Mul24
	push	hl				; dx*cos(2a)
	
	ld	e,(ix+_NPC_dy)
	ld	d,(ix+_NPC_ddy)
	ld	a,_npc20_sin_2a
	call	Mul24			; dy*sin(2a)
	pop		de				
	ex		de,hl
	
	and	a
	sbc	hl,de				; dx' = dx*cos(2a)-dy*sin(2a)
	ld	(iy+_NPC_dx),l
	ld	(iy+_NPC_ddx),h

	add	hl,de
	add	hl,de
	ld	(temp03),hl			; dx*cos(2a)+dy*sin(2a)
	
	
	; dy' = dy*cos(2a)+dx*sin(2a)

	ld	e,(ix+_NPC_dy)
	ld	d,(ix+_NPC_ddy)
	ld	a,_npc20_cos_2a
	call	Mul24
	push	hl				; dy*cos(2a)

	ld	e,(ix+_NPC_dx)
	ld	d,(ix+_NPC_ddx)
	ld	a,_npc20_sin_2a
	call	Mul24			; dx*sin(2a)
	pop	de					
	ex		de,hl

	and	a
	sbc	hl,de
	ld	(temp04),hl			; dy*cos(2a)-dx*sin(2a)
	
	add	hl,de
	add	hl,de				; dy' = dy*cos(2a)+dx*sin(2a)
	ld	(iy+_NPC_dy),l
	ld	(iy+_NPC_ddy),h

	
	ld 		(iy+_NPC_pattern),0x24	
	ld 		(iy+_NPC_color),15
	ld 		(iy+_NPC_status),1
	ld 		(iy+_NPC_xoffset),6		;????????? PLACE RIGHT VALUES HERE
	ld 		(iy+_NPC_yoffset),5	
	ld 		(iy+_NPC_xsize),4
	ld 		(iy+_NPC_ysize),4										

    ld    (iy+_NPC_type),2
    ld    (iy+_NPC_status),1		; bullet is moving


	; 5th bullet
	call	castbullet     			; Ask for a new bullet
									; in hl npcrecord pointing at status
									
    jp    z,0f                      ; Init failed: no spare room

[3]	dec		hl
	push	hl
	pop		iy						; aiming to the start of the new record

	
	ld	hl,(temp03)
	ld	(iy+_NPC_dx),l
	ld	(iy+_NPC_ddx),h
	
	ld	hl,(temp04)
	ld	(iy+_NPC_dy),l
	ld	(iy+_NPC_ddy),h
	
	ld 		(iy+_NPC_pattern),0x24	
	ld 		(iy+_NPC_color),15
	ld 		(iy+_NPC_status),1
	ld 		(iy+_NPC_xoffset),6		;????????? PLACE RIGHT VALUES HERE
	ld 		(iy+_NPC_yoffset),5	
	ld 		(iy+_NPC_xsize),4
	ld 		(iy+_NPC_ysize),4										

    ld    (iy+_NPC_type),2
    ld    (iy+_NPC_status),1		; bullet is moving

0:

    jp    next_npc			


