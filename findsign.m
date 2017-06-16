function findsign(filename,debugMode,debugMode2)
% MAIN Funktion für die Verkehrschilderauswertung
%
%   EINGABE
%   filename  ... Auszuwertendes Image
%   debugMode ... 1 -> enable Debug; 0 wenn kein Argument übergeben wird
%   AUSGABE
%
%   author: Bernhard Vorderegger

if nargin < 2
   debugMode = 0;
   debugMode2 = 0;
elseif nargin < 3
   debugMode2 = 0;
end
imageCounter=0;

RGB = imread(filename);
assert(size(RGB,1) < 1025 | size(RGB,2) < 1025,'Bitte nur Bilder max 1024x1024');
% sp_showImage Supportfunktion zur Ausgabe der Bilder
if debugMode
imageCounter = sp_showImage(imageCounter,'Eingabebild',RGB);
else
    disp('Die Auswertung kann einige Minuten dauern .. bitte Geduld');
    fig1 = figure(1);
    set(fig1,'name','Verkehrszeichenauswertung');
    imshow (RGB);
    imageCounter=1;
end

%-------------------------------------------------------------------- 
% Konvertierung in den HSV Farbraum 
% Farbton(Hue),Farbsättigung (Saturation), Hellwert(Value) 
%--------------------------------------------------------------------
HSV = rgb2hsv(RGB);
% 1-Dim Bild mit den Rotwerten
% redvalues = hsv_filter(HSV);
redvalues = hsv_filter(HSV,'r');

yellowvalues = hsv_filter(HSV,'y');

if debugMode
imageCounter = sp_showImage(imageCounter,'Rot Filter',redvalues);
end
if debugMode2
imageCounter = sp_showImage(imageCounter,'Gelb Filter',yellowvalues);
end
%-------------------------------------------------------------------- 
% Relevante Connected Componensts auswählen
%-------------------------------------------------------------------- 

cclfiltered = CCLfilter(redvalues);
cclfiltered_y = CCLfilter(yellowvalues);

filled = ImFill(cclfiltered);
filled_y = ImFill(cclfiltered_y);

if debugMode
imageCounter = sp_showImage(imageCounter,'CCL Filter & Fill',filled);
end
if debugMode2
imageCounter = sp_showImage(imageCounter,'CCL Filter & Fill Yellow',filled_y);
end
%-------------------------------------------------------------------- 
% Kanten glätten - Gauss Filter
%-------------------------------------------------------------------- 
% smoothedImage = smooth_filter(cclfiltered);

smoothedImage = gaussian_filter(filled, 15);

Is = zeros(size(smoothedImage));
Is(smoothedImage > 0) = 1;

smoothedImage_y = gaussian_filter(filled_y, 15);

Is_y = zeros(size(smoothedImage_y));
Is_y(smoothedImage_y > 0) = 1;

if debugMode
imageCounter = sp_showImage(imageCounter,'Gauss Filter',Is);
end
if debugMode2
imageCounter = sp_showImage(imageCounter,'Gauss Filter Y',Is_y);
end
%-------------------------------------------------------------------- 
% Edge Detektor
%-------------------------------------------------------------------- 

%BW = edge(smoothedImage,'sobel');

BW = sobelF(Is);

BW(BW(:,:) > 0.2) = 1;


%BW_y = edge(Is_y,'sobel');
BW_y = sobelF(Is_y);
BW_y(BW_y(:,:) > 0.2) = 1;

if debugMode
imageCounter = sp_showImage(imageCounter,'Kanten',BW);
end
if debugMode2
imageCounter = sp_showImage(imageCounter,'Kanten Y',BW_y);
end
%-------------------------------------------------------------------- 
% Hough Lines
%-------------------------------------------------------------------- 

lines = hough_lines(BW);

lines_y = hough_lines(BW_y);
%plot lines
if debugMode
imageCounter = plot_hough_lines(RGB,lines,imageCounter);
end
if debugMode2
imageCounter = plot_hough_lines(RGB,lines_y,imageCounter);
end
%-------------------------------------------------------------------- 
% Hough Lines Evaluation - Dreieck
%-------------------------------------------------------------------- 
warning ('off','all');
 triangles = eval_triangle(lines,RGB);

 % if (isempty(triangles) == 0)

 imageCounter = plot_triangle(triangles,RGB,imageCounter,debugMode);
 % end

%-------------------------------------------------------------------- 
% Hough Lines Evaluation - Rauten
%-------------------------------------------------------------------- 

rauten = eval_raute(lines_y,RGB);

imageCounter = plot_rauten(rauten,RGB,imageCounter,debugMode);
warning ('on','all');

 
%-------------------------------------------------------------------- 
% Hough Circles
%-------------------------------------------------------------------- 

[xc yc r conf] = hough_circle(BW, .55, .8, 2);

% plot hough circles
if debugMode
imageCounter = imageCounter+1;
fig1 = figure(imageCounter);
set(fig1,'name','Gefundene Einfahrt-verboten Schilder');
imshow(RGB);
end
if conf > .9
    hold on;
    [brx, bry] = bresenham(r);
    plot(brx + xc, bry + yc, 'g-');
    hnd1 = text(xc, yc, 'Einfahrt verboten', 'BackgroundColor', [1 0 0]);
    set(hnd1, 'FontSize', 12)
    hold off
    
    disp(['found "Einfahrt verboten" at x: ', num2str(xc), ', y: ', num2str(yc), ', radius: ', num2str(r)]);
else
    disp('no circle found');
end

% --------------- Result Output -------------------------------------

if size(rauten,1) > 0 
    for i=1:size(rauten,1)
        P1 = rauten(i,1:2);
        P2 = rauten(i,3:4);
        S = rauten(i,7:8);
        Pdiff =  P2 - P1;
        l = sqrt(Pdiff(1,1)^2+Pdiff(1,2)^2);
        disp(['found "Vorrangstraße" at x: ', num2str(S(1,1)), ', y: ', num2str(S(1,2)), ', Seitenmaß: ', num2str(l)]);
    end
end
if size(triangles,1) > 0 
    for i=1:size(triangles,1)
        P1 = triangles(i,1:2);
        P2 = triangles(i,3:4);
        S = triangles(i,7:8);
        Pdiff =  P2 - P1;
        l = sqrt(Pdiff(1,1)^2+Pdiff(1,2)^2);
        disp(['found "Vorrang geben" at x: ', num2str(S(1,1)), ', y: ', num2str(S(1,2)), ', Seitenmaß: ', num2str(l)]);
    end
end

%-------------------------------------------------------------------- 
% 
%-------------------------------------------------------------------- 

end