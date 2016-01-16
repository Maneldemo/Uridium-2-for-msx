;----------------------------------------------------------------------------
; Horizontal scrolling in screen 8 on msx2
; by artrag
;
; Abstract: Horizontal scrolling on msx 2 is a sort of holy grail
; Here follows an overview on the approach followed in Uridium 2 beta 
; and a simplified version of its scrolling engine.   
; We focus on side scrolling right to left, the extension to the other 
; direction is direct.
; The image to scroll is composed by tiles 16x16 pixels, the screen 
; window is 240x160 (taller windows are possible only in PAL mode). 
;
; Memory layout
;
; As we are in screen 8, we have only two VRAM pages that have to be
; used to show the screen window using  double buffering  
; (i.e. we plot on one page while we show the other page).
; This implies that the tiles have to stay in RAM or ROM. 
; Moreover the access to the tiles will be demanded to the z80, as we will see 
; later, leaving to the vdp the task of moving the screen. 
;
; The engine relies on a mega rom mapper with 8K pages (here Konami SCC) as a  
; full tile set of 256 tiles of 16x16 pixels takes 64KB of space.
; Naturally using a ram mapper or less tiles, other solutions are possible.
; Each tile is stored column wise, this in order to simplify the task of the z80
; which is in charge of plotting the new columns of pixels that enter the screen.
; 
; The map is stored by lines (in RAM) and, to simplify line changes, has size 256x10 
; Each byte in the map is a tile number.
; As a tile is 16x16=256 bytes, a page in the rom mapper can host 8*1024/256  = 32 tiles
; The full tile set of 256 tiles is spread across 8 pages of 8K each.
;
; The algorithm 
;   
; The engine works on the ISR and is based on a strong parallelism between VDP and z80.
; The visible window is 240x160 pixels, plus an extra border area of 16x160 pixels.  
; The screen window is moved in 16 steps corresponding to the 16 scroll positions of R#18.
; The z80 is in charge of plotting, at each ISR a new column of pixels in the right border 
; and a column of blank pixels on the left border on the visible screen.
; In 16 steps, the z80 builds a full new column of tiles on the right and deletes 
; a corresponding area of 16x160 pixels on the left.
; In the meanwhile, at each step, the VDP is in charge of moving 15 slices 16x160 pixels  
; from the visible screen to the hidden page (displacing each slice of 16 pixels) and to  
; build the black border on the right that will appear at page swap (also in this case 16x160 pixels).
; Once the screen offset has reached its maximum, the hidden page is ready and can be 
; swapped with the visible page and the process can restart.
; 
; Devil in the details (1)
; 
; When the z80 starts filling the 16th column of the right border on the visible screen  
; (column n. 255) the vdp has to copy the slice of pixels 16x160 that includes the column
; of pixels being plotted by the z80 from the visible page to the hidden page.
; It happens that the vdp has to wait for the z80 to have plotted at least 4-5 pixels 
; before the copy commands is issued or the copy will miss some pixels from that column.
; The engine has solved the concurrency problem by issuing the copy command only 
; after that the z80 has copied the last column of the first 4 tiles.
; This causes a small loss in performances of the VDP that will miss a fraction of the 
; VBLANK time (where the copy is faster).  
;
; Devil in the details (2)
;
; Why do we split the screen in slices instead of coping the whole 240x160 area to be moved?
; The problem is that the command engine of the VDP is affected by changes in R#18 
; At each change in R#18 occurring while the VDP is coping there is the possibility that
; a black or while pixel appears. 
; The sole solution is to move set R#18 only when the VDP command has been executed.
; This implies that the copy of the screen has to be segmented in tasks that the VDO can 
; complete within a single frame, before R#18 has to be set again.
; 
; use sjasm42c to compile
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
		include brdrs.asm
		
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

		; Ram in page 3 is not needed but it is a simple way to hook the ISR at 038h

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
		incbin "tiles.bin",0xC000;,0x2000
		; page 11
		; incbin "tiles.bin",0xE000;,0x2000

		page 12		
_level
		incbin	datamap.bin		

		
;---------------------------------------------------------
; Variables
;---------------------------------------------------------
	
	
	MAP 0xC000

_levelmap:			#mapWidth*mapHeight

slotvar				#1
slotram				#1
SEL_NTSC			#1


_ymappos:			#1
_xmappos:			#2


_displaypage:		#1

_xoffset:			#1

	ENDMAP