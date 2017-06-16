function result = eval_raute(lines,image) 
%   Evaluierung ob Linien eine Raute bilden
%   Brute Force Ansatz: Mit den Hough Lines werden Schnittpunkte
%   festgelegt, diese Schnittpunkte werden Rautenhälften(Dreiecke) kombiniert.
%   Die besten Kombinationen werden aufgrund der Differenz von P3(Normale auf P1/P2) zu den
%   aus P1 und P2 berechneten MittelpunktPunkt ausgewählt.
%   P4 der Raute wird in Gegenrichtung zu P3 gesucht. Raute mit bester
%   Houghlinedeckung wird ausgwählt
%
%   Überlappungende Rauten werden aussortiert
%   Die gefundenen Rauten müssen je Seite eine x-prozentige Überdeckung
%   ausweisen.
%
%   EINGABE
%   lines .. Hough lines
%   image .. Input Image
%   AUSGABE
%   result .. Image mit markierten Rauten 
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
pointindex = zeros(comb3,9); % Index der Punkte , Qualitätswert, Schwerpunkt

% Mindesabstand von P1 und P2
MINDIFF = 20;
% max. Unterschied zwischen berechneten P3 und Ziel P3
MAXDIFF_P3 = 30;
% Kombinationen der Punkte evaluieren (Brute Force)

for k=1:n
    for l = 1+k:n
        for m = 1+l:n
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
                
                P3_N = P3 + Pdiffnorm;
                % inserction Point  P3+P3_N  P1+P2
                %[P1 P2 P3 P3_N]
                Pb_t = intersectionPoint(P1',P2',P3',P3_N');
                Pb = Pb_t';
                % max Abweichung von P3
                
                P3diff = P3 - Pb;
                %P1_P2 --> P3 hoehe
                h3 = sqrt(P3diff(1,1)^2+P3diff(2,1)^2);  
                %[s2 h3]
                if s2*0.5 < h3 && s2*1.5 > h3
                                        
                    P4 = Pb + (Pb - P3);
                    
                    Pb_h = Pb - Ph;
                    diff1 = sqrt(Pb_h(1,1)^2+Pb_h(2,1)^2);
                                        
                    pointindex(count3,4)  = diff1;
                    %Schwerpunkt
                    Sp = Ph;
                    pointindex(count3,5) = Sp(1,1);
                    pointindex(count3,6) = Sp(2,1);
                    
                    pointindex(count3,7) = P4(1,1);
                    pointindex(count3,8) = P4(2,1);
                    pointindex(count3,9) = h3;
                end
                
                
            end
        end        
    end        
end
%count3
%pointindex

[B,IX] = sort(pointindex(:,4));
sortedpointindex = pointindex(IX,:);

idx =1;
sortedpiF1 = [];
resultraute = []; %P1 P2 P3 S P4
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
for i = 1: size(sortedpiF1,1)
   S = [sortedpiF1(i,5) sortedpiF1(i,6)];
   P4 = [sortedpiF1(i,7) sortedpiF1(i,8)];
   h = sortedpiF1(i,9);
   %alreade in?
   isIN = 0;
   for j=1: size(resultraute,1)       
    IN = inpolygon([S(1,1)],[S(1,2)],[resultraute(j,1) resultraute(j,5) resultraute(j,3) resultraute(j,9)],[resultraute(j,2) resultraute(j,6) resultraute(j,4) resultraute(j,10)]);    
    if IN == 1
       isIN =1;
       break;
    end
   end
      
   if isIN == 0
       P1 = spoints(sortedpiF1(i,1),:);
       P2 = spoints(sortedpiF1(i,2),:);
       P3 = spoints(sortedpiF1(i,3),:);
      
    % find nearest Point to P4
    pix = 5;
    for j = 1: size(spoints,1)
       Pa = spoints(j,:);
       searchRange = h*0.3; 
       pd = Pa - P4;
       pdL = sqrt(pd(1,1)^2+pd(1,2)^2);
       if pdL < searchRange
         % check coverage  
         % check Coverage of triangle: Überprüfung ob das gefunden Rauten auch eine
         % Hough line Deckung aufweist
            if checkLinesInRaute([P1 P2 P3 S Pa ],lines,pix) == 1
                resultraute  = [resultraute; P1 P2 P3 S Pa]; % P4
				break;
            end
       end
    end
       
      
   end
end
%

result = resultraute;
catch exception
    
    result = [];
end

end