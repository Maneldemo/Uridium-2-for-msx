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

;	16 bit divide and modulus routines
;	called with dividend in hl and divisor in de
;	returns with result in hl.
;	adiv (amod) is signed divide (modulus), ldiv (lmod) is unsigned

	;global	adiv,ldiv,amod,lmod
	;psect	text,class=CODE

amod:
	call	adiv
	ex	de,hl		;put modulus in hl
	ret

lmod:
	call	ldiv
	ex	de,hl
	ret

ldiv:
	xor	a
	push	af
	ex	de,hl
	jr	dv1


adiv:
	ld	a,h
	xor	d		;set sign flag for quotient
	ld	a,h		;get sign of dividend
	push	af
	call	negif
	ex	de,hl
	call	negif
dv1:	
	ld	b,1
	ld	a,h
	or	l
	jr	nz,dv8
	pop	af
	ret

dv8:
	push	hl
	add	hl,hl
	jr	c,dv2
	ld	a,d
	cp	h
	jr	c,dv2
	jp	nz,dv6
	ld	a,e
	cp	l
	jr	c,dv2
dv6:
	pop	af
	inc	b
	jp	dv8

dv2:
	pop	hl
	ex	de,hl
	push	hl
	ld	hl,0
	ex	(sp),hl

dv4:
	ld	a,h
	cp	d
	jr	c,dv3
	jp	nz,dv5
	ld	a,l
	cp	e
	jr	c,dv3
dv5:	
	sbc	hl,de
dv3:	
	ex	(sp),hl
	ccf
	adc	hl,hl
	srl	d
	rr	e
	ex	(sp),hl
	djnz	dv4
	pop	de
	ex	de,hl
	pop	af
	call	m,negat
	ex	de,hl
	or	a			;test remainder sign bit
	call	m,negat
	ex	de,hl
	ret

negif:
	bit	7,h
	ret	z
negat:
	ld	b,h
	ld	c,l
	ld	hl,0
	or	a
	sbc	hl,bc
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
	