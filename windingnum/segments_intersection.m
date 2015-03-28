function [x, y, jl, err] = segments_intersection(p1, p2, r1, r2)

[x, y, jl, err] = leikkauspiste([p1(1);r1(1)], [p1(2);r1(2)], ...
    [p2(1);r2(1)], [p2(2);r2(2)]);