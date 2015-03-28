function K = polyc_angles(P)

[n, tmp] = size(P);

K = zeros(1, n);

for i=1:n
   io = mod(i, n) + 1;

   r= P(io,:)-P(i,:);   
   R(i,:)= r / norm(r,2);
end

% Huom! Vektorien järjestyksellä on merkitystä, koska laskemme
% positiivisesti suunnistetun kappaleen sisäkulmaa.

for i=1:n
   i2 = mod(i, n) + 1;
   d = det([R(i,:);R(i2,:)]);

   if d < 0
       K(i2) = pi + acos(R(i,:)*R(i2,:)');
   else
       K(i2) = pi - acos(R(i,:)*R(i2,:)');
   end
end