clear
close all
 

      %  green red blue
sprtpalgrb =  [ 0 0 0
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
t = imresize(t,sprtpalrgb,16,'nearest', 'Colormap','original');
image(t)
colormap(sprtpalrgb);
imwrite(t,sprtpalrgb,['grpx\spritepalette.png'],'png', 'BitDepth',8)
axis equal
grid


name = 'mship02';

[AA,MMAP] = imread([name '.png']);
AA(find(AA==19))=17;

MMAP = MMAP(1:16,:);
MAP = sprtpalrgb;
MAP(18,:) = [3 3 3]/7;

Y = AA;
figure
image(Y)
axis equal
colormap(MAP)

Y = [Y(1:32,:)  Y(33:64,:)  Y(65:96,:) Y(97:128,:)  Y(129:160,:)];

Frames = im2col(Y,[32 16],'distinct');

[C,IA,IC] = unique(Frames','rows');

CC = C';
A = col2im( CC,[32 16],[32 size(CC,2)*16],'distinct');

[LIA,LOCB] = ismember(Frames',C,'rows');

figure
image(A)
axis equal
colormap(MAP)

imwrite(A,MAP,['grpx\' name '_shapes.png'],'png', 'BitDepth',8)

IC = LOCB;

fid = fopen([name '_ani.asm'],'w');
fprintf (fid,[name '_ani:\n']);
fprintf (fid,'    defb %d \n',IC-1);
fclose(fid);

Y=A;
Nframes = size(CC,2);

frame1 = cell(16,Nframes);
frame2 = cell(16,Nframes);
frame3 = cell(16,Nframes);
color1 = cell(16,Nframes);
color2 = cell(16,Nframes);



figure
axis equal
colormap(MAP)

k = 0;
h = 0;
for i = 1:Nframes
    img = Y(h+[1:16],k+[1:16]);
    image(img);
    drawnow;
    i
    for j = 1:16
        line = double(img(j,:))+1;
        [s1,s2,c1,c2] = convert_line2(line);
        frame1{j,i} = s1;
        frame2{j,i} = s2;
        color1{j,i} = c1;
        color2{j,i} = c2;
    end
    
    img = Y(h+[17:32],k+[1:16]);
    for j = 1:16
        line = double(img(j,:))+1;
        [s,c] = convert_line(line);
        frame3{j,i} = s;
    end
    
    k = k + 16;
    if (k>=size(Y,2))
        k = 0;
        h = h + 32;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% save sprite data


fid = fopen([name '_frm.bin'],'w');
fid2 = fopen([name '_clr.bin'],'w');

for i = 1:Nframes
    for j = 1:16
        s = frame1{j,i};
        t = dec2hex(bi2de(s(1:8),'left-msb'),2);
        fwrite (fid,hex2dec(t));
    end
    for j = 1:16
        s = frame1{j,i};    
        t = dec2hex(bi2de(s(9:16),'left-msb'),2);
        fwrite (fid,hex2dec(t));
    end
    for j = 1:16
        s = frame2{j,i};
        t = dec2hex(bi2de(s(1:8),'left-msb'),2);
        fwrite (fid,hex2dec(t));
    end
    for j = 1:16
        s = frame2{j,i};    
        t = dec2hex(bi2de(s(9:16),'left-msb'),2);
        fwrite (fid,hex2dec(t));
    end
    for j = 1:16
        s = frame3{j,i};
        t = dec2hex(bi2de(s(1:8),'left-msb'),2);
        fwrite (fid,hex2dec(t));
    end
    for j = 1:16
        s = frame3{j,i};    
        t = dec2hex(bi2de(s(9:16),'left-msb'),2);
        fwrite (fid,hex2dec(t));
    end
    for j = 1:16
        s = color1{j,i};
        fwrite (fid2,s);
    end
    for j = 1:16
        s = color2{j,i};
        fwrite (fid2,s);
    end

end
fclose(fid);
fclose(fid2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% save collision window

minx = zeros(Nframes,1);
maxx = zeros(Nframes,1);
miny = zeros(Nframes,1);
maxy = zeros(Nframes,1);

h = 1;
kk = 0;
for i = 1:Nframes
    A = Y([1:16],kk+[1:16]) ~= 17;
    for x = 1:16
        if any(A(:,x))
            minx(h) = x;
            break;
        end
    end
    for x = 16:-1:1
        if any(A(:,x))
            maxx(h) = x;
            break;
        end
    end
    for x = 1:16
        if any(A(x,:))
            miny(h) = x;
            break;
        end
    end
    for x = 16:-1:1
        if any(A(x,:))
            maxy(h) = x;
            break;
        end
    end
    %[h minx(h) maxx(h) miny(h) maxy(h)]
    h = h + 1;
    kk = kk+ 16;
end

fid = fopen([name '_frm_coll_wind.asm'],'w');
fprintf (fid,[name '_coll_wind:\n']);
for h = 1:size(Y,2)/16
     fprintf (fid,'    defb %d,%d,%d,%d \n',[minx(h) maxx(h)-1 miny(h) maxy(h)-1] );
end
fprintf (fid,'\n');
fclose(fid);
