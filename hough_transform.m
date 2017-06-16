function [ H,T,R] = hough_transform( BW )
%Anwendung der Hough Transformation
%
%   EINGABE
%   BW  ...  Binärbild nach Anwendung des Kantenfilters 
%   
%   AUSGABE
%   H   ... Hough Transformations Matrix
%   T   ... Theta Werte mit denen die Matrix generiert wurde 
%   R   ..  Rho Werte mit denen die Matrix generiert wurde
%
%   @author Tobias Ortmayr,1026279
%

% Erzeugen des Vektors mit den Theta-Werten (Quantisierungsschritt=1, Werte
% zwischen -90 und 89 grad (analog zur hough() Funktion aus der
% ImageProcessingToolbox

T=-90:89;

[row,col]=size(BW);
% Berechnung der Maximallänge des Radius
D=sqrt((row-1)^2+(col-1)^2);
diagonal=ceil(D);
% Erzeugung des Vektors mit den Rho-Werten (Quantisierungsschritt=1)
R=-diagonal:diagonal;
% Erzeugung der Akkumulator-Matrix 
H= zeros(length(R),length(T));
% Suchen der Kantenpixel mittels find. [Liefert alle Pixel die nicht 0 sind
% zurück)
[y,x]=find(BW);

for cnt=1:length(x)
    indexT=1;
    % Für jedes Kantenpixel wird der Radius mit allen Theta-Werten
    % berechnet
    for theta=T*pi/180
        rho=(x(cnt)-1)*cos(theta)+(y(cnt)-1)*sin(theta);
        rho=round(rho);
        % Das dem Ergebniss entsprechende Akkumulatorfeld wird um 1 erhöht
        H(rho+diagonal+1,indexT)=  H(rho+diagonal+1,indexT)+1;
        indexT=indexT+1;
    end
end

end

