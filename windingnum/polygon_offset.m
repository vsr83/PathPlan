function C = polygon_offset(P, d)

PC = polygon_preoffset(P, d);
PO = polygon_orientation(P);

if PO == 1
    C = polyc_topolygons(PC);
elseif PO == -1
    C = polyc_topolygons(PC, 0, 0, 1);
end