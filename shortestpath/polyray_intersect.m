% Hakee p-alkuisen angle-suuntaisen puolisuoran leikkaamat
% C:n janat sekä leikkauspisteiden etäisyydet.

function S = polyray_intersect(C, p, angle)

S= [];

%figure(2);
%clf
%hold on

rotMatrix = [cos(-angle) -sin(-angle);sin(-angle) cos(-angle)];
for ind_P = 1:length(C)
    Poly = C{ind_P};
    [rows, cols] = size(Poly);
    
    for ind_S = 1:rows
        Poly(ind_S, :) = (Poly(ind_S, :) - p) * rotMatrix';
    end
    C{ind_P} = Poly;

%    plot(Poly(:, 1), Poly(:, 2));
end

for ind_P = 1:length(C)
    Poly = C{ind_P};
    [rows, cols] = size(Poly);

    angle_prev = arctan(Poly(rows,1), Poly(rows, 2));
    for ind_S = 1:rows
        angle = arctan(Poly(ind_S, 1), Poly(ind_S, 2));
        ind_prev = mod(ind_S - 2, rows) + 1;
        
%        if ind_P == 2
%            [angle angle_prev]
%        end
        
        if abs(angle_prev - angle) > pi
            [x, y] = segments_intersection(Poly(ind_prev, :), Poly(ind_S, :), ...
                                           [0 0], [4000, 0]);
            S = [S;ind_P ind_S norm([x y], 2)];
        end
        angle_prev = angle;
    end
end
