% CREATE_PATH Luo reitin verkossa tietyst‰ aloitussolmusta ensimm‰iseen
% vastaantulevaan aitoon umpikujaan.
% P = CREATE_PATH(p, Mn, C, dir, startnode)
%
%   p, Mn ja C on kuten funktiossa MESH_CONNECT_NODES.
%
%   dir= 1 tai -1 riippuen siit‰ muodostammeko reitin p:n sis‰normaalin
%   vai vastakkaiseen suuntaan.
%
%   startnode on verkon se solmu, josta reitin muodostaminen aloitetaan
%
%   Funktio palauttaa nx1 vektorin Mn:n solmujen indeksej‰, jotka 
%   m‰‰r‰‰v‰t reitin.

function P = create_path(p, Mn, C, dir, startnode)

P = [startnode];
dead_end = false;
curNode = startnode;

while Mn{curNode}.Type ~= 1
    if Mn{curNode}.Right 
        curNode = Mn{curNode}.Right;        
        Mn{curNode}.Visited = true;
        P = [P;curNode];       
    else
        disp(curNode);
        error 'foo';
    end
end

while ~dead_end   
    Mn{curNode}.Visited = true;

    % Olemme tyypin 1 solmussa. Siirrymme vasemmalle tai oikealle sen
    % mukaan, kumpaan siirtyminen on mahdollista.
    
    if Mn{curNode}.Left 
        curNode = Mn{curNode}.Left;
        P = [P;curNode];
    elseif Mn{curNode}.Right 
        curNode = Mn{curNode}.Right;
        P = [P;curNode];
    else
        curNode
        error(curNode);
    end
    Mn{curNode}.Visited = true;

    % Vaakasuora siirtyminen on tehty. Koska olemme j‰lleen tyypin 1
    % solmussa, voimme siirty‰ ylˆs tai alas riippuen etenemissuuntasta. 
    % Jos vastaantulevassa solmussa on k‰yty, olemme ajaneet
    % k‰sitelt‰v‰n monotonisen lohkon. (dead_end)
    
    if dir == 1
        if Mn{curNode}.Up
            curNode = Mn{curNode}.Up;
            dead_end = Mn{curNode}.Visited;
            if ~dead_end
                P = [P;curNode];
            end
        end
    else
        if Mn{curNode}.Down
            curNode = Mn{curNode}.Down;
            dead_end = Mn{curNode}.Visited;
            if ~dead_end
                P = [P;curNode];
            end
        end
    end
    
    Mn{curNode}.Visited = true;
    
    % Jos edellisen j‰lkeen ajauduimme ‰‰riarvosolmuun, siirrymme jonkin
    % strategian mukaisesti uuteen tyypin 1 solmuun.

    if Mn{curNode}.Type ~= 1
        negNode = curNode; posNode = curNode;
        negStack = []; posStack = [];
        
        while Mn{negNode}.Type ~= 1 
           [negNode, tmp1, tmp2] = mesh_find_next_node(p, Mn, C, negNode, -1);
           negStack = [negStack; negNode];
        end
        while Mn{posNode}.Type ~= 1 
           [posNode, tmp1, tmp2] = mesh_find_next_node(p, Mn, C, posNode, 1);
           posStack = [posStack; posNode];
        end
        if ~Mn{negNode}.Visited
            curNode = negNode;
            Mn = setfields(Mn, negStack, 'Visited', true);
        elseif ~Mn{posNode}.Visited
            curNode = posNode;
            Mn = setfields(Mn, posStack, 'Visited', true);
        else
            dead_end = true;
        end
        P = [P;curNode];
    end
    %{    
    if Mn{curNode}.Type ~= 1
        if node_isdeadend(Mn, C, curNode)
                dead_end = true;
                return;
        end
        
        negNode = curNode;
        posNode = curNode;
        negStack = [];
        posStack = [];
        
        
        while Mn{negNode}.Type ~= 1 
           [negNode, tmp1, tmp2] = mesh_find_next_node(p, Mn, C, negNode, -1);
           negStack = [negStack; negNode];
        end
        while Mn{posNode}.Type ~= 1 
           [posNode, tmp1, tmp2] = mesh_find_next_node(p, Mn, C, posNode, 1);
           posStack = [posStack; posNode];
        end

        if Mn{posNode}.Visited
            curNode = negNode;
            Mn = setfields(Mn, negStack, 'Visited', true);
        else
            curNode = posNode;
            Mn = setfields(Mn, posStack, 'Visited', true);
        end
        P = [P;curNode];
    else
        Mn{curNode}.Visited = true;        
end
%}
end