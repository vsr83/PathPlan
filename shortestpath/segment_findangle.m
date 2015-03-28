function angle = segment_findangle(Poly, seg)

[rows, cols] = size(Poly);
nextSeg = mod(seg, rows) + 1;
            
R = unit(Poly(nextSeg, :) - Poly(seg, :));
angle = arctan(R(1), R(2));
