% INNER_NORMAL(p) Muodostaa sisäyksikkönormaalin vektorille.
% n = INNER_NORMAL(p)
% 
% p = vektori muotoa [x y].
% Funktio palauttaa yksikkövektorin n, joka saadaan kääntämällä p:tä
% 90 astetta positiiviseen kiertosuuntaan(vastapäivään) ja jakamalla
% normilla.

function n = inner_normal(t)

t = t / norm(t, 2);
n = t * [0 1;-1 0];