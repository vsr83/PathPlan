% PATH_DRAW piirt‰‰ reitin verkossa
%   PATH_DRAW(p, Mn, P, pause)
%
%   p, Mn on m‰‰ritelty kuten funktiossa MESH_CONNECT_NODES.
%
%   P on vektori indeksej‰, jotka m‰‰r‰‰v‰t reitin Mn:n kuvaamassa
%   verkossa
%
%   pause = 1 tai 0 riippuen pyydet‰‰nkˆ k‰ytt‰j‰lt‰ syˆtett‰ jokaisen
%   piiretyn janan v‰lill‰.

function path_draw(p, Mn, P, pause)

l = norm(p, 2);
pu = p/l;
n = inner_normal(p)*l;

Points = [];

for ind_P = 1:length(P)
    Point = Mn{P(ind_P, 1)}.Point * [n;p];
    Points = [Points;Point P(ind_P, 2)];
end

%figure(2)

for i= 1:length(Points)-1
    x0 = Points(i, 1);
    x1 = Points(i+1, 1);
    y0 = Points(i, 2);
    y1 = Points(i+1, 2);
    
    if Points(i, 3)
        plot([x0;x1], [y0;y1], 'r:', 'LineWidth', 2);
        if pause
            input ''
        end
    else
        plot([x0;x1], [y0;y1], 'r', 'LineWidth', 2);
    end
        
    r = [x1-x0 y1-y0];
    ru = -r/norm(r, 2);
    nu = inner_normal(ru);

    s = sprintf('  %d', i);
    %text('string', s, 'interpreter', 'latex', 'pos', [x0+x1 y0+y1]/2, 'fontsize', 8);
    
    plot(0.5*(x0+x1) + [(ru(1)- 0.25*nu(1))*l/2; 0; (ru(1) + 0.25*nu(1))*l/2], ...
         0.5*(y0+y1) + [(ru(2)- 0.25*nu(2))*l/2; 0; (ru(2) + 0.25*nu(2))*l/2], ...
         'r', 'LineWidth', 2);
end
%plot(Points(:, 1), Points(:, 2), 'r', 'LineWidth', 2);

%figure(1)