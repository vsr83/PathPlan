% POLYGON_WN Laskee kierrosluvun(winding number) suljetun murtoviivan
% sisässä olevan pisteen suhteen.
% wn = POLYGON_WN(P, p)
%
% P     Polygoni nx2 matriisina.
% p     Piste, jonka suhteen kierrosluku määritellään(1x2 matriisi).
% wn    Palautettava kierrosluku.
%
% Huom: wn ei numeeristen virheiden ansiosta välttämättä ole 
% kokonaisluku! Luvun voi pyöristää komennolla ROUND.

function r = polygon_wn(P, p)

if isequal(class(P), 'cell')
    r = 0;
    
    L = length(P);
    for ind_C = 1:L
        curP = C{ind_C};
        r = r + polygon_wn(curP, p);
    end
    return;
end

[rows, cols] = size(P);

Theta = 0;

for ind_P = 1:rows
    ind_next = mod(ind_P, rows) + 1;

    u1 = P(ind_P, :) - p;
    u2 = P(ind_next, :) - p;
    
    theta = acos(dot(u1, u2) / (norm(u1)*norm(u2)));
    sign  = det([u1;u2-u1]);
    if sign > 0
        sign = 1;
    else
        sign = -1;
    end
    
    Theta = Theta + sign * theta;
end

r = Theta / (2*pi);

