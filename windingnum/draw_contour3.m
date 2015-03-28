function draw_contour3(C, style, width, z)

if nargin < 3
    width = 2;
end
if nargin == 1
    style = 'b'
end

%clf
hold on
for ind_C = 1:length(C)
    P = C{ind_C};
    X = [P(:, 1);P(1, 1)];
    Y = [P(:, 2);P(1, 2)];
    Z = ones(length(X), 1)*z;
    
    plot3(X, Y, Z, style, 'LineWidth', width);
end