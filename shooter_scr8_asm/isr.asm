
		; include "header.asm"
		
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

_fake_isr
		push	af
		xor	a 			; read S#0
		out (0x99),a
		ld a,128+15
		out (0x99),a
		 
		in	a,(0x99)
		pop	af
		ei
		ret
	
_isrinit:
		di
		ld	hl,0x0038
		ld	(hl),0xC3
		inc	hl
		ld	(hl),low _scroll
		inc	hl
		ld	(hl),high _scroll

; set interrupt line
		LD    A,YSIZE-1
		out (0x99),a
		LD    A,19+128
		out (0x99),a
	
; enable line interrupt
		LD    A,(RG0SAV)
		OR    00010000B
		LD    (RG0SAV),A
		out (0x99),a
		LD    A,0+128
		out (0x99),a
		ei
		ret
	
_intreset:
		di
		ld	hl,0x0038
		ld	(hl),0xC3
		inc	hl
		ld	(hl),low _fake_isr
		inc	hl
		ld	(hl),high _fake_isr

; disable line interrupt		
		LD    A,(RG0SAV)
		and    11101111B
		LD    (RG0SAV),A
		out (0x99),a
		LD    A,0+128
		out (0x99),a
		ei
		ret
	
;;;;;;;;;;;;;;;;;;;;;;
; actual ISR handler
;;;;;;;;;;;;;;;;;;;;;;

_scroll:
		push	af
		
		ld a,1 			; read S#1
		out (0x99),a
		ld a,128+15
		out (0x99),a
		 
		in	a,(0x99)
		rra
		jp	c,lint	

		xor	a 			; read S#0
		out (0x99),a
		ld a,128+15
		out (0x99),a
		 
		in	a,(0x99)
		rlca
		jp	c,vblank
		
		pop	af			; none of them (?)
		ei
		ret
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
; manage score bar at YSIZE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
waitHBLANK
		ld a,2 				; read S#2
		out (0x99),a
		ld a,128+15
		out (0x99),a		; poll for HBLANK
		 
; 1:		in	a,(0x99)		; we are in HBLANK already, so wait until end of HBLANK
		; and	0x20
		; jp	nz,1b			
2:		in	a,(0x99)		; wait until end of the active area
		and	0x20
		jp	z,2b
		ret
	
lint:	
		; call	waitHBLANK
		; now we are at the start of HBLANK
	
		; ld	a,(RG1SAV)
		; and	010111111B			; disable screen
		; ld	(RG1SAV),a
		; out	(0x99),a
		; ld	a,1+128
		; out	(0x99),a


		ld a,00011111B		; 0XX11111B
		out (0x99),a
		ld a,2+128			; R#2 
		out (0x99),a		; score bar in page 0

		LD    A,mapHeight*16-(YSIZE-2)	; SCROLL DOWN
		out (0x99),a
		LD    A,23+128
		out (0x99),a

		xor		a
		out	(099h),a
		ld	a,18+128
		out	(099h),a		; set adjust 0,0


		ld	a,(RG8SAV)
		or	000000010B		; disable sprites
		ld	(RG8SAV),a
		out	(0x99),a
		ld	a,8+128
		out	(0x99),a

		; call	waitHBLANK
		
		; ld	a,(RG1SAV)
		; or 	01000010B		; enable screen
		; ld	(RG1SAV),a
		; out	(0x99),a
		; ld	a,1+128
		; out	(0x99),a
	
		push   hl         
		push   de         
		push   bc         
		exx               
		ex     af,af'     
		push   hl         
		push   de         
		push   bc         
		push   af         
		push   iy         
		push   ix         

		
		ld	hl,.exit
		push	hl
		ld		a,(dxmap)
		rlc a
		jp	z,replay_route			;  output music data	
		jp	nc,_blank_line_lft		; >0 == dx
		jp	 c,_blank_line_rgt		; <0 == sx
1:		pop	hl
.exit:
		
		pop    ix         
		pop    iy         
		pop    af         
		pop    bc         
		pop    de         
		pop    hl         
		ex     af,af'     
		exx               
		pop    bc         
		pop    de         
		pop    hl         

		pop		af
		ei
		ret

;-------------------------------------		

border_color	equ 	0;	00100101B
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
;   manage normal vblank routine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	

vblank:
		call	activate_window	

		push   hl         
		push   de         
		push   bc         
		exx               
		ex     af,af'     
		push   hl         
		push   de         
		push   bc         
		push   af         
		push   iy         
		push   ix         

		; ld	a,00011100B		; red
		; out		(0x99),a
		; ld		a,7+128
		; out		(0x99),a

		call	changedir
				
		ld	hl,(_jiffy)
		inc	hl
		ld	(_jiffy),hl
				
		; ld	a,00011100B		; red
		; out	(0x99),a
		; ld	a,7+128
		; out	(0x99),a
		
		call	replay_play			; calculate next output

		xor		a		; black
		out	(0x99),a
		ld	a,7+128
		out	(0x99),a
	
		pop    ix         
		pop    iy         
		pop    af         
		pop    bc         
		pop    de         
		pop    hl         
		ex     af,af'     
		exx               
		pop    bc         
		pop    de         
		pop    hl         

		pop		af
		ei
		ret
