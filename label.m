function [ccl LUT] = label(img)

%   filtering regions < 100 pixel
%   see "Einführung in Visual Computing, II: Grundlagen der Digitalen Bildverarbeitung, Skriptum zur Vorlesung" for theory.   
%
%   INPUT
%   image ... black and white image
%   OUTPUT
%   ccl ... image with labeled components
%   LUT ... lookup table for all regions including size
%
%   author: Natascha Machner
%   author: Michaela Schönbauer

isize = size(img);
ccl = zeros(size(img));
new = 2;

% (:1) == nummer der region
% (:2) == aequivalentklasse
% (:3) == groesse der region
LUT = zeros(9999, 3);
LUT(:,1) = (2:size(LUT(:,1)) + 1)';

%keine randbehandlung
for j = 2: isize(1)
    for k = 2:isize(2)
        
        %  maske: pixel-nord-west
        if(img(j,k) ~= 0)
            n = ccl(j-1, k);
            w = ccl(j, k-1);
            
            %Fall: north und west gleich null
            if(n == 0 && w == 0)
                ccl(j,k) = new;
                LUT(new - 1, 3) = 1;
                new = new + 1;
            %Fall: entweder north oder west gleich null ODER north gleich west
            elseif(n*w == 0 || n == w)
                ccl(j,k) = max(n, w);
                LUT(ccl(j,k) - 1, 3) = LUT(ccl(j,k) - 1, 3) + 1;
            %Fall: north und west ungleich und nicht null
            else
                ccl(j,k) = min(n, w);
                LUT(max(n, w) - 1, 1) =  min(n, w);
                LUT(ccl(j,k) - 1, 3) = LUT(ccl(j,k) - 1, 3) + 1;
            end
        end
    end
end

LUT = LUT(1:new - 2, :);

%klassen bestimmen, solange regionen vorhanden
for i = 2:size(LUT, 1) + 1;
    LU = i;
    
    while true
        LU_Old = LU;
        LU = LUT(LU - 1, 1);
        
        if LU == i || LU == LU_Old
            LUT(i - 1, 2) = LU - 1;
            break;
        end
    end
end

%zweiter durchlauf
for j = 2: isize(1)
    for k = 2:isize(2)
        if ccl(j, k) > 0
            ccl(j, k) = LUT(LUT(ccl(j, k) - 1, 1) - 1, 2);
        end
    end
end

end