;----------------------------------------------------------------------------
;
;----------------------------------------------------------------------------

        output "urd2.rom"

		;	konami scc
		
_kBank1:	equ 05000h ;- 57FFh (5000h used)
_kBank2: 	equ 07000h ;- 77FFh (7000h used)
_kBank3: 	equ 09000h ;- 97FFh (9000h used)
_kBank4: 	equ 0B000h ;- B7FFh (B000h used)



		defpage	 0,0x4000, 0x2000		; page 0 main code 
		defpage	 1,0x6000, 0x2000		; page 1 code 
		defpage	 2,0x8000, 0x2000		; page 2 code  
		defpage	 3,0xA000, 0x2000		; swapped data 
		
		defpage	 4..15					; 64KB of swapped data 



  		include "header.asm"			; only definitions
		
		
		
		page 0
		
        org 4000h
        dw  4241h,START,0,0,0,0,0,0

	;-------------------------------------		


		include rominit64.asm				
		include vdpio.asm
		include isr.asm
		include fsmscroll.asm
		include vdpcmds.asm
		include brdrs_opt.asm
		
		include checkkbd.asm
		
;-------------------------------------
; Entry point
;-------------------------------------
START:
		xor	a
		ld	(SEL_NTSC),a		; PAL MODE
		call	set_scr			; set video mode to screen 8
		di
		
;-------------------------------------
;   Power-up routine for 32K ROM
;   set pages and sub slot
;-------------------------------------
        call    search_slot
        call    search_slotram	
		call	setrompage2		; ROM in page 1 & 2
		call	setrampage0		; RAM in page 0 & 3


		; activate  the fist 24K of rom
		xor	a			   
		ld	(_kBank1),a
		inc	a
		ld	(_kBank2),a
		inc	a
		ld	(_kBank3),a
		
		call	_cls
		
		;--- initialise ISR in RAM
		
		di
		ld	hl,0x0038
		ld	(hl),0xC3
		inc	hl
		ld	(hl),low _fake_isr
		inc	hl
		ld	(hl),high _fake_isr

		; copy the level map from ROM to RAM
		
		call	vdptest
		call	mapinit
		
		ld	hl,0
		ld	(_jiffy),hl		
		xor	a
		ld	(_displaypage),a		
		
		ei
1:		halt
		ld	a,(_xoffset)		
		and	a
		jp	nz,1b
		
		ld	e,8
		call	checkkbd
		and	1				; space
		call	z,PAL_ntsc
		jp	1b
		
PAL_ntsc
		ld		a,(RG9SAV)		
		xor		00000010B		; PAL or NTSC 
		ld		(RG9SAV),a
		out		(0x99),a
		ld		a,9+128
		out		(0x99),a
		ret

mapinit		
		ld	a, :_level
		ld	(_kBank4),a
		ld		hl,_level
		ld		de,_levelmap
		ld		bc,mapWidth*mapHeight
		ldir
		
		xor		a
		ld		h,a
		ld		l,a		
		ld		(_ymappos),a
		ld		(_xmappos),hl
		
		ret
vdptest:
		ld	d,160			; dest y
		ld	e,0				; dest x
		ld	b,1				; page
		ld	c,16*3+9		; initial tile
		ld	a,96			; number of tiles
1:		push	af

		ld	a,c
[3]		rlca
		and	00000111B
		add	a,:_tiles0
		ld	(_kBank4),a		; select tile bank

		ld	a,c
		and	00011111B
		add	a,high _tiles0
		ld	h,a				; select offset in the bank
		ld	l,0
		
		push	de
		push	bc
		call	LMMC_tile
		pop		bc
		pop		de
		
		ld		a,16		; x=x+16
		add		a,e
		ld		e,a
		jr		nc,2f

		ld		a,16		; y=y+16
		add		a,d
		ld		d,a
		
2:		inc		c
		pop	af
		dec	a
		jr	nz,1b
		ret
		
		
		page 4
_tiles0:
		incbin "tiles.bin",0x0000,0x2000
		page 5
		incbin "tiles.bin",0x2000,0x2000
		page 6
		incbin "tiles.bin",0x4000,0x2000
		page 7
		incbin "tiles.bin",0x6000,0x2000
		page 8
		incbin "tiles.bin",0x8000,0x2000
		page 9
		incbin "tiles.bin",0xA000,0x2000
		page 10
		incbin "tiles.bin",0xC000,0x2000
		page 11
		incbin "tiles.bin",0xE000,0x2000

		page 12		
