% CONTOUR_OFFSET sisent�� aluetta
%   CO = CONTOUR_OFFSET(C, d)
%
%   C on cell array polygoneja, joka kuvaa aluetta(kuten muuallakin).
%
%   d on sisennett�v� matka janojen sis�normaalien suuntaan.
%
%   Funktio palauttaa sisennetyn cell arrayn polygoneja CO.
%   Huom! T�m� funktio k�sittelee esteit� ja ulkoreunaa erikseen
%   eik� sitten mitenk��n huomioi niiden sisennyksien leikkauksia.
%   Ts. funktio soveltuu k�ytt�tarkoitukseena ainoastaan silloin kun
%   sisennetyt polygonit eiv�t leikkaa kesken��n!

function CO = contour_offset(C, d)

nPoly= length(C);
CO = {};

for ind_Poly = 1:nPoly
    PC = polygon_preoffset(C{ind_Poly}, d);

    if ind_Poly > 1         
        PL = polyc_topolygons(PC, 0, 0);
    else
        PL = polyc_topolygons(PC);
    end
    
    if length(PL) > 1
        error 'Polygoni jakautuu useampaan kuin yhteen osaan.'
    else
        CO = {CO PL{1}};
    end
end