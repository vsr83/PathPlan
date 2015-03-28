% SEGMENT_ORIENTATION Tutkii onko polygonin janan loppup‰‰ alkup‰‰t‰
%                     korkeammalla p:n sis‰normaalin suhteen.
% SO = segment_orientation(p, P, ind)
%
%  p on 1x2 vektori.
% 
%  P on polygoni nx2 matriisina.
%
%  ind on indeksi janan alkup‰‰t‰ vastaavalle k‰rjelle polygonissa.
%
%  Funktio palauttaa positiivisen tai negatiivisen luvun sen mukaan
%  onko janan loppup‰‰ alkup‰‰t‰ enemm‰n p:n sis‰normaalin suunnassa.

function SO = segment_orientation(p, Poly, ind)

n = inner_normal(p);

[Pr, Pc] = size(Poly);
ind_next = mod(ind, Pr) + 1;

SO = (Poly(ind_next, :) - Poly(ind, :)) * n';
