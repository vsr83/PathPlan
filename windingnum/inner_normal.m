% Muodostaa sisä(yksikkö)normaalin positiivisesti suunnistetulle
% tangenttivektorille.
% t (1x2) -> n (1x2)

function n = inner_normal(t)

t = t / norm(t, 2);
n = t * [0 1;-1 0];