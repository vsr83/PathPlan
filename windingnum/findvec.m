function ind = findvec(S, v)

ind = [];

[rows, cols] = size(S);

for ind_r = 1:rows
    if isequal(S(ind_r, :), v)
        ind = [ind; ind_r];
    end
end