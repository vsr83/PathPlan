P = [0.3 0.3;0.3 0.2;0.2 0.2;0.2 0.1;0.3 0.1;0.3 0;0.4 -0;0.4 0.1;0.5 0.1;0.5 -0;0.6 0;0.6 0.1;0.6 0.2;0.5 0.2;0.5 0.3;0.4 0.3;0.4 0.4;0.5 0.4;0.5 0.5;0.6 0.5;0.6 0.4;0.6 0.3;0.7 0.3;0.7 0.2;0.7 0.1;0.8 0.1;0.9 0.1;0.9 0.6;0.8 0.6;0.8 0.4;0.7 0.4;0.7 0.7;1 0.7;1 0.8;0.7 0.8;0.7 0.9;0.8 0.9;0.8 1;0.6 1;0.6 0.6;0.5 0.6;0.4 0.6;0.4 0.7;0.5 0.7;0.5 0.8;0.5 0.9;0.4 0.9;0.1 0.9;0.1 0.8;0.3 0.8;0.3 0.7;0.1 0.7;0 0.7;0 0.6;0.1 0.6;0.1 0.5;0 0.5;0 0.4;0.1 0.4;0.1 0.3];
C = {P};
figure(1); title 'K?sitelt?v? alue ja sen sisennys'
draw_contour(C, 'b', 2, 1)
d = 0.02;
CO = contour_offset(C, d/2);
draw_contour(CO, 'r:')


axis equal
inclination_angles(d, CO, 0.01)
p = d*[cos(0.99) sin(0.99)];
Mn = create_mesh_nodes(p, CO);
Mn = mesh_connect_nodes(p, Mn, CO);
figure(2); title 'Aluetta vastaava verkko';
mesh_draw(p, Mn, CO, 0);
draw_contour(C, 'r', 1);