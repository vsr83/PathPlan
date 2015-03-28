% POLYGON_MOVE Siirt‰‰ polygonia
% P = POLYGON_MOVE(P, x, y)

function P = polygon_move(P, x, y)

[rows, cols] = size(P);

PN = [ones(rows, 1)*x ones(rows, 1)*y];
P = P + PN;