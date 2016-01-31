
  // MSX 1 
RG0SAV  equ 0xF3DF  
RG1SAV  equ 0xF3E0  
RG2SAV  equ 0xF3E1
RG3SAV  equ 0xF3E2
RG4SAV  equ 0xF3E3
RG5SAV  equ 0xF3E4
RG6SAV  equ 0xF3E5
RG7SAV  equ 0xF3E6
// MSX 2
RG8SAV  equ 0xFFE7 
RG9SAV  equ 0xFFE8 
RG10SAV equ 0xFFE9 
RG11SAV equ 0xFFEA 
RG12SAV equ 0xFFEB 
RG13SAV equ 0xFFEC 
RG14SAV equ 0xFFED 
RG15SAV equ 0xFFEE 
RG16SAV equ 0xFFEF 
RG17SAV equ 0xFFF0 
RG18SAV equ 0xFFF1 
RG19SAV equ 0xFFF2 
RG20SAV equ 0xFFF3 
RG21SAV equ 0xFFF4 
RG22SAV equ 0xFFF5 
RG23SAV equ 0xFFF7 

_jiffy: equ 0xFC9E 

	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

max_enem:					equ 12		; max 12
max_enem_bullets:			equ 3
max_bullets:				equ 2		; max number of enemies*2 + ms_bullets + enem_bullets + 3 for ms	<= 32 sprites

maxspeed:					equ 4		; the actual speed is divided by 4
assault_wave_timer_preset:	equ	3*60	; a wave each 3 seconds
enemy_bullet_speed:			equ	2	
xship_rel:					equ (128-8)

mapWidth	equ	256
mapHeight	equ	10
YSIZE		equ	10*16

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
debug equ 1

	macro setpage_a
		ld	(_kBank3),a
		inc	a
		ld	(_kBank4),a
	endmacro
	
	macro bdrclr n
		if debug
		ifdif	n,0	
			ld		a,n
		else
			xor	a
		endif
		out		(0x99),a
		ld		a,7+128
		out		(0x99),a	
		endif
	endmacro
	
	macro set_tile reg
		ld	a,reg
[3]		rlca
		and	00000111B
		add	a,:_tiles0
		ld	(_kBank4),a		; select tile bank

		ld	a,reg
		and	00011111B
		add	a,high _tiles0
	endmacro
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
