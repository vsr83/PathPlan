% CONTOUR_SPLIT jakaa esteitä sisltävän alueen kahteen osaan janalla, 
% joka lävistää ulkoreunan kahdessa paikassa.
%   [CO0, CO1] = CONTOUR_SPLIT(C, S1)
%
%   C on cell array polygoneja (kuten muuallakin).
%
%   S1 on muotoa [x1 y1;x2 y2] oleva matriisi, joka määrittää
%   leikkausjanan. Janojen on kuljettava täsmälleen kaksi kertaa 
%   ulkoreunan läpi eikä se saa leikata yhtäkään estettä.
%
%   Funktio palauttaa jaossa saatuja alueita kuvaavat cell-arrayt
%   polygoneja, jotka sisältävät niiden ulkoreunojen rajoittamat
%   C:n esteet.


function [CO0, CO1] = contour_split(C, S1)

nPoly = length(C);

% Haetaan leikkauspisteet jakajajanojen ja esteiden kanssa.

I1 = [];

for ind_Poly = 1:nPoly
    P = C{ind_Poly};
    [nSeg, tmp] = size(P);
    
    for ind_Seg = 1:nSeg
        ind_next = mod(ind_Seg, nSeg) + 1;
        S = [P(ind_Seg, :); P(ind_next, :)];
        
        [L x y] = segments_dointersect(S, S1);
        if L
            I1 = [I1; ind_Poly ind_Seg ind_next x y];
        end
    end
end

[nI, tmp] = size(I1);
if nI ~= 2 
    error 'Jakaja ei leikkaa ulkoreunaa täsmälleen kahdessa pisteessä!'
end
if I1(1,1) ~= 1 || I1(2, 1) ~= 1
    error 'Jakaja leikkaa estepolygoneja!'
end

P = C{1};

% Muodostetaan polygonit kiertämällä jakajan määräämät kaksi
% silmukkaa.

[nSeg, tmp] = size(P);

ind = I1(1, 3);
PO0 = [I1([2 1], 4:5); P(ind, :)];
while ind ~= I1(2, 2)
    ind = mod(ind, nSeg) + 1;
    PO0 = [PO0; P(ind, :)];
end

ind = I1(2, 3);
PO1 = [I1([1 2], 4:5); P(ind, :)];
while ind ~= I1(1, 2)
    ind = mod(ind, nSeg) + 1;
    PO1 = [PO1; P(ind, :)];
end

CO0 = {PO0};
CO1 = {PO1};

for ind_Poly = 2:nPoly
    P = C{ind_Poly};
    in0= point_inpolygon(PO0, P(1, :));
    in1= point_inpolygon(PO1, P(1, :));
    if in0 && in1
        error 'Piste molemmissa polygoneissa => jokin vialla!'
    end
    if in0             
        CO0{length(CO0) + 1} = P;
    elseif in1
        CO1{length(CO1) + 1} = P;
    end
end

draw_contour(CO0, 'b')
draw_contour(CO1, 'r')
