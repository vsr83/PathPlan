% SISAKULMAT Laskee kulmat murtoviivan janojen v‰lill‰ sis‰normaalien 
%            m‰‰r‰‰m‰lt‰ puolelta.
% K = SISAKULMAT(PC)
%
%   PC on murtoviiva nx2 matriisina, jonka rivit vastaavat viivan
%   yksitt‰isi‰ k‰rki‰.
%
%   Funktio palauttaa nx1 vektorin sis‰kulmia.
%   Ensimm‰inen kulmista vektorissa on kulma viimeisest‰ pisteest‰
%   ensimm‰iseen ja ensimm‰isen toiseen vedetyn janan v‰lill‰.

function K = sisakulmat(P)
[n, tmp] = size(P);

K = zeros(1, n);

for i=1:n
   io = mod(i, n) + 1;

   r= P(io,:)-P(i,:);   
   R(i,:)= r / norm(r,2);
end

% Huom! Vektorien j‰rjestyksell‰ on merkityst‰, koska laskemme
% positiivisesti suunnistetun kappaleen sis‰kulmaa.

for i=1:n
   i2 = mod(i, n) + 1;
   d = det([R(i,:);R(i2,:)]);

   if d < 0
       K(i2) = pi + acos(R(i,:)*R(i2,:)');
   else
       K(i2) = pi - acos(R(i,:)*R(i2,:)');
   end
end