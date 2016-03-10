		output "SAT64TEST.rom"

		defpage	 0,0x4000, 0x2000		; page 0 main code 
		defpage	 1,0x6000, 0x2000		; page 1 
		defpage	 2..7					; swapped data 
	
		;	konami scc
		
_kBank1:	equ 05000h ;- 57FFh (5000h used)
_kBank2: 	equ 07000h ;- 77FFh (7000h used)
_kBank3: 	equ 09000h ;- 97FFh (9000h used)
_kBank4: 	equ 0B000h ;- B7FFh (B000h used)
	
		page 0
		
        org 4000h
        dw  4241h,START,0,0,0,0,0,0

CGTABL:			equ	0x0004		
MAX_SPRITES:	equ	64		; System flikering
SPRTBL:			equ	0x3800	; Tabla de Sprites
SPRATR:			equ	0x1B00	; Tabla de los atributos de los sprites
SATor64:		equ	0x5b00

SPR_Y_NODRAW:	equ	209

SPRITE_Y		equ	0
SPRITE_X		equ	1
SPRITE_INDEX	equ	2
SPRITE_COLOR	equ	3
	
screeninit:
		ld		a,2
		call	005fh		
		ld		hl,SPRTBL
		call	0053h		

		ld		hl,(CGTABL)
		ld		bc,098h
[8]		otir
		ret

START:  
		call	screeninit
		
		xor		a
		ld		[m_iSprDrawFrame],a		
		
				
1:		xor		a
		ld		(ram_count),a
		call	sat_reset
		
2:		call	addsprite
		jr	nz,2b

		halt              
		call	DRAW_SPRITES

		; ld	e,8
		; call   	checkkbd      
		; and		1
		; call	z,addsprite
		
		
		jp	1b
		
		ret    

addsprite
		ld	iy,ramdata
		ld	a,r
		and	3
		ld	d,a
		ld	a,(ram_count)
		and	00000011b
[6]		add	a,a				;	x64
		add	a,32
		add	a,d
		ld	(iy+SPRITE_X),a		; x

		ld	a,r
		and	3
		ld	d,a
		ld	a,(ram_count)
		and	11111100b
		add	a,a				;	x16
		add	a,d
		ld	(iy+SPRITE_Y),a		; y

		ld	a,r
		and	3
		add	a,10
		ld	(iy+SPRITE_COLOR),a		; c
		ld	(iy+SPRITE_INDEX),'A'		; sp

		ld	iy,ramdata
		call	INSERT_SPRITE
		
		ld	a,(ram_count)
		inc	a
		and	63
		ld	(ram_count),a

		ret
	   

;-----------------------------------------------------------
; Draw sprites
;-----------------------------------------------------------
DRAW_SPRITES:
	;---------------------------------------------------
	; SISTEM FLIKERING----------------------------------
	;---------------------------------------------------

	ld	a,[m_iSprDrawFrame]
	or	a
	call	z,WRITESAT			; Note: WRITESAT returns always with Z
	call	nz,revWRITESAT

	;---------------------------------------------------
	; par-inpar frame run

	ld	a,[m_iSprDrawFrame]
	xor	1
	ld	[m_iSprDrawFrame],a

	ret
	
sat_reset:
	;---------------------------------------------------
	; reset virtual sat
	xor	a
	ld	[m_iNumSpr],a
	ld	hl,m_iSprAtr
	ld	[m_iSprAtrPointer],hl
	ret
	;---------------------------------------------------


