function [lines ] = find_lines( BW, theta, rho, peaks,fillgap,minlength )
%Finde Linien anhand der Hough Peaks
%  Eingabe 
%  BW           ...  Binärbild der Kanten
%  theta        ...  Vektor mit den von der Hough Transformation verwendeten
%                    Theta Werten
%  rho          ...  Vektor mit den von der Hough Transformation verwendeten Rho
%                    Werten    
%  peaks        ...  Zweidimensionaler Vektor mit den theta und rho
%                    Werten der Peaks
%  fillgap      ...  Wenn die Distanz zwischen 2 Liniensegment <fillgap ist,
%                    werden sie verschmolzen
%  minlength    ...  Linensegmente <minlength werden verworfen
% 
%  Ausgabe      ...   gefundene Linen in einem Structure-Array
%                     jedes Element hat folgende Felder:
%                     - point 1     ...     [X,Y] Vektor des Startpunkts 
%                     - point 2     ...     [X,Y] Vektor des Endpunkts
%                     - theta       ...     Winkel (in Grad) der
%                                           Transformation
%                     - rho         ...     Rho-Achesen Position
%
%  @author Tobias Ortmayr,1026279

% Fallback-Default-Wert für minlength (äquivalent zu houghlines() aus der
% ImageProcessingToolbox)
if nargin<6
    minlength=40;
end
%Fallback-Default-Wert für fillgap (äquivalent zu houghlines() aus der
% ImageProcessingToolbox)
if nargin <5
    fillgap=20;
end

%Suchen der Kantenpixel(nichtSchwarz)
[y,x]=find(BW);
nonzero=[x,y]-1;
minlength_sq=minlength^2;
fillgap_sq=fillgap^2;
numlines=0; lines=struct;
for k=1:size(peaks,1)
    [r,c]=hough_pixels(nonzero,theta,rho,peaks(k,:));
    if isempty(r)
        continue
    end
    
    
      % Berechnet die Distanz(Lücke) zwischen 2 Punktepaaren
  xy = [c r]; 
  diff_xy_sq = diff(xy,1,1).^2; 
  dist_sq = sum(diff_xy_sq,2); 
  
   %Ermitteln der Lücken die kleinerals der FillGap-Threshold sind unf
   %aufüllen ebendieser
   fillgap_idx = find(dist_sq > fillgap_sq); 
  idx = [0; fillgap_idx; size(xy,1)]; 
  for p = 1:length(idx) - 1 
    p1 = xy(idx(p) + 1,:); % Verschiebung um 1, (Konvertierung vom 0-(n-1) Index auf 1-n
    p2 = xy(idx(p + 1),:); 
    linelength_sq = sum((p2-p1).^2); 
    %Überprüfung ob das Liniensegment größer als der MinLength-Threshold ist
    if linelength_sq >= minlength_sq 
      %Wenn ja, füge die Linie in das Struct ein
      numlines = numlines + 1; 
      lines(numlines).point1 = p1; 
      lines(numlines).point2 = p2; 
      lines(numlines).theta = theta(peaks(k,2)); 
      lines(numlines).rho = rho(peaks(k,1)); 
    end 
  end 
end

end

