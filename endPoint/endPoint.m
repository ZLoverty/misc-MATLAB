function endPoint
tifStackDir = 'R:\Dip\DNA_chain\Substack_test(1-20).tif';
distList = endPointStack(tifStackDir);
info = imfinfo(tifStackDir);
nFrame = numel(info);
frameNo = 1: nFrame;
plot(frameNo, distList);
end

function distList = endPointStack(tifStackDir)
info = imfinfo(tifStackDir);
nFrame = numel(info);
distList = zeros(nFrame, 1);
for i = 1: nFrame    
    single_img = imread(tifStackDir, i);
    dist = endtoend(single_img);
    disp(['frame ' , num2str(i) , ': ' , num2str(dist)]);
    distList(i) = dist;
end
end

function e2edist_temp = endtoend(imageData)
ic = imbinarize(imcomplement(imageData));
out = bwskel(ic);
endimage = bwmorph(out, 'endpoints'); %end points
k = find(endimage);
e2edist_temp = 0;
for i = 1: numel(k)
    for j = i+1: numel(k)
        [row1, col1] = ind2sub(size(imageData), k(i)); %replace 1200 1200 with frame size
        [row2, col2] = ind2sub(size(imageData), k(j));
        e2edist = sqrt((row1-row2)^2 + (col1 - col2)^2);
        if e2edist > e2edist_temp
            e2edist_temp = e2edist;
        end
    end
end
% [row1, col1] = ind2sub(size(imageData), k(1)); %replace 1200 1200 with frame size
% [row2, col2] = ind2sub(size(imageData), k(2));
% 
% e2edist = sqrt((row1-row2)^2 + (col1 - col2)^2);

end