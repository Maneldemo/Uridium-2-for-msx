; Compiled using tt_compile.exe V0.3 [12-04-2015]
; Copyright 2015 Richard Cornelisse

; Song: Namachuukei68 - Game Set        
; By:   KONAMI/TECHNOuchi/T4N3  (c) 2015

;	org $c000

; [ Song start data ]
	db $05				; Initial song speed.
	dw .waveform_start 		; Start of the waveform data.
	dw .instrument_start 		; Start of the instrument data.

; [ Song order pointer list ]
		dw .track_0,.track_1,.track_1,.track_2,.track_1,.track_1,.track_1,.track_1		; Sequence step 0 /pattern 0
.restart:
		dw .track_3,.track_4,.track_5,.track_6,.track_7,.track_8,.track_9,.track_10		; Sequence step 1 /pattern 1
		dw .track_11,.track_12,.track_13,.track_14,.track_15,.track_16,.track_17,.track_18		; Sequence step 2 /pattern 2
		dw .track_11,.track_19,.track_20,.track_21,.track_22,.track_23,.track_24,.track_25		; Sequence step 3 /pattern 3
		dw .track_26,.track_27,.track_28,.track_29,.track_30,.track_31,.track_32,.track_33		; Sequence step 4 /pattern 4
		dw .track_3,.track_34,.track_5,.track_6,.track_7,.track_8,.track_35,.track_36		; Sequence step 5 /pattern 5
		dw .track_11,.track_37,.track_13,.track_14,.track_15,.track_16,.track_38,.track_39		; Sequence step 6 /pattern 6
		dw .track_11,.track_40,.track_20,.track_41,.track_22,.track_23,.track_42,.track_43		; Sequence step 7 /pattern 7
		dw .track_44,.track_45,.track_28,.track_29,.track_46,.track_47,.track_48,.track_49		; Sequence step 8 /pattern 8
		dw 0x0000, .restart			; End of sequence delimiter + restart address.

.waveform_start:
	db $80,$B0,$C0,$10,$1A,$2A,$2C,$1A,$00,$E0,$D0,$E0,$22,$53,$70,$75,$70,$31,$EA,$80,$88,$8A,$8C,$8E,$00,$7F,$75,$73,$62,$00,$C0,$90	; Waveform 0(was 0)
	db $00,$20,$30,$40,$50,$58,$60,$68,$70,$68,$60,$58,$50,$40,$30,$20,$00,$E0,$D0,$C0,$B0,$A0,$98,$90,$88,$90,$98,$A0,$B0,$C0,$D0,$E0	; Waveform 1(was 1)
	db $80,$AA,$C8,$00,$24,$40,$5C,$70,$7F,$6A,$4A,$26,$00,$D0,$A8,$8C,$80,$AA,$C8,$00,$24,$40,$5C,$70,$7F,$6A,$4A,$26,$00,$D0,$A8,$8C	; Waveform 2(was 2)
	db $30,$50,$50,$30,$00,$00,$10,$40,$60,$70,$60,$30,$F0,$E0,$E0,$00,$20,$20,$10,$C0,$A0,$90,$A0,$C0,$00,$00,$D0,$B0,$B0,$D0,$00,$00	; Waveform 3(was 4)
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; Waveform 4(was 31)

.instrument_start:
	dw .ins_1
	dw .ins_2
	dw .ins_3
	dw .ins_4
	dw .ins_5
	dw .ins_6
	dw .ins_7
	dw .ins_8
	dw .ins_9
	dw .ins_10
	dw .ins_11
	dw .ins_12
	dw .ins_13
	dw .ins_14
	dw .ins_15
	dw .ins_16
.ins_1:						; PSG BD          
		db 0					; Waveform (was 0)
.rst_i1:
		db $0B,$0E
		dw .rst_i1
.ins_2:						; PSG SD          
		db 0					; Waveform (was 0)
		db $13,$0E
		db $85,$0D,$05,$00
		db $85,$0C,$04,$00
		db $85,$0B,$04,$00
		db $85,$0A,$04,$00
		db $A5,$0A,$01,$04,$00
		db $81,$09
		db $A1,$09,$01
		db $81,$09
		db $81,$08
		db $81,$08
		db $81,$07
		db $81,$06
		db $81,$05
		db $81,$03
		db $81,$01
		db $81,$01
		db $81,$01
		db $81,$01
		db $81,$00
.rst_i2:
		db $89,$00
		dw .rst_i2
.ins_3:						; PSG SD2         
		db 0					; Waveform (was 0)
		db $73,$0C,$1F
		db $E1,$0A,$03
		db $81,$09
		db $E1,$08,$01
		db $81,$07
		db $A1,$06,$03
		db $81,$05
		db $81,$05
		db $81,$04
		db $81,$04
		db $81,$04
		db $81,$04
		db $81,$04
		db $81,$04
		db $81,$04
		db $81,$04
		db $81,$04
		db $81,$04
		db $81,$04
		db $81,$04
.rst_i3:
		db $09,$04
		dw .rst_i3
.ins_4:						; PSG HH          
		db 0					; Waveform (was 0)
		db $91,$0C
		db $81,$05
		db $81,$02
.rst_i4:
		db $A9,$00,$1F
		dw .rst_i4
.ins_5:						; PSG HH2         
.ins_6:						; PSG HH3         
		db 0					; Waveform (was 0)
		db $87,$09,$05,$00
		db $85,$06,$05,$00
		db $85,$01,$05,$00
.rst_i6:
		db $8D,$00,$05,$00
		dw .rst_i6
.ins_7:						; PSG CY          
		db 0					; Waveform (was 0)
		db $81,$0C
		db $81,$0A
		db $81,$09
		db $81,$08
		db $81,$08
		db $81,$07
		db $81,$07
		db $81,$07
		db $81,$06
		db $81,$06
		db $81,$05
		db $81,$04
		db $81,$04
		db $81,$04
		db $81,$03
		db $81,$03
		db $81,$03
		db $81,$03
		db $81,$02
		db $81,$02
		db $81,$02
		db $81,$01
		db $81,$01
		db $81,$01
		db $81,$01
		db $81,$01
		db $81,$01
		db $81,$01
		db $81,$01
		db $81,$01
		db $81,$01
.rst_i7:
		db $89,$00
		dw .rst_i7
.ins_8:						; TomSine         
		db 8					; Waveform (was 1)
		db $11,$0C
		db $11,$09
		db $11,$07
		db $11,$06
		db $11,$05
		db $11,$05
		db $11,$04
		db $11,$04
		db $11,$04
		db $11,$03
		db $11,$03
		db $11,$02
		db $11,$01
		db $11,$00
.rst_i8:
		db $19,$00
		dw .rst_i8
.ins_9:						; Click           
		db 0					; Waveform (was 0)
		db $01,$00
		db $00
.rst_i9:
		db $0B,$0E
		dw .rst_i9
.ins_10:						; PSG RC          
		db 0					; Waveform (was 0)
		db $91,$0B
		db $D5,$0C,$E1,$02,$00
		db $F5,$0B,$1F,$F8,$FF
		db $F1,$0B,$1F
		db $91,$0B
		db $91,$0A
		db $91,$0A
		db $91,$0A
		db $91,$0A
		db $91,$0A
		db $91,$09
		db $91,$09
		db $91,$08
		db $91,$08
		db $91,$08
		db $91,$07
		db $91,$07
		db $91,$07
		db $91,$06
		db $91,$06
		db $91,$06
		db $91,$06
		db $91,$05
		db $91,$05
		db $91,$04
		db $91,$04
		db $91,$04
		db $91,$03
		db $91,$03
		db $91,$03
		db $91,$02
.rst_i10:
		db $99,$01
		dw .rst_i10
.ins_11:						; GekiPenaBass    
		db 0					; Waveform (was 0)
		db $11,$09
		db $11,$07
		db $11,$06
		db $11,$04
		db $11,$03
		db $11,$03
		db $11,$03
		db $11,$03
		db $11,$03
		db $11,$03
		db $11,$03
		db $11,$02
		db $11,$02
		db $11,$02
		db $11,$02
		db $11,$02
		db $11,$02
		db $11,$02
		db $11,$02
		db $11,$02
.rst_i11:
		db $19,$01
		dw .rst_i11
.ins_12:						; PSG Bass        
		db 0					; Waveform (was 0)
		db $11,$0F
		db $11,$0D
		db $11,$0C
		db $11,$0B
		db $11,$0A
		db $11,$08
		db $11,$07
		db $11,$06
		db $11,$05
		db $11,$05
.rst_i12:
		db $19,$05
		dw .rst_i12
.ins_13:						; SofTriDouble    
		db 16					; Waveform (was 2)
		db $13,$09
		db $11,$08
		db $11,$07
		db $11,$07
		db $11,$06
		db $11,$06
		db $11,$06
		db $11,$05
		db $11,$05
		db $11,$05
		db $11,$05
		db $11,$04
		db $11,$04
		db $11,$04
		db $11,$04
		db $11,$04
		db $11,$03
		db $11,$03
		db $11,$03
		db $11,$03
		db $11,$03
		db $11,$03
		db $11,$03
		db $11,$03
		db $11,$03
		db $11,$03
		db $11,$03
		db $11,$03
		db $11,$03
		db $11,$03
		db $11,$03
.rst_i13:
		db $19,$03
		dw .rst_i13
.ins_14:						; PSG Tone        
		db 0					; Waveform (was 0)
		db $13,$0F
		db $11,$0E
		db $11,$0D
		db $11,$0D
		db $11,$0C
		db $11,$0C
		db $11,$0C
		db $11,$0B
		db $11,$0B
		db $11,$0B
		db $11,$0B
		db $11,$0A
		db $11,$0A
		db $11,$0A
		db $11,$0A
		db $11,$0A
		db $11,$0A
		db $11,$09
		db $11,$09
		db $11,$09
		db $11,$09
		db $11,$09
		db $11,$09
		db $11,$09
		db $11,$09
		db $11,$08
		db $11,$08
		db $11,$08
		db $11,$08
		db $11,$08
		db $11,$08
.rst_i14:
		db $19,$08
		dw .rst_i14
