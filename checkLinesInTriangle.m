function result = checkLinesInTriangle(triangle,lines,pix)
%   Dreieckkanten Hough lines evaluierung - Deckungsgrad
%
%   EINGABE
%   triangles .. Dreieckpunkte
%   lines .. Hough lines
%   AUSGABE
%   result .. 1 wenn Deckungsgrad erfüllt, sonst 0
%
%   author: Bernhard Vorderegger

    MINCOVERAGE = 0.3;
    T1 = [triangle(1,1) triangle(1,2)];
    T2 = [triangle(1,3) triangle(1,4)];
    T3 = [triangle(1,5) triangle(1,6)];
    
    result = 0;
    count = 0;
    %lineinArea(T1,T2,lines,pix)
    if lineinArea(T1,T2,lines,pix) > MINCOVERAGE
        count = count+1;
    end
    %lineinArea(T2,T3,lines,pix)
    if lineinArea(T2,T3,lines,pix) > MINCOVERAGE
        count = count+1;
    end
    %lineinArea(T1,T3,lines,pix)
    if lineinArea(T1,T3,lines,pix) > MINCOVERAGE
        count = count+1;
    end
    
    if count > 2
       result = 1; 
    end
    function coverage = lineinArea(P1,P2,lines,pix)
        vect = P2-P1;
        linelengthSoll = sqrt(vect(1,1)^2+vect(1,2)^2);
        coverlength = 0;
        
        Pdiff = P2-P1;
        Pdiffn = (P2-P1)/norm(Pdiff);
        Pn = [-Pdiff(1,2) Pdiff(1,1)]/norm(Pdiff);

        Q1 = P1 - pix*Pn - pix*Pdiffn;
        Q2 = P1 + pix*Pn - pix*Pdiffn;
        Q3 = P2 + pix*Pn + pix*Pdiffn;
        Q4 = P2 - pix*Pn + pix*Pdiffn;
                
        for k = 1:length(lines)
            L1 =  lines(k).point1;
            L2 =  lines(k).point2;
            IN = inpolygon([L1(1,1) L2(1,1)],[L1(1,2) L2(1,2)],[Q1(1,1) Q2(1,1) Q3(1,1) Q4(1,1)],[Q1(1,2) Q2(1,2) Q3(1,2) Q4(1,2)]);
            if IN(1,1) == 1 && IN(1,2) ==1
                vect = L2-L1;
                linelength = sqrt(vect(1,1)^2+vect(1,2)^2);
                coverlength = coverlength + linelength;
            end
        end        
        coverage = double(coverlength) / double(linelengthSoll);
    end


end