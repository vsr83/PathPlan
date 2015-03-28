function P=invert(P)

Pnew = [];
for ind_P = 1:length(P)
    Pnew(ind_P,:) = P(length(P)+1-ind_P, :);
end
P = Pnew;
