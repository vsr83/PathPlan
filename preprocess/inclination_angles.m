function [NS, incl, p] = inclination_angles(l, C, d)

nPoly = length(C);
ns = 0;

mina = [inf 0];

for a = 0:d:pi
    p = l * [cos(a) sin(a)];
    ns = 0;
    for ind_P = 1:nPoly
        Poly = C{ind_P};
        [nSeg, tmp] = size(Poly);
    
        for ind_S = 1:nSeg
            ind_next = mod(ind_S, nSeg) + 1;
            [n, tmp2] = segment_coords(p, Poly(ind_S, :), Poly(ind_next, :));
            ns = ns + length(n);
        end
    end
    if ns < mina(1)
        mina = [ns a];
    end    
end

NS = mina(1);
incl = mina(2);
p = l*[cos(incl) sin(incl)];