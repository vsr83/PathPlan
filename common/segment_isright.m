% SEGMENT_ISRIGHT Selvittää virittääkö polygonin reunalla kuljettaessa
% seuraava jana p:n suhteen vastakkaiseen nähden oikeanpuoleisen
% puolisuoran.
% isRight = SEGMENT_ISRIGHT(p, P, ind_S, dir)
%
%   p on 1x2 vektori.
%
%   P on polygoni nx2 matriisina, jonka reunalla kuljemme. 
%
%   ind_S on sen janan indeksi, jonka alun suhteen tilannetta tutkimme.
%   dir määrää onko "seuraava" jana positiivisessa vai negatiivisessa
%   kiertosuunnassa.
%
%   Funktio palauttaa isRight = 0 tai 1.

function isRight = segment_isright(p, Poly, ind_S, dir)

[Pr, Pc] = size(Poly);

prevSeg = mod(ind_S - 2, Pr) + 1;
nextSeg = mod(ind_S, Pr) + 1;
           
nSu = unit(Poly(nextSeg, :) - Poly(ind_S, :));
pSu = unit(Poly(prevSeg, :) - Poly(ind_S, :));
if (nSu-pSu) * p' * dir > 0
    isRight = true;
else
    isRight = false;
end            
  