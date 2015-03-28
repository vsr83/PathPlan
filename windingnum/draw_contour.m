function draw_contour(C, style, width, fillc)

if nargin < 3
    width = 2;
end
if nargin < 4
    fillc = false;
end
if nargin == 1
    style = 'b'
end

%clf
hold on
for ind_C = 1:length(C)
    P = C{ind_C};
    plot([P(:, 1);P(1, 1)], [P(:, 2);P(1, 2)], style, 'LineWidth', width);
    if fillc && ind_C > 1
        fill([P(:, 1);P(1, 1)], [P(:, 2);P(1, 2)], 'c');
    end
end