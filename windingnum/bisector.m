% Straight skeleton-muunnoksen implementaatiossa bisektori lasketaan
% kahdelle mielivaltaiselle reunalle, joiden ei tarvitse olla 
% vierekkäisiä. Tämä on tarpeen, koska osa reunoista katoaa 
% kutistusprosessissa. Erillään olevista reunoista voi tällöin
% tulla vierekkäisiä.
%
% Ts. oletetaan vastaavat puolisuorat peräkkäisiksi ja lasketaan 
% niiden välinen kulma, puolitetaan se kahdella ja lisätään
% jälkimmäisen kulmaan.

function b = bisector(P, ind_E1, ind_E2)

[rows, cols] = size(P);

edge1_start = ind_E1;
edge1_end   = mod(ind_E1, rows) + 1;

edge2_start = ind_E2;
edge2_end   = mod(ind_E2, rows) + 1;

u1 = unit(P(edge1_end, :) - P(edge1_start, :));
u2 = unit(P(edge2_end, :) - P(edge2_start, :));

K = polyc_angles([0 0; u1; u1+u2]);

a = arctan(u2) + K(2)/2;
b = [cos(a), sin(a)];