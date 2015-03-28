% FIND_NODES Etsii MeshNodes-cellarrayst‰ alkioita.
%
%   ind = FIND_NODES(MeshNodes, MnStruct, sortc)
%   
%   MeshNodes on cell-array MeshNode-rakenteita, jotka kuvaavat
%   siksak-graafin solmuja. T‰m‰ saadaan yleens‰ funktioilla 
%   CREATE_MESH_NODES ja MESH_CONNECT_NODES.
%
%   MnStruct on struct niit‰ MeshNodes-rakenteen alkioita, joita
%   haluamme etsi‰. Esimerkiksi 
%    ind = FIND_NODES(MeshNodes, struct('Type', 2), 1)
%   palauttaa taulukon niiden MeshNodes-cellarrayn alkioiden
%   indeksej‰, joita vastaavat solmut ovat Tyyppi‰ 2. Ts.
%   jokaisella ind(n) MeshNodes{ind(n)}.Type = 2.
%
%   sortc kertoo kumman koordinaatin lˆydetyt solmut j‰rjestet‰‰n.
%
%   Funktio palauttaa vektorin ind t‰sm‰‰vien solmujen indeksej‰
%   j‰rjestettyn‰ jommankumman koordinaatin n tai p mukaan.
%

function I = find_nodes(MeshNodes, MnStruct, sortc)

MnFields = fieldnames(MnStruct);
I = [];

for ind_Mn = 1:length(MeshNodes)
    MeshNode = MeshNodes{ind_Mn};
    found = true;
    
    for ind_Fn = 1:length(MnFields)
        name = MnFields{ind_Fn};
        data1 = getfield(MeshNode, name);
        data2 = getfield(MnStruct, name);
        
        
        if isequal(name, 'Point') 
            if sortc == 2
                if data1(1) ~= data2(1)
                    found = false;
                end
            else
                % T‰h‰n pit‰isi selvitt‰‰ mink‰lainen luku eps sis‰‰n
                % on syyt‰ oikeasti laittaa.
                found = norm(data1 - data2, 2) < eps(1000);
            end
        else
            if ~isequal(data1, data2)
                found = false;
            end
        end
    end
    if found
        I = [I; ind_Mn, MeshNode.Point(sortc)];
    end
end

if length(I) > 0
    I = sortrows(I, 2);
    I = I(:, 1);
end