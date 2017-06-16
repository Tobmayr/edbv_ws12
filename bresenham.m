function [xc yc] = bresenham(r)

%  Bresenham's circle algorithm (aka midpoint circle algorithm)
%
%   INPUT
%   r ... radius
%   OUTPUT
%   xc yc ... x and y coordinates of points forming a circle with radius r around (0,0)
%
%   author: Riccardo Scalisi

f = 1 - r;
x = 0;
y = r;

xc = [0 0 r -r];
yc = [r -r 0 0];

while x < y
    if f < 0
        f = f + 2*x + 3;
    else
        f = f + 2*(x-y) + 5;
        y = y - 1;
    end
    
    xc = [xc x -x x -x y -y y -y];
    yc = [yc y y -y -y x x -x -x];
    x = x + 1;
end

% optionaly sorts coordinates so they can be plotted as a line
if(true)
    q1 = find(xc >= 0 & yc >= 0);
    q2 = find(xc < 0 & yc >= 0);
    q3 = find(xc < 0 & yc < 0);
    q4 = find(xc >= 0 & yc < 0);
    
    xq1 = xc(q1);
    yq1 = yc(q1);
    xq2 = xc(q2);
    yq2 = yc(q2);
    xq3 = xc(q3);
    yq3 = yc(q3);
    xq4 = xc(q4);
    yq4 = yc(q4);
    
    [x1 IX1] = sort(xq1, 'descend');
    y1 = yq1(IX1);
    [x2 IX2] = sort(xq2, 'descend');
    y2 = yq2(IX2);
    [x3 IX3] = sort(xq3, 'ascend');
    y3 = yq3(IX3);
    [x4 IX4] = sort(xq4, 'ascend');
    y4 = yq4(IX4);
    
    xc = [x1 x2 x3 x4];
    yc = [y1 y2 y3 y4];
end
end