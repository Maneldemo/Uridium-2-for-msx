		output "TOTALRAS.rom"

		defpage	 0,0x4000, 0x2000		; page 0 main code 
		defpage	 1,0x6000, 0x2000		; page 1 
		defpage	 2..31					; swapped data 
	
		;	konami scc
		
_kBank1:	equ 05000h ;- 57FFh (5000h used)
_kBank2: 	equ 07000h ;- 77FFh (7000h used)
_kBank3: 	equ 09000h ;- 97FFh (9000h used)
_kBank4: 	equ 0B000h ;- B7FFh (B000h used)
	
		page 0
		
        org 4000h
        dw  4241h,START,0,0,0,0,0,0

screeninit:
		ld		a,8
		call	005fh		; screen 1
		ld		hl,0h
		call	0053h		

		ld		de,256*:_opening+7
		
outvram:
2:		ld	a,d
		ld	(_kBank2),a
		ld	hl,0x6000
		
		ld	bc,0x98
		ld	a,32
1:		otir
		dec	a
		jp	nz,1b
		inc	d
		dec	e
		jr	nz,2b
		ret
		
		
		
		
START:  
		call	screeninit
		
		di                
		ld     a,#97      
		out    (#99),a    
		ld     a,#91      
		out    (#99),a  
		ei

		halt              ; allow ISR
		
		ld     de,sintab
1:   	call   raster_wave
		call   #009c      
		jr     z,1b    
		
		ret    
;S#2		
;b6	VR: Vertical scanning line timing flag
;		During vertical scanning, this flag is set to 1.

;b5	HR: Horizontal scanning line timing flag
;		During horizontal scanning, this flag is set to 1.
       
raster_wave:   
		di                
		ld     a,#02      
        out    (#99),a    
		ld     a,#8f      
		out    (#99),a


		ld		c,0x9B
		
1:   	in     a,(#99)    ; wait for VR (start of the frame)
		bit    6,a        
		jp     nz,1b

		ld		h,d
		ld		l,e
		
.loop:		

1:   	in     a,(#99)     ; wait for HR (end of the line)
		bit    5,a        
		jr     z,1b   

		outi
		
		bit    6,a        ; wait for VR (end of the frame)
		jr     z,.loop    
		

		xor    a          
		out    (#99),a    
		ld     a,#8f      
		out    (#99),a    
		ei                
		ret
		
           

sintab:  
	include rast.txt
endsintab:
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

