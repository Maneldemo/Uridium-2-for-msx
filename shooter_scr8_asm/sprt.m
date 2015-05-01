clear
close all
 

red   = [0,  36,  73, 109, 146, 182, 219, 255];
green = [0,  36,  73, 109, 146, 182, 219, 255];
blue  = [0,  73, 146, 255];

i=1;
for g=0:7
    for r=0:7
        for b=0:3
            pal(i,:) = ([red(r+1) green(g+1) blue(b+1)]/255);
            i=i+1;
        end
    end
end

%[A,MAP] = imread('bmp\Sprite_Palette_OR.bmp'); sprtpaldec = round(MAP(double(A(1:16:256,1))+1,:)*7);

      %  green red blue
sprtpalgrb = [ 0 0 0
    0 0 2
    0 3 0
    0 3 2
    3 0 0
    3 0 2
    3 3 0
    3 3 2
    4 7 2
    0 0 7
    0 7 0
    0 7 7
    7 0 0
    7 0 7
    7 7 0
    7 7 7];
        
sprtpalrgb = sprtpalgrb(:,[2 1 3])/7;
        
figure;
r = uint8(kron(0:15,ones(16,1)));
t = bitor(r,r');
image(t)
colormap(sprtpalrgb);
axis equal
grid

name = 'main ship02.gif';
[AA,MMAP] = imread(['ene_code\' name]);
MMAP = MMAP(1:16,:);
%name = 'uridium_rev9';
MAP = sprtpalrgb;

%[A,MAP] = imread(['ene_code\' name '.bmp']);
MAP(1,:) = [7 0 7]/7;

A= AA(:,:,1,1);
F = imapprox(A, MMAP, sprtpalrgb,'nodither');


F0 = zeros(size(F));
F1 = zeros(size(F));
F2 = zeros(size(F));


for y=1:16
    e = inf;
    for c1=0:15
        for c2=(c1+1):15
            pal = [MAP(1,:); sprtpalrgb(1+[c1, c2, bitor(c1,c2)],:)];
            
            l = F(y,:);
            m = imapprox(l,MAP,pal, 'nodither');
            
            ne = sum(sum((MAP(1+l,:)-pal(1+m,:)).^2));

            if (ne<e) 
                e = ne;
                F0(y,:) = (m>0);
                F1(y,:) = ((m==1)+(m==3)>0)*c1;
                F2(y,:) = ((m==2)+(m==3)>0)*c2;
            end
        end
    end
end
        
figure;
image(bitand(bitor(F1,F2),F0*15)+2)
colormap([MAP(1,:); sprtpalrgb]);
axis equal

Y1 = F1>0;
Y2 = F2>0;

Y = [Y1;Y2];
figure
image(Y)
colormap(flag)
axis equal

%imwrite(Y*16,MAP,[name '.png'],'png', 'BitDepth',8);

Nframes = size(Y,1)*size(Y,2)/16/16;

frames = cell(32,Nframes);

figure;
k = 0;
h = 0;
for i = 1:size(frames,2)
    for j = 1:16
        frames{j,i} = dec2hex(bi2de(Y(h+j,k+[1:8]),'left-msb'),2);
    end
    for j=17:32
        frames{j,i} = dec2hex(bi2de(Y(h+j-16,k+8+[1:8]),'left-msb'),2);
    end
    image( [ Y(h+[1:16],k+[1:8]) Y(h+[17:32]-16,k+8+[1:8])]);
    colormap(MAP);
    %pause
    k = k + 16;
    if (k>=size(Y,2))
        k = 0;
        h=h+16;
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% save sprite data

fid = fopen([name '.asm'],'w');
fprintf (fid,[name ':\n']);
for i=1:size(frames,2)
    fprintf (fid,[ name '_%d \n'],i-1);
    for j=1:32
        fprintf (fid,'    defb 0x%s \n',frames{j,i});
    end
    fprintf (fid,'\n');
end
fclose(fid);
