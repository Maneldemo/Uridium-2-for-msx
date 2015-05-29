
rdslt	equ	0x000c
CALSLT	equ	0x001c
chgcpu	equ	0x0180	; change cpu mode
exttbl	equ	0xfcc1	; main rom slot

; Switch to r800 rom mode
	
_set_r800:
		in	a,(0aah)
		and 011110000B			; upper 4 bits contain info to preserve
		or	6
		out (0aah),a
		in	a,(0a9h)
		ld	l,a

		ld	a,(0x002d)
		cp	3					; this is a TR
		ld	a,l
		jr	z,set_turbo_tr
								; this is anything else
		and	0x02				; CTR
		ret	nz					; if NZ, CTR is not pressed set the turbo

		ld	A,(chgcpu)
		cp	0C3h
		ld	a,81h              ; R800 ROM mode or any other turbo
		call	z,chgcpu
		ret

set_turbo_tr
		and	0x02				; CTR
		ret	z					; if Z, CTR is pressed -> do not set the turbo
		ld	a,81h              	; R800 ROM mode
		jp chgcpu
		
