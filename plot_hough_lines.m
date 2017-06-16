function count = plot_hough_lines(image,lines,count)
%  Plot Hough Lines
%
%   EINGABE
%   image ... Image
%   Lines  ... hough lines
%   count  ... figure Index
%   AUSGABE
%   count ... figure Index+1 
%
%   author: Michaela Schönbauer

count = count + 1;
fig1 = figure(count);
set(fig1,'name','Hough Lines');

imshow(image), hold on
max_len = 0;


for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end

% highlight the longest line segment
plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','blue');


end