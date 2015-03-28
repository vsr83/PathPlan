% M‰‰ritt‰‰ kaikki reitit C:n ‰‰riarvosolmuista ja laskee jokaisen
% pituuden.

function allpaths(p, Mn, C)

nodes = [find_nodes(Mn, struct('Type', 2), 1); ...
         find_nodes(Mn, struct('Type', 3), 1)];
nnodes = length(nodes);


draw_contour(C, 'g:');

hold on
nfig = gcf;

for ind_node = 1:nnodes
%    figure(ind_node+1);

    figure(4)
    path = toolpath_stack(p, Mn, C, nodes(ind_node));
    pp = path_topoints(p, Mn, C, {}, path);
%    clf
%    draw_contour(C, 'g:');    
%    ppplot(p, pp, 0, 0.1);
%    axis equal
    
    len = sum(path_length(pp));
    lens = sprintf('\n%.5f\n %.0f, %d', len, ...
        angles_cost(pp, 3*norm(p), pi/2), nodes(ind_node));
%    title(lens);
    
    p_begin = pp(1, 1:2);
    p_end   = pp(length(pp), 1:2);

    figure(nfig)
    plot([p_begin(1);p_end(1)], [p_begin(2);p_end(2)], 'k');
    
    plot(p_begin(1), p_begin(2), 'rs');
    plot(p_end(1),   p_end(2),   'rs');

    ang = arctan(p_end-p_begin)*360/(2*pi);
    text(0.5*(p_begin(1)+p_end(1)), 0.5*(p_begin(2)+p_end(2)), ...
        lens, 'Rotation', ang+180, 'FontSize', 8);
end