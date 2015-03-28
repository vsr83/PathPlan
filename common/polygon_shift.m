function PS = polygon_shift(P, n)

[rows, cols] = size(P);

for ind_V = 1:rows
    ind = mod(ind_V + n - 1, rows) + 1;
    PS(ind, :) = P(ind_V, :);
end