.ins_15:						; GekipenaLead    
		db 24					; Waveform (was 4)
		db $13,$0B
		db $11,$0A
		db $11,$09
		db $11,$08
		db $11,$08
		db $11,$08
		db $11,$07
		db $11,$07
		db $11,$07
		db $11,$07
		db $11,$06
		db $11,$06
		db $11,$06
		db $11,$06
		db $11,$05
		db $11,$05
		db $11,$05
		db $11,$05
		db $11,$04
		db $11,$04
		db $11,$04
		db $11,$04
		db $11,$04
		db $11,$04
		db $11,$04
		db $11,$04
		db $11,$04
		db $11,$04
		db $11,$04
		db $11,$04
		db $11,$04
.rst_i15:
		db $19,$04
		dw .rst_i15
.ins_16:						; GekipenaLeadEcho
		db 24					; Waveform (was 4)
		db $13,$0F
.rst_i16:
		db $19,$0F
		dw .rst_i16

; [ Song track data ]
.track_0:
	db $13		;[Note] 20
	db $6F		;[Volume] 15
	db $72		;[Instrument] 3
	db $C3		;[Wait] 4
	db $19		;[Note] 26
				;[Skip delay] 4
	db $13		;[Note] 20
				;[Skip delay] 4
	db $13		;[Note] 20
	db $76		;[Instrument] 7
	db $C6		;[Wait] 7
	db $1A		;[Note] 27
	db $78		;[Instrument] 9
	db $C0		;[Wait] 1
	db $13		;[Note] 20
	db $6E		;[Volume] 14
	db $71		;[Instrument] 2
				;[Skip delay] 1
	db $6D		;[Volume] 13
	db $C2		;[Wait] 3
	db $13		;[Note] 20
	db $6E		;[Volume] 14
	db $C0		;[Wait] 1
	db $6D		;[Volume] 13
	db $C2		;[Wait] 3
	db $13		;[Note] 20
	db $6E		;[Volume] 14
	db $C0		;[Wait] 1
	db $6D		;[Volume] 13
	db $C2		;[Wait] 3
	db $BF		;[End-Of-Track]
.track_1:
	db $DF		;[Wait] 32
	db $BF		;[End-Of-Track]
.track_2:
	db $2A		;[Note] 43
	db $6E		;[Volume] 14
	db $77		;[Instrument] 8
	db $A5, $0E; slide-down
	db $C0		;[Wait] 1
	db $A5, $0E; slide-down
				;[Skip delay] 1
	db $2A		;[Note] 43
	db $A5, $0F; slide-down
				;[Skip delay] 1
	db $A5, $0F; slide-down
				;[Skip delay] 1
	db $28		;[Note] 41
	db $6F		;[Volume] 15
	db $A5, $0E; slide-down
				;[Skip delay] 1
	db $A5, $0E; slide-down
				;[Skip delay] 1
	db $A5, $0F; slide-down
				;[Skip delay] 1
	db $A5, $0F; slide-down
				;[Skip delay] 1
	db $2A		;[Note] 43
	db $6E		;[Volume] 14
	db $A5, $0E; slide-down
				;[Skip delay] 1
	db $A5, $0E; slide-down
				;[Skip delay] 1
	db $A5, $0F; slide-down
				;[Skip delay] 1
	db $A5, $0F; slide-down
				;[Skip delay] 1
	db $24		;[Note] 37
	db $6F		;[Volume] 15
	db $A5, $0E; slide-down
				;[Skip delay] 1
	db $A5, $0E; slide-down
				;[Skip delay] 1
	db $A5, $0F; slide-down
				;[Skip delay] 1
	db $A5, $0F; slide-down
	db $C4		;[Wait] 5
	db $1C		;[Note] 29
	db $6A		;[Volume] 10
	db $A5, $0E; slide-down
	db $C0		;[Wait] 1
	db $A5, $0E; slide-down
				;[Skip delay] 1
	db $A5, $0F; slide-down
				;[Skip delay] 1
	db $A5, $0F; slide-down
				;[Skip delay] 1
	db $1A		;[Note] 27
	db $A5, $0E; slide-down
				;[Skip delay] 1
	db $A5, $0E; slide-down
				;[Skip delay] 1
	db $A5, $0F; slide-down
				;[Skip delay] 1
	db $A5, $0F; slide-down
				;[Skip delay] 1
	db $18		;[Note] 25
	db $A5, $0E; slide-down
				;[Skip delay] 1
	db $A5, $0E; slide-down
				;[Skip delay] 1
	db $A5, $0F; slide-down
				;[Skip delay] 1
	db $A5, $0F; slide-down
				;[Skip delay] 1
	db $BF		;[End-Of-Track]
.track_3:
	db $0F		;[Note] 16
	db $6F		;[Volume] 15
	db $76		;[Instrument] 7
	db $94, $01	; vibrato control
	db $C6		;[Wait] 7
	db $1A		;[Note] 27
	db $78		;[Instrument] 9
	db $C0		;[Wait] 1
	db $13		;[Note] 20
	db $6E		;[Volume] 14
	db $71		;[Instrument] 2
	db $C7		;[Wait] 8
	db $5A		;[Note] 91
	db $6F		;[Volume] 15
	db $73		;[Instrument] 4
	db $C3		;[Wait] 4
	db $0C		;[Note] 13
	db $70		;[Instrument] 1
				;[Skip delay] 4
	db $13		;[Note] 20
	db $6E		;[Volume] 14
	db $71		;[Instrument] 2
	db $C0		;[Wait] 1
	db $6D		;[Volume] 13
	db $C2		;[Wait] 3
	db $0C		;[Note] 13
	db $6F		;[Volume] 15
	db $70		;[Instrument] 1
	db $C3		;[Wait] 4
	db $5A		;[Note] 91
	db $73		;[Instrument] 4
				;[Skip delay] 4
	db $0C		;[Note] 13
	db $70		;[Instrument] 1
				;[Skip delay] 4
	db $13		;[Note] 20
	db $6E		;[Volume] 14
	db $71		;[Instrument] 2
	db $C0		;[Wait] 1
	db $6D		;[Volume] 13
	db $C2		;[Wait] 3
	db $0C		;[Note] 13
	db $6F		;[Volume] 15
	db $70		;[Instrument] 1
	db $C3		;[Wait] 4
	db $5A		;[Note] 91
	db $73		;[Instrument] 4
				;[Skip delay] 4
	db $0C		;[Note] 13
	db $70		;[Instrument] 1
				;[Skip delay] 4
	db $13		;[Note] 20
	db $6E		;[Volume] 14
	db $71		;[Instrument] 2
	db $C0		;[Wait] 1
	db $6D		;[Volume] 13
	db $C2		;[Wait] 3
	db $5F		;[Note] 96
	db $6F		;[Volume] 15
	db $79		;[Instrument] 10
	db $C3		;[Wait] 4
	db $BF		;[End-Of-Track]
.track_4:
	db $0E		;[Note] 15
	db $6B		;[Volume] 11
	db $7B		;[Instrument] 12
	db $95, $01	; track detune
	db $C7		;[Wait] 8
	db $0E		;[Note] 15
				;[Skip delay] 8
	db $0E		;[Note] 15
	db $C3		;[Wait] 4
	db $10		;[Note] 17
				;[Skip delay] 4
	db $12		;[Note] 19
				;[Skip delay] 4
	db $14		;[Note] 21
	db $95, $02	; track detune
	db $C0		;[Wait] 1
	db $15		;[Note] 22
	db $A6, $0E; tone-slide
				;[Skip delay] 1
	db $A6, $0C; tone-slide
				;[Skip delay] 1
	db $A6, $0D; tone-slide
				;[Skip delay] 1
	db $A6, $0E; tone-slide
				;[Skip delay] 1
	db $A6, $0E; tone-slide
				;[Skip delay] 1
	db $B0, $02; tone-slide rep
	db $C1		;[Wait] 2
	db $15		;[Note] 22
	db $C7		;[Wait] 8
	db $15		;[Note] 22
				;[Skip delay] 8
	db $14		;[Note] 21
	db $95, $03	; track detune
				;[Skip delay] 8
	db $13		;[Note] 20
	db $95, $04	; track detune
	db $C3		;[Wait] 4
	db $BF		;[End-Of-Track]
.track_5:
	db $21		;[Note] 34
	db $6A		;[Volume] 10
	db $7D		;[Instrument] 14
	db $95, $09	; track detune
	db $CF		;[Wait] 16
	db $69		;[Volume] 9
	db $C3		;[Wait] 4
	db $21		;[Note] 34
	db $6A		;[Volume] 10
	db $C7		;[Wait] 8
	db $24		;[Note] 37
	db $95, $09	; track detune
	db $CF		;[Wait] 16
	db $69		;[Volume] 9
	db $C3		;[Wait] 4
	db $24		;[Note] 37
	db $6A		;[Volume] 10
	db $CB		;[Wait] 12
	db $69		;[Volume] 9
	db $C3		;[Wait] 4
	db $BF		;[End-Of-Track]
.track_6:
	db $0E		;[Note] 15
	db $6F		;[Volume] 15
	db $7A		;[Instrument] 11
	db $95, $01	; track detune
	db $C7		;[Wait] 8
	db $0E		;[Note] 15
				;[Skip delay] 8
	db $0E		;[Note] 15
	db $C3		;[Wait] 4
	db $10		;[Note] 17
				;[Skip delay] 4
	db $12		;[Note] 19
				;[Skip delay] 4
	db $14		;[Note] 21
	db $95, $02	; track detune
	db $C0		;[Wait] 1
	db $15		;[Note] 22
	db $A6, $0E; tone-slide
				;[Skip delay] 1
	db $A6, $0B; tone-slide
				;[Skip delay] 1
	db $A6, $0C; tone-slide
				;[Skip delay] 1
	db $A6, $0D; tone-slide
				;[Skip delay] 1
	db $A6, $0D; tone-slide
				;[Skip delay] 1
	db $B0, $02; tone-slide rep
	db $C1		;[Wait] 2
	db $15		;[Note] 22
	db $C7		;[Wait] 8
	db $15		;[Note] 22
				;[Skip delay] 8
	db $14		;[Note] 21
	db $95, $03	; track detune
				;[Skip delay] 8
	db $13		;[Note] 20
	db $95, $04	; track detune
	db $C3		;[Wait] 4
	db $BF		;[End-Of-Track]
