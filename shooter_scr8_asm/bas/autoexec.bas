10 color 15,0,0:screen 8,3
20 sprite$(0)=string$(32,255):s=0
30 for y=0 to 212  step 128
40 for x = 0 to 255 step 32
50 put sprite s,(x,y),s,0
60 put sprite s+16,(x,y+32),s,0
70 s=s+1
80 next:next
100 goto 100
