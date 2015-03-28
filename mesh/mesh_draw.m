% MESH_DRAW Piirtää havainnollistavan kuvan verkosta.
%
% MESH_DRAW(p, MeshNodes, C, draw_text)
% p, MeshNodes, C määritelty samoin kuin muuallakin
% draw_text = 0 tai 1 riippuen numeroidaanko solmut graafisesti.

function mesh_draw(p, MeshNodes, C, draw_text)

%clf
hold on
axis equal

n= inner_normal(p) * norm(p, 2);

[min_o max_o min_p max_p] = mesh_size(MeshNodes);
min_o = ceil(min_o);
max_o = floor(max_o);

for ind_ml=min_o-1:max_o+1
    r1 = n * ind_ml + p * (min_p-1);
    r2 = n * ind_ml + p * (max_p+1);
    plot([r1(1);r2(1)], [r1(2);r2(2)], 'g:');

    s = sprintf('%d.', ind_ml);
    rt = n * ind_ml + p * (min_p-2);
    text('string', s, 'interpreter', 'latex', 'pos', rt, 'fontsize', 8);
end

for ind_C=1:length(C)
    Poly = C{ind_C};
    if ind_C > 1
        fill([Poly(:, 1);Poly(1, 1)], [Poly(:, 2);Poly(1, 2)], 'g');
    end
    plot([Poly(:, 1);Poly(1, 1)], [Poly(:, 2);Poly(1, 2)], 'b', 'LineWidth', 2);
end

for ind_Mn = 1:length(MeshNodes)
    MeshNode = MeshNodes{ind_Mn};
    
    Point = MeshNode.Point;
    r = n * Point(1) + p * Point(2);
    
    switch MeshNode.Type
        case 1
            plot(r(1), r(2), 'ro');
        case 2
            plot(r(1), r(2), 'r^', 'MarkerSize', 10);
        case 3
            plot(r(1), r(2), 'rv', 'MarkerSize', 10);
    end
    
    if MeshNode.Right && MeshNode.Type == 1
        r1 = MeshNode.Point*[n' p'];
        r2 = MeshNodes{MeshNode.Right}.Point*[n' p'];
        if MeshNodes{MeshNode.Right}.Type == 1
            plot([r1(:, 1);r2(:, 1)], [r1(:, 2); r2(:, 2)], 'g', 'LineWidth', 2);
        end
    end
    if MeshNode.Down
        r1 = MeshNode.Point*[n' p'];
        r2 = MeshNodes{MeshNode.Down}.Point*[n' p'];
        
        %plot([r1(:, 1);r2(:, 1)], [r1(:, 2); r2(:, 2)], 'r:', 'LineWidth', 2);
    end
end

for ind_Mn = 1:length(MeshNodes)
    MeshNode = MeshNodes{ind_Mn};

    Point = MeshNode.Point;
    r = n * Point(1) + p * Point(2);
    
    if MeshNode.Type ~= 1
        s = sprintf('    $%d_{(', ind_Mn);
        if MeshNode.Right
            sn = sprintf('R%d ', MeshNode.Right); s = [s sn];        
        end
        if MeshNode.Up
            sn = sprintf('U%d ', MeshNode.Up); s = [s sn];        
        end
        if MeshNode.Left
            sn = sprintf('L%d ', MeshNode.Left); s = [s sn];        
        end
        if MeshNode.Down
            sn = sprintf('D%d ', MeshNode.Down); s = [s sn];        
        end
    s= [s ')}$'];
    else
        s = sprintf('    %d', ind_Mn);
    end
    if draw_text
        text('string', s, 'interpreter', 'latex', 'pos', r, 'fontsize', 8);
    end
end