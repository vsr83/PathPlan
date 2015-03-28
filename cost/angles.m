function c = angles(pp, max_angle, max_dist)

A = path_angles(pp);
angles= A(:, 1);
dist = A(:, 2);
[rows, tmp] = size(angles);

state = 0;
d = 0;
c = 0;

for ind_V=1:rows
    % Haetaan ne kärjet, jotka ovat alle max_dist päässä takanapäin,
    % kärkien kulmat ja niitä edeltäneiden janojen pituudet. 
    ds = 0;
    D = ones(rows, 1)*max_dist*2;
    for ind_E = ind_V:-1:1
        ds = ds + dist(ind_E);
        D(ind_E) = ds;
    end
    D(ind_V) = 0;
                D'
  
    if state > 0 && D(state+1) > max_dist
        c = c + 1;
        state = 0;
        
        disp 'OFF'
        disp([ind_V, 0, state, c])

        for ind_t = 1:ind_V-1
            angles(ind_t) = 0;
        end
    end
        
    % Ne kärjet jotka ovat alle max_dist päässä takanapäin.

    %EDELLISEEN ETÄISYYS EI NÄY!!!!
    ind_A = find(D < max_dist)
    % Kokonaiskulma kyseisiä kärkiä vastaavilla käännöksillä.
    angle = sum(angles(ind_A));
    
    angle
    if state == 0 && angle > max_angle
        state = ind_V;
        disp 'ON'
        disp([ind_V, angle, state, c])
        for ind_t = 1:ind_V
            angles(ind_t) = 0;
        end
    end
end
if state > 0
    c = c + 1;
end