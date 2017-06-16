function count = plot_rauten(rauten,image,count,debugMode)
%   Eintragen der Rauten in das 'image'
%
%   EINGABE
%   rauten .. Rauten P1,P2,P3,S(Schwerpunkt),P4
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
set(fig1,'name','Gefundene Vorrangschilder');
imshow(image)
end
hold on
for i=1:size(rauten,1)
   %xy = [lines(k).point1; lines(k).point2];
   xy = [rauten(i,1:2); rauten(i,5:6)];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','blue');
   
   xy = [rauten(i,5:6); rauten(i,3:4)];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','blue');
   
   xy = [rauten(i,3:4); rauten(i,9:10)];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','blue');
   
   xy = [rauten(i,1:2); rauten(i,9:10)];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','blue');
   
   hnd1=text(rauten(i,7),rauten(i,8),'Vorrangstraße','BackgroundColor',[0 1 0]);
   set(hnd1,'FontSize',16)

end
   
hold off

end