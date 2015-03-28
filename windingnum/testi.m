function testi(P, d, n, inv, style)

if nargin < 5
    style = 'b';
end

draw_contour({P});
for ind_offset = 1:n
    PC = polygon_preoffset(P, d*ind_offset);
    
    C= {};
    if inv 
        C = polyc_topolygons(PC, 0, 0, 1);
    else
        C = polyc_topolygons(PC);
    end

    if mod(ind_offset, 2) == 0
        draw_contour(C, style, 1);
    else
        draw_contour(C, style, 1);
    end
    pause(0.5)
end
