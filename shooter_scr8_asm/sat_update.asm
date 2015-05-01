
; _plot_enemy:

; __sat_update
	; ld		c,0
	; ld		de,0FA00h
	; call	_vdpsetvramwr
	; ld		hl,_sat
	; ld		bc,0x8098
; 1:	outi
	; ld	a,(_xoffset)		; set R#18 only if not scrolling
	; add	a,(hl)
	; out (0x98),a
	; inc hl
; [2]	outi
	; djnz 1b
	; ret
	
	
plot_enemy:
	ld	a,(flip_flop)
	xor	1
	ld	(flip_flop),a
	jp nz, reverseplot_enemy
	
directplot_enemy:
	; R#5=0xF7 -> sat = FA000
	ld 		a,0xF7
	out (0x99),a
	ld 		a,128+5
	out (0x99),a
	
	ld		c,0
	ld		de,0FA00h	;+4*3	; 3 positions for main ship and its shadow
	call	_vdpsetvramwr
	
	ld	ix,any_object

; process MS bullets and enemy bullets

	ld	bc,0x98+256*(max_bullets + max_enem_bullets)
	
1:	bit 0,(ix+enemy_data.status)
	jp	z,.spriteoff1
	
	ld	l,(ix+enemy_data.x+0)
	ld	h,(ix+enemy_data.x+1)
	ld	de,(xmap)
	xor a
	sbc hl,de				; dx = enemy.x - xmap
	jp	m,.spriteoff1		; dx <0

	or	h
	jp	nz,.spriteoff1		; dx >255

	ld	a,(_xoffset)		; compensate R#18 
	add	a,l
	jp	c,.spriteoff1		; remove if off screen i.e. dx + _xoffset > 255
	cp	240
	jp	nc,.spriteoff1		; remove if dx + _xoffset > 240
	
	ld	d,(ix+enemy_data.y)	; write Y
	out (c),d
	out (c),a				; write X
	ld	a,(ix+enemy_data.frame)
	out (0x98),a			; write shape
	out (c),a				; write crap
	
.next1
	ld	de,enemy_data
	add ix,de
	djnz	1b

; process two layer enemies

	ld	b,max_enem 
1:	bit 0,(ix+enemy_data.status)
	jp	z,.spriteoff2

	ld	l,(ix+enemy_data.x+0)
	ld	h,(ix+enemy_data.x+1)
	ld	de,(xmap)
	xor a
	sbc hl,de				; dx = enemy.x - xmap
	jp	m,.spriteoff2		; dx <0

	or	h
	jp	nz,.spriteoff2		; dx >255

	ld	a,(_xoffset)		; compensate R#18 
	add	a,l
	jp	c,.spriteoff2		; remove if off screen i.e. dx + _xoffset > 255
	cp	240
	jp	nc,.spriteoff2		; remove if dx + _xoffset > 240
	
	ld	d,(ix+enemy_data.y)	
	out (c),d				; write Y
	ld  l,a
	out (0x98),a			; write X

	ld	a,(ix+enemy_data.frame)
	out (0x98),a			; write shape
	out (c),a				; write crap

	out (c),d				; write Y
	out (c),l				; write X
	add	a,4
	out (0x98),a			; write shape
	out (c),a				; write crap
	
.next2
	ld	de,enemy_data
	add ix,de
	djnz	1b
	
	; ld	bc,0x98+4*3*256
	; ld  hl,ram_sat
	; otir

	ld	a,0xD8
	out (0x98),a			; SAT terminator
	ret
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
.spriteoff1
	ld	a,0xD9
[4]	out (c),a				; write crap
	jp	.next1

.spriteoff2
	ld	a,0xD9
[8]	out (c),a				; write crap
	jp	.next2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

reverseplot_enemy:
	; R#5=0xFF -> sat = FE000
	ld 		a,0xFF
	out (0x99),a
	ld 		a,128+5
	out (0x99),a

	ld		c,0
	ld		de,0FE00h	;+4*3	; 3 positions for main ship and its shadow
	call	_vdpsetvramwr

	; ld	ix,any_object+(max_bullets+max_enem_bullets+max_enem-1)*enemy_data
	ld	ix,enemies+(max_enem-1)*enemy_data

; process two layer enemies

	ld	bc,0x98+256*max_enem
	
1:	bit 0,(ix+enemy_data.status)
	jp	z,.spriteoff2
	
	ld	l,(ix+enemy_data.x+0)
	ld	h,(ix+enemy_data.x+1)
	ld	de,(xmap)
	xor a
	sbc hl,de				; dx = enemy.x - xmap
	jp	m,.spriteoff2		; dx <0

	or	h
	jp	nz,.spriteoff2		; dx >255

	ld	a,(_xoffset)		; compensate R#18 
	add	a,l
	jp	c,.spriteoff2		; remove if off screen i.e. dx + _xoffset > 255
	cp	240
	jp	nc,.spriteoff2		; remove if dx + _xoffset > 240
	ld	d,(ix+enemy_data.y)	
	out (c),d				; write Y
	ld  l,a
	out (0x98),a			; write X

	ld	a,(ix+enemy_data.frame)
	out (0x98),a			; write shape
	out (c),a				; write crap

	out (c),d				; write Y
	out (c),l				; write X
	add	a,4
	out (0x98),a			; write shape
	out (c),a				; write crap
	
.next2
	ld	de,-enemy_data
	add ix,de
	djnz	1b

; process one layer enemies

	ld	b,max_bullets + max_enem_bullets 
1:	bit 0,(ix+enemy_data.status)
	jp	z,.spriteoff1

	ld	l,(ix+enemy_data.x+0)
	ld	h,(ix+enemy_data.x+1)
	ld	de,(xmap)
	xor a
	sbc hl,de				; dx = enemy.x - xmap
	jp	m,.spriteoff1		; dx <0

	or	h
	jp	nz,.spriteoff1		; dx >255

	ld	a,(_xoffset)		; compensate R#18 
	add	a,l
	jp	c,.spriteoff1		; remove if off screen i.e. dx + _xoffset > 255
	cp	240
	jp	nc,.spriteoff1		; remove if dx + _xoffset > 240
	
	ld	d,(ix+enemy_data.y)	
	out (c),d				; write Y
	out (c),a			; write X

	ld	a,(ix+enemy_data.frame)
	out (0x98),a			; write shape
	out (c),a				; write crap

.next1
	ld	de,-enemy_data
	add ix,de
	djnz	1b
	
	; ld	bc,0x98+4*3*256
	; ld  hl,ram_sat
	; otir

	ld	a,0xD8
	out (0x98),a			; SAT terminator
	ret
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
.spriteoff1
	ld	a,0xD9
[4]	out (c),a				; write crap
	jp	.next1

.spriteoff2
	ld	a,0xD9
[8]	out (c),a				; write crap
	jp	.next2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
