function a = path_angles(pp)

a= [];

[rows, cols] = size(pp);

for ind = 2:rows-1
    Rprev = pp(ind, 1:2) - pp(ind-1, 1:2);
    Rnext = pp(ind+1, 1:2) - pp(ind, 1:2);
    
    n = norm(Rprev, 2) * norm(Rnext, 2);
    if n ~= 0
        % Numeeriset virheet saattavat tehdä kulmasta ei-reaalisen.
        angle = real(acos(Rprev* Rnext' / n));
        a = [a; angle norm(Rprev, 2)];
    end
end