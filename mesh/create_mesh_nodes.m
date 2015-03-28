% CREATE_MESH_NODES Luo Cell-Arrayn verkon solmuja vastaten siksak-
% janojen leikkauspisteit‰ C:n polygonien kanssa.
%   MeshNodes = CREATE_MESH_NODES(p, C)
%
%   p=[x, y] on verkon inklinaation m‰‰r‰‰v‰ vektori. p:n normi m‰‰r‰‰
%   siksak-janojen et‰isyyden toisistaan ja p:n suunta janojen suunnan.
%
%   C on cell array polygoneja, joista ensimm‰inen m‰‰r‰‰ ulkoreunan
%   ja j‰lkimm‰iset eri esteet. Ensimm‰isen polygonin tulee olla 
%   positiivisesti(myˆt‰p‰iv‰‰n) ja j‰lkimm‰isten negatiivisesti
%   suunnistettuja.
%
%   Funktio palauttaa cell-arrayn MeshNode-rakenteita, jotka kuvaavat
%   siksak-graafin solmuja.

function MeshNodes = create_mesh_nodes(p, C)

if ~isequal(class(C), 'cell')
    error 'C:n tulee olla cell-array polygoneja';
end

MeshNodes = [];
for ind_C = 1:length(C)
    Pg_MN = polygon_mesh(p, C{ind_C});

    for ind_Pmn = 1:length(Pg_MN)
        MeshNode = Pg_MN{ind_Pmn};       
        
        MeshNode.Polygon = ind_C;
        MeshNodes{length(MeshNodes) + 1} = MeshNode;
    end
end