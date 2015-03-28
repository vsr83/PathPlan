

drawtext= 0;
startnode = 411;

theta = [1:0.1:(10*pi)]';
P1 = [(theta+0).*cos(theta), (theta+0).*sin(theta)];
PS = [31.4, 30; 60, 30; 60, 0; 35.85, 0];
P2 = [(theta+5).*cos(theta), (theta+5).*sin(theta)];

P = [P1; PS; P2(end:-1:1, :)];
PE = [50, 10; 40, 10; 40, 20; 50, 20];

P = P(end:-1:1, :);

C = {P, PE};

figure(1); title 'K?sitelt?v? alue ja sen sisennys'
draw_contour(C, 'b', 2, 1)
d = 1;
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
path = toolpath_stack(p, Mn, CO, startnode);
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

