% POLYGON_AROUND Lyhempi reitti pitkin polygonin reunaa kahden
% polygonin pisteen välillä.
%   Points = POLYGON_AROUND(Poly, startp, endp, p)
%
% Poly          Polygoni peruskoordinaatistossa nx2 matriisina.
% startp, endp  Alku- ja loppupisteet määrittelevät rakenteet, jotka
%               sisältävät alkiot 'Point' ja 'Segment'. 'Point'
%               määrää pisteiden koordinaatit sekä 'Segment' 
%               vastaavat polygonin janat.
% p             Koordinaatiston määräävä inklinaatiovektori. Mikäli 
%               p:tä ei ole annettu, oletamme, että kaikki pisteet
%               on annettu peruskoordinaatistossa.
% Points        Reitin määräävät pisteet peruskoordinaatistossa.

function Points = polygon_around(Poly, startp, endp, p)

Points = [];

[nSeg, tmp] = size(Poly);
curSeg = startp.Segment;

if nargin == 4
    n = inner_normal(p)*norm(p);
    startp.Point = startp.Point*[n;p];
    endp.Point = endp.Point*[n;p];
end
    
posSeg = curSeg; negSeg = curSeg;
Pointsp = []; Pointsn = [];        
        
while posSeg ~= endp.Segment
    posSeg = mod(posSeg, nSeg) + 1;
    if ~(posSeg == endp.Segment && endp.Type ~=1)
        Pointsp = [Pointsp;Poly(posSeg, :)];
    end
end
while negSeg ~= endp.Segment
    if ~(negSeg == startp.Segment && startp.Type ~=1)
        Pointsn = [Pointsn;Poly(negSeg, :)];
    end
    negSeg = mod(negSeg-2, nSeg) + 1;
end

Pointsp = [Pointsp; endp.Point];
Pointsn = [Pointsn; endp.Point];
if polyc_length([startp.Point; Pointsp]) > polyc_length([startp.Point; Pointsn])
    Points = [Points; Pointsn];
else
    Points = [Points; Pointsp];
end
    