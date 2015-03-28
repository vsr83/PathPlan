P = [0 0;2 0;2 2;1 4;0 2];
H1 = [0.5 0.5; 0.5 1; 1.5 1; 1.5 0.5];
H2 = [0.25 2;0.75 2.5;0.75 2];
H3 = invert([2-0.25 2;2-0.75 2.5;2-0.75 2]);
C = {P, H1, H2, H3};

p = 0.1*[1 3];
Mn = create_mesh_nodes(p, C);
Mn = mesh_connect_nodes(p, Mn, C);

path = toolpath_stack(p, Mn, C, 9);
pp = path_topoints(p, Mn, C, {}, path);