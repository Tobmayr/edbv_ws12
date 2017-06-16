function number = sp_showImage(number,titel,image)
%  Support Funktion zur Ausgabe der Bilder
%
%   EINGABE
%   number ... Index des Bildes
%   titel  ... Titel des Bildes
%   image  ... Bild
%   AUSGABE
%   number ... Index+1 
%
%   author: Michaela Schönbauer

number = number + 1;
fig1 = figure(number);
set(fig1,'name',titel);
imshow (image);

end