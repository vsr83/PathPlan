% Haemme verkon solmupisteiden koordinaattien maksimin ja minimin.
% verkon suunnan m‰‰r‰‰m‰ss‰ koordinaatistossa.

function [min_o max_o min_p max_p] = mesh_size(MeshNodes)

min_o = realmax;
min_p = realmax;
max_o = realmin;
max_p = realmin;

for ind_Mn = 1:length(MeshNodes)
    point = MeshNodes{ind_Mn}.Point;
    
    o = point(1);
    p = point(2);
    min_o = min(min_o, o);
    min_p = min(min_p, p);
    max_o = max(max_o, o);
    max_p = max(max_p, p);
end