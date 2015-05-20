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


name = 'enemies';
[AA,MAP] = imread([name '.bmp']);

% MAP = sprtpalrgb;
% MAP(18,:) = [6 0 6]/7;
sprtpalrgb = [ sprtpalrgb ; MAP(18,:)];

Y = AA;
figure
image(Y)
axis equal
colormap(MAP)

Y = [Y(1:16,:)  Y(17:32,:)  Y(33:48,:) Y(49:64,:)  Y(65:80,:) Y(81:96,:)];

Frames = im2col(Y,[16 16],'distinct');
Nframes = size(Frames,2);


frame1 = cell(16,Nframes);
frame2 = cell(16,Nframes);
color1 = cell(16,Nframes);
color2 = cell(16,Nframes);

figure
axis equal
colormap(MAP)

k = 0;
h = 0;
Template = [];
for i = 1:Nframes 
    img = Y(h+[1:16],k+[1:16]);
    image(img);
    drawnow;
    Template = [Template img];
    i

    for j = 1:16
        line = double(img(j,:))+1;
        [s1,s2,c1,c2] = convert_line2(line,MAP,sprtpalrgb);
        frame1{j,i} = s1;
        frame2{j,i} = s2;
        color1{j,i} = c1;
        color2{j,i} = c2;
    end
        
    k = k + 16;
    if (k>=size(Y,2))
        k = 0;
        h = h + 32;
    end

end
imwrite(Template,MAP,['grpx\' name '_org.png'],'png', 'BitDepth',8)

org = MAP(1+Template);


MAP = sprtpalrgb;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% save converted sprite data
k = 0;
h = 0;
YY = Y;

for i = 1:Nframes
    img = zeros(16);
    for j = 1:16
        line = bitor(frame1{j,i}*color1{j,i},frame2{j,i}*bitand(color2{j,i},15));
        line(find(bitand(frame1{j,i}==0,frame2{j,i}==0))) = 16;
        img(j,:) = line;
    end
    YY(h+[1:16],k+[1:16]) = img ;
    k = k + 16;
    if (k>=size(YY,2))
        k = 0;
        h = h + 32;
    end
end
imwrite(YY,MAP,['grpx\' name '_scr8.png'],'png', 'BitDepth',8)

imwrite(abs(org-sprtpalrgb(1+YY)),['grpx\' name '_comp.bmp'],'bmp')


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


% %system(['miz\MSX-O-Mizer -r data_bin\' [name '.bin'] ' data_miz\' [name '.miz'] ]);
% 
% % store collision data for tile tests (only for MS bullets)
% 
% Y = Y(17:32,:);
% 
% minx = zeros(size(Y,2),1);
% maxx = zeros(size(Y,2),1);
% miny = zeros(size(Y,2),1);
% maxy = zeros(size(Y,2),1);
% 
% h = 1;
% for k = 1:16:size(Y,2)
%     
%     A = Y(:,k:(k+15));
%        
%     for x = 1:16
%         if any(A(:,x))
%             minx(h) = x;
%             break;
%         end
%     end
%     for x = 16:-1:1
%         if any(A(:,x))
%             maxx(h) = x;
%             break;
%         end
%     end
%     for x = 1:16
%         if any(A(x,:))
%             miny(h) = x;
%             break;
%         end
%     end
%     for x = 16:-1:1
%         if any(A(x,:))
%             maxy(h) = x;
%             break;
%         end
%     end
%     [h minx(h) maxx(h) miny(h) maxy(h)]
%     h = h+1;
% end
% 
% name = 'ms_bllts';
% 
% fid = fopen([name '_frm_coll_wind.asm'],'w');
% fprintf (fid,[name '_coll_wind:\n']);
% for h = 1:size(Y,2)/16
%      fprintf (fid,'    defb %d,%d,%d,%d \n',[minx(h) maxx(h)-1 miny(h) maxy(h)-1] );
% end
% fprintf (fid,'\n');
% fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% save sprite data
% 
% fid = fopen([name '.asm'],'w');
% fprintf (fid,[name ':\n']);
% for i=1:size(frames,2)
%     fprintf (fid,[ name '_%d: \n'],i-1);
%     for j=1:32
%         if (j==1)
%             fprintf (fid,'    defb 0x%s,', binaryVectorToHex(frames{j,i}));
%         elseif (j<32)
%             fprintf (fid,'0x%s,', binaryVectorToHex(frames{j,i}));
%         else
%             fprintf (fid,'0x%s\n', binaryVectorToHex(frames{j,i}));
%         end
%     end
%     fprintf (fid,'\n');
% end
% fclose(fid);

% ; xoff			db	0
% ; yoff			db	0
% ; xsize			db	0
% ; ysize			db	0


Y = AA~=17;
fid = fopen(['sprite_collision_window.asm'],'w');

text = [ '\n ; xoff			db	0 \n ; yoff			db	0 \n ; xsize		db	0 \n ; ysize		db	0 \n\n'];

fprintf (fid,text);

k = 0;
for j = 1:16:(size(Y,1)-15)
    for i = 1:16:(size(Y,2)-15)

        fprintf (fid,'sprite_%d:\n',k);
        
        T = Y(j:(j+15),i:(i+15));
%         image(T)
%         colormap(MAP)
%         axis equal;
        [~,indx] = find(sum(T));
        [~,indy] = find(sum(T'));
        if (~isempty(indx) && ~isempty(indy))
            fprintf (fid,'    defb %2d,%2d,%2d,%2d \n',min(indx)-1,min(indy)-1,max(indx)-min(indx)+1,max(indy)-min(indy)+1);
        end
        
        
        %pause
        
        k = k+1;
    end
    
end
fclose(fid);
