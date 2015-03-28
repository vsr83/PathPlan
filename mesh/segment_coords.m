% SEGMENT_COORDS palauttaa vektorin leikkauspisteitä siksakjanojen 
%                ja janan välillä [n p]-koordinaatistossa.

% Oletetaan, että taso on jaettu tangentin t suuntaisilla
% suorilla. Tehtävänä on selvittää mitkä näistä suorista janamme 
% (r1,r2) leikkaa. Näin saamme 'aidot' solmupisteet, joiden välillä
% työkone siirtyy 'vaakasuorassa'.

% Martin Held ehdottaa tähän ilmeisesti monimutkaisempaa "sweep line"-
% tekniikkaa, mutta ongelma vaikuttaa yksinkertaisemmalta tarkastella
% tangentin t ja sen "sisänormaalin" määräämässä koordinaatistossa.

% o viittaa tangentin suhteen ortogonaaliseen koordinaattiin.
% u-pääte kertoo kyseessä olevan yksikkövektori.

function [O P] = segment_coords(t, r_1, r_2)

l = norm(t, 2);
tu = t / l;
nu = inner_normal(t);
n = nu * l;

o_1 = (r_1 * nu') / l;
o_2 = (r_2 * nu') / l;
p_1 = r_1 * tu' / l;
p_2 = r_2 * tu' / l;

max_o = max(o_1, o_2);
min_o = min(o_1, o_2);
max_p = max(p_1, p_2);
min_p = min(p_1, p_2);

min_o = ceil(min_o);
max_o = floor(max_o);

O = (min_o:max_o)';

%if floor(max_o) > floor(min_o)
if o_2 ~= o_1
    kk = (p_2 - p_1) / (o_2 - o_1);
    p_0 = p_1 - kk * o_1;
    P = kk * O + p_0;
else
    P = []; O = [];
    return;
end