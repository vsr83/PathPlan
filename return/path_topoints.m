% PATH_TOPOINTS Muuntaa verkossa annetun liikeradan "todelliseksi"
% liikeradaksi.
% Points = PATH_TOPOINTS(p, Mn, C, AH, Path)
% Points = PATH_TOPOINTS(p, Mn, C, AH, Path, Vout, E, V)
%
%   p, Mn, C määritellään samoin kuin funktiossa MESH_CONNECT_NODES.
%
%   AH on cell array kierrettäviä lisäesteitä, jotka eivät vaikuta
%   verkossa muodostettuun reittiin.
%
%   Path on reitti verkossa, joka saadaan esimerkiksi funktiolta
%   TOOLPATH_STACK.
%
%   Vout, E, V Saadaan näkyvyysgraafilta esimerkiksi funktiolla
%   VISIBILITYGRAPH_POLAR. Toisaalta oletamme, että mikäli läsnä on
%   lisäesteitä tai/ja käyttäjä ei ole antanut näitä, näkyvyysgraafi
%   muodostetaan uudestaan.
%
%   Funktio palauttaa nx3 matriisin, jonka rivit vastaavat reitin
%   pisteitä. Ensimmäiset kaksi alkiota rivillä määräävät pisteen
%   koordinaatit [x, y] ja kolmas alkio kertoo minkätyyppinen jana
%   kyseisestä pisteestä lähtee. 1 reuna, 2 siksak, 3 paluu.
%

% 26.7.2007
% path_topoints - Muuntaa solmujen välisen liikeradan "aidoksi"
% liikeradaksi. 

% Tyyppi merkitään janan päätepisteeseen.

function Points = path_topoints2(p, Mn, C, AH, Path, Vout, E, V)

% Korvataan lisäesteet niiden konvekseilla verhoilla.
C2 = C;
if length(AH) > 0 
    for ind_ah = 1:length(AH)
        H = AH{ind_ah};
    
        ch = convhull(H(:, 1), H(:, 2));
        ch(length(ch)) = [];
        H = invert(H(ch, :));
        %AH{ind_ah} = H;
        C2{length(C2)+1} = H;
    end

% Muodostetaan verkko lisäesteiden kanssa:
% Tässä on oleellista huomioida, että lisättyjen esteiden solmut 
% lisätään uudessa verkossa vanhojen jälkeen. ts. Verkon Mn solmut 
% löytyvät verkosta Mn2, mutta linkitykset voivat olla erilaisia. 

    Mn2 = create_mesh_nodes(p, C2);
    Mn2 = mesh_connect_nodes(p, Mn2, C2);
else
    Mn2 = Mn;
end

if nargin < 8 || length(AH) > 0
    [Vout, E, V] = visibilitygraph_polar(C2);
end


n = inner_normal(p) * norm(p, 2);
[rows, cols] = size(Path);

Points = [Mn{Path(1)}.Point*[n;p] 1];

for ind_P = 1:length(Path)-1
    ind_next = ind_P + 1;
    curNode = Path(ind_P);
    nextNode = Path(ind_next);

    onZigzagSeg = (Mn{curNode}.Type == 1 && ...
                  (Mn{curNode}.Left == nextNode || ...
                   Mn{curNode}.Right == nextNode));
    onSegment = (Mn{curNode}.Polygon == Mn{nextNode}.Polygon && ...
                 Mn{curNode}.Segment == Mn{nextNode}.Segment);
     
    % Kuljemmeko siksak-janaa pitkin tai reunaa pitkin pysyen
    % samalla janalla?
    simple = onZigzagSeg || onSegment;
    
    jump = Path(ind_P, 2);
    if simple
        if onZigzagSeg && (Mn2{curNode}.Left ~= nextNode && ...
                           Mn2{curNode}.Right~= nextNode)
            startSeg = Mn2{curNode}.Point(1);
            
            nodes = find_nodes(Mn2, struct('Point', startSeg), 2);

            ind_start = find(nodes == curNode);
            ind_end   = find(nodes == nextNode);                        
            if ind_start < ind_end
                dir = 1;
            else 
                dir = -1;
            end
            
            
            if ~mod(ind_end - ind_start, 2) 
                ind_start
                ind_end
                error 'foobar!'
            end
            
            ind = ind_start;
            
            while ind ~= ind_end
                thisNode = Mn2{nodes(ind)};
                nextNode = Mn2{nodes(ind + dir)};
                if mod(ind - ind_start, 2) 
                    ap = polygon_around(C2{thisNode.Polygon}, thisNode, nextNode, p);
                    [rows, cols] = size(ap);
                    Points = [Points; ap ones(rows, 1)*2];
                else
                    Points = [Points; nextNode.Point*[n;p] 2];
                end

                ind = ind + dir;
            end
        else
            Points = [Points; Mn{nextNode}.Point*[n;p] onZigzagSeg+1];
        end
    elseif jump%if 1 == 1
        % Haemme lyhintä reittiä edellisen kuljetun siksak-janan
        % lopusta, joten voimme poistaa kaiken muun välistä.
        [rows, cols] = size(Points);
        while Points(rows, 3) ~= 2
            Points(rows, :) = [];
            [rows, cols] = size(Points);
        end
        
        startp = Mn{curNode};
        endp = Mn{nextNode};
        
        startp.Point = startp.Point * [n;p];
        endp.Point = endp.Point * [n;p];
        
        spath = shortestpath(startp, endp, C2, Vout, E, V);
        %[curNode, nextNode]
        % Lyhimmän reitin alkusolmu on lisätty jo edellisellä ind_P.
        if isequal(Points(:, 1:2), startp.Point)
            spath(1, :) = [];
        end
        [rows, cols] = size(spath);
        Points = [Points; spath ones(rows, 1)*2+1];
    else
        ap = polygon_around(C{Mn{curNode}.Polygon}, Mn{curNode}, Mn{nextNode}, p);
        [rows, cols] = size(ap);
        Points = [Points; ap ones(rows, 1)];
    end        
end