.track_7:
	db $1E		;[Note] 31
	db $6F		;[Volume] 15
	db $7C		;[Instrument] 13
	db $95, $07	; track detune
	db $C7		;[Wait] 8
	db $6E		;[Volume] 14
				;[Skip delay] 8
	db $6D		;[Volume] 13
	db $C3		;[Wait] 4
	db $1E		;[Note] 31
	db $6F		;[Volume] 15
	db $C7		;[Wait] 8
	db $1E		;[Note] 31
	db $95, $07	; track detune
				;[Skip delay] 8
	db $6E		;[Volume] 14
				;[Skip delay] 8
	db $6D		;[Volume] 13
	db $C3		;[Wait] 4
	db $1E		;[Note] 31
	db $6F		;[Volume] 15
	db $C7		;[Wait] 8
	db $6E		;[Volume] 14
				;[Skip delay] 8
	db $BF		;[End-Of-Track]
.track_8:
	db $19		;[Note] 26
	db $6F		;[Volume] 15
	db $7C		;[Instrument] 13
	db $95, $07	; track detune
	db $C7		;[Wait] 8
	db $6E		;[Volume] 14
				;[Skip delay] 8
	db $6D		;[Volume] 13
	db $C3		;[Wait] 4
	db $19		;[Note] 26
	db $6F		;[Volume] 15
	db $C7		;[Wait] 8
	db $1C		;[Note] 29
	db $95, $06	; track detune
				;[Skip delay] 8
	db $6E		;[Volume] 14
				;[Skip delay] 8
	db $6D		;[Volume] 13
	db $C3		;[Wait] 4
	db $1B		;[Note] 28
	db $6F		;[Volume] 15
	db $95, $00	; track detune
	db $C7		;[Wait] 8
	db $6E		;[Volume] 14
				;[Skip delay] 8
	db $BF		;[End-Of-Track]
.track_9:
	db $35		;[Note] 54
	db $6A		;[Volume] 10
	db $7E		;[Instrument] 15
	db $95, $02	; track detune
	db $C0		;[Wait] 1
	db $36		;[Note] 55
	db $6B		;[Volume] 11
	db $A6, $01; tone-slide
				;[Skip delay] 1
	db $6C		;[Volume] 12
				;[Skip delay] 1
	db $6D		;[Volume] 13
	db $C0		;[Wait..] 1
	db $B0, $01; tone-slide rep
				;[Skip delay] 1
	db $6E		;[Volume] 14
	db $95, $01	; track detune
				;[Skip delay] 1
	db $95, $01	; track detune
				;[Skip delay] 1
	db $B0, $01; tone-slide rep
				;[Skip delay] 1
	db $6F		;[Volume] 15
	db $C0		;[Wait..] 1
	db $B0, $01; tone-slide rep
	db $C3		;[Wait] 4
	db $B0, $07; tone-slide rep
	db $CA		;[Wait] 11
	db $A7, $74	;[CMD vibrato]
	db $C0		;[Wait] 1
	db $B1, $1B	;[CMD vibrato] rep
	db $DA		;[Wait] 27
	db $3B		;[Note] 60
	db $6B		;[Volume] 11
	db $95, $08	; track detune
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
				;[Skip delay] 1
	db $6B		;[Volume] 11
				;[Skip delay] 1
	db $6A		;[Volume] 10
				;[Skip delay] 1
	db $39		;[Note] 58
	db $6B		;[Volume] 11
				;[Skip delay] 1
	db $6C		;[Volume] 12
				;[Skip delay] 1
	db $6B		;[Volume] 11
				;[Skip delay] 1
	db $6A		;[Volume] 10
				;[Skip delay] 1
	db $3B		;[Note] 60
	db $6B		;[Volume] 11
				;[Skip delay] 1
	db $6C		;[Volume] 12
				;[Skip delay] 1
	db $6B		;[Volume] 11
				;[Skip delay] 1
	db $6A		;[Volume] 10
				;[Skip delay] 1
	db $BF		;[End-Of-Track]
.track_10:
	db $C5		;[Wait] 6
	db $35		;[Note] 54
	db $62		;[Volume] 2
	db $7F		;[Instrument] 16
	db $95, $02	; track detune
	db $C0		;[Wait] 1
	db $36		;[Note] 55
	db $A6, $01; tone-slide
				;[Skip delay] 1
	db $B0, $12; tone-slide rep
	db $D5		;[Wait] 22
	db $A7, $74	;[CMD vibrato]
	db $C0		;[Wait] 1
	db $B1, $1B	;[CMD vibrato] rep
	db $DA		;[Wait] 27
	db $3B		;[Note] 60
	db $95, $00	; track detune
	db $C3		;[Wait] 4
	db $39		;[Note] 58
	db $C1		;[Wait] 2
	db $BF		;[End-Of-Track]
.track_11:
	db $0C		;[Note] 13
	db $6F		;[Volume] 15
	db $70		;[Instrument] 1
	db $C3		;[Wait] 4
	db $0C		;[Note] 13
	db $75		;[Instrument] 6
				;[Skip delay] 4
	db $13		;[Note] 20
	db $6E		;[Volume] 14
	db $71		;[Instrument] 2
	db $C7		;[Wait] 8
	db $5A		;[Note] 91
	db $6F		;[Volume] 15
	db $73		;[Instrument] 4
	db $C3		;[Wait] 4
	db $0C		;[Note] 13
	db $70		;[Instrument] 1
				;[Skip delay] 4
	db $13		;[Note] 20
	db $6E		;[Volume] 14
	db $71		;[Instrument] 2
				;[Skip delay] 4
	db $0C		;[Note] 13
	db $6F		;[Volume] 15
	db $70		;[Instrument] 1
				;[Skip delay] 4
	db $5A		;[Note] 91
	db $73		;[Instrument] 4
				;[Skip delay] 4
	db $0C		;[Note] 13
	db $70		;[Instrument] 1
				;[Skip delay] 4
	db $13		;[Note] 20
	db $6E		;[Volume] 14
	db $71		;[Instrument] 2
				;[Skip delay] 4
	db $0C		;[Note] 13
	db $6F		;[Volume] 15
	db $70		;[Instrument] 1
				;[Skip delay] 4
	db $5A		;[Note] 91
	db $73		;[Instrument] 4
				;[Skip delay] 4
	db $0C		;[Note] 13
	db $70		;[Instrument] 1
				;[Skip delay] 4
	db $13		;[Note] 20
	db $6E		;[Volume] 14
	db $71		;[Instrument] 2
	db $C0		;[Wait] 1
	db $6D		;[Volume] 13
	db $C2		;[Wait] 3
	db $5F		;[Note] 96
	db $6F		;[Volume] 15
	db $79		;[Instrument] 10
	db $C3		;[Wait] 4
	db $BF		;[End-Of-Track]
.track_12:
	db $94, $01	; vibrato control
	db $C7		;[Wait] 8
	db $13		;[Note] 20
	db $6B		;[Volume] 11
	db $7B		;[Instrument] 12
	db $95, $04	; track detune
				;[Skip delay] 8
	db $13		;[Note] 20
	db $C3		;[Wait] 4
	db $0E		;[Note] 15
	db $95, $01	; track detune
				;[Skip delay] 4
	db $0D		;[Note] 14
	db $95, $02	; track detune
				;[Skip delay] 4
	db $0C		;[Note] 13
	db $CB		;[Wait] 12
	db $0C		;[Note] 13
	db $C7		;[Wait] 8
	db $0C		;[Note] 13
	db $C3		;[Wait] 4
	db $0E		;[Note] 15
	db $95, $01	; track detune
				;[Skip delay] 4
	db $10		;[Note] 17
	db $95, $07	; track detune
				;[Skip delay] 4
	db $12		;[Note] 19
	db $95, $07	; track detune
	db $C0		;[Wait] 1
	db $A5, $01; slide-down
	db $C2		;[Wait] 3
	db $BF		;[End-Of-Track]
.track_13:
	db $23		;[Note] 36
	db $6A		;[Volume] 10
	db $7D		;[Instrument] 14
	db $95, $09	; track detune
	db $DF		;[Wait] 32
	db $1F		;[Note] 32
	db $95, $03	; track detune
				;[Skip delay] 32
	db $BF		;[End-Of-Track]
.track_14:
	db $C7		;[Wait] 8
	db $13		;[Note] 20
	db $6F		;[Volume] 15
	db $7A		;[Instrument] 11
	db $95, $04	; track detune
				;[Skip delay] 8
	db $13		;[Note] 20
	db $C3		;[Wait] 4
	db $0E		;[Note] 15
	db $95, $01	; track detune
				;[Skip delay] 4
	db $0D		;[Note] 14
	db $95, $02	; track detune
				;[Skip delay] 4
	db $0C		;[Note] 13
	db $95, $02	; track detune
	db $CB		;[Wait] 12
	db $0C		;[Note] 13
	db $C7		;[Wait] 8
	db $0C		;[Note] 13
	db $C3		;[Wait] 4
	db $0E		;[Note] 15
	db $95, $01	; track detune
				;[Skip delay] 4
	db $10		;[Note] 17
	db $95, $07	; track detune
				;[Skip delay] 4
	db $12		;[Note] 19
	db $95, $07	; track detune
	db $C0		;[Wait] 1
	db $A5, $01; slide-down
	db $C2		;[Wait] 3
	db $BF		;[End-Of-Track]
.track_15:
	db $1E		;[Note] 31
	db $6F		;[Volume] 15
	db $7C		;[Instrument] 13
	db $95, $07	; track detune
	db $C7		;[Wait] 8
	db $6E		;[Volume] 14
				;[Skip delay] 8
	db $6D		;[Volume] 13
	db $CF		;[Wait] 16
	db $1C		;[Note] 29
	db $6F		;[Volume] 15
	db $95, $05	; track detune
	db $C7		;[Wait] 8
	db $6E		;[Volume] 14
				;[Skip delay] 8
	db $6D		;[Volume] 13
	db $CF		;[Wait] 16
	db $BF		;[End-Of-Track]
.track_16:
	db $1A		;[Note] 27
	db $6F		;[Volume] 15
	db $7C		;[Instrument] 13
	db $95, $06	; track detune
	db $C7		;[Wait] 8
	db $6E		;[Volume] 14
				;[Skip delay] 8
	db $6D		;[Volume] 13
	db $CF		;[Wait] 16
	db $16		;[Note] 23
	db $6F		;[Volume] 15
	db $95, $07	; track detune
	db $C7		;[Wait] 8
	db $6E		;[Volume] 14
				;[Skip delay] 8
	db $6D		;[Volume] 13
	db $CF		;[Wait] 16
	db $BF		;[End-Of-Track]
