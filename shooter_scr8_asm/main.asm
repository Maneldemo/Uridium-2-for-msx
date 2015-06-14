;----------------------------------------------------------------------------
;----------------------------------------------------------------------------

        output "urd_scr8.rom"

		incdir ene_code
		incdir music
		incdir manta
		incdir sources
		incdir databin

		defpage	 0,0x4000, 0x2000		; page 0 main code + far call routines
		defpage	 1,0x6000, 0x2000		; page 1 main code + far call routines
		defpage	 2,0x8000, 0x2000		; swapped data 
		defpage	 3,0xA000, 0x2000		; swapped data 
		
		defpage	 4..12					; 64KB of swapped data 

		; defpage	12,0x4000, 0x2000		; swapped code
		defpage	13,0x6000, 0x2000		; swapped code 
		defpage	14,0x8000, 0x2000		; swapped data 
		defpage	15,0xA000, 0x2000		; swapped data 

		defpage	16..31					; 128KB of swapped data 

		;	konami scc
		
_kBank1:	equ 05000h ;- 57FFh (5000h used)
_kBank2: 	equ 07000h ;- 77FFh (7000h used)
_kBank3: 	equ 09000h ;- 97FFh (9000h used)
_kBank4: 	equ 0B000h ;- B7FFh (B000h used)
	
mapWidth	equ	256
mapHeight	equ	11
YSIZE		equ	10*16+8

	macro setpage_a
		ld	(_kBank3),a
		inc	a
		ld	(_kBank4),a
	endmacro
  
  		include "header.asm"
		
		
		
		page 0
		
        org 4000h
        dw  4241h,START,0,0,0,0,0,0

	;-------------------------------------		


		include "rominit64.asm"
		include "vdpio.asm"
		include "turbo.asm"
		include "isr.asm"
		
		include checkkbd.asm
		include sprts.asm
		include sat_update.asm
		include collision_tst.asm
		include enemies.asm
		include plot_distrucable.asm
		
;-------------------------------------
; Entry point
;-------------------------------------
START:
		ld e,6
		call	checkkbd
		ld	a,1
		rrc	l				; shift
		jp	nc,_ntsc
		xor	a
_ntsc:	ld	(SEL_NTSC),a	; if set NSTC, if reset PAL

		call 	rand8_init								
		call	set_scr

		ld e,6
		call	checkkbd
		and	00000010B		; CRTL
		call nz,_set_r800	; if CRTL is pressed do not test for turbo
		
;-------------------------------------
;   Power-up routine for 32K ROM
;   set pages and sub slot
;-------------------------------------
        call    search_slot
        call    search_slotram
		call	setrompage2
		call	setrampage0


		xor	a
		ld	(_kBank1),a
		inc	a
		ld	(_kBank2),a
		inc	a
		ld	(_kBank3),a
		
		;--- initialise demo song
		ld	bc,	end_ttreplayRAM-ttreplayRAM
		ld	hl,	ttreplayRAM
		ld	de,	ttreplayRAM+1
		ld	(hl),0
		ldir
		call	_replay_init
		call	_intreset
		
		ld		c,0
		ld		d,c
		ld		e,c
		call	_vdpsetvramwr

		ld	de,256*:_opening+7
		call	outvram
		
1:		ld e,8
		call	checkkbd
		and		00000001B
		jr		nz,1b

		call	_cls
		di
		ld		a,(RG9SAV)		
		and		01111111B		; Set 192 lines
		ld		(RG9SAV),a
		out		(0x99),a
		ld		a,128+9
		out		(0x99),a
		ei

		call 	_hw_sprite_init

		ld		c,0
		ld		de,256*(mapHeight*16+3)
		call	_vdpsetvramwr

		ld		de, 256*:_scorebar+1
		call	outvram
		
		ld		c,1
		ld		de,256*mapHeight*16
		call	_vdpsetvramwr

		ld		de, 256*:_animated+2
		call	outvram

	
		; ld	a,:demo_song
		; setpage_a
		
		; ld	bc,	end_demo_song-musbuff
		; ld	hl,	demo_song
		; ld	de,	musbuff
		; ldir
			
		; call	replay_init
		; ld		hl,musbuff
		; call	replay_loadsong


		ld		e,0
		call	_setpage
				
		ld	a, :_level
		ld	(_kBank4),a
		
		ld		hl,_level
		ld		de,_levelmap
		ld		bc,mapWidth*mapHeight
		ldir


		; call	init_page0

		ld		a,0
		ld		(cur_level),a

		ld		hl,demo_song
		call	_replay_loadsong
		ei
