function l = graph_loop(Nodes, Edges, src, dst)

% src ja dst ovat aloitusjanan alku- ja loppusolmut. 
% Kyseinen jana m‰‰r‰‰ kiertosuunnan ja sen viritt‰m‰‰n suoraan
% n‰hden k‰‰nnymmen aina mahdollisimman vasemmalle.

[nnodes, tmp] = size(Nodes);


l = [src];
curnode = dst;

while ~max(find(l == curnode))
    N = find(Edges(curnode, :));

    seg_startp = Nodes(curnode, 2:3);    
    for ind_N = 1:4
        seg_endp = Nodes(N(ind_N), 2:3);
        deg(ind_N) = mod(arctan(seg_startp - seg_endp), 2*pi);
    end
end