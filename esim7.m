drawtext= 1;

load esim2

%C = {C{1}};
P = C{1};
midx = sum(P(:, 1))/length(P);
midy = sum(P(:, 2))/length(P);

P(:, 1) = P(:, 1) - midx;
P(:, 2) = P(:, 2) - midy;
C{1} = P;

P = C{2};
P(:, 1) = P(:, 1) - midx;
P(:, 2) = P(:, 2) - midy;
C{2} = P;



figure(1); title 'K?sitelt?v? alue ja sen sisennys'
draw_contour(C, 'b', 2, 1)
d = 22;
CO = contour_offset(C, d/2);
draw_contour(CO, 'r:')


axis equal
inclination_angles(d, CO, 0.001)
p = d*[cos(0.99) sin(0.99)];
Mn = create_mesh_nodes(p, CO);
Mn = mesh_connect_nodes(p, Mn, CO);
figure(2); title 'Aluetta vastaava verkko';
mesh_draw(p, Mn, CO, drawtext);
draw_contour(C, 'r', 1);
figure(3); title 'Kulku verkossa'
hold on
draw_contour(C, 'r', 1);
path = toolpath_stack(p, Mn, CO, 31);
path_draw(p, Mn, path, 0);

figure(4);
pp = path_topoints(p, Mn, CO, {}, path);
clf
title 'Kulkua vastaava aito reitti'
draw_contour(C, 'b', 2, 1);
ppplot(p, pp, 0.01, 0.3);
CO2 = {CO{1}};
CO2_P = {CO{2}};
Mn2 = create_mesh_nodes(p, CO2);
Mn2 = mesh_connect_nodes(p, Mn2, CO2);
maxnodes = find_nodes(Mn2, struct('Type', 2), 1);
startnode = maxnodes(length(maxnodes));
path2 = toolpath_stack(p, Mn2, CO2, startnode);
pp2 = path_topoints(p, Mn2, CO2, CO2_P, path2);

figure(5); title 'Toinen reitti hy?dynt?en pseudoesteit?'
draw_contour(C, 'b', 2, 1);
ppplot(p, pp2, 0.01, 0.1);

CBO = contour_offset({C{1}}, d/2);
P = polygon_shift(CBO{1}, 4);
P = [P; P(1, :)];
[rows, cols] = size(P);
pp3 = [P ones(rows, 1);pp2];

figure(6); title 'Edelliseen reittiin lis?tty reunakulku'
draw_contour(C, 'g', 2, 1);
axis equal
ppplot(p, pp3, 0.01, 0.4)

