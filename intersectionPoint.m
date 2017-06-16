% input p [1 1]
function [ S1 ] = intersectionPoint(l1s,l1e,l2s,l2e )
%   Schnittpunkt zweier Linien
%
%   EINGABE
%   l1s ..  [1 1] [2 2] ...
%   AUSGABE
%   S1 .. Schnittpunkt
%
% author: Riccardo Scalisi
%
% Schnittpunkt 2er Geraden
 V1 = transpose(l1s);
 V2 = transpose(l1e - l1s);
 
 W1 = transpose(l2s);
 W2 = transpose(l2e-l2s);
 %det(A)
 A = [V2 W2];
 s = inv(A) * (W1-V1);
 S1 = transpose(V1 + s(1) * V2);

end

