% INNER_NORMAL(p) Muodostaa sis�yksikk�normaalin vektorille.
% n = INNER_NORMAL(p)
% 
% p = vektori muotoa [x y].
% Funktio palauttaa yksikk�vektorin n, joka saadaan k��nt�m�ll� p:t�
% 90 astetta positiiviseen kiertosuuntaan(vastap�iv��n) ja jakamalla
% normilla.

function n = inner_normal(t)

t = t / norm(t, 2);
n = t * [0 1;-1 0];