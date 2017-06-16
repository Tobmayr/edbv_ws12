function result = ImFill(image)

%   filling image holes
%
%   INPUT
%   image ... black and white image
%   OUTPUT
%   result ... black and white image without holes
%
%   author: Riccardo Scalisi

% using CCL on the inverted image means that only image holes get labeled
ccl = imcomplement(image);
ccl = label(ccl);

% find all regions connected to the border of the image
isize = size(image);
borderRegions = unique([ccl(1,:), ccl(isize(1), :), ccl(:,1)', ccl(:, isize(2))']);
borderRegions = borderRegions(borderRegions > 0);

% set those regions connected to the border to 0 and the rest (including image holes) to 1
for j = 2:isize(1) 
    for k = 2:isize(2)
        if (any(ccl(j,k) == borderRegions))
            ccl(j,k) = 0;
        else
            ccl(j,k) = 1;
        end
    end
end

result = ccl;

end