.track_17:
	db $32		;[Note] 51
	db $6B		;[Volume] 11
	db $7E		;[Instrument] 15
	db $95, $00	; track detune
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
				;[Skip delay] 1
	db $6B		;[Volume] 11
				;[Skip delay] 1
	db $6C		;[Volume] 12
				;[Skip delay] 1
	db $6D		;[Volume] 13
				;[Skip delay] 1
	db $6E		;[Volume] 14
	db $C2		;[Wait] 3
	db $6D		;[Volume] 13
	db $A7, $74	;[CMD vibrato]
	db $C0		;[Wait] 1
	db $B1, $0B	;[CMD vibrato] rep
	db $CA		;[Wait] 11
	db $32		;[Note] 51
	db $6B		;[Volume] 11
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
				;[Skip delay] 1
	db $6B		;[Volume] 11
				;[Skip delay] 1
	db $6A		;[Volume] 10
				;[Skip delay] 1
	db $34		;[Note] 53
	db $6B		;[Volume] 11
				;[Skip delay] 1
	db $6C		;[Volume] 12
				;[Skip delay] 1
	db $6B		;[Volume] 11
				;[Skip delay] 1
	db $6A		;[Volume] 10
				;[Skip delay] 1
	db $32		;[Note] 51
	db $6B		;[Volume] 11
				;[Skip delay] 1
	db $6C		;[Volume] 12
				;[Skip delay] 1
	db $6B		;[Volume] 11
				;[Skip delay] 1
	db $6A		;[Volume] 10
				;[Skip delay] 1
	db $37		;[Note] 56
	db $6B		;[Volume] 11
	db $95, $08	; track detune
				;[Skip delay] 1
	db $39		;[Note] 58
	db $6C		;[Volume] 12
	db $A6, $06; tone-slide
				;[Skip delay] 1
	db $A6, $05; tone-slide
				;[Skip delay] 1
	db $A6, $06; tone-slide
				;[Skip delay] 1
	db $A6, $07; tone-slide
				;[Skip delay] 1
	db $B0, $03; tone-slide rep
	db $C2		;[Wait] 3
	db $37		;[Note] 56
	db $6B		;[Volume] 11
	db $95, $00	; track detune
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
				;[Skip delay] 1
	db $6B		;[Volume] 11
				;[Skip delay] 1
	db $6C		;[Volume] 12
	db $C4		;[Wait] 5
	db $32		;[Note] 51
	db $6B		;[Volume] 11
	db $95, $00	; track detune
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
				;[Skip delay] 1
	db $6B		;[Volume] 11
				;[Skip delay] 1
	db $6C		;[Volume] 12
	db $C4		;[Wait] 5
	db $2E		;[Note] 47
	db $6B		;[Volume] 11
	db $95, $02	; track detune
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
				;[Skip delay] 1
	db $6B		;[Volume] 11
				;[Skip delay] 1
	db $6C		;[Volume] 12
	db $C4		;[Wait] 5
	db $BF		;[End-Of-Track]
.track_18:
	db $C1		;[Wait] 2
	db $3B		;[Note] 60
	db $62		;[Volume] 2
	db $7F		;[Instrument] 16
	db $95, $00	; track detune
	db $C3		;[Wait] 4
	db $32		;[Note] 51
	db $95, $01	; track detune
	db $C7		;[Wait] 8
	db $A7, $74	;[CMD vibrato]
	db $C0		;[Wait] 1
	db $B1, $0B	;[CMD vibrato] rep
				;[Skip delay] 1
	db $61		;[Volume] 1
	db $C9		;[Wait] 10
	db $32		;[Note] 51
	db $62		;[Volume] 2
	db $C3		;[Wait] 4
	db $34		;[Note] 53
				;[Skip delay] 4
	db $32		;[Note] 51
				;[Skip delay] 4
	db $37		;[Note] 56
	db $95, $00	; track detune
	db $C0		;[Wait] 1
	db $39		;[Note] 58
	db $A6, $06; tone-slide
				;[Skip delay] 1
	db $A6, $05; tone-slide
				;[Skip delay] 1
	db $A6, $06; tone-slide
				;[Skip delay] 1
	db $A6, $07; tone-slide
				;[Skip delay] 1
	db $B0, $03; tone-slide rep
	db $C2		;[Wait] 3
	db $37		;[Note] 56
	db $95, $01	; track detune
	db $C7		;[Wait] 8
	db $32		;[Note] 51
	db $95, $01	; track detune
				;[Skip delay] 8
	db $2E		;[Note] 47
	db $95, $03	; track detune
	db $C1		;[Wait] 2
	db $BF		;[End-Of-Track]
.track_19:
	db $C7		;[Wait] 8
	db $12		;[Note] 19
	db $6B		;[Volume] 11
	db $7B		;[Instrument] 12
	db $95, $07	; track detune
	db $C0		;[Wait] 1
	db $A5, $01; slide-down
	db $C6		;[Wait] 7
	db $10		;[Note] 17
	db $95, $02	; track detune
	db $C3		;[Wait] 4
	db $12		;[Note] 19
	db $95, $07	; track detune
	db $C0		;[Wait] 1
	db $A5, $01; slide-down
	db $C6		;[Wait] 7
	db $0B		;[Note] 12
	db $95, $06	; track detune
	db $C7		;[Wait] 8
	db $17		;[Note] 24
	db $C3		;[Wait] 4
	db $0B		;[Note] 12
				;[Skip delay] 4
	db $19		;[Note] 26
				;[Skip delay] 4
	db $0E		;[Note] 15
	db $95, $03	; track detune
				;[Skip delay] 4
	db $1B		;[Note] 28
	db $95, $01	; track detune
				;[Skip delay] 4
	db $12		;[Note] 19
	db $95, $07	; track detune
	db $C0		;[Wait] 1
	db $A5, $01; slide-down
	db $C2		;[Wait] 3
	db $10		;[Note] 17
	db $95, $07	; track detune
	db $C3		;[Wait] 4
	db $BF		;[End-Of-Track]
.track_20:
	db $21		;[Note] 34
	db $6A		;[Volume] 10
	db $7D		;[Instrument] 14
	db $95, $09	; track detune
	db $DB		;[Wait] 28
	db $21		;[Note] 34
	db $95, $09	; track detune
	db $D3		;[Wait] 20
	db $21		;[Note] 34
	db $95, $09	; track detune
	db $CF		;[Wait] 16
	db $BF		;[End-Of-Track]
.track_21:
	db $C7		;[Wait] 8
	db $12		;[Note] 19
	db $6F		;[Volume] 15
	db $7A		;[Instrument] 11
	db $95, $07	; track detune
	db $C0		;[Wait] 1
	db $A5, $01; slide-down
	db $C6		;[Wait] 7
	db $10		;[Note] 17
	db $95, $02	; track detune
	db $C3		;[Wait] 4
	db $12		;[Note] 19
	db $95, $07	; track detune
	db $C0		;[Wait] 1
	db $A5, $01; slide-down
	db $C6		;[Wait] 7
	db $0B		;[Note] 12
	db $95, $06	; track detune
	db $C7		;[Wait] 8
	db $17		;[Note] 24
	db $95, $06	; track detune
	db $C3		;[Wait] 4
	db $0B		;[Note] 12
				;[Skip delay] 4
	db $19		;[Note] 26
				;[Skip delay] 4
	db $0E		;[Note] 15
	db $6E		;[Volume] 14
	db $95, $03	; track detune
				;[Skip delay] 4
	db $1B		;[Note] 28
	db $95, $01	; track detune
				;[Skip delay] 4
	db $12		;[Note] 19
	db $95, $07	; track detune
	db $C0		;[Wait] 1
	db $A5, $01; slide-down
	db $C2		;[Wait] 3
	db $10		;[Note] 17
	db $95, $07	; track detune
	db $C3		;[Wait] 4
	db $BF		;[End-Of-Track]
.track_22:
	db $1C		;[Note] 29
	db $6F		;[Volume] 15
	db $7C		;[Instrument] 13
	db $95, $05	; track detune
	db $C7		;[Wait] 8
	db $6E		;[Volume] 14
	db $D3		;[Wait] 20
	db $1E		;[Note] 31
	db $6F		;[Volume] 15
	db $95, $07	; track detune
	db $C7		;[Wait] 8
	db $6E		;[Volume] 14
	db $CB		;[Wait] 12
	db $1E		;[Note] 31
	db $6F		;[Volume] 15
	db $95, $07	; track detune
	db $C7		;[Wait] 8
	db $6E		;[Volume] 14
				;[Skip delay] 8
	db $BF		;[End-Of-Track]
.track_23:
	db $19		;[Note] 26
	db $6F		;[Volume] 15
	db $7C		;[Instrument] 13
	db $95, $07	; track detune
	db $C7		;[Wait] 8
	db $6E		;[Volume] 14
	db $D3		;[Wait] 20
	db $1A		;[Note] 27
	db $6F		;[Volume] 15
	db $95, $05	; track detune
	db $C7		;[Wait] 8
	db $6E		;[Volume] 14
	db $CB		;[Wait] 12
	db $17		;[Note] 24
	db $6F		;[Volume] 15
	db $95, $05	; track detune
	db $C7		;[Wait] 8
	db $6E		;[Volume] 14
				;[Skip delay] 8
	db $BF		;[End-Of-Track]
