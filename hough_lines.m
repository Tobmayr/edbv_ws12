function lines = hough_lines(BW)
%   Findet die den Kanten entsprechenden Linien
%
%   EINGABE
%   BW .. binary image der Kanten
%   AUSGABE
%   lines .. Linien
%
%   author: Tobias Ortmayr

    [H,T,R] = hough_transform(BW);
   
    P  = find_peaks(H,15);

    lines = find_lines(BW,T,R,P,20,25);

end