function cross_correlation
main_test
end

function main_test
% img = imread('E:\matlab code for particle tracking.tif');
t1 = datetime('now');
mask = imread('maski.tif');
imgstack = 'video.tif'
info = imfinfo(imgstack);
num_images = numel(info);
number_of_particle = 3;
% fig = figure();
% ax = axes(fig);
% saveDir = '13particle\';
% mkdir([pwd '\' saveDir]);
% fid = fopen([saveDir 'xyt.dat'], 'w');
% fprintf(fid, '%-7s\t%-7s\t%-7s\n', 'X', 'Y', 'Frame');
n = 100;
for i = 1: n
    disp(['Processing image ' num2str(i) ' ...']);
    img_ori = imread(imgstack, i);
    img = imcomplement(img_ori);
    [max_coor, pk_value] = track_spheres(img, mask, number_of_particle);    
%     imagesc(img_ori);
%     colormap(gray);
%     hold on
%     plot3(max_coor(1, :), max_coor(2,:), pk_value, 'LineStyle', 'None', 'Marker', 'o',...
%     'MarkerFaceColor', 'None', 'MarkerEdgeColor', 'r', 'MarkerSize', 30, 'LineWidth', 5);
%     hold off
%     axis off
%     pause(.001);
%     F = getframe(ax);
%     Image = frame2im(F);
%     imwrite(Image, [saveDir num2str(i) '.jpg']);
%     for j = 1: number_of_particle
%         fprintf(fid, '%3.3f\t%3.3f\t%3.3f\n', [max_coor(1, j) max_coor(2,j) i])
%     end
end
t2 = datetime('now');
sec_duration = seconds(t2-t1);
disp(['MATLAB processed ' num2str(n) ' images in ' num2str(sec_duration) ' secs']);

end

function [max_coor, pk_value] = track_spheres(img, mask, number_of_particle)
c = normxcorr2(mask, img);
[him, wim] = size(img);
[hma, wma] = size(mask);
ori_r = floor(hma/2);
ori_c = floor(wma/2);
c_crop = c(ori_r: ori_r+him-1, ori_c: ori_c+wim-1);
cent = FastPeakFind(c_crop);
cent2 = reshape(cent, [2, numel(cent)/2]);
peaks = zeros(1, numel(cent)/2);
for i = 1: numel(cent)/2
    row = floor(cent2(2, i));
    col = floor(cent2(1, i));
    a = c_crop(row, col);
    peaks(1, i) = a;
end
[pks, index] = maxk(peaks, number_of_particle);
max_coor = zeros(2, number_of_particle);
pk_value = zeros(1, number_of_particle);
for i = 1: number_of_particle
    max_coor(:, i) = cent2(:, index(i));
    pk_value(1, i) = pks(i);
end
for i = 1: size(max_coor, 2)
    x = max_coor(1,i);
    y = max_coor(2,i);
    fitx_row = x-7:x+7;
    fity_col =y-7:y+7;
    [row, col] = takedate(c_crop,x,y);
    fit1 = fit(fitx_row', row', 'gauss1');
    fit2 = fit(fity_col', col,'gauss1');
    max_coor(1,i)=fit1.b1;
    max_coor(2,i)=fit2.b1;
end
end

function [row, col] = takedate(x_crop,x,y)
row = x_crop(y,x-7:x+7);
col = x_crop(y-7:y+7,x);
end