.track_24:
	db $2D		;[Note] 46
	db $6B		;[Volume] 11
	db $7E		;[Instrument] 15
	db $95, $00	; track detune
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
				;[Skip delay] 1
	db $6B		;[Volume] 11
				;[Skip delay] 1
	db $6A		;[Volume] 10
				;[Skip delay] 1
	db $31		;[Note] 50
	db $6B		;[Volume] 11
	db $95, $08	; track detune
				;[Skip delay] 1
	db $6C		;[Volume] 12
				;[Skip delay] 1
	db $6B		;[Volume] 11
				;[Skip delay] 1
	db $6A		;[Volume] 10
				;[Skip delay] 1
	db $36		;[Note] 55
	db $6B		;[Volume] 11
	db $95, $01	; track detune
				;[Skip delay] 1
	db $6C		;[Volume] 12
				;[Skip delay] 1
	db $6B		;[Volume] 11
				;[Skip delay] 1
	db $6A		;[Volume] 10
				;[Skip delay] 1
	db $34		;[Note] 53
	db $6B		;[Volume] 11
	db $95, $00	; track detune
				;[Skip delay] 1
	db $6C		;[Volume] 12
	db $C1		;[Wait] 2
	db $6B		;[Volume] 11
	db $C4		;[Wait] 5
	db $32		;[Note] 51
	db $95, $00	; track detune
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
	db $C1		;[Wait] 2
	db $6B		;[Volume] 11
	db $C4		;[Wait] 5
	db $31		;[Note] 50
	db $95, $08	; track detune
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
	db $C1		;[Wait] 2
	db $6B		;[Volume] 11
	db $C4		;[Wait] 5
	db $32		;[Note] 51
	db $95, $00	; track detune
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
	db $C1		;[Wait] 2
	db $6B		;[Volume] 11
	db $C4		;[Wait] 5
	db $2F		;[Note] 48
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
	db $C1		;[Wait] 2
	db $6B		;[Volume] 11
	db $C4		;[Wait] 5
	db $31		;[Note] 50
	db $95, $08	; track detune
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
				;[Skip delay] 1
	db $6B		;[Volume] 11
	db $C1		;[Wait] 2
	db $32		;[Note] 51
	db $95, $00	; track detune
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
				;[Skip delay] 1
	db $6B		;[Volume] 11
	db $C1		;[Wait] 2
	db $34		;[Note] 53
	db $95, $00	; track detune
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
				;[Skip delay] 1
	db $6B		;[Volume] 11
				;[Skip delay] 1
	db $6A		;[Volume] 10
				;[Skip delay] 1
	db $BF		;[End-Of-Track]
.track_25:
	db $C5		;[Wait] 6
	db $2D		;[Note] 46
	db $62		;[Volume] 2
	db $7F		;[Instrument] 16
	db $95, $01	; track detune
	db $C3		;[Wait] 4
	db $31		;[Note] 50
	db $95, $00	; track detune
				;[Skip delay] 4
	db $36		;[Note] 55
	db $95, $01	; track detune
				;[Skip delay] 4
	db $34		;[Note] 53
	db $95, $01	; track detune
	db $C7		;[Wait] 8
	db $32		;[Note] 51
	db $95, $01	; track detune
				;[Skip delay] 8
	db $31		;[Note] 50
	db $95, $00	; track detune
				;[Skip delay] 8
	db $32		;[Note] 51
	db $95, $01	; track detune
				;[Skip delay] 8
	db $2F		;[Note] 48
				;[Skip delay] 8
	db $31		;[Note] 50
	db $95, $00	; track detune
	db $C3		;[Wait] 4
	db $32		;[Note] 51
	db $95, $01	; track detune
	db $C1		;[Wait] 2
	db $BF		;[End-Of-Track]
.track_26:
	db $0C		;[Note] 13
	db $6F		;[Volume] 15
	db $70		;[Instrument] 1
	db $C3		;[Wait] 4
	db $0C		;[Note] 13
	db $75		;[Instrument] 6
				;[Skip delay] 4
	db $13		;[Note] 20
	db $6E		;[Volume] 14
	db $71		;[Instrument] 2
	db $C7		;[Wait] 8
	db $13		;[Note] 20
	db $C0		;[Wait] 1
	db $6D		;[Volume] 13
	db $C2		;[Wait] 3
	db $0C		;[Note] 13
	db $6F		;[Volume] 15
	db $70		;[Instrument] 1
	db $C3		;[Wait] 4
	db $13		;[Note] 20
	db $6E		;[Volume] 14
	db $71		;[Instrument] 2
				;[Skip delay] 4
	db $5F		;[Note] 96
	db $6F		;[Volume] 15
	db $79		;[Instrument] 10
	db $C7		;[Wait] 8
	db $0C		;[Note] 13
	db $70		;[Instrument] 1
	db $C3		;[Wait] 4
	db $13		;[Note] 20
	db $6E		;[Volume] 14
	db $71		;[Instrument] 2
				;[Skip delay] 4
	db $5F		;[Note] 96
	db $6F		;[Volume] 15
	db $79		;[Instrument] 10
				;[Skip delay] 4
	db $0C		;[Note] 13
	db $70		;[Instrument] 1
				;[Skip delay] 4
	db $13		;[Note] 20
	db $6E		;[Volume] 14
	db $71		;[Instrument] 2
				;[Skip delay] 4
	db $13		;[Note] 20
	db $C0		;[Wait] 1
	db $6D		;[Volume] 13
	db $C2		;[Wait] 3
	db $13		;[Note] 20
	db $6E		;[Volume] 14
	db $C3		;[Wait] 4
	db $BF		;[End-Of-Track]
.track_27:
	db $C3		;[Wait] 4
	db $10		;[Note] 17
	db $6B		;[Volume] 11
	db $7B		;[Instrument] 12
	db $95, $07	; track detune
				;[Skip delay] 4
	db $1C		;[Note] 29
	db $95, $01	; track detune
				;[Skip delay] 4
	db $10		;[Note] 17
	db $95, $07	; track detune
				;[Skip delay] 4
	db $0E		;[Note] 15
	db $95, $06	; track detune
	db $C0		;[Wait] 1
	db $10		;[Note] 17
	db $A6, $10; tone-slide
				;[Skip delay] 1
	db $A6, $13; tone-slide
				;[Skip delay] 1
	db $A6, $10; tone-slide
				;[Skip delay] 1
	db $A6, $11; tone-slide
				;[Skip delay] 1
	db $A6, $11; tone-slide
				;[Skip delay] 1
	db $B0, $02; tone-slide rep
	db $C1		;[Wait] 2
	db $0B		;[Note] 12
	db $95, $01	; track detune
	db $C3		;[Wait] 4
	db $09		;[Note] 10
	db $95, $00	; track detune
	db $C7		;[Wait] 8
	db $09		;[Note] 10
	db $C3		;[Wait] 4
	db $15		;[Note] 22
	db $95, $02	; track detune
				;[Skip delay] 4
	db $09		;[Note] 10
	db $95, $00	; track detune
	db $C7		;[Wait] 8
	db $09		;[Note] 10
	db $C3		;[Wait] 4
	db $0B		;[Note] 12
	db $95, $02	; track detune
				;[Skip delay] 4
	db $0E		;[Note] 15
	db $95, $02	; track detune
				;[Skip delay] 4
	db $BF		;[End-Of-Track]
.track_28:
	db $23		;[Note] 36
	db $6A		;[Volume] 10
	db $7D		;[Instrument] 14
	db $95, $09	; track detune
	db $DB		;[Wait] 28
	db $23		;[Note] 36
	db $95, $09	; track detune
	db $E3		;[Wait] 36
	db $BF		;[End-Of-Track]
.track_29:
	db $C3		;[Wait] 4
	db $10		;[Note] 17
	db $6F		;[Volume] 15
	db $7A		;[Instrument] 11
	db $95, $07	; track detune
				;[Skip delay] 4
	db $1C		;[Note] 29
	db $95, $01	; track detune
				;[Skip delay] 4
	db $10		;[Note] 17
	db $95, $07	; track detune
				;[Skip delay] 4
	db $0E		;[Note] 15
	db $95, $06	; track detune
	db $C0		;[Wait] 1
	db $10		;[Note] 17
	db $A6, $0F; tone-slide
				;[Skip delay] 1
	db $A6, $10; tone-slide
				;[Skip delay] 1
	db $A6, $0F; tone-slide
				;[Skip delay] 1
	db $A6, $0F; tone-slide
				;[Skip delay] 1
	db $A6, $10; tone-slide
				;[Skip delay] 1
	db $B0, $02; tone-slide rep
	db $C1		;[Wait] 2
	db $0B		;[Note] 12
	db $95, $01	; track detune
	db $C3		;[Wait] 4
	db $09		;[Note] 10
	db $95, $00	; track detune
	db $C7		;[Wait] 8
	db $09		;[Note] 10
	db $C3		;[Wait] 4
	db $15		;[Note] 22
	db $95, $02	; track detune
				;[Skip delay] 4
	db $09		;[Note] 10
	db $95, $00	; track detune
	db $C7		;[Wait] 8
	db $09		;[Note] 10
	db $C3		;[Wait] 4
	db $0B		;[Note] 12
	db $95, $02	; track detune
				;[Skip delay] 4
	db $0E		;[Note] 15
	db $95, $02	; track detune
				;[Skip delay] 4
	db $BF		;[End-Of-Track]
.track_30:
	db $1E		;[Note] 31
	db $6F		;[Volume] 15
	db $7C		;[Instrument] 13
	db $95, $07	; track detune
	db $C7		;[Wait] 8
	db $6E		;[Volume] 14
	db $D3		;[Wait] 20
	db $1F		;[Note] 32
	db $6F		;[Volume] 15
	db $95, $07	; track detune
	db $C7		;[Wait] 8
	db $6E		;[Volume] 14
	db $DB		;[Wait] 28
	db $BF		;[End-Of-Track]
.track_31:
	db $1A		;[Note] 27
	db $6F		;[Volume] 15
	db $7C		;[Instrument] 13
	db $95, $06	; track detune
	db $C7		;[Wait] 8
	db $6E		;[Volume] 14
	db $D3		;[Wait] 20
	db $1A		;[Note] 27
	db $6F		;[Volume] 15
	db $95, $06	; track detune
	db $C7		;[Wait] 8
	db $6E		;[Volume] 14
	db $DB		;[Wait] 28
	db $BF		;[End-Of-Track]
