% POINT_INPOLYGON(P, p)
%
% 

function I = point_inpolygon(P, p)

I = 0;

A = polygon_area(P);

% Jos A on negatiivinen, P on negatiivisesti suunnistettu.

if A < 0
    wn = polygon_wn(P, p);
    if round(wn) == -1
        I = 1;
    end
elseif A > 0
    wn = polygon_wn(P, p);
    if round(wn) == 1
        I = 1;
    end
end