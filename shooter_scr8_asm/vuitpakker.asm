
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


_vuitpakker:
    push iy
    push ix

    call  1f

    pop ix
    pop iy
    ret

1:
; in de input
; in bc VRAM output

    ld h,d
    ld l,e
    ld d,b
    ld e,c

; pletter v0.5 msx unpacker

;-----------------------------------------------------------
; Pletter 0.5b VRAM Depacker - 64Kb version
; HL = RAM/ROM source ; DE = VRAM destination
;-----------------------------------------------------------
    di

; VRAM address setup
;    ld  a,e
;    out (0x99),a
;    ld  a,d
;    or  0x40
;    out (0x99),a
    call setVwrite

; Initialization
    ld  a,(hl)
    inc hl
    exx
    ld  de,0
    add a,a
    inc a
    rl  e
    add a,a
    rl  e
    add a,a
    rl  e
    rl  e
    ld  hl,__modes
    add hl,de
    ld  e,(hl)
    db    0xdd
    ld  l,e         ; ld ixl,e    
    inc hl
    ld  e,(hl)
    db    0xdd
    ld h,e          ; ld  ixh,e
    ld  e,1
    exx
    ld  iy,__loop

; Main depack loop
_literal:ld  c,098h
    outi
    inc de
__loop:   add a,a
    call    z,_getbit
    jr  nc,_literal

; Compressed data
    exx
    ld  h,d
    ld  l,e
_getlen: add a,a
    call    z,_getbitexx
    jr  nc,lenok
lus:    add a,a
    call    z,_getbitexx
    adc hl,hl
    ret c
    add a,a
    call    z,_getbitexx
    jr  nc,lenok
    add a,a
    call    z,_getbitexx
    adc hl,hl
    jp  c,Depack_out
    add a,a
    call    z,_getbitexx
    jp  c,lus
lenok:  inc hl
    exx
    ld  c,(hl)
    inc hl
    ld  b,0
    bit 7,c
    jp  z,offsok
    jp  (ix)

_mode7:  add a,a
    call    z,_getbit
    rl  b
_mode6:  add a,a
    call    z,_getbit
    rl  b
_mode5:  add a,a
    call    z,_getbit
    rl  b
_mode4:  add a,a
    call    z,_getbit
    rl  b
_mode3:  add a,a
    call    z,_getbit
    rl  b
_mode2:  add a,a
    call    z,_getbit
    rl  b
    add a,a
    call    z,_getbit
    jr  nc,offsok
    or  a
    inc b
    res 7,c
offsok: inc bc
    push    hl
    exx
    push    hl
    exx
    ld  l,e
    ld  h,d
    sbc hl,bc
    pop bc
    push    af
_loop: 
;    ld  a,l
;    out (0x99),a
;    ld  a,h
;    out (0x99),a
    call setVread
    
    in  a,(0x98)
    ex  af,af'
;    ld  a,e
;    out (0x99),a
;    ld  a,d
;    or  0x40
;    out (0x99),a
    call setVwrite
    
    ex  af,af'
    out (0x98),a
    inc de
    cpi
    jp  pe,_loop
    pop af
    pop hl
    jp  (iy)
;
_getbit: ld  a,(hl)
    inc hl
    rla
    ret

_getbitexx:
    exx
    ld  a,(hl)
    inc hl
    exx
    rla
    ret

; De-packer exit
Depack_out:
    ei
    ret



setVwrite:

    push    de
    push    bc
    ld      bc,(_vbit16)
    call    _vdpsetvramwr
    pop     bc
    pop     de

    ret
setVread:    

    push    de
    push    bc
    ld      e,l
    ld      d,h
    ld      bc,(_vbit16)
    call    _vdpsetvramrd
    pop     bc
    pop     de

    ret

__modes:
    dw  offsok
    dw  _mode2
    dw  _mode3
    dw  _mode4
    dw  _mode5
    dw  _mode6
    dw  _mode7
