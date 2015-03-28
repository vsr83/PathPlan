% HUOM!!! T�M� ALGORITMI EI OLE LUOTETTAVA! ILMEISESTI KOODI
% SAATTAA LASKEA K��NN�KSET MATKALLA len USEAAN KERTAAN 
% JOKAISESSA K�RJESS� MIK�LI EDELLISELL� MATKALLA len ON YLITETTY
% KOKONAISKULMA angle.

% Haemme kokonaiskulman angle matkalla len ylitt�vien k��nn�sten
% m��r�n.

function c = angles_cost(pp, len, angle)

c = 0;
pa = path_angles(pp);
[rows, cols] = size(pa);

list = [];
for ind_P = 1:rows
    list = [list;pa(ind_P, :)];
        
    if sum(list(:, 1)) > angle
        c = c + 1;
        list = [];
    end
    
    [lr, lc] = size(list);
    if lr > 1 
        while sum(list(2:lr, 2)) > len
            list(1, :) = [];
            [lr, lc] = size(list);
        end
    end
end