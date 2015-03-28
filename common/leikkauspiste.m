% LEIKKAUSPISTE(x0, y0, x1, y1) Hakee kahden janan leikkauspisteen.
% [x y] = LEIKKAUSPISTE(x0, y0, x1, y1)
%
% x0, y0 kahden janan alkupisteiden x- ja y-koordinaatit.
% x1, y1 kahden janan loppupisteiden x- ja y-koordinaatit.
% x0, y0, x1, y1 ovat 2x1 tai 1x2 matriiseja.
%
% Funktio palauttaa janojen leikkauspisteen [x y].

% Hakee kahden janan määräämän suoran leikkauspisteen. 
function [x, y, jl, err] = leikkauspiste(x0, y0, x1, y1)

jl= 0; err = 0; x = 0; y= 0;

% Muunnetaan suorat ensin implisiittiseen muotoon Ax+By+C=0:
A = y1 - y0;
B = x0 - x1;
C = y0.*x1 - x0.*y1;

xn = (B(2)*A(1) - A(2)*B(1));
yn = (A(2)*B(1) - B(2)*A(1));

% Jos suorat ovat samansuuntaisia koordinaatin nimittäjä saa arvon nolla
% ja voimme ajautua jakamaan osoittajan nollalla.
if xn ~= 0 & yn ~= 0
  x = (C(2)*B(1) - B(2)*C(1)) / xn;
  y = (C(2)*A(1) - C(1)*A(2)) / yn;
else
  err = 1;
%  error 'foo'
end

% Ilmeisesti tässä voi tulla numeerisia virheitä. En ymmärrä liukuluku-
% aritmetiikan kummallisuuksia, joten seuraavassa voi olla virheitä.
tol = eps;
%{
[u, v] = segment_contains_point([x0(1) y0(1)], [x1(1) y1(1)], [x y]);
[u2, v2] = segment_contains_point([x0(2) y0(2)], [x1(2) y1(2)], [x y]);

jl = true; %% v toleranssi
if -u > tol || u-1 > tol || 1000*tol < v
    jl = false;
end
if -u2 > tol || u2-1 > tol || 1000*tol < v2
    jl = false;
end
%}