.track_32:
	db $36		;[Note] 55
	db $6A		;[Volume] 10
	db $7E		;[Instrument] 15
	db $95, $01	; track detune
	db $C0		;[Wait] 1
	db $37		;[Note] 56
	db $6B		;[Volume] 11
	db $A6, $01; tone-slide
				;[Skip delay] 1
	db $6C		;[Volume] 12
	db $95, $00	; track detune
				;[Skip delay] 1
	db $6D		;[Volume] 13
	db $B0, $02; tone-slide rep
				;[Skip delay] 1
	db $6E		;[Volume] 14
				;[Skip delay] 1
	db $6F		;[Volume] 15
	db $C0		;[Wait..] 1
	db $B0, $02; tone-slide rep
	db $C1		;[Wait] 2
	db $A7, $74	;[CMD vibrato]
	db $C0		;[Wait] 1
	db $B1, $03	;[CMD vibrato] rep
	db $C2		;[Wait] 3
	db $36		;[Note] 55
	db $6B		;[Volume] 11
	db $95, $01	; track detune
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
				;[Skip delay] 1
	db $6D		;[Volume] 13
	db $C9		;[Wait] 10
	db $32		;[Note] 51
	db $6B		;[Volume] 11
	db $95, $01	; track detune
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
				;[Skip delay] 1
	db $6B		;[Volume] 11
				;[Skip delay] 1
	db $6A		;[Volume] 10
				;[Skip delay] 1
	db $32		;[Note] 51
	db $6B		;[Volume] 11
				;[Skip delay] 1
	db $6C		;[Volume] 12
	db $C6		;[Wait] 7
	db $2D		;[Note] 46
	db $6B		;[Volume] 11
	db $95, $00	; track detune
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
	db $C2		;[Wait] 3
	db $2F		;[Note] 48
	db $6B		;[Volume] 11
	db $95, $00	; track detune
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
	db $C2		;[Wait] 3
	db $3B		;[Note] 60
	db $6B		;[Volume] 11
	db $95, $00	; track detune
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
	db $C2		;[Wait] 3
	db $6B		;[Volume] 11
	db $C3		;[Wait] 4
	db $39		;[Note] 58
	db $95, $08	; track detune
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
				;[Skip delay] 1
	db $6D		;[Volume] 13
	db $C1		;[Wait] 2
	db $A7, $74	;[CMD vibrato]
	db $C0		;[Wait] 1
	db $B1, $07	;[CMD vibrato] rep
	db $C6		;[Wait] 7
	db $BF		;[End-Of-Track]
.track_33:
	db $C1		;[Wait] 2
	db $34		;[Note] 53
	db $62		;[Volume] 2
	db $7F		;[Instrument] 16
	db $95, $01	; track detune
	db $C3		;[Wait] 4
	db $36		;[Note] 55
	db $95, $02	; track detune
	db $C0		;[Wait] 1
	db $37		;[Note] 56
	db $A6, $01; tone-slide
				;[Skip delay] 1
	db $95, $00	; track detune
				;[Skip delay] 1
	db $B0, $02; tone-slide rep
	db $C2		;[Wait] 3
	db $B0, $02; tone-slide rep
	db $C1		;[Wait] 2
	db $A7, $74	;[CMD vibrato]
	db $C0		;[Wait] 1
	db $B1, $03	;[CMD vibrato] rep
	db $C2		;[Wait] 3
	db $36		;[Note] 55
	db $95, $02	; track detune
	db $CB		;[Wait] 12
	db $32		;[Note] 51
	db $95, $02	; track detune
	db $C3		;[Wait] 4
	db $32		;[Note] 51
	db $C7		;[Wait] 8
	db $2D		;[Note] 46
	db $95, $01	; track detune
	db $C3		;[Wait] 4
	db $2F		;[Note] 48
				;[Skip delay] 4
	db $3B		;[Note] 60
	db $95, $01	; track detune
	db $C7		;[Wait] 8
	db $39		;[Note] 58
	db $95, $00	; track detune
	db $C3		;[Wait] 4
	db $A7, $74	;[CMD vibrato]
	db $C0		;[Wait] 1
	db $B1, $01	;[CMD vibrato] rep
				;[Skip delay] 1
	db $BF		;[End-Of-Track]
.track_34:
	db $0E		;[Note] 15
	db $6B		;[Volume] 11
	db $7B		;[Instrument] 12
	db $95, $01	; track detune
	db $C7		;[Wait] 8
	db $0E		;[Note] 15
				;[Skip delay] 8
	db $0E		;[Note] 15
	db $C3		;[Wait] 4
	db $10		;[Note] 17
				;[Skip delay] 4
	db $12		;[Note] 19
				;[Skip delay] 4
	db $14		;[Note] 21
	db $95, $02	; track detune
	db $C0		;[Wait] 1
	db $15		;[Note] 22
	db $A6, $0E; tone-slide
				;[Skip delay] 1
	db $A6, $0B; tone-slide
				;[Skip delay] 1
	db $A6, $0C; tone-slide
				;[Skip delay] 1
	db $A6, $0D; tone-slide
				;[Skip delay] 1
	db $A6, $0D; tone-slide
				;[Skip delay] 1
	db $B0, $02; tone-slide rep
	db $C1		;[Wait] 2
	db $15		;[Note] 22
	db $C7		;[Wait] 8
	db $15		;[Note] 22
				;[Skip delay] 8
	db $14		;[Note] 21
	db $95, $03	; track detune
				;[Skip delay] 8
	db $13		;[Note] 20
	db $95, $04	; track detune
	db $C3		;[Wait] 4
	db $BF		;[End-Of-Track]
.track_35:
	db $60		;[Note] 97
	db $C7		;[Wait] 8
	db $36		;[Note] 55
	db $6B		;[Volume] 11
	db $7E		;[Instrument] 15
	db $95, $01	; track detune
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
	db $C1		;[Wait] 2
	db $6B		;[Volume] 11
	db $C0		;[Wait] 1
	db $37		;[Note] 56
	db $95, $00	; track detune
				;[Skip delay] 1
	db $6C		;[Volume] 12
	db $C1		;[Wait] 2
	db $6A		;[Volume] 10
	db $C0		;[Wait] 1
	db $3B		;[Note] 60
	db $6B		;[Volume] 11
				;[Skip delay] 1
	db $6C		;[Volume] 12
	db $C2		;[Wait] 3
	db $39		;[Note] 58
	db $6B		;[Volume] 11
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
	db $C2		;[Wait] 3
	db $3B		;[Note] 60
	db $6B		;[Volume] 11
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
	db $C1		;[Wait] 2
	db $6B		;[Volume] 11
	db $C0		;[Wait] 1
	db $3E		;[Note] 63
	db $95, $00	; track detune
				;[Skip delay] 1
	db $6C		;[Volume] 12
				;[Skip delay] 1
	db $6B		;[Volume] 11
				;[Skip delay] 1
	db $6A		;[Volume] 10
	db $C4		;[Wait] 5
	db $3B		;[Note] 60
	db $6B		;[Volume] 11
	db $95, $00	; track detune
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
				;[Skip delay] 1
	db $6B		;[Volume] 11
				;[Skip delay] 1
	db $6A		;[Volume] 10
	db $C4		;[Wait] 5
	db $39		;[Note] 58
	db $6B		;[Volume] 11
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
				;[Skip delay] 1
	db $6B		;[Volume] 11
				;[Skip delay] 1
	db $6A		;[Volume] 10
	db $C4		;[Wait] 5
	db $35		;[Note] 54
	db $6B		;[Volume] 11
	db $95, $01	; track detune
	db $C0		;[Wait] 1
	db $36		;[Note] 55
	db $6C		;[Volume] 12
	db $A6, $03; tone-slide
				;[Skip delay] 1
	db $A6, $03; tone-slide
				;[Skip delay] 1
	db $A6, $09; tone-slide
				;[Skip delay] 1
	db $34		;[Note] 53
	db $6B		;[Volume] 11
	db $95, $00	; track detune
				;[Skip delay] 1
	db $6C		;[Volume] 12
				;[Skip delay] 1
	db $6B		;[Volume] 11
	db $C1		;[Wait] 2
	db $32		;[Note] 51
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
	db $C2		;[Wait] 3
	db $BF		;[End-Of-Track]
.track_36:
	db $61		;[Volume] 1
	db $B1, $06	;[CMD vibrato] rep
	db $C5		;[Wait] 6
	db $60		;[Note] 97
	db $C7		;[Wait] 8
	db $36		;[Note] 55
	db $62		;[Volume] 2
	db $7F		;[Instrument] 16
	db $95, $02	; track detune
	db $C3		;[Wait] 4
	db $37		;[Note] 56
	db $95, $01	; track detune
				;[Skip delay] 4
	db $3B		;[Note] 60
				;[Skip delay] 4
	db $39		;[Note] 58
				;[Skip delay] 4
	db $3B		;[Note] 60
	db $61		;[Volume] 1
				;[Skip delay] 4
	db $3E		;[Note] 63
	db $62		;[Volume] 2
	db $95, $00	; track detune
	db $C7		;[Wait] 8
	db $3B		;[Note] 60
	db $95, $01	; track detune
				;[Skip delay] 8
	db $39		;[Note] 58
				;[Skip delay] 8
	db $35		;[Note] 54
	db $C0		;[Wait] 1
	db $36		;[Note] 55
	db $A6, $03; tone-slide
				;[Skip delay] 1
	db $A6, $03; tone-slide
				;[Skip delay] 1
	db $A6, $09; tone-slide
				;[Skip delay] 1
	db $34		;[Note] 53
	db $C1		;[Wait] 2
	db $BF		;[End-Of-Track]
.track_37:
	db $94, $01	; vibrato control
	db $C7		;[Wait] 8
	db $13		;[Note] 20
	db $6B		;[Volume] 11
	db $7B		;[Instrument] 12
	db $95, $04	; track detune
				;[Skip delay] 8
	db $13		;[Note] 20
	db $C3		;[Wait] 4
	db $0E		;[Note] 15
	db $95, $01	; track detune
				;[Skip delay] 4
	db $0D		;[Note] 14
	db $95, $02	; track detune
				;[Skip delay] 4
	db $0C		;[Note] 13
	db $95, $02	; track detune
	db $CB		;[Wait] 12
	db $0C		;[Note] 13
	db $C7		;[Wait] 8
	db $0C		;[Note] 13
	db $C3		;[Wait] 4
	db $0E		;[Note] 15
	db $95, $01	; track detune
				;[Skip delay] 4
	db $10		;[Note] 17
	db $95, $07	; track detune
				;[Skip delay] 4
	db $12		;[Note] 19
	db $95, $07	; track detune
	db $C0		;[Wait] 1
	db $A5, $01; slide-down
	db $C2		;[Wait] 3
	db $BF		;[End-Of-Track]