_level
		incbin	datamap.bin		

		; call	opening
		

		; call 	_hw_sprite_init

		; ld		c,0
		; ld		de,256*(mapHeight*16+3)
		; call	_vdpsetvramwr

		; ld		de, 256*:_scorebar+1
		; call	outvram
		
		; ld		c,1
		; ld		de,256*mapHeight*16
		; call	_vdpsetvramwr

		; ld		de, 256*:_animated+2
		; call	outvram

	
		; ; ld	a,:demo_song
		; ; setpage_a
		
		; ; ld	bc,	end_demo_song-musbuff
		; ; ld	hl,	demo_song
		; ; ld	de,	musbuff
		; ; ldir
			
		; ; call	replay_init
		; ; ld		hl,musbuff
		; ; call	replay_loadsong


		; ld		e,0
		; call	_setpage
				
		; ld	a, :_level
		; ld	(_kBank4),a
		
		; ld		hl,_level
		; ld		de,_levelmap
		; ld		bc,mapWidth*mapHeight
		; ldir


		; ; call	init_page0

		; ld		a,0
		; ld		(cur_level),a

		; ei

; restart:
		; call	_intreset

		

		; ld		a,1
		; ld		(_displaypage),a		
		; call 	_cls0
		; ld		hl,_levelmap
		; ld		(_levelmap_pos),hl
		
		; xor		a
		; ld		h,a
		; ld		l,a
		; ld		(flip_flop),a
		; ld		(god_mode),a
		; ld		(_ymappos),a
		; ld		(_xmappos),hl
		
		; ld		(_nframes),hl
		; ld		(_mcdx),hl
		; ld		(_mcframe),a
		
		; ld		(_yoffset),a		;  0 tutto su
		; ld		(_xoffset),a		;  0 tutto su
								
		; ld		(aniframe),a
		; ld		(anispeed),a
		; ld		(ms_state),a
		; inc 	a
		; ld		(old_aniframe),a		; old_aniframe!=aniframe
	
		; ld		(dxmap),a		; moving right
		; ld		(_dxmap),a		; moving right

		; ld		(xmap),hl
		; ld		(_xmapx4),hl
		; ld		bc,xship_rel
		; add 	hl,bc
		; ld		(xship),hl
		; ld		a,80
		; ld		(yship),a

		; call 	npc_init								
		; call 	load_colors

		; xor	a
		; ld		(_kBank1),a
		; inc	a
		; ld		(_kBank2),a
		; inc	a
		; ld		(_kBank3),a
		

		; call	_isrinit

; main_loop: 
				
		; ld	hl,0
		; ld	(_jiffy),hl

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ; run ms FSM and place its sprites in the SAT in RAM
		; call	ms_ctrl
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ; test for game restart
		; ld	a,(ms_state)
		; cp	ms_reset
		; jp	z,restart

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ; place MS in the SAT and test for collision
		; call	put_ms_sprt
		; ld		a,(god_mode)
		; and 	a
		; ; call	z,test_obstacles

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ; run NCPS FSM
		; call	wave_timer
		; call	npc_loop
		; call	enemy_bullet_loop

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ; run MS bullets FSM
		; call	bullet_loop

		; ; ld	a,00100101B			; random colour
		; ; out		(0x99),a
		; ; ld		a,7+128
		; ; out		(0x99),a
		
		; ; call	_waitvdp

		; ; ld	a,10100101B			; random colour
		; ; out		(0x99),a
		; ; ld		a,7+128
		; ; out		(0x99),a
				
		; ld	a,(joystick)
		; and	32
		; ; call	z,_plot_distrucable

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		; ; ld		a,3
		; ; out		(0x99),a
		; ; ld		a,7+128
		; ; out		(0x99),a
		
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		; ; call	test_star

		; ; xor		a
		; ; out		(0x99),a
		; ; ld		a,7+128
		; ; out		(0x99),a
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		
; 1:		ld	a,(_jiffy)		; wait for vblank (and not for linit)
		; or	a
		; jr	z,1b
	
		; ld	hl,(xmap)
		; ld	bc,xship_rel
		; add hl,bc
		; ld	(xship),hl

		; ld		a,(dxmap)
		; ld		(_dxmap),a

		; jp      main_loop

; ;-------------------------------------
; AFXPLAY:
		; ret
; ;	include vuitpakker.asm
	; include print.asm
	; include plot_line.asm
	; include plot_line2.asm
	; include color_update.asm
; ms_bllts_col_win:
	; include ms_bllts_frm_coll_wind.asm
	; include	ms_bllts.asm
		
; ;-------------------------------------

	
		; page 1

		; include	ms_crtl.asm
		; include	put_ms_sprt.asm
		; include probe_level.asm				
		; include opening.asm		
; outvram:
; 2:		ld	a,d
		; ld	(_kBank4),a
		; ld	hl,0xA000
		; ld	bc,0x98
		; ld	a,32
