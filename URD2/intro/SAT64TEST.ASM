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
;-----------------------------------------------------------
		
screeninit:
		ld		a,2
		call	005fh		
		ld		hl,SPRTBL
		call	0053h		

		ld		hl,(CGTABL)
		ld		bc,098h
[8]		otir
		ret
;-----------------------------------------------------------

addsprite
		ld	iy,ramdata
		ld	a,(ram_count)
		and	00000011b
[6]		add	a,a					; x64
		add	a,32
		ld	(iy+SPRITE_X),a		; x

		ld	a,(ram_count)
		and	11111100b
		add	a,a					; x8
		ld	(iy+SPRITE_Y),a		; y

		ld	a,(ram_count)
		and	7
		add	a,8
		ld	(iy+SPRITE_COLOR),a		; c
		ld	(iy+SPRITE_INDEX),'A'	; sp

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
[4]	outi
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
[4]	outi
	add	hl,de		; it does not affect Z
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

	
; Square of a 8 bit value
; in: A = 8 bit value, ZF = sign of A
; out: HL = A*A
sqr:
	jp	z,1f
	neg
1:	ld	l,a
	ld	h,0
	add	hl,hl
	ld	bc,tab
	add	hl,bc
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	ret
tab: dw 0,1,4,9,16,25,36,49,64,81,100,121,144,169,196,225,256,289,324,361,400,441,484,529,576,625,676,729,784,841,900,961,1024,1089,1156,1225,1296,1369,1444,1521,1600,1681,1764,1849,1936,2025,2116,2209,2304,2401,2500,2601,2704,2809,2916,3025,3136,3249,3364,3481,3600,3721,3844,3969,4096,4225,4356,4489,4624,4761,4900,5041,5184,5329,5476,5625,5776,5929,6084,6241,6400,6561,6724,6889,7056,7225,7396,7569,7744,7921,8100,8281,8464,8649,8836,9025,9216,9409,9604,9801,10000,10201,10404,10609,10816,11025,11236,11449,11664,11881,12100,12321,12544,12769,12996,13225,13456,13689,13924,14161,14400,14641,14884,15129,15376,15625,15876,16129,16384,16641,16900,17161,17424,17689,17956,18225,18496,18769,19044,19321,19600,19881,20164,20449,20736,21025,21316,21609,21904,22201,22500,22801,23104,23409,23716,24025,24336,24649,24964,25281,25600,25921,26244,26569,26896,27225,27556,27889,28224,28561,28900,29241,29584,29929,30276,30625,30976,31329,31684,32041,32400,32761,33124,33489,33856,34225,34596,34969,35344,35721,36100,36481,36864,37249,37636,38025,38416,38809,39204,39601,40000,40401,40804,41209,41616,42025,42436,42849,43264,43681,44100,44521,44944,45369,45796,46225,46656,47089,47524,47961,48400,48841,49284,49729,50176,50625,51076,51529,51984,52441,52900,53361,53824,54289,54756,55225,55696,56169,56644,57121,57600,58081,58564,59049,59536,60025,60516,61009,61504,62001,62500,63001,63504,64009,64516,65025
	
;Square root of 16-bit value
;In: HL = value
;Out: D = result (rounded down)
;
sqrt:
	ld de,0x0040
	ld a,l
	ld l,h
	ld h,d
	or a

	repeat	8			; unroll 8 times
		sbc hl,de
		jr nc,1f
		add hl,de
1:
		ccf
		rl d
		add a,a
		adc hl,hl
		add a,a
		adc hl,hl
	endrepeat

	ret


;Divide a 17-bit value (with sign in ZF)
;In: Divide HL by divider D
;Out: HL = result
;
	
Div16:
	push	de
	ld	e,d
	ld	d,0
	push	af
	jr	z,1f
	ld	b,h
	ld	c,l
	xor	a
	ld	l,a
	ld	h,a
	sbc	hl,bc
1:
	call	ldiv
	pop	af
	jr	z,1f
	ld	b,h
	ld	c,l
	xor	a
	ld	l,a
	ld	h,a
	sbc	hl,bc
1:
	pop		de
	ret	
		
		
; This routine performs the operation HL = DE*A/256

Mul24:              
	bit	7,d
	jp	z,UsignedMul

	ld	hl,0
	or	a
	sbc	hl,de
	ex	de,hl						; DE = -DE
	
	call	UsignedMul				; HL = DE*A/256

	ex	de,hl
	ld	hl,0
	or	a
	sbc	hl,de						; HL = -HL
	ret

UsignedMul:
	
	ld	c,0
	ld	l,c
	ld	h,c
	
;Input: A = Multiplier, DE = Multiplicand, HL = 0, C = 0
;Output: A:HL = Product

	add	a,a		; optimised 1st iteration
	jr	nc,$+4
	ld	h,d
	ld	l,e

	repeat	7

	add	hl,hl		; unroll 7 times
	rla			; ...
	jr	nc,$+4		; ...
	add	hl,de		; ...
	adc	a,c		; ...
	endrepeat

	ld	l,h
	ld	h,a
	
	ret
		
; ix		 -> main bullet
; iy 		-> 2nd bullet
; iy+rsize	-> 3rd bullet		

; use as temporary area some dummy bios locations
temp01	equ 0xF67A	
temp02	equ	0xF67C

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


	; a=15;
	; cos_a = round(cos(2*pi*a/360)*256) 
	; sin_a = round(sin(2*pi*a/360)*256) 
    
cos_a	equ 247
sin_a	equ 66
		
	; dx' = dx*cos(a)-dy*sin(a)

	ld	e,(ix+_NPC_dx)
	ld	d,(ix+_NPC_ddx)
	ld	a,cos_a
	call	Mul24
	push	hl				; dx*cos(a)
	
	ld	e,(ix+_NPC_dy)
	ld	d,(ix+_NPC_ddy)
	ld	a,sin_a
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
	ld	a,cos_a
	call	Mul24
	push	hl				; dy*cos(a)

	ld	e,(ix+_NPC_dx)
	ld	d,(ix+_NPC_ddx)
	ld	a,sin_a
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
		
		
	ld	hl,(temp01)
	ld	(iy+_NPC_dx),l
	ld	(iy+_NPC_ddx),h
	
	ld	hl,(temp02)
	ld	(iy+_NPC_dy),l
	ld	(iy+_NPC_ddy),h		
	map 0xc000
	
	; SPRITE MACHINE
m_iSprAtr:			#(MAX_SPRITES*4)		; Sprite system buffers

ram_count:			#1
	
m_iSprDrawFrame:	#1
m_iNumSpr:			#1
m_iSprAtrPointer:	#2


ramdata:			#4
	endmap
