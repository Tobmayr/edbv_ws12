function result = eval_triangle(lines,image) 
%   Evaluierung ob Linien ein Dreieck bilden
%   Brute Force Ansatz: Mit den Hough Lines werden Schnittpunkte
%   festgelegt, diese Schnittpunkte werden Dreiecken kombiniert.
%   Die besten Kombinationen werden aufgrund der Differenz von P3 zu den
%   aus P1 und P2 berechneten Punkt ausgewählt.
%
%   Überlappungende Dreiecke werden aussortiert
%   Die gefundenen Dreiecke müssen je Seite eine x-prozentige Überdeckung
%   ausweisen.
%
%   EINGABE
%   lines .. Hough lines
%   image .. Input Image
%   AUSGABE
%   result .. Image mit markieren Dreiecken 
%
%   author: Bernhard Vorderegger

try
n = length(lines);
if n < 2 
    result = [];
    return;
end

comb = factorial(n)/(2*factorial(n-2));
spoints = zeros(comb,2);

pointidx = 1;
%Schnittpunkte spoints berechnen
for k = 1:length(lines)
    for l = 1+k:length(lines)        
       schnittpunkt = intersectionPoint(lines(k).point1,lines(k).point2,lines(l).point1,lines(l).point2);
       if schnittpunkt(1,1) > 0 && schnittpunkt(1,1) < size(image,2) && schnittpunkt(1,2) > 0 && schnittpunkt(1,2) < size(image,1)
            spoints(pointidx,:) = schnittpunkt;
            pointidx = pointidx +1;
       end
    end        
end

n = size(spoints,1);
if  n > 50
    spoints = spoints(1:50,:);
    %r = randi(size(spoints,1),1,50)
    %spoints(r',:)
    %spoints = spoints(r',:)
end
n = size(spoints,1);
comb3 = factorial(n)/(factorial(3)*factorial(n-3));
count3 = 0;
pointindex = zeros(comb3,6); % Index der Punkte , Qualitätswert, Schwerpunkt

% Mindesabstand von P1 und P2
MINDIFF = 20;
% max. Unterschied zwischen berechneten P3 und Ziel P3
MAXDIFF_P3 = 40;
% Kombinationen der Punkte evaluieren (Brute Force)
for k=1:n
    for l = 1+k:n
        for m = 1+ l:n
            count3 = count3 +1;
            pointindex(count3,1:3) = [k l m];
            % eval Triangle
            P1 = spoints(k,:)';
            P2 = spoints(l,:)';
            P3 = spoints(m,:)';
            Pdiff = (P2-P1)/2;
            Ph = P1 + (P2-P1)/2;
            s2 = sqrt(Pdiff(1,1)^2+Pdiff(2,1)^2);  
            if s2 > MINDIFF
                h = sqrt(3) * s2;
                Pdiffnorm = [-Pdiff(2,1); Pdiff(1,1)];
                Pdiffnorm = Pdiffnorm / s2;           
                Pcand1 = Ph + h * Pdiffnorm;
                Pcand2 = Ph - h * Pdiffnorm;
                % diff P3
                Pd1 = P3 - Pcand1;
                Pd2 = P3 - Pcand2;
                diff1 = sqrt(Pd1(1,1)^2+Pd1(2,1)^2);
                diff2 = sqrt(Pd2(1,1)^2+Pd2(2,1)^2);
                if diff1 < diff2
                   pointindex(count3,4)  = diff1;
                else
                   pointindex(count3,4)  = diff2;
                end
                %Schwerpunkt
                Sp = (P1+P2+P3)/3;
                pointindex(count3,5) = Sp(1,1);
                pointindex(count3,6) = Sp(2,1);
            end
        end        
    end        
end
count3;
%pointindex

[B,IX] = sort(pointindex(:,4));
sortedpointindex = pointindex(IX,:);
idx =1;
sortedpiF1 = [];
resulttriangles = []; %P1 P2 P3 S
%
% Auwahl der besten Kandidaten.
%
for i = 1: size(sortedpointindex,1)
    if sortedpointindex(i,4) > 0 && sortedpointindex(i,4) < MAXDIFF_P3
       idx = i;
       sortedpiF1 = [sortedpiF1; sortedpointindex(i,:)];
    end
end
%sortedpiF1

P1 = spoints(sortedpointindex(idx,1),:);
P2 = spoints(sortedpointindex(idx,2),:);
P3 = spoints(sortedpointindex(idx,3),:);
%
% Anhand des Schwerpunkt werden gleiche Treffer ausgefiltert
%
pix = 5;
for i = 1: size(sortedpiF1,1)
   S = [sortedpiF1(i,5) sortedpiF1(i,6)];
   %alreade in?
   isIN = 0;
   %for j=1: size(resulttriangles,1)       
    %IN = inpolygon([S(1,1)],[S(1,2)],[resulttriangles(j,1) resulttriangles(j,3) resulttriangles(j,5)],[resulttriangles(j,2) resulttriangles(j,4) resulttriangles(j,6)]);    
    %if IN == 1
     %  isIN =1;
     %  break;
    %end
   %end
      
   %if isIN == 0
       P1 = spoints(sortedpiF1(i,1),:);
       P2 = spoints(sortedpiF1(i,2),:);
       P3 = spoints(sortedpiF1(i,3),:);
       Pdiff = P2-P1;
       plen = sqrt(Pdiff(1,1)^2+Pdiff(1,2)^2);  
% check Coverage of triangle: Überprüfung ob das gefunden Dreicke auch eine
% Hough line Deckung aufweist
% 
   if checkLinesInTriangle([P1 P2 P3 S],lines,pix) == 1    
      resulttriangles  = [resulttriangles; P1 P2 P3 S plen];
   end
end
%
%resulttriangles

[B,IX] = sort(resulttriangles(:,9));
sortedresulttriangles = resulttriangles(IX,:);

% Todo sortiere nach größten P1/P2
% Todo Schwerpunkt Auswahl
resulttriangles_c = [];

for i= 1: size(sortedresulttriangles,1)
   S = [sortedresulttriangles(i,7) sortedresulttriangles(i,8)];
   isIN = 0;
   for j=1: size(resulttriangles_c,1)       
    IN = inpolygon([S(1,1)],[S(1,2)],[resulttriangles_c(j,1) resulttriangles_c(j,3) resulttriangles_c(j,5)],[resulttriangles_c(j,2) resulttriangles_c(j,4) resulttriangles_c(j,6)]);    
    if IN == 1
       isIN =1;
       break;
    end
   end
      
  if isIN == 0   
   resulttriangles_c = [resulttriangles_c; sortedresulttriangles(i,1:8)];
  end
end

%coveragetriangles
result = resulttriangles_c;
catch exception
    
    result = [];
end

end