; 1:		jp      1b

restart:
		call	_replay_init
		call	_intreset

		;--- initialise demo song
		ld	bc,	end_ttreplayRAM-ttreplayRAM
		ld	hl,	ttreplayRAM
		ld	de,	ttreplayRAM+1
		ld	(hl),0
		ldir
		

		ld		a,1
		ld		(_displaypage),a		
		call 	_cls0
		ld		hl,_levelmap
		ld		(_levelmap_pos),hl
		
		xor		a
		ld		h,a
		ld		l,a
		ld		(flip_flop),a
		ld		(god_mode),a
		ld		(_ymappos),a
		ld		(_xmappos),hl
		
		ld		(_nframes),hl
		ld		(_mcdx),hl
		ld		(_mcframe),a
		
		ld		(_yoffset),a		;  0 tutto su
		ld		(_xoffset),a		;  0 tutto su
								
		ld	(aniframe),a
		ld	(anispeed),a
		ld	(ms_state),a
		inc a
		ld	(old_aniframe),a		; old_aniframe!=aniframe
	
		ld		(dxmap),a		; moving right
		ld		(_dxmap),a		; moving right

		ld		(xmap),hl
		ld		(_xmapx4),hl
		ld		bc,xship_rel
		add 	hl,bc
		ld		(xship),hl
		ld		a,80
		ld		(yship),a

		call 	npc_init								
		call 	load_colors

		xor	a
		ld	(_kBank1),a
		inc	a
		ld	(_kBank2),a
		inc	a
		ld	(_kBank3),a
		
		ld		hl,demo_song
		call	_replay_loadsong

		call	_isrinit

main_loop: 
				
		ld	hl,0
		ld	(_jiffy),hl

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; run ms FSM and place its sprites in the SAT in RAM
		call	ms_ctrl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; test for game restart
		ld	a,(ms_state)
		cp	ms_reset
		jp	z,restart

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; place MS in the SAT and test for collision
		call	put_ms_sprt
		ld		a,(god_mode)
		and 	a
		; call	z,test_obstacles

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; run NCPS FSM
		call	wave_timer
		call	npc_loop
		call	enemy_bullet_loop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; run MS bullets FSM
		call	bullet_loop

		; ld	a,00100101B			; random colour
		; out		(0x99),a
		; ld		a,7+128
		; out		(0x99),a
		
		; call	_waitvdp

		; ld	a,10100101B			; random colour
		; out		(0x99),a
		; ld		a,7+128
		; out		(0x99),a
				
		ld	a,(joystick)
		and	32
		; call	z,_plot_distrucable

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		; ld		a,3
		; out		(0x99),a
		; ld		a,7+128
		; out		(0x99),a
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		; call	test_star

		; xor		a
		; out		(0x99),a
		; ld		a,7+128
		; out		(0x99),a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		
1:		ld	a,(_jiffy)		; wait for vblank (and not for linit)
		or	a
		jr	z,1b
	
		ld	hl,(xmap)
		ld	bc,xship_rel
		add hl,bc
		ld	(xship),hl

		ld		a,(dxmap)
		ld		(_dxmap),a

		jp      main_loop

;-------------------------------------
AFXPLAY:
		ret
;	include vuitpakker.asm
	include print.asm
	include plot_line.asm
	include plot_line2.asm
	include color_update.asm
ms_bllts_col_win:
	include ms_bllts_frm_coll_wind.asm
	include	ms_bllts.asm
		
;-------------------------------------

	
		page 1

		include	"..\TTplayer\code\ttreplay.asm"
		include	"ms_crtl.asm"
		include	"put_ms_sprt.asm"
		include probe_level.asm				
		
outvram:
2:		ld	a,d
		ld	(_kBank4),a
		ld	hl,0xA000
		ld	bc,0x98
		ld	a,32
