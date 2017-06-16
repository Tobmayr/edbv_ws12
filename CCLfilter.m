function result = CCLfilter(img)

%   filtering regions < 100 pixel
%
%   INPUT
%   image ... black and white image
%   OUTPUT
%   result ... black and white image without regions < 100 pixel
%
%   author: Natascha Machner
%   author: Michaela Schönbauer

isize = size(img);

% for bulk of the CCL code see label.m
[ccl LUT] = label(img);

% calculate the area of each component through the lookup table
area = zeros(max(LUT(:,2)), 1);

for j = 1:size(LUT(:,2))
    area(LUT(j,2)) = area(LUT(j,2)) + LUT(j,3);
end

% flatten the components, setting those < 100 pixel to zero
for j = 2:isize(1)
    for k = 2:isize(2)
        if (ccl(j, k) > 0 && area(ccl(j,k)) > 100)
            ccl(j,k) = 1;
        else
            ccl(j,k) = 0;
        end
    end
end

result = ccl;

end