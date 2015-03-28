% Ruohonen - Vektorikentät(http://math.tut.fi/~ruohonen/VK.pdf) s. 18.

function a = arctan(x, y)

if nargin == 1
    y = x(2);
    x = x(1);
end

if x > 0 && y >= 0
    a = atan(y / x);
elseif x > 0 && y < 0
    a = 2*pi + atan(y / x);
elseif x < 0
    a = pi + atan(y / x);
elseif x== 0 && y > 0
    a = (pi/2);
elseif x== 0 && y < 0
    a = 3*pi/2;
else
    %error 'Vektorin pituus nolla!';
    a = -1;
end