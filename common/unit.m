% UNIT palauttaa vektoria vastaavan yksikkövektorin.

function u = unit(v)
u = v/ norm(v, 2);