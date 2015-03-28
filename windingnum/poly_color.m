% Pikaisesti v‰‰nnetty testikoodi, joka v‰ritt‰‰ positiivisesti
% suunnistetut polygonin sis‰osan pisteitt‰in tiheydell‰ t.

function poly_color(P, t)

clf
hold on

%polyc_draw(P, 0.05);

min_x = min(P(:, 1));
max_x = max(P(:, 1));
min_y = min(P(:, 2));
max_y = max(P(:, 2));

for x = min_x:t:max_x
    for y = min_y:t:max_y
        w = polygon_wn(P, [x y]);
        w = fix(w + 0.5);
        if w == 1
            plot(x, y, 'r');
        end
    end
end