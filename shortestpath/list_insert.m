function L = list_insert(L, value)

ind_F = list_find(L, value);

if ind_F
    return;
else
    L = [L;value];
end