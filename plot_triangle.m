function count = plot_triangle(triangles,image,count,debugMode)
%   Eintragen der Dreiecke in das 'image'
%
%   EINGABE
%   triangles .. Dreiecke P1,P2,P3,S(Schwerpunkt)
%   image .. Input Image
%   count .. figure Index
%   AUSGABE
%   count .. Index+1
%
%   author: Natascha Machner

if nargin < 4
   debugMode = 0; 
end
if debugMode
count = count+1;

fig1 = figure(count);
set(fig1,'name','Gefundene Gefahrenschilder');

imshow(image)
end
hold on
for i=1:size(triangles,1)
   %xy = [lines(k).point1; lines(k).point2];
   xy = [triangles(i,1:2); triangles(i,3:4)];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
   
   xy = [triangles(i,3:4); triangles(i,5:6)];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
   
   xy = [triangles(i,1:2); triangles(i,5:6)];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
   
   hnd1=text(triangles(i,7),triangles(i,8),'Vorrang geben','BackgroundColor',[1 0 0]);
   set(hnd1,'FontSize',16)

end
   
hold off

end