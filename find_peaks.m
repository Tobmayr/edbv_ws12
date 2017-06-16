function [peaks] = find_peaks(H,numpeaks)
% Finden der größten Houghpeaks
%   EINGABE
%   H           ...     Hough-Transformations-Matrix
%   numpeaks    ...     maximale Anzahl an gesuchten Peaks
%      
%    
%   AUSGABE
%   peaks       ...     Zweidimensionaler Vektor mit den theta und rho
%                       Werten der Peaks
%
%   @author Tobias Ortmayr,1026279
%

%Setzen der Defaultwerte falls Parameter nicht eingeben wurden

%  Größe der Nachbarschaft um einen Peak, die nach der Verwendung eines 
%  Peaks auf 0 gesetzt wird
    nhood=size(H)/50;
    % Stellt sicht das die Nachbarschaft ungerade ist
    nhood=max(2*ceil(nhood/2)+1,1);

%Schwellenwert ab dem Werte von H als Peaks betrachtet werden
    thresold=0.5*max(H(:));

    
% Wenn kein Paramter für numpeaks eingeben wurde-> Fallback auf Defaultwert 1    
if nargin<2
    numpeaks=1;
end

running=true;
temp=H; peaks=[];
counter=0;

while running
    % Finden des größten Eintrags
    [r,t]=find(temp==max(temp(:)));
    r=r(1);t=t(1);
    % Nur wenn das Maximum größer als der Schwellenwert ist wird
    % weitergemacht, ansonsten wird abgebrochen
    if temp(r,t)>=thresold
        counter=counter+1;
        peaks(counter,1)=r;peaks(counter,2)=t;
        % Erstellen der Nachbarschaft, welche beim nächsten Suchversuch
        % ignoriert werden soll
        y1=r-(nhood(1)-1)/2;y2=r+(nhood(1)-1)/2; 
        x1=t-(nhood(2)-1)/2;x2=t+(nhood(2)-1)/2; 
        [y,x]=ndgrid(y1:y2,x1:x2);
        % Verwerfen der Nachbarschaftsindizess die 'out of bounds sind' im
        % Bezug auf den Radius sind
        outofbounds=find( (y<1)| (y>size(H,1)));
        y(outofbounds)=[]; x(outofbounds)=[];
        
        %Indizess die im Bezug auf Theta 'out of bounds' sind werden
        %seperat behandelt (Weil H antisymetrisch bei theta=+/- 90 ist)
        out= find(x<1);
        x(out)=size(H,2)+x(out);
        y(out)=size(H,1)-y(out)+1;
        out=find(x>size(H,2));
        x(out)=x(out)-size(H,2);
        y(out)=size(H,1)-y(out)+1;
        %Konvertieren der Nachbarschaft in lineare Indizesse, um diese
        %Werte auf 0 zu setzen
        temp(sub2ind(size(temp),y,x))=0;
        running=counter<numpeaks;
    else
        running=false;
    end
    
    
    
    
end