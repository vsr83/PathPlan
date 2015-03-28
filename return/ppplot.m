% PPPLOT piirtää PATH_TOPOINTS:n palauttaman reitin.
%   PPPLOT(p, points, delay, as)
%
%   p on verkon inklinaatio kuten muuallakin.
%   
%   points on PATH_TOPOINTS:n palauttama matriisi.
%
%   delay määrää kuinka monta sekuntia jokaisen janan piirtämisen
%   välillä pidetään taukoa.
%
%   as määrää nuolien leveyden.

function ppplot(p, points, delay, as)

l = norm(p, 2);
[rows, cols] = size(points);

%text('string', 'Alku', 'interpreter', 'latex', 'pos', points(1, :), ...
%   'fontsize', 12);
%text('string', 'Loppu', 'interpreter', 'latex', 'pos', ...
%     points(length(points), :), 'fontsize', 12);

startp = points(1, 1:2);
endp = points(length(points), 1:2);
plot(startp(1), startp(2), 'sm', 'MarkerSize', 15);
plot(endp(1), endp(2), 'sm', 'MarkerSize', 15);

for ind_p = 1:rows-1
    switch points(ind_p+1, 3)
        case 1
            color = 'k';
        case 2
            color = 'r';
        case 3
            color = 'b';
    end
    
    plot([points(ind_p, 1);points(ind_p+1, 1)], ...
         [points(ind_p, 2);points(ind_p+1, 2)], color, 'LineWidth', 2);
    pause(delay);

    r = points(ind_p+1, 1:2) - points(ind_p, 1:2);
    ru = -r/norm(r, 2);
    nu = inner_normal(ru);
    %s = sprintf('  %d', i);
    %text('string', s, 'interpreter', 'latex', 'pos', [x0+x1 y0+y1]/2,
    %'fontsize', 8);
    
    if norm(r, 2) > l/2
       plot(0.5*(points(ind_p, 1) + points(ind_p+1, 1)) + ...
                 [(ru(1)- as*nu(1))*l/2; 0; (ru(1) + as*nu(1))*l/2], ...
             0.5*(points(ind_p, 2) + points(ind_p+1, 2)) + ...
               [(ru(2)- as*nu(2))*l/2; 0; (ru(2) + as*nu(2))*l/2], ...
             color, 'LineWidth', 2);
    end
end

