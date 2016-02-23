		output "TOTALRAS.rom"

		defpage	 0,0x4000, 0x2000		; page 0 main code 
		page 0
		
        org 4000h
        dw  4241h,START,0,0,0,0,0,0

		
START:   
		di                
		ld     a,#97      
		out    (#99),a    
		ld     a,#91      
		out    (#99),a    
		
1:   	ld     bc,#0100   
		ld     hl,sintab1
		call   raster_wave
		call   #009c      
		jr     z,1b    

		ld     bc,#0200   
		ld     hl,sintab2 
		call   raster_wave      
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
		
1:   	in     a,(#99)    ; wait for VR (start of the frame)
		bit    6,a        
		jr     nz,1b

		ld     e,l        
		ld     d,h       
.loop:		
1:   	in     a,(#99)     ; wait for HR (start of the line)
		bit    5,a        
		jr     nz,1b   

		ld     a,(de)     
		out    (#9b),a    
		inc    de         
		
1:   	in     a,(#99)    ; wait for HR (end of the line)
		bit    5,a        
		jr     z,1b
		
		bit    6,a        ; wait for VR (end of the frame)
		jr     z,.loop    
		
		xor    a          
		out    (#99),a    
		ld     a,#8f      
		out    (#99),a    
		ei                
		halt              ; allow ISR
		inc    hl         
		dec    bc         
		ld     a,b        
		or     c          
		jr     nz,raster_wave
		ret               


sintab:  
	db 00h,01h,01h,02h,03h,03h,04h,04h,05h,05h
	db 05h,06h,06h,06h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h
	db 07h,06h,06h,06h,05h,05h,05h,04h,04h,03h,03h,02h,01h,01h,00h,00h
	db 00h,00h,FFh,FEh,FEh,FDh,FDh,FCh,FCh,FBh,FBh,FAh,FAh,FAh,F9h,F9h
	db F9h,F9h,F9h,F9h,F9h,F9h,F9h,F9h,F9h,F9h,F9h,F9h,FAh,FAh,FAh,FBh
	db FBh,FCh,FCh,FDh,FDh,FEh,FEh,FFh,FFh,00h,00h,00h,01h,01h,02h,02h
	db 03h,03h,04h,04h,05h,05h,06h,06h,06h,07h,07h,07h,07h,07h,07h,07h
	db 07h,07h,07h,07h,07h,07h,07h,06h,06h,06h,05h,05h,04h,04h,03h,03h
	db 02h,02h,01h,00h,00h,00h,00h,FFh,FFh,FEh,FDh,FDh,FCh,FCh,FBh,FBh
	db FBh,FAh,FAh,FAh,F9h,F9h,F9h,F9h,F9h,F9h,F9h,F9h,F9h,F9h,F9h,F9h
	db F9h,FAh,FAh,FAh,FBh,FBh,FBh,FCh,FCh,FDh,FDh,FEh,FFh,FFh,00h,00h
	db 00h,00h,01h,02h,02h,03h,03h,04h,04h,05h,05h,06h,06h,06h,07h,07h
	db 07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,06h,06h,06h,05h
	db 05h,04h,04h,03h,03h,02h,02h,01h,01h,00h,00h,00h,FFh,FFh,FEh,FEh
	db FDh,FDh,FCh,FCh,FBh,FBh,FAh,FAh,FAh,F9h,F9h,F9h,F9h,F9h,F9h,F9h
	db F9h,F9h,F9h,F9h,F9h,F9h,F9h,FAh,FAh,FAh,FBh,FBh,FCh,FCh,FDh,FDh
	db FEh,FEh,FFh,00h,00h,00h      
       
C156:        
