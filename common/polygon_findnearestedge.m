function ind = polygon_findnearestedge(P, p)

[rows, cols] = size(P);

d = zeros(rows, 1);
for ind_V = 1:rows
    ind_next = mod(ind_V, rows) + 1;
    
    r = P(ind_next, :) - P(ind_V, :);
    ru = r / norm(r);
    n = inner_normal(r);
    
    
    p = dot(p - P(ind_V, :), ru);
    
    d(ind_V, 2) = p;
    
    if p >= 0 && p < norm(r)
        d(ind_V) = dot(p - P(ind_V, :), n);
    else
        d(ind_V) = min(norm(p-P(ind_V, :)), norm(p-P(ind_next, :)));
    end
end

d
ind = find(d == min(d));