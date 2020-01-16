filepath='';
filen1='phasediagram.dat';
x=linspace(1,35,400);
y=linspace(1,100,400);
numx=numel(x);
numy=numel(y);
[xx,yy]=meshgrid(x,y);
z=zeros(numx,numy);
for i=1:numx
    for j=1:numy
        z(i,j)=303.0/(x(i)*(y(j)-0.0045*y(j)^2));
        if z(i,j)>1.05 || z(i,j)<0
            z(i,j) = NaN;
        end
    end
end
fileID=fopen(filen1,'r');
formatSpec='%f %f %f';
sizeA=[4,Inf];
A=fscanf(fileID,formatSpec, sizeA);
fclose(fileID);
scatter3(A(1,:),A(2,:),A(3,:),'s','filled','k');
hold on; 
xlabel('v [\mum/s]','FontSize',18);
ylabel('n/n_0','FontSize',18);
zlabel('f','FontSize',18)
scatter3(A(1,:),A(2,:),A(4,:),'r','LineWidth',2);
s=surf(xx,yy,z,'FaceAlpha',0.8,'EdgeColor','none');
axis([8.5 35 0 100 0 1.05]);
set(gca, 'XScale', 'log')
% Plot phase boundary for each velocity
hold on
Vs = unique(A(1, :));
for i = 1: numel(Vs)
    [M, I] = min(abs(x - Vs(i)));
    plot3(xx(:, I), yy(:, I), z(:, I), 'Color', 'k', 'LineWidth', 2, 'LineStyle', '-');
end
% Add rectangle frames around datasets corresponding to different velocity
% Using plot3 command
ymin = min(A(2, :));
ymax = max(A(2, :));
zmin = min(min(A(3, :)), min(A(4, :)));
zmax = max(max(A(3, :)), max(A(4, :)));
% Add pad
pad = 0.00;
yminp = ymin - pad * (ymax - ymin);
ymaxp = ymax + pad * (ymax - ymin);
zminp = zmin - pad * (zmax - zmin);
zmaxp = zmax + pad * (zmax - zmin);
% Plot
yminp = 0
ymaxp = 100
zminp = 0
zmaxp = 1.05
for i = 1: numel(Vs)
    plot3([Vs(i) Vs(i)], [yminp ymaxp], [zminp zminp], 'Color', 'k',...
        'LineWidth', 1.5, 'LineStyle', '--');
    plot3([Vs(i) Vs(i)], [yminp ymaxp], [zmaxp zmaxp], 'Color', 'k',...
        'LineWidth', 1.5, 'LineStyle', '--');
    plot3([Vs(i) Vs(i)], [yminp yminp], [zminp zmaxp], 'Color', 'k',...
        'LineWidth', 1.5, 'LineStyle', '--');
    plot3([Vs(i) Vs(i)], [ymaxp ymaxp], [zminp zmaxp], 'Color', 'k',...
        'LineWidth', 1.5, 'LineStyle', '--');
end

