function [xc yc r conf] = hough_circle(image, signHeightMin, signHeightMax, precision)

%  Hough Transformation of Circles
%
%   INPUT
%   image ... edge features
%   signHeightMin ... minimum sign height that is being searched for (as a percentage of image height [0 1])
%   signHeightMax ... maximum sign height that is being searched for (as a percentage of image height [0 1])
%   precision ... from n radii only one is included in the search, set to 1 for maximum precision
%   OUTPUT
%   xc yc r ... x and y coordinates and the radius of the biggest circle found
%   conf ... confidence with which the result is an actual circle
%
%   author: Riccardo Scalisi

disp('hough circle started');
% image height and size
[imHeight, imWidth] = size(image);

% find all non-zero elements
[fy fx] = find(image);
nf = length(fx);

%determine radii we are looking for based on the image height
radiiMin = floor(imHeight * signHeightMin * .5);
radiiMax = floor(imHeight * signHeightMax * .5);
radii = (radiiMin:precision:radiiMax);
nrad = length(radii);

% initialize accumlator array
acc = zeros(imHeight, imWidth, nrad);

% loop through radii
for radInd = 1:nrad
    progress = round(100 * (radInd/nrad));
    barPos = round(progress/3);
    barlength = round(100/3) - barPos;
    if progress < 10, barlength = barlength + 1; end
    if progress == 100, barPos = barPos - 1; end
    disp(['progress: [', repmat('=', 1, barPos), '(', num2str(progress), '%)', repmat('-', 1, barlength), ']']);
    
    % determine all possible origins this feature could originate from
    rad = radii(radInd);
    [cpx cpy] = bresenham(rad);
    ncp = length(cpx);
    
    % loop through features
    for feat = 1:nf;
        y = fy(feat);
        x = fx(feat);
        
        % loop through circle points and add vote as long as it's inside the image bounds
        for c = 1:ncp
            cx = cpx(c);
            cy = cpy(c);
            
            if(y + cy > 0 && y + cy < imHeight && x + cx > 0 && x + cx < imWidth)
                acc(y + cy, x + cx, radInd) = acc(y + cy, x + cx, radInd) + 1;
            end
        end
    end
end

if false
    % normalize accumulator array
    acc = bsxfun(@rdivide, acc, reshape(radii, 1, 1, nrad));
    
    % visualize accumulator array
    for i = 1:nrad
        fig1 = figure(radii(i));
        set(fig1,'name','accumulator array');
        imshow(acc(:,:,i));
    end
end

% find the highest vote and return it's parameters
maxValue = find(acc == max(acc(:)));
[y x radInd] = ind2sub(size(acc), maxValue);

xc = x(1);
yc = y(1);
r = radii(radInd(1));
conf = max(bsxfun(@rdivide, reshape(max(max(acc)), nrad, 1), reshape(radii, nrad, 1)));

end