.track_38:
	db $6D		;[Volume] 13
	db $A7, $74	;[CMD vibrato]
	db $C0		;[Wait] 1
	db $B1, $0F	;[CMD vibrato] rep
	db $C6		;[Wait] 7
	db $6C		;[Volume] 12
	db $C7		;[Wait] 8
	db $60		;[Note] 97
	db $C3		;[Wait] 4
	db $2D		;[Note] 46
	db $6B		;[Volume] 11
	db $7E		;[Instrument] 15
	db $95, $00	; track detune
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
	db $C2		;[Wait] 3
	db $2F		;[Note] 48
	db $6B		;[Volume] 11
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
	db $C1		;[Wait] 2
	db $6A		;[Volume] 10
	db $C0		;[Wait] 1
	db $32		;[Note] 51
	db $6B		;[Volume] 11
				;[Skip delay] 1
	db $6C		;[Volume] 12
	db $C1		;[Wait] 2
	db $6B		;[Volume] 11
	db $C0		;[Wait] 1
	db $37		;[Note] 56
	db $95, $00	; track detune
				;[Skip delay] 1
	db $39		;[Note] 58
	db $6C		;[Volume] 12
	db $A6, $03; tone-slide
				;[Skip delay] 1
	db $A6, $05; tone-slide
				;[Skip delay] 1
	db $6D		;[Volume] 13
	db $A6, $07; tone-slide
				;[Skip delay] 1
	db $B0, $01; tone-slide rep
				;[Skip delay] 1
	db $A6, $08; tone-slide
				;[Skip delay] 1
	db $B0, $02; tone-slide rep
	db $C1		;[Wait] 2
	db $37		;[Note] 56
	db $6B		;[Volume] 11
	db $95, $01	; track detune
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
	db $C1		;[Wait] 2
	db $6D		;[Volume] 13
	db $C4		;[Wait] 5
	db $3D		;[Note] 62
	db $6B		;[Volume] 11
	db $95, $00	; track detune
	db $C0		;[Wait] 1
	db $3E		;[Note] 63
	db $6C		;[Volume] 12
	db $A6, $03; tone-slide
				;[Skip delay] 1
	db $A6, $03; tone-slide
				;[Skip delay] 1
	db $6D		;[Volume] 13
	db $A6, $07; tone-slide
				;[Skip delay] 1
	db $A6, $08; tone-slide
				;[Skip delay] 1
	db $B0, $01; tone-slide rep
				;[Skip delay] 1
	db $A6, $09; tone-slide
				;[Skip delay] 1
	db $B0, $01; tone-slide rep
				;[Skip delay] 1
	db $3A		;[Note] 59
	db $6B		;[Volume] 11
	db $95, $00	; track detune
				;[Skip delay] 1
	db $6C		;[Volume] 12
	db $C1		;[Wait] 2
	db $6D		;[Volume] 13
	db $C4		;[Wait] 5
	db $BF		;[End-Of-Track]
.track_39:
	db $C1		;[Wait] 2
	db $32		;[Note] 51
	db $62		;[Volume] 2
	db $7F		;[Instrument] 16
	db $C3		;[Wait] 4
	db $A7, $74	;[CMD vibrato]
	db $C0		;[Wait] 1
	db $B1, $0F	;[CMD vibrato] rep
				;[Skip delay] 1
	db $61		;[Volume] 1
	db $CD		;[Wait] 14
	db $60		;[Note] 97
	db $C3		;[Wait] 4
	db $2D		;[Note] 46
	db $62		;[Volume] 2
	db $95, $01	; track detune
				;[Skip delay] 4
	db $2F		;[Note] 48
	db $7E		;[Instrument] 15
				;[Skip delay] 4
	db $32		;[Note] 51
				;[Skip delay] 4
	db $37		;[Note] 56
	db $95, $01	; track detune
	db $C0		;[Wait] 1
	db $39		;[Note] 58
	db $A6, $03; tone-slide
				;[Skip delay] 1
	db $A6, $05; tone-slide
				;[Skip delay] 1
	db $A6, $07; tone-slide
				;[Skip delay] 1
	db $B0, $01; tone-slide rep
				;[Skip delay] 1
	db $A6, $08; tone-slide
				;[Skip delay] 1
	db $B0, $02; tone-slide rep
	db $C1		;[Wait] 2
	db $37		;[Note] 56
	db $95, $02	; track detune
	db $C7		;[Wait] 8
	db $3D		;[Note] 62
	db $95, $01	; track detune
	db $C0		;[Wait] 1
	db $3E		;[Note] 63
	db $A6, $03; tone-slide
				;[Skip delay] 1
	db $A6, $03; tone-slide
				;[Skip delay] 1
	db $A6, $07; tone-slide
				;[Skip delay] 1
	db $A6, $08; tone-slide
				;[Skip delay] 1
	db $B0, $01; tone-slide rep
				;[Skip delay] 1
	db $A6, $09; tone-slide
				;[Skip delay] 1
	db $B0, $01; tone-slide rep
				;[Skip delay] 1
	db $3A		;[Note] 59
	db $95, $01	; track detune
	db $C1		;[Wait] 2
	db $BF		;[End-Of-Track]
.track_40:
	db $94, $01	; vibrato control
	db $C7		;[Wait] 8
	db $12		;[Note] 19
	db $6B		;[Volume] 11
	db $7B		;[Instrument] 12
	db $95, $07	; track detune
	db $C0		;[Wait] 1
	db $A5, $01; slide-down
	db $C6		;[Wait] 7
	db $10		;[Note] 17
	db $95, $02	; track detune
	db $C3		;[Wait] 4
	db $12		;[Note] 19
	db $95, $07	; track detune
	db $C0		;[Wait] 1
	db $A5, $01; slide-down
	db $C6		;[Wait] 7
	db $0B		;[Note] 12
	db $95, $06	; track detune
	db $C7		;[Wait] 8
	db $17		;[Note] 24
	db $95, $06	; track detune
	db $C3		;[Wait] 4
	db $0B		;[Note] 12
				;[Skip delay] 4
	db $19		;[Note] 26
				;[Skip delay] 4
	db $0E		;[Note] 15
	db $95, $03	; track detune
				;[Skip delay] 4
	db $1B		;[Note] 28
	db $95, $01	; track detune
				;[Skip delay] 4
	db $12		;[Note] 19
	db $95, $07	; track detune
	db $C0		;[Wait] 1
	db $A5, $01; slide-down
	db $C2		;[Wait] 3
	db $10		;[Note] 17
	db $95, $07	; track detune
	db $C3		;[Wait] 4
	db $BF		;[End-Of-Track]
.track_41:
	db $C7		;[Wait] 8
	db $12		;[Note] 19
	db $6F		;[Volume] 15
	db $7A		;[Instrument] 11
	db $95, $07	; track detune
	db $C0		;[Wait] 1
	db $A5, $01; slide-down
	db $C6		;[Wait] 7
	db $10		;[Note] 17
	db $95, $02	; track detune
	db $C3		;[Wait] 4
	db $12		;[Note] 19
	db $95, $07	; track detune
	db $C0		;[Wait] 1
	db $A5, $01; slide-down
	db $C6		;[Wait] 7
	db $0B		;[Note] 12
	db $95, $06	; track detune
	db $C7		;[Wait] 8
	db $17		;[Note] 24
	db $95, $06	; track detune
	db $C3		;[Wait] 4
	db $0B		;[Note] 12
				;[Skip delay] 4
	db $19		;[Note] 26
				;[Skip delay] 4
	db $0E		;[Note] 15
	db $95, $03	; track detune
				;[Skip delay] 4
	db $1B		;[Note] 28
	db $95, $01	; track detune
				;[Skip delay] 4
	db $12		;[Note] 19
	db $95, $07	; track detune
	db $C0		;[Wait] 1
	db $A5, $01; slide-down
	db $C2		;[Wait] 3
	db $10		;[Note] 17
	db $95, $07	; track detune
	db $C3		;[Wait] 4
	db $BF		;[End-Of-Track]
.track_42:
	db $39		;[Note] 58
	db $6B		;[Volume] 11
	db $7E		;[Instrument] 15
	db $95, $00	; track detune
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
	db $C2		;[Wait] 3
	db $32		;[Note] 51
	db $6B		;[Volume] 11
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
				;[Skip delay] 1
	db $6A		;[Volume] 10
				;[Skip delay] 1
	db $6B		;[Volume] 11
				;[Skip delay] 1
	db $3B		;[Note] 60
	db $C0		;[Wait..] 1
	db $6C		;[Volume] 12
	db $C2		;[Wait] 3
	db $32		;[Note] 51
	db $6B		;[Volume] 11
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
				;[Skip delay] 1
	db $6A		;[Volume] 10
				;[Skip delay] 1
	db $6B		;[Volume] 11
				;[Skip delay] 1
	db $3D		;[Note] 62
	db $C0		;[Wait..] 1
	db $6C		;[Volume] 12
	db $C2		;[Wait] 3
	db $32		;[Note] 51
	db $6B		;[Volume] 11
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
	db $C1		;[Wait] 2
	db $6A		;[Volume] 10
	db $C0		;[Wait] 1
	db $39		;[Note] 58
	db $6B		;[Volume] 11
				;[Skip delay] 1
	db $6C		;[Volume] 12
	db $C2		;[Wait] 3
	db $3D		;[Note] 62
	db $6B		;[Volume] 11
	db $C0		;[Wait] 1
	db $3E		;[Note] 63
	db $6C		;[Volume] 12
	db $A6, $03; tone-slide
				;[Skip delay] 1
	db $A6, $06; tone-slide
				;[Skip delay] 1
	db $A6, $09; tone-slide
				;[Skip delay] 1
	db $6B		;[Volume] 11
	db $B0, $04; tone-slide rep
	db $C3		;[Wait] 4
	db $3D		;[Note] 62
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
	db $C2		;[Wait] 3
	db $6B		;[Volume] 11
	db $C3		;[Wait] 4
	db $3B		;[Note] 60
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
	db $C2		;[Wait] 3
	db $6B		;[Volume] 11
	db $C3		;[Wait] 4
	db $3E		;[Note] 63
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
	db $C2		;[Wait] 3
	db $6B		;[Volume] 11
	db $C3		;[Wait] 4
	db $39		;[Note] 58
	db $6A		;[Volume] 10
	db $C0		;[Wait] 1
	db $6B		;[Volume] 11
				;[Skip delay] 1
	db $6C		;[Volume] 12
				;[Skip delay] 1
	db $6D		;[Volume] 13
				;[Skip delay] 1
	db $BF		;[End-Of-Track]
