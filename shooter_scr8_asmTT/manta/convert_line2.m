
function   [s1,s2,c1,c2] = convert_line2(line,MAP,sprtpalrgb)

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

return