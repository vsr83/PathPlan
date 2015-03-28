% POLYC_LENGTH Laskee murtoviivan pituuden
% l = POLYC_LENGTH(PC)
%
% PC = nx2 matriisi murtoviivan m‰‰ritt‰vi‰ pisteit‰.
% Funktio palauttaa murtoviivan euklidisen pituuden l.

function l = polyc_length(P)

[rows, cols] = size(P);
l = 0;

for ind_P= 2:rows
    l = l + norm(P(ind_P, :)-P(ind_P-1, :), 2);
end