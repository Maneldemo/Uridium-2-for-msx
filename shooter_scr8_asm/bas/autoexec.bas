10 color 15,0,0:screen 8,3
20 sprite$(0)=string$(32,255):s=0
30 for y=0 to 212  step 128
35 for x = 0 to 255 step 32
40 put sprite s,(x,y),s,0
50 put sprite s+16,(x,y+32),s,0
55 s=s+1
60 next:next
70 for x = 0 to 255 
80 line (x,0)-(x,212),x
90 next
100 goto 100
