function result = checkLinesInRaute(raute,lines,pix)
%   Raute Hough lines evaluierung - Deckungsgrad
%
%   EINGABE
%   raute .. Rautenpunkte
%   lines .. Hough lines
%   AUSGABE
%   result .. 1 wenn Deckungsgrad erfüllt, sonst 0
%
%   author: Bernhard Vorderegger

    MINCOVERAGE = 0.3;
	ALLCOVERAGE = 0.7;
    R1 = [raute(1,1) raute(1,2)];
    R2 = [raute(1,5) raute(1,6)];
    R3 = [raute(1,3) raute(1,4)];
    R4 = [raute(1,9) raute(1,10)];
    
    result = 0;
    count = 0;
	sumcover = 0;
    %lineinArea(R1,R2,lines,pix)
    cover = lineinArea(R1,R2,lines,pix);
    sumcover = sumcover + cover;
    if cover > MINCOVERAGE
        count = count+1;
    end
    %lineinArea(R2,R3,lines,pix)
    cover = lineinArea(R2,R3,lines,pix);
    sumcover = sumcover + cover;
    if cover > MINCOVERAGE
        count = count+1;
    end
    %lineinArea(R3,R4,lines,pix)
    cover = lineinArea(R3,R4,lines,pix);
    sumcover = sumcover + cover;
    if cover > MINCOVERAGE
        count = count+1;
    end
    %lineinArea(R4,R1,lines,pix)
    cover = lineinArea(R4,R1,lines,pix);
    sumcover = sumcover + cover;
    if  cover > MINCOVERAGE
        count = count+1;
    end
    %count
    if count > 3 || ((sumcover/4) > ALLCOVERAGE)
       result = 1; 
    end
    function coverage = lineinArea(P1,P2,lines,pix)
        vectS = P2-P1;
        linelengthSoll = sqrt(vectS(1,1)^2+vectS(1,2)^2);
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
        %[coverlength  linelengthSoll ]
        coverage = double(coverlength) / double(linelengthSoll);
    end


end