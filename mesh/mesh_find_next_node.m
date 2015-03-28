function [new_node, isDown, isRight] = mesh_find_next_node(p, Mn, C, node, dir)

n = inner_normal(p);

nPoly = Mn{node}.Polygon;
nSeg  = Mn{node}.Segment;

Poly = C{nPoly};
[Pr, Pc] = size(Poly);

SO = segment_orientation(p, Poly, nSeg);

ind_F = find_nodes(Mn, struct('Polygon', nPoly, 'Segment', nSeg), 1);
isRight = 0;

isDown = dir * SO < 0;    
ulospain = (node == ind_F(1) && isDown) ...
        || (node == ind_F(length(ind_F)) && ~isDown);
     
if ~ulospain
    ind = find(ind_F == node);
    if isDown
        new_node = ind_F(ind - 1);    
    else
        new_node = ind_F(ind + 1);
    end    
    
    if Mn{node}.Type ~= 1         
        [tmp, tmp2, isRight] = mesh_find_next_node(p, Mn, C, node, -dir);
        isRight = ~isRight;
    end
    return;
end

nextSeg = mod(nSeg, Pr) + 1;
thisSeg = nSeg;
prevSeg = mod(nSeg - 2, Pr) + 1;

nSu = unit(Poly(nextSeg, :) - Poly(thisSeg, :));
pSu = unit(Poly(prevSeg, :) - Poly(thisSeg, :));
if Mn{node}.Type ~=1
    isRight = (nSu-pSu) * p' * dir > 0;
end

ind_F = [];
while length(ind_F) == 0
    if dir < 0
        nSeg = mod(nSeg - 2, Pr) + 1;
    else
        nSeg = mod(nSeg, Pr) + 1;
    end
    ind_F = find_nodes(Mn, struct('Polygon', nPoly, 'Segment', nSeg), 1);
end

nextSeg = mod(nSeg, Pr) + 1;

if dir * (Poly(nextSeg, :) - Poly(nSeg, :)) * n' > 0
    new_node = ind_F(1);
else
    new_node = ind_F(length(ind_F));
end