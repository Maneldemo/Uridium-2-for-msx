;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; update main ship
;
	
_plot_spt:
	ld		c,0
	ld		de,0F000h
	call	_vdpsetvramwr
	
	ld	a, :ms_spt
	ld	(_kBank4),a

	ld	hl,(aniframe)
	ld	a,l
	cp	h
	ret	z
	ld	(old_aniframe),a
	ld	hl,ms_ani
	ld	c,a
	ld	b,0
	add	hl,bc
	ld	l,(hl)
	ld	h,b
[5]	add hl,hl
	ld	e,l
	ld	d,h
	add	hl,hl
	add	hl,de
	ld	de,ms_spt
	add hl,de
	ld	c,0x98
	call	out48
	ld	a,-1
	ld	(_mccolorchange),a
out48:
[16]	outi
out32:
[2*16]	outi
	ret
	

set_manta_color
	ld	a,(_mccolorchange)
	and	a
	ret z

	ld a,e 					; set bits 0-7
	out (0x99),a
	ld a,d 					; set bits 8-13 with write access
	out (0x99),a

	xor	a
	ld	(_mccolorchange),a
	
	ld	a, :manta_color
	ld	(_kBank4),a
	
	ld	bc,(aniframe)
	ld	b,0
	ld	hl,ms_ani
	add	hl,bc
	ld	l,(hl)
	ld	h,b
[5]	add hl,hl
	ld  bc,manta_color
	add	hl,bc
	ld	c,0x98
	call	out32
	xor	a
[16]	out	(0x98),a
	ret
		

color_enemy:
	call 	_plot_spt
	ld	a,(flip_flop)
	and	1
	jp nz, reversecolor_enemy
	
directcolor_enemy:		
		
	ld	a,3
	out (0x99),a 		;set bits 14-16 of F800h
	ld a,14+128
	out (0x99),a
		
	ld		de,07800h	; F800h 3 positions  for bullets and manta
	
	call	set_manta_color

	ld	a, :color_base
	ld	(_kBank4),a

	ld		de,16*(3+max_bullets+max_enem_bullets)+07800h	; F800h 6 positions for bullets
	
	ld	ix,enemies		; process two layer enemies

	ld	bc,256*max_enem+0x98
		
1:	bit	0,(ix+enemy_data.status)
	jp	z,.next
		
	ld	a,(ix+enemy_data.frame)
	cp  (ix+enemy_data.color)
	jp	z,.next
	
	ld   (ix+enemy_data.color),a
	
	ld	l,a					; color x 4
	ld	h,0
[2]	add hl,hl				; color x 16
		
	ld	a,high color_base	; nb: the first 16 patterns reserved to mship, explosions and bullets
	add	a,h
	ld	h,a
	
	ld a,e 					; set bits 0-7
	out (0x99),a
	ld a,d 					; set bits 8-13 with write access
	out (0x99),a
	ld	a,b
[32]	outi
	ld b,a

.next
	push bc
	ld	bc,enemy_data
	add ix,bc
	pop bc
	ld hl,32
	add hl,de
	ex de,hl
	
	djnz	1b
	ret

reversecolor_enemy:
	ld		de,07C00h	; FC00h 6 positions for bullets

	ld	a,3
	out (0x99),a 		;set bits 14-16 of F800h
	ld a,14+128
	out (0x99),a
	
	ld	a, :color_base
	ld	(_kBank4),a
	
	ld	ix,enemies+(max_enem-1)*enemy_data
	
	ld	bc,0x98+256*max_enem
	
1:	bit	0,(ix+enemy_data.status)
	jp	z,.next
	
	ld	a,(ix+enemy_data.frame)
	cp  (ix+enemy_data.color2)
	jp	z,.next
	
	ld   (ix+enemy_data.color2),a
	
	ld	l,a					; color x 4
	ld	h,0
[2]	add hl,hl				; color x 16
	
	ld	a,high color_base	; nb: the first 16 patterns reserved to mship, explosions and bullets
	add	a,h
	ld	h,a
	
	ld a,e 					; set bits 0-7
	out (0x99),a
	ld a,d 					; set bits 8-13 with write access
	out (0x99),a
	ld	a,b
[32]	outi
	ld b,a

.next
	push bc
	ld	bc,-enemy_data
	add ix,bc
	pop bc
	ld hl,32
	add hl,de
	ex de,hl
	
	djnz	1b

	ld	de,07C00h+16*(2*max_enem+max_bullets + max_enem_bullets)	; FC00h 6 positions for bullets

	jp	set_manta_color
	
