% CONTOUR_SPLIT_THROUGH_HOLE jakaa esteitä sisltävän alueen kahteen
% osaan kahdella janalla, joista molemmat lävistävät ulkoreunan sekä
% molemmat saman esteen.
%   [CO0, CO1] = CONTOUR_SPLIT_THROUGH_HOLE(C, S1, S2)
%
%   C on cell array polygoneja (kuten muuallakin).
%
%   S1 ja S2 ovat muotoa [x1 y1;x2 y2] olevia matriiseja, jotka
%   määrittävät leikkausjanat. Molempien janojen on kuljettava
%   täsmälleen kerran ulkoreunan ja saman esteen läpi.
%
%   Funktio palauttaa jaossa saatuja alueita kuvaavat cell-arrayt
%   polygoneja, jotka sisältävät niiden ulkoreunojen rajoittamat
%   C:n esteet.

function [CO0, CO1] = contour_split_through_hole(C, S1, S2)

nPoly = length(C);

% Haetaan leikkauspisteet jakajajanojen ja esteiden kanssa.

I1 = [];
I2 = [];

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
        [L x y] = segments_dointersect(S, S2);
        if L
            I2 = [I2; ind_Poly ind_Seg ind_next x y];
        end
    end
end

% Leikkausten määrä jakajilla.

[nI1, tmp] = size(I1);
[nI2, tmp] = size(I2);

if nI1 ~= nI2 || nI1 ~= 2
    error 'Jakajien leikkauksissa virhe!'
end

% Oletus: I1(1,1) = I2(1, 1) = 1 
%         I1(2,1) = I2(2, 1) ~= 1

P = C{1};
PE = C{I1(2, 1)};

[nSeg, tmp] = size(P);
[nSegE, tmp] = size(PE);

% Kierto 1
% I1 -> Loppu(SEG(I1)-> Alku(SEG(I2)) -> I2 -> E2 -> Loppu(SEG(E2))
%    -> Alku(SEG(E1)) -> E1 -> I1

ind_I1 = I1(1, 3); ind_I2 = I2(1, 2);
ind_E1 = I1(2, 2); ind_E2 = I2(2, 3);

ind = ind_I1;
PO0 = [P(ind, :)];
while ind ~= ind_I2;
    ind = mod(ind, nSeg) + 1;
    PO0 = [PO0; P(ind, :)];
end
ind = ind_E2;
PO0 = [PO0; I2(1:2, 4:5); PE(ind, :)];
while ind ~= ind_E1
    ind = mod(ind, nSegE) + 1;
    PO0 = [PO0; PE(ind, :)];
end
PO0 = [PO0; I1([2 1], 4:5)];


% Kierto 2 (Tämä on kyllä todella rumaa kirjoittaa jokseenkin sama
%           asia kahteen kertaan.)
% I2 -> Loppu(SEG(I2)) -> Alku(SEG(I1)) -> I1 -> E1 -> Loppu(SEG(E1))
%    -> Alku(SEG(E2))  -> E2 -> I2

ind_I1 = I1(1, 2); ind_I2 = I2(1, 3);
ind_E1 = I1(2, 3); ind_E2 = I2(2, 2);

ind = ind_I2;
PO1 = [P(ind, :)];
while ind ~= ind_I1
    ind = mod(ind, nSeg) + 1;
    PO1 = [PO1; P(ind, :)];
end
ind = ind_E1;
PO1 = [PO1; I1(1:2, 4:5); PE(ind, :)];
while ind ~= ind_E2
    ind = mod(ind, nSegE) + 1;
    PO1 = [PO1; PE(ind, :)];
end
PO1 = [PO1; I2([2 1], 4:5)];


%%
CO0 = {PO0};
CO1 = {PO1};

% Nyt on selvitettävä kumpaan polygoneista jäljelle jäävät estepolygonit
% kuuluvat.

for ind_Poly = 2:nPoly
    if ind_Poly ~= I1(2, 1)
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
end

draw_contour(CO0, 'b');
draw_contour(CO1, 'r');

I1
I2