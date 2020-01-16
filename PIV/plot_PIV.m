function plot_PIV
main;
set(gcf, 'InvertHardCopy', 'off');
print(gcf, 'autosave.png', '-dpng', '-r300');
print(gcf, 'autosave.eps', '-depsc');
print(gcf, 'autosave.pdf', '-dpdf');
end

function main
imgDir = '40x30fps80od_100p0rk_9vt1500.tif';
newimgDir = 'PIV_sc_3.png';
pivDataDir = 'PIVlab_frame1500.txt';
xlen = 65;
ylen = 65;
rimg = imread(imgDir);
img = imread(newimgDir);

[h, w, d] = size(img);
imshow(img);
colormap(gray)
hold on
[X, Y, U, V] = read_data(pivDataDir, xlen, ylen);
X = X(1:3:xlen, 1:3:ylen);
Y = Y(1:3:xlen, 1:3:ylen);
U = U(1:3:xlen, 1:3:ylen);
V = V(1:3:xlen, 1:3:ylen);
% quiver(X, Y, U, V, 'Color', 'y', 'LineWidth', .9, 'AutoScaleFactor', 1.2,...
%     'MaxHeadSize', .5);
axis tight
axis equal
axis off
rectangle('Position', [234, 517, 100, 100], 'EdgeColor', 'w', 'LineWidth', 1.5);
plot([234+99 w], [517, h-306], 'Color', 'w', 'LineStyle', '--');
plot([234 w-306], [517+99, h], 'Color', 'w', 'LineStyle', '--');
window_pad = 255*ones(307, 307);
imagesc(w-306, h-306, window_pad);
window_ori = rimg(517:517+99, 234:234+99);
window_rsc = imresize(window_ori, 3);
imagesc(w-300, h-300, window_rsc, [min(min(window_rsc)), max(max(window_rsc))]);
end

function [X, Y, U, V] = read_data(filepath, xlen, ylen)
T = readtable(filepath);
X = T.Var1;
Y = T.Var2;
U = T.Var3;
V = T.Var4;
X = reshape(X, xlen, ylen);
Y = reshape(Y, xlen, ylen);
U = reshape(U, xlen, ylen);
V = reshape(V, xlen, ylen);
end

function zoom_window

end