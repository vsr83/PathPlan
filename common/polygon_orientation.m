% POLYGON_ORIENTATION(P) m‰‰ritt‰‰ onko polygoni positiivisesti vai
% negatiivisesti suunnistettu. 
%
% P on polygoni nx2-matriisina
% 
% Funktio palauttaa 1 tai -1 riippuen polygonin suunnistuksesta.

function O = polygon_orientation(P)

A = polygon_area(P);
if A < 0
    O = -1
else
    O = 1;
end

% O'Rourke:n korollaari 1.2.5 sanoo,
% ett‰ polygonin sis‰kulmien summa on (n-2)*pi, miss‰ n on 
% k‰rkien lukum‰‰r‰. Vastaavasti ulkokulmien summa on (n+2)*pi.

%[rows, cols] = size(P);
%K = sisakulmat(P);
%a = round(sum(K)/pi);

%if a == rows+2
%    O = -1;
%elseif a == rows-2
%    O = 1;
%else   
%    P
%    K
%    a
%    error 'Polygonin suunnistuksen m‰‰ritt‰minen ei onnistunut!'
%end

