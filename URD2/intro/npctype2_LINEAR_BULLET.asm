; =============================
; NPC 2
; linear bullet
; Moving to MC
; =============================


	ld 		a,	(ix+_NPC_status)
	and		a
	jp		nz, 0f
	;;;;;;;;;;;;;;;;;;;;;;;
	; state 0
	;;;;;;;;;;;;;;;;;;;;;;;
	
	
	; dx
	ld 	a,(myX)
	sub 	a,(ix+_NPC_x)
	ld 	(ix+_NPC_dx),a
	sbc	a,a
	ld	(ix+_NPC_ddx),a					;DDX = HI byte, DX = LO byte
	
	; dy
	ld 	a,(myY)
	sub 	a,(ix+_NPC_y)
	ld 	(ix+_NPC_dy),a
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
	
	call 	sqrt							; D = sqrt(|DX|^2 + |DY|^2)

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


	ld 		(ix+_NPC_pattern),	0x24	
	ld 		(ix+_NPC_color),	15
	ld 		(ix+_NPC_status),1
	ld 		(ix+_NPC_xoffset),6		;????????? PLACE RIGHT VALUES HERE
	ld 		(ix+_NPC_yoffset),5	
	ld 		(ix+_NPC_xsize),4
	ld 		(ix+_NPC_ysize),4										
	
	jp		npc_to_sat

	;;;;;;;;;;;;;;;;;;;;;;;
	; state !=0
	;;;;;;;;;;;;;;;;;;;;;;;
0:				
	; y movement
	ld a,(ix+_NPC_y)
	add a,32
	cp 192+32 		; out of screen?
	jp nc,freeNPC
	cp 32
	jp c,freeNPC
		
	ld a,(ix+_NPC_fy)
	add a,(ix+_NPC_dy)
	ld (ix+_NPC_fy),a
	
	ld a,(ix+_NPC_y)
	adc a,(ix+_NPC_ddy)
	ld (ix+_NPC_y),a
	

	; x movement	
	ld a,(ix+_NPC_x)
	add a,32
	cp 8*24-16+32 		; out of screen?
	jp nc,freeNPC
	cp 32
	jp c,freeNPC
	
	ld a,(ix+_NPC_fx)
	add a,(ix+_NPC_dx)
	ld (ix+_NPC_fx),a
	
	ld a,(ix+_NPC_x)
	adc a,(ix+_NPC_ddx)
	ld (ix+_NPC_x),a
	
	; alternate colors of bullets to catch attention
	ld	a,(ix+_NPC_color)
	xor	8
	ld	(ix+_NPC_color),a

	

	;;;;;;;;;;;;;;;;;;;;;;;
	;  collision test
	;  NPC against SUBWEAP
	;;;;;;;;;;;;;;;;;;;;;;;
	call bullet_collision
	jp c,swhit					
	
	;;;;;;;;;;;;;;;;;;;;;;;
	;  collision test
	;  NPC against MC
	;;;;;;;;;;;;;;;;;;;;;;;	
	ld iy,myState
	call collision						; check for collision
	jp nc, npc_to_sat				; no collision.... continue
	
mchit:	
	ld a,1
	ld (myState),a
swhit:
	jp freeNPC

	
	
	
	




