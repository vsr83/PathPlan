function polyc_draw(P, as, lab, color)

if nargin < 4
    color = 'b';
end

%clf
hold on

[rows, cols] = size(P);

for ind_P = 1:rows
    ind_next = mod(ind_P, rows) + 1;
    
    r = P(ind_next, :) - P(ind_P, :);
    ru = -r/norm(r, 2);
    nu = inner_normal(ru);
l = as;
    if norm(r, 2) > l/2
      plot(0.5 * (P(ind_P, 1) + P(ind_next, 1)) + ...
           [(ru(1)- 2*as*nu(1))*l/2; 0; (ru(1) + 2*as*nu(1))*l/2], ...
           0.5 * (P(ind_P, 2) + P(ind_next, 2)) + ...
           [(ru(2)- 2*as*nu(2))*l/2; 0; (ru(2) + 2*as*nu(2))*l/2], ...
           color , 'LineWidth', 2);
    end
    plot([P(ind_P, 1);P(ind_next, 1)], [P(ind_P, 2);P(ind_next, 2)], ...
         color, 'LineWidth', 2);
    plot(P(ind_P, 1), P(ind_P, 2), 'bo', 'MarkerFaceColor', color);
end

if lab == 1
    for ind_N = 1:rows
        s = sprintf(' %d', ind_N);
        text(P(ind_N, 1), P(ind_N, 2), s);
    end
end