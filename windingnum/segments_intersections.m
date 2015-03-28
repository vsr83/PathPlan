% SEGMENTS_INTERSECTIONS m‰‰ritt‰‰ janajoukosta kesken‰‰n leikkaavat janat.
%   [I, XY] = segments_intersections(S)
%
%   S on nx4 matriisi, jonka rivit [x1 y1 x2 y2] vastaavat yksitt‰isi‰
%   janoja.
%
%   I on nxn harva matriisi. I(i, j) = 1 <=> janat i ja j leikkaavat.
%
%   XY on mx4 matriisi, jonka rivit m‰‰ritt‰v‰t leikkaavien janojen
%   indeksit ja leikkauspisteet muodossa [i1, i2, x, y].

function [I, XY] = segments_intersections(S)

[nseg, cols] = size(S);

I = sparse(zeros(nseg));

% Huom matriisi on "enemm‰n kuin" alakolmiomatriisi. 
% ts. ind_S1 >= ind_S2 => I = 0

XY = [];

for ind_S1 = 2:nseg
    % Emme halua huomioida leikkauksia per‰kk‰isten janojen v‰lill‰.
    S1_prev = ind_S1 - 1;
    S1_next = mod(ind_S1, nseg) + 1;
    
    for ind_S2 = 1:ind_S1-1
        [L, x, y] = segments_dointersect([S(ind_S1, 1:2); S(ind_S1, 3:4)], ...
                                         [S(ind_S2, 1:2); S(ind_S2, 3:4)]);

        if L && ind_S2 ~= S1_prev && ind_S2 ~= S1_next
            I(ind_S1, ind_S2) = 1;        
            XY = [XY;ind_S1 ind_S2, x, y];
        end        
    end
end