; 1:		otir
		; dec	a
		; jp	nz,1b
		; inc	d
		; dec	e
		; jr	nz,2b
		; ret
		
		; page 2
	; ; include mainhero_LMMM.asm

	
		; page 3
; manta_color:
		; incbin mship03_clr.bin
; ms_spt:
		; incbin mship03_frm.bin
		
		; page 4
; _tiles0:
		; incbin "tiles.bin",0x0000,0x2000
		; page 5
		; incbin "tiles.bin",0x2000,0x2000
		; page 6
		; incbin "tiles.bin",0x4000,0x2000
		; page 7
		; incbin "tiles.bin",0x6000,0x2000
		; page 8
		; incbin "tiles.bin",0x8000,0x2000
		; page 9
		; incbin "tiles.bin",0xA000,0x2000
		; page 10
		; incbin "tiles.bin",0xC000,0x2000
		; page 11
		; incbin "tiles.bin",0xE000;,0x2000

		; page 12

		; page 15
; _level:
		; incbin "datamap.bin"
	
		; page 16
; _opening:
		; incbin "opening.bin",0x0000,0x2000
		; page 17
		; incbin "opening.bin",0x2000,0x2000
		; page 18
		; incbin "opening.bin",0x4000,0x2000
		; page 19
		; incbin "opening.bin",0x6000,0x2000
		; page 20
		; incbin "opening.bin",0x8000,0x2000
		; page 21
		; incbin "opening.bin",0xA000,0x2000
		; page 22
		; incbin "opening.bin",0xC000;,0x2000
		; page 23
		; ; incbin "opening.bin",0xE000;,,0x2000
	
		; page 24
; _scorebar:	
		; incbin scorebar.bin
	
		; page 25
; _animated:	
		; incbin animated.bin,0x0000,0x2000
		; page 26
		; incbin animated.bin,0x2000,0x2000

		; page 27
; sprtdata:
		; incbin 	uridium_revA.bin,,16*32
		; incbin 	enemies_frm.bin

		; page 28
; color_base:
		; repeat 4
		; ds	16,8
		; ds	16,10+64
		; endrepeat
		; repeat 4
		; ds	16,8
		; ds	16,10+64
		; endrepeat

		
		; incbin 	enemies_clr.bin
		
; FINISH:


; ;---------------------------------------------------------
; ; Variables
; ;---------------------------------------------------------
	
	
	MAP 0xC000

_levelmap:			#mapWidth*mapHeight

slotvar				#1
slotram				#1
SEL_NTSC			#1

; joystick			#1

; _mcdivider			#1

; _mcx				#2	; relative with in the frame on the screen
; _mcy				#2

; _mclx				#2	; absolute with the level in ram
; _mcly				#2

; _mcframe			#1
; _mcstate			#1

; _mcdx				#2
; _mcdy				#2

; _mcprobe:			#1
; _mcprobeb:			#1

; _ticxframe			#1

; _buffer:			#16
; _fps:				#2
; _nframes:			#2
; _vbit16:			#2

_ymappos:			#1
_xmappos:			#2

; _shadowbuff:		#2

_displaypage:		#1

; _mccolorchange:		#1
_xoffset:			#1
; _yoffset:			#1

; __xoffset:			#1
; __r18:				#1

; randSeed:			#2
; cur_level:			#1
; wave_count:			#1
; landing_permission:	#1
; assault_wave_timer:	#2
; bullet_rate:		#1
; _dxchng:			#1		; <>0 if direction changes
; _dxmap:				#1		; previous dxmap
; dxmap:				#1
; xmap:				#2
; _xmapx4:			#2		; xmap x 4
; yship:				#1
; xship:				#2
; aniframe:			#1
; ms_state:			#1
; old_aniframe:		#1
; anispeed:			#1
; already_dead:		#1
; lives_bin:			#1

; god_mode:			#1
; visible_sprts:		#1
; flip_flop:			#1

; ram_sat:			#3*4

	; struct enemy_data
; y				db	0
; x				dw	0
; xoff			db	0
; yoff			db	0
; xsize			db	0
; ysize			db	0
; status			db	0	; B7 = DWN/UP | B6 = RIGHT/LEFT | B5 = ok/wrong clr | B0 = Inactive/Active
; cntr			db	0
; kind			db	0
; frame			db	0
; color			db	0
; color2			db	0
; speed			dw	0
	; ends
	
; any_object:			#0
; ms_bullets:			#enemy_data*max_bullets
; enem_bullets:		#enemy_data*max_enem_bullets
; enemies:			#enemy_data*max_enem
; endram:				#1
	ENDMAP