.track_43:
	db $C5		;[Wait] 6
	db $39		;[Note] 58
	db $62		;[Volume] 2
	db $7F		;[Instrument] 16
	db $95, $00	; track detune
	db $C3		;[Wait] 4
	db $32		;[Note] 51
				;[Skip delay] 4
	db $3B		;[Note] 60
				;[Skip delay] 4
	db $32		;[Note] 51
				;[Skip delay] 4
	db $3D		;[Note] 62
				;[Skip delay] 4
	db $32		;[Note] 51
				;[Skip delay] 4
	db $39		;[Note] 58
				;[Skip delay] 4
	db $3D		;[Note] 62
	db $C0		;[Wait] 1
	db $3E		;[Note] 63
	db $A6, $03; tone-slide
				;[Skip delay] 1
	db $A6, $06; tone-slide
				;[Skip delay] 1
	db $A6, $09; tone-slide
				;[Skip delay] 1
	db $B0, $04; tone-slide rep
	db $C3		;[Wait] 4
	db $3D		;[Note] 62
	db $C7		;[Wait] 8
	db $3B		;[Note] 60
				;[Skip delay] 8
	db $3E		;[Note] 63
	db $C5		;[Wait] 6
	db $BF		;[End-Of-Track]
.track_44:
	db $0C		;[Note] 13
	db $6F		;[Volume] 15
	db $70		;[Instrument] 1
	db $C3		;[Wait] 4
	db $0C		;[Note] 13
	db $75		;[Instrument] 6
				;[Skip delay] 4
	db $13		;[Note] 20
	db $6E		;[Volume] 14
	db $71		;[Instrument] 2
	db $C7		;[Wait] 8
	db $13		;[Note] 20
	db $C0		;[Wait] 1
	db $6D		;[Volume] 13
	db $C2		;[Wait] 3
	db $0C		;[Note] 13
	db $6F		;[Volume] 15
	db $70		;[Instrument] 1
	db $C3		;[Wait] 4
	db $13		;[Note] 20
	db $6E		;[Volume] 14
	db $71		;[Instrument] 2
				;[Skip delay] 4
	db $5F		;[Note] 96
	db $6F		;[Volume] 15
	db $79		;[Instrument] 10
	db $C7		;[Wait] 8
	db $13		;[Note] 20
	db $6E		;[Volume] 14
	db $71		;[Instrument] 2
	db $C0		;[Wait] 1
	db $6D		;[Volume] 13
	db $C2		;[Wait] 3
	db $13		;[Note] 20
	db $6E		;[Volume] 14
	db $C0		;[Wait] 1
	db $6D		;[Volume] 13
	db $C2		;[Wait] 3
	db $13		;[Note] 20
	db $6E		;[Volume] 14
	db $C3		;[Wait] 4
	db $13		;[Note] 20
	db $C0		;[Wait] 1
	db $6D		;[Volume] 13
	db $C2		;[Wait] 3
	db $13		;[Note] 20
	db $6E		;[Volume] 14
				;[Skip delay] 3
	db $6D		;[Volume] 13
	db $C0		;[Wait] 1
	db $13		;[Note] 20
	db $6E		;[Volume] 14
				;[Skip delay] 1
	db $6D		;[Volume] 13
	db $C2		;[Wait] 3
	db $13		;[Note] 20
	db $6E		;[Volume] 14
				;[Skip delay] 3
	db $6D		;[Volume] 13
	db $C0		;[Wait] 1
	db $BF		;[End-Of-Track]
.track_45:
	db $94, $01	; vibrato control
	db $C3		;[Wait] 4
	db $10		;[Note] 17
	db $6B		;[Volume] 11
	db $7B		;[Instrument] 12
	db $95, $07	; track detune
				;[Skip delay] 4
	db $1C		;[Note] 29
	db $95, $01	; track detune
				;[Skip delay] 4
	db $10		;[Note] 17
	db $95, $07	; track detune
				;[Skip delay] 4
	db $0E		;[Note] 15
	db $95, $06	; track detune
	db $C0		;[Wait] 1
	db $10		;[Note] 17
	db $A6, $0F; tone-slide
				;[Skip delay] 1
	db $A6, $10; tone-slide
				;[Skip delay] 1
	db $A6, $0F; tone-slide
				;[Skip delay] 1
	db $A6, $0F; tone-slide
				;[Skip delay] 1
	db $A6, $10; tone-slide
				;[Skip delay] 1
	db $B0, $02; tone-slide rep
	db $C1		;[Wait] 2
	db $0B		;[Note] 12
	db $95, $01	; track detune
	db $C3		;[Wait] 4
	db $09		;[Note] 10
	db $95, $00	; track detune
	db $C7		;[Wait] 8
	db $09		;[Note] 10
	db $C3		;[Wait] 4
	db $15		;[Note] 22
	db $95, $02	; track detune
				;[Skip delay] 4
	db $09		;[Note] 10
	db $95, $00	; track detune
	db $C7		;[Wait] 8
	db $09		;[Note] 10
	db $C3		;[Wait] 4
	db $0B		;[Note] 12
	db $95, $02	; track detune
				;[Skip delay] 4
	db $0E		;[Note] 15
	db $95, $02	; track detune
				;[Skip delay] 4
	db $BF		;[End-Of-Track]
.track_46:
	db $1E		;[Note] 31
	db $6F		;[Volume] 15
	db $7C		;[Instrument] 13
	db $95, $07	; track detune
	db $C7		;[Wait] 8
	db $6E		;[Volume] 14
	db $D3		;[Wait] 20
	db $1F		;[Note] 32
	db $6F		;[Volume] 15
	db $95, $07	; track detune
	db $C7		;[Wait] 8
	db $6E		;[Volume] 14
				;[Skip delay] 8
	db $1F		;[Note] 32
	db $6F		;[Volume] 15
	db $95, $07	; track detune
				;[Skip delay] 8
	db $1F		;[Note] 32
	db $95, $07	; track detune
				;[Skip delay] 8
	db $6E		;[Volume] 14
	db $C3		;[Wait] 4
	db $BF		;[End-Of-Track]
.track_47:
	db $1A		;[Note] 27
	db $6F		;[Volume] 15
	db $7C		;[Instrument] 13
	db $95, $06	; track detune
	db $C7		;[Wait] 8
	db $6E		;[Volume] 14
	db $D3		;[Wait] 20
	db $1A		;[Note] 27
	db $6F		;[Volume] 15
	db $95, $06	; track detune
	db $C7		;[Wait] 8
	db $6E		;[Volume] 14
				;[Skip delay] 8
	db $1A		;[Note] 27
	db $6F		;[Volume] 15
	db $95, $06	; track detune
				;[Skip delay] 8
	db $1A		;[Note] 27
	db $95, $06	; track detune
				;[Skip delay] 8
	db $6E		;[Volume] 14
	db $C3		;[Wait] 4
	db $BF		;[End-Of-Track]
.track_48:
	db $6E		;[Volume] 14
	db $C3		;[Wait] 4
	db $A7, $74	;[CMD vibrato]
	db $C0		;[Wait] 1
	db $B1, $0B	;[CMD vibrato] rep
	db $C2		;[Wait] 3
	db $6D		;[Volume] 13
	db $C7		;[Wait] 8
	db $60		;[Note] 97
	db $C3		;[Wait] 4
	db $2D		;[Note] 46
	db $6B		;[Volume] 11
	db $7E		;[Instrument] 15
	db $95, $00	; track detune
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
	db $C2		;[Wait] 3
	db $2F		;[Note] 48
	db $6B		;[Volume] 11
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
	db $C2		;[Wait] 3
	db $32		;[Note] 51
	db $6B		;[Volume] 11
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
	db $C1		;[Wait] 2
	db $6A		;[Volume] 10
	db $C0		;[Wait] 1
	db $36		;[Note] 55
	db $6B		;[Volume] 11
	db $95, $08	; track detune
				;[Skip delay] 1
	db $37		;[Note] 56
	db $6C		;[Volume] 12
	db $A6, $01; tone-slide
	db $C1		;[Wait] 2
	db $B0, $05; tone-slide rep
	db $C4		;[Wait] 5
	db $36		;[Note] 55
	db $6B		;[Volume] 11
	db $95, $00	; track detune
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
	db $C6		;[Wait] 7
	db $32		;[Note] 51
	db $6B		;[Volume] 11
	db $95, $01	; track detune
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
	db $C6		;[Wait] 7
	db $34		;[Note] 53
	db $6B		;[Volume] 11
	db $95, $00	; track detune
	db $C0		;[Wait] 1
	db $6C		;[Volume] 12
	db $C6		;[Wait] 7
	db $BF		;[End-Of-Track]
.track_49:
	db $C1		;[Wait] 2
	db $39		;[Note] 58
	db $62		;[Volume] 2
	db $7F		;[Instrument] 16
	db $C7		;[Wait] 8
	db $A7, $74	;[CMD vibrato]
	db $C0		;[Wait] 1
	db $B1, $0B	;[CMD vibrato] rep
	db $CA		;[Wait] 11
	db $60		;[Note] 97
	db $C3		;[Wait] 4
	db $2D		;[Note] 46
	db $63		;[Volume] 3
	db $95, $01	; track detune
				;[Skip delay] 4
	db $2F		;[Note] 48
				;[Skip delay] 4
	db $32		;[Note] 51
				;[Skip delay] 4
	db $36		;[Note] 55
	db $95, $00	; track detune
	db $C0		;[Wait] 1
	db $37		;[Note] 56
	db $A6, $01; tone-slide
	db $C1		;[Wait] 2
	db $B0, $05; tone-slide rep
	db $C4		;[Wait] 5
	db $36		;[Note] 55
	db $95, $00	; track detune
	db $C7		;[Wait] 8
	db $32		;[Note] 51
	db $95, $01	; track detune
				;[Skip delay] 8
	db $34		;[Note] 53
	db $95, $00	; track detune
	db $C1		;[Wait] 2
	db $BF		;[End-Of-Track]
.track_50:
	db $BF		;[End-Of-Track]
; [ Song sub-track data ]
