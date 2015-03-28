% Esimerkki useiden reittien muodostuksesta luomalla reitti
% jokaisesta ääriarvosolmusta.

% TÄSSÄ ON OLEELLISTA HUOMIOIDA ETTÄ ANGLES_COST EI ANNA
% LUOTETTAVIA TULOKSIA EMMEKÄ TARKKAAN EDES OLE MÄÄRITELLEET
% MITÄ KÄÄNNÖKSELLÄ TARKOITAMME.

load esim2
d = 10;
CO = contour_offset(C, d);


p = d*[cos(0.948) sin(0.948)];
Mn = create_mesh_nodes(p, CO);
Mn = mesh_connect_nodes(p, Mn, CO);

maxnodes = find_nodes(Mn, struct('Type', 2), 1);
minnodes = find_nodes(Mn, struct('Type', 3), 1);

nodes = [maxnodes; minnodes];

CC = [];
pplist = {};

for ind_node= 1:length(nodes)
    figure(ind_node);

    startnode = nodes(ind_node);
    path = toolpath_stack(p, Mn, CO, startnode);
    pp = path_topoints(p, Mn, CO, {}, path);

    CC = [CC;startnode, path_length(pp), angles_cost(pp, 3*d, pi/2), ...
        angles_cost(pp, 3*d, pi)];
    pplist{ind_node} = pp;
    
    %% VISUALISOINTIA %%%
    clf
    axis equal
    draw_contour(C, 'g', 2, 1);
    ppplot(p, pp, 0.01, 0.1);

    s1 = sprintf('Kulku reuna/siksak/paluu\n $%.3f/%.3f/%.3f$', CC(ind_node, 2:4));
    s2 = sprintf('Kaannokset $>\\pi/2, >\\pi$ \n $%d, %d$', CC(ind_node, 5:6));
    
    xl = xlim;
    yl = ylim;
    text(xl(1), yl(2), s1, 'VerticalAlignment', 'Top','Interpreter','latex')
    text(xl(2), yl(2), s2, 'VerticalAlignment', 'Top','Interpreter','latex', ...
        'HorizontalAlignment', 'Right')
end
