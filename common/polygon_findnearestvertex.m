function ind = polygon_findnearestvertex(P, p)

[rows, cols] = size(P);

d = zeros(rows, 1);
for ind_V = 1:rows
    d(ind_V) = norm(p - P(ind_V, :));
end

ind = find(d == min(d));