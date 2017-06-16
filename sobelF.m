function [ edge ] = sobelF( img )
%sobel Edge
% author: Natascha Machner

isize = size(img);
edge = img;

for j = 1: (isize(1)) %zeilen
        
    for k = 1:(isize(2)) %spalten
        
        % Gx mit Filter: 1 0 -1
                        %2 0 -2
                        %1 0 -1
        % Gy mit Filter:  1  2  1
                        % 0  0  0
                        %-1 -2 -1
                        
                        
        if j<2 && k<2
            GX = double(1/5*( - 2*img(j,k+1) - img(j+1,k+1) ));
            GY = double(1/5*( - 2*img(j+1,k) - img(j+1,k+1) ));
            
        elseif k<2 && j==isize(1)
            GX = double(1/5*(  - img(j-1,k+1) - 2*img(j,k+1) ));
            GY = double(1/5*(  + 2* img(j-1,k) + img(j-1,k+1) ));
            
        elseif j<2 && k == isize(2)
            GX = double(1/5*(  2* img(j,k-1) + img(j+1,k-1) ));
            GY = double(1/5*(  - img(j+1,k-1) - 2*img(j+1,k) ));   
            
        elseif j== isize(1) && k == isize(2)
            GX = double(1/5*( img(j-1,k-1) + 2* img(j,k-1) ));
            GY = double(1/5*( img(j-1,k-1) + 2* img(j-1,k) ));   
            
        elseif j<2
            GX = double(1/7*(  2* img(j,k-1) + img(j+1,k-1) - 2*img(j,k+1) - img(j+1,k+1) ));
            GY = double(1/6*(  - img(j+1,k-1) - 2*img(j+1,k) - img(j+1,k+1) ));   
             
        elseif k<2
            GX = double(1/6*( - img(j-1,k+1) - 2*img(j,k+1) - img(j+1,k+1) ));
            GY = double(1/7*( 2* img(j-1,k) + img(j-1,k+1) - 2*img(j+1,k) - img(j+1,k+1) ));  
             
        elseif j == isize(1)
            GX = double(1/7*( img(j-1,k-1) + 2* img(j,k-1) - img(j-1,k+1) - 2*img(j,k+1)));
            GY = double(1/6*( img(j-1,k-1) + 2* img(j-1,k) + img(j-1,k+1) ));  
             
        elseif k == isize(2)
            GX = double(1/6*( img(j-1,k-1) + 2* img(j,k-1) + img(j+1,k-1) ));
            GY = double(1/7*( img(j-1,k-1) + 2* img(j-1,k) - img(j+1,k-1) - 2*img(j+1,k) ));   
                
        else
            GX = double(1/9*( img(j-1,k-1) + 2* img(j,k-1) + img(j+1,k-1) - img(j-1,k+1) - 2*img(j,k+1) - img(j+1,k+1) ));
            GY = double(1/9*( img(j-1,k-1) + 2* img(j-1,k) + img(j-1,k+1) - img(j+1,k-1) - 2*img(j+1,k) - img(j+1,k+1) ));   
            
        end
        
        



        %edge_x(j,k)=SX;
        %edge_y(j,k)=SY;

        %wert berechnen
        G = sqrt( double(GY*GY) + double(GX*GX));
        %calculate direction array GDIR
        % GDIR(i,j) = 360/(2*pi)*(atan2 ( double(SY) , double(SX) )) ; 
      
        edge(j,k)=G;

    end;
end;


end

