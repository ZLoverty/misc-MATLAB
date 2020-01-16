function color_plot_2D
dataDir = 'F:\Google Drive\Code\MATLAB\Zhengyang\Research\misc\color_plot_2D\testData\op_energy_absolute\'; % Folder directory containing the .dat data files
legendList = {'30 $\mathrm{n_0}$','35 $\mathrm{n_0}$','45 $\mathrm{n_0}$','60 $\mathrm{n_0}$','100 $\mathrm{n_0}$'}% Manually input legends for each curve
num_dataset = 5;
main_test(dataDir, legendList, num_dataset);
ax = gca;
set(gca,'XLim', [0 1], 'YLim', [0 2]);
set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on');
ax.XAxis.MinorTickValues = 0:0.25:1
ax.YAxis.MinorTickValues = 0:0.25:2
xlabel('Order Parameter', 'interpreter', 'latex', 'FontSize', 24);
ylabel(['$E$ $(\times 10^{5}$ $\mathrm{\mu m^2/s^2)}$'], 'interpreter', 'latex', 'FontSize', 24);
end

function main_test(dataDir, legendList, num_dataset)
symbolList = {'o', '^', 's', 'h', 'd', 'p', 'x'};   
colorScheme = 1;
list = dir(dataDir);
count = 0;
h = [];
hold on
for i = 1: numel(list)
    if ~endsWith(list(i).name, '.dat')
        continue;
    end
    count = count + 1;
    dataDir1 = [dataDir list(i).name];
    data = readXYData(dataDir1, 3);
    h_single = color_plot_2D_single(data,symbolList{count}, -1, colorScheme);
    h = [h, h_single];
end
set(gca,...
    'FontSize', 16,...
    'Box', 'on',...
    'LineWidth', 1.5,...
    'XScale', 'linear');


hl = legend(h(1:num_dataset), legendList{1:num_dataset},...
    'Location', 'northwest');
hl.Interpreter = 'latex';
hl.Box = 'off';
timeMapSimpleHSV = [0.7-linspace(0, 0.7, 64); ones(2, 64)]';
timeMapSimple = hsv2rgb(timeMapSimpleHSV);
colormap(timeMapSimple);
c = colorbar;
end


function h1 = color_plot_2D_single(data, Marker, MarkerFaceColor, colorScheme)
% Example (t, OP, E)
% data = readXYData(dataDir, numcol)
% colorScheme = 1;
% color_plot_2D(data, colorScheme);
% Note: colorScheme can only be 1, other schemes will be implemented later.
timeMap = [];
t_original = data(:, 1);
OP = data(:, 2);
E = data(:, 3)*1e-5;
t_total = max(t_original) - min(t_original);
t_resc = (t_original-min(t_original))/(1/0.699)/t_total;
if colorScheme == 1
    cohsv_h = 0.7-t_resc;
    for i = 1: numel(OP)
        cohsv = [cohsv_h(i), 1, 1];
        corgb = hsv2rgb(cohsv);
        h = line(OP(i), E(i), 'MarkerFaceColor', corgb,...
            'MarkerEdgeColor', 0.7*corgb,...
            'LineWidth', 1.3,...
            'LineStyle', 'none',...
            'Marker', Marker, 'MarkerSize', 10);
%         text(OP(i), E(i), num2str(cohsv(1)));
        if MarkerFaceColor ~= -1
            set(h, 'MarkerFaceColor', 'none');
        end
    end
end
h1 = line(-1000, -1000, 'MarkerFaceColor', 'w',...
            'MarkerEdgeColor', 'k',...
            'LineWidth', 1.3,...
            'LineStyle', 'none',...
            'Marker', Marker, 'MarkerSize', 10);
end


function data = readXYData(dataDir, numcol)
fid = fopen(dataDir);
data = fscanf(fid, '%f', [numcol inf]);
data = data';
fclose(fid);
end