1:		otir
		dec	a
		jp	nz,1b
		inc	d
		dec	e
		jr	nz,2b
		ret
		
		page 2
	; include mainhero_LMMM.asm

	
		page 3
manta_color:
		incbin mship03_clr.bin
ms_spt:
		incbin mship03_frm.bin
		
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
		incbin "tiles.bin",0xE000;,0x2000

		page 12
demo_song:
musbuff:
		; org 0x0040
		include	"demosong.asm"
		include	"..\TTplayer\code\ttreplayDAT.asm"
end_demo_song:	

		page 15
_level:
		incbin "datamap.bin"
	
		page 16
_opening:
		incbin "opening.bin",0x0000,0x2000
		page 17
		incbin "opening.bin",0x2000,0x2000
		page 18
		incbin "opening.bin",0x4000,0x2000
		page 19
		incbin "opening.bin",0x6000,0x2000
		page 20
		incbin "opening.bin",0x8000,0x2000
		page 21
		incbin "opening.bin",0xA000,0x2000
		page 22
		incbin "opening.bin",0xC000;,0x2000
		page 23
		; incbin "opening.bin",0xE000;,,0x2000
	
		page 24
_scorebar:	
		incbin scorebar.bin
	
		page 25
_animated:	
		incbin animated.bin,0x0000,0x2000
		page 26
		incbin animated.bin,0x2000,0x2000

		page 27
sprtdata:
		incbin 	uridium_revA.bin,,16*32
		incbin 	enemies_frm.bin

		page 28
color_base:
		repeat 4
		ds	16,8
		ds	16,10+64
		endrepeat
		repeat 4
		ds	16,8
		ds	16,10+64
		endrepeat

		
		incbin 	enemies_clr.bin
		
FINISH:


;---------------------------------------------------------
; Variables
;---------------------------------------------------------
	
	MAP 0x100
ttreplayRAM:		#0
	include	"..\TTplayer\code\ttreplayRAM.asm"
end_ttreplayRAM:	#0
	ENDMAP
	
	MAP 0xC000

_levelmap:			#mapWidth*mapHeight

slotvar				#1
slotram				#1
SEL_NTSC			#1

joystick			#1

_mcdivider			#1

_mcx				#2	; relative with in the frame on the screen
_mcy				#2

_mclx				#2	; absolute with the level in ram
_mcly				#2

_mcframe			#1
_mcstate			#1

_mcdx				#2
_mcdy				#2

_mcprobe:			#1
_mcprobeb:			#1

_ticxframe			#1

_buffer:			#16
_fps:				#2
_nframes:			#2
_vbit16:			#2

_ymappos:			#1
_xmappos:			#2
_levelmap_pos:		#2

_shadowbuff:		#2

_displaypage:		#1

_mccolorchange:		#1
_xoffset:			#1
_yoffset:			#1

__xoffset:			#1
__r18:				#1

randSeed:			#2
cur_level:			#1
wave_count:			#1
landing_permission:	#1
assault_wave_timer:	#2
bullet_rate:		#1
_dxchng:			#1		; <>0 if direction changes
_dxmap:				#1		; previous dxmap
dxmap:				#1
xmap:				#2
_xmapx4:			#2		; xmap x 4
yship:				#1
xship:				#2
aniframe:			#1
ms_state:			#1
old_aniframe:		#1
anispeed:			#1
already_dead:		#1
lives_bin:			#1

god_mode:			#1
visible_sprts:		#1
flip_flop:			#1

ram_sat:			#3*4

	struct enemy_data
y				db	0
x				dw	0
xoff			db	0
yoff			db	0
xsize			db	0
ysize			db	0
status			db	0	; B7 = DWN/UP | B6 = RIGHT/LEFT | B5 = ok/wrong clr | B0 = Inactive/Active
cntr			db	0
kind			db	0
frame			db	0
color			db	0
color2			db	0
speed			dw	0
	ends
	
any_object:			#0
ms_bullets:			#enemy_data*max_bullets
enem_bullets:		#enemy_data*max_enem_bullets
enemies:			#enemy_data*max_enem
endram:				#1
	ENDMAP