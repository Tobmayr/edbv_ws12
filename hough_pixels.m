function [ r,c ] = hough_pixels( nonzero, theta, rho, peak )
%Berechnet die Pixel des Eingabebildes, die auf der durch den Peak
%dargestellten Geraden liegen
%   Eingabe
%   nonzero          ... Kantenpixel des Eingabebildes
%   theta            ...  Vektor mit den von der Hough Transformation verwendeten
%                    Theta Werten
%    rho             ...  Vektor mit den von der Hough Transformation verwendeten Rho
%                    Werten    
%   peak             Parameterdarstellung der Gerade, zu der die
%                    entsprechenden Pixel gefunden werden sollen
%
%   Ausgabe:         Pixelarray [r,c] (rows,colums) mit allen Pixel des
%                    Eingabebildes die auf der Geraden liegen
%
%   @author Tobias Ortmayr, 1026279


x = nonzero(:,1); 
y = nonzero(:,2); 
%Ermitteln des entsprechenden Theta/Rho der Gerade 
theta_c = theta(peak(2)) * pi / 180; 

rho_xy = x*cos(theta_c) + y*sin(theta_c); 
nrho = length(rho); 
slope = (nrho - 1)/(rho(end) - rho(1)); 
rho_bin_index = round(slope*(rho_xy - rho(1)) + 1); 
 
idx = find(rho_bin_index == peak(1)); 
 
r = y(idx) + 1; c = x(idx) + 1; 

end

