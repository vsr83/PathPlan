function Cnew = contour_offset(C, d)

nPolygons = length(C);

Cnew = {};

for ind_Poly = 1:nPolygons
    Ctmp = polygon_offset(C{ind_Poly}, d);
    if length(Ctmp) == 1
        Cnew = {Cnew{:}, Ctmp{:}};
    end
end