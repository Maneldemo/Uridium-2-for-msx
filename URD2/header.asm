
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

max_enem:					equ 12		; max 12
max_enem_bullets:			equ 3
max_bullets:				equ 2		; max number of enemies*2 + ms_bullets + enem_bullets + 3 for ms	<= 32 sprites

maxspeed:					equ 4		; the actual speed is divided by 4
assault_wave_timer_preset:	equ	3*60	; a wave each 3 seconds
enemy_bullet_speed:			equ	2	
xship_rel:					equ (128-8)

mapWidth	equ	256
mapHeight	equ	11
YSIZE		equ	10*16+8

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	macro setpage_a
		ld	(_kBank3),a
		inc	a
		ld	(_kBank4),a
	endmacro
  