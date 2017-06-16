function result = gaussian_filter(image, hsize)
%  Kanten gl�tten
%
%   EINGABE
%   image  ... Auszuwertendes Image
%   hsize  ... Gr��e des quadratischen Filterkerns (ungerade!)
%   AUSGABE
%   result ... gegl�ttetes Image 
%
%   author: Michaela Sch�nbauer

% Erzeugen des Filterkerns mit den Ma�en hsize x hsize
g = fspecial('gaussian',hsize, 1);

imSize = size(image);
height = imSize(1);
width = imSize(2);

% Erzeugen einer 0-Matrix
% Ma�e des Originalbildes - den Pixelreihen, die durch die Filterung
% wegfallen
result = zeros(size(image));

% neuer Wert, der in das Ausgabebild gespeichert wird

offset = (hsize-1)/2;

for i = 1+offset:height-offset
    for j = 1+offset:width-offset        
        temp = image(i-offset:i+offset,j-offset:j+offset) .* g;
        result(i,j) = sum(temp(:));
    end
end


%imshow(result)
end