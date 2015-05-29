
; // Line Bit_7 Bit_6 Bit_5 Bit_4 Bit_3 Bit_2 Bit_1 Bit_0
; // 0 "7" "6" "5" "4" "3" "2" "1" "0"
; // 1 ";" "]" "[" "\" "=" "-" "9" "8"
; // 2 "B" "A" ??? "/" "." "," "'" "`"
; // 3 "J" "I" "H" "G" "F" "E" "D" "C"
; // 4 "R" "Q" "P" "O" "N" "M" "L" "K"
; // 5 "Z" "Y" "X" "W" "V" "U" "T" "S"
; // 6 F3 F2 F1 CODE CAP GRAPH CTRL SHIFT
; // 7 RET SEL BS STOP TAB ESC F5 F4
; // 8 RIGHT DOWN UP LEFT DEL INS HOME SPACE

checkkbd:
		di
		in	a,(0aah)
		and 011110000B			; upper 4 bits contain info to preserve
		or	e
		out (0aah),a
		in	a,(0a9h)
		ld	l,a
		ei
		ret
