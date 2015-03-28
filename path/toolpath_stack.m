% TOOLPATH_STACK muodostaa reitin verkossa pinoamallla funktion
%                CREATE_PATH muodostamia reittejä.
%   TP = TOOLPATH_STACK(p, Mn, C, startnode)
%
%   p, Mn ja C ovat kuten funktiossa MESH_CONNECT_NODES.
%
%   startnode on aloitussolmu Mn:n kuvaamassa verkossa, josta reittiä
%   lähdetään muodostamaan.
%
%   Funktio palauttaa nx2 matriisin, jonka rivit muodostuvat indekseistä
%   solmuille, joiden kautta muodostettu reitti kulkee ja kokonaisluvusta
%   1 tai 0 riippuen siitä, lähteekö solmusta paluuliike.


function toolpath = toolpath_stack(p, Mn, C, startnode)

if Mn{startnode}.Type == 2
    dir = -1;
elseif Mn{startnode}.Type == 3
    dir = 1;
else
    error 'Aloitussolmun tulee olla ääriarvosolmu!';
end

toolpath = [];
stack = [startnode dir];
lastNode = 0;

while length(stack) > 0
    [srows, tmp] = size(stack);
    dir = stack(srows, 2);
    startnode = stack(srows, 1);
    
    while Mn{startnode}.Visited
        stack(srows,:) = [];        
        [srows, tmp] = size(stack);
        if srows == 0
            return;
        end
        startnode = stack(srows, 1);
        dir = stack(srows, 2);
    end

    if lastNode
        if Mn{startnode}.Left
            startnode2 = Mn{startnode}.Left;
        else
            startnode2 = Mn{startnode}.Right;
        end
        dist = Mn{startnode}.Point - Mn{lastNode}.Point;
        dist2 = Mn{startnode2}.Point - Mn{lastNode}.Point;
        if norm(dist2,2) < norm(dist, 2)
            startnode = startnode2;
        end
    end
    
    
    path = create_path(p, Mn, C, dir, startnode);
    path_len = length(path);
    stack(srows,:) = [];
    lastNode = path(path_len);
    
    toolpath = [toolpath;path [zeros(length(path)-1, 1);1]];
        
    Mn = setfields(Mn, path, 'Visited', true);

    % Lisää asianmukaiset solmut pinoon.
    for ind_path=1:path_len
        curNode = path(ind_path);
        down = Mn{curNode}.Down;
        up = Mn{curNode}.Up;
        
        if Mn{curNode}.Type ~= 1
            continue;
        end

        posNode = curNode;
        negNode = curNode;
        
        while Mn{posNode}.Type ~= 1 || posNode == curNode
            [posNode, tmp1, tmp2] = mesh_find_next_node(p, Mn, C, posNode, 1);
        end
        while Mn{negNode}.Type ~= 1 || negNode == curNode
            [negNode, tmp1, tmp2] = mesh_find_next_node(p, Mn, C, negNode, -1);
        end
        if ~Mn{posNode}.Visited
            SO = segment_orientation(p, C{Mn{posNode}.Polygon}, ...
                                        Mn{posNode}.Segment);
            stack = [stack;posNode SO/abs(SO)];
        end
        if ~Mn{negNode}.Visited
            SO = segment_orientation(p, C{Mn{negNode}.Polygon}, ...
                                        Mn{negNode}.Segment);
            stack = [stack;negNode -SO/abs(SO)];
        end
    end
    %stack
end

ind_F = find_nodes(Mn, struct('Visited', false, 'Type', 1), 1)
