% CONTOUR_ISINSIDE tutkii onko piste alueen sisässä.
% I = CONTOUR_ISINSIDE(C, p)

function I = contour_isinside(C, p)

nPoly = length(C);

I = true;

if round(polygon_wn(C{1}, p)) ~= 1
    I = false;
end

for ind_Poly = 2:nPoly
    if round(polygon_wn(C{ind_Poly}, p)) ~= 0
        I = false;
    end
end