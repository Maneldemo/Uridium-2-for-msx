
function   [s1,s2,c1,c2] = convert_line2(line,MAP,sprtpalrgb)

%line =  1+ double([17 17 17 13 13 13 13 13 13 13 10 17 17 17 17 17]);

      %  green red blue
% sprtpalgrb =  [ 0 0 0
%                 0 0 2
%                 0 3 0
%                 0 3 2
%                 3 0 0
%                 3 0 2
%                 3 3 0
%                 3 3 2
%                 4 7 2
%                 0 0 7
%                 0 7 0
%                 0 7 7
%                 7 0 0
%                 7 0 7
%                 7 7 0
%                 7 7 7];
% 
% sprtpalrgb = sprtpalgrb(:,[2 1 3])/7;
% MAP = sprtpalrgb;
% MAP(18,:) = [6 0 6]/7;

e = inf;
for c1=0:15
    for c2=(c1+1):15
        pal = [MAP(18,:); sprtpalrgb(1+[c1, c2, bitor(c1,c2)],:)];
        m = imapprox(line,MAP,pal, 'nodither');
        ne = sum(sum((MAP(line,:) - pal(1+m,:)).^2));

            if (ne<e) 
                e = ne;
                s1 = ((m==1)+(m==3))>0;
                s2 = ((m==2)+(m==3))>0;
                mc1 = c1;
                if any(any(m==3))
                    mc2 = c2+64;
                else
                    mc2 = c2;
                end
            end
        end
    end
c1 = mc1;
c2 = mc2;
% s1
% s2
% c1
% c2

return