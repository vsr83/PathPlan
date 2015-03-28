% POLYGON_PREOFFSET esisisent‰‰ tai laajentaa polygonia
%   PC = POLYGON_PREOFFSET(P, d)
%
%   P on polygoni nx2 matriisina
%
%   d on kohtisuora matka, joka polygonia sisennet‰‰n tai laajennetaan
%   janoihin n‰hden kohtisuoraan.


function PC = polygon_preoffset(P, d)

[rows, cols] = size(P);

IA = polyc_angles(P);
PC = [];

for ind_P = 1:rows
    ind_prev = mod(ind_P - 2, rows) + 1;
    ind_next = mod(ind_P, rows) + 1;

    p = P(ind_P, :);
    n1 = inner_normal(P(ind_P, :) - P(ind_prev, :));
    n2 = inner_normal(P(ind_next, :) - P(ind_P, :));
    
    if IA(ind_P) < pi
        % Convex-k‰rjet korvataan kahdella k‰rjell‰, jotka saadaan kulkemalla
        % alkuper‰iseen k‰rkeen yhteydess‰ olevien janojen sis‰normaalien 
        % suuntaan matka d.
        p1 = p + n1 * d;
        p2 = p + n2 * d;
        PC = [PC;p1;p2];
    else
        % Reflex-k‰rjet korvataan k‰rkeen yhteydess‰ olevia janoja
        % vastaavien sisennettyjen suorien leikkauspisteill‰ tai
        % ekvivalentisti bisektorin leikkaukselle toisen t‰llaisen suoran
        % kanssa(kuten t‰ss‰).
        
        b = bisector(P, ind_prev, ind_P);
        [x, y] = segments_intersection(p, p+b, p+n1*d, p+n1*d + (p - P(ind_prev, :)));
        PC = [PC;x y];
    end
end