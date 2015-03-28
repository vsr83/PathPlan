% POLYGON_AREA Laskee polygonin pinta-alan.
% A = POLYGON_AREA(P)
%
% P on polygoni nx2-matriina.
%
% Funktio palauttaa polygonin etumerkillisen pinta-alan. 
% Etumerkki m‰‰r‰ytyy siit‰ onko P positiivisesti(vastap‰iv‰‰n)
% vai negatiivisesti(myˆt‰p‰iv‰‰n) suunnistettu.
%
% Laskentakaava: O'Rourke - Computational Geometry in C s.21.

function A = polygon_area(P)

%if polygon_orientation(P) == -1
%    warning 'Polygoni on negatiivisesti suunnistettu!'
%end

[nVertices, tmp] = size(P);

u = P(:, 1) + [P(2:nVertices, 1);P(1, 1)];
v = [P(2:nVertices, 2);P(1, 2)] - P(:, 2);

A = 0.5*u'*v;

