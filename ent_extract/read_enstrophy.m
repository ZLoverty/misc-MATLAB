function read_enstrophy
% Put the folder containing *.dat data files (energy, enstrophy and order parameters)
% Note that the *.dat files DO NOT have to be in the root directory of
% dataPath. Instead, it can be in any level subfolder inside dataPath. The
% program will track them down.
% The result is saved as text file outputData

%%%%%%%%%%%% Make your modifications here %%%%
dataPath = 'E:\Peng_scan_data_proj\20181003\';
outputData = [dataPath 'enstrophy_data.dat'];
mean_range = 300; % The number of data points to be averaged
fps = 30; % Frames per sec, x-axis conversion rate
%%%%%%%%%%%% Make your modifications here %%%%

%%%%%%%%% Operation begins, don't change anything below %%%%%%%%%%%%%
fid = fopen(outputData, 'w');
fprintf(fid, '%40s\t%10s\t%10s\t%10s%10s\t%10s\t%10s\n', 'Name', 'plateauE',...
    'E', 'plateauEns', 'Ens', 'plateauOP', 'OP');
list = dirrec(dataPath, 'ent_*');
listOP = dirrec(dataPath, 'frac*');
result = struct();

for i = 1: 10 %numel(list)
    Name = extractName(list{i});
    dataDir = list{i};
    ent_data = read_ent(dataDir);
    [plateauE, E_mean, plateauEns, Ens_mean] = get_plateau(ent_data, mean_range, fps);
    OP_found = 0;
    for j = 1: numel(listOP)
        NameOP = extractName(listOP{j});
        if strcmp(Name, NameOP)
            dataDirOP = listOP{j};
            frac_data = read_frac(dataDirOP);
            [plateauOP, OP_mean] = get_plateau_OP(frac_data, mean_range, fps);
            OP_found = 1;
            break;
        end
    end
    if OP_found == 0
        plateauOP = -1;
        OP_mean = -1;
    end
    fprintf(fid, '%40s\t%10.2f\t%10.2f\t%10.2f\t%10.2f\t%10.2f\t%10.2f\n',...
        Name, plateauE, E_mean, plateauEns, Ens_mean, plateauOP, OP_mean);
end
fclose(fid);
end

function name = extractName(strDir)
ind = find(strDir=='\', 100);
NoD = numel(ind);
ind_start = ind(NoD-2) + 1;
ind_end = ind(NoD) - 1;
name = strDir(ind_start: ind_end);
end

function [plateauOP, OP_mean] = get_plateau_OP(frac_data, range, fps)
t = frac_data(:, 1);
OP = frac_data(:, 2);
figure(3);
plot(t, OP);
title('Order Parameter (click transition point)');
set(gca, 'Position', [0.1 0.1 0.8 0.8], 'Unit', 'Normalized');
input = ginput(1);
plateauOP = input(1);
OP_start = floor(plateauOP*fps);
OP_end = floor(min(numel(OP), plateauOP*fps + range));
OP_mean = mean(OP(OP_start: OP_end));
end

function [plateauE, E_mean, plateauEns, Ens_mean] = get_plateau(ent_data, range, fps)
t = ent_data(:, 1);
E = ent_data(:, 2);
Ens = ent_data(:, 3);
figure(1);
plot(t, E);
title('Energy (click transition point)');
set(gca, 'Position', [0.1 0.1 0.8 0.8], 'Unit', 'Normalized');
input = ginput(1);
plateauE = input(1);
E_start = floor(plateauE*fps);
E_end = floor(min(numel(E), plateauE*fps + range));
E_mean = mean(E(E_start: E_end))
figure(2);
plot(t, Ens);
title('Enstrophy (click transition point)');
set(gca, 'Position', [0.1 0.1 0.8 0.8], 'Unit', 'Normalized');
input = ginput(1);
plateauEns = input(1);
Ens_start = floor(plateauEns*fps);
Ens_end = floor(min(numel(Ens), plateauEns*fps + range));
Ens_mean = mean(Ens(Ens_start: Ens_end));
end

function ent_data = read_ent(dataDir)
fid = fopen(dataDir);
A = fscanf(fid, '%f', [3 inf]);
ent_data = A';
fclose(fid);
end

function frac_data = read_frac(dataDir)
fid = fopen(dataDir);
A = fscanf(fid, '%f', [2 inf]);
frac_data = A';
fclose(fid);
end