load esim4

startp = [356 200]; endp = [152 173];
[C1, C2] = contour_split(C, [startp;endp]);

startp = [539 283];endp = [430 140];
[C2, C3] = contour_split(C2, [startp;endp]);

figure(1);
clf
draw_contour(contour_move(C1, 0, 0));
draw_contour(contour_move(C2, 20, 20));
draw_contour(contour_move(C3, 0, 20));


% Luodaan sisennykset jokaiselle alueista:
d = 5;
CO1 = contour_offset(C1, d/2);
CO2 = contour_offset(C2, d/2);
CO3 = contour_offset(C3, d/2);

draw_contour(contour_move(CO1, 0, 0), 'g');
draw_contour(contour_move(CO2, 20, 20), 'g');
draw_contour(contour_move(CO3, 0, 20), 'g');

axis equal

[NS, incl1, p1] =inclination_angles(d, CO1, 0.001);
[NS, incl2, p2] =inclination_angles(d, CO2, 0.001);
[NS, incl3, p3] =inclination_angles(d, CO3, 0.001);

disp 'Verkko1'
Mn1 = create_mesh_nodes(p1, CO1);
Mn1 = mesh_connect_nodes(p1, Mn1, CO1);
disp 'Verkko2'
Mn2 = create_mesh_nodes(p2, CO2);
Mn2 = mesh_connect_nodes(p2, Mn2, CO2);
disp 'Verkko3'
Mn3 = create_mesh_nodes(p3, CO3);
Mn3 = mesh_connect_nodes(p3, Mn3, CO3);

figure(2);
disp 'Piirret‰‰n Verkot'
clf
mesh_draw(p1, Mn1, CO1, 0)
mesh_draw(p2, Mn2, CO2, 0)
mesh_draw(p3, Mn3, CO3, 0)
axis equal

figure(3);
clf
draw_contour(CO1, 'g', 2, 1);
draw_contour(CO2, 'g', 2, 1);
draw_contour(CO3, 'g', 2, 1);
allpaths(p1, Mn1, CO1)
allpaths(p2, Mn2, CO2)
allpaths(p3, Mn3, CO3)

path1 = invert(toolpath_stack(p1, Mn1, CO1, 54));
pp1 = path_topoints(p1, Mn1, CO1, {}, path1);
path3 = toolpath_stack(p3, Mn3, CO3, 15);
pp3 = path_topoints(p3, Mn3, CO3, {}, path3);
path2 = toolpath_stack(p2, Mn2, CO2, 26);
pp2 = path_topoints(p2, Mn2, CO2, {}, path2);
pp = [pp1;pp3;pp2];
figure(4)
clf
draw_contour(C);
ppplot(p1, pp, 0.02, 0.1)

