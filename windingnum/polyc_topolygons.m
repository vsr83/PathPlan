% POLYC_TOPOLYGONS  Muuntaa suljetun murtoviivan joukoksi yksinkertaisia
%                   polygoneja.
%   PL = POLYC_TOPOLYGONS(PC, vis, swn) 
%   PL = POLYC_TOPOLYGONS(PC, vis) 
%   PL = POLYC_TOPOLYGONS(PC) 
%
%   PC on murtoviiva nx2 matriisina. PC saadaan yleens� funktiolta
%   POLYGON_PREOFFSET.
%
%   Mik�li vis = 1, 
%
%   swn m��r�� kierrosluvun(winding number), jonka mukaisia silmukoita
%   etsimme.
%

% T�m� lienee vanhentunut?
%   PL = POLYC_TOPOLYGONS(PC, vis, swn, inv) 
%   inv = 1, jos olemme laajentamassa polygonia.

function PL = polyc_topolygons(P, vis, swn, inv)

L = {};
if nargin < 2
    vis = false;
end
if nargin < 3
    swn = 1;
end
if nargin < 4
    inv = 0;
end


[Nodes, Edges] = polyc_tograph(P, vis);
[nnodes , tmp] = size(Nodes);

% Etsit��n graafista minimaaliset silmukat.

[row, col] = find(Edges);
EdgeList = [row, col];
[nEdges, tmp] = size(EdgeList);
nPaths = 0;

LM = [];

% K�yd��n kaikki graafin kaaret(Edges) l�pi. Edges-matriisi on
% symmetrinen, joten kaaret k�yd��n molempiin suuntiin.

for ind_E = 1:nEdges    
    startNode = EdgeList(ind_E, 1);
    curNode = EdgeList(ind_E, 2);
    lastNode = startNode;

    path = [startNode; curNode];
        
    % Pyrit��n muodostamaan suljettu silmukka k��ntym�lll� aina niin
    % vasemmalle kuin mahdollista.     
    while curNode ~= startNode
        % Haetaan curNoden ymp�rist�n solmupisteet.
        N = find(Edges(curNode, :));
        nN = length(N);
    
        r_a = unit(Nodes(curNode, 2:3) - Nodes(lastNode, 2:3));
        c = [];
        
        % Tutkitaan jokaiseen ymp�rist�n k�rkeen johtavan reitin
        % sis�kulma. Kulma on sit� pienempi mit� enemm�n vasemmalle
        % k��nnymme.
        for ind_N = 1:nN
            r = unit(Nodes(N(ind_N), 2:3) - Nodes(curNode, 2:3));

            % Emme halua kulkea takaisin:
            if N(ind_N) == lastNode
                c(ind_N, :) = [Inf N(ind_N)];
            else            
                K = polyc_angles([Nodes(lastNode, 2:3); Nodes(curNode, 2:3);...
                                  Nodes(N(ind_N), 2:3)]);
                c(ind_N, :) = [K(2) N(ind_N)];
            end
        end
        c = sortrows(c, 1);
        lastNode = curNode;
        curNode = c(1, 2);
        
        % Jos olemme kulkeneet aiemmin t�st� (ei-aloitus)-solmusta,         
        % silmukka on virheellinen.
        if length(find(path == curNode)) > 0 && curNode ~= startNode
            %path
            path = [];
            break;
        end
        path = [path;curNode];
    end
    % Mik�li reitti on kelvollinen, lis�t��n se listaan.
    if length(path) > 0
        path(length(path)) = [];

        found = false;
        for ind_P = 1:nPaths
            thisPath = sort(path);
            testPath = sort(L{ind_P});
            
            if length(thisPath) == length(testPath) && isequal(thisPath, testPath)
                found = true;
                break;
            end
        end
        if found == false
            nPaths = nPaths + 1;
            L{nPaths} = path;            

            if vis
                Nodes(path, 2:3)
                h = fill(Nodes(path, 2), Nodes(path, 3), 'g')        
                
                path
                %input ''
                delete(h)
            end
        end
    end
end


% Nyt meill� on iso lista L silmukoita, joita graafistamme on 
% l�ytynyt. 
%
% Laajentaessamme(inv = 1) polygonia, olemme kiinnostuneita pinta-alaltaan
% laajimmasta silmukasta, joka ilmeisesti on aina yksi edell�saaduista.

nPolygons = 0;
PL = {};
A = zeros(length(L), 1);

for ind_path = 1:nPaths
    path = L{ind_path};
    A(ind_path) = abs(polygon_area(Nodes(path, 2:3)));
    
    p = polygon_findinside(Nodes(path,2:3));            
    wn = polygon_wn(P, p);
    wn
    swn
    if round(wn) == swn
        nPolygons = nPolygons + 1;
        PL{nPolygons} = Nodes(path, 2:3);
    end
    if vis 
        polyc_draw(Nodes(path, 2:3), 0.05, 0);
      
        
        s = sprintf('%.2f', round(wn));
        text(p(1), p(2), s);
        plot(p(1), p(2), 'gs');
    end
end

% Jos laajennamme polygonia, haluamme my�s ulkoreunaa kuvaavan polygonin.
% Koska kierroslukua testataan aina t�m�n sis�puolelta, t�ytyy polygoni
% lis�t� erikseen.

if inv
    ind = find(A == max(A));
    PO = Nodes(L{ind}, 2:3);
    
    nPolygons = nPolygons + 1;
    PL{nPolygons} = PO;
end

