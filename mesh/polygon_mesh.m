% MeshNodes = POLYGON_MESH(p, P)
% Käyttäytyminen on sama kuin CREATE_MESH_NODES:lla, mutta argumenttina
% annetaan yksittäinen polygoni.

% TEHTÄVÄÄ:
% Huomioi kaksinkertaisien solmupisteiden esiintyminen janojen 
% leikkauspisteissä.

function MeshNodes = polygon_mesh(p, Pg)

[Pg_rows, Pg_cols] = size(Pg);
nu = inner_normal(p);
lp = norm(p, 2);
pu = p / lp;

MeshNodes = {};

for ind_Pg = 1:Pg_rows
    ind_next = mod(ind_Pg, Pg_rows) + 1;
    ind_prev = mod(ind_Pg -2, Pg_rows) + 1;

    % Haetaan 'aidot' solmutpisteet:
    [O, P] = segment_coords(p, Pg(ind_Pg, :), Pg(ind_next, :));

    for ind_O = 1:length(O)
        MeshNode = struct('Right', 0, 'Up', 0, 'Left', 0, 'Down', 0);
        MeshNode.Point = [O(ind_O), P(ind_O)];
        MeshNode.Segment = ind_Pg;
        MeshNode.Type = 1;
        MeshNode.Visited = false;
        
        ind_F = find_nodes(MeshNodes, struct('Point', MeshNode.Point, 'Type', 1), 1);        

        % find_nodes vertaa normia eps(1000) toleranssilla.
        if length(ind_F) == 0
            MeshNodes{length(MeshNodes) + 1} = MeshNode;
        end
    end   
    
    % Haetaan lokaalit ääriarvopisteet veraamalla kärjen normaalin
    % suuntaista koordinaattia viereisten kärkien koordinaatteihin.
    o_prev = Pg(ind_prev, :) * nu' / lp;
    o_this = Pg(ind_Pg, :) * nu' / lp;
    o_next = Pg(ind_next, :) * nu' / lp;
    
    if o_this > max(o_prev, o_next) || o_this < min(o_prev, o_next)
        p_this = Pg(ind_Pg, :) * pu' / lp;
        
        MeshNode = struct('Right', 0, 'Up', 0, 'Left', 0, 'Down', 0);
        MeshNode.Point = [o_this p_this];
        MeshNode.Segment = ind_Pg;
        if o_this > max(o_prev, o_next)
            MeshNode.Type = 2;
        else
            MeshNode.Type = 3;
        end
        MeshNode.Visited = false;
        MeshNodes{length(MeshNodes) + 1} = MeshNode;
    end
end