;-------------------------------------

_blank_line_lft:
		ld	a,00000111B		; blue
		out	(0x99),a
		ld	a,7+128
		out	(0x99),a

		ld	e,0
		call	blank_line
		call	replay_route		; first output data	
		
		ld		a,(_xoffset)
		and		1
		call	z,_plot_distrucable
		
		xor	a
		out	(0x99),a
		ld	a,7+128
		out	(0x99),a
		ret

;-------------------------------------	

_blank_line_rgt
		ld	a,00000111B		; blue
		out	(0x99),a
		ld	a,7+128
		out	(0x99),a

		ld	e,240
		call	blank_line
		call	replay_route		; first output data	

		xor	a
		out	(0x99),a
		ld	a,7+128
		out	(0x99),a
		ret
		
;-------------------------------------	
		
inc_xoffset
		call	plot_line_rgt1
		call	.movex
		call	plot_line_rgt2
				
		; ld	a,00000010B		; blue
		; out	(0x99),a
		; ld	a,7+128
		; out	(0x99),a
		
		jp		newxmap
		
.movex
		ld		a,(_xoffset)
		and		a
		jr		nz,.case1_15
.case0
		ld 		a,(_displaypage)
		xor		1
		ld 		d,a
		ld		e,240
		jp		clrboder
		
.case1_15
[4]		add		a,a
		ld		e,a
		sub		a,16
		ld		d,a
		jp		move_block


;-------------------------------------	
	
dec_xoffset
		call	plot_line_lft1
		call	.movex
		call	plot_line_lft2
				
		; ld	a,00000011B		; blue
		; out	(0x99),a
		; ld	a,7+128
		; out	(0x99),a

		jp		newxmap
		
.movex
		ld		a,(_xoffset)
		cp	15
		jr		nz,.case0_14
.case15
		ld 		a,(_displaypage)
		xor		1
		ld 		d,a
		ld		e,0
		jp		clrboder
		
.case0_14
[4]		add		a,a
		ld		e,a
		add		a,16
		ld		d,a
		jp		move_block


;-------------------------------------
newxmap
		call 	plot_enemy		
		call	color_enemy

		ld		hl,(_xmapx4)
		ld		a,(dxmap)
		ld		e,a
		add 	a,a
		sbc 	a,a
		ld		d,a
		add 	hl,de
		ld		(_xmapx4),hl
		repeat 2
		sra		h
		rr  	l
		endrepeat
		ld		(xmap),hl
		ld 		a,l
		and		15
		ld		(_xoffset),a
		repeat 4
		sra		h
		rr  	l
		endrepeat
		ld 		a,l
		and		1
		ld		(_displaypage),a
		ld		de,_levelmap
		add		hl,de
		ld		(_levelmap_pos),hl
		ret
		
;-------------------------------------

activate_window	
		ld	a,(_displaypage)
[5]		add a,a 			; x32
		or	00011111B
		out (0x99),a
		ld a,2+128
		out (0x99),a
		
		LD    A,(_yoffset)		; SCROLL DOWN
		out (0x99),a
		add    A,YSIZE-1
		ld		l,a
		LD    A,23+128
		out (0x99),a

		ld    a,l
		out (0x99),a			; set interrupt line
		LD    A,19+128
		out (0x99),a
		
		ld	a,(_xoffset)		; set R#18 only if not scrolling
		add	a,-8
		and	0Fh
		out	(099h),a
		ld	a,18+128
		out	(099h),a

		ld	a,(RG8SAV)		; enable sprites
		and	11111101B
		ld	(RG8SAV),a
		out	(0x99),a
		ld	a,8+128
		out	(0x99),a

		ret
			
;-------------------------------------
	
changedir:
		ld		a,(_dxmap)
		and		128
		ld		b,a
		inc		hl
		ld		a,(dxmap)		; dxmap
		ld		c,a
		and		128
		xor		b				; compare signs
		jp		z,nodirchange
		ld		(_dxchng),a		; a<>0
		bit		7,c
		jr		z,.right
.left
		call	plot_line_lft1
		ld 		a,(_displaypage)
		xor		1
		ld 		d,a
		ld		e,0
		call	clrboder
		call	plot_line_lft2
		jp		newxmap

.right
		call	plot_line_rgt1
		ld 		a,(_displaypage)
		xor		1
		ld 		d,a
		ld		e,240
		call	clrboder
		call	plot_line_rgt2
		jp		newxmap

nodirchange:
		ld		a,(_dxchng)
		and		a
		jr		nz,1f
		bit		7,c
		jp		z,inc_xoffset
		jp		dec_xoffset
	
1:		xor	a
		ld		(_dxchng),a
		bit		7,c
		jp		z,.right
.left
		call	plot_line_lft1
		ld		e,240-16
		ld		d,240
		call	move_block
		call	plot_line_lft2
		jp		newxmap

.right
		call	plot_line_rgt1
		ld		e,16
		ld		d,0
		call	move_block
		call	plot_line_rgt2
		jp		newxmap

;-------------------------------------
