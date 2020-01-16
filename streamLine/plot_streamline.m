function plot_streamline
main;
print(gcf, 'autosave.png', '-dpng', '-r300');
print(gcf, 'autosave.eps', '-depsc');
print(gcf, 'autosave.pdf', '-dpdf');
end

function main
% Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%
filepath = 'pivdata_1501_1530\PIVlab_0001.txt';
datasetpath = 'pivdata_1501_1530\';
xlen = 65;
ylen = 65;
streamline_width = 0.5;
vorticity_smoothing_level = 10;
line_density = 5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[X, Y, U, V, vor] = read_data(filepath, xlen, ylen);
% quiver(X, Y, U, V);
minn = -0.06;
maxx = 0.06;
[minn, maxx] = get_range(datasetpath);
vor = (vor - minn) / (maxx-minn);
[Xs, Ys, vors] = smooth_surface(X, Y, vor, vorticity_smoothing_level);
[cs, cmap] = rainbowColorRGB(vors);
surface(Xs, Ys, zeros(size(Xs)), cs, 'EdgeColor', 'none', 'FaceAlpha', 1);
h = streamslice(X, Y, U, V, line_density);
set(h, 'Color', 'k', 'LineWidth', streamline_width);
colormap(cmap);
c = colorbar;
c.Ticks = 0:0.1:1;
for i = 1: numel(c.Ticks)
    c.TickLabels{i} = sprintf('%.3f', c.Ticks(i)*(maxx-minn)+minn);
end
axis tight;
axis equal;
axis off;
end

function [minn, maxx] = get_range(filepath)
files = dirrec(filepath, '.txt');
xlen = 65;
ylen = 65;
maxx = 0;
minn = 0;
for i = 1: numel(files)
    [X, Y, U, V, vorticity] = read_data(files{i}, xlen, ylen);
    maxx = max(max(max(vorticity)), maxx);
    minn = min(min(min(vorticity)), minn);
end
maxx = maxx/5;
minn = minn/5;
end

function [X, Y, U, V, vorticity] = read_data(filepath, xlen, ylen)
fid = fopen(filepath);
A = fscanf(fid, '%f', [11 inf]);
X = A(1, :);
Y = A(2, :);
U = A(3, :);
V = A(4, :);
vorticity = A(5, :);
X = reshape(X, xlen, ylen);
Y = reshape(Y, xlen, ylen);
U = reshape(U, xlen, ylen);
V = reshape(V, xlen, ylen);
vorticity = reshape(vorticity, xlen, ylen);
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

function [corgb, cmap] = rainbowColorRGB(data)
%Data is one dimensional array
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