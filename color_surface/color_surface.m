function color_surface
% ene_and_OP
% OP_as_color
% fit_color
% degree = linspace(0, 1, 64);
% degree = rand(4,4);
% corgb = idl_rainbow(degree);
% colormap(corgb);
% colorbar
end

function [corgb, cmap] = idl_rainbow(data)
load('rgbMap.mat');
corgb = zeros(size(data, 1), size(data, 2), 3);
for i = 1: size(data, 1)
    for j = 1: size(data, 2)
        [M, I] = min(abs(rgbMap(:, 1)-data(i, j)));
        corgb(i,j,:) = rgbMap(I, 2:4)/255;
    end
end
cmap_d = linspace(0, 1, 64);
[M, I] = min(abs(rgbMap(:, 1)-cmap_d));
cmap = rgbMap(I, 2:4)/255;
end

function ene_and_OP
filepath='';
filen1=[filepath 'test_data\surface60x10fps80n0_100pg0r_30perl_10umt301.dat'];

E = 227.6764; % normalization factor for energy data from t301
nx = 19;
ny = 29;
fileID = fopen(filen1,'r');
formatSpec = '%f';
sizeA = [5,Inf];
A = fscanf(fileID,formatSpec, sizeA);
fclose(fileID);
xx = reshape(A(1, :), [ny, nx]);
yy = reshape(A(2, :),[ny, nx]);
energy = reshape(A(4, :), [ny, nx]);
OP = reshape(A(3, :), [ny, nx]);
x = xx(2: ny-1, 2: nx-1);
y = yy(2: ny-1, 2: nx-1);
ene = energy(2: ny-1, 2: nx-1);
OP = OP(2: ny-1, 2: nx-1);
color = idl_rainbow(OP);
[x_s, y_s, ene_s] = smooth_surface(x, y, ene, 60);
[x_s, y_s, OP_s] = smooth_surface(x, y, OP, 60);
ene_s = imgaussfilt(ene_s, 2);
ene_s_norm = ene_s / E;
OP_s_norm = (OP_s + 1) / 2;
[color_ene, cmap_ene] = idl_rainbow(ene_s_norm);
[color_OP, cmap_OP] = idl_rainbow(OP_s_norm);

% Plot
figure(2);

subplot(1,2,1);
colormap(cmap_ene);
surf(x_s,y_s,ene_s, color_ene, 'EdgeColor','none', 'FaceColor', 'interp',...
    'FaceAlpha', 1, 'AmbientStrength', .1, 'DiffuseStrength', .1);
axis off
c1 = colorbar;

subplot(1,2,2);
colormap(cmap_OP);
surf(x_s,y_s,OP_s, color_OP, 'EdgeColor','none', 'FaceColor', 'interp',...
    'FaceAlpha', 1, 'AmbientStrength', .1, 'DiffuseStrength', .1);
view(-32.700, 42.0000);
axis off
c2 = colorbar;
end

function OP_as_color
filepath='test_data/';
filen1=[filepath 'orderen_60x10fps80n0_100pg0r_30perl_10umt301.dat'];
nx=19;
ny=29;
fileID=fopen(filen1,'r');
formatSpec='%f';
sizeA=[5,Inf];
A=fscanf(fileID,formatSpec, sizeA);
fclose(fileID);
xx=reshape(A(1,:),[ny,nx]);
yy=reshape(A(2,:),[ny,nx]);
energy=reshape(A(3,:),[ny,nx]);
OP=reshape(A(4,:),[ny,nx]);
x = xx(2:ny-1,2:nx-1);
y = yy(2:ny-1,2:nx-1);
ene = energy(2:ny-1,2:nx-1);
OP = OP(2:ny-1,2:nx-1);
color = rainbowColorRGB(OP);
[x_s, y_s, ene_s] = smooth_surface(x, y, ene, 4);
[x_s, y_s, OP_s] = smooth_surface(x, y, OP, 4);
color_s = idl_rainbow(OP_s);
ene_s = medfilt2(ene_s,[10 10]);
surf(x_s,y_s,ene_s, color_s, 'EdgeColor','none', 'FaceColor', 'interp',...
    'FaceAlpha', .7, 'AmbientStrength', .1, 'DiffuseStrength', .1);
view(-32.700, 42.0000);
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

function dataout = linear_resc(datain,minval,maxval)
dataout = datain - min(datain(:));
dataout = (dataout/range(dataout(:)))*(maxval-minval);
dataout = dataout + minval;
end
