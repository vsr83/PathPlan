% UNIT palauttaa vektoria vastaavan yksikk�vektorin.

function u = unit(v)
u = v/ norm(v, 2);