% NODE_ISDEADEND Tutkii onko jokin verkon piste umpikuja.
%   DE = NODE_ISDEADEND(Mn, C, node)
%
%   Mn ja C m‰‰ritelty kuten funktiossa MESH_CONNECT_NODES.
%
%   node on tutkittavan solmun indeksi Mn:n kuvaamassa verkossa.
%
%   Funktio palauttaa 1 tai 0 riippuen onko kyseess‰ umpikuja.


% Umpikuja on konveksi ‰‰riarvopiste. Jakaja on reflex ‰‰riarvopiste.

function de = node_isdeadend(Mn, C, node)

poly = Mn{node}.Polygon;
seg = Mn{node}.Segment;

Poly = C{poly};
[Pr, Pc] = size(Poly);

seg_prev = mod(seg - 2, Pr) + 1;
seg_next = mod(seg, Pr) + 1;

K = sisakulmat([Poly(seg_prev,:); Poly(seg, :); Poly(seg_next, :)]);

de = K(2) < pi && Mn{node}.Type ~= 1;
