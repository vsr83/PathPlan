% SEGMENTS_DOINTERSECT tutkii leikkaavatko kaksi janaa
%   [L, x, y] = SEGMENTS_DOINTERSECT(S1, S2)
%
%   S1, S2 = [x0 y0;x1 y1] m‰‰ritt‰v‰t janat joiden leikkausta
%   tutkimme.
%
%   Funktio palauttaa L = 1 tai L = 0 riippuen siit‰ leikkaavatko
%   janat. Edelleen [x, y] on janojen viritt‰mien suorien 
%   leikkauspiste.

function [L, x, y] = segments_dointersect(S1, S2)

r1 = S1(2, :) - S1(1, :);
r2 = S2(2, :) - S2(1, :);

l1 = norm(r1);
r1 = r1 / l1;
l2 = norm(r2);
r2 = r2 / l2;

[x, y] = segments_intersection(S1(1, :), S1(2, :), S2(1, :), S2(2, :));
I = [x, y];

d1 = dot(I - S1(1, :), r1);
d2 = dot(I - S2(1, :), r2);

L1 = 0 < d1 && d1 < l1;
L2 = 0 < d2 && d2 < l2;
L = L1 && L2;

if L
%    plot(x, y, 'rx');
end