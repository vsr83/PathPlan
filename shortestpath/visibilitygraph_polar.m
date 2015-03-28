% VISIBILITYGRAPH_POLAR muodostaa n‰kyvyysgraafin alueelle 
%   [Vout, E, V] = visibilitygraph_polar(C)
%   [Vout, E, V] = visibilitygraph_polar(C, draw)
%
%   C on cell array polygoneja, joka m‰‰ritt‰‰ alueen(kuten muaallakin).
%
%   Funktio palauttaa matriisit Vout, E, V
%
%   Vout on nx3 matriisi, jonka rivit ovat numeroituja n‰kyvyysgraafin 
%   solmuja muodossa [ind x y].
%
%   E on nx3 matriisi, joka m‰‰ritt‰‰ graafin kaaret. E:n rivit ovat
%   muotoa [ind, v1, v2], mik‰ ilmaisee, ett‰ solmujen v1 ja v2 v‰lill‰
%   on kaari.
%
%   V on nx2 matriisi, joka liitt‰‰ n‰kyvyysgraafin pisteet C:n
%   tiettyjen polygonien tietyille janoille.
%
%   Jos draw on annettu ja nollasta poikkeava, n‰kyvyysgraafin
%   kaaret piirret‰‰n.


function [Vout, E, V] = visibilitygraph_polar(C, draw)

if nargin < 2
    draw = false;
end

V = [];
E = [];
%d
ind_V = 1;
for ind_P = 1:length(C)
    Poly = C{ind_P};
    [Pr, Pc] = size(Poly);

    for ind_S = 1 :Pr
        V(ind_V, :) = [ind_P ind_S];
        Vout(ind_V, :) = [ind_V Poly(ind_S, :)];
        %text(Poly(ind_S, 1), Poly(ind_S, 2), num2str(ind_V));
        ind_V = ind_V + 1;
    end
end

ind_E = 1;
for ind_P = 1:length(C)
    Poly = C{ind_P};
    [rows, cols] = size(Poly);
    
    for ind_S = 1:rows
        visible = visiblevertices_polar(C, ind_P, ind_S, [], false);
        p = Poly(ind_S, :);

        %[ind_P ind_S]
        
        vertex_source = list_find(V, [ind_P ind_S]);
        
        [Vr, Vc] = size(visible);
        for ind_V = 1:Vr
            vPoly = C{visible(ind_V, 1)};
            vSeg = visible(ind_V, 2);

            vertex_end = list_find(V, [visible(ind_V, 1) vSeg]);      
            
            if draw
                plot([p(1);vPoly(vSeg, 1)], [p(2);vPoly(vSeg, 2)], 'r');
            end

            m = min(vertex_source, vertex_end);
            M = max(vertex_source, vertex_end);
            
            if ~list_find(E, [m M])           
                E(ind_E, :) = [m M];
                ind_E = ind_E + 1;
            end
        end
    end
end

E = [(1:ind_E-1)' E];