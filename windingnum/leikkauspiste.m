% Hakee kahden janan m‰‰r‰‰m‰n suoran leikkauspisteen. 
function [x, y, jl, err] = leikkauspiste(x0, y0, x1, y1)

jl= 0; err = 0; x = 0; y= 0;

% Muunnetaan suorat ensin implisiittiseen muotoon Ax+By+C=0:
A = y1 - y0;
B = x0 - x1;
C = y0.*x1 - x0.*y1;

xn = (B(2)*A(1) - A(2)*B(1));
yn = (A(2)*B(1) - B(2)*A(1));

% Jos suorat ovat samansuuntaisia koordinaatin nimitt‰j‰ saa arvon nolla
% ja voimme ajautua jakamaan osoittajan nollalla.
if xn ~= 0 & yn ~= 0
  x = (C(2)*B(1) - B(2)*C(1)) / xn;
  y = (C(2)*A(1) - C(1)*A(2)) / yn;
else
  err = 1;
end
