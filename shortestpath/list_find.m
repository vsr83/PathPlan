function ind_F = list_find(L, value)

[rows, cols] = size(L);

ind_F = false;
if rows == 0
    return;
end

for ind_L = 1:rows
    if isequal(L(ind_L, :), value)
        ind_F = ind_L;
        return;
    end
end
