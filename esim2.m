load esim2
figure(1); title 'Käsiteltävä alue ja sen sisennys'
draw_contour(C, 'b', 2, 1)
d = 10;
CO = contour_offset(C, d);
draw_contour(CO, 'r:')


axis equal
inclination_angles(d, CO, 0.001)
p = d*[cos(0.948) sin(0.948)];
Mn = create_mesh_nodes(p, CO);
Mn = mesh_connect_nodes(p, Mn, CO);
figure(2); title 'Aluetta vastaava verkko';
mesh_draw(p, Mn, CO, 1);
draw_contour(C, 'r', 1);
figure(3); title 'Kulku verkossa'
hold on
draw_contour(C, 'r', 1);
path = toolpath_stack(p, Mn, CO, 66);
path_draw(p, Mn, path, 0);

figure(4);
pp = path_topoints(p, Mn, CO, {}, path);
clf
title 'Kulkua vastaava aito reitti'
draw_contour(C, 'b', 2, 1);
ppplot(p, pp, 0.01, 0.1);
CO2 = {CO{1}};
CO2_P = {CO{2}};
Mn2 = create_mesh_nodes(p, CO2);
Mn2 = mesh_connect_nodes(p, Mn2, CO2);
maxnodes = find_nodes(Mn2, struct('Type', 2), 1);
startnode = maxnodes(length(maxnodes));
path2 = toolpath_stack(p, Mn2, CO2, startnode);
pp2 = path_topoints(p, Mn2, CO2, CO2_P, path2);

figure(5); title 'Toinen reitti hyödyntäen pseudoesteitä'
draw_contour(C, 'b', 2, 1);
ppplot(p, pp2, 0.01, 0.1);

CBO = contour_offset({C{1}}, d/2);
P = polygon_shift(CBO{1}, 4);
P = [P; P(1, :)];
[rows, cols] = size(P);
pp3 = [P ones(rows, 1);pp2];

figure(6); title 'Edelliseen reittiin lisätty reunakulku'
draw_contour(C, 'g', 2, 1);
axis equal
ppplot(p, pp3, 0.01, 0.4)

