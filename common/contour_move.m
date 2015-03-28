function C = contour_move(C, x, y)

for ind_Poly = 1:length(C)
    C{ind_Poly} = polygon_move(C{ind_Poly}, x, y);
end