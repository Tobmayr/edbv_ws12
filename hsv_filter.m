function hsvcut = hsv_filter(hsvimage,type)
%  Filtered den Rot Bereich eines Bildes
%
%   EINGABE
%   hsvimage ... Bild im HSV Format
%   AUSGABE
%   hsvcut ... Schwarz/Weis Bild das nur den roten Bereich des
%   Eingabebildes darstellt.
%
%   author: Riccardo Scalisi
    
    H = hsvimage(:,:,1);
    S = hsvimage(:,:,2);
    V = hsvimage(:,:,3);
    
    hsvcut = zeros(size(hsvimage,1),size(hsvimage,2));
    
    if  type=='r'
        hsvcut((H > 0.95 | H < 0.05) & V > 0.01 & S > 0.1) = 1;
    elseif type=='y'
        hsvcut((H < 0.21 & H > 0.11) & V > 0.01 & S > 0.1) = 1;
    end
        
end