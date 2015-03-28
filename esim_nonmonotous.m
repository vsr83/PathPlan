P = [0.1 0.5;0.1 0.1;0.5 0.1;0.5 0.4;0.45 0.35;0.4 0.4;0.35 0.35;0.3 0.4;0.3 0.5];
d = 0.075;
C = {P};
p = d*[cos(0.1) sin(0.1)];

clf
Mn = create_mesh_nodes(p, C);
Mn = mesh_connect_nodes(p, Mn, C);
draw_contour(C, 'b', 1);
mesh_draw(p, Mn, C, 0);