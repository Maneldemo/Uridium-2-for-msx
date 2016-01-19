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


[A,MAP] = imread('levels\lev1.png');


[ A MAP] = imapprox(A,MAP,pal, 'nodither');
%[ A MAP] = imapprox(A,MAP,pal);
pal = MAP;
%MAP = pal;

S = fix(size(A)/16).*16;
H = S(1);
W = S(2);

B = A(1:H,1:W);

H = size(B,1);
W = size(B,2);

image(B);
axis equal;
colormap(MAP);

InpTiles = im2col(B,'indexed',[16 16],'distinct');

 
% if (0)
% 	RGB = ind2rgb(InpTiles',MAP);
% 	t = [RGB(:,:,1) RGB(:,:,2) RGB(:,:,3)];
% 	[IDX, C] = kmeans(t, 256,'EmptyAction','singleton','Replicates',10,'OnlinePhase','on');
% 	UniqueTiles = zeros(256,256,3);
% 	UniqueTiles (:,:,1) = C(:,1:256);
% 	UniqueTiles (:,:,2) = C(:,257:512);
% 	UniqueTiles (:,:,3) = C(:,513:768);
% 	UniqueTiles = rgb2ind(UniqueTiles,MAP);
% 	InpMap=IDX;
% else
    UniqueTiles = unique(InpTiles','rows');
    
    fun = @(block_struct) norm(double(block_struct.data));
    C = blockproc(double(UniqueTiles),[1 256],fun);

    [~,i] = sort(C,1); 
    UniqueTiles = UniqueTiles(i,:);
    
    [~,InpMap] = ismember(InpTiles',UniqueTiles,'rows');
% end

Ntiles = (H/16*W/16);

ReducedImage = UniqueTiles(InpMap,:);

A = col2im(ReducedImage',[16 16],[H W],'distinct');

figure
image(A);
axis equal;
colormap(MAP)

UniqueTiles = UniqueTiles';

K = size(UniqueTiles,2)
T = UniqueTiles;

% if (K<=256)
%    T = [UniqueTiles zeros(256,256-K)];
%    T = UniqueTiles;
% else
%    T = UniqueTiles(:,1:256) ;
% end

%TT = [T(1:16:256,:); T(2:16:256,:); T(3:16:256,:); T(4:16:256,:)]


% fun2 = inline('rgb2ind(ind2rgb(x,M),p,s)','x','M','p','s');
% TT = blkproc(T,[256 1],fun2,MAP,pal,'nodither'); 

TT = T;

B = col2im(TT,[16 16],[16 16*K],'distinct');

fun1 = inline('transpose(x)');
C = blkproc(B,[16 16],fun1)'; 

CC = uint8(zeros((fix(size(C,1)/256)+1)*256,16));
CC(1:size(C,1),:) = C;

n = size(CC,1)/16;

D = [];

x = 1;
for j=1:n/16
    E = [];
    for i=1:16
        E = [E CC(x:(x+15),:)];
        x = x+16;
    end
    D = [ D ; E];
end

figure
image(D)
axis equal;
colormap(pal)
imwrite(D,pal,'tilesets\tileset.png','png');

NewMap = InpMap;

X = reshape(NewMap,H/16,W/16);

figure;
image(X)
axis equal;
colormap(gray)

fid = fopen('datamap.bin','wb');
for i=1:(H/16)
    fwrite(fid,X(i,:)-1,'uchar');
end
fclose(fid);

fid = fopen('levels\datamap.txt','wb');
for i=1:(H/16)
    for j=1:(W/16)
        fprintf(fid,'   <tile gid="%i"/> \n',X(i,j));
    end
end
fclose(fid);

ReducedImage = T(:,NewMap);

A = col2im(ReducedImage,[16 16],[H W],'distinct');

figure
image(A)
colormap(MAP)
imwrite(A,MAP,'output.png','png');

fid = fopen('tiles.bin','wb');
for y=1:K
    t = uint8(TT(:,y));
    fwrite(fid,t,'uchar');
end
for y=K+1:256
     fwrite(fid,zeros(256,1),'uchar');
end

fclose(fid);

%figure;
%image(kron(1:256,ones(256)))
%colormap(MAP);

size(unique(C,'rows'))