;-----------------------------------------------------------
; Sprite system
; IY = position of buffer. The buffer format must be y, x, color, sprite
;-----------------------------------------------------------
INSERT_SPRITE:
	ld	hl,[m_iSprAtrPointer]
	ld	de, 0xFFFF & (-m_iSprAtr) 
	add	hl,de
	dec	h					; if hl=64*4 return 
	ret	z					
	; set values
	ld	hl,[m_iSprAtrPointer]
	ld	a,[iy+SPRITE_Y]		; +19c
	ld	[hl],a				; +7c add y data
	inc	hl					; +6c
	ld	a,[iy+SPRITE_X]		; +19c
	ld	[hl],a				; +7c add x data
	inc	hl					; +6c
	ld	a,[iy+SPRITE_INDEX]	; +19c
	ld	[hl],a				; +7c add color
	inc	hl					; +6c
	ld	a,[iy+SPRITE_COLOR]	; +19c
	ld	[hl],a				; +7c add sprite index
	inc	hl					; +6c
	ld	[m_iSprAtrPointer],hl
							
	; increment num sprites index
	ld	a,[m_iNumSpr]
	inc	a
	ld	[m_iNumSpr],a
	ret
	
; -------------------
; direct write sat
; 
; -------------------
WRITESAT:
	ld	hl,[m_iSprAtrPointer]
	ld	bc, 0xFFFF & (-m_iSprAtr) 
	add	hl,bc
	
	ld	a,SATor64 & 255
	out	[0x99],a
	ld	a,SATor64/256
	out	[0x99],a

	ld	a,l
	or	h
	jr	z,ws2f
	
	ld	b,l			;	always safe, as we test for more than 64 sprites in INSERT_SPRITE
	ld	a,128
	cp	b
	jr	nc,1f
	ld	b,a
1:
	
	ld	hl,m_iSprAtr
	ld	c,0x98
ws1b:
	outi
	outi
	outi
	outi
	jr	nz,ws1b
			
ws2f:	
	ld	a,208
	out	[0x98],a
	ret 

			
; -------------------
; reverse write sat
; 
; -------------------
revWRITESAT:
	ld	hl,[m_iSprAtrPointer]
	ld	bc, 0xFFFF & (-m_iSprAtr) 
	add	hl,bc
	
	ld a,SATor64 & 255
	out (0x99),a
	ld a,SATor64/256
	out (0x99),a

	ld	a,l
	or	h
	jr	z,rw2f

	ld	b,l			;	always safe, as we test for more than 64 sprites in INSERT_SPRITE
	ld	a,128
	cp	b
	jr	nc,1f
	ld	b,a
1:

	ld	hl,[m_iSprAtrPointer]
	ld	de,-4
	add	hl,de
	ld	de,-8
	ld c,0x98
rw1b:
	outi
	outi
	outi
	outi
	add	hl,de				; it does not affect Z
	jr	nz,rw1b

rw2f:
	ld	a,208
	out	(0x98),a
	ret 	

; // Line Bit_7 Bit_6 Bit_5 Bit_4 Bit_3 Bit_2 Bit_1 Bit_0
; // 0 	   "7"  "6"   "5"   "4"   "3"   "2"   "1"   "0"
; // 1 	   ";"  "]"   "["   "\"   "="   "-"   "9"   "8"
; // 2 	   "B"  "A"   ???   "/"   "."   ","   "'"   "`"
; // 3 	   "J"  "I"   "H"   "G"   "F"   "E"   "D"   "C"
; // 4 	   "R"  "Q"   "P"   "O"   "N"   "M"   "L"   "K"
; // 5 	   "Z"  "Y"   "X"   "W"   "V"   "U"   "T"   "S"
; // 6 	   F3 	 F2    F1  CODE   CAP  GRAPH  CTRL SHIFT
; // 7 	   RET  SEL    BS  STOP   TAB   ESC    F5    F4
; // 8 	   RIGHT DOWN  UP  LEFT   DEL   INS   HOME SPACE

checkkbd:
		; di
		in	a,(0aah)
		and 011110000B			; upper 4 bits contain info to preserve
		or	e
		out (0aah),a
		in	a,(0a9h)
		ld	l,a
		; ei
		ret

	map 0xc000
	
	; SPRITE MACHINE
m_iSprAtr:			#(MAX_SPRITES*4)		; Sprite system buffers

ram_count:			#1
	
m_iSprDrawFrame:	#1
m_iNumSpr:			#1
m_iSprAtrPointer:	#2


ramdata:			#4
	endmap
