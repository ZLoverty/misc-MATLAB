function plot_contour
main;
print(gcf, 'autosave.png', '-dpng', '-r300');
print(gcf, 'autosave.eps', '-depsc');
print(gcf, 'autosave.pdf', '-dpdf');
end

function main
% Parameters %%%%%%%%%%%%
filepath = 'order_1500.dat';
level_of_smoothing = 10;
line_thickness = 1;
levels = [.3 .6 .9];
%%%%%%%%%%%%%%%%%%%%%%%%%

fid = fopen(filepath);
A = fscanf(fid, '%f', [7 inf]);
X = A(1, :);
Y = A(2, :);
OP = A(6, :);
X = reshape(X, [65, 65]);
Y = reshape(Y, [65, 65]);
OP = reshape(OP, [65, 65]);



[X, Y, OP] = smooth_surface(X, Y, OP, level_of_smoothing);


[C, cmap] = rainbowColorRGB(OP);
surface(X, Y, zeros(size(X)), C, 'EdgeColor', 'none');
hold on
contour(X, Y, OP, levels, 'Color', 'k', 'LineWidth', line_thickness);

colormap(cmap);
c = colorbar;
c.Ticks = 0:0.1:1;
for i = 1: numel(c.Ticks)
    c.TickLabels{i} = sprintf('%.1f', c.Ticks(i)*2-1);
end

hold off
axis equal
axis off
end

function [corgb, cmap] = rainbowColorRGB(data)
HSV_max = .7;
direction = -1;
if direction > 0
    cmapHSV = [abs(linspace(0, HSV_max, 64)); ones(2, 64)]';
else
    cmapHSV = [abs(0.7-linspace(0, HSV_max, 64)); ones(2, 64)]';
end
cmap = hsv2rgb(cmapHSV);
[row, col] = size(data);
data(data>1) = 1;
data(data<0) = 0;
cohsv = ones(row, col, 3);
cohsv(:, :, 1) = (1-data)*HSV_max;
corgb = zeros(row, col, 3);
for i = 1: row
    for j = 1: col
        corgb(i, j, :) = hsv2rgb(cohsv(i, j, :));
    end
end
end

function [X, Y, Z] = smooth_surface(x, y, z, level_of_smoothing)
if ~isequal(size(x), size(y)) || ~isequal(size(x), size(z)) || ~isequal(size(z), size(y))    
    error('Dimensions must be same');
    return;
end
nX = level_of_smoothing * size(x, 1);
nY = level_of_smoothing * size(x, 2);
X = linspace(min(min(x)), max(max(x)), nX);
Y = linspace(min(min(y)), max(max(y)), nY);
[X, Y] = meshgrid(X, Y);
Z = interp2(x, y, z, X, Y, 'linear');
end