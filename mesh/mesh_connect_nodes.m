% MESH_CONNECT_NODES Linkittää siksak-graafin solmut keskenään.
%   MeshNodes = MESH_CONNECT_NODES(p, MeshNodes, C) 
%
%   p=[x, y] on verkon inklinaation määräävä vektori. p:n normi määrää
%   siksak-janojen etäisyyden toisistaan ja p:n suunta janojen suunnan.
%
%   MeshNodes on cell-array MeshNode-rakenteita, jotka kuvaavat
%   siksak-graafin solmuja. Tämä saadaan yleensä funktiolla 
%   CREATE_MESH_NODES.
%   
%   C on cell array polygoneja, joista ensimmäinen määrää ulkoreunan
%   ja jälkimmäiset eri esteet. Ensimmäisen polygonin tulee olla 
%   positiivisesti(myötäpäivään) ja jälkimmäisten negatiivisesti
%   suunnistettuja.
%
%   Funktio palauttaa uuden MeshNodes-cellarrayn, jossa solmut
%   ovat linkitetty keskenään MeshNode-struktuurissa alkioilla
%   'Up', 'Down', 'Left', 'Right'.


function MeshNodes = mesh_connect_nodes(p, MeshNodes, C)

n = inner_normal(p) * norm(p, 2);
[min_o max_o min_p max_p] = mesh_size(MeshNodes);

% Pisteisiin viittauksen yksinkertaistamiseksi ja mahdollisesti
% nopeuttamiseksi kopioimme solmujen pisteet taulukkoon

for ind_Mn = 1:length(MeshNodes)
    Points(ind_Mn, :) = MeshNodes{ind_Mn}.Point;
end

% Solmuja yhdistäessä vaakasuorilla janoilla, meidän tarvitsee käydä
% läpi kokonaisluvuilla kuvattavat normaalin-suuntaiset koordinaatit.
% Ääriarvosolmut saattavat vaikuttaa maksimikoordinaatteihin, joten
% ne on tuotava oikeaan muotoon:

min_o = ceil(min_o);
max_o = floor(max_o);

for ind_o = min_o:max_o
    inds_F = find_nodes(MeshNodes, struct('Type', 1, 'Point', [ind_o 0]), 2);
    lF = length(inds_F);

    if mod(lF, 2) == 1
        s = sprintf('ZL(%d):llä pariton määrä Tyypin 1 Solmuja!', ind_o);
        warning(s);
    end
    
    for ind_F=2:lF
        if mod(ind_F, 2) == 0
            MeshNodes{inds_F(ind_F-1)}.Right = inds_F(ind_F);
            MeshNodes{inds_F(ind_F)}.Left = inds_F(ind_F-1);
        end
    end
end

for ind_P = 1:length(C)
    Poly = C{ind_P};
    [Pr, Pc] = size(Poly);
    
    for ind_S = 1:Pr
        inds_F = find_nodes(MeshNodes, struct('Polygon', ind_P, 'Segment', ind_S), 1);
        SO = segment_orientation(p, Poly, ind_S);        
        lF = length(inds_F);
        
        if lF == 0
            continue;
        end
        
        % 2a
        for ind_N = 2:lF-1
            MeshNodes{inds_F(ind_N)}.Up   = inds_F(ind_N+1);
            MeshNodes{inds_F(ind_N)}.Down = inds_F(ind_N-1);
        end

        % 2b
        if lF > 1
            isRight = segment_isright(p, Poly, ind_S, 1);
            
            if MeshNodes{inds_F(1)}.Type == 1
                MeshNodes{inds_F(1)}.Up = inds_F(2);            
            else
                if isRight
                    MeshNodes{inds_F(1)}.Right = inds_F(2);
                else
                    MeshNodes{inds_F(1)}.Left = inds_F(2);
                end
            end

            if MeshNodes{inds_F(lF)}.Type == 1
                MeshNodes{inds_F(lF)}.Down = inds_F(lF-1);
            else
                if isRight
                    MeshNodes{inds_F(lF)}.Right = inds_F(lF-1);
                else
                    MeshNodes{inds_F(lF)}.Left = inds_F(lF-1);
                end
            end
        end
        % 2c
        [newP, downP, rightP] = mesh_find_next_node(p, MeshNodes, C, inds_F(lF), SO);
        [newN, downN, rightN] = mesh_find_next_node(p, MeshNodes, C, inds_F(1), -SO);
        
        if MeshNodes{inds_F(lF)}.Type == 1
            if downP
                MeshNodes{inds_F(lF)}.Down = newP;
            else
                MeshNodes{inds_F(lF)}.Up = newP;
            end
        else
            if rightP
                MeshNodes{inds_F(lF)}.Right = newP;
            else
                MeshNodes{inds_F(lF)}.Left = newP;
            end
        end
        if MeshNodes{inds_F(1)}.Type == 1
            if downN
                MeshNodes{inds_F(1)}.Down = newN;
            else
                MeshNodes{inds_F(1)}.Up = newN;
            end
        else
            if rightN
                MeshNodes{inds_F(1)}.Right = newN;
            else
                MeshNodes{inds_F(1)}.Left = newN;
            end
        end

    end
end
