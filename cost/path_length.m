function l = path_length(P)

[rows, cols] = size(P);
l = [0 0 0];

for ind_P = 2:rows
    type = P(ind_P, 3);
    l(type) = l(type) + norm(P(ind_P, 1:2)- P(ind_P - 1, 1:2), 2);
end