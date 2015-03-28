% POLYGON_FINDINSIDE etsii pisteen polygonin sis‰st‰.
%   p = POLYGON_FINDINSIDE(P)
%
%   P on polygoni nx2 matriisina
%
%   Funktio palauttaa pisteen p(1x2 vektori) polygonin sis‰st‰.

% Polygonista etsit‰‰n reflex-k‰rki, jonka "tarpeeksi l‰hell‰"
% bisektorilla olevat pisteet ovat sis‰pisteit‰.
%
% Onko kyseess‰ kuvion "sis‰puolella" oleva piste riippuu polygonin
% suunnistuksesta. Negatiivisesti suunnistetut polygonit k‰‰nn‰mme 
% ja suoritamme saman operaation kuin positiivisesti suunnistetussa
% tapauksessa.
% 

function p = polygon_findinside(P)

[nVertices, tmp] = size(P);

PO = polygon_orientation(P);

if PO == -1 
    P = invert(P);
end

K = polyc_angles(P);
rVertex = min(find(K < pi));
    
ind_prev = mod(rVertex-2, nVertices) + 1;
ind_next = mod(rVertex, nVertices) + 1;

b = bisector(P, ind_prev, rVertex);

rNext = unit(P(ind_next, :) - P(rVertex, :));
rPrev = unit(P(ind_prev, :) - P(rVertex, :));

verticesBetween = [ind_next; ind_prev];

for ind_V = 1:nVertices
    d1 = det([rNext; P(ind_V, :)-P(rVertex, :)]);
    d2 = det([P(ind_V, :)-P(rVertex, :); rPrev]);
    if d1 > 0 && d2 > 0 && ind_V ~= rVertex
        verticesBetween = [verticesBetween; ind_V];
    end    
end

nBetween = length(verticesBetween);

dist = [];

for ind_B = 1:nBetween
    dist = [dist; dot(b, P(verticesBetween(ind_B), :) - P(rVertex, :))];
end

pos = min(dist) / 2

p = P(rVertex, :) + pos*b;

if fix(polygon_wn(P, p)) == -1
    P = invert(P);
    p = polygon_findinside(P);
end

