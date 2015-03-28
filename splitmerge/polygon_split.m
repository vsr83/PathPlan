% POLYGON_SPLIT jakaa polygonin kahteen osaan leikkausjanan mukaisesti.
%   C = POLYGON_SPLIT(P, v1, v2)
%
%   P on polygoni nx2 matriisina.
%
%   v1 ja v2 ovat leikkausjanan alku- ja loppupisteet. Janan on 
%   leikattava täsmälleen kahta P:n janaa.
%
%   Funktio palauttaa cell arrayn C = {P1, P2}, missä P1 ja P2
%   ovat jaossa saadut osat P:stä. 
%
%   Tässä on oleellista huomata, että P1 ja P2 on samalla tavoin
%   suunnistettuja, joten P2 ei edusta estettä kuten yleensä C:n
%   jälkimmäiset alkiot.

function C = polygon_split(P, v1, v2)

[nSeg, tmp] = size(P);

S1 = [P(v1, :);P(v2, :)];
I = zeros(nSeg, 1);

for ind_S = 1:nSeg
    ind_next = mod(ind_S, nSeg) + 1;
    S2 = [P(ind_S, :);P(ind_next, :)];
    I(ind_S) = segments_dointersect(S1, S2);
end

v1_prev = mod(v1-2, nSeg) + 1;
v2_prev = mod(v2-2, nSeg) + 1;

I(v1_prev) = 0;
I(v2_prev) = 0;
I(v1) = 0;
I(v2) = 0;

if length(find(I)) ~= 0
    error 'Jana leikkaa useampaa kuin kahta janaa!';
end

P1 = [P(v1, :)];
P2 = [P(v2, :)];

ind = v1;
while ind ~= v2
    ind = mod(ind, nSeg) + 1;
    P1 = [P1;P(ind, :)];
end
while ind ~= v1
    ind = mod(ind, nSeg) + 1;
    P2 = [P2;P(ind, :)];
end

C